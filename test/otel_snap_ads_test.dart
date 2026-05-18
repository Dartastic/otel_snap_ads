// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_snap_ads/otel_snap_ads.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_snap_ads-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('stats.get records ad_squad + swipes + screenshots', () async {
    await tracedSnapAds<String>(
      operation: 'stats.get',
      invoke: () async => const SnapAdsCallResult(
        value: 'ok',
        result: SnapAdsResult(
          organizationId: 'org_1',
          adAccountId: 'aa_1',
          campaignId: 'cam_1',
          adSquadId: 'as_1',
          objective: 'APP_INSTALLS',
          adType: 'AR_LENS',
          bidStrategy: 'AUTOBID',
          deliveryStatus: 'ACTIVE',
          pixelId: 'pix_1',
          snapAttachmentType: 'DEEP_LINK',
          spendMicros: 4500000,
          currencyCode: 'USD',
          impressions: 120000,
          swipes: 3800,
          shares: 250,
          screenshots: 175,
          videoViews: 45000,
          conversionPurchases: 22,
          statusCode: 200,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('snap_ads stats.get')!);
    expect(a['snap_ads.ad_squad.id'], 'as_1');
    expect(a['snap_ads.ad.type'], 'AR_LENS');
    expect(a['snap_ads.attachment.type'], 'DEEP_LINK');
    expect(a['snap_ads.swipes'], 3800);
    expect(a['snap_ads.screenshots'], 175);
    expect(a['snap_ads.video_views'], 45000);
  });

  test('REJECTED delivery sets span error', () async {
    await tracedSnapAds<String>(
      operation: 'ads.create',
      invoke: () async => const SnapAdsCallResult(
        value: 'ok',
        result: SnapAdsResult(deliveryStatus: 'REJECTED'),
      ),
    );
    expect(
      spans.findSpanByName('snap_ads ads.create')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutSnapAdsInstrumentationAsync(() async {
      await tracedSnapAds<String>(
        operation: 'pixels.event',
        invoke: () async => const SnapAdsCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('snap_ads '), isEmpty);
  });
}
