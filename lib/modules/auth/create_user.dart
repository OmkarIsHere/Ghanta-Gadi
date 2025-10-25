import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:ghanta_gadi/core/extensions/custom_widgets.dart';
import 'package:ghanta_gadi/core/extensions/margin.dart';
import 'package:ghanta_gadi/core/extensions/padding.dart';
import 'package:ghanta_gadi/core/extensions/validation.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/core/widgets/show_toast.dart';
import 'package:provider/provider.dart';

import '../../core/constant/dimension_constant.dart';
import '../../core/misc/enum.dart';
import '../../core/misc/input_decoration.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/auth_provider.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key, required this.name});

  final String name;

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AuthProvider>(context, listen: false).loadCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          return Form(
            key: provider.signupKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return (value!.trimString.isEmpty)
                          ? "Please enter a full name"
                          : null;
                    },
                    controller: provider.nameController,
                    style: context.text.labelLarge,
                    decoration: textInputFieldDecoration(context).copyWith(
                      hintText: 'Enter full name',
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: DimensionConstant.edgeInsetH10,
                    ),
                  ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
                  if (provider.cityState == LoadState.LOADING) Center(child: CircularProgressIndicator()),
                  if (provider.cityState == LoadState.ERROR) Text("Failed to load cities"),
                  if (provider.cityState == LoadState.LOADED) Container(
                    padding: DimensionConstant.edgeInsetH10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.color.outline, width: 1),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: provider.selectedCity,
                      hint: Text('Select City', style: context.text.titleSmall!.copyWith(color: context.color.tertiary),),
                      items: provider.cities!
                          .map((city) =>
                          DropdownMenuItem<String>(value: city, child: Text(city, style: context.text.labelLarge,)))
                          .toList(),
                      onChanged: (value) {
                        provider.setSelectedCity(value!);
                      },
                      iconEnabledColor: context.color.tertiary,
                      underline: Container(color: Colors.transparent),
                    ),
                  ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
                  if (provider.wards == null) SizedBox(),
                  if (provider.wards != null)Container(
                    padding: DimensionConstant.edgeInsetH10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.color.outline, width: 1),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: provider.selectedWard,
                      hint: Text('Select Ward', style: context.text.titleSmall!.copyWith(color: context.color.tertiary),),
                      items: provider.wards!
                          .map((ward) =>
                          DropdownMenuItem<String>(value: ward, child: Text(ward, style: context.text.labelLarge,)))
                          .toList(),
                      onChanged: (value) {
                        provider.setSelectedWard(value!);
                      },
                      iconEnabledColor: context.color.tertiary,
                      underline: Container(color: Colors.transparent),
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
                    controller: provider.phoneController,
                    style: context.text.labelLarge,
                    decoration: textInputFieldDecoration(context).copyWith(
                      hintText: 'Enter phone number',
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      contentPadding: DimensionConstant.edgeInsetH10,
                    ),
                  ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
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
                  ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    obscuringCharacter: '*',
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
                  ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscuringCharacter: '*',
                    obscureText: true,
                    validator: (value) {
                      return (value!.trimString.isNotEmpty)
                          ? (value == provider.passwordController.text)
                              ? null
                              : "Both the password should be match"
                          : "Please enter a confirm password";
                    },
                    controller: provider.cnfPasswordController,
                    style: context.text.labelLarge,
                    decoration: textInputFieldDecoration(context).copyWith(
                      hintText: 'Enter a confirm password',
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.key),
                      contentPadding: DimensionConstant.edgeInsetH10,
                    ),
                  ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
                  SizedBox(height: context.mqHeight*0.25),
                  (provider.authState == LoadState.LOADED)
                    ? CustomButton(bgColor: context.color.primary, label: 'SIGN UP', voidCallback: () async{
                    if(!provider.signupKey.currentState!.validate()) return;
                    await provider.signup().then((res){
                      if(res == 'success'){
                        showCustomToast("Successfully signed up", context, isError: false);
                      }else if(res == 'fail'){
                        showCustomToast("Something went wrong", context);
                      }else{
                        showCustomToast(res.toString(), context);
                      }
                    });
                  })
                    : CircularProgressIndicator()
                ],
              ).paddingSymmetric(edgeInsets: DimensionConstant.edgeInsetH20V10).singleChildScrollView(),);
        },
      ),
    );
  }
}
