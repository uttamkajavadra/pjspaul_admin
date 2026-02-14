import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

/// Centralized utility for Firebase Storage operations.
/// Stores storage paths alongside URLs for proper cleanup.
class FirebaseStorageHelper {
  FirebaseStorageHelper._();

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file and returns both the storage path and download URL.
  static Future<Map<String, String>> uploadFile({
    required String folder,
    required Uint8List bytes,
    required String extension,
  }) async {
    final storagePath =
        '$folder/${DateTime.now().millisecondsSinceEpoch}.$extension';
    final ref = _storage.ref().child(storagePath);
    await ref.putData(bytes);
    final downloadUrl = await ref.getDownloadURL();
    return {
      'storage_path': storagePath,
      'download_url': downloadUrl,
    };
  }

  /// Deletes a file from Firebase Storage using its storage path.
  /// Silently ignores if the file doesn't exist or path is empty.
  static Future<void> deleteFile(String? storagePath) async {
    if (storagePath == null || storagePath.isEmpty) return;
    try {
      await _storage.ref().child(storagePath).delete();
    } catch (_) {
      // File may already be deleted or path invalid — ignore
    }
  }

  /// Deletes a file using its download URL.
  static Future<void> deleteFileByUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {
      // File may already be deleted or URL invalid — ignore
    }
  }

  /// Gets the download URL for a storage path.
  static Future<String> getDownloadUrl(String storagePath) async {
    return await _storage.ref().child(storagePath).getDownloadURL();
  }
}
