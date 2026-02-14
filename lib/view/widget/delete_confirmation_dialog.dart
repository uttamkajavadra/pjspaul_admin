import 'package:flutter/material.dart';

/// Reusable delete confirmation dialog.
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    this.title = 'Delete',
    this.message =
        'Are you sure you want to delete this item? This action cannot be undone.',
    required this.onConfirm,
    super.key,
  });

  /// Shows the dialog and returns true if user confirmed, false otherwise.
  static Future<bool> show(
    BuildContext context, {
    String title = 'Delete',
    String message =
        'Are you sure you want to delete this item? This action cannot be undone.',
    required VoidCallback onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
