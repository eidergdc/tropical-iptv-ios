class SerieDetails {
  final Map<String, List<Episode>>? episodes;
  final SerieInfo? info;
  final List<Season>? seasons;

  SerieDetails({
    this.episodes,
    this.info,
    this.seasons,
  });

  SerieDetails.fromJson(Map<String, dynamic> json)
      : episodes = json['episodes'] != null
            ? (json['episodes'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                  key,
                  (value as List)
                      .map((e) => Episode.fromJson(e as Map<String, dynamic>))
                      .toList(),
                ),
              )
            : null,
        info = json['info'] != null
            ? SerieInfo.fromJson(json['info'] as Map<String, dynamic>)
            : null,
        seasons = json['seasons'] != null
            ? (json['seasons'] as List)
                .map((e) => Season.fromJson(e as Map<String, dynamic>))
                .toList()
            : null;

  Map<String, dynamic> toJson() => {
        'episodes': episodes?.map(
          (key, value) => MapEntry(
            key,
            value.map((e) => e.toJson()).toList(),
          ),
        ),
        'info': info?.toJson(),
        'seasons': seasons?.map((e) => e.toJson()).toList(),
      };
}

class Episode {
  final String? id;
  final String? episodeNum;
  final String? title;
  final String? containerExtension;
  final String? info;
  final String? customSid;
  final String? added;
  final String? season;
  final String? directSource;

  Episode({
    this.id,
    this.episodeNum,
    this.title,
    this.containerExtension,
    this.info,
    this.customSid,
    this.added,
    this.season,
    this.directSource,
  });

  Episode.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        episodeNum = json['episode_num']?.toString(),
        title = json['title']?.toString(),
        containerExtension = json['container_extension']?.toString(),
        info = json['info']?.toString(),
        customSid = json['custom_sid']?.toString(),
        added = json['added']?.toString(),
        season = json['season']?.toString(),
        directSource = json['direct_source']?.toString();

  Map<String, dynamic> toJson() => {
        'id': id,
        'episode_num': episodeNum,
        'title': title,
        'container_extension': containerExtension,
        'info': info,
        'custom_sid': customSid,
        'added': added,
        'season': season,
        'direct_source': directSource,
      };
}

class SerieInfo {
  final String? name;
  final String? cover;
  final String? plot;
  final String? cast;
  final String? director;
  final String? genre;
  final String? releaseDate;
  final String? lastModified;
  final double? rating;
  final String? rating5based;
  final String? backdropPath;
  final String? youtubeTrailer;
  final int? episodeRunTime;
  final String? categoryId;

  SerieInfo({
    this.name,
    this.cover,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.releaseDate,
    this.lastModified,
    this.rating,
    this.rating5based,
    this.backdropPath,
    this.youtubeTrailer,
    this.episodeRunTime,
    this.categoryId,
  });

  SerieInfo.fromJson(Map<String, dynamic> json)
      : name = json['name']?.toString(),
        cover = json['cover']?.toString(),
        plot = json['plot']?.toString(),
        cast = json['cast']?.toString(),
        director = json['director']?.toString(),
        genre = json['genre']?.toString(),
        releaseDate = json['releaseDate']?.toString(),
        lastModified = json['last_modified']?.toString(),
        rating = json['rating'] != null
            ? double.tryParse(json['rating'].toString())
            : null,
        rating5based = json['rating_5based']?.toString(),
        backdropPath = json['backdrop_path']?.toString() ??
            json['backdrop_path_list']?.toString(),
        youtubeTrailer = json['youtube_trailer']?.toString(),
        episodeRunTime = json['episode_run_time'] as int?,
        categoryId = json['category_id']?.toString();

  Map<String, dynamic> toJson() => {
        'name': name,
        'cover': cover,
        'plot': plot,
        'cast': cast,
        'director': director,
        'genre': genre,
        'releaseDate': releaseDate,
        'last_modified': lastModified,
        'rating': rating,
        'rating_5based': rating5based,
        'backdrop_path': backdropPath,
        'youtube_trailer': youtubeTrailer,
        'episode_run_time': episodeRunTime,
        'category_id': categoryId,
      };
}

class Season {
  final String? airDate;
  final int? episodeCount;
  final int? id;
  final String? name;
  final String? overview;
  final int? seasonNumber;
  final String? cover;
  final String? coverBig;

  Season({
    this.airDate,
    this.episodeCount,
    this.id,
    this.name,
    this.overview,
    this.seasonNumber,
    this.cover,
    this.coverBig,
  });

  Season.fromJson(Map<String, dynamic> json)
      : airDate = json['air_date']?.toString(),
        episodeCount = json['episode_count'] as int?,
        id = json['id'] as int?,
        name = json['name']?.toString(),
        overview = json['overview']?.toString(),
        seasonNumber = json['season_number'] as int?,
        cover = json['cover']?.toString(),
        coverBig = json['cover_big']?.toString();

  Map<String, dynamic> toJson() => {
        'air_date': airDate,
        'episode_count': episodeCount,
        'id': id,
        'name': name,
        'overview': overview,
        'season_number': seasonNumber,
        'cover': cover,
        'cover_big': coverBig,
      };
}
