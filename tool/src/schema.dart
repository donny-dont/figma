import 'package:change_case/change_case.dart';

typedef Definition = Map<String, Object?>;

final RegExp nodeMatch = RegExp(r'[A-Za-z]+Node?');
final RegExp traitMatch = RegExp(r'[A-Za-z]+Traits?');

bool isMixin(String name) => traitMatch.hasMatch(name);

class Schemas {
  final Map<String, Schema> _schemas = <String, Schema>{};

  Iterable<Schema> get schemas => _schemas.values;

  void add(String name, Definition definition) {
    late final Schema schema;

    if (isMixin(name)) {
      schema = _addMixin(name, definition);
    } else if (definition.isOneOf) {
      schema = _addUnion(name, definition);
    } else if (definition.isEnum) {
      schema = _addEnum(name, definition);
      print('${schema.name} ${schema.metadata}');
    } else {
      schema = _addClass(name, definition);
    }

    _schemas[name] = schema;
  }

  T get<T extends Schema>(String name) => _schemas[name]! as T;

  Union _addUnion(String name, Definition definition) {
    final oneOf = definition.oneOf;
    final types = <String>[];

    for (final value in oneOf) {
      if (value.isReference) {
        types.add(value.referenceName);
      } else {
        print(name);
        //throw ArgumentError.value(value, 'value', 'no know what to do');
      }
    }

    final Map<String, String> mapping = <String, String>{};
    var property = '';

    if (definition.hasDiscriminator) {
      final discriminator = definition.discriminator;
      print(discriminator);

      property = discriminator['propertyName']! as String;
      final discriminatorMapping = (discriminator['mapping']! as Map)
          .cast<String, String>();

      for (final entry in discriminatorMapping.entries) {
        mapping[entry.key] = entry.value.referenceName;
      }
    }

    return Union(
      root: this,
      name: name,
      metadata: definition.metadata,
      types: types,
      property: property,
      mapping: mapping,
    );
  }

  Enum _addEnum(String name, Definition definition) => Enum(
    root: this,
    name: name,
    metadata: definition.metadata,
    values: definition.enumerations,
  );

  Class _addClass(String name, Definition definition) {
    final implements = <String>[];
    final mixins = <String>[];
    final properties = <Property>[];

    final definitions = definition.isAllOf
        ? definition.allOf
        : <Definition>[definition];

    for (final value in definitions) {
      if (value.isReference) {
        final reference = value.referenceName;

        if (isMixin(reference)) {
          mixins.add(reference);
        }
      } else if (value.isObject) {
        properties.addAll(_addProperties(value));
      }
    }

    return Class(
      root: this,
      name: name,
      metadata: definition.metadata,
      mixin: false,
      implements: implements,
      mixins: mixins,
      properties: properties,
    );
  }

  Class _addMixin(String name, Definition definition) {
    final implements = <String>[];
    final properties = <Property>[];

    final definitions = definition.isAllOf
        ? definition.allOf
        : <Definition>[definition];

    for (final value in definitions) {
      if (value.isReference) {
        implements.add(value.referenceName);
      } else if (value.isObject) {
        properties.addAll(_addProperties(value));
      }
    }

    return Class(
      root: this,
      name: name,
      metadata: definition.metadata,
      mixin: true,
      implements: implements,
      properties: properties,
    );
  }

  Iterable<Property> _addProperties(Definition object) sync* {
    final required = object.required;

    for (final property in object.properties.entries) {
      final name = property.key;
      final definition = (property.value as Map).cast<String, Object>();

      yield _addProperty(name, definition, required: required.contains(name));
    }
  }

  Property _addProperty(
    String name,
    Definition definition, {
    bool required = false,
  }) {
    final type = _addType(name, definition);

    var defaultsTo = definition['default'];
    if (!required) {
      if (type.name == 'array') {
        defaultsTo = [];
      } else if (type.name == 'object') {
        defaultsTo = {};
      }
    }

    return Property(
      name: name,
      type: type,
      metadata: definition.metadata,
      required: required,
      defaultsTo: defaultsTo,
    );
  }

  Type _addType(String name, Definition definition) {
    if (definition.isReference) {
      return Type(name: definition.referenceName);
    }

    final definitionType = definition['type'];

    if (definitionType is List) {
      return Type(name: definitionType[0], isNullable: true);
    }

    if (definitionType is String) {
      if (definitionType == 'object') {
        // Look to see if another object is defined
        if (definition.hasProperties) {
          final schemaName = definition.hasDartName
              ? definition.dartName
              : name.toPascalCase();

          add(schemaName, definition);

          return Type(name: schemaName);
        } else {
          return Type(
            name: definitionType,
            typeArgument: definition.hasAdditionalProperties
                ? _addType(name, definition.additionalProperties)
                : null,
          );
        }
      } else if (definitionType == 'array') {
        return Type(
          name: definitionType,
          typeArgument: definition.hasItems
              ? _addType(name, definition.items)
              : null,
        );
      } else if (definition.isEnum) {
        final schemaName = definition.hasDartName
            ? definition.dartName
            : name.toPascalCase();

        add(schemaName, definition);

        return Type(name: schemaName);
      } else {
        return Type(name: definitionType);
      }
    }

    if (definition.isOneOf) {
      if (definition.hasDartName) {
        return Type(name: definition.dartName);
      }

      return Type(
        name: 'any',
        isNullable: definition.oneOf.any((v) => v.containsValue('null')),
      );
    }

    return Type(name: 'any', isNullable: true);
  }
}

typedef Metadata = Map<String, Object?>;

abstract class Annotated {
  Metadata get metadata;
}

sealed class Schema implements Annotated {
  const Schema({
    required this.root,
    required this.name,
    required this.metadata,
  });

  final Schemas root;
  final String name;

  @override
  final Metadata metadata;
}

final class Class extends Schema {
  const Class({
    required super.root,
    required super.name,
    super.metadata = const {},
    this.mixin = false,
    this.extend = '',
    this.implements = const <String>[],
    this.mixins = const <String>[],
    this.properties = const <Property>[],
  });

  final bool mixin;

  final String extend;

  final List<String> implements;

  final List<String> mixins;

  final List<Property> properties;

  Iterable<Property> get superProperties sync* {
    if (extend.isNotEmpty) {
      final extending = root.get<Class>(extend);
      yield* extending.implementedProperties;
    }
  }

  Iterable<Property> get implementedProperties sync* {
    for (final name in implements) {
      final implementing = root.get<Class>(name);
      yield* implementing.implementedProperties;
    }

    yield* properties;
  }

  Iterable<Property> get mixinProperties sync* {
    if (mixin) {
      yield* implementedProperties;
    } else {
      for (final name in mixins) {
        final mixin = root.get<Class>(name);
        yield* mixin.mixinProperties;
      }
    }
  }

  Iterable<Property> get allProperties sync* {
    yield* implementedProperties;
    yield* properties;
  }
}

final class Union extends Schema {
  Union({
    required super.root,
    required super.name,
    super.metadata = const {},
    this.types = const <String>[],
    this.property = '',
    this.mapping = const <String, String>{},
  });

  final List<String> types;

  final String property;
  final Map<String, String> mapping;
}

final class Enum extends Schema {
  const Enum({
    required super.root,
    required super.name,
    super.metadata = const {},
    required this.values,
  });

  final List<Object> values;
}

class Property implements Annotated {
  const Property({
    required this.name,
    required this.type,
    required this.required,
    this.metadata = const {},
    this.description = '',
    this.defaultsTo,
  });

  final String name;

  @override
  final Metadata metadata;

  final Type type;

  final bool required;

  final String description;

  final Object? defaultsTo;
}

class Type {
  const Type({required this.name, this.isNullable = false, this.typeArgument});

  final String name;

  final bool isNullable;

  final Type? typeArgument;
}

extension on String {
  String get referenceName => substring(lastIndexOf('/') + 1);
}

extension on Definition {
  bool get isReference => containsKey(r'$ref');

  String get reference => this[r'$ref']! as String;

  String get referenceName => reference.referenceName;

  bool get isObject => this['type'] == 'object';

  bool get isAllOf => containsKey('allOf');

  List<Definition> get allOf => _listOfDefinitions('allOf');

  bool get isOneOf => containsKey('oneOf');

  List<Definition> get oneOf => _listOfDefinitions('oneOf');

  bool get hasDiscriminator => containsKey('discriminator');

  Definition get discriminator => _mapOf('discriminator');

  bool get isEnum => containsKey('enum');

  List<Object> get enumerations => _listOf<Object>('enum');

  List<String> get required => _listOf<String>('required');

  bool get hasProperties => containsKey('properties');

  Definition get properties => _mapOf('properties');

  bool get hasAdditionalProperties => containsKey('additionalProperties');

  Definition get additionalProperties => _mapOf('additionalProperties');

  bool get hasItems => containsKey('items');

  Definition get items => _mapOf('items');

  bool get hasDartName => containsKey('x-dart-name');

  String get dartName => this['x-dart-name']! as String;

  Definition get metadata => Map<String, Object?>.fromEntries(
    entries.where((e) => e.key.startsWith('x-')),
  );

  List<T> _listOf<T>(String property) {
    final value = this[property] as List?;
    if (value == null) {
      return const [];
    }

    return value.cast<T>();
  }

  List<Definition> _listOfDefinitions(String property) {
    final value = this[property] as List?;
    if (value == null) {
      return const [];
    }

    return value.map((m) => (m as Map).cast<String, Object?>()).toList();
  }

  Definition _mapOf(String property) {
    final value = this[property] as Map?;
    if (value == null) {
      return const <String, Object?>{};
    }

    return value.cast<String, Object?>();
  }
}
