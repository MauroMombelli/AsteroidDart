// Copyright (c) 2014, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import "dart:html" as dom;
import "package:play_phaser/phaser.dart";
import 'states/game/GameState.dart';


main() {
  Game game = new Game(1024, 768, WEBGL, 'phaser-example', new GameState());
}
