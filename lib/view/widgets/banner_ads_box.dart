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
  final BannerAdsState bannerAdsState = BannerAdsState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadAd(bannerAdsState);
  }

  @override
  Widget build(BuildContext context) {
    return !bannerAdsState.isLoaded
        ? const SizedBox(
            height: 65,
          )
        : Stack(
            children: [
              if (bannerAdsState.isLoaded && bannerAdsState.isLoaded)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                      child: SizedBox(
                    width: bannerAdsState.bannerAd.size.width.toDouble(),
                    height: bannerAdsState.bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: bannerAdsState.bannerAd),
                  )),
                )
            ],
          );
  }

  void loadAd(BannerAdsState bannerAdsState) async {
    if (!mounted) {
      return;
    }

    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(context).width.truncate());

    if (size == null) return;

    bannerAdsState.bannerAd = BannerAd(
      adUnitId: bannerAdsState.adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            bannerAdsState.isLoaded = true;
          });
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
    bannerAdsState.bannerAd.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
