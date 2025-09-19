import 'package:code_builder/code_builder.dart' as code;
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
    for (final mixin in mixins) {
      yield* mixin.properties.where(_isField);
    }

    yield* properties.where(_isField);
  }

  Iterable<PropertyDefinition> get superFields sync* {
    final extending = extend;
    if (extending != null) {
      yield* extending.superFields;
      yield* extending.fields;
    }
  }

  Iterable<PropertyDefinition> get getters =>
      properties.where((d) => !_isField(d));

  bool _isField(PropertyDefinition definition) => !definition.singleValue;

  /// Function used to check if a type is a mixin.
  static bool Function(TypeDefinition) mixinCheck = _none;

  static bool _none(TypeDefinition type) => false;
}
