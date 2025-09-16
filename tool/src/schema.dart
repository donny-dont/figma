import 'json_map.dart';

extension ReferenceSchema on JsonMap {
  static const String _ref = r'$ref';

  /// Whether the value is a reference.
  bool get isReference => containsKey(_ref);

  /// The full reference to the type.
  String get reference => this[_ref]! as String;

  /// The name of the referenced type.
  String get referenceName => reference.referenceName;
}

extension TypeSchema on JsonMap {
  static const String _type = 'type';
  static const String _any = 'any';

  /// The type of the definition.
  String get type => this[_type] as String? ?? _any;
}

extension ObjectSchema on JsonMap {
  static const String _object = 'object';
  static const String _properties = 'properties';
  static const String _required = 'required';
  static const String _additionalProperties = 'additionalProperties';

  /// Whether the type definition is an object.
  bool get isObject => type == _object;

  /// Whether the type has properties.
  bool get hasProperties => containsKey(_properties);

  /// The properties on the object.
  ///
  /// Check [hasProperties] first before accessing.
  JsonMap get properties => getMap<String, Object?>(_properties);

  /// The required properties for the object.
  ///
  /// Check [hasProperties] first before accessing.
  List<String> get required => getList<String>(_required);

  /// Whether the object contains additional properties.
  ///
  /// This is used to create a Map structure.
  bool get hasAdditionalProperties => containsKey(_additionalProperties);

  /// Additional properties for the object.
  ///
  /// The value type for the map.
  JsonMap get additionalProperties => this[_additionalProperties] is Map
      ? getMap<String, Object?>(_additionalProperties)
      : const <String, Object?>{};
}

extension AllOfSchema on JsonMap {
  static const String _allOf = 'allOf';

  /// Whether the type is `allOf`.
  bool get isAllOf => containsKey(_allOf);

  /// Retrieves the value of `allOf`.
  ///
  /// Check [isAllOf] first before accessing.
  List<JsonMap> get allOf => getJsonList(_allOf);
}

extension OneOfSchema on JsonMap {
  static const String _oneOf = 'oneOf';
  static const String _discriminator = 'discriminator';

  /// Whether the type is `oneOf`.
  bool get isOneOf => containsKey(_oneOf);

  /// Retrieves the value of `oneOf`.
  ///
  /// Check [isOneOf] first before accessing.
  List<JsonMap> get oneOf => getJsonList(_oneOf);

  bool get hasDiscriminator => containsKey(_discriminator);

  JsonMap get discriminator => getMap<String, Object?>(_discriminator);
}

extension DiscriminatorSchema on JsonMap {
  static const String _property = 'propertyName';
  static const String _mapping = 'mapping';

  String get property => this[_property]! as String;

  Map<String, Object?> get mapping => getMap(_mapping);
}

extension EnumerationSchema on JsonMap {
  static const String _enum = 'enum';

  /// Whether the type is an enumeration.
  bool get isEnumeration => containsKey(_enum);

  /// The list of enumerations for the type.
  ///
  /// Check [isEnumeration] first before accessing.
  List<Object> get enumerations => getList<Object>(_enum);
}

extension ArraySchema on JsonMap {
  static const String _array = 'array';
  static const String _items = 'items';

  /// Whether the type definition is an array.
  bool get isArray => type == _array;

  /// Whether the value type of the array is specified.
  bool get hasItems => containsKey(_items);

  /// The value type of the array.
  JsonMap get items => getMap<String, Object?>(_items);
}

extension StringSchema on JsonMap {
  static const String _string = 'string';
  static const String _format = 'format';
  static const String _dateTime = 'date-time';
  static const String _uri = 'uri';

  bool get isString => type == _string;

  bool get isDateTime => this[_format] == _dateTime;

  bool get isUri => this[_format] == _uri;
}

extension PropertySchema on JsonMap {
  static const String _nullable = 'nullable';
  static const String _default = 'default';
  static const String _deprecated = 'deprecated';

  /// Whether the property value can be `null`.
  ///
  /// This is used when the property is required but could also be `null`.
  bool get isNullable => getBool(_nullable);

  /// The default value of the property if applicable.
  Object? get defaultsTo => this[_default];

  /// Whether the property is deprecated.
  bool get isDeprecated => getBool(_deprecated);

  /// Whether the property defines a type.
  ///
  /// A property can contain the definition of a type within it. If there isn't
  /// any need to reference the type elsewhere defining it inline is a common
  /// convention.
  bool get definesType =>
      isOneOf || isAllOf || isEnumeration || (isObject && hasProperties);
}

// \TODO merge if not used!
extension on String {
  String get referenceName => substring(lastIndexOf('/') + 1);
}

/*
import 'package:change_case/change_case.dart';

typedef Definition = Map<String, Object?>;

final RegExp _nodeMatch = RegExp(r'[A-Za-z]+Node?$');
final RegExp _traitMatch = RegExp(r'[A-Za-z]+Traits?$');

bool isMixin(String name) => _traitMatch.hasMatch(name);

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
    } else {
      schema = _addClass(name, definition);
    }

    _schemas[name] = schema;
  }

  T? tryGet<T extends Schema>(String name) => _schemas[name] as T?;

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

      print('adding enum ${name.toPascalCase()}${property.toPascalCase()}');

      add('${name.toPascalCase()}${property.toPascalCase()}', <String, Object?>{
        'enum': mapping.keys.toList(),
      });
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
    final implements = <Type>[];
    final mixins = <Type>[];
    final properties = <Property>[];

    final definitions = definition.isAllOf
        ? definition.allOf
        : <Definition>[definition];

    for (final value in definitions) {
      if (value.isReference) {
        final reference = value.referenceName;

        if (isMixin(reference)) {
          mixins.add(Type(root: this, name: reference));
        }
      } else if (value.isObject) {
        properties.addAll(_addProperties(value));
      }
    }

    // This should come from the data
    late final Type? extend;
    if (_nodeMatch.hasMatch(name)) {
      final extendType = name == 'CanvasNode' || name == 'DocumentNode'
          ? 'Node'
          : 'SubcanvasNode';

      extend = Type(root: this, name: extendType);
    } else {
      extend = null;
    }

    return Class(
      root: this,
      name: name,
      metadata: definition.metadata,
      extend: extend,
      mixin: false,
      implements: implements,
      mixins: mixins,
      properties: properties,
    );
  }

  Class _addMixin(String name, Definition definition) {
    final implements = <Type>[];
    final properties = <Property>[];

    final definitions = definition.isAllOf
        ? definition.allOf
        : <Definition>[definition];

    for (final value in definitions) {
      if (value.isReference) {
        implements.add(Type(root: this, name: value.referenceName));
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
    final type = !definition.useDiscriminator
        ? _addType(name, definition)
        : Type(root: this, name: definition.discriminatorType);

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
      description: definition.description,
      metadata: definition.metadata,
      required: required,
      defaultsTo: defaultsTo,
    );
  }

  Type _addType(String name, Definition definition) {
    if (definition.isReference) {
      return Type(root: this, name: definition.referenceName);
    }

    final definitionType = definition['type'];

    if (definitionType is List) {
      return Type(root: this, name: definitionType[0], isNullable: true);
    }

    if (definitionType is String) {
      if (definitionType == 'object') {
        // Look to see if another object is defined
        if (definition.hasProperties) {
          final schemaName = definition.hasDartName
              ? definition.dartName
              : name.toPascalCase();

          add(schemaName, definition);

          return Type(root: this, name: schemaName);
        } else {
          return Type(
            root: this,
            name: definitionType,
            typeArgument: definition.hasAdditionalProperties
                ? _addType(name, definition.additionalProperties)
                : null,
          );
        }
      } else if (definitionType == 'array') {
        return Type(
          root: this,
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

        return Type(root: this, name: schemaName);
      } else {
        return Type(root: this, name: definitionType);
      }
    }

    if (definition.isOneOf) {
      if (definition.hasDartName) {
        return Type(root: this, name: definition.dartName);
      }

      return Type(
        root: this,
        name: 'any',
        isNullable: definition.oneOf.any((v) => v.containsValue('null')),
      );
    }

    return Type(root: this, name: 'any', isNullable: true);
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
    this.extend,
    this.implements = const <Type>[],
    this.mixins = const <Type>[],
    this.properties = const <Property>[],
  });

  final bool mixin;

  final Type? extend;

  final List<Type> implements;

  final List<Type> mixins;

  final List<Property> properties;

  Iterable<Property> get superProperties sync* {
    if (extend != null) {
      final extending = root.get(extend!.name);
      if (extending is Class) {
        yield* extending.implementedProperties;
      }
    }
  }

  Iterable<Property> get implementedProperties sync* {
    for (final type in implements) {
      final implementing = root.get<Class>(type.name);
      yield* implementing.implementedProperties;
    }

    yield* properties;
  }

  Iterable<Property> get mixinProperties sync* {
    if (mixin) {
      yield* implementedProperties;
    } else {
      for (final type in mixins) {
        final mixin = root.get<Class>(type.name);
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
  const Type({
    required this.root,
    required this.name,
    this.isNullable = false,
    this.typeArgument,
  });

  final Schemas root;

  final String name;

  final bool isNullable;

  final Type? typeArgument;

  Schema? get trySchema => root.tryGet(name);

  Schema get schema => root.get(name);
}

extension on String {
  String get referenceName => substring(lastIndexOf('/') + 1);
}

extension on Definition {
  String get description => this['description'] as String? ?? '';

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

  bool get useDiscriminator => containsKey('x-dart-discriminator');

  String get discriminatorType => this['x-dart-discriminator']! as String;

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
*/
