part of 'helpers.dart';

String getStreamUrl(
  String serverUrl,
  String username,
  String password,
  String streamId,
  String extension,
) {
  return '$serverUrl/$username/$password/$streamId.$extension';
}

String getLiveStreamUrl(
  String serverUrl,
  String username,
  String password,
  String streamId,
) {
  return '$serverUrl/live/$username/$password/$streamId.m3u8';
}

String getMovieStreamUrl(
  String serverUrl,
  String username,
  String password,
  String streamId,
) {
  return '$serverUrl/movie/$username/$password/$streamId.mp4';
}

String getSeriesStreamUrl(
  String serverUrl,
  String username,
  String password,
  String streamId,
) {
  return '$serverUrl/series/$username/$password/$streamId.mp4';
}

String? getImageUrl(String? icon, String? serverUrl) {
  if (icon == null || icon.isEmpty) return null;

  if (icon.startsWith('http')) {
    return icon;
  }

  if (serverUrl != null && serverUrl.isNotEmpty) {
    return '$serverUrl/$icon';
  }

  return null;
}

bool isValidUrl(String? url) {
  if (url == null || url.isEmpty) return false;

  try {
    final uri = Uri.parse(url);
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  } catch (e) {
    return false;
  }
}

String sanitizeString(String? text) {
  if (text == null || text.isEmpty) return '';
  return text.trim();
}

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}
