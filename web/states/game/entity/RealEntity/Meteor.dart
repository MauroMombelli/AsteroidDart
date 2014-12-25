library meteor;

import 'package:play_phaser/phaser.dart';
import '../../GameState.dart';

class Meteor {
  GameState game;
  
  bool alive;
  Sprite shadow;
  Sprite tank;
  int size;
  
  Meteor(int index, GameState game, int size, num x, num y) {
    this.game = game;
    this.alive = true;
    this.shadow = game.add.sprite(x, y, 'enemy', 'shadow');
    this.tank = game.add.sprite(x, y, 'enemy', 'tank1');
    this.size = size;
    
    this.shadow.anchor.set(0.5);
    this.tank.anchor.set(0.5);
    
    game.physics.enable(this.tank, Physics.ARCADE);
    this.tank.body.immovable = false;
    this.tank.body.collideWorldBounds = true;
    this.tank.body.bounce.setTo(1, 1);
    this.tank.angle = game.rnd.angle();
    
    this.tank.name = index.toString();
    game.physics.arcade.velocityFromRotation(this.tank.rotation, 100, this.tank.body.velocity);
  }
  
  damage(explosions) {
    this.shadow.kill();
    this.tank.kill();
    this.alive = false;
    
    game.addExplosion(tank.x,  tank.y);
    
    size--;
    if (size > 0){
      game.addMeteor(size, tank.x, tank.y);
      game.addMeteor(size, tank.x, tank.y);
    }
  }
  
  update() {
    this.shadow.x = this.tank.x;
    this.shadow.y = this.tank.y;
    this.shadow.rotation = this.tank.rotation;
  }

}