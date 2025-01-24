import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    required this.onTap,
    required this.selectedDate,
    this.text,
    super.key});
  final Function(DateTime) onTap;
  final DateTime? selectedDate;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
                    onTap: () async{
                      final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900, 8),
                          lastDate: DateTime(2101));
                      if (picked != null) {
                        onTap(picked);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text((selectedDate != null)? DateFormat('d MMM, yyyy').format(selectedDate!) : (text != null)?text!:"Select Date", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),),
                          Icon(CupertinoIcons.calendar, color: Colors.black,)
                        ],
                      ),
                    ),
                  );
  }
}