import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../color_constants.dart';


class LocationWidget extends StatelessWidget{
  LocationWidget({Key? key,
    required this.regionName,
    required this.selected,
  }) : super(key: key);

  final String regionName;
  final bool selected;



  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black38, width: 0.5)),
            //border: selected? Border.all(color: interfaceColor,width: 2) : null,
            //borderRadius: const BorderRadius.all(Radius.circular(10))

        ),
        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              selected? const Icon(FontAwesomeIcons.dotCircle, color: interfaceColor,): const Icon(FontAwesomeIcons.circle),

              SizedBox(

                  //height: 40,
                  width: Get.width/2.5,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(regionName, style: Get.textTheme.headlineMedium?.merge(const TextStyle(fontSize: 13, color: buttonColor)), overflow: TextOverflow.ellipsis,)
                        )
                      ]
                  )
              )
            ]
        ).paddingOnly(left: 10, right: 10)
    );
  }
}