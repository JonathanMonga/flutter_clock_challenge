// Copyright 2019 Jonathan Monga. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'dart:math' as math;
import 'dart:ui';

import 'package:digital_clock/long_shadow/config.dart';
import 'package:digital_clock/long_shadow/light.dart';
import 'package:digital_clock/long_shadow/util.dart' as util;
import 'package:flutter/material.dart';

class ShadowController {
  final Rect rectangle;
  Point _position;

  ShadowController(this.rectangle) : assert(rectangle != null) {
    _position = Point(rectangle.left + rectangle.width * 0.5,
        rectangle.top + rectangle.height * 0.5);
  }

  ///Draw this shadow with based on a light source
  Future<List<Shadow>> generateLongShadow(Light light, Config config) async {
    Point delta = util.delta(_position, light.position);
    double distance = math.sqrt(delta.x * delta.x + delta.y * delta.y);
    distance = math.max(32, distance); // keep a min amount of shadow

    return List<Shadow>.generate(config.numSteps, (int index) {
      double ratio = index / config.numSteps;

      double ratioOpacity = math.pow(ratio, config.opacityPow);
      double ratioOffset = math.pow(ratio, config.offsetPow);
      double ratioBlur = math.pow(ratio, config.blurPow);

      double opacity =
          light.intensity * math.max(0, config.opacity * (1.0 - ratioOpacity));
      double offsetX = -config.offset * delta.x * ratioOffset;
      double offsetY = -config.offset * delta.y * ratioOffset;
      double blurRadius = distance * config.blur * ratioBlur / 512;

      return _getShadow(
          config.shadowRGB, opacity, offsetX, offsetY, blurRadius);
    });
  }

  Shadow _getShadow(Color shadowRGB, double opacity, double offsetX,
      double offsetY, double blurRadius) {
    return Shadow(
      blurRadius: blurRadius,
      color: shadowRGB.withOpacity(opacity),
      offset: Offset(offsetX, offsetY),
    );
  }
}
