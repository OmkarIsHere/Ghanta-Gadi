import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/extensions/custom_widgets.dart';
import 'package:ghanta_gadi/core/extensions/padding.dart';
import 'package:ghanta_gadi/core/extensions/validation.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/core/misc/enum.dart';
import 'package:ghanta_gadi/providers/auth_provider.dart';
import 'package:ghanta_gadi/routes.dart';
import 'package:provider/provider.dart' show Consumer;

import '../../core/constant/asset_constant.dart';
import '../../core/constant/dimension_constant.dart';
import '../../core/misc/input_decoration.dart';
import '../../core/misc/spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/show_toast.dart';

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
          Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Form(
                key: provider.loginKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        return (value!.trimString.isNotEmpty)
                            ? (value.isValidEmail)
                            ? null
                            : "Please enter a valid email"
                            : "Please enter a email";
                      },
                      controller: provider.emailController,
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
                      controller: provider.passwordController,
                      style: context.text.labelLarge,
                      decoration: textInputFieldDecoration(context).copyWith(
                        hintText: 'Enter a password',
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.key),
                        contentPadding: DimensionConstant.edgeInsetH10,
                      ),
                    ),
                    VSpace(context.mqHeight*0.06),
                    (provider.authState == LoadState.LOADED)
                        ? CustomButton(bgColor: context.color.primary,
                        label: 'SIGN IN',
                        voidCallback: () async{
                            if(!provider.loginKey.currentState!.validate()) return;
                            String result = await provider.login();
                            print("USER: Result $result");
                            if(result == 'citizen'){
                              showCustomToast("Successfully signed in", context, isError: false);
                              Navigator.pushReplacementNamed(context, AppRouter.citizenHome);
                            }else if(result == 'driver'){
                              showCustomToast("Successfully signed in", context, isError: false);
                              Navigator.pushReplacementNamed(context, AppRouter.driverHome);
                            }else if(result == 'admin'){
                              showCustomToast("Successfully signed in", context, isError: false);
                              Navigator.pushReplacementNamed(context, AppRouter.adminHome);
                            }else if(result == 'fail'){
                              showCustomToast("User not found", context);
                            }else{
                              showCustomToast(result.toString(), context);
                            }
                        })
                        : CircularProgressIndicator()
                  ],
                ),
              );
            },
          ),
          VSpace(context.mqHeight* 0.02),
          GestureDetector(
            onTap: ()=> Navigator.pushNamed(
                context,
                arguments: {
                  'name': AssetConstant.createUser,
                },
                AppRouter.createUser),
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