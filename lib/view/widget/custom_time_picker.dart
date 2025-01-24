import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({required this.onTap, required this.selectedTime, super.key});
  final Function(TimeOfDay) onTap;
  final TimeOfDay? selectedTime;
  @override
  Widget build(BuildContext context) {
    String formatTimeOfDay(TimeOfDay tod) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      return TimeOfDay.fromDateTime(dt).format(context);
    }

    return GestureDetector(
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: selectedTime ?? TimeOfDay.now(),
            builder: (BuildContext context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                child: child!,
              );
            });

        if (pickedTime != null) {
          onTap(pickedTime);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (selectedTime != null) ? formatTimeOfDay(selectedTime!) : "Select Time",
              style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Icon(
              CupertinoIcons.time,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
