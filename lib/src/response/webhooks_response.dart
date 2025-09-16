import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../models.dart';

part 'webhooks_response.g.dart';

/// Response from the GET /v2/webhooks endpoint.
@JsonSerializable()
@CopyWith()
@immutable
class WebhooksResponse extends Equatable {
  const WebhooksResponse({required this.webhooks, this.pagination});

  factory WebhooksResponse.fromJson(Map<String, dynamic> json) =>
      _$WebhooksResponseFromJson(json);

  /// A list of [Webhook]s.
  final List<Webhook> webhooks;

  /// Pagination
  final ResponsePagination? pagination;

  @override
  List<Object?> get props => [webhooks, pagination];

  Map<String, dynamic> toJson() => _$WebhooksResponseToJson(this);
}
