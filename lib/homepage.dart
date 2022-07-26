import 'dart:async';
// import 'package:card_matching/audio_manager.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'flip_card_game.dart';
import 'data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers = [];
  late List<Animation> _colorAnimations = [];
  late List<Animation> _transformAnimations = [];
  // AudioManager _homeAudioManager = AudioManager();

  @override
  void initState() {
    super.initState();
    _levelList.forEach((element) {
      _animationControllers.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 50)));
    });

    _levelList.forEachIndexed((index, element) {
      _colorAnimations.add(ColorTween(begin: element.color, end: Colors.white)
          .animate(_animationControllers[index])
        ..addListener(() {
          setState(() {});
        }));
    });

    _levelList.forEachIndexed((index, element) {
      _transformAnimations.add(Tween<double>(begin: 1, end: 1.05)
          .animate(_animationControllers[index])
        ..addListener(() {
          setState(() {});
        }));
    });
    // _homeAudioManager.init();
    // _homeAudioManager.musicPlay('Startup', volume: 0.3);
    // _homeAudioManager.musicPlayer.onPlayerCompletion.listen((event) {
    //   _homeAudioManager.musicPlay('Filler', volume: 0.3);
    // });
  }

  @override
  void dispose() {
    _animationControllers.forEach((element) {
      element.dispose();
    });
    // _homeAudioManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/pokemon_pics/pokemon_background.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              height: 200,
              child: Column(
                children: [
                  Expanded(
                    flex: 70,
                    child: Image.asset(
                      'assets/pokemon_pics/pokemon_logo.gif',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: List.generate(_levelList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        TickerFuture tickerFuture =
                            _animationControllers[index].repeat(reverse: true);
                        tickerFuture.timeout(Duration(milliseconds: 700),
                            onTimeout: () {
                          _animationControllers[index].forward(from: 0);
                          _animationControllers[index].stop(canceled: true);
                        });
                        Timer(Duration(milliseconds: 500), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  _levelList[index].levelPage,
                            ),
                          );
                        });
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Transform.scale(
                            scale: _transformAnimations[index].value,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 5),
                              height: MediaQuery.of(context).size.height * 0.13,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: _colorAnimations[index].value,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black12,
                                      spreadRadius: 0.3,
                                      offset: Offset(5, 3)),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: FittedBox(
                                      child: Text(
                                        _levelList[index].name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 2,
                                              offset: Offset(1.2, 1.2),
                                            ),
                                            Shadow(
                                              color: _levelList[index]
                                                  .color
                                                  .withOpacity(0.5),
                                              blurRadius: 2,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> difficultyIcon(int count) {
    List<Widget> _icons = [];
    for (int i = 0; i < count; i++) {}
    return _icons;
  }
}

class LevelDetails {
  String name;
  Color color;
  Widget levelPage;

  LevelDetails(
      {required this.name, required this.color, required this.levelPage});
}

List<LevelDetails> _levelList = [
  LevelDetails(
      name: "EASY",
      color: Colors.green.shade500,
      levelPage: FlipCardGame(Level.Easy)),
  LevelDetails(
      name: "NORMAL",
      color: Colors.orange.shade500,
      levelPage: FlipCardGame(Level.Medium)),
  LevelDetails(
      name: "HARD",
      color: Colors.red.shade500,
      levelPage: FlipCardGame(Level.Hard)),
];
