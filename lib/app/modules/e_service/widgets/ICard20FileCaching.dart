import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/common/ui.dart';

//
// 02.10.2020 rtl
// 11.10.2020 radius and shadow
// 11.10.2020 callback add string image
//

class ICard20FileCaching extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;
  final TextDirection direction;
  final double width;
  final double height;
  final String text;
  final String cost;
  final String old;
  final String text2;
  final String text3;
  final String image;
  final Color colorRoute;
  final String id;
  final TextStyle title;
  final TextStyle body;
  final Function(BuildContext context,String id, String hero, String) callback;
  final Function(String id) callbackNavigateIcon;
  final double radius;
  final int shadow;

  ICard20FileCaching({
    this.color = Colors.white,
    this.cost,
    this.old,
    this.width = 100,
    this.height ,
    this.colorProgressBar = Colors.black,
    this.text = "",
    this.text2 = "",
    this.image = "",
    this.colorRoute = Colors.black,
    this.id = "",
    this.title,
    this.body,
    this.callback,
    this.callbackNavigateIcon,
    this.text3 = "",
    this.direction,
    this.radius,
    this.shadow,
  });

  @override
  _ICard20FileCachingState createState() => _ICard20FileCachingState();
}

class _ICard20FileCachingState extends State<ICard20FileCaching> {
  var _titleStyle = TextStyle(fontSize: 16);
  var _bodyStyle = TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.title != null) _titleStyle = widget.title;
    if (widget.body != null) _bodyStyle = widget.body;
    return Container(
        margin: EdgeInsets.only(left: 5, top: 0, bottom: 0, right: 5),
        width: widget.width /*- 10 + 2*/,
        // height: widget.height - 0,
        decoration: BoxDecoration(
            color: widget.color,
            // border: Border.all(color: Colors.black.withAlpha(100)),
            borderRadius: new BorderRadius.circular(widget.radius),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withAlpha(widget.shadow),
            //     spreadRadius: 2,
            //     blurRadius: 4,
            //     offset: Offset(5, 7), // changes position of shadow
            //   ),
            // ]
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: InkWell(
                        onTap: () {
                          if (widget.callback != null)
                            widget.callback(context,widget.id, _id, widget.image);
                        }, // needed
                        child: Hero(
                            tag: _id,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),

                              ),
                              width: widget.width ,
                              // height: widget.height,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(widget.radius),
                                    topRight: Radius.circular(widget.radius),
                                    bottomLeft: Radius.circular(widget.radius),
                                    bottomRight: Radius.circular(widget.radius)),

                                child: Container(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        CupertinoActivityIndicator(),
                                    imageUrl: widget.image,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  ),
                                ),
                              ),
                            )))),
              ],
            ),
            Padding(
              // padding: EdgeInsets.only(top: widget.height - 60),
              padding: EdgeInsets.only(top:  160),
              child: InkWell(
                  onTap: () {
                    if (widget.callback != null)
                      widget.callback(context,widget.id, _id, widget.image);
                  }, // needed
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                          color: Get.theme.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                color: Get.theme.focusColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5)),
                          ],
                          // border: Border.all(
                          //     color: Get.theme.focusColor.withOpacity(0.05)),

                          gradient: LinearGradient(
                              colors: [
                                Get.theme.accentColor.withAlpha(50),
                                Get.theme.primaryColor,
                                Get.theme.primaryColor
                              ],
                              begin: AlignmentDirectional.topCenter,
                              //const FractionalOffset(1, 0),
                              end: AlignmentDirectional.bottomCenter,
                              stops: [0.1,0.5, 1],
                              tileMode: TileMode.clamp)),
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Container(
                        alignment: Alignment.center,
                          width: widget.width - 50,
                          child: Text(
                            "${widget.text2}",
                            maxLines: 3,
                            style:_titleStyle,// _bodyStyle,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          )))),
            ),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child:
// Ui().discountSticker(widget.width-10+2, widget.cost, widget.old, widget.cost),),

//              if (widget.direction == TextDirection.ltr)
//                UnconstrainedBox(
//                    child: Container(
//                        margin: EdgeInsets.only(left: widget.width-70, top: widget.height-50),
//                        height: 40,
//                        width: 40,
//                        child: _route()
//                    )),
//
//              if (widget.direction == TextDirection.rtl)
//                UnconstrainedBox(
//                    child: Container(
//                        margin: EdgeInsets.only(right: widget.width-70, top: widget.height-55),
//                        height: 40,
//                        width: 40,
//                        child: _route()
//                    )),
          ],
        ));
  }

  _route() {
    return Stack(
      children: <Widget>[
        // Image.asset("assets/img/route.png",
        //   fit: BoxFit.cover, color: widget.colorRoute,
        // ),
        // Icon(Icons.shopping_cart),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  if (widget.callbackNavigateIcon != null)
                    widget.callbackNavigateIcon(widget.id);
                }, // needed
              )),
        )
      ],
    );
  }
}
