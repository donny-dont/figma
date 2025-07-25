// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webhook.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WebhookCWProxy {
  Webhook id(String? id);

  Webhook eventType(WebhookEvent? eventType);

  Webhook context(WebhookContext? context);

  Webhook contextId(String? contextId);

  Webhook planApiId(String? planApiId);

  Webhook status(WebhookStatus? status);

  Webhook clientId(String? clientId);

  Webhook passcode(String? passcode);

  Webhook endpoint(String? endpoint);

  Webhook description(String? description);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Webhook(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Webhook(...).copyWith(id: 12, name: "My name")
  /// ````
  Webhook call({
    String? id,
    WebhookEvent? eventType,
    WebhookContext? context,
    String? contextId,
    String? planApiId,
    WebhookStatus? status,
    String? clientId,
    String? passcode,
    String? endpoint,
    String? description,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWebhook.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWebhook.copyWith.fieldName(...)`
class _$WebhookCWProxyImpl implements _$WebhookCWProxy {
  const _$WebhookCWProxyImpl(this._value);

  final Webhook _value;

  @override
  Webhook id(String? id) => this(id: id);

  @override
  Webhook eventType(WebhookEvent? eventType) => this(eventType: eventType);

  @override
  Webhook context(WebhookContext? context) => this(context: context);

  @override
  Webhook contextId(String? contextId) => this(contextId: contextId);

  @override
  Webhook planApiId(String? planApiId) => this(planApiId: planApiId);

  @override
  Webhook status(WebhookStatus? status) => this(status: status);

  @override
  Webhook clientId(String? clientId) => this(clientId: clientId);

  @override
  Webhook passcode(String? passcode) => this(passcode: passcode);

  @override
  Webhook endpoint(String? endpoint) => this(endpoint: endpoint);

  @override
  Webhook description(String? description) => this(description: description);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Webhook(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Webhook(...).copyWith(id: 12, name: "My name")
  /// ````
  Webhook call({
    Object? id = const $CopyWithPlaceholder(),
    Object? eventType = const $CopyWithPlaceholder(),
    Object? context = const $CopyWithPlaceholder(),
    Object? contextId = const $CopyWithPlaceholder(),
    Object? planApiId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? clientId = const $CopyWithPlaceholder(),
    Object? passcode = const $CopyWithPlaceholder(),
    Object? endpoint = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
  }) {
    return Webhook(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      eventType: eventType == const $CopyWithPlaceholder()
          ? _value.eventType
          // ignore: cast_nullable_to_non_nullable
          : eventType as WebhookEvent?,
      context: context == const $CopyWithPlaceholder()
          ? _value.context
          // ignore: cast_nullable_to_non_nullable
          : context as WebhookContext?,
      contextId: contextId == const $CopyWithPlaceholder()
          ? _value.contextId
          // ignore: cast_nullable_to_non_nullable
          : contextId as String?,
      planApiId: planApiId == const $CopyWithPlaceholder()
          ? _value.planApiId
          // ignore: cast_nullable_to_non_nullable
          : planApiId as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as WebhookStatus?,
      clientId: clientId == const $CopyWithPlaceholder()
          ? _value.clientId
          // ignore: cast_nullable_to_non_nullable
          : clientId as String?,
      passcode: passcode == const $CopyWithPlaceholder()
          ? _value.passcode
          // ignore: cast_nullable_to_non_nullable
          : passcode as String?,
      endpoint: endpoint == const $CopyWithPlaceholder()
          ? _value.endpoint
          // ignore: cast_nullable_to_non_nullable
          : endpoint as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
    );
  }
}

extension $WebhookCopyWith on Webhook {
  /// Returns a callable class that can be used as follows: `instanceOfWebhook.copyWith(...)` or like so:`instanceOfWebhook.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WebhookCWProxy get copyWith => _$WebhookCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Webhook _$WebhookFromJson(Map<String, dynamic> json) => Webhook(
      id: json['id'] as String?,
      eventType: $enumDecodeNullable(_$WebhookEventEnumMap, json['event_type']),
      context: $enumDecodeNullable(_$WebhookContextEnumMap, json['context']),
      contextId: json['context_id'] as String?,
      planApiId: json['plan_api_id'] as String?,
      status: $enumDecodeNullable(_$WebhookStatusEnumMap, json['status']),
      clientId: json['client_id'] as String?,
      passcode: json['passcode'] as String?,
      endpoint: json['endpoint'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$WebhookToJson(Webhook instance) => <String, dynamic>{
      'id': instance.id,
      'event_type': _$WebhookEventEnumMap[instance.eventType],
      'context': _$WebhookContextEnumMap[instance.context],
      'context_id': instance.contextId,
      'plan_api_id': instance.planApiId,
      'status': _$WebhookStatusEnumMap[instance.status],
      'client_id': instance.clientId,
      'passcode': instance.passcode,
      'endpoint': instance.endpoint,
      'description': instance.description,
    };

const _$WebhookEventEnumMap = {
  WebhookEvent.ping: 'PING',
  WebhookEvent.fileUpdate: 'FILE_UPDATE',
  WebhookEvent.fileVersionUpdate: 'FILE_VERSION_UPDATE',
  WebhookEvent.fileDelete: 'FILE_DELETE',
  WebhookEvent.libraryPublish: 'LIBRARY_PUBLISH',
  WebhookEvent.fileComment: 'FILE_COMMENT',
  WebhookEvent.devModeStatusUpdate: 'DEV_MODE_STATUS_UPDATE',
};

const _$WebhookContextEnumMap = {
  WebhookContext.project: 'project',
  WebhookContext.team: 'team',
  WebhookContext.file: 'file',
};

const _$WebhookStatusEnumMap = {
  WebhookStatus.active: 'ACTIVE',
  WebhookStatus.paused: 'PAUSED',
};
