import 'package:flutter/material.dart';

class CustomYesNo extends StatelessWidget {
  const CustomYesNo({
    required this.isYoutube,
    required this.onTap,
    super.key});
  final bool isYoutube;
  final Function(bool) onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
                children: [
                  Expanded(child: Text("Want to add youtube link?")),
                  GestureDetector(
                    onTap: ()=>onTap(true),
                    child: Container(
                      width: 60,
                      height: 30,
                      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (isYoutube)?Colors.black:Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text("Yes", style: TextStyle(color: (isYoutube)?Colors.white:Colors.black),),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  GestureDetector(
                    onTap: ()=>onTap(false),
                    child: Container(
                      width: 60,
                      height: 30,
                      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (!isYoutube)?Colors.black:Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text("No", style: TextStyle(color: (!isYoutube)?Colors.white:Colors.black),),
                    ),
                  )
                ],
              );
  }
}