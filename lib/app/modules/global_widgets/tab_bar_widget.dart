/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarController extends GetxController {
  RxString selectedId;

  @override
  void onInit() {
    super.onInit();
  }

  TabBarController() {
    selectedId = RxString("");
  }

  bool isSelected(dynamic tabId) => selectedId.value == tabId.toString();

  void toggleSelected(
    dynamic tabId,
  ) {
    if (!isSelected(tabId)) {
      selectedId.value = tabId.toString();
    }
  }
}

class TabBarWidget extends StatelessWidget implements PreferredSize {
  TabBarWidget({Key key, @required this.tag, @required this.tabs, @required this.initialSelectedId}) {
    tabs[0] = Padding(padding: EdgeInsetsDirectional.only(start: 15), child: tabs.elementAt(0));
    tabs[tabs.length - 1] = Padding(padding: EdgeInsetsDirectional.only(end: 15), child: tabs[tabs.length - 1]);
  }

  final String tag;
  final dynamic initialSelectedId;
  final List<Widget> tabs;

  Widget buildTabBar() {
    final controller = Get.put(TabBarController(), tag: tag, permanent: true);
    if (controller.selectedId.firstRebuild) {
      controller.selectedId.value = initialSelectedId.toString();
    }
    return Container(
      alignment: AlignmentDirectional.centerStart,
      height: 60,
      child: ListView(primary: false, shrinkWrap: true, scrollDirection: Axis.horizontal, children: tabs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTabBar();
  }

  @override
  Widget get child => buildTabBar();

  @override
  Size get preferredSize => new Size(Get.width, 60);
}

class TabBarLoadingWidget extends StatelessWidget implements PreferredSize {
  Widget buildTabBar() {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      height: 60,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: List.generate(
          4,
          (index) => RawChip(
            elevation: 0,
            label: Text(''),
            padding: EdgeInsets.symmetric(horizontal: 20.0 * (index + 1), vertical: 15),
            backgroundColor: Get.theme.focusColor.withOpacity(0.1),
            selectedColor: Get.theme.accentColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            showCheckmark: false,
            pressElevation: 0,
          ).marginSymmetric(horizontal: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTabBar();
  }

  @override
  Widget get child => buildTabBar();

  @override
  Size get preferredSize => new Size(Get.width, 60);
}

class ChipWidget extends StatelessWidget {
  ChipWidget({
    Key key,
    @required this.text,
    this.onSelected,
    this.hightt,
    this.dark=false,
    @required this.tag,
    @required this.id,
  }) : super(key: key);

  final String text;
  final double hightt;
  final bool dark;
  final dynamic id;
  final String tag;
  final ValueChanged<dynamic> onSelected;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabBarController(), tag: tag, permanent: true);
    return Obx(() {
      return RawChip(
        elevation: 0,
        label: Text(text),
        labelStyle: controller.isSelected(this.id) ?(dark)?Get.textTheme.bodyText2.merge(TextStyle(color: Colors.white)) : Get.textTheme.bodyText2.merge(TextStyle(color: Colors.black)) : (dark)?Get.textTheme.bodyText2.merge(TextStyle(color: Colors.black)) : Get.textTheme.bodyText2,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        backgroundColor:(dark)?Get.theme.primaryColor.withOpacity(0.4): Get.theme.focusColor.withOpacity(0.1),
        selectedColor: (dark)?Get.theme.accentColor.withOpacity(1):Get.theme.primaryColor.withOpacity(0.6),
        selected: controller.isSelected(this.id),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        showCheckmark: false,
        pressElevation: 0,
        onSelected: (bool value) {
          controller.toggleSelected(this.id);
          onSelected(id);
        },
      ).marginSymmetric(horizontal: 5);
    });
  }
}