import 'dart:math';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sokoban/components/feature_manager.dart';
import 'package:sokoban/components/user_settings.dart';
import 'package:sokoban/src/push_game.dart';

import 'components/player.dart';
import 'components/crate.dart';

import 'dart:async';

import 'utility/config.dart';
import 'utility/direction.dart';

class MainGame extends FlameGame with KeyboardEvents, HasGameRef {
  late Function stateCallbackHandler;
  FeatureManager featureManager = FeatureManager();

  Sokoban sokoban = Sokoban();
  late Player _player;
  final List<Crate> _crateList = [];
  final List<SpriteComponent> _bgComponentList = [];
  final List<SpriteComponent> _floorSpriteList = [];
  late Map<String, Sprite> _spriteMap;
  late Sprite _floorSprite;
  int moveCount = 0;
  bool skillAvailable = false;
  Random random = Random();
  late SpriteComponent skillComponent;

  @override
  Color backgroundColor() => const Color.fromRGBO(89, 106, 108, 1.0);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final blockSprite = await Sprite.load('block.png');
    final goalSprite = await Sprite.load('goal.png');
    _floorSprite = await Sprite.load('floor.png');
    _spriteMap = {
      '#': blockSprite,
      '.': goalSprite,
    };

    await draw();
  }

  void setCallback(Function fn) => stateCallbackHandler = fn;

  Future<void> draw() async {
    for (var y = 0; y < sokoban.state.splitStageStateList.length; y++) {
      final row = sokoban.state.splitStageStateList[y];
      final firstWallIndex = row.indexOf('#');
      final lastWallIndex = row.lastIndexOf('#');

      for (var x = 0; x < row.length; x++) {
        final char = row[x];
        if (x > firstWallIndex && x < lastWallIndex)
          renderFloor(x.toDouble(), y.toDouble());
        if (_spriteMap.containsKey(char))
          renderBackGround(_spriteMap[char], x.toDouble(), y.toDouble());
        if (char == 'p') initPlayer(x.toDouble(), y.toDouble());
        if (char == 'o') initCrate(x.toDouble(), y.toDouble());
      }
    }

    add(_player);
    for (var crate in _crateList) {
      add(crate);
    }

    if (sokoban.state.width > playerCameraWallWidth) {
      camera.follow(_player);
    } else {
      // camera.followVector2(Vector2(sokoban.state.width * oneBlockSize / 2, sokoban.state.height * oneBlockSize / 2));
      // final component = _bgComponentList.first;
      // camera.followComponent(component);
      // camera.setRelativeOffset(Anchor.center);
    }
  }

  void renderBackGround(sprite, double x, double y) {
    final component = SpriteComponent(
      size: Vector2.all(oneBlockSize),
      sprite: sprite,
      position: Vector2(x * oneBlockSize, y * oneBlockSize),
    );
    _bgComponentList.add(component);
    add(component);
  }

  void renderFloor(double x, double y) {
    final component = SpriteComponent(
      size: Vector2.all(oneBlockSize),
      sprite: _floorSprite,
      position: Vector2(x * oneBlockSize, y * oneBlockSize),
    );
    _floorSpriteList.add(component);
    add(component);
  }

  void initPlayer(double x, double y) {
    _player = Player(featureManager);
    _player.position = Vector2(x * oneBlockSize, y * oneBlockSize);
  }

  void initCrate(double x, double y) {
    final crate = Crate();
    crate.setPosition(Vector2(x, y));
    crate.position = Vector2(x * oneBlockSize, y * oneBlockSize);
    _crateList.add(crate);
  }

  void allReset() {
    remove(_player);
    for (var crate in _crateList) {
      remove(crate);
    }
    for (var bg in _bgComponentList) {
      remove(bg);
    }
    for (var floorSprite in _floorSpriteList) {
      remove(floorSprite);
    }
    _crateList.clear();
    _bgComponentList.clear();
    _floorSpriteList.clear();
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction keyDirection = Direction.none;

    if (!isKeyDown || _player.moveCount != 0 || sokoban.state.isClear) {
      return super.onKeyEvent(event, keysPressed);
    }

    keyDirection = getKeyDirection(event);
    bool isMove = sokoban.changeState(keyDirection.name);
    if (isMove) {
      moveCount++;

      if (moveCount % 5 == 0) {
        moveCount = 0;
        generateSkill();
      }

      playerMove(isKeyDown, keyDirection);
      if (sokoban.state.isCrateMove) {
        createMove();
      }
      if (sokoban.state.isClear) {
        stateCallbackHandler(sokoban.state.isClear);
        Timer(const Duration(seconds: 3), drawNextStage);
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  Future<void> generateSkill() async {
    final skill = await Sprite.load('skill.png');
    final component = skillComponent = SpriteComponent(
      size: Vector2.all(oneBlockSize),
      sprite: skill,
      position: Vector2(oneBlockSize * 1, oneBlockSize * 2),
    );
    skillAvailable = true;
    add(component);
  }

  Direction getKeyDirection(RawKeyEvent event) {
    Direction keyDirection = Direction.none;
    var userSettings = UserSettings();

    if (userSettings.controlScheme == ControlScheme.wasd) {
      // WASD kontrolleri
      if (event.logicalKey == LogicalKeyboardKey.keyA) {
        keyDirection = Direction.left;
      } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
        keyDirection = Direction.right;
      } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
        keyDirection = Direction.up;
      } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
        keyDirection = Direction.down;
      }
    } else {
      // Yön tuşları kontrolleri
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        keyDirection = Direction.left;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        keyDirection = Direction.right;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        keyDirection = Direction.up;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        keyDirection = Direction.down;
      }
    }

    return keyDirection;
  }

  void playerMove(bool isKeyDown, Direction keyDirection) {
    debugPrint(_player.position.toString());
    if (_player.position.x == 128) {
      // featureManager.applyFeature(Feature.sprint);
      // add(skillComponent);
      removeWhere((component) => component == skillComponent);
    }
    if (isKeyDown && keyDirection != Direction.none) {
      _player.direction = keyDirection;
      _player.moveCount = oneBlockSize.toInt();
    } else if (_player.direction == keyDirection) {
      _player.direction = Direction.none;
    }
  }

  void createMove() {
    final targetCrate = _crateList.firstWhere(
        (crate) => crate.coordinate == sokoban.state.crateMoveBeforeVec);
    targetCrate.move(sokoban.state.crateMoveAfterVec);
    targetCrate.goalCheck(sokoban.state.goalVecList);
  }

  void drawNextStage() {
    sokoban.nextStage();
    stateCallbackHandler(sokoban.state.isClear);
    allReset();
    draw();
  }
}
