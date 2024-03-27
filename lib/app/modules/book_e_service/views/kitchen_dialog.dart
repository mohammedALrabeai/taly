import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/kitchen.dart';
import '../controllers/book_e_service_controller.dart';

class KitchenDialog extends GetView<BookEServiceController> {
  const KitchenDialog( {Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Obx(
      ()=> SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  right: 12, left: 12, top: 6, bottom: 6),
              decoration: BoxDecoration(
                borderRadius:
                const BorderRadius.all(const Radius.circular(5)),
                color: Get.theme.focusColor.withOpacity(0.1),
              ),
              child: Obx(
                  ()=> Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: dropKitchen(
                      controller.kitchens.value,
                      controller.selectedKitchen.value, (value) {
                    controller.oneCart3.forEach((element) { element.withcook=false;});
                    controller.selectedKitchen.value=value;
                    controller.selectedKitchen.refresh();
                    controller.oneCart3.refresh();
                  }),
                ),
              ),
            ),

            ...controller.oneCart3.map((element) {
          var kitchen=    controller.getKitchen(element);
              return CheckboxListTile(value: element.withcook,
                    onChanged:kitchen==0.0?null: (value){
                      element.withcook=value;
                      element.cook_price=kitchen;
                      controller.oneCart3.refresh();
                    },
                title: Text("${element.food_name}" +" "+ (element.part_id !=
                    null &&
                    element.part_id !=
                        "null" &&
                    element.part_id !=
                        "0"? "${element.part_name}": "")),
                  controlAffinity: ListTileControlAffinity.leading,
               subtitle:kitchen==0.0?Text("غير متوفر"):Text("سعر الطبخ : "+" "+kitchen.toString()) ,
                 secondary: kitchen==0.0
                      ? Icon(Icons.block, color: Colors.grey)
                      : null,
                );})

          ],
        ),
      ),
    );
  }
}
dropKitchen(List<Kitchen> items, Kitchen selectedValue, Function(Kitchen) onChang) {
  return DropdownButtonHideUnderline(
    child: DropdownButton2(
      isExpanded: true,
      hint: Row(
        children: const [
          Icon(
            Icons.place,
            size: 16,
            color: Colors.red,
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              'Select Place',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      items: items
          .map((item) => DropdownMenuItem<Kitchen>(
        value: item,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0.0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          leading: Icon(Icons.location_on_sharp),
        ),
      ))
          .toList(),
      value: selectedValue.hasData ? selectedValue : null,
      onChanged: (value) {
        onChang(value);
        // setState(() {
        //   selectedValue = value as String;
        // });
      },
      icon: const Icon(
        Icons.arrow_drop_down,
      ),
      iconSize: 14,
      iconEnabledColor: Colors.indigo,
      iconDisabledColor: Colors.grey,
      buttonHeight: 70,
      // buttonWidth: 120,
      buttonPadding: const EdgeInsets.only(left: 0, right: 0),
      buttonDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black26,
        ),
        color: Colors.transparent,
      ),
      buttonElevation: 0,
      itemHeight: 50,
      itemPadding: const EdgeInsets.only(left: 0, right: 2),
      dropdownMaxHeight: 300,
      dropdownWidth: 400,
      dropdownPadding: null,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Get.theme.cardColor,
      ),
      dropdownElevation: 8,
      scrollbarRadius: const Radius.circular(40),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
      offset: const Offset(-20, 0),
    ),
  );
}