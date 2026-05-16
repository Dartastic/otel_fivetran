// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_fivetran_suppression.dart';

class FivetranResult {
  const FivetranResult({
    this.account,
    this.groupId,
    this.connectorId,
    this.connectorName,
    this.service,
    this.serviceVersion,
    this.destinationId,
    this.destinationService,
    this.schemaName,
    this.tableName,
    this.syncMode,
    this.syncStatus,
    this.syncFrequencyMinutes,
    this.rowsExtracted,
    this.rowsLoaded,
    this.bytesExtracted,
    this.bytesLoaded,
    this.monthlyActiveRows,
    this.syncDurationMs,
    this.modelRunId,
    this.modelRunStatus,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? account;
  final String? groupId;
  final String? connectorId;
  final String? connectorName;
  final String? service;
  final String? serviceVersion;
  final String? destinationId;
  final String? destinationService;
  final String? schemaName;
  final String? tableName;
  final String? syncMode;
  final String? syncStatus;
  final int? syncFrequencyMinutes;
  final int? rowsExtracted;
  final int? rowsLoaded;
  final int? bytesExtracted;
  final int? bytesLoaded;
  final int? monthlyActiveRows;
  final int? syncDurationMs;
  final String? modelRunId;
  final String? modelRunStatus;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class FivetranCallResult<T> {
  const FivetranCallResult({required this.value, this.result});
  final T value;
  final FivetranResult? result;
}

Future<T> tracedFivetran<T>({
  required String operation,
  required Future<FivetranCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (fivetranInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_fivetran');
  final span = t.startSpan('fivetran $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'fivetran');
    span.setStringAttribute('rpc.method', operation);
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.account != null) {
        span.setStringAttribute('fivetran.account', res.account!);
      }
      if (res.groupId != null) {
        span.setStringAttribute('fivetran.group.id', res.groupId!);
      }
      if (res.connectorId != null) {
        span.setStringAttribute('fivetran.connector.id', res.connectorId!);
      }
      if (res.connectorName != null) {
        span.setStringAttribute('fivetran.connector.name', res.connectorName!);
      }
      if (res.service != null) {
        span.setStringAttribute('fivetran.service', res.service!);
      }
      if (res.serviceVersion != null) {
        span.setStringAttribute(
            'fivetran.service.version', res.serviceVersion!);
      }
      if (res.destinationId != null) {
        span.setStringAttribute('fivetran.destination.id', res.destinationId!);
      }
      if (res.destinationService != null) {
        span.setStringAttribute(
            'fivetran.destination.service', res.destinationService!);
      }
      if (res.schemaName != null) {
        span.setStringAttribute('fivetran.schema', res.schemaName!);
      }
      if (res.tableName != null) {
        span.setStringAttribute('fivetran.table', res.tableName!);
      }
      if (res.syncMode != null) {
        span.setStringAttribute('fivetran.sync.mode', res.syncMode!);
      }
      if (res.syncStatus != null) {
        span.setStringAttribute('fivetran.sync.status', res.syncStatus!);
      }
      if (res.syncFrequencyMinutes != null) {
        span.setIntAttribute(
            'fivetran.sync.frequency_minutes', res.syncFrequencyMinutes!);
      }
      if (res.rowsExtracted != null) {
        span.setIntAttribute('fivetran.rows.extracted', res.rowsExtracted!);
      }
      if (res.rowsLoaded != null) {
        span.setIntAttribute('fivetran.rows.loaded', res.rowsLoaded!);
      }
      if (res.bytesExtracted != null) {
        span.setIntAttribute('fivetran.bytes.extracted', res.bytesExtracted!);
      }
      if (res.bytesLoaded != null) {
        span.setIntAttribute('fivetran.bytes.loaded', res.bytesLoaded!);
      }
      if (res.monthlyActiveRows != null) {
        span.setIntAttribute(
            'fivetran.monthly_active_rows', res.monthlyActiveRows!);
      }
      if (res.syncDurationMs != null) {
        span.setIntAttribute('fivetran.sync.duration_ms', res.syncDurationMs!);
      }
      if (res.modelRunId != null) {
        span.setStringAttribute(
            'fivetran.transformation.run_id', res.modelRunId!);
      }
      if (res.modelRunStatus != null) {
        span.setStringAttribute(
            'fivetran.transformation.run_status', res.modelRunStatus!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('fivetran.error.code', res.errorCode!);
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.syncStatus == 'failed' ||
          res.syncStatus == 'broken' ||
          res.modelRunStatus == 'failed';
      if (fail) {
        span.setStringAttribute(
            ErrorResource.errorType.key, res.errorCode ?? 'fivetran.error');
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
