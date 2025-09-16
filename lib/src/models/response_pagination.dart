import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'response_pagination.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class ResponsePagination extends Equatable {
  const ResponsePagination({this.prevPage, this.nextPage});

  factory ResponsePagination.fromJson(Map<String, Object?> json) =>
      _$ResponsePaginationFromJson(json);

  @JsonKey(name: 'prev_page')
  final String? prevPage;

  @JsonKey(name: 'next_page')
  final String? nextPage;

  @override
  List<Object?> get props => <Object?>[prevPage, nextPage];

  Map<String, Object?> toJson() => _$ResponsePaginationToJson(this);
}
