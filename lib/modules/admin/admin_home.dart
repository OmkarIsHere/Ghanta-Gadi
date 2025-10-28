import 'package:flutter/material.dart';
import 'package:ghanta_gadi/modules/admin/driver_list.dart';
import 'package:ghanta_gadi/modules/admin/feedback_list.dart';
import 'package:ghanta_gadi/core/widgets/live_map.dart';
import 'package:ghanta_gadi/providers/map_provider.dart';
import 'package:ghanta_gadi/providers/user_provider.dart' show UserProvider;
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int selectedIndex = 0;
  final pages = [LiveMap(), DriverList(), FeedbackList()];
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
      Provider.of<UserProvider>(context, listen: false).getAllDrivers();
      Provider.of<MapProvider>(context, listen: false).listenToVehiclesLocation();
    });
  }

  @override
  void dispose() {
    context.read<MapProvider>().stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavList,
        currentIndex: selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (value)=> onItemTapped(value),
      ),
      body: IndexedStack(index: selectedIndex, children:pages),
    );
  }
}
