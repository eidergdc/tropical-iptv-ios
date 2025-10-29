class WatchingModel {
  final String? id;
  final String? name;
  final String? icon;
  final String? type;
  final String? categoryId;
  final String? lastWatched;
  final int? progress;
  final int? duration;

  WatchingModel({
    this.id,
    this.name,
    this.icon,
    this.type,
    this.categoryId,
    this.lastWatched,
    this.progress,
    this.duration,
  });

  WatchingModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        icon = json['icon']?.toString(),
        type = json['type']?.toString(),
        categoryId = json['category_id']?.toString(),
        lastWatched = json['last_watched']?.toString(),
        progress = json['progress'] as int?,
        duration = json['duration'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'type': type,
        'category_id': categoryId,
        'last_watched': lastWatched,
        'progress': progress,
        'duration': duration,
      };

  double get progressPercentage {
    if (progress == null || duration == null || duration == 0) {
      return 0.0;
    }
    return (progress! / duration!) * 100;
  }

  @override
  String toString() {
    return 'WatchingModel(id: $id, name: $name, type: $type, progress: $progressPercentage%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WatchingModel && other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}
