/// Utility class for YouTube URL parsing and video ID extraction.
/// Supports regular videos, shorts, embeds, m.youtube, and youtu.be URLs.
class YoutubeHelper {
  YoutubeHelper._();

  /// Checks if a URL is a YouTube URL.
  static bool isYoutubeUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('youtube.com') ||
        lower.contains('youtu.be') ||
        lower.contains('youtube-nocookie.com');
  }

  /// Extracts the video ID from any YouTube URL format.
  /// Returns null if the URL is not a valid YouTube URL or ID cannot be extracted.
  ///
  /// Supported formats:
  /// - https://www.youtube.com/watch?v=VIDEO_ID
  /// - https://youtu.be/VIDEO_ID
  /// - https://youtube.com/shorts/VIDEO_ID
  /// - https://youtube.com/embed/VIDEO_ID
  /// - https://m.youtube.com/watch?v=VIDEO_ID
  /// - https://www.youtube-nocookie.com/embed/VIDEO_ID
  static String? extractVideoId(String url) {
    url = url.trim();

    // Pattern 1: youtu.be/VIDEO_ID
    final shortUrlRegex = RegExp(
      r'youtu\.be/([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final shortMatch = shortUrlRegex.firstMatch(url);
    if (shortMatch != null) return shortMatch.group(1);

    // Pattern 2: youtube.com/shorts/VIDEO_ID
    final shortsRegex = RegExp(
      r'youtube\.com/shorts/([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final shortsMatch = shortsRegex.firstMatch(url);
    if (shortsMatch != null) return shortsMatch.group(1);

    // Pattern 3: youtube.com/embed/VIDEO_ID
    final embedRegex = RegExp(
      r'youtube(?:-nocookie)?\.com/embed/([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final embedMatch = embedRegex.firstMatch(url);
    if (embedMatch != null) return embedMatch.group(1);

    // Pattern 4: youtube.com/watch?v=VIDEO_ID (including m.youtube.com)
    final watchRegex = RegExp(
      r'youtube\.com/watch\?.*v=([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final watchMatch = watchRegex.firstMatch(url);
    if (watchMatch != null) return watchMatch.group(1);

    // Pattern 5: youtube.com/v/VIDEO_ID
    final vRegex = RegExp(
      r'youtube\.com/v/([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final vMatch = vRegex.firstMatch(url);
    if (vMatch != null) return vMatch.group(1);

    return null;
  }

  /// Returns an embeddable YouTube URL for the given video ID.
  static String getEmbedUrl(String videoId) {
    return 'https://www.youtube.com/embed/$videoId';
  }

  /// Returns a YouTube thumbnail URL for the given video ID.
  static String getThumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
}
