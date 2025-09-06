import 'package:change_case/change_case.dart';
import 'package:code_builder/code_builder.dart' as code;

import 'annotate.dart' as annotate;
import 'naming.dart';
import 'reference.dart' as reference;
import 'schema.dart';

extension on String {
  Iterable<String> get toDocumentation {
    final trimmed = trim();

    if (trimmed.isEmpty) {
      return const <String>[];
    }

    return trimmed.split('\n').map((s) => '/// $s');
  }
}

code.Library schemaLibrary(Schema value, {String? comment}) {
  final spec = schemaSpec(value);

  final library = code.LibraryBuilder()
    ..body.add(spec)
    ..generatedByComment = comment;

  if (spec is code.Class && !spec.mixin) {
    library.directives.add(
      code.Directive.part('${spec.name.toSnakeCase()}.g.dart'),
    );
  }

  return library.build();
}

code.Spec schemaSpec(Schema value) => switch (value) {
  Class() => classSpec(value),
  Enum() => enumSpec(value),
  Union() => unionSpec(value),
};

code.Spec classSpec(Class value) =>
    (value.mixin ? _mixinSpec : _classSpec)(value);

code.Class _classSpec(Class value) {
  final name = value.name;
  final extending = reference.equatable;

  return code.Class(
    (c) => c
      ..name = name
      ..annotations.addAll(<code.Expression>[
        annotate.jsonSerializable,
        annotate.copyWith,
        annotate.immutable,
      ])
      ..extend = extending
      ..mixins.addAll(
        value.mixins.map((n) => code.refer(n, '${n.toSnakeCase()}.dart')),
      )
      ..constructors.addAll(<code.Constructor>[
        code.Constructor(
          (c) => c
            ..constant = true
            ..optionalParameters.addAll(<code.Parameter>[
              ...value.superProperties.map(_constructorSuperParameterSpec),
              ...value.mixinProperties.map(_constructorThisParameterSpec),
              ...value.implementedProperties.map(_constructorThisParameterSpec),
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
            ..body = code.refer('_\$${name}FromJson').call(<code.Expression>[
              code.refer('json'),
            ]).code,
        ),
      ])
      ..fields.addAll(<code.Field>[
        ...value.mixinProperties.map(_fieldMixinPropertySpec),
        ...value.properties.map(_fieldClassPropertySpec),
      ])
      ..methods.addAll(<code.Method>[
        code.Method(
          (m) => m
            ..returns = reference.props
            ..name = 'props'
            ..annotations.add(annotate.override)
            ..type = code.MethodType.getter
            ..body = code.literalList(<Object>[
              //if (extending != reference.equatable)
              //  code.refer('super').call(<code.Expression>[
              //    code.refer('props'),
              //  ]).spread,
              ...value.properties.map((p) => code.refer(p.name.toCamelCase())),
            ], reference.objectNullable).code,
        ),
        code.Method(
          (m) => m
            ..returns = reference.json
            ..name = 'toJson'
            ..annotations.addAll(<code.Expression>[
              //if (extending != reference.equatable) annotations.override,
            ])
            ..body = code.refer('_\$${name}ToJson').call(<code.Expression>[
              code.refer('this'),
            ]).code,
        ),
      ]),
  );
}

typedef _ClassConstructorMapper = code.Parameter Function(Property);

final _ClassConstructorMapper _constructorThisParameterSpec =
    _constructorParameterSpec(toSuper: false);

final _ClassConstructorMapper _constructorSuperParameterSpec =
    _constructorParameterSpec(toSuper: true);

_ClassConstructorMapper _constructorParameterSpec({required bool toSuper}) =>
    (value) {
      final defaultTo = value.defaultsTo;
      final required = defaultTo == null && value.required;

      return code.Parameter(
        (p) => p
          ..name = value.name.toCamelCase()
          ..named = true
          ..required = required
          ..toSuper = toSuper
          ..toThis = !toSuper
          ..defaultTo = defaultTo != null
              ? _constructorParameterDefaultToCode(defaultTo)
              : null,
      );
    };

code.Code _constructorParameterDefaultToCode(Object value) {
  final expression = switch (value) {
    List() => code.literalConstList(value),
    Map() => code.literalConstMap(value),
    _ => code.literal(value),
  };

  return expression.code;
}

typedef _ClassFieldMapper = code.Field Function(Property);

final _ClassFieldMapper _fieldClassPropertySpec = _fieldPropertySpec();

final _ClassFieldMapper _fieldMixinPropertySpec = _fieldPropertySpec(
  annotateWith: <code.Expression>[annotate.override],
);

_ClassFieldMapper _fieldPropertySpec({
  List<code.Expression> annotateWith = const <code.Expression>[],
}) => (value) {
  final name = value.name;
  final dartName = name.toCamelCase();

  final arguments = <String, code.Expression>{};

  if (dartName != name) {
    arguments['name'] = code.literalString(name);
  }

  final defaultsTo = value.defaultsTo;
  if (defaultsTo != null) {
    arguments['defaultValue'] = code.literal(defaultsTo);
  }

  var type = typeSpec(value.type);
  if (!value.required && value.defaultsTo == null) {
    type = type.rebuild((t) => t.isNullable = true);
  }

  return code.Field(
    (f) => f
      ..name = dartName
      ..annotations.addAll(<code.Expression>[
        if (arguments.isNotEmpty) annotate.jsonKey(arguments),
        ...annotateWith,
      ])
      ..modifier = code.FieldModifier.final$
      ..type = type
      ..docs.addAll(value.description.toDocumentation),
  );
};

code.Class _mixinSpec(Class value) => code.Class(
  (c) => c
    ..name = value.name
    ..abstract = true
    ..mixin = true
    ..implements.addAll(value.implements.map(reference.model))
    ..methods.addAll(value.properties.map(_getterPropertySpec)),
);

code.Method _getterPropertySpec(Property value) {
  var type = typeSpec(value.type);
  if (!value.required && value.defaultsTo == null) {
    type = type.rebuild((t) => t.isNullable = true);
  }

  return code.Method(
    (m) => m
      ..name = value.name.toCamelCase()
      ..type = code.MethodType.getter
      ..returns = type
      ..docs.addAll(value.description.toDocumentation),
  );
}

code.Spec enumSpec(Enum value) {
  print(value.name);
  print(value.values.runtimeType);
  print(value.values[0].runtimeType);
  print(value.dartValues);
  //print(value.values);
  print(value.name);

  return code.Enum(
    (e) => e
      ..name = value.name
      ..values.addAll(value.dartValues.map(_enumValue)),
  );
}

code.EnumValue _enumValue(MapEntry<Object, String> entry) => code.EnumValue(
  (v) => v
    ..name = entry.value
    ..annotations.add(annotate.jsonValue(entry.key)),
);

code.Spec unionSpec(Union value) => code.Class((c) => c..name = value.name);

code.TypeReference typeSpec(Type value) {
  final name = value.name;

  late final String dartName;
  final typeArguments = <code.Reference>[];
  String? url;

  if (name == 'boolean') {
    dartName = 'bool';
  } else if (name == 'string') {
    dartName = 'String';
  } else if (name == 'number') {
    dartName = 'num';
  } else if (name == 'any') {
    dartName = 'Object';
  } else if (name == 'array') {
    dartName = 'List';
    typeArguments.add(typeSpecNullable(value.typeArgument));
  } else if (name == 'object') {
    dartName = 'Map';
    typeArguments.addAll(<code.Reference>[
      reference.string,
      typeSpecNullable(value.typeArgument),
    ]);
  } else {
    dartName = name;
    url = '${name.toSnakeCase()}.dart';
  }

  return code.TypeReference(
    (t) => t
      ..symbol = dartName
      ..isNullable = value.isNullable
      ..url = url
      ..types.addAll(typeArguments),
  );
}

code.TypeReference typeSpecNullable(Type? value) =>
    value != null ? typeSpec(value) : reference.objectNullable;
