import 'package:change_case/change_case.dart';
import 'package:logging/logging.dart';

import 'json_map.dart';
import 'schema.dart';
import 'schema_extensions.dart';

final Logger _logger = Logger('preprocess');

void addDiscriminator(
  String name,
  JsonMap definitions, {
  String? discriminatorType,
}) {
  final definition = definitions.getMap<String, Object?>(name);
  final discriminator = definition.discriminator;

  if (discriminator.isEmpty) {
    throw ArgumentError.value(
      name,
      'name',
      'definition does not have a discriminator',
    );
  }

  final propertyName = discriminator.property;
  discriminatorType ??= '${name.toPascalCase()}${propertyName.toPascalCase()}';

  for (final value in definition.oneOf) {
    late final JsonMap valueDefinition;

    if (value.isReference) {
      final referenceName = value.referenceName;
      _logger.fine('modifying $referenceName definition of $propertyName');
      valueDefinition = definitions.getMap<String, Object?>(referenceName);
    } else {
      _logger.fine('modifying instance of inline type');
      valueDefinition = value;
    }

    final properties = valueDefinition.properties;
    final property = properties.getMap<String, Object?>(propertyName);

    if (property.isEmpty) {
      _logger.warning('unable to find $propertyName on definition');
      continue;
    }

    property.discriminatorType = discriminatorType;
  }
}

void addDiscriminators(JsonMap document) {
  final schemas = document.getJsonFromPath(<String>['components', 'schemas']);

  for (final entry in schemas.entries) {
    final name = entry.key;
    final definition = (entry.value as Map).cast<String, Object?>();

    if (definition.hasDiscriminator) {
      addDiscriminator(name, schemas);
    }
  }
}

void addTypeOverrides(JsonMap document, {String property = 'type'}) {
  final schemas = document.getJsonFromPath(<String>['components', 'schemas']);
  final propertyDartName = property.toPascalCase();

  for (final entry in schemas.entries) {
    final name = entry.key;
    final definition = (entry.value as Map).cast<String, Object?>();

    if (definition.hasProperties) {
      final properties = definition.properties;
      final propertyDefinition = properties.getMap<String, Object?>(property);

      if (propertyDefinition.isNotEmpty) {
        if (propertyDefinition.isEnumeration &&
            !propertyDefinition.hasTypeOverride) {
          propertyDefinition.typeOverride =
              '${name.toPascalCase()}$propertyDartName';
        }
      }
    }
  }
}

const _defaultResponseTypes = <String>[
  'GetLocalVariablesResponse',
  'GetPublishedVariablesResponse',
];

void addResponses(
  JsonMap document, {
  List<String> responseTypes = _defaultResponseTypes,
}) {
  final schemas = document.getJsonFromPath(<String>['components', 'schemas']);
  final responses = document.getJsonFromPath(<String>[
    'components',
    'responses',
  ]);

  for (final responseType in responseTypes) {
    //final description = responseType.description;
    final definition = responses.getJsonFromPath(<String>[responseType]);
    final schema = definition.getJsonFromPath(<String>[
      'content',
      'application/json',
      'schema',
    ]);

    schemas[responseType] = schema;
  }
}
