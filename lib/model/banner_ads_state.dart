import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdsState {
  late Future<InitializationStatus> initializationStatus;
  late BannerAd bannerAd;
  late BuildContext context;
  bool isLoaded = false;

  String get adUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';
}
