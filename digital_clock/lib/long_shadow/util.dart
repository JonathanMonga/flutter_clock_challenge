// Copyright 2019 Jonathan Monga. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

////A point representing the x and y distance to a point.
Point delta(Point _position, Point point) =>
    Point(point.x - _position.x, point.y - _position.y);
