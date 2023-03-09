/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';

import '../../../../common/ui.dart';

class EServiceTilWidget extends StatelessWidget {
  final Widget title;
  final bool decore;
  final Widget content;
  final List<Widget> actions;
  final double horizontalPadding;

  const EServiceTilWidget({Key key, this.title, this.content,this.decore=true, this.actions, this.horizontalPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20, vertical: 5),
      decoration:decore? Ui.getBoxDecoration():null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: title),
              if (actions != null)
                Wrap(
                  children: actions,
                )
            ],
          ),
          Divider(
            height: 26,
            thickness: 1.2,
          ),
          content,
        ],
      ),
    );
  }
}
