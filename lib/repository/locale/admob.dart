part of 'locale.dart';

// AdMob IDs - Replace with your actual AdMob IDs
const String kBanner = 'ca-app-pub-3940256099942544/2934735716'; // Test ID
const String kInterstitial =
    'ca-app-pub-3940256099942544/4411468910'; // Test ID
const String kRewarded = 'ca-app-pub-3940256099942544/1712485313'; // Test ID

class AdmobHelper {
  static String getBannerId() {
    return kBanner;
  }

  static String getInterstitialId() {
    return kInterstitial;
  }

  static String getRewardedId() {
    return kRewarded;
  }
}
