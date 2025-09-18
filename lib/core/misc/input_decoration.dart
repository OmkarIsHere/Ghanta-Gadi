import 'package:flutter/material.dart' show InputDecoration, BuildContext, OutlineInputBorder, BorderSide;
import 'package:flutter/rendering.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';


InputDecoration textInputFieldDecoration(BuildContext context){
  return  InputDecoration(
    prefixIconColor: context.color.outline,
    // suffixIconColor: context.color.onBackground.withOpacity(0.6),
    hintStyle: context.text.labelMedium!.copyWith(color: context.color.tertiary),
    labelStyle: context.text.titleSmall!.copyWith(color: context.color.tertiary),
    floatingLabelStyle: context.text.labelMedium,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: context.color.outline,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: context.color.outline,
        width: 1,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: context.color.error,
        width: 1,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: context.color.error,
        width: 1,
      ),
    ),
  );
}