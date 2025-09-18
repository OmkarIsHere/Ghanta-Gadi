import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/extensions/custom_widgets.dart';
import 'package:ghanta_gadi/core/extensions/padding.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import '../constant/dimension_constant.dart';

showLogoutPopUpDialog(BuildContext context, {required VoidCallback voidCallback}){
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Container(
            width: context.mqWidth*0.5,
            decoration: BoxDecoration(
                color: context.color.background,
                borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ARE YOU SURE?',
                  style: context.text.headlineSmall,
                ).paddingSymmetric(edgeInsets: DimensionConstant.edgeInsetH20V20),
                Text('By signing out you won\'t be able to view or use live features', softWrap: true, style: context.text.bodyMedium,).paddingSymmetric(edgeInsets: DimensionConstant.edgeInsetH20),
                Row(
                  children: [
                    Container(
                      padding: DimensionConstant.edgeInsetV10,
                      margin: DimensionConstant.edgeInsetH10V5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: context.color.outline, width: 1)
                      ),
                      child: Text(
                          'CANCEL',
                          style: context.text.titleSmall!.copyWith(color: context.color.scrim)
                      ),
                    ).inkWell(onTap: ()=> Navigator.pop(context)).expanded(flex: 1),
                    Container(
                      padding: DimensionConstant.edgeInsetV10,
                      margin: DimensionConstant.edgeInsetH10V5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: context.color.outline, width: 1)
                      ),
                      child: Text(
                          'LOG OUT',
                          style: context.text.titleSmall!.copyWith( color: context.color.error)
                      ),
                    ).expanded(flex: 1),
                  ],
                ).paddingSymmetric(edgeInsets: DimensionConstant.edgeInsetH15V15)
              ],
            ),
          ),
        );
      });
}