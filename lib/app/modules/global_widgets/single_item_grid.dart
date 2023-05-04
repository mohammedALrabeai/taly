import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/products_model.dart';

class SingleItemGridView extends StatefulWidget {
  final String name;
  final String id;
  final double price;
  final double previousPrice;
  final String imageUrl;
  final Product product;

  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  SingleItemGridView({
    @required this.name,
    @required this.id,
    @required this.price,
    @required this.imageUrl,
    @required this.previousPrice,
    @required this.product,
  });

  @override
  State<SingleItemGridView> createState() => _SingleItemGridViewState();
}

class _SingleItemGridViewState extends State<SingleItemGridView> {
  @override
  Widget build(BuildContext context) {
    void toggleAddToCart() {
      setState(() {
        // cartData.addItemToCart(
        //   widget.id,
        //   widget.name,
        //   widget.price,
        //   widget.previousPrice,
        //   widget.imageUrl,
        // );
      });
    }

    // ignore: sized_box_for_whitespace
    return Hero(
      tag: widget.product.id,
      child: Container(
        height: 95,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              // bottomRight: Radius.circular(25),
              // topLeft: Radius.circular(25),
            ),
          ),
          color: Colors.white,
          elevation: 5,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        height: 120,
                        // cacheHeight: 120,
                        width: double.infinity,

                        placeholder: (context, url) =>
                            CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )

                      // Image.network(
                      //   widget.imageUrl,
                      //   alignment: Alignment.center,
                      //   fit: BoxFit.cover,
                      //   height: 120,
                      //   cacheHeight: 120,
                      //   width: double.infinity,
                      // ),
                      ),
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        children: [
                          // IconButton(
                          //   icon: Icon(
                          //     productData.isItemOnFavorite(widget.product)
                          //         ? CupertinoIcons.heart_fill
                          //         : CupertinoIcons.heart,
                          //     color: Colors.deepOrange,
                          //   ),
                          //   onPressed: () => setState(
                          //     () {
                          //       productData.toggleItemtoFavirite(widget.product);
                          //     },
                          //   ),
                          // ),
                          // IconButton(
                          //   icon: Icon(
                          //     cartData.isItemOnCart(widget.id)
                          //         ? Icons.shopping_cart
                          //         : Icons.add_shopping_cart_sharp,
                          //     color: Colors.deepOrange,
                          //   ),
                          //   onPressed: () => {
                          //     toggleAddToCart(),
                          //     ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //         duration: const Duration(seconds: 2),
                          //         elevation: 5,
                          //         padding: const EdgeInsets.all(5),
                          //         backgroundColor: Colors.grey,
                          //         content: Text(
                          //           cartData.isItemOnCart(widget.id)
                          //               ? 'Added ${widget.name} To Cart!'
                          //               : 'Removed ${widget.name} From Cart!',
                          //           style: const TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //               color: Colors.white),
                          //           textAlign: TextAlign.center,
                          //         ),
                          //         action: SnackBarAction(
                          //           textColor: Colors.deepOrange,
                          //           label: 'UNDO',
                          //           onPressed: () {
                          //             toggleAddToCart();
                          //           },
                          //         ),
                          //       ),
                          //     )
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 1,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.price.toString()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          "default_currency".tr,
                          style: const TextStyle(
                            // decoration: TextDecoration.lineThrough,
                            fontSize: 11,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
