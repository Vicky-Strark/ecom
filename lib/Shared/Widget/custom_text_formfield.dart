
import 'package:ecom/Core/Errors/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../Core/Constants/app_colors.dart';
import 'custom_text.dart';



class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintTxt, hintTxt1, manitTxt;
  final double? h, w, radius;
  final Widget? suffix, preffix;
  final Color? fillClr;
  final bool? readOnly, enable, obscure, starWant;
  final Function()? tap;
  final String? Function(String?)? validation;
  final Function(String?)? onchange;
  final Function(String?)? submit;
  final int? maxLn,maxLen;
  final TextInputType? keyboardType;
  final TextInputAction? txtInputAction;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final double? overAllHeight;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.starWant,
    this.manitTxt,
    this.hintTxt,
    this.h,
    this.obscure,
    this.w,
    this.radius,
    this.onchange,
    this.fillClr,
    this.tap,
    this.readOnly,
    this.validation,
    this.maxLn,
    this.focusNode,
    this.submit,
    this.hintTxt1,
    this.inputFormatters,
    this.suffix,
    this.preffix,
    this.enable,
    this.keyboardType,
    this.txtInputAction,
    this.overAllHeight,
    this.maxLen
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;

    return ManitoryTitleText(
      w: w ?? width,
      strWant: starWant ?? true,
      txt: manitTxt ?? "",
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w ?? 0, vertical: h ?? 0),
        child: TextFormField(
          style: const TextStyle(fontSize: 12),
          obscureText: obscure ?? false,
          inputFormatters: inputFormatters,
          scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 15 * 4),
          controller: controller,
          readOnly: readOnly ?? false,
          onTap: tap,
          validator: starWant == false? null : validation ??
                  (val) => _defaultValidator(context, val: val, hintTxt: hintTxt),
          maxLines: maxLn ?? 1,
          maxLength: maxLen,
          enabled: enable,
          focusNode: focusNode,
          onChanged: onchange,
          keyboardType: keyboardType ?? _getKeyBoardType(val: hintTxt ?? ""),
          textInputAction: txtInputAction ?? TextInputAction.next,
          onFieldSubmitted: submit,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            errorStyle: const TextStyle(
              fontSize: 12,
              height: 1,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            hintText: hintTxt1 ??
                "",
            hintStyle: const TextStyle(
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            suffixIcon: suffix,
            prefixIcon: preffix,
            fillColor: fillClr ?? AppColors.secondaryColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.manitTxt.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(radius ?? 7),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.manitTxt.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(radius ?? 7),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.manitTxt.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(radius ?? 7),
            ),
          ),
        ),
      ),
    );
  }

  TextInputType? _getKeyBoardType({String? val}) {
    if (val == null) return null;
    if (val.contains("Name") || val.contains("name")) {
      return TextInputType.name;
    } else if (val.contains("Email") ||
        val.contains("mail") ||
        val.contains("Mail")) {
      return TextInputType.emailAddress;
    } else if (val.contains("Phone") || val.contains("Mobile")) {
      return TextInputType.phone;
    } else if (val.contains("Description") || val.contains("description")) {
      return TextInputType.multiline;
    } else {
      return null;
    }
  }

  String? _defaultValidator(BuildContext context,
      {String? val, String? hintTxt}) {
    if (val == null || val.isEmpty) {
      return "${hintTxt ?? ""}";
    }

    if (hintTxt != null) {
      if (hintTxt.contains("Email") ||
          hintTxt.contains("mail") ||
          hintTxt.contains("Mail")) {
        if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(val)) {
          return ErrorMessages.inValidEmail;
        }
      } else if (hintTxt.contains("Phone") || hintTxt.contains("Mobile")) {
        if (val.length >= 12) {
          return ErrorMessages.inValidPhone;
        }
      }
    }

    return null;
  }
}






class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool? showWant,searchEnable;
  final Widget? prefix, suffix;
  final FocusNode? focusNode;

  SearchTextField({super.key, this.controller, this.onChanged,this.prefix,this.showWant,this.suffix,this.searchEnable,this.focusNode});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;

    return Container(
      height: h*0.055,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow:showWant == false ? []: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            blurRadius: 6,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),

        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          onChanged: onChanged,
          enabled: searchEnable,
          autofocus: false,


          decoration: InputDecoration(
            prefixIcon: prefix,



            hintText: "Search...",
            // hintStyle: TextStyle(fontSize: 12),
            suffixIcon:  suffix ?? Icon(Icons.search, color: Colors.grey[700],size: 20,),
            border: InputBorder.none,

            // border: OutlineInputBorder(
            //
            //   borderRadius: BorderRadius.circular(8),
            //   borderSide: const BorderSide(
            //     color: Colors.transparent
            //     // color: Color(0xff4E4B66)
            //   ),
            // ),
            filled: true,
            fillColor: Colors.white,
            // contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          ),
        ),
      ),
    );
  }
}


