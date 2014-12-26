// Copyright (c) 2014, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import "dart:html" as dom;
import "package:play_phaser/phaser.dart";

import 'dart:html';

import 'states/menu_main/MainMenuState.dart';
import 'states/game/GameState.dart';
import 'states/death/DeathState.dart';


main() {
  num x = window.innerHeight-100;
  num y = window.innerWidth-100;
  
  Game game = new Game(y, x, WEBGL, 'phaser-example');
  game.state.add("Game", new GameState());
  game.state.add("Death", new DeathState());
  game.state.add("MainMenu", new MainMenuState());
  
  game.state.start("MainMenu");
}
