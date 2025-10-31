import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/constant/asset_constant.dart';
import 'package:ghanta_gadi/core/constant/dimension_constant.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/core/misc/enum.dart';
import 'package:ghanta_gadi/core/widgets/loader.dart';
import 'package:ghanta_gadi/core/widgets/show_toast.dart';
import 'package:ghanta_gadi/providers/user_provider.dart';
import 'package:provider/provider.dart' show Consumer;

import '../../core/widgets/my_divider.dart';
import '../../routes.dart';

class DriverList extends StatelessWidget {
  const DriverList({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: context.mqHeight,
          width: context.mqWidth,
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              if(userProvider.loadState == LoadState.LOADED) {
                return ListView.separated(
                  itemCount: userProvider.drivers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: RichText(
                          text: TextSpan(
                            text: 'Name: ',
                            style: context.text.titleSmall,
                            children: [
                              TextSpan(
                                text: userProvider.drivers[index].name,
                                style: context.text.labelMedium,
                              )
                            ]
                          )
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'Location: ',
                                  style: context.text.titleSmall,
                                  children: [
                                    TextSpan(
                                      text:  "${userProvider.drivers[index].ward}, ${userProvider.drivers[index].city}",
                                      style: context.text.labelMedium,
                                    )
                                  ]
                              )
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Contact: ',
                                  style: context.text.titleSmall,
                                  children: [
                                    TextSpan(
                                      text: '${userProvider.drivers[index].phone} | ${userProvider.drivers[index].email}',
                                      style: context.text.labelMedium,
                                    )
                                  ]
                              )
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return MyDivider(
                        color: context.color.outline, thickness: 1);
                  },
                );
              }else if(userProvider.loadState == LoadState.LOADING){
                return loader();
              }else{
                return showBasicToast("Something Went Wrong", context);
              }
            },
          ),
        ),
        Positioned(
          right: 15,
          bottom: 15,
          child: GestureDetector(
            onTap: (){
              Navigator.pushNamed(
                  context,
                  arguments: {
                    'name': AssetConstant.addDriver,
                  },
                  AppRouter.createUser);
            },
            child: Container(
              padding: DimensionConstant.edgeInsetH10V10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: context.color.scrim,
              ),
                child: Icon(Icons.add, size: 28, color: context.color.primary),
            ),
          ),
        )
      ],
    );
  }
}
