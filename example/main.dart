// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_fivetran/otel_fivetran.dart';

/// Traces Fivetran calls with OpenTelemetry.
///
/// `otel_fivetran` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Fivetran call in
/// [tracedFivetran]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'fivetran-example');

  // Traces a Fivetran call.
  final fivetranId = await tracedFivetran<String>(
    operation: 'create',
    invoke: () async {
      // Make the Fivetran call here, then report what it returned.
      const id = 'fivetran_8f3a2c';
      return const FivetranCallResult(
          value: id,
          result: FivetranResult(
              account: 'example',
              groupId: 'group_8f3a2c',
              connectorId: 'connector_8f3a2c',
              connectorName: 'example',
              service: 'example',
              serviceVersion: '1',
              destinationId: 'destination_8f3a2c',
              destinationService: 'example',
              schemaName: 'example',
              tableName: 'orders',
              syncMode: 'example',
              syncStatus: 'succeeded',
              syncFrequencyMinutes: 1,
              rowsExtracted: 1,
              rowsLoaded: 1,
              bytesExtracted: 512,
              bytesLoaded: 512,
              monthlyActiveRows: 1,
              syncDurationMs: 120,
              modelRunId: 'modelrun_8f3a2c',
              modelRunStatus: 'succeeded',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedFivetran create returned $fivetranId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutFivetranInstrumentationAsync.
  await runWithoutFivetranInstrumentationAsync(
    () => tracedFivetran<String>(
      operation: 'create',
      invoke: () async {
        const id = 'fivetran_8f3a2c';
        return const FivetranCallResult(
            value: id,
            result: FivetranResult(
                account: 'example',
                groupId: 'group_8f3a2c',
                connectorId: 'connector_8f3a2c',
                connectorName: 'example',
                service: 'example',
                serviceVersion: '1',
                destinationId: 'destination_8f3a2c',
                destinationService: 'example',
                schemaName: 'example',
                tableName: 'orders',
                syncMode: 'example',
                syncStatus: 'succeeded',
                syncFrequencyMinutes: 1,
                rowsExtracted: 1,
                rowsLoaded: 1,
                bytesExtracted: 512,
                bytesLoaded: 512,
                monthlyActiveRows: 1,
                syncDurationMs: 120,
                modelRunId: 'modelrun_8f3a2c',
                modelRunStatus: 'succeeded',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
