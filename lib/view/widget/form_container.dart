import 'package:flutter/material.dart';
import 'package:pjspaul_admin/view/theme/app_theme.dart';

class FormContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final double? maxWidth;

  const FormContainer({
    super.key,
    required this.child,
    this.title,
    this.maxWidth = 800,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: AppTheme.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade200),
              const SizedBox(height: 24),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
