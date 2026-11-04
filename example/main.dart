// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_snap_ads/otel_snap_ads.dart';

/// Traces Snap Ads (Marketing calls with OpenTelemetry.
///
/// `otel_snap_ads` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Snap Ads (Marketing call in
/// [tracedSnapAds]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'snap-ads-example');

  // Wraps a Snap Ads (Marketing API) call in a CLIENT span.
  final snapAdsId = await tracedSnapAds<String>(
    operation: 'campaigns.create',
    invoke: () async {
      // Make the Snap Ads (Marketing call here, then report what it returned.
      const id = 'snap_ads_8f3a2c';
      return const SnapAdsCallResult(
          value: id,
          result: SnapAdsResult(
              organizationId: 'organization_8f3a2c',
              adAccountId: 'adaccount_8f3a2c',
              campaignId: 'campaign_8f3a2c',
              adSquadId: 'adsquad_8f3a2c',
              adId: 'ad_8f3a2c',
              objective: 'BRAND_AWARENESS',
              adType: 'SNAP_AD',
              bidStrategy: 'LOWEST_COST_WITHOUT_CAP',
              deliveryStatus: 'ACTIVE',
              pixelId: 'pixel_8f3a2c',
              snapAttachmentType: 'WEB_VIEW',
              spendMicros: 1,
              currencyCode: 'usd',
              impressions: 1,
              swipes: 1,
              shares: 1,
              screenshots: 1,
              videoViews: 1,
              conversionPurchases: 1,
              statusCode: 201));
    },
  );
  OTelLog.info('tracedSnapAds campaigns.create returned $snapAdsId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutSnapAdsInstrumentationAsync.
  await runWithoutSnapAdsInstrumentationAsync(
    () => tracedSnapAds<String>(
      operation: 'campaigns.create',
      invoke: () async {
        const id = 'snap_ads_8f3a2c';
        return const SnapAdsCallResult(
            value: id,
            result: SnapAdsResult(
                organizationId: 'organization_8f3a2c',
                adAccountId: 'adaccount_8f3a2c',
                campaignId: 'campaign_8f3a2c',
                adSquadId: 'adsquad_8f3a2c',
                adId: 'ad_8f3a2c',
                objective: 'BRAND_AWARENESS',
                adType: 'SNAP_AD',
                bidStrategy: 'LOWEST_COST_WITHOUT_CAP',
                deliveryStatus: 'ACTIVE',
                pixelId: 'pixel_8f3a2c',
                snapAttachmentType: 'WEB_VIEW',
                spendMicros: 1,
                currencyCode: 'usd',
                impressions: 1,
                swipes: 1,
                shares: 1,
                screenshots: 1,
                videoViews: 1,
                conversionPurchases: 1,
                statusCode: 201));
      },
    ),
  );

  await OTel.shutdown();
}
