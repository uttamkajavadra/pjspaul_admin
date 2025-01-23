import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.hintText,
    this.disabledHint,
    this.value,
    this.label,
    this.isRequired = false,
    this.items,
    required this.onChanged,
    required this.validator,
    this.onSave,
    this.onClick,
    this.formKey,
  });

  final String? hintText;
  final String? disabledHint;
  final int? value;
  final String? label;
  final bool isRequired;
  final List<dynamic>? items;
  final void Function(int)? onChanged;
  final String? Function(dynamic)? validator;
  final void Function(String?)? onSave;
  final VoidCallback? onClick;
  final Key? formKey;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value,
      isExpanded: true,
      dropdownColor: Colors.white,
      items:  List.generate(items!.length, (index)=>index).toList().map((int value) {
            return DropdownMenuItem<int>(
        value: value,
        child: Text(items![value], 
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Inter',
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w400),),
            );
          }).toList(),
      onChanged: (index)=>onChanged!(index!),
      icon: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Icon(Icons.arrow_drop_down_rounded),
      ),
      style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Inter',
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w400),
      validator: validator,
      disabledHint: disabledHint == null
          ? null
          : Text(disabledHint!, overflow: TextOverflow.ellipsis),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
        ),
        errorBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red)),
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 18.0, 0.0, 18.0),
        label: label == null
            ? null
            : RichText(
              text: TextSpan(
                text: label,
                style: TextStyle(color: Colors.grey.shade300, fontSize: 16,),
                children: <TextSpan>[
                   if(isRequired) TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16,)),
                ],
              ),
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2)
        ),
      ),
    );
  }
}