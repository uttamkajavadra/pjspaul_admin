import 'dart:typed_data';

import 'package:flutter/material.dart';

class CustomUploadFile extends StatelessWidget {
  const CustomUploadFile({
    required this.onTap,
    required this.selectedFile,
    this.uploadText = "Upload File",
    this.selectedText = "Selected",
    super.key});
  final Function()? onTap;
  final Uint8List? selectedFile;
  final String? uploadText;
  final String? selectedText;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text((selectedFile != null)? selectedText! : uploadText!, style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),),
                          if(selectedFile != null) Icon(Icons.check_circle_rounded, color: Colors.black,)
                        ],
                      ),
                    ),
                  );
  }
}