class MovieDetail {
  final MovieInfo? info;
  final MovieStreamInfo? movieData;

  MovieDetail({
    this.info,
    this.movieData,
  });

  MovieDetail.fromJson(Map<String, dynamic> json)
      : info = json['info'] != null
            ? MovieInfo.fromJson(json['info'] as Map<String, dynamic>)
            : null,
        movieData = json['movie_data'] != null
            ? MovieStreamInfo.fromJson(
                json['movie_data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'info': info?.toJson(),
        'movie_data': movieData?.toJson(),
      };
}

class MovieInfo {
  final String? tmdbId;
  final String? name;
  final String? o_name;
  final String? coverBig;
  final String? movieImage;
  final String? releasedate;
  final String? episodeRunTime;
  final String? youtubeTrailer;
  final String? director;
  final String? actors;
  final String? cast;
  final String? description;
  final String? plot;
  final String? age;
  final String? mpaaRating;
  final String? ratingCountKinopoisk;
  final double? rating;
  final String? country;
  final String? genre;
  final String? backdropPath;
  final String? duration;
  final String? video;
  final String? audio;
  final String? bitrate;

  MovieInfo({
    this.tmdbId,
    this.name,
    this.o_name,
    this.coverBig,
    this.movieImage,
    this.releasedate,
    this.episodeRunTime,
    this.youtubeTrailer,
    this.director,
    this.actors,
    this.cast,
    this.description,
    this.plot,
    this.age,
    this.mpaaRating,
    this.ratingCountKinopoisk,
    this.rating,
    this.country,
    this.genre,
    this.backdropPath,
    this.duration,
    this.video,
    this.audio,
    this.bitrate,
  });

  MovieInfo.fromJson(Map<String, dynamic> json)
      : tmdbId = json['tmdb_id']?.toString(),
        name = json['name']?.toString(),
        o_name = json['o_name']?.toString(),
        coverBig = json['cover_big']?.toString(),
        movieImage = json['movie_image']?.toString(),
        releasedate = json['releasedate']?.toString(),
        episodeRunTime = json['episode_run_time']?.toString(),
        youtubeTrailer = json['youtube_trailer']?.toString(),
        director = json['director']?.toString(),
        actors = json['actors']?.toString(),
        cast = json['cast']?.toString(),
        description = json['description']?.toString(),
        plot = json['plot']?.toString(),
        age = json['age']?.toString(),
        mpaaRating = json['mpaa_rating']?.toString(),
        ratingCountKinopoisk = json['rating_count_kinopoisk']?.toString(),
        rating = json['rating'] != null
            ? double.tryParse(json['rating'].toString())
            : null,
        country = json['country']?.toString(),
        genre = json['genre']?.toString(),
        backdropPath = json['backdrop_path']?.toString() ??
            json['backdrop_path_list']?.toString(),
        duration = json['duration']?.toString(),
        video = json['video']?.toString(),
        audio = json['audio']?.toString(),
        bitrate = json['bitrate']?.toString();

  Map<String, dynamic> toJson() => {
        'tmdb_id': tmdbId,
        'name': name,
        'o_name': o_name,
        'cover_big': coverBig,
        'movie_image': movieImage,
        'releasedate': releasedate,
        'episode_run_time': episodeRunTime,
        'youtube_trailer': youtubeTrailer,
        'director': director,
        'actors': actors,
        'cast': cast,
        'description': description,
        'plot': plot,
        'age': age,
        'mpaa_rating': mpaaRating,
        'rating_count_kinopoisk': ratingCountKinopoisk,
        'rating': rating,
        'country': country,
        'genre': genre,
        'backdrop_path': backdropPath,
        'duration': duration,
        'video': video,
        'audio': audio,
        'bitrate': bitrate,
      };
}

class MovieStreamInfo {
  final String? streamId;
  final String? name;
  final String? added;
  final String? categoryId;
  final String? containerExtension;
  final String? customSid;
  final String? directSource;

  MovieStreamInfo({
    this.streamId,
    this.name,
    this.added,
    this.categoryId,
    this.containerExtension,
    this.customSid,
    this.directSource,
  });

  MovieStreamInfo.fromJson(Map<String, dynamic> json)
      : streamId = json['stream_id']?.toString(),
        name = json['name']?.toString(),
        added = json['added']?.toString(),
        categoryId = json['category_id']?.toString(),
        containerExtension = json['container_extension']?.toString(),
        customSid = json['custom_sid']?.toString(),
        directSource = json['direct_source']?.toString();

  Map<String, dynamic> toJson() => {
        'stream_id': streamId,
        'name': name,
        'added': added,
        'category_id': categoryId,
        'container_extension': containerExtension,
        'custom_sid': customSid,
        'direct_source': directSource,
      };
}
