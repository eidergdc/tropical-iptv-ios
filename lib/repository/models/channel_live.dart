class ChannelLive {
  final int? num;
  final String? name;
  final String? streamType;
  final int? streamId;
  final String? streamIcon;
  final int? epgChannelId;
  final String? added;
  final String? categoryId;
  final String? customSid;
  final int? tvArchive;
  final String? directSource;
  final int? tvArchiveDuration;

  ChannelLive({
    this.num,
    this.name,
    this.streamType,
    this.streamId,
    this.streamIcon,
    this.epgChannelId,
    this.added,
    this.categoryId,
    this.customSid,
    this.tvArchive,
    this.directSource,
    this.tvArchiveDuration,
  });

  ChannelLive.fromJson(Map<String, dynamic> json)
      : num = json['num'] as int?,
        name = json['name']?.toString(),
        streamType = json['stream_type']?.toString(),
        streamId = json['stream_id'] as int?,
        streamIcon = json['stream_icon']?.toString(),
        epgChannelId = json['epg_channel_id'] != null
            ? int.tryParse(json['epg_channel_id'].toString())
            : null,
        added = json['added']?.toString(),
        categoryId = json['category_id']?.toString(),
        customSid = json['custom_sid']?.toString(),
        tvArchive = json['tv_archive'] as int?,
        directSource = json['direct_source']?.toString(),
        tvArchiveDuration = json['tv_archive_duration'] as int?;

  Map<String, dynamic> toJson() => {
        'num': num,
        'name': name,
        'stream_type': streamType,
        'stream_id': streamId,
        'stream_icon': streamIcon,
        'epg_channel_id': epgChannelId,
        'added': added,
        'category_id': categoryId,
        'custom_sid': customSid,
        'tv_archive': tvArchive,
        'direct_source': directSource,
        'tv_archive_duration': tvArchiveDuration,
      };

  @override
  String toString() {
    return 'ChannelLive(num: $num, name: $name, streamId: $streamId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChannelLive && other.streamId == streamId;
  }

  @override
  int get hashCode => streamId.hashCode;
}
