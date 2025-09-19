import 'package:code_builder/code_builder.dart' as code;
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

import 'annotate.dart' as annotate;
import 'hierarchy.dart';
import 'parse.dart';
import 'reference.dart' as reference;

final RegExp _traitMatch = RegExp(r'[A-Za-z]+Traits?$');

bool isMixin(TypeDefinition definition) =>
    _traitMatch.hasMatch(definition.name);

extension FinalType on Type {
  TypeDefinition get finalDefinition {
    final intermediary = definition;

    return intermediary is TypeAliasDefinition
        ? intermediary.alias.finalDefinition
        : intermediary;
  }
}

extension on String {
  Iterable<String> get toDocumentation {
    final trimmed = trim();

    if (trimmed.isEmpty) {
      return const <String>[];
    }

    return trimmed.split('\n').map((s) => '/// $s');
  }
}

code.Library schemaLibrary(TypeDefinition value, {String? comment}) {
  final spec = schemaSpec(value);
  final directives = <code.Directive>[];

  if (spec is code.Class && !spec.mixin) {
    directives.add(code.Directive.part(value.dartPartFile!));

    if (value is ClassDefinition) {
      final extend = value.extend;

      if (extend != null) {
        // The json_serialization generator can't currently add in types that are
        // used in super classes. Might change with extended parts implementation.
        MapEntry<String, String?> createEntry(PropertyDefinition p) {
          final typeDefinition = p.type.definition;
          return MapEntry<String, String?>(
            typeDefinition.name,
            typeDefinition.dartFile,
          );
        }

        // Get all the types used in the hierarchy
        final superTypes =
            Map<String, String?>.fromEntries(<MapEntry<String, String?>>[
              ...extend.fields.map(createEntry),
              ...extend.discriminators.map(createEntry),
            ]);

        // Remove any types that are already used by the class
        for (final property in value.properties) {
          superTypes.remove(property.type.definition.name);
        }

        final discriminator = value.discriminator;
        if (discriminator != null) {
          superTypes.remove(discriminator.type.definition.name);
        }

        for (final value in superTypes.values) {
          if (value != null) {
            directives.add(code.Directive.import(value));
          }
        }
      }
    }
  }

  return code.Library(
    (l) => l
      ..directives.addAll(directives)
      ..body.add(spec)
      ..generatedByComment = comment,
  );
}

code.Library exportLibrary(String path, List<String> exports) {
  final exportFrom = p.posix.dirname(path);

  code.Directive relative(String export) =>
      code.Directive.export(p.posix.relative(export, from: exportFrom));

  return code.Library((l) => l..directives.addAll(exports.map(relative)));
}

code.Spec schemaSpec(TypeDefinition value) => switch (value) {
  ClassDefinition() => classSpec(value),
  EnumDefinition() => enumSpec(value),
  TypeAliasDefinition() => typeAliasSpec(value),
};

code.Spec classSpec(ClassDefinition value) {
  ClassHierarchy.mixinCheck = isMixin;

  if (value.isMixin) {
    return _mixinSpec(value);
  }

  final dartName = value.name;
  final extend = value.extendReference ?? reference.equatable;

  final jsonSerializableArguments = <String, code.Expression>{};
  final explicitToJson =
      value.properties.firstWhereOrNull((p) => !p.type.isFullyBuiltin) != null;

  if (explicitToJson) {
    jsonSerializableArguments['explicitToJson'] = code.literalTrue;
  }

  final discriminator = value.discriminator;
  final hasDiscriminator = discriminator != null;
  var generateDiscriminatorProperty = hasDiscriminator;

  if (discriminator != null) {
    // See if the discriminator is present on the superclass
    final superDiscriminator = value.extend?.discriminator;
    if (superDiscriminator != null &&
        superDiscriminator.name == discriminator.name) {
      generateDiscriminatorProperty = false;
    }
  }

  final isAbstract = hasDiscriminator;

  if (isAbstract) {
    jsonSerializableArguments['createFactory'] = code.literalFalse;
  }

  final fields = value.fields;

  return code.Class(
    (c) => c
      ..name = dartName
      ..annotations.addAll(<code.Expression>[
        annotate.jsonSerializable(jsonSerializableArguments),
        if (value.fields.isNotEmpty && !isAbstract) annotate.copyWith,
        annotate.immutable,
      ])
      ..docs.addAll(value.description.toDocumentation)
      ..abstract = isAbstract
      ..extend = extend
      ..mixins.addAll(value.mixinReferences)
      ..constructors.addAll(<code.Constructor>[
        code.Constructor(
          (c) => c
            ..constant = true
            ..optionalParameters.addAll(<code.Parameter>[
              ...value.superFields.map(_constructorSuperParameterSpec),
              ...fields.map(_constructorThisParameterSpec),
            ]),
        ),
        code.Constructor(
          (c) => c
            ..factory = true
            ..name = 'fromJson'
            ..requiredParameters.add(
              code.Parameter(
                (p) => p
                  ..type = reference.json
                  ..name = 'json',
              ),
            )
            ..lambda = !hasDiscriminator
            ..body = hasDiscriminator
                ? _discriminatorConstructorBody(discriminator!)
                : code.refer('_\$${dartName}FromJson').call(<code.Expression>[
                    code.refer('json'),
                  ]).code,
        ),
      ])
      ..fields.addAll(<code.Field>[...fields.map(_fieldClassPropertySpec)])
      ..methods.addAll(<code.Method>[
        if (generateDiscriminatorProperty)
          _getterPropertySpec()(discriminator!),
        ...value.getters.map(
          _getterPropertySpec(
            annotateWith: [
              if (extend != reference.equatable) annotate.override,
            ],
            addJsonKey: true,
          ),
        ),
        code.Method(
          (m) => m
            ..returns = reference.props
            ..name = 'props'
            ..annotations.add(annotate.override)
            ..type = code.MethodType.getter
            ..body = code.literalList(<Object>[
              if (extend != reference.equatable)
                code.refer('super').property('props').spread,
              ...value.props.map(_propsReference),
            ], reference.objectNullable).code,
        ),
        code.Method(
          (m) => m
            ..returns = reference.json
            ..name = 'toJson'
            ..annotations.addAll(<code.Expression>[
              if (extend != reference.equatable) annotate.override,
            ])
            ..body = code.refer('_\$${dartName}ToJson').call(<code.Expression>[
              code.refer('this'),
            ]).code,
        ),
      ]),
  );
}

code.Reference _propsReference(PropertyDefinition value) => value.refer;

typedef _ClassConstructorMapper = code.Parameter Function(PropertyDefinition);

final _ClassConstructorMapper _constructorThisParameterSpec =
    _constructorParameterSpec(toSuper: false);

final _ClassConstructorMapper _constructorSuperParameterSpec =
    _constructorParameterSpec(toSuper: true);

_ClassConstructorMapper _constructorParameterSpec({required bool toSuper}) =>
    (value) {
      final defaultsTo = value.defaultsTo;
      final type = value.type;

      late final code.Code? defaultToCode;
      late final bool required;

      if (defaultsTo != null) {
        defaultToCode = !toSuper
            ? _parameterDefault(type, defaultsTo).code
            : null;
        required = false;
      } else {
        defaultToCode = null;
        required = !type.isNullable;
      }

      return code.Parameter(
        (p) => p
          ..name = value.name
          ..named = true
          ..required = required
          ..toSuper = toSuper
          ..toThis = !toSuper
          ..defaultTo = defaultToCode,
      );
    };

code.Expression _parameterDefault(Type type, Object value) => type.isBuiltin
    ? _parameterDefaultLiteralToCode(value)
    : _parameterDefaultValueSchemaToCode(type.definition, value);

code.Expression _parameterDefaultLiteralToCode(Object value) => switch (value) {
  List() => code.literalConstList(value),
  Map() => code.literalConstMap(value),
  _ => code.literal(value),
};

code.Expression _parameterDefaultValueSchemaToCode(
  TypeDefinition schema,
  Object value,
) => switch (schema) {
  EnumDefinition() => schema.dartValue(value),
  ClassDefinition() => schema.refer.constInstance(<code.Expression>[]),
  _ => throw ArgumentError.value(schema, 'schema', 'unsupported schema'),
};

typedef _ClassFieldMapper = code.Field Function(PropertyDefinition);

final _ClassFieldMapper _fieldClassPropertySpec = _fieldPropertySpec();

final _ClassFieldMapper _fieldMixinPropertySpec = _fieldPropertySpec(
  annotateWith: <code.Expression>[annotate.override],
);

_ClassFieldMapper _fieldPropertySpec({
  List<code.Expression> annotateWith = const <code.Expression>[],
}) => (value) {
  final name = value.name;
  final serializedName = value.serializedName;

  final arguments = <String, code.Expression>{};

  if (name != serializedName) {
    arguments['name'] = code.literalString(serializedName);
  }

  final type = value.type;
  final defaultsTo = value.defaultsTo;
  if (defaultsTo != null) {
    if (type.isBuiltin) {
      arguments['defaultValue'] = code.literal(defaultsTo);
    } else {
      final typeDefinition = type.definition;
      if (typeDefinition is EnumDefinition) {
        arguments['defaultValue'] = typeDefinition.dartValue(defaultsTo);
      }
    }
  }

  if (type.isNullable && !value.isRequired) {
    arguments['includeIfNull'] = code.literalFalse;
  }

  final docs = !annotateWith.contains(annotate.override)
      ? value.description.toDocumentation
      : <String>[];

  return code.Field(
    (f) => f
      ..name = name
      ..annotations.addAll(<code.Expression>[
        if (arguments.isNotEmpty) annotate.jsonKey(arguments),
        ...annotateWith,
      ])
      ..modifier = code.FieldModifier.final$
      ..type = typeSpec(value.type)
      ..docs.addAll(docs),
  );
};

code.Class _mixinSpec(ClassDefinition value) => code.Class(
  (c) => c
    ..name = value.name
    ..docs.addAll(value.description.toDocumentation)
    ..abstract = true
    ..mixin = true
    ..implements.addAll(value.implements.map(reference.type))
    ..methods.addAll(value.properties.map(_getterPropertySpec())),
);

typedef _ClassGetterMapper = code.Method Function(PropertyDefinition);

_ClassGetterMapper _getterPropertySpec({
  List<code.Expression> annotateWith = const <code.Expression>[],
  bool addJsonKey = false,
}) => (value) {
  final name = value.name;

  final arguments = <String, code.Expression>{};

  if (addJsonKey) {
    arguments['includeToJson'] = code.literalTrue;

    final serializedName = value.serializedName;
    if (name != serializedName) {
      arguments['name'] = code.literalString(serializedName);
    }
  }

  return code.Method(
    (m) => m
      ..name = name
      ..annotations.addAll(<code.Expression>[
        if (arguments.isNotEmpty) annotate.jsonKey(arguments),
        ...annotateWith,
      ])
      ..docs.addAll(value.description.toDocumentation)
      ..type = code.MethodType.getter
      ..body = value.singleValue
          ? _parameterDefault(value.type, value.defaultsTo!).code
          : null
      ..returns = typeSpec(value.type),
  );
};

code.Spec enumSpec(EnumDefinition value) => code.Enum(
  (e) => e
    ..name = value.name
    ..docs.addAll(value.description.toDocumentation)
    ..values.addAll(value.values.map(_enumValue)),
);

code.EnumValue _enumValue(EnumValueDefinition value) => code.EnumValue(
  (v) => v
    ..name = value.name
    ..annotations.add(annotate.jsonValue(value.value)),
);

code.Spec typeAliasSpec(TypeAliasDefinition value) => code.TypeDef(
  (t) => t
    ..name = value.name
    ..docs.addAll(value.description.toDocumentation)
    ..definition = value.alias.definition.refer,
);

code.Code _discriminatorConstructorBody(DiscriminatorDefinition property) {
  final mapping = Map<String, Type>.from(property.mapping);
  final caseStatements = <code.Code>[];

  while (mapping.isNotEmpty) {
    final key = mapping.keys.first;
    final mapToType = mapping.remove(key)!;

    final typeMappings = <String>[
      key,
      ...mapping.entries
          .where((e) => e.value.name == mapToType.name)
          .map((e) => e.key),
    ];

    for (final remove in typeMappings) {
      mapping.remove(remove);
    }

    caseStatements.addAll(<code.Code>[
      if (key != '_')
        code.Code(typeMappings.map((v) => "'$v'").join(' || '))
      else
        code.Code('_'),
      code.Code('=>'),
      mapToType.definition.refer.property('fromJson').code,
      code.Code(','),
    ]);
  }

  final propertySerializedName = property.serializedName;

  if (!property.mapping.containsKey('_')) {
    caseStatements.add(
      code.Code(
        '_ => throw ArgumentError.value(discriminator,'
        "'$propertySerializedName',"
        "'unknown $propertySerializedName'),",
      ),
    );
  }

  return code.Block.of(<code.Code>[
    code.Code("final discriminator = json['$propertySerializedName'];"),
    code.Code('final construct = switch (discriminator) {'),
    ...caseStatements,
    code.Code('};\n\n'),
    code.Code('return construct(json);'),
  ]);
}

code.TypeReference typeSpec(Type value) {
  late final String? url;
  final typeArguments = <code.Reference>[];

  final definition = value.definition;

  if (value.isBuiltin) {
    if (value.isList) {
      typeArguments.add(typeSpecNullable(value.typeArgument));
    } else if (value.isMap) {
      typeArguments.addAll(<code.Reference>[
        reference.string,
        typeSpecNullable(value.typeArgument),
      ]);
    }
    url = null;
  } else {
    url = definition.dartFile;
  }

  return code.TypeReference(
    (t) => t
      ..symbol = value.name
      ..isNullable = value.isNullable
      ..url = url
      ..types.addAll(typeArguments),
  );
}

code.TypeReference typeSpecNullable(Type? value) =>
    value != null ? typeSpec(value) : reference.objectNullable;
