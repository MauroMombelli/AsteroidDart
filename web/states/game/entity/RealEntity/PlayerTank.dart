library player;

import '../Tank.dart';
import 'package:play_phaser/phaser.dart';

class PlayerTank extends Tank {

  var cursors;
  //int currentSpeed = 0;

  PlayerTank(num x, num y, var namet, Game game, Group bullets) : super(x, y, namet, game, bullets) {
    cursors = game.input.keyboard.createCursorKeys();
  }

  @override update() {
    super.update();
    
    if (cursors.left.isDown) {
      tank.angle -= 4;
    } else if (cursors.right.isDown) {
      tank.angle += 4;
    }

    int currentSpeed = 0;
    if (cursors.up.isDown) {
      // The speed we'll travel at
      currentSpeed = 300;
    }
    if (cursors.down.isDown) {
      // The speed we'll travel at
      currentSpeed = -300;
    }

    if (currentSpeed > 0) {
      game.physics.arcade.velocityFromRotation(tank.rotation, currentSpeed, tank.body.velocity);
    }
    // Position all the parts and align rotations
    turret.rotation = game.physics.arcade.angleToPointer(turret);
    
    if (game.input.activePointer.isDown) {
      // Boom!
      fire();
    }
  }

  fire() {
    if (game.time.now > nextFire && bullets.countDead() > 0) {
      nextFire = game.time.now + fireRate;
      var bullet = bullets.getFirstExists(false);
      bullet.reset(turret.x, turret.y);
      bullet.rotation = game.physics.arcade.moveToPointer(bullet, 1000, game.input.activePointer, 500);
    }
  }
}
