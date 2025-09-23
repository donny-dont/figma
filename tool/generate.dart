import 'dart:io';

import 'package:code_builder/code_builder.dart' as code;
import 'package:cli_util/cli_logging.dart' as cli;
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

import 'src/clone.dart';
import 'src/logging.dart';
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
  'PublishedVariablesResponse',
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
  'PostComment',

  'Vector',
  'FrameOffset',
  'Region',
  'FrameOffsetRegion',
  'CommentPinCorner',

  'StylesMeta',
  'PublishedStyle',
  'StyleType',

  'Project',

  'ProjectFile',

  'Version',
  'ResponsePagination',
  'VersionsResponse',

  'PublishedComponent',
  'ComponentsMeta',
  'ResponseCursor',
  'FrameInfo',
  'ContainingComponentSet',

  'Webhook',
  'WebhookEvent',
  'WebhookStatus',
  'PostWebhook',
  'PutWebhook',

  'WebhookPayload',
  'PingPayload',
  'FileUpdatePayload',
  'FileDeletePayload',
  'FileVersionUpdatePayload',
  'LibraryPublishPayload',
  'FileCommentPayload',
  'DevModeStatusUpdatePayload',
  'LibraryItemData',
  'DevResource',
  'CommentFragment',

  'Effect',
  'EffectType',
  'ShadowEffect',
  'DropShadowEffect',
  'InnerShadowEffect',
  'BlendMode',
  'ShadowEffectVariables',

  'BlurEffect',
  'BlurType',
  'BlurEffectVariables',
  'NormalBlurEffect',
  'ProgressiveBlurEffect',
  'TextureEffect',
  'NoiseEffect',
  'NoiseType',
  'MonotoneNoiseEffect',
  'MultitoneNoiseEffect',
  'DuotoneNoiseEffect',

  'IsLayerTrait',
  'ScrollBehavior',
  'LayerTraitVariables',
  'SizeVariables',
  'IndividualStrokeWeightsVariables',
  'RectangleCornerRadiiVariables',

  'Paint',
  'PaintType',
  'SolidPaint',
  'SolidPaintVariables',
  'GradientPaint',
  'Vector',
  'ColorStop',
  'ColorStopVariables',
  'ImagePaint',
  'ScaleMode',
  'Transform',
  'ImageFilters',
  'PatternPaint',
  'PatternAlignment',
  'TileType',

  'HasLayoutTrait',
  'LayoutConstraint',
  'HorizontalConstraint',
  'VerticalConstraint',
  'GridChildAlign',
  'LayoutAlign',
  'LayoutGrow',
  'LayoutSizing',
  'LayoutPositioning',
  'Rectangle',

  'CornerTrait',
  'HasEffectsTrait',
  'HasMaskTrait',
  'MaskType',
  'HasBlendModeAndOpacityTrait',
  'MinimalFillsTrait',
  'MinimalStrokesTrait',

  'ComponentPropertiesTrait',
  'ComponentPropertyDefinition',
  'ComponentPropertyType',
  'InstanceSwapPreferredValue',
  'InstanceSwapPreferredValueType',
  'ComponentProperty',
  'ComponentPropertyVariables',

  'TypePropertiesTrait',
  'BaseTypeStyle',
  'TypeStyle',
  'LineType',
  'TextPathPropertiesTrait',
  'TextPathTypeStyle',
  'TextDecoration',
  'TextAutoResize',
  'TextTruncation',
  'LineHeightUnit',
  'TypeStyleVariables',
  'TextPathTypeStyleVariables',
  'TextCase',
  'TextAlignHorizontal',
  'TextAlignVertical',
  'Hyperlink',
  'HyperlinkType',
  'SemanticWeight',
  'SemanticItalic',

  'HasExportSettingsTrait',
  'ExportSetting',
  'ExportFormat',
  'Constraint',
  'ConstraintType',

  'HasGeometryTrait',
  'StrokeCap',
  'Path',
  'WindingRule',
  'StrokeAlign',
  'StrokeJoin',
  'PaintOverride',

  'HasBlendModeAndOpacityTrait',

  'HasFramePropertiesTrait',
  'LayoutGrid',
  'LayoutGridVariables',
  'LayoutGridPattern',
  'LayoutGridAlignment',
  'OverflowDirection',
  'LayoutMode',
  'PrimaryAxisAlignItems',
  'CounterAxisAlignItems',
  'AxisSizingMode',
  'LayoutWrap',
  'CounterAxisAlignContent',
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

Future<List<String>> loadTypeListing(String path) async {
  final file = File(path);
  final contents = await file.readAsString();

  return contents
      .split('\n')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty && !s.startsWith('#'))
      .toList();
}

bool Function(TypeDefinition) _typenameEquals(String typename) =>
    (d) => d.name == typename;

Future<File> writeDefinition(
  TypeDefinition definition, {
  String root = '',
  String generatedComment = '',
}) async {
  final path = p.join(root, 'lib', 'src', 'models', definition.dartFile);

  final progress = logger.progress('generated type at $path');
  final library = schemaLibrary(definition, comment: generatedComment);
  final file = await writeLibrary(path, library);
  progress.finish();

  return file;
}

Future<void> fileListingMode(
  Iterable<TypeDefinition> definitions,
  String path, {
  String root = '',
  String generatedComment = '',
}) async {
  final listingProgress = logger.progress('loading listing from $path');
  final names = await loadTypeListing(path);
  listingProgress.finish(message: 'found ${names.length} types');

  await generateLibraries(
    getDefinitions(definitions, names),
    root: root,
    generatedComment: generatedComment,
  );
}

Future<void> interactiveMode(
  Iterable<TypeDefinition> definitions, {
  String root = '',
  String generatedComment = '',
}) async {
  while (true) {
    logger.write('Type to generate: ');
    final name = stdin.readLineSync();

    if (name == null || name.isEmpty) {
      break;
    }

    final definition = definitions.firstWhereOrNull(_typenameEquals(name));

    if (definition == null) {
      logger.stderr('Unable to find definition of $name');
      continue;
    }

    await writeDefinition(
      definition,
      root: root,
      generatedComment: generatedComment,
    );
  }

  logger.write('exiting');
}

Future<void> generateLibraries(
  Iterable<TypeDefinition> definitions, {
  String root = '',
  String generatedComment = '',
}) async {
  for (final definition in definitions) {
    await writeDefinition(
      definition,
      root: root,
      generatedComment: generatedComment,
    );
  }
}

Iterable<TypeDefinition> getDefinitions(
  Iterable<TypeDefinition> definitions,
  Iterable<String> names,
) sync* {
  for (final name in names) {
    final definition = definitions.firstWhereOrNull(_typenameEquals(name));

    if (definition != null) {
      yield definition;
    } else {
      logger.stderr('${ansi.yellow}Unable to find $name${ansi.noColor}');
    }
  }
}

Future<void> main() async {
  setupLogger('warn');

  final apiPath = p.join('tool', 'openapi.yaml');
  final loadProgress = logger.progress(
    'Loading Figma API specification from $apiPath',
  );
  final document = await loadYamlFile(apiPath);
  final apiVersion = (document['info'] as Map)['version']! as String;
  loadProgress.finish(message: 'loaded v$apiVersion');

  final generatedComment =
      'Generated from v$apiVersion of the Figma REST API specification';

  // Modify definition
  final modifyProgress = logger.progress('Modifying Figma API specification');
  addDiscriminators(document);
  addTypeOverrides(document);
  addDiscriminatorTypes(document);
  addResponses(document);
  addRequests(document);
  modifyProgress.finish();

  final parsingProgress = logger.progress('Parsing Figma API specification');
  final definitions = parseSchemaDefinitions(document).toList();
  parsingProgress.finish();

  await fileListingMode(
    definitions,
    p.join('tool', 'types.txt'),
    root: p.join('..', 'figma'),
    generatedComment: generatedComment,
  );

  /*

  await interactiveMode(
    definitions,
    root: p.join('..', 'figma'),
    generatedComment: generatedComment,
  );
  
  final modelExports = <String>[];

  for (final definition in definitions) {
    final path = 'lib/src/models/${definition.dartFile}';

    if (allowed(definition)) {
      final library = schemaLibrary(definition, comment: generatedComment);

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
*/
}
