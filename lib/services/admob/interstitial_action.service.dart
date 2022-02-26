import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:lateral_thinking/data/advertising.dart';

void showInterstitialAd(
  BuildContext context,
  ValueNotifier<InterstitialAd?> interstitialAd,
) async {
  if (interstitialAd.value == null) {
    return;
  }
  interstitialAd.value!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      ad.dispose();
    },
  );
  interstitialAd.value!.show();
  interstitialAd.value = null;
}

void createInterstitialAd(
  ValueNotifier<InterstitialAd?> interstitialAd,
  int _numInterstitialLoadAttempts,
  int interstitialNumber,
) {
  InterstitialAd.load(
    adUnitId: Platform.isAndroid
        ? interstitialNumber == 1
            ? androidAnsweredInterstitialAdvId
            : androidWerewolfInterstitialAdvId
        : interstitialNumber == 1
            ? iosAnsweredInterstitialAdvId
            : iosWerewolfInterstitialAdvId,
    // adUnitId: InterstitialAd.testAdUnitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        interstitialAd.value = ad;
        _numInterstitialLoadAttempts = 0;
        interstitialAd.value!.setImmersiveMode(true);
      },
      onAdFailedToLoad: (LoadAdError error) {
        _numInterstitialLoadAttempts += 1;
        interstitialAd.value = null;
        if (_numInterstitialLoadAttempts <= 3) {
          createInterstitialAd(
            interstitialAd,
            _numInterstitialLoadAttempts,
            interstitialNumber,
          );
        }
      },
    ),
  );
}

Future interstitialLoading(
  ValueNotifier<InterstitialAd?> interstitialAd,
  int interstitialNumber,
) async {
  int _numInterstitialLoadAttempts = 0;
  createInterstitialAd(
    interstitialAd,
    _numInterstitialLoadAttempts,
    interstitialNumber,
  );
  for (int i = 0; i < 10; i++) {
    if (i > 2 && interstitialAd.value != null) {
      break;
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}
