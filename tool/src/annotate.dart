import 'package:code_builder/code_builder.dart';

final Expression override = refer('override');

final Expression immutable = refer('immutable', 'package:meta/meta.dart');

final Expression copyWith = refer(
  'CopyWith',
  'package:copy_with_extension/copy_with_extension.dart',
).call(const <Expression>[]);

final _jsonKey = refer(
  'JsonKey',
  'package:json_annotation/json_annotation.dart',
);

final _jsonValue = refer(
  'JsonValue',
  'package:json_annotation/json_annotation.dart',
);

final Expression _jsonSerializable = refer(
  'JsonSerializable',
  'package:json_annotation/json_annotation.dart',
);

Expression jsonKey(Map<String, Expression> arguments) =>
    _jsonKey.call(const <Expression>[], arguments);

Expression jsonSerializable(Map<String, Expression> arguments) =>
    _jsonSerializable.call(const <Expression>[], arguments);

Expression jsonValue(Object value) =>
    _jsonValue.call(<Expression>[literal(value)]);
