import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:pjspaul_admin/utils/youtube_helper.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

/// Dialog for playing videos — YouTube (via iframe) or uploaded (via HTML5 video).
class VideoPreviewDialog extends StatefulWidget {
  final String videoUrl;
  final bool isYoutube;

  const VideoPreviewDialog({
    required this.videoUrl,
    required this.isYoutube,
    super.key,
  });

  static void show(BuildContext context, String videoUrl, bool isYoutube) {
    showDialog(
      context: context,
      builder: (context) => VideoPreviewDialog(
        videoUrl: videoUrl,
        isYoutube: isYoutube,
      ),
    );
  }

  @override
  State<VideoPreviewDialog> createState() => _VideoPreviewDialogState();
}

class _VideoPreviewDialogState extends State<VideoPreviewDialog> {
  YoutubePlayerController? _ytController;
  String? _htmlVideoViewType;

  @override
  void initState() {
    super.initState();
    if (widget.isYoutube) {
      final videoId = YoutubeHelper.extractVideoId(widget.videoUrl);
      if (videoId != null) {
        _ytController = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: true,
          params: const YoutubePlayerParams(
            showFullscreenButton: true,
            mute: false,
          ),
        );
      }
    } else {
      // HTML5 video player for uploaded files
      _htmlVideoViewType =
          'video-player-${DateTime.now().millisecondsSinceEpoch}';
      // ignore: undefined_prefixed_name
      ui_web.platformViewRegistry.registerViewFactory(
        _htmlVideoViewType!,
        (int viewId) {
          final videoElement = html.VideoElement()
            ..src = widget.videoUrl
            ..autoplay = true
            ..controls = true
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.borderRadius = '8px'
            ..setAttribute('playsinline', 'true');
          return videoElement;
        },
      );
    }
  }

  @override
  void dispose() {
    _ytController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isYoutube ? 'YouTube Video' : 'Video Player',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 400,
                child: _buildPlayer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    if (widget.isYoutube && _ytController != null) {
      return YoutubePlayer(
        controller: _ytController!,
      );
    } else if (!widget.isYoutube && _htmlVideoViewType != null) {
      return HtmlElementView(viewType: _htmlVideoViewType!);
    }
    return const Center(
      child: Text('Unable to play this video',
          style: TextStyle(color: Colors.red)),
    );
  }
}
