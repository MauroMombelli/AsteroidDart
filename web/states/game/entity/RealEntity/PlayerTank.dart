library player;

import 'package:play_phaser/phaser.dart';

import '../Tank.dart';

class PlayerTank extends Tank {

  var cursors;
  //int currentSpeed = 0;

  PlayerTank(num x, num y, var namet, Game game, Group bullets) : super(x, y, namet, game, bullets) {
    cursors = game.input.keyboard.createCursorKeys();
    game.input.keyboard.addKeyCapture(Keyboard.W);
    game.input.keyboard.addKeyCapture(Keyboard.A);
    game.input.keyboard.addKeyCapture(Keyboard.S);
    game.input.keyboard.addKeyCapture(Keyboard.D);
    game.input.keyboard.addKeyCapture(Keyboard.SPACEBAR);
    
  }

  fire() {
    if (game.time.now > nextFire && bullets.countDead() > 0) {
      nextFire = game.time.now + fireRate;
      var bullet = bullets.getFirstExists(false);
      if (bullet != null){
        bullet.reset(tank.x, tank.y);
      
        bullet.rotation = tank.rotation;
      //game.physics.arcade.moveToPointer(bullet, bulletSpeed, game.input.activePointer, 500);
        bullet.body.velocity = game.physics.arcade.velocityFromRotation(tank.rotation, bulletSpeed);
      //bullet.rotation = game.physics.arcade.moveToPointer(bullet, 1000, game.input.activePointer, 500);
      }
    }
  }

  @override update() {
    super.update();
    
    if (cursors.left.isDown || game.input.keyboard.isDown(Keyboard.A)) {
      tank.angle -= 4;
    } else if (cursors.right.isDown || game.input.keyboard.isDown(Keyboard.D)) {
      tank.angle += 4;
    }

    if (cursors.up.isDown || game.input.keyboard.isDown(Keyboard.W)) {
      num acceleration = 500;
      tank.body.acceleration = game.physics.arcade.accelerationFromRotation(tank.rotation, acceleration);
      //tank.body.velocity = game.physics.arcade.velocityFromRotation(tank.rotation, acceleration);
    }else{
      tank.body.acceleration.x=0;
      tank.body.acceleration.y=0;
    }
    
    if ( game.input.keyboard.isDown(Keyboard.SPACEBAR) ) {//spacebar
      // Boom!
      fire();
    }
    
    
  }
}
