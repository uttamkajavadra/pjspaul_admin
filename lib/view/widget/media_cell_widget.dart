import 'package:flutter/material.dart';
import 'package:pjspaul_admin/utils/youtube_helper.dart';
import 'package:pjspaul_admin/view/widget/video_preview_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

/// Reusable widget for rendering media cells (images, videos, audio, files) in DataTables.
/// Detects type and shows the appropriate action buttons.
class MediaCellWidget extends StatelessWidget {
  final String url;
  final String? videoType; // 'youtube' or 'upload' or null

  const MediaCellWidget({
    required this.url,
    this.videoType,
    super.key,
  });

  bool get _isYoutube =>
      videoType == 'youtube' || YoutubeHelper.isYoutubeUrl(url);

  bool get _isVideo =>
      _isYoutube ||
      videoType == 'upload' ||
      url.contains('.mp4') ||
      url.contains('video');

  bool get _isAudio =>
      url.contains('.mp3') || url.contains('.wav') || url.contains('audio');

  bool get _isImage =>
      url.contains('.jpg') ||
      url.contains('.jpeg') ||
      url.contains('.png') ||
      url.contains('.gif') ||
      url.contains('image');

  @override
  Widget build(BuildContext context) {
    if (_isYoutube) {
      return _buildActionRow(context, [
        _buildChip(
          icon: Icons.play_circle_fill,
          label: 'Play',
          color: Colors.red,
          onTap: () => VideoPreviewDialog.show(context, url, true),
        ),
      ]);
    }

    if (_isVideo) {
      return _buildActionRow(context, [
        _buildChip(
          icon: Icons.play_circle_fill,
          label: 'Play',
          color: Colors.blue.shade700,
          onTap: () => VideoPreviewDialog.show(context, url, false),
        ),
        _buildChip(
          icon: Icons.download,
          label: 'Download',
          color: Colors.green.shade700,
          onTap: () => _openUrl(url),
        ),
      ]);
    }

    if (_isAudio) {
      return _buildActionRow(context, [
        _buildChip(
          icon: Icons.audiotrack,
          label: 'Play',
          color: Colors.purple.shade700,
          onTap: () => _openUrl(url),
        ),
        _buildChip(
          icon: Icons.download,
          label: 'Download',
          color: Colors.green.shade700,
          onTap: () => _openUrl(url),
        ),
      ]);
    }

    if (_isImage) {
      return _buildActionRow(context, [
        _buildChip(
          icon: Icons.visibility,
          label: 'View',
          color: Colors.black87,
          onTap: () => _showImageDialog(context, url),
        ),
        _buildChip(
          icon: Icons.download,
          label: 'Download',
          color: Colors.green.shade700,
          onTap: () => _openUrl(url),
        ),
      ]);
    }

    // Generic file
    return _buildActionRow(context, [
      _buildChip(
        icon: Icons.open_in_new,
        label: 'Open',
        color: Colors.black87,
        onTap: () => _openUrl(url),
      ),
      _buildChip(
        icon: Icons.download,
        label: 'Download',
        color: Colors.green.shade700,
        onTap: () => _openUrl(url),
      ),
    ]);
  }

  Widget _buildActionRow(BuildContext context, List<Widget> chips) {
    return Row(mainAxisSize: MainAxisSize.min, children: chips);
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Image Preview',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _openUrl(imageUrl),
                        icon: const Icon(Icons.download),
                        tooltip: 'Download',
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return SizedBox(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    (progress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stack) => const SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.broken_image,
                                size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Failed to load image'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
