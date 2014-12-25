// Copyright (c) 2014, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import "dart:html" as dom;
import "package:play_phaser/phaser.dart";
import 'states/game/GameState.dart';
import 'dart:html';


main() {
  num x = window.innerHeight-100;
  num y = window.innerWidth-100;
  Game game = new Game(y, x, WEBGL, 'phaser-example', new GameState());
}
