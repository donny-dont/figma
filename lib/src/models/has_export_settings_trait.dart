import 'export_setting.dart';

abstract mixin class HasExportSettingsTrait {
  /// An array of export settings representing images to export from the node.
  List<ExportSetting> get exportSettings;
}
