class ChannelSerie {
  final int? num;
  final String? name;
  final int? seriesId;
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

  ChannelSerie({
    this.num,
    this.name,
    this.seriesId,
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

  ChannelSerie.fromJson(Map<String, dynamic> json)
      : num = json['num'] as int?,
        name = json['name']?.toString(),
        seriesId = json['series_id'] as int?,
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
        'num': num,
        'name': name,
        'series_id': seriesId,
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

  @override
  String toString() {
    return 'ChannelSerie(num: $num, name: $name, seriesId: $seriesId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChannelSerie && other.seriesId == seriesId;
  }

  @override
  int get hashCode => seriesId.hashCode;
}
