import 'package:flutter/material.dart';
import 'package:pjspaul_admin/view/theme/app_theme.dart';
import 'package:pjspaul_admin/view/widget/detail_dialog.dart';

class ResponsiveDataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> data;
  final void Function(int index) onDelete;
  final void Function(int index)? onToggleStatus;
  final bool isOldTab;

  const ResponsiveDataTable({
    super.key,
    required this.headers,
    required this.data,
    required this.onDelete,
    this.onToggleStatus,
    this.isOldTab = false,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No data found"));
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
          child: SelectionArea(
            child: DataTable(
              showCheckboxColumn: false,
              headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => Colors.grey.shade100),
              dataRowMaxHeight: 65,
              columns: [
                ...headers.map((h) => DataColumn(
                      label: Text(
                        h,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    )),
                if (onToggleStatus != null)
                  const DataColumn(
                    label: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
              ],
              rows: List.generate(data.length, (index) {
                final row = data[index];
                return DataRow(
                  onSelectChanged: (selected) {
                    Map<String, String> details = {};
                    String? imageUrl;
                    String? videoUrl;

                    for (int i = 0; i < row.length; i++) {
                      String h = headers.length > i ? headers[i] : "Column $i";
                      String val = row[i];
                      if (h.toLowerCase() == 'delete' || val.toLowerCase() == 'delete') {
                        continue;
                      }
                      if (val.startsWith('http')) {
                        if (val.contains('.mp4') || val.contains('youtube') || val.contains('.mp3') || val.contains('.wav')) {
                          videoUrl = val;
                        } else {
                          imageUrl = val;
                        }
                      } else {
                        details[h] = val;
                      }
                    }

                    DetailDialog.show(
                      context,
                      title: "Row Details",
                      data: details,
                      imageUrl: imageUrl,
                      videoUrl: videoUrl,
                    );
                  },
                  cells: List.generate(row.length, (cellIndex) {
                    final val = row[cellIndex];
                    final header = headers.length > cellIndex ? headers[cellIndex] : "";

                    if (header.toLowerCase() == 'delete' || val.toLowerCase() == 'delete') {
                      return DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => onDelete(index),
                          tooltip: "Delete",
                        ),
                      );
                    }

                    if (val.startsWith('http')) {
                      return DataCell(
                        InkWell(
                          onTap: () {
                            DetailDialog.show(
                              context,
                              title: "Media Preview",
                              data: {},
                              imageUrl: (val.contains('.mp4') || val.contains('youtube') || val.contains('.mp3') || val.contains('.wav')) ? null : val,
                              videoUrl: (val.contains('.mp4') || val.contains('youtube') || val.contains('.mp3') || val.contains('.wav')) ? val : null,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.link, color: AppTheme.primaryColor, size: 20),
                              const SizedBox(width: 4),
                              Text("View Media", style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      );
                    }

                    return DataCell(
                      Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Tooltip(
                          message: val,
                          child: Text(
                            val,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  })
                  ..add(
                    onToggleStatus != null
                        ? DataCell(
                            ElevatedButton.icon(
                              onPressed: () => onToggleStatus!(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isOldTab ? Colors.green : Colors.blue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                              ),
                              icon: Icon(isOldTab ? Icons.restore : Icons.archive, size: 16),
                              label: Text(isOldTab ? "Move to New" : "Move to Old", style: const TextStyle(fontSize: 12)),
                            ),
                          )
                        : const DataCell(SizedBox.shrink()),
                  )
                  ..removeWhere((cell) => onToggleStatus == null && cell.child is SizedBox),
                );
              }),
            ),
          ),
          ),
        ),
      ),
    );
  }
}
