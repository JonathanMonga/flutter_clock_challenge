// Copyright 2019 Jonathan Monga. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class RowTextShadowWidget extends StatelessWidget {
  const RowTextShadowWidget(
      {Key key,
      this.hour,
      this.minute,
      this.amPmFlag,
      this.style,
      this.amPmFlagFontSize,
      this.shadows})
      : super(key: key);

  final String hour;
  final String minute;
  final String amPmFlag;
  final TextStyle style;
  final double amPmFlagFontSize;
  final List<Shadow> shadows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            amPmFlag,
            style: style.copyWith(fontSize: amPmFlagFontSize, shadows: shadows),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(hour, style: style.copyWith(shadows: shadows)),
              Text(":", style: style.copyWith(shadows: shadows)),
              Text(minute, style: style.copyWith(shadows: shadows)),
            ],
          ),
        ),
      ],
    );
  }
}
