import 'dart:io';
import 'dart:math';

import 'package:eng_dict/model/banner_ads_state.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdsBox extends StatefulWidget {
  const BannerAdsBox({super.key});

  @override
  State<BannerAdsBox> createState() => _BannerAdsBoxState();
}

class _BannerAdsBoxState extends State<BannerAdsBox>
    with AutomaticKeepAliveClientMixin {
  late BannerAd bannerAd;
  bool isLoaded = false;

  String get adUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadAd();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return !isLoaded
        ? const SizedBox(
            height: 65,
          )
        : SizedBox(
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          );
  }

  void loadAd() async {
    if (!mounted) {
      return;
    }

    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(context).width.truncate());

    if (size == null) return;

    bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            isLoaded = true;
          });
        },
        onAdClosed: (ad) {
          ad.dispose();
          debugPrint("$ad closed");
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
