// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

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
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'fivetran')]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.account != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('fivetran.account', res.account!)]));
      }
      if (res.groupId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('fivetran.group.id', res.groupId!)]));
      }
      if (res.connectorId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('fivetran.connector.id', res.connectorId!)]));
      }
      if (res.connectorName != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('fivetran.connector.name', res.connectorName!)
        ]));
      }
      if (res.service != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('fivetran.service', res.service!)]));
      }
      if (res.serviceVersion != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('fivetran.service.version', res.serviceVersion!)
        ]));
      }
      if (res.destinationId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('fivetran.destination.id', res.destinationId!)
        ]));
      }
      if (res.destinationService != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'fivetran.destination.service', res.destinationService!)
        ]));
      }
      if (res.schemaName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('fivetran.schema', res.schemaName!)]));
      }
      if (res.tableName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('fivetran.table', res.tableName!)]));
      }
      if (res.syncMode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('fivetran.sync.mode', res.syncMode!)]));
      }
      if (res.syncStatus != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('fivetran.sync.status', res.syncStatus!)]));
      }
      if (res.syncFrequencyMinutes != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'fivetran.sync.frequency_minutes', res.syncFrequencyMinutes!)
        ]));
      }
      if (res.rowsExtracted != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('fivetran.rows.extracted', res.rowsExtracted!)
        ]));
      }
      if (res.rowsLoaded != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('fivetran.rows.loaded', res.rowsLoaded!)]));
      }
      if (res.bytesExtracted != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('fivetran.bytes.extracted', res.bytesExtracted!)
        ]));
      }
      if (res.bytesLoaded != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('fivetran.bytes.loaded', res.bytesLoaded!)]));
      }
      if (res.monthlyActiveRows != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'fivetran.monthly_active_rows', res.monthlyActiveRows!)
        ]));
      }
      if (res.syncDurationMs != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('fivetran.sync.duration_ms', res.syncDurationMs!)
        ]));
      }
      if (res.modelRunId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'fivetran.transformation.run_id', res.modelRunId!)
        ]));
      }
      if (res.modelRunStatus != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'fivetran.transformation.run_status', res.modelRunStatus!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('fivetran.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.syncStatus == 'failed' ||
          res.syncStatus == 'broken' ||
          res.modelRunStatus == 'failed';
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              ErrorResource.errorType.key, res.errorCode ?? 'fivetran.error')
        ]));
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
