import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:yaml/yaml.dart';

TypeReference builtinType(
  Map<String, Object?> definition, {
  bool nullable = false,
}) {
  final type = definition['type'];
  if (type == 'array') {
    final items = (definition['items']! as Map).cast<String, Object?>();
    return TypeReference(
      (t) => t
        ..symbol = 'List'
        ..types.add(schemaType(items)),
    );
  }

  final name = switch (type) {
    YamlList() => 'Object',
    'object' => 'Object',
    'string' => 'String',
    'number' => 'num',
    'boolean' => 'bool',
    _ => 'Object',
    //throw ArgumentError.value(type, 'type', 'unknown type'),
  };

  return TypeReference(
    (t) => t
      ..symbol = name
      ..isNullable = nullable,
  );
}

TypeReference referenceType(
  Map<String, Object?> definition, {
  bool nullable = false,
}) {
  final type = definition[r'$ref']! as String;
  final name = type.substring(type.lastIndexOf('/') + 1);

  return TypeReference(
    (t) => t
      ..symbol = name
      ..isNullable = nullable
      ..url = '$name.dart',
  );
}

TypeReference schemaType(
  Map<String, Object?> definition, {
  bool nullable = false,
}) => (definition.containsKey(r'$ref') ? referenceType : builtinType)(
  definition,
  nullable: nullable,
);

TypeReference typeReference(String type, {bool nullable = false}) {
  final builder = TypeReferenceBuilder()..isNullable = nullable;

  if (type.startsWith('#/components/schemas/')) {
    final name = type.substring(type.lastIndexOf('/') + 1);

    builder
      ..symbol = name
      ..url = '$name.dart';
  } else {
    builder.symbol = switch (type) {
      'string' => 'String',
      'number' => 'num',
      'boolean' => 'bool',
      _ => throw ArgumentError.value(type, 'type', 'unknown type'),
    };
  }

  return builder.build();
}

Iterable<Field> classFields(
  Map<String, Object?> properties, {
  List<String> required = const <String>[],
}) sync* {
  for (final property in properties.entries) {
    final name = property.key;
    //print('property $property');
    final definition = (property.value! as Map).cast<String, Object?>();
    final nullable =
        !required.contains(name) && !properties.containsKey('default');

    yield Field(
      (f) => f
        ..name = name
        ..modifier = FieldModifier.final$
        ..type = schemaType(definition, nullable: nullable),
    );
  }
}

Library buildClass(
  String name,
  Map<String, Object?> schema,
  Map<String, Object?> schemas,
) {
  final clazz = ClassBuilder()..name = name;

  if (schema.containsKey('allOf')) {
    final allOf = (schema['allOf']! as List).cast<Map>();
    final baseClass = allOf.length == 2;

    for (final definition in allOf) {
      late final Map<String, Object?> properties;

      final ref = definition[r'$ref'];
      if (ref != null) {
        final baseType = referenceType(definition.cast<String, Object?>());

        // \TODO THIS IS WRONG
        properties = const <String, Object?>{};

        if (baseClass) {
          clazz.extend = baseType;
        } else {
          clazz.mixins.add(baseType);
        }
      } else {
        properties = (definition['properties']! as Map).cast<String, Object?>();
      }

      clazz.fields.addAll(classFields(properties));
    }
  } else if (schema.containsKey('oneOf')) {
    final oneOf = (schema['oneOf']! as List).cast<Map>();
    //print('one of us! $oneOf');
  } else if (schema.containsKey('enum')) {
    final values = schema['enum']! as List;
    //print(values);
  } else if (schema['type'] == 'object') {
    final properties = (schema['properties']! as Map).cast<String, Object?>();
    final required =
        (schema['required'] as List?)?.cast<String>() ?? const <String>[];

    clazz.fields.addAll(classFields(properties, required: required));
  } else {
    // This will be a typedef
    //print('typedef $name');
    //throw ArgumentError.value(schema, 'schema', 'unknown schema');
  }

  return Library((l) => l.body.add(clazz.build()));
}

Library buildMixin(
  String name,
  Map<String, Object?> schema,
  Map<String, Object?> schemas,
) {
  final clazz = ClassBuilder()
    ..name = name
    ..abstract = true
    ..mixin = true;

  final required = <String>[];
  final properties = <String, Object?>{};

  if (schema.containsKey('allOf')) {
    final allOf = (schema['allOf']! as List).cast<Map>();

    for (final value in allOf) {
      final definition = value.cast<String, Object?>();
      final ref = definition[r'$ref'] as String?;
      if (ref != null) {
        clazz.implements.add(referenceType(definition));
      } else if (definition['type'] == 'object') {
        final subRequired = definition['required'] as List?;
        if (subRequired != null) {
          required.addAll(subRequired.cast<String>());
        }

        final subProperties = (definition['properties']! as Map)
            .cast<String, Object>();
        properties.addAll(subProperties);
      }
    }
  } else {
    final subRequired = schema['required'] as List?;
    if (subRequired != null) {
      required.addAll(subRequired.cast<String>());
    }

    final subProperties = (schema['properties']! as Map).cast<String, Object>();
    properties.addAll(subProperties);
  }

  for (final property in properties.entries) {
    final name = property.key;
    //print('property $property');
    final definition = (property.value! as Map).cast<String, Object?>();

    final nullable =
        !(required.contains(name) || definition.containsKey('default'));

    final description =
        (definition['description'] as String?)
            ?.split('\n')
            .map((s) => '/// $s') ??
        <String>[];

    clazz.methods.add(
      Method(
        (m) => m
          ..name = name
          ..docs.addAll(description)
          ..type = MethodType.getter
          ..returns = schemaType(definition, nullable: nullable),
      ),
    );
  }

  return Library((l) => l.body.add(clazz.build()));
}
*/

Future<Map<String, Object?>> loadYamlFile(String path) async {
  final file = File(path);
  final contents = await file.readAsString();

  return (loadYaml(contents) as Map).cast<String, Object?>();
}

Future<void> main() async {
  final document = await loadYamlFile('tool/openapi.yaml');
  final components = (document['components'] as Map).cast<String, Object?>();
  final schemas = (components['schemas'] as Map).cast<String, Object?>();

  final traitMatch = RegExp(r'[A-Za-z]+Traits?');

  for (final entry in schemas.entries) {
    final name = entry.key;
    final schema = (entry.value as Map).cast<String, Object?>();

    final construct = traitMatch.hasMatch(name) ? buildMixin : buildClass;
    final library = construct(name, schema, schemas);

    final emitter = DartEmitter(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );
    print(
      DartFormatter(
        languageVersion: DartFormatter.latestLanguageVersion,
      ).format('${library.accept(emitter)}'),
    );
  }
}
