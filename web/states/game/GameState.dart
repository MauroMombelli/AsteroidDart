import 'package:play_phaser/phaser.dart';

import 'entity/RealEntity/Meteor.dart';
import 'entity/Tank.dart';
import 'entity/RealEntity/PlayerTank.dart';

class GameState extends State {
  preload() {
    game.load.atlas('tank', 'assets/game/pack1/tanks.png', 'assets/game/pack1/tanks.json');
    game.load.atlas('enemy', 'assets/game/pack1/enemy-tanks.png', 'assets/game/pack1/tanks.json');
    //game.load.image('logo', 'assets/games/tanks/logo.png');
    game.load.image('bullet', 'assets/game/pack1/bullet.png');
    game.load.image('background', 'assets/game/pack1/scorched_earth.png');
    game.load.spritesheet('kaboom', 'assets/game/pack1/explosion.png', 64, 64, 23);
  }

  Tank protagonist;
  List<Meteor> enemies = [];

  Group explosions;
  var logo;

  Group bullets;
  TileSprite land;

  int estimatedAliveBody = 0;

  void create() {
   
    // Resize our game world to be a 2000 x 2000 square
    game.world.setBounds(0, 0, game.width,  game.height);

    // Our tiled scrolling background
    land = game.add.tileSprite(0, 0,  game.width,  game.height, 'background');
    land.fixedToCamera = true;

    //be sure there is no gravity
    game.physics.arcade.gravity.x = 0;
    game.physics.arcade.gravity.y = 0;

    // Create some baddies to waste :)
    int enemiesTotal = 10;
    for (var i = 0; i < enemiesTotal; i++) {
      var x = game.world.randomX;
      var y = game.world.randomY;
      addMeteor(3, x, y);
    }

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

    protagonist = new PlayerTank(0, 0, 'protagonista', game, bullets);


    //logo = game.add.sprite(0, 200, 'logo');
    //logo.fixedToCamera = true;
    //game.input.onDown.add(removeLogo);

    game.camera.follow(protagonist.tank);

    //game.camera.deadzone = new Rectangle(150, 150, 500, 300);
    game.camera.focusOnXY(0, 0);
  }

  void removeLogo(p, e) {
    game.input.onDown.remove(removeLogo);
    logo.kill();
  }

  void update() {
    List<Meteor> enemiesAliveAtTheirUpdate = [];
    for (var i = 0; i < enemies.length; i++) {
      //if alive
      if (enemies[i].alive) {
        //check for collision with all other body alive at the be
        for (var c = 0; c < enemiesAliveAtTheirUpdate.length; c++) {
          //if otherbody still alive (may be dead after some collision after its update!)
          if (enemiesAliveAtTheirUpdate[c].alive) {
            //check for collision
            game.physics.arcade.collide(enemies[i].tank, enemiesAliveAtTheirUpdate[c].tank, enemyHitEnemy);
          }
          //if the actual body is dead by collion, exit this loop early
          if (!enemies[i].alive) {
            break;
          }
        }
      }

      //if still alive
      if (enemies[i].alive) {
        //if still alive add to alive list
        enemiesAliveAtTheirUpdate.add(enemies[i]);
        //check for collision with player or bullet
        game.physics.arcade.collide(protagonist.tank, enemies[i].tank, protagonistHitEnemy);
        game.physics.arcade.collide(bullets, enemies[i].tank, bulletHitEnemy);
        //update
        enemies[i].update();
      }
    }

    game.physics.arcade.collide(bullets, protagonist.tank, bulletHitPlayer);

    protagonist.update();

    estimatedAliveBody = enemiesAliveAtTheirUpdate.length;

    land.tilePosition.x = -game.camera.x;
    land.tilePosition.y = -game.camera.y;

  }
  void bulletHitPlayer(GameObject tank, Sprite bullet) {
    bullet.kill();
    this.game.state.start('Death');
  }

  void protagonistHitEnemy(GameObject obj1, GameObject obj2) {
    this.game.state.start('Death');
  }

  void enemyHitEnemy(GameObject tankEnemy1, GameObject tankEnemy2) {
    enemies[int.parse(tankEnemy1.name)].damage(explosions);
    enemies[int.parse(tankEnemy2.name)].damage(explosions);
  }

  void bulletHitEnemy(GameObject tank, Sprite bullet) {
    bullet.kill();
    enemies[int.parse(tank.name)].damage(explosions);
  }

  void render() {
    game.debug.text('Enemies: ' + estimatedAliveBody.toString() + ' / ' + enemies.length.toString(), 32, 32);
  }

  void addMeteor(int size, num x, num y) {
    enemies.add(new Meteor(enemies.length, this, size, x, y));
    estimatedAliveBody++;
  }

  void addExplosion(num x, num y) {
    var explosionAnimation = explosions.getFirstExists(false);
    if (explosionAnimation == null){
      explosionAnimation = explosions.create(0, 0, 'kaboom', 0, false);
      explosionAnimation.anchor.setTo(0.5, 0.5);
      explosionAnimation.animations.add('kaboom');
    }
    explosionAnimation.reset(x, y);
    explosionAnimation.play('kaboom', 30, false, true);
  }
}
