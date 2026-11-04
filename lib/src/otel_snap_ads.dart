// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_snap_ads_suppression.dart';

const _tracerName = 'dartastic_otel_libs_snap_ads';

APITracer _tracer() => OTelAPI.tracerProvider().getTracer(_tracerName);

class SnapAdsResult {
  /// Creates a result.
  const SnapAdsResult({
    this.organizationId,
    this.adAccountId,
    this.campaignId,
    this.adSquadId,
    this.adId,
    this.objective,
    this.adType,
    this.bidStrategy,
    this.deliveryStatus,
    this.pixelId,
    this.snapAttachmentType,
    this.spendMicros,
    this.currencyCode,
    this.impressions,
    this.swipes,
    this.shares,
    this.screenshots,
    this.videoViews,
    this.conversionPurchases,
    this.statusCode,
  });

  final String? organizationId;
  final String? adAccountId;
  final String? campaignId;

  /// Snap's term for "ad set".
  final String? adSquadId;

  final String? adId;

  /// `BRAND_AWARENESS` / `APP_INSTALLS` / `APP_CONVERSIONS` /
  /// `LEAD_GENERATION` / `SALES` / `WEB_TRAFFIC` / `WEB_CONVERSIONS` /
  /// `VIDEO_VIEWS` / `CATALOG_SALES`.
  final String? objective;

  /// `SNAP_AD` / `STORY` / `COLLECTION` / `AR_LENS` / `FILTER` /
  /// `COMMERCIAL` / `SHOWCASE` / `DYNAMIC`.
  final String? adType;

  /// `LOWEST_COST_WITHOUT_CAP` / `MIN_ROAS` / `TARGET_COST` /
  /// `AUTOBID`.
  final String? bidStrategy;

  /// `ACTIVE` / `PAUSED` / `PENDING` / `REJECTED`.
  final String? deliveryStatus;

  /// Snap Pixel id (web conversions).
  final String? pixelId;

  /// `WEB_VIEW` / `DEEP_LINK` / `AD_TO_CALL` / `AD_TO_MESSAGE` /
  /// `AD_TO_LENS` / `LONGFORM_VIDEO` / `AR` / `REMOTE_WEBPAGE`.
  final String? snapAttachmentType;

  /// Spend in micros (Snap convention).
  final int? spendMicros;

  final String? currencyCode;
  final int? impressions;

  /// Swipe-up clicks (Snap's primary engagement metric).
  final int? swipes;

  final int? shares;

  /// Snap-unique metric — screenshots of the ad.
  final int? screenshots;

  final int? videoViews;
  final int? conversionPurchases;
  final int? statusCode;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class SnapAdsCallResult<T> {
  /// Creates a call result.
  const SnapAdsCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final SnapAdsResult? result;
}

/// Wraps a Snap Ads (Marketing API) call in a CLIENT span.
/// [operation] is one of `stats.get`, `campaigns.create`,
/// `adsquads.create`, `ads.create`, `audiences.create`,
/// `pixels.event`, `catalogs.create`.
Future<T> tracedSnapAds<T>({
  required String operation,
  required Future<SnapAdsCallResult<T>> Function() invoke,
}) async {
  if (snapAdsInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'snap_ads',
    'rpc.method': operation,
    'snap_ads.operation': operation,
  };

  final span = _tracer().startSpan(
    'snap_ads $operation',
    kind: SpanKind.client,
    attributes: OTelAPI.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final extras = <Attribute<Object>>[];
      if (r.result!.organizationId != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.organization.id',
          r.result!.organizationId!,
        ));
      }
      if (r.result!.adAccountId != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.ad_account.id',
          r.result!.adAccountId!,
        ));
      }
      if (r.result!.campaignId != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.campaign.id',
          r.result!.campaignId!,
        ));
      }
      if (r.result!.adSquadId != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.ad_squad.id',
          r.result!.adSquadId!,
        ));
      }
      if (r.result!.adId != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.ad.id',
          r.result!.adId!,
        ));
      }
      if (r.result!.objective != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.objective',
          r.result!.objective!,
        ));
      }
      if (r.result!.adType != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.ad.type',
          r.result!.adType!,
        ));
      }
      if (r.result!.bidStrategy != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.bid.strategy',
          r.result!.bidStrategy!,
        ));
      }
      if (r.result!.deliveryStatus != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.delivery.status',
          r.result!.deliveryStatus!,
        ));
        if (r.result!.deliveryStatus == 'REJECTED') {
          span.setStatus(SpanStatusCode.Error, 'Snap Ads REJECTED');
        }
      }
      if (r.result!.pixelId != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.pixel.id',
          r.result!.pixelId!,
        ));
      }
      if (r.result!.snapAttachmentType != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.attachment.type',
          r.result!.snapAttachmentType!,
        ));
      }
      if (r.result!.spendMicros != null) {
        extras.add(OTelAPI.attributeInt(
          'snap_ads.spend.micros',
          r.result!.spendMicros!,
        ));
      }
      if (r.result!.currencyCode != null) {
        extras.add(OTelAPI.attributeString(
          'snap_ads.currency.code',
          r.result!.currencyCode!,
        ));
      }
      if (r.result!.impressions != null) {
        extras.add(OTelAPI.attributeInt(
          'snap_ads.impressions',
          r.result!.impressions!,
        ));
      }
      if (r.result!.swipes != null) {
        extras.add(OTelAPI.attributeInt(
          'snap_ads.swipes',
          r.result!.swipes!,
        ));
      }
      if (r.result!.shares != null) {
        extras.add(OTelAPI.attributeInt(
          'snap_ads.shares',
          r.result!.shares!,
        ));
      }
      if (r.result!.screenshots != null) {
        extras.add(OTelAPI.attributeInt(
          'snap_ads.screenshots',
          r.result!.screenshots!,
        ));
      }
      if (r.result!.videoViews != null) {
        extras.add(OTelAPI.attributeInt(
          'snap_ads.video_views',
          r.result!.videoViews!,
        ));
      }
      if (r.result!.conversionPurchases != null) {
        extras.add(OTelAPI.attributeInt(
          'snap_ads.conversion.purchases',
          r.result!.conversionPurchases!,
        ));
      }
      if (r.result!.statusCode != null) {
        extras.add(OTelAPI.attributeInt(
          'http.response.status_code',
          r.result!.statusCode!,
        ));
        if (r.result!.statusCode! >= 400) {
          span.setStatus(
            SpanStatusCode.Error,
            'Snap Ads HTTP ${r.result!.statusCode}',
          );
        }
      }
      if (extras.isNotEmpty) span.addAttributes(OTelAPI.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTelAPI.attributes([
      OTelAPI.attributeString(
        ErrorAttributes.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
