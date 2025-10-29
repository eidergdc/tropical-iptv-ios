part of 'helpers.dart';

String formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return 'N/A';
  }

  try {
    final date = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(date);
  } catch (e) {
    return dateString;
  }
}

String formatDateTime(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return 'N/A';
  }

  try {
    final date = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  } catch (e) {
    return dateString;
  }
}

String formatDuration(int? seconds) {
  if (seconds == null || seconds == 0) {
    return '0:00';
  }

  final duration = Duration(seconds: seconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final secs = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  } else {
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}

String timeAgo(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return 'N/A';
  }

  try {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  } catch (e) {
    return dateString;
  }
}
