class ChannelMovie {
  final int? num;
  final String? name;
  final String? streamType;
  final int? streamId;
  final String? streamIcon;
  final double? rating;
  final String? rating5based;
  final String? added;
  final String? categoryId;
  final String? containerExtension;
  final String? customSid;
  final String? directSource;

  ChannelMovie({
    this.num,
    this.name,
    this.streamType,
    this.streamId,
    this.streamIcon,
    this.rating,
    this.rating5based,
    this.added,
    this.categoryId,
    this.containerExtension,
    this.customSid,
    this.directSource,
  });

  ChannelMovie.fromJson(Map<String, dynamic> json)
      : num = json['num'] as int?,
        name = json['name']?.toString(),
        streamType = json['stream_type']?.toString(),
        streamId = json['stream_id'] as int?,
        streamIcon = json['stream_icon']?.toString(),
        rating = json['rating'] != null
            ? double.tryParse(json['rating'].toString())
            : null,
        rating5based = json['rating_5based']?.toString(),
        added = json['added']?.toString(),
        categoryId = json['category_id']?.toString(),
        containerExtension = json['container_extension']?.toString(),
        customSid = json['custom_sid']?.toString(),
        directSource = json['direct_source']?.toString();

  Map<String, dynamic> toJson() => {
        'num': num,
        'name': name,
        'stream_type': streamType,
        'stream_id': streamId,
        'stream_icon': streamIcon,
        'rating': rating,
        'rating_5based': rating5based,
        'added': added,
        'category_id': categoryId,
        'container_extension': containerExtension,
        'custom_sid': customSid,
        'direct_source': directSource,
      };

  @override
  String toString() {
    return 'ChannelMovie(num: $num, name: $name, streamId: $streamId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChannelMovie && other.streamId == streamId;
  }

  @override
  int get hashCode => streamId.hashCode;
}
