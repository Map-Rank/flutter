import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../color_constants.dart';
import '../../../common/ui.dart';

class TextFieldWidget extends StatelessWidget {

   TextFieldWidget({
    Key? key,
    this.initialValue,
     this.textController,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.hintText,
     this.errorText,
    required this.iconData,
    this.labelText,
    this.obscureText,
    required this.suffixIcon,
    this.isFirst,
    this.editable,
    this.isLast,
    this.prefixIcon,
    this.style,
    this.textAlign,
    required this.suffix,
    this.onTap,
    required this.readOnly,
    this.maxLines,
     this.selection,
     this.onCancelTapped
  }) : super(key: key);

  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final Function()? onTap;
   final Function()? onCancelTapped;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? hintText;
  var errorText;
  final TextAlign? textAlign;
  final String? labelText;
  final TextStyle? style;
  final bool? editable;
  final bool readOnly;
  final IconData iconData;
  final String? initialValue;
  final bool? obscureText;
  final bool? isFirst;
  final bool? isLast;
  final Widget suffixIcon;
  var prefixIcon;
  final Widget suffix;
  final int? maxLines;
  var selection;
  var textController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text(
              labelText ?? "",
              style: Get.textTheme.labelMedium,
              textAlign: textAlign ?? TextAlign.start,
            ),


          selection != null ? TextButton(onPressed: onCancelTapped, child:const Text('Ok/Cancel')):const SizedBox()

        ],).paddingOnly(left: 10, right: 20),
       const SizedBox(height: 10,),
        TextFormField(
          controller: textController,
          initialValue: initialValue,
          maxLines: keyboardType == TextInputType.multiline ? null : 1,
          key: key,
          keyboardType: keyboardType ?? TextInputType.text,
          onSaved: onSaved,
          onTap: onTap,
          readOnly: readOnly,
          onChanged: onChanged,
          minLines: maxLines,
          validator: validator,
          enabled: editable,
          style: style ?? Get.textTheme.headline1,
          obscureText: obscureText ?? false,
          textAlign: textAlign ?? TextAlign.start,
          decoration: Ui.getInputDecoration(
            hintText: hintText ?? '',
            //iconData: Image.asset(name),
            suffixIcon: suffixIcon,
            suffix: suffix,
            errorText: errorText, 
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    ).marginOnly(bottom: 20);
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst!) {
      return const BorderRadius.all(Radius.circular(10));
    }
    if (isLast != null && isLast!) {
      return const BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && !isFirst! && isLast != null && !isLast!) {
      return const BorderRadius.all(Radius.circular(0));
    }
    return const BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst!)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast!)) {
      return 20;
    } else if (isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }
}
