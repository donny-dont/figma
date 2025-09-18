import 'package:change_case/change_case.dart';
import 'package:code_builder/code_builder.dart' as code;
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as p;

import 'annotate.dart' as annotate;
import 'naming.dart';
import 'parse.dart';
import 'reference.dart' as reference;
import 'hierarchy.dart';

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

  final library = code.LibraryBuilder()
    ..body.add(spec)
    ..generatedByComment = comment;

  if (spec is code.Class && !spec.mixin) {
    library.directives.add(code.Directive.part(value.dartPartFile!));
  }

  return library.build();
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

  return code.Class(
    (c) => c
      ..name = dartName
      ..annotations.addAll(<code.Expression>[
        annotate.jsonSerializable(jsonSerializableArguments),
        annotate.copyWith,
        annotate.immutable,
      ])
      ..docs.addAll(value.description.toDocumentation)
      ..abstract = hasDiscriminator
      ..extend = extend
      ..mixins.addAll(value.mixinReferences)
      ..constructors.addAll(<code.Constructor>[
        code.Constructor(
          (c) => c
            ..constant = true
            ..optionalParameters.addAll(<code.Parameter>[
              //...value.superProperties.map(_constructorSuperParameterSpec),
              //...value.mixinProperties.map(_constructorThisParameterSpec),
              //...value.implementedProperties.map(_constructorThisParameterSpec),
              ...value.superFields.map(_constructorSuperParameterSpec),
              ...value.fields.map(_constructorThisParameterSpec),
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
                ? _discriminatorConstructorBody(discriminator)
                : code.refer('_\$${dartName}FromJson').call(<code.Expression>[
                    code.refer('json'),
                  ]).code,
        ),
      ])
      ..fields.addAll(<code.Field>[
        //...value.mixinProperties.map(_fieldMixinPropertySpec),
        ...value.properties.map(_fieldClassPropertySpec),
      ])
      ..methods.addAll(<code.Method>[
        if (hasDiscriminator) _getterPropertySpec(discriminator),
        code.Method(
          (m) => m
            ..returns = reference.props
            ..name = 'props'
            ..annotations.add(annotate.override)
            ..type = code.MethodType.getter
            ..body = code.literalList(<Object>[
              if (extend != reference.equatable)
                code.refer('super').property('props').spread,
              //...value.mixinProperties.map(_propsReference),
              //...value.implementedProperties.map(_propsReference),
              ...value.properties.map(_propsReference),
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
        defaultToCode = _parameterDefault(type, defaultsTo).code;
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

code.Expression _jsonAnnotationDefault(Type type, Object value) =>
    type.isBuiltin
    ? code.literal(value)
    : _jsonAnnotationDefaultValueSchemaToCode(type.definition, value);

code.Expression _jsonAnnotationDefaultValueSchemaToCode(
  TypeDefinition schema,
  Object value,
) => switch (schema) {
  EnumDefinition() => schema.dartValue(value),
  ClassDefinition() => code.literalMap({}),
  _ => throw ArgumentError.value(schema, 'schema', 'unsupported schema'),
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

  final defaultsTo = value.defaultsTo;
  if (defaultsTo != null) {
    arguments['defaultValue'] = _jsonAnnotationDefault(value.type, defaultsTo);
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
    ..methods.addAll(value.properties.map(_getterPropertySpec)),
);

code.Method _getterPropertySpec(PropertyDefinition value) => code.Method(
  (m) => m
    ..name = value.name
    ..docs.addAll(value.description.toDocumentation)
    ..type = code.MethodType.getter
    ..returns = typeSpec(value.type),
);

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
