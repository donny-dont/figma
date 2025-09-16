import 'dart:io';

import 'package:code_builder/code_builder.dart' as code;
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

import 'src/clone.dart';
import 'src/parse.dart';
import 'src/preprocess.dart';
import 'src/reference.dart';
import 'src/spec.dart';

const List<String> _allowList = <String>[
  'LocalVariable',
  'LocalVariableCollection',
  //'LocalVariablesResponse',
  'LocalVariablesMeta',
  'VariableResolvedDataType',
  'VariableAlias',
  'VariableScope',
  'VariableCodeSyntax',
  //'VariableData',
  //'VariableDataType',
  //'VariableDataValue',
  //'VariableValue',
  //'PublishedVariablesResponse',
  'PublishedVariablesMeta',
  'PublishedVariable',
  'PublishedVariableCollection',
  'Mode',
  'Rgba',
  'Rgb',

  'FileMeta',
  'User',
  'EditorType',
  'Role',
  'LinkAccess',

  'Comment',
  //'ClientMeta',
  'Reaction',
  'Emoji',

  'Vector',
  'FrameOffset',
  'Region',
  'FrameOffsetRegion',
  'CommentPinCorner',

  'StylesMeta',
  'PublishedStyle',
  'StyleType',
];

bool allowed(TypeDefinition definition) => _allowList.contains(definition.name);

final _formatter = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
);

Future<File> writeLibrary(String path, code.Library library) {
  final emitter = code.DartEmitter(
    allocator: code.Allocator(),
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  final contents = _formatter.format('${library.accept(emitter)}');

  return File(path).writeAsString(contents);
}

Future<Map<String, Object?>> loadYamlFile(String path) async {
  final file = File(path);
  final contents = await file.readAsString();

  return cloneJsonMap(loadYaml(contents) as Map);
}

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final document = await loadYamlFile('tool/openapi.yaml');

  // Modify definition
  addDiscriminators(document);
  addTypeOverrides(document);
  addResponses(document);

  final definitions = parseSchemaDefinitions(document);
  final modelExports = <String>[];

  for (final definition in definitions) {
    final path = 'lib/src/models/${definition.dartFile}';

    if (allowed(definition)) {
      final library = schemaLibrary(definition);

      print('writing $path');
      await writeLibrary(path, library);

      modelExports.add(path);
    } else {
      print('ignoring [${definition.name}] ${allowed(definition)}');

      if (File(path).existsSync()) {
        modelExports.add(path);
      }
    }
  }

  final modelsLibraryPath = 'lib/src/models.dart';
  final modelsLibrary = exportLibrary('lib/src/models.dart', modelExports);
  await writeLibrary(modelsLibraryPath, modelsLibrary);

  print(_allowList);
}
