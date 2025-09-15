/// Parses the OpenAPI definition from Figma and transforms it into an
/// intermediate representation that can be used to generate code.
library;

import 'package:change_case/change_case.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'json_map.dart';
import 'reference.dart';
import 'schema.dart';
import 'schema_extensions.dart';

const List<String> _builtinTypes = [
  'bool',
  'num',
  'int',
  'String',
  'List',
  'Map',
  'Object',
];

@internal
class DefinitionContext {
  static final _logger = Logger('DefinitionContext');

  final Map<String, TypeDefinition> _definitions = <String, TypeDefinition>{};

  final bool includeDeprecated;

  DefinitionContext({this.includeDeprecated = false}) {
    // Set default mappings for built-in types
    final boolean = ClassDefinition(context: this, name: 'bool');
    _definitions['boolean'] = boolean;
    _definitions['bool'] = boolean;

    final number = ClassDefinition(context: this, name: 'num');
    _definitions['number'] = number;
    _definitions['num'] = number;

    final integer = ClassDefinition(context: this, name: 'int');
    _definitions['integer'] = integer;
    _definitions['int'] = integer;

    final string = ClassDefinition(context: this, name: 'String');
    _definitions['string'] = string;
    _definitions['String'] = string;

    final list = ClassDefinition(context: this, name: 'List');
    _definitions['array'] = list;
    _definitions['List'] = list;

    final map = ClassDefinition(context: this, name: 'Map');
    _definitions['object'] = map;
    _definitions['Map'] = map;

    final object = ClassDefinition(context: this, name: 'Object');
    _definitions['any'] = object;
    _definitions['Object'] = object;
  }

  /// Get all the types defined in the context.
  ///
  /// Ignores any built-in types.
  Iterable<TypeDefinition> get types sync* {
    for (final entry in _definitions.entries) {
      final key = entry.key;
      final definition = entry.value;

      // Ignore aliased names & built in types
      if (key == definition.name && !_builtinTypes.contains(key)) {
        yield definition;
      }
    }
  }

  /// Lookup a type with the given [name].
  TypeDefinition? lookup(String name) => _definitions[name];

  /// Add a definition to the context.
  void add(String name, JsonMap definition) {
    late final TypeDefinition typeDefinition;

    if (definition.isAllOf) {
      typeDefinition = _allOf(name, definition);
    } else if (definition.isOneOf) {
      typeDefinition = _oneOf(name, definition);
    } else if (definition.isEnumeration) {
      typeDefinition = _enum(name, definition);
    } else if (definition.isObject) {
      typeDefinition = _object(name, definition);
    } else {
      typeDefinition = _typeAlias(name, definition);
    }

    _storeTypeDefinition(name, typeDefinition);
    final typename = typeDefinition.name;

    if (name == typename) {
      _logger.info('added definition of $typename');
    } else {
      _logger.info('added definition of $typename (also aliased to $name)');
      _storeTypeDefinition(typename, typeDefinition);
    }
  }

  TypeDefinition _allOf(String name, JsonMap definition) {
    _logger.fine('adding class definition associated with $name');

    final implements = <Type>[];
    final properties = <PropertyDefinition>[];

    for (final value in definition.allOf) {
      if (value.isReference) {
        final reference = value.referenceName;

        _logger.finer('class implements $reference');

        implements.add(Type(context: this, referenceName: reference));
      } else {
        properties.addAll(_properties(value));
      }
    }

    return ClassDefinition(
      context: this,
      name: definition.dartType(name),
      implements: implements,
      properties: properties,
    );
  }

  TypeDefinition _oneOf(String name, JsonMap definition) {
    final oneOf = definition.oneOf;

    // Assuming if any value is not a reference type then its a union
    final isUnion = oneOf.firstWhereOrNull((v) => !v.isReference) != null;

    if (isUnion) {
      final alias = Type.object(context: this);

      _logger.fine(
        'adding type alias definition associated with $name '
        '(alias ${alias.referenceName})',
      );

      final aliasDefinition = TypeAliasDefinition(
        context: this,
        name: definition.dartType(name),
        alias: alias,
      );

      _storeTypeDefinition(name, aliasDefinition);
      return aliasDefinition;
    }

    if (definition.hasDiscriminator) {
      final discriminator = definition.discriminator;
      final enumerationValues = discriminator.mapping.keys.toList();
      final enumerationNames = discriminator.hasEnumerationNames
          ? definition.enumerationNames
          : enumerationValues
                .cast<String>()
                .map((v) => v.toCamelCase())
                .toList();
      final property = discriminator.property;

      final enumerationName =
          '${name.toPascalCase()}${property.toPascalCase()}';

      _storeTypeDefinition(
        enumerationName,
        EnumDefinition(
          context: this,
          name: enumerationName,
          values: _enumValues(enumerationNames, enumerationValues),
        ),
      );
    }

    return ClassDefinition(context: this, name: name);
  }

  TypeDefinition _enum(String name, JsonMap definition) {
    _logger.fine('adding enumeration definition associated with $name');

    final enumerationValues = definition.enumerations;
    final enumerationNames = definition.hasEnumerationNames
        ? definition.enumerationNames
        : enumerationValues.cast<String>().map((v) => v.toCamelCase()).toList();

    return EnumDefinition(
      context: this,
      name: definition.dartType(name),
      values: _enumValues(enumerationNames, enumerationValues),
    );
  }

  List<EnumValueDefinition> _enumValues(
    List<String> names,
    List<Object> values,
  ) {
    final enumerations = <EnumValueDefinition>[];
    final enumerationCount = values.length;

    if (names.length != enumerationCount) {
      throw ArgumentError.value(
        values,
        'enum',
        'number of names and values do not match',
      );
    }

    for (var i = 0; i < enumerationCount; ++i) {
      final name = names[i];
      final value = values[i];

      _logger.finer('adding enumeration value $name (serialized to $value)');

      enumerations.add(EnumValueDefinition(name: name, value: value));
    }

    return enumerations;
  }

  TypeDefinition _object(String name, JsonMap definition) {
    _logger.fine('adding object definition associated with $name');

    return ClassDefinition(
      context: this,
      name: definition.dartType(name),
      properties: _properties(definition).toList(),
    );
  }

  TypeDefinition _typeAlias(String name, JsonMap definition) {
    final alias = Type(context: this, referenceName: definition.type);
    _logger.fine(
      'adding type alias definition associated with $name '
      '(aliased to ${alias.referenceName})',
    );

    return TypeAliasDefinition(
      context: this,
      name: definition.dartType(name),
      alias: alias,
    );
  }

  Iterable<PropertyDefinition> _properties(JsonMap definition) sync* {
    final properties = definition.properties;
    final propertyCount = properties.length;

    if (propertyCount == 0) {
      _logger.warning('no properties found in definition');
    } else {
      _logger.finer('found $propertyCount properties');
    }

    final required = definition.required;

    for (final property in properties.entries) {
      final name = property.key;
      final propertyDefinition = (property.value as Map).cast<String, Object>();

      final deprecated = propertyDefinition.isDeprecated;

      if (includeDeprecated || !deprecated) {
        yield _property(
          name,
          propertyDefinition,
          required: required.contains(name),
          deprecated: deprecated,
        );
      } else {
        _logger.finer('ignoring deprecated property $name');
      }
    }
  }

  PropertyDefinition _property(
    String name,
    JsonMap definition, {
    bool required = false,
    bool deprecated = false,
  }) {
    _logger.finer('adding property definition associated with $name');

    late final Type type;
    final isDiscriminator = definition.isDiscriminatorType;

    if (isDiscriminator) {
      type = Type(context: this, referenceName: definition.discriminatorType!);
    } else {
      type = _type(name, definition);
    }

    var isNullable = false;
    Object? defaultsTo;
    if (!required) {
      if (type.isList) {
        defaultsTo = [];
      } else if (type.isMap) {
        defaultsTo = {};
      } else {
        defaultsTo = definition.defaultsTo;
        isNullable = defaultsTo == null;
      }
    }

    return PropertyDefinition(
      name: definition.dartName(name),
      serializedName: name,
      type: isNullable ? type.nullable() : type,
      isDeprecated: deprecated,
      isDiscriminator: isDiscriminator,
      defaultsTo: defaultsTo,
    );
  }

  Type _type(String name, JsonMap definition) {
    late final String referenceName;
    late Type? typeArgument;

    if (definition.isReference) {
      referenceName = definition.referenceName;
      typeArgument = null;
    } else if (definition.definesType) {
      referenceName = definition.dartType(name);
      typeArgument = null;

      _logger.finer('found embedded type in $name property ($referenceName)');
      add(referenceName, definition);
    } else if (definition.isObject) {
      referenceName = definition.type;
      typeArgument = definition.hasAdditionalProperties
          ? _type(name, definition.additionalProperties)
          : null;
    } else if (definition.isArray) {
      referenceName = definition.type;
      typeArgument = definition.hasItems ? _type(name, definition.items) : null;
    } else {
      referenceName = definition.type;
      typeArgument = null;
    }

    return Type(
      context: this,
      referenceName: referenceName,
      isNullable: definition.isNullable,
      typeArgument: typeArgument,
    );
  }

  void _storeTypeDefinition(String name, TypeDefinition definition) {
    if (_definitions.containsKey(name)) {
      _logger.warning(
        'a definition of $name already present! ignoring new one',
      );
      return;
      //throw StateError('a definition named $name already present');
    }

    _definitions[name] = definition;
  }
}

@immutable
sealed class Definition {
  const Definition();
}

@immutable
sealed class TypeDefinition extends Definition {
  const TypeDefinition({required this.context, required this.name});

  @protected
  final DefinitionContext context;

  /// The name of the type.
  final String name;

  /// The type.
  Type get type => Type(context: context, referenceName: name);
}

@immutable
final class ClassDefinition extends TypeDefinition {
  const ClassDefinition({
    required super.context,
    required super.name,
    this.implements = const <Type>[],
    this.properties = const <PropertyDefinition>[],
  });

  /// The implemented classes.
  ///
  /// Corresponds to referenced values in `allOf`.
  final List<Type> implements;

  /// The directly defined properties.
  ///
  /// Does not take into account any properties from [implements].
  final List<PropertyDefinition> properties;
}

@immutable
final class EnumDefinition extends TypeDefinition {
  const EnumDefinition({
    required super.context,
    required super.name,
    required this.values,
  });

  /// The enumeration's values.
  final List<EnumValueDefinition> values;
}

@immutable
final class EnumValueDefinition extends Definition {
  const EnumValueDefinition({required this.name, required this.value});

  /// The associated name.
  final String name;

  /// The associated value.
  final Object value;
}

@immutable
final class TypeAliasDefinition extends TypeDefinition {
  const TypeAliasDefinition({
    required super.context,
    required super.name,
    required this.alias,
  });

  /// The type being aliased.
  final Type alias;
}

@immutable
final class PropertyDefinition extends Definition {
  const PropertyDefinition({
    required this.name,
    required this.serializedName,
    required this.type,
    this.description = '',
    this.isDeprecated = false,
    this.isDiscriminator = false,
    this.defaultsTo,
  });

  /// The name of the property.
  final String name;

  /// The serialized name for the property.
  final String serializedName;

  /// The type for the property.
  final Type type;

  /// Description of the property.
  final String description;

  /// Whether the property is deprecated.
  final bool isDeprecated;

  /// Whether the property is used to determine type.
  final bool isDiscriminator;

  /// The value the property should default to.
  final Object? defaultsTo;
}

@immutable
final class Type {
  @internal
  const Type({
    required this.context,
    required this.referenceName,
    this.isNullable = false,
    this.typeArgument,
  });

  @internal
  const Type.object({
    required DefinitionContext context,
    bool isNullable = false,
  }) : this(context: context, referenceName: 'any', isNullable: isNullable);

  @internal
  final DefinitionContext context;

  @internal
  final String referenceName;

  /// Whether the type can be null.
  final bool isNullable;

  /// The type argument if applicable.
  final Type? typeArgument;

  /// The name of the associated type.
  String get name => definition.name;

  /// Retrieve the type's definition.
  TypeDefinition get definition => context.lookup(referenceName)!;

  /// Create a nullable version of the type.
  Type nullable() => Type(
    context: context,
    referenceName: referenceName,
    isNullable: true,
    typeArgument: typeArgument,
  );
}

extension BuiltinType on Type {
  bool get isBuiltin => _builtinTypes.contains(definition.name);

  bool get isList => referenceName == 'array';

  bool get isMap => referenceName == 'object';
}

extension on JsonMap {
  /// A name for a type following Dart's naming conventions.
  String dartType(String defaultTo) => typeOverride ?? defaultTo.toPascalCase();

  /// A name for a property or variable following Dart's naming conventions.
  String dartName(String defaultTo) => nameOverride ?? defaultTo.toCamelCase();
}

/// Parses the schema definitions found in the [root].
///
/// Reads everything from the `components/schemas` to generate the data types.
Iterable<TypeDefinition> parseSchemaDefinitions(JsonMap root) {
  final schemas = root.getJsonFromPath(<String>['components', 'schemas']);
  final context = DefinitionContext();

  for (final entry in schemas.entries) {
    final name = entry.key;
    final definition = (entry.value as Map).cast<String, Object?>();

    context.add(name, definition);
  }

  return context.types;
}
