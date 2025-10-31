import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/extensions/custom_widgets.dart';
import 'package:ghanta_gadi/core/extensions/padding.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/core/widgets/logout_popup.dart';
import 'package:ghanta_gadi/modules/driver/driver_list.dart';
import 'package:ghanta_gadi/modules/feedback/feedback_list.dart';
import 'package:ghanta_gadi/core/widgets/live_map.dart';
import 'package:ghanta_gadi/modules/vehicle/vehicle_list.dart';
import 'package:ghanta_gadi/providers/map_provider.dart';
import 'package:ghanta_gadi/providers/permission_provider.dart';
import 'package:ghanta_gadi/providers/user_provider.dart' show UserProvider;
import 'package:ghanta_gadi/providers/vehicle_provider.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int selectedIndex = 0;
  final pages = [LiveMap(), DriverList(), VehicleList(), FeedbackList()];
  List<BottomNavigationBarItem> bottomNavList = [
    BottomNavigationBarItem(
        icon: Icon(Icons.map_outlined),
        activeIcon: Icon(Icons.map),
        label: 'Map'
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.group_outlined),
        activeIcon: Icon(Icons.group),
        label: 'Drivers'
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.directions_bus_outlined),
        activeIcon: Icon(Icons.directions_bus_filled),
        label: 'Vehicles'
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.feedback_outlined),
        activeIcon: Icon(Icons.feedback),
        label: 'Feedback'
    ),
  ];

  void onItemTapped(int index){
    setState(() => selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MapProvider>(context, listen: false).listenToVehiclesLocation();
      Provider.of<UserProvider>(context, listen: false).getAllDrivers();
      Provider.of<VehicleProvider>(context, listen: false).getAllVehicles();
      if(!Provider.of<PermissionProvider>(context, listen: false).allPermissionsGranted
          && Provider.of<PermissionProvider>(context, listen: false).checkedAllPermissions){
        Navigator.pushNamed(context, AppRouter.permission);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN'),
        actions: [
          Icon(Icons.logout, color: context.color.error)
              .paddingOnly(right: 8)
              .inkWell(onTap: ()=> showLogoutPopUpDialog(context))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavList,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (value)=> onItemTapped(value),
      ),
      body: IndexedStack(index: selectedIndex, children:pages),
    );
  }
}
