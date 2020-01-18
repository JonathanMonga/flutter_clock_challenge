// Copyright 2019 Jonathan Monga. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'dart:math' as math;
import 'dart:math';

import 'package:digital_clock/row_text.dart';
import 'package:digital_clock/long_shadow/config.dart';
import 'package:digital_clock/long_shadow/light.dart';
import 'package:digital_clock/long_shadow/shadow_controller.dart';
import 'package:digital_clock/row_text_shadow.dart';
import 'package:digital_clock/hex.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element { background, text, shadow }

final _lightTheme = {
  _Element.background: Hex.stringToColor("2bcac6"),
  _Element.text: Hex.stringToColor("ffffff"),
  _Element.shadow: Hex.stringToColor("143282")
};

final _darkTheme = {
  _Element.background: Hex.stringToColor("143212"),
  _Element.text: Hex.stringToColor("faa12d"),
  _Element.shadow: Hex.stringToColor("000000")
};

/// Shadow configuration
final _config = Config(
  numSteps: 300,
  opacity: 1.0,
  opacityPow: 1.0,
  offset: 1.0,
  offsetPow: 1.15,
  blur: 1,
  blurPow: 1.0,
  shadowRGB: Hex.stringToColor("143282"),
);

/// A shadow digital clock.
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    final size = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    final amPmFlag = !widget.model.is24HourFormat
        ? DateFormat('aaa').format(_dateTime).toLowerCase()
        : " ";

    final fontSize = width / 3.5;
    final amPmFlagFontSize = widget.model.is24HourFormat ? 0.0 : width / 8.5;

    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'MuseoModerno',
      fontSize: fontSize,
    );

    return Container(
      color: colors[_Element.background],
      width: width,
      height: height,
      child: ClipRect(
        child: FutureBuilder(
          future: ShadowController(
            Rect.fromCenter(
                center: (Offset.zero & size).center,
                width: width,
                height: height),
          ).generateLongShadow(
            Light(
                position: Point(
                    calculateSunPositionX(0.0, _dateTime, width, height),
                    calculateSunPositionY(0.0, _dateTime, width, height))),
            _config.copyWith(shadowRGB: colors[_Element.shadow]),
          ),
          builder: (BuildContext context,
              AsyncSnapshot<List<Shadow>> asyncSnapshot) {
            return Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                RowTextShadowWidget(
                  hour: hour,
                  minute: minute,
                  amPmFlag: amPmFlag,
                  style: defaultStyle,
                  amPmFlagFontSize: amPmFlagFontSize,
                  shadows: asyncSnapshot?.data ?? [],
                ),
                RowTextWidget(
                  hour: hour,
                  minute: minute,
                  amPmFlag: amPmFlag,
                  style: defaultStyle,
                  amPmFlagFontSize: amPmFlagFontSize,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  /// This method calculate the sun position in x
  double calculateSunPositionX(
      double _offset, DateTime time, double width, double height) {
    return ((width / 2 +
        (width / 2 + width) *
            math.cos(
                (2 * math.pi * time.minute / 60) + _offset - math.pi / 2)));
  }

  /// This method calculate the sun position in y
  double calculateSunPositionY(
      double _offset, DateTime time, double width, double height) {
    return (height / 2 +
        (width / 2 + width) *
            math.sin((2 * math.pi * time.minute / 60) + _offset - math.pi / 2));
  }
}
