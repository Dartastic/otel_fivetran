// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_fivetran/otel_fivetran.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_fivetran-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('connector.sync records service + rows + MAR', () async {
    await tracedFivetran<String>(
      operation: 'connector.sync',
      invoke: () async => const FivetranCallResult(
        value: 'ok',
        result: FivetranResult(
          connectorName: 'salesforce_prod',
          service: 'salesforce',
          destinationService: 'snowflake',
          syncMode: 'incremental',
          syncStatus: 'completed',
          rowsLoaded: 12500,
          monthlyActiveRows: 1850000,
          syncDurationMs: 42000,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('fivetran connector.sync')!);
    expect(a['fivetran.service'], 'salesforce');
    expect(a['fivetran.rows.loaded'], 12500);
    expect(a['fivetran.monthly_active_rows'], 1850000);
  });

  test('broken connector sets span error', () async {
    await tracedFivetran<String>(
      operation: 'connector.get',
      invoke: () async => const FivetranCallResult(
        value: 'ok',
        result: FivetranResult(
          connectorName: 'shopify',
          syncStatus: 'broken',
        ),
      ),
    );
    expect(
      spans.findSpanByName('fivetran connector.get')!.status,
      SpanStatusCode.Error,
    );
  });

  test('transformation run records status', () async {
    await tracedFivetran<String>(
      operation: 'transformation.run',
      invoke: () async => const FivetranCallResult(
        value: 'ok',
        result: FivetranResult(
          modelRunId: 'r_1',
          modelRunStatus: 'succeeded',
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('fivetran transformation.run')!);
    expect(a['fivetran.transformation.run_id'], 'r_1');
    expect(a['fivetran.transformation.run_status'], 'succeeded');
  });

  test('suppression skips spans', () async {
    await runWithoutFivetranInstrumentationAsync(() async {
      await tracedFivetran<String>(
        operation: 'connectors.list',
        invoke: () async => const FivetranCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('fivetran '), isEmpty);
  });
}
