import 'package:flutter/material.dart';

class ResponsiveDataGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const ResponsiveDataGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return const Center(child: Text("No data found"));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        double width = constraints.maxWidth;

        if (width >= 1200) {
          crossAxisCount = 4;
        } else if (width >= 900) {
          crossAxisCount = 3;
        } else if (width >= 600) {
          crossAxisCount = 2;
        }

        // Use a grid with a fixed aspect ratio or fit content?
        // Since card height varies, MasonryGrid is best but standard GridView with childAspectRatio works if items are uniform.
        // Or simply use Wrap/RunSpacing if heights differ significantly.
        // Let's use GridView with a reasonable aspect ratio or mainAxisExtent.

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            // Aspect ratio can be tricky. Using mainAxisExtent or just letting it flow.
            // Let's try mainAxisExtent if cards are uniform height, or childAspectRatio.
            // A safe bet for these content cards is around 0.8 - 1.2 depending on content.
            // Better yet: use maxCrossAxisExtent logic but with SliverGridDelegateWithMaxCrossAxisExtent?
            // No, fixed columns give better control.
            // Let's use a rough aspect ratio and let content scroll internally if needed?
            // Actually, for varying content, Wrap inside SingleChildScrollView is safest if not virtualized.
            // But for performance with many items, GridView is better.
            // Let's assume cards have similar height.
            childAspectRatio: 0.85,
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
