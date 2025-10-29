part of 'helpers.dart';

const String kAppName = "TROPICAL PLAY";

//TODO: Show Ads ( true / false )
const bool showAds = false;

const String kIconLive = "assets/images/live-stream.png";
const String kIconSeries = "assets/images/clapperboard.png";
const String kIconMovies = "assets/images/film-reel.png";
const String kIconSplash = "assets/images/icon.png";
const String kLogoApp = "assets/images/logo.png";
const String kImageIntro = "assets/images/intro.jpeg";

const String kPrivacy = "https://www.whmcssmarters.com/terms-of-service/";
const String kContact = "https://tropicaliptv.com";

const String kDemoUrl =
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";

const double sizeTablet = 950;

enum TypeCategory { all, live, movies, series }

Size getSize(BuildContext context) => MediaQuery.of(context).size;

bool isTv(BuildContext context) {
  return MediaQuery.of(context).size.width > sizeTablet;
}

bool isPhone(BuildContext context) {
  return MediaQuery.of(context).size.width < sizeTablet;
}
