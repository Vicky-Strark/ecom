import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Core/Constants/app_colors.dart';

class CustomText extends StatelessWidget {
  String txt;
  Color? clr;
  double? size, space;
  FontWeight? fontWeight;
  bool? underLn;
  FontStyle? fontStyle;
  TextAlign? textAlign;
  int? maxLn;

  CustomText({
    required this.txt,
    this.size,
    this.fontWeight,
    this.clr,
    this.underLn,
    this.space,
    this.fontStyle,
    this.textAlign,
    this.maxLn,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      maxLines: maxLn ?? 3,
      style: TextStyle(
        fontFamily: "AvenirArabic",
        color: clr,
        fontWeight: fontWeight,
        fontSize: size ?? 12,
        letterSpacing: space ?? 0,
        fontStyle: fontStyle,
        decoration: underLn == true ? TextDecoration.underline : null,
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      // textDirection: TextDirection.rtl,
    );
  }
}

class ManitoryTitleText extends StatelessWidget {
  ManitoryTitleText({
    super.key,
    required this.w,
    this.txt,
    this.strWant,
    this.child,
    this.padding,
  });

  final double w;
  final String? txt;
  final bool? strWant;
  Widget? child;
  EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: child != null ? 5 : 0,
        children: [
          Align(
            alignment: Alignment.centerLeft,

            child: Padding(
              padding: padding != null ? padding! : EdgeInsets.only(left: 10),

              child: RichText(
                text: TextSpan(
                  text: '${txt}',
                  style: TextStyle(
                    // color: Colors.black,
                    color: AppColors.manitTxt,
                    fontSize: 12,
                    fontFamily: "AvenirArabic",
                  ),
                  children: [
                    TextSpan(
                      text: strWant == false ? "" : '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child ?? SizedBox(),
        ],
      ),
    );
  }
}
