import 'dart:async';
import 'dart:io';
import 'package:budgetapp/services/ads/ads_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class RewardedAdsService implements AdsService {
  RewardedAdsService();

  RewardedAd? _rewardedAd;
  Completer<bool>? _rewardCompleter;

  final testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  final prodAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-4276933186583420/1501005966'
      : 'ca-app-pub-4276933186583420/8700621599';

  @override
  void loadAd({VoidCallback? onLoaded, Function(String)? onError}) {
    RewardedAd.load(
      adUnitId: kDebugMode ? testAdUnitId : prodAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) {},
            onAdClicked: (_) {},
            onAdImpression: (_) {},
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              // If reward was never completed, complete with false
              if (_rewardCompleter != null && !_rewardCompleter!.isCompleted) {
                _rewardCompleter!.complete(false);
              }
              loadAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              if (_rewardCompleter != null && !_rewardCompleter!.isCompleted) {
                _rewardCompleter!.complete(false);
              }
              onError?.call(error.message);
            },
          );
          _rewardedAd = ad;
          onLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          onError?.call(error.message);
        },
      ),
    );
  }

  @override
  Future<bool> showAd() async {
    if (_rewardedAd == null){
      loadAd();
    }

    _rewardCompleter = Completer<bool>();

    await _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        if (!_rewardCompleter!.isCompleted) {
          _rewardCompleter!.complete(true);
        }
      },
    );

    return _rewardCompleter!.future.timeout(
      const Duration(seconds: 60),
      onTimeout: () => false,
    );
  }


  bool get isAdLoaded => _rewardedAd != null;
}