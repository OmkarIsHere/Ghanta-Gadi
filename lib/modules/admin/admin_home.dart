import 'package:flutter/material.dart';

import '../../core/widgets/custom_button.dart';
import '../../core/widgets/logout_popup.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Center(
        child: CustomButton(
            bgColor: Colors.red,
            label: "Logout",
            voidCallback: ()=> showLogoutPopUpDialog(context),
        ),
      ),
    );
  }
}
