import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/extensions/custom_widgets.dart';
import 'package:ghanta_gadi/core/extensions/padding.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/core/widgets/live_map.dart';
import 'package:ghanta_gadi/core/widgets/show_toast.dart';
import 'package:ghanta_gadi/data/repositories/user_repository.dart';
import 'package:ghanta_gadi/data/services/firestore_service.dart';
import 'package:provider/provider.dart' show Provider, Consumer;

import '../../core/constant/dimension_constant.dart';
import '../../core/constant/sf_constant.dart';
import '../../core/helper/sf_helper.dart';
import '../../core/widgets/logout_popup.dart';
import '../../data/services/location_service.dart';
import '../../models/place_suggestion.dart';
import '../../providers/map_provider.dart';
import '../../providers/permission_provider.dart';
import '../../providers/user_provider.dart';
import '../../routes.dart';

class CitizenHome extends StatefulWidget {
  const CitizenHome({super.key});

  @override
  State<CitizenHome> createState() => _CitizenHomeState();
}

class _CitizenHomeState extends State<CitizenHome> {
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MapProvider>(
        context,
        listen: false,
      ).listenToWardVehiclesLocation();
      if (!Provider.of<PermissionProvider>(
            context,
            listen: false,
          ).allPermissionsGranted &&
          Provider.of<PermissionProvider>(
            context,
            listen: false,
          ).checkedAllPermissions) {
        Navigator.pushNamed(context, AppRouter.permission);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CITIZEN').inkWell(
          onTap: () async {
            final position = await LocationService().getCurrentPosition();
            final uId = await SFHelper.get(SfConstant.uId);
            await UserRepository(FirestoreService()).saveUserHomeLocation(
              userId: uId!,
              lat: position?.latitude ?? 0.0,
              lng: position?.longitude ?? 0.0,
            );
          },
        ),
        actions: [
          Icon(Icons.pin_drop_outlined)
              .paddingOnly(right: 16)
              .inkWell(onTap: () => showHomeLocationDialog(context)),
          Icon(Icons.logout, color: context.color.error)
              .paddingOnly(right: 8)
              .inkWell(onTap: () => showLogoutPopUpDialog(context)),
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
              onTap: () {
                Navigator.pushNamed(context, AppRouter.addFeedback);
              },
              child: Container(
                padding: DimensionConstant.edgeInsetH10V10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: context.color.scrim,
                ),
                child: Icon(
                  Icons.add_comment_outlined,
                  size: 28,
                  color: context.color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showHomeLocationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Home Location"),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Container(
            width: context.mqWidth * 0.5,
            decoration: BoxDecoration(
              color: context.color.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          hintText: "Enter location",
                        ),
                      ),
                    ),
                    Icon(Icons.search).inkWell(
                      onTap: () async {
                        await Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).searchPlaces(_locationController.text.trim());
                      },
                    ),
                  ],
                ).paddingSymmetric(
                  edgeInsets: DimensionConstant.edgeInsetH20V20,
                ),
                Consumer<UserProvider>(
                  builder: (_, provider, _) {
                    if (provider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (provider.errorMessage != null) {
                      return Text(provider.errorMessage!,
                          style: TextStyle(color: Colors.red));
                    }

                    if (provider.suggestions.isEmpty) {
                      return Text("No results");
                    }
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.suggestions.length,
                        itemBuilder: (_, index) {
                          final PlaceSuggestion place =
                          provider.suggestions[index];
                          return ListTile(
                            title: Text(place.displayName),
                            onTap: () {
                              provider.selectSuggestedPlace(place);
                              _locationController.text = place.displayName;
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    Container(
                          padding: DimensionConstant.edgeInsetV10,
                          margin: DimensionConstant.edgeInsetH10V5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: context.color.outline,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'CANCEL',
                            style: context.text.titleSmall!.copyWith(
                              color: context.color.tertiary,
                            ),
                          ),
                        )
                        .inkWell(onTap: () => Navigator.pop(context))
                        .expanded(flex: 1),
                    Container(
                      padding: DimensionConstant.edgeInsetV10,
                      margin: DimensionConstant.edgeInsetH10V5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: context.color.outline,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'SAVE',
                        style: context.text.titleSmall!.copyWith(
                          color: context.color.primary,
                        ),
                      ),
                    ).inkWell(onTap: () {
                      Provider.of<UserProvider>(context, listen: false).saveHomeLocation().then((value){
                        if(value){
                          showCustomToast("Home location updated successfully", context, isError: false);
                        }else{
                          showCustomToast("Home location failed to update", context);
                        }
                        Navigator.pop(context);
                      });
                    }).expanded(flex: 1),
                  ],
                ).paddingSymmetric(
                  edgeInsets: DimensionConstant.edgeInsetH15V15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}