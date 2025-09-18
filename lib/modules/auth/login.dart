import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/extensions/custom_widgets.dart';
import 'package:ghanta_gadi/core/extensions/padding.dart';
import 'package:ghanta_gadi/core/extensions/validation.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/routes.dart';

import '../../core/constant/asset_constant.dart';
import '../../core/constant/dimension_constant.dart';
import '../../core/misc/input_decoration.dart';
import '../../core/misc/spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/firestore_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(AssetConstant.garbageTruck, width: context.mqWidth*0.95, height: context.mqHeight*0.35),
          SizedBox(
            width: context.mqWidth*0.9,
            child: Text('Sign in with your email address and password', textAlign: TextAlign.start, style: context.text.displayLarge),
          ),
          VSpace(context.mqHeight*0.04),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              return (value!.trimString.isNotEmpty)
                  ? (value.isValidEmail)
                  ? null
                  : "Please enter a valid email"
                  : "Please enter a email";
            },
            // controller: loginController.phoneController.value,
            style: context.text.labelLarge,
            decoration: textInputFieldDecoration(context).copyWith(
              hintText: 'example@email.com',
              labelText: 'Email Address',
              prefixIcon: const Icon(Icons.email_outlined),
              contentPadding: DimensionConstant.edgeInsetH10,
            ),
          ),
          VSpace(context.mqHeight*0.02),
          TextFormField(
            keyboardType: TextInputType.text,
            obscuringCharacter: '*',
            obscureText: true,
            validator: (value) {
              return (value!.trimString.isNotEmpty)
                  ? null
                  : "Please enter a password";
            },
            // controller: loginController.phoneController.value,
            style: context.text.labelLarge,
            decoration: textInputFieldDecoration(context).copyWith(
              hintText: 'Enter a password',
              labelText: 'Password',
              prefixIcon: const Icon(Icons.key),
              contentPadding: DimensionConstant.edgeInsetH10,
            ),
          ),
          VSpace(context.mqHeight*0.06),
          CustomButton(bgColor: context.color.primary, 
              label: 'SIGN IN', 
              voidCallback: () {
              }),
          VSpace(context.mqHeight* 0.02),
          GestureDetector(
            onTap: ()=> Navigator.pushNamed(context, AppRouter.signup),
            child: Container(
              width: double.maxFinite,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.color.secondary)
              ),
              child: Text('CREATE NEW ACCOUNT', style: context.text.titleSmall!.copyWith(color: context.color.secondary, letterSpacing: 1.3)),
            ),
          )
        ],
      ).paddingSymmetric(edgeInsets: DimensionConstant.edgeInsetH20).singleChildScrollView(),
    );
  }
}