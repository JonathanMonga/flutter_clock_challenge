// Copyright 2019 Jonathan Monga. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class Hex {
  //Hex Number To Color
  static Color _intToColor(int hexNumber) => Color.fromARGB(
      255,
      (hexNumber >> 16) & 0xFF,
      ((hexNumber >> 8) & 0xFF),
      (hexNumber >> 0) & 0xFF);

  //String To Hex Number
  static Color stringToColor(String hex) =>
      _intToColor(int.parse(hex, radix: 16));
}
