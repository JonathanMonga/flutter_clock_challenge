// Copyright 2019 Jonathan Monga. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class RowTextWidget extends StatelessWidget {
  const RowTextWidget(
      {Key key,
      this.hour,
      this.minute,
      this.amPmFlag,
      this.style,
      this.amPmFlagFontSize})
      : super(key: key);

  final String hour;
  final String minute;
  final String amPmFlag;
  final TextStyle style;
  final double amPmFlagFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            amPmFlag,
            style: style.copyWith(fontSize: amPmFlagFontSize),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(hour, style: style),
              Text(":", style: style),
              Text(minute, style: style),
            ],
          ),
        )
      ],
    );
  }
}
