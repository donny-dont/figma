import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'containing_component_set.dart';

part 'frame_info.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class FrameInfo extends Equatable {
  const FrameInfo({
    this.nodeId,
    this.name,
    this.backgroundColor,
    required this.pageId,
    required this.pageName,
    this.containingComponentSet,
  });

  factory FrameInfo.fromJson(Map<String, Object?> json) =>
      _$FrameInfoFromJson(json);

  final String? nodeId;

  final String? name;

  final String? backgroundColor;

  final String pageId;

  final String pageName;

  final ContainingComponentSet? containingComponentSet;

  @override
  List<Object?> get props => <Object?>[
    nodeId,
    name,
    backgroundColor,
    pageId,
    pageName,
    containingComponentSet,
  ];

  Map<String, Object?> toJson() => _$FrameInfoToJson(this);
}
