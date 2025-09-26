import 'package:code_builder/code_builder.dart' as code;
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import 'parse.dart';
import 'reference.dart';

extension ClassHierarchy on ClassDefinition {
  static final _logger = Logger('ClassHierarchy');

  /// Whether the [ClassDefinition] is for a mixin.
  bool get isMixin => mixinCheck(this);

  ClassDefinition? get extend {
    final extend = _implementDefinitions.where((d) => !mixinCheck(d)).toList();
    final length = extend.length;

    if (length == 0) {
      return null;
    } else if (length > 1) {
      _logger.warning(
        'multiple potential supertypes '
        '(${extend.map((d) => d.name).join(', ')}) '
        'defaulting to ${extend[0].name}',
      );
    }

    final definition = extend[0];

    return (definition is TypeAliasDefinition
            ? definition.alias.definition
            : definition)
        as ClassDefinition;
  }

  code.Reference? get extendReference => extend?.refer;

  Iterable<ClassDefinition> get mixins =>
      _implementDefinitions.where(mixinCheck).cast<ClassDefinition>();

  Iterable<code.Reference> get mixinReferences => implements
      .where((t) => mixinCheck(t.definition))
      .map((t) => t.definition.refer);

  Iterable<TypeDefinition> get _implementDefinitions =>
      implements.map((t) => t.definition);

  Iterable<PropertyDefinition> get fields sync* {
    yield* mixinFields;
    yield* properties.where(_isField);
  }

  Iterable<PropertyDefinition> get classFields sync* {
    final check = _isOverridden(<PropertyDefinition>[
      ...mixinFields,
      ...superFields,
      ...discriminators,
    ]);

    yield* fields.where((p) => !check(p));
  }

  Iterable<PropertyDefinition> get overriddenFields sync* {
    yield* fields.where(
      _isOverridden(<PropertyDefinition>[
        ...mixinFields,
        ...superFields,
        ...discriminators,
      ]),
    );
  }

  Iterable<PropertyDefinition> get mixinFields sync* {
    for (final mixin in mixins) {
      yield* mixin.properties.where(_isField);

      for (final implement in mixin.implements) {
        yield* (implement.definition as ClassDefinition).fields;
      }
    }
  }

  Iterable<PropertyDefinition> get superFields sync* {
    final extending = extend;
    if (extending != null) {
      yield* extending.superFields;
      yield* extending.fields;
    }
  }

  Iterable<PropertyDefinition> get discriminators sync* {
    final extending = extend;
    if (extending != null) {
      yield* extending.discriminators;
    }

    if (discriminator != null) {
      yield discriminator!;
    }
  }

  Iterable<PropertyDefinition> get getters =>
      properties.where((d) => !_isField(d));

  Iterable<PropertyDefinition> get props sync* {
    final discriminatorValue = discriminator;
    if (discriminatorValue != null) {
      yield discriminatorValue;
    }

    final extending = extend;
    final superProps = extending != null
        ? extending.props
        : Iterable<PropertyDefinition>.empty();

    final allProperties = <PropertyDefinition>[
      ...properties,
      ...mixins.expand((m) => m.properties),
    ];

    for (final property in allProperties) {
      if (superProps.firstWhereOrNull((p) => p.name == property.name) == null) {
        yield property;
      }
    }
  }

  bool _isField(PropertyDefinition definition) => !definition.singleValue;

  bool Function(PropertyDefinition) _isOverridden(
    List<PropertyDefinition> values,
  ) => (definition) {
    final name = definition.name;

    for (final value in values) {
      if (name == value.name) {
        return true;
      }
    }

    return false;
  };

  /// Function used to check if a type is a mixin.
  static bool Function(TypeDefinition) mixinCheck = _none;

  static bool _none(TypeDefinition type) => false;
}
