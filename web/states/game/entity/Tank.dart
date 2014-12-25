library tank;

import 'package:play_phaser/phaser.dart';

class Tank {
  Game game;
  int health = 3;
  Group bullets;
  num fireRate;
  num nextFire;
  bool alive;
  Sprite shadow;
  Sprite tank;
  Sprite turret;
  
  Tank(num x, num y, var name, Game game, Group bullets) {
    this.game = game;
    this.health = 1;
    this.bullets = bullets;
    this.fireRate = 1000;
    this.nextFire = 0;
    this.alive = true;
    
    //create shadow
    this.shadow = game.add.sprite(x, y, 'tank', 'shadow');
    //then the tank body
    this.tank = game.add.sprite(x, y, 'tank', 'tank1');
    //and finally the turret
    this.turret = game.add.sprite(x, y, 'tank', 'turret');
    
    //now we have the spite in right Z-order, place then inthe right relative XY posisition
    this.shadow.anchor.set(0.5);
    this.tank.anchor.set(0.5);
    this.turret.anchor.set(0.3, 0.5);
    
    //add the moving animation
    tank.animations.add('move', ['tank1', 'tank2', 'tank3', 'tank4', 'tank5', 'tank6'], 20, true);
    
    tank.name = name;
    
    game.physics.enable(tank, Physics.ARCADE);
    tank.body.maxVelocity.setTo(400, 400);
    tank.body.drag.set(0);
    tank.body.collideWorldBounds = true;
    tank.body.immovable = false;
    tank.body.bounce.setTo(1, 1);
    
    //force correct display
    tank.bringToTop();
    turret.bringToTop();
  }
  
  damage() {
    this.health -= 1;
    if (this.health <= 0) {
      this.shadow.kill();
      this.tank.kill();
      this.turret.kill();
      this.alive = false;
      return true;
    }
    return false;
  }
  
  update() {
    this.shadow.x = this.tank.x;
    this.shadow.y = this.tank.y;
    this.shadow.rotation = this.tank.rotation;
    this.turret.x = this.tank.x;
    this.turret.y = this.tank.y;
  }

}