import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../../services/auth_service.dart';
// import '../../global_widgets/search_bar_widget.dart';


class WelcomeWidget extends StatelessWidget {
  final text;

  WelcomeWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.grey.withOpacity(0.8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 3,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("$text", style: Get.textTheme.bodyText2.merge(TextStyle(color: Colors.white,fontSize: 19))),
                // Text(Get.find<AuthService>().user.value.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.primaryColor))),
                // Text('!', style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.primaryColor)))
              ],
            ),
            // SizedBox(height: 8),
            // Text("Can I help you something?".tr, style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
            // SizedBox(height: 22),
            // SearchBarWidget()
          ],
        ),
      ),
    );
  }
}
