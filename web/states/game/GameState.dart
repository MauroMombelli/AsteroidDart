import 'package:play_phaser/phaser.dart';
import 'entity/EnemyTank.dart';

class GameState extends State {
  preload() {
    game.load.atlas('tank', 'assets/game/pack1/tanks.png', 'assets/game/pack1/tanks.json');
    game.load.atlas('enemy', 'assets/game/pack1/enemy-tanks.png', 'assets/game/pack1/tanks.json');
    //game.load.image('logo', 'assets/games/tanks/logo.png');
    game.load.image('bullet', 'assets/game/pack1/bullet.png');
    game.load.image('background', 'assets/game/pack1/scorched_earth.png');
    game.load.spritesheet('kaboom', 'assets/game/pack1/explosion.png', 64, 64, 23);
  }
  var land;
  var shadow;
  var tank;
  var turret;
  List<EnemyTank> enemies = [];
  var enemyBullets;
  var enemiesTotal = 0;
  //var enemiesAlive = 0;
  Group explosions;
  var logo;
  var currentSpeed = 0;
  var cursors;
  var bullets;
  var fireRate = 100;
  var nextFire = 0;

  create() {
// Resize our game world to be a 2000 x 2000 square
    game.world.setBounds(0, 0, 1024, 768);
// Our tiled scrolling background
    land = game.add.tileSprite(0, 0, 1024, 768, 'background');
    land.fixedToCamera = true;
// The base of our tank
    tank = game.add.sprite(0, 0, 'tank', 'tank1');
    tank.anchor.setTo(0.5, 0.5);
    tank.animations.add('move', ['tank1', 'tank2', 'tank3', 'tank4', 'tank5', 'tank6'], 20, true);
// This will force it to decelerate and limit its speed
    game.physics.enable(tank, Physics.ARCADE);
    game.physics.arcade.gravity.y = 0;
    tank.body.drag.set(0.2);
    tank.body.maxVelocity.setTo(400, 400);
    tank.body.collideWorldBounds = true;
// Finally the turret that we place on-top of the tank body
    turret = game.add.sprite(0, 0, 'tank', 'turret');
    turret.anchor.setTo(0.3, 0.5);

// The enemies bullet group
    enemyBullets = game.add.group();
    enemyBullets.enableBody = true;
    enemyBullets.physicsBodyType = Physics.ARCADE;
    enemyBullets.createMultiple(100, 'bullet');
    enemyBullets.forEach((Sprite s) {
      s.anchor.setTo(0.5);
      s.outOfBoundsKill = true;
      s.checkWorldBounds = true;
    });

// Create some baddies to waste :)
    enemiesTotal = 10;
    for (var i = 0; i < enemiesTotal; i++) {
      enemies.add(new EnemyTank(i, game, tank, enemyBullets));
    }

// A shadow below our tank
    shadow = game.add.sprite(0, 0, 'tank', 'shadow');
    shadow.anchor.setTo(0.5, 0.5);
// Our bullet group
    bullets = game.add.group();
    bullets.enableBody = true;
    bullets.physicsBodyType = Physics.ARCADE;
    bullets.createMultiple(30, 'bullet', 0, false);
    bullets.forEach((Sprite s) {
      s.anchor.setTo(0.5);
      s.outOfBoundsKill = true;
      s.checkWorldBounds = true;
    });
// Explosion pool
    explosions = game.add.group();
    for (var i = 0; i < 10; i++) {
      var explosionAnimation = explosions.create(0, 0, 'kaboom', 0, false);
      explosionAnimation.anchor.setTo(0.5, 0.5);
      explosionAnimation.animations.add('kaboom');
    }
    tank.bringToTop();
    turret.bringToTop();

    //logo = game.add.sprite(0, 200, 'logo');
    //logo.fixedToCamera = true;
    //game.input.onDown.add(removeLogo);

    game.camera.follow(tank);
    //game.camera.deadzone = new Rectangle(150, 150, 500, 300);
    game.camera.focusOnXY(0, 0);
    cursors = game.input.keyboard.createCursorKeys();
  }
  removeLogo(p, e) {
    game.input.onDown.remove(removeLogo);
    logo.kill();
  }
  update() {
    game.physics.arcade.overlap(enemyBullets, tank, bulletHitPlayer, null);
    //enemiesAlive = 0;
    List<EnemyTank> enemiesAlive = [];
    for (var i = 0; i < enemies.length; i++) {
      
      if (enemies[i].alive) {
        for (var c = 0; c < enemiesAlive.length; c++) {
          if (enemiesAlive[c].alive){
            game.physics.arcade.overlap(enemies[i].tank, enemiesAlive[c].tank, enemyHitEnemy, null);
            game.physics.arcade.collide(enemies[i].tank, enemiesAlive[c].tank);
          }
          if (!enemies[i].alive){
            break;
          }
        }
      }
      
      if (enemies[i].alive){
        enemiesAlive.add(enemies[i]);
        game.physics.arcade.collide(tank, enemies[i].tank);
        //game.physics.arcade.overlap(tank, enemies[i].tank, playerHitEnemy, null);
        //game.physics.arcade.overlap(bullets, enemies[i].tank, bulletHitEnemy, null);
        game.physics.arcade.collide(bullets, enemies[i].tank, bulletHitEnemy);
        enemies[i].update();
      }
    }
    //it may still contains some tank expleded after collion wih other tank. who care?
    //enemies = enemiesAlive;
    /*
    for (var i = 0; i < enemiesAlive.length; i++) {
      enemiesAlive[i].update();
    }
     */
    
    if (cursors.left.isDown) {
      tank.angle -= 4;
    } else if (cursors.right.isDown) {
      tank.angle += 4;
    }
    if (cursors.up.isDown) {
// The speed we'll travel at
      currentSpeed = 300;
    } else {
      if (currentSpeed > 0) {
        currentSpeed -= 4;
      }
    }
    if (currentSpeed > 0) {
      game.physics.arcade.velocityFromRotation(tank.rotation, currentSpeed, tank.body.velocity);
    }
    land.tilePosition.x = -game.camera.x;
    land.tilePosition.y = -game.camera.y;
// Position all the parts and align rotations
    shadow.x = tank.x;
    shadow.y = tank.y;
    shadow.rotation = tank.rotation;
    turret.x = tank.x;
    turret.y = tank.y;
    turret.rotation = game.physics.arcade.angleToPointer(turret);
    if (game.input.activePointer.isDown) {
// Boom!
      fire();
    }
  }
  bulletHitPlayer(tank, bullet) {
    bullet.kill();
  }

  playerHitEnemy(tankPlayer, tankEnemy) {
    //bullet.kill();
    var destroyed = enemies[int.parse(tankEnemy.name)].damage();
    if (destroyed) {
      var explosionAnimation = explosions.getFirstExists(false);
      explosionAnimation.reset(tankEnemy.x, tankEnemy.y);
      explosionAnimation.play('kaboom', 30, false, true);
    }
  }

  enemyHitEnemy(tankEnemy1, tankEnemy2) {
    var destroyed = enemies[int.parse(tankEnemy1.name)].damage();
    if (destroyed) {
      var explosionAnimation = explosions.getFirstExists(false);
      explosionAnimation.reset(tankEnemy1.x, tankEnemy1.y);
      explosionAnimation.play('kaboom', 30, false, true);
    }

    destroyed = enemies[int.parse(tankEnemy2.name)].damage();
    if (destroyed) {
      var explosionAnimation = explosions.getFirstExists(false);
      explosionAnimation.reset(tankEnemy2.x, tankEnemy2.y);
      explosionAnimation.play('kaboom', 30, false, true);
    }
  }

  bulletHitEnemy(tank, bullet) {
    bullet.kill();
    /*
    var destroyed = enemies[int.parse(tank.name)].damage();
    if (destroyed) {
      var explosionAnimation = explosions.getFirstExists(false);
      explosionAnimation.reset(tank.x, tank.y);
      explosionAnimation.play('kaboom', 30, false, true);
    }
     */
  }
  
  fire() {
    if (game.time.now > nextFire && bullets.countDead() > 0) {
      nextFire = game.time.now + fireRate;
      var bullet = bullets.getFirstExists(false);
      bullet.reset(turret.x, turret.y);
      bullet.rotation = game.physics.arcade.moveToPointer(bullet, 1000, game.input.activePointer, 500);
    }
  }
  render() {
// game.debug.text('Active Bullets: ' + bullets.countLiving() + ' / ' + bullets.length, 32, 32);
    game.debug.text('Enemies: ' + enemies.length.toString() + ' / ' + enemiesTotal.toString(), 32, 32);
  }
}
