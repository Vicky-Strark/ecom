import 'package:flutter/material.dart';



import '../../Core/core.dart';
import 'custom_text.dart';



class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    this.h,
    this.w,
    this.txt,
    this.tap,this.radius,
    this.brClr,
    this.txtClr,
    this.bgClr,
    this.shadowWant,
    this.brWidth,
    this.shadowClr,
    this.txtSize,this.elevation
  });

  final double? h;
  final double? w,radius,brWidth,txtSize,elevation;
  String? txt;
  Function()? tap;
  Color? bgClr,txtClr,brClr,shadowClr;
  bool? shadowWant;



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return InkWell(
      onTap: tap,
      child: Container(
        height: h ?? height*0.05,
        width: w ?? width*0.45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgClr ?? AppColors.primaryColor,
            boxShadow: shadowWant == false ? []: [

              BoxShadow(
                color: shadowClr == null ?AppColors.primaryColor.withOpacity(0.8):shadowClr!.withOpacity(0.8),
                blurRadius: elevation ?? 8,
                offset: Offset(0, 6),
              )
            ],

            border: Border.all(
              width: brWidth ?? 1,
                color: brClr ?? AppColors.primaryColor),

            borderRadius: BorderRadius.circular(
               radius ?? 10,

            )
        ),
        child: CustomText(txt: txt.toString(),fontWeight: FontWeight.bold,clr: txtClr ??AppColors.secondaryColor ,size: txtSize ??15,),
      ),
    );
  }
}