import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:ghanta_gadi/core/extensions/custom_widgets.dart';
import 'package:ghanta_gadi/core/extensions/margin.dart';
import 'package:ghanta_gadi/core/extensions/padding.dart';
import 'package:ghanta_gadi/core/extensions/validation.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';

import '../../core/constant/dimension_constant.dart';
import '../../core/misc/input_decoration.dart';
import '../../core/widgets/custom_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CREATE ACCOUNT'),
      ),
      body: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            validator: (value) {
              return (value!.trimString.isNotEmpty)
                  ? "Please enter a full name"
                  : null;
            },
            // controller: loginController.phoneController.value,
            style: context.text.labelLarge,
            decoration: textInputFieldDecoration(context).copyWith(
              hintText: 'Enter full name',
              labelText: 'Full Name',
              prefixIcon: const Icon(Icons.person),
              contentPadding: DimensionConstant.edgeInsetH10,
            ),
          ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
          TextFormField(
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value) {
              return (value!.isNotEmpty)
                  ? (value.isValidPhoneNo)
                  ? null
                  : "Please enter a valid phone"
                  : "Please enter a phone";
            },
            // controller: loginController.phoneController.value,
            style: context.text.labelLarge,
            decoration: textInputFieldDecoration(context).copyWith(
              hintText: 'Enter phone number',
              labelText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone),
              contentPadding: DimensionConstant.edgeInsetH10,
            ),
          ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV15),
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
          ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV15),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            obscuringCharacter: '*',
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
          ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV15),
          TextFormField(
            keyboardType: TextInputType.text,
            obscuringCharacter: '*',
            obscureText: true,
            validator: (value) {
              return (value!.trimString.isNotEmpty)
                  ? null
                  : "Please enter a confirm password";
            },
            // controller: loginController.phoneController.value,
            style: context.text.labelLarge,
            decoration: textInputFieldDecoration(context).copyWith(
              hintText: 'Enter a confirm password',
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.key),
              contentPadding: DimensionConstant.edgeInsetH10,
            ),
          ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV15),
          SizedBox(height: context.mqHeight*0.37),
          CustomButton(bgColor: context.color.primary, label: 'SIGN UP', voidCallback: (){}),
        ],
      ).paddingSymmetric(edgeInsets: DimensionConstant.edgeInsetH20V10).singleChildScrollView(),
    );
  }
}
