import 'package:change_case/change_case.dart';
import 'package:logging/logging.dart';

import 'json_map.dart';
import 'schema.dart';
import 'schema_extensions.dart';

final Logger _logger = Logger('preprocess');

void addDiscriminator(String name, JsonMap definitions) {
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
  final discriminatorType =
      discriminator.discriminatorType ??
      '${name.toPascalCase()}${propertyName.toPascalCase()}';

  for (final value in definition.oneOf) {
    late JsonMap valueDefinition;

    if (value.isReference) {
      final referenceName = value.referenceName;
      _logger.fine('modifying $referenceName definition of $propertyName');
      valueDefinition = definitions.getJson(referenceName);
    } else {
      _logger.fine('modifying instance of inline type');
      valueDefinition = value;
    }

    if (valueDefinition.isAllOf) {
      for (final allOfDefinition in valueDefinition.allOf) {
        if (allOfDefinition.hasProperties) {
          valueDefinition = allOfDefinition;
          break;
        }
      }
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
  final schemas = document.componentSchemas;

  for (final entry in schemas.entries) {
    final name = entry.key;
    final definition = (entry.value as Map).cast<String, Object?>();

    if (definition.hasDiscriminator) {
      addDiscriminator(name, schemas);
    }
  }
}

void addTypeOverrides(JsonMap document, {String property = 'type'}) {
  final schemas = document.componentSchemas;
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

const _discriminatorTypes = <String, String>{
  'ShadowEffect': 'BaseShadowEffect',
  'BlurEffect': 'BaseBlurEffect',
};

void addDiscriminatorTypes(
  JsonMap document, {
  Map<String, String> mappings = _discriminatorTypes,
}) {
  final schemas = document.componentSchemas;

  for (final entry in mappings.entries) {
    final oneOfName = entry.key;

    final implementingName = entry.value;
    final implementing = schemas.remove(implementingName) as Map;

    schemas[implementingName] = <String, Object?>{
      r'$ref': '#/components/schemas/$oneOfName',
    };

    schemas.getJson(oneOfName).dartObject = implementing.cast<String, Object>();
  }
}

const _defaultResponseTypes = <String>[
  'GetLocalVariablesResponse',
  'GetPublishedVariablesResponse',
  'GetFileMetaResponse',
  'GetFileStylesResponse',
  'GetTeamProjectsResponse',
  'GetProjectFilesResponse',
  'GetFileVersionsResponse',
  'GetTeamComponentsResponse',
];

void addResponses(
  JsonMap document, {
  List<String> responseTypes = _defaultResponseTypes,
}) {
  final schemas = document.componentSchemas;
  final responses = document.componentResponses;

  for (final responseType in responseTypes) {
    final response = responses.getJson(responseType);

    schemas[responseType] = response.responseSchema;
  }
}

const List<String> _defaultRequestEndpoints = <String>[
  '/v2/webhooks',
  '/v2/webhooks/{webhook_id}',
  '/v1/files/{file_key}/comments',
];

void addRequests(
  JsonMap document, {
  List<String> endpoints = _defaultRequestEndpoints,
}) {
  final schemas = document.componentSchemas;
  final paths = document.paths;
  print('adding request');

  for (final endpoint in endpoints) {
    final path = paths.path(endpoint);

    if (path.hasPost) {
      final post = path.post;
      final name = post.operationId.toPascalCase();
      print('adding $name to schemas');

      schemas[name] = post.requestBodySchema;
    }

    if (path.hasPut) {
      final put = path.put;
      final name = put.operationId.toPascalCase();
      print('adding $name to schemas');

      schemas[name] = put.requestBodySchema;
    }
  }
}
