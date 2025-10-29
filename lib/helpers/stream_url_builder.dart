part of 'helpers.dart';

class StreamUrlBuilder {
  /// Constrói URL para Live TV
  /// Formato: http://server:port/live/username/password/streamId.ts
  static Future<String> buildLiveUrl(int streamId) async {
    final user = await LocaleApi.getUser();
    if (user == null) return '';

    final serverUrl =
        user.serverInfo!.serverUrl!.replaceAll('/player_api.php', '');
    final username = user.userInfo!.username;
    final password = user.userInfo!.password;

    return '$serverUrl/live/$username/$password/$streamId.ts';
  }

  /// Constrói URL para Movie
  /// Formato: http://server:port/movie/username/password/streamId.ext
  static Future<String> buildMovieUrl(int streamId, String? extension) async {
    final user = await LocaleApi.getUser();
    if (user == null) return '';

    final serverUrl =
        user.serverInfo!.serverUrl!.replaceAll('/player_api.php', '');
    final username = user.userInfo!.username;
    final password = user.userInfo!.password;
    final ext = extension ?? 'mp4';

    return '$serverUrl/movie/$username/$password/$streamId.$ext';
  }

  /// Constrói URL para Series Episode
  /// Formato: http://server:port/series/username/password/streamId.ext
  static Future<String> buildSeriesUrl(int streamId, String? extension) async {
    final user = await LocaleApi.getUser();
    if (user == null) return '';

    final serverUrl =
        user.serverInfo!.serverUrl!.replaceAll('/player_api.php', '');
    final username = user.userInfo!.username;
    final password = user.userInfo!.password;
    final ext = extension ?? 'mp4';

    return '$serverUrl/series/$username/$password/$streamId.$ext';
  }
}
