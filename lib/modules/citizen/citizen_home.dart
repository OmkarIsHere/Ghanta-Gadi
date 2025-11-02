import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/extensions/custom_widgets.dart';
import 'package:ghanta_gadi/core/extensions/padding.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/core/widgets/live_map.dart';
import 'package:ghanta_gadi/data/repositories/user_repository.dart';
import 'package:ghanta_gadi/data/services/firestore_service.dart';
import 'package:provider/provider.dart' show Provider;

import '../../core/constant/dimension_constant.dart';
import '../../core/constant/sf_constant.dart';
import '../../core/helper/sf_helper.dart';
import '../../core/widgets/logout_popup.dart';
import '../../data/services/location_service.dart';
import '../../providers/map_provider.dart';
import '../../providers/permission_provider.dart';
import '../../routes.dart';

class CitizenHome extends StatefulWidget {
  const CitizenHome({super.key});

  @override
  State<CitizenHome> createState() => _CitizenHomeState();
}

class _CitizenHomeState extends State<CitizenHome> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MapProvider>(context, listen: false).listenToWardVehiclesLocation();
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
        title: Text('CITIZEN').inkWell(onTap: ()async{
          final position = await LocationService().getCurrentPosition();
          final uId = await SFHelper.get(SfConstant.uId);
          await UserRepository(FirestoreService()).saveUserHomeLocation(
              userId:uId!,
              lat: position?.latitude?? 0.0,
              lng: position?.longitude?? 0.0);
        }),
        actions: [
          Icon(Icons.logout, color: context.color.error)
              .paddingOnly(right: 8)
              .inkWell(onTap: ()=> showLogoutPopUpDialog(context))
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: context.mqWidth,
            height: context.mqHeight,
            child: LiveMap(),
          ),
          Positioned(
            right: 15,
            bottom: 15,
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(
                    context,
                    AppRouter.addFeedback);
              },
              child: Container(
                padding: DimensionConstant.edgeInsetH10V10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: context.color.scrim,
                ),
                child: Icon(Icons.add_comment_outlined, size: 28, color: context.color.primary),
              ),
            ),
          )
        ],
      ),
    );
  }
}
