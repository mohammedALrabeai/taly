// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../models/products_model.dart';
import '../../routes/app_routes.dart';
import 'single_item_grid.dart';

class GridItemView extends StatefulWidget {
  List<Product> products;
  // ignore: use_key_in_widget_constructors
  GridItemView(this.products);

  @override
  State<GridItemView> createState() => _GridItemViewState();
}

class _GridItemViewState extends State<GridItemView> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true ,
      children: widget.products.map(
        (product) {
          return GestureDetector(
            onTap: () =>Get.toNamed(Routes.PRODUCT_Details,arguments: product),
            // onTap: () =>log(product.cuts?.length?.toString()??null),
              child: SingleItemGridView(
                name: product.name,
                id: product.id,
                price: product.parts.first.price.toDouble(),
                previousPrice: product.parts.first.price.toDouble(),
                imageUrl: product.img,
                product: product,
              ),
          );
        },
      ).toList(),
    );
  }
}
