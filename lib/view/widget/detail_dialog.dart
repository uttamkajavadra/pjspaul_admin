import 'package:flutter/material.dart';
import 'package:pjspaul_admin/view/theme/app_theme.dart';
import 'package:pjspaul_admin/view/widget/media_cell_widget.dart';

class DetailDialog extends StatelessWidget {
  final String title;
  final Map<String, String> data;
  final String? imageUrl;
  final String? videoUrl;
  final String? videoType;

  const DetailDialog({
    super.key,
    required this.title,
    required this.data,
    this.imageUrl,
    this.videoUrl,
    this.videoType,
  });

  static void show(BuildContext context,
      {required String title,
      required Map<String, String> data,
      String? imageUrl,
      String? videoUrl,
      String? videoType}) {
    showDialog(
      context: context,
      builder: (context) => DetailDialog(
        title: title,
        data: data,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
        videoType: videoType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTheme.titleLarge.copyWith(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: MediaCellWidget(url: imageUrl!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (videoUrl != null && videoUrl!.isNotEmpty) ...[
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: MediaCellWidget(
                                url: videoUrl!,
                                videoType: videoType), // Pass videoType
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    ...data.entries.map((entry) => _buildDetailRow(entry)),
                  ],
                ),
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Close",
                        style: AppTheme.bodyLarge
                            .copyWith(color: AppTheme.primaryColor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(MapEntry<String, String> entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              entry.key,
              style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              entry.value.isEmpty ? "-" : entry.value,
              style: AppTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
