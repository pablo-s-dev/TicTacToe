import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tic-tac-toe',
      home: MyHomePage(title: 'Tic-tac-toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _player = 1;
  int _p1_wins = 0;
  int _p2_wins = 0;
  bool _gameOver = false;
  final Color _bgColor = const Color.fromRGBO(13, 13, 13, 1.0);
  final Color _shapesColor = const Color.fromRGBO(27, 217, 208, 1.0);
  List<dynamic> _shapes = List.generate(9, (index) => null);
  List<int> _gameMatrix = List.generate(9, (index) => 0);
  int _winner = 0;
  final List<String> _winningPhrases = ['',
    '✖ wins. (❁´◡`❁)',
    "⬤ wins. (❁´◡`❁)", "Empate. -.-",
  ];
  final List<String> _whoseTurn = ["✖'s  turn.", "⬤'s  turn."];

  addShape(index) {
    if (!_gameOver) {
      setState(() {
        if (_gameMatrix[index] != 0) {
          return;
        }
        if (_player == 1) {
          _shapes[index] = Icon(
            Icons.clear,
            size: 35.0,
            color: _shapesColor,
          );
          _gameMatrix[index] = 1;
          _player = 2;
        } else {
          _shapes[index] = Icon(
            Icons.circle_outlined,
            size: 25.0,
            color: _shapesColor,
          );
          _gameMatrix[index] = -1;
          _player = 1;
        }
      });
      checkWin();
    }
  }

  checkWin() {
    int i = 0;
    if(_gameMatrix.every((element) => element != 0)){
      _winner = 3;
    }
    // columns check
    for (i = 0; i < 3; i++) {
      int sum = _gameMatrix[i] + _gameMatrix[i + 3] + _gameMatrix[i + 6];
      if (sum == 3) {
        _gameOver = true;
        _winner = 1;
        return;
      } else if (sum == -3) {
        _winner = 2;
        _gameOver = true;
        return;
      }
    }
    // rows check
    for (i = 0; i < 9; i += 3) {
      int sum = _gameMatrix[i] + _gameMatrix[i + 1] + _gameMatrix[i + 2];
      if (sum == 3) {
        _p1_wins++;
        _gameOver = true;
        _winner = 1;
        return;
      } else if (sum == -3) {
        _winner = 2;
        _p2_wins++;
        _gameOver = true;
      }
    }
    //diagonals check
    switch (_gameMatrix[0] + _gameMatrix[4] + _gameMatrix[8]) {
      case 3:
        {
          print('oi');
          _p1_wins++;
          _gameOver = true;
          _winner = 1;
        }
        break;
      case -3:
        {
          _p1_wins++;
          _gameOver = true;
          _winner = 1;
        }
        break;
    }
    switch (_gameMatrix[2] + _gameMatrix[4] + _gameMatrix[6]) {
      case 3:
        {
          _p1_wins++;
          _gameOver = true;
          _winner = 1;
        }
        break;
      case -3:
        {
          _p1_wins++;
          _gameOver = true;
          _winner = 2;
        }
        break;
    }
  }

  restart() {
    setState(() {
      _gameMatrix = List.generate(9, (index) => 0);
      _shapes = List.generate(9, (index) => null);
      _player = 1;
      _gameOver = false;
      _winner = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title,
            style: TextStyle(
                fontFamily: 'Quicksand', fontWeight: FontWeight.w600, fontSize: MediaQuery.of(context).size.width*0.045)),
        backgroundColor: _bgColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(children: [
        Container(
          height: (MediaQuery.of(context).size.height - // total height
              kToolbarHeight - // top AppBar height
              MediaQuery.of(context).padding.top - // top padding
              kBottomNavigationBarHeight - //nav bar
              MediaQuery.of(context).size.width * 0.8) //hashTag Container
              /
              2,
          width: MediaQuery.of(context).size.width * 1,
          color: _bgColor,
          child: Center(
            child: Text(
              _whoseTurn[_player - 1],
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width*0.045,
                  color: Colors.white,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        ClipRect(
          clipBehavior: Clip.hardEdge,
          clipper: RectClipper(clipSize:2),
          child: Container(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [
                    0.1,
                    0.3,
                    0.6
                  ],
                  colors: [
                    Colors.cyan,
                    Color.fromRGBO(101, 248, 197, 1.0),
                    Colors.cyan
                  ]),
            ),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              children: List.generate(9, (index) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: _bgColor,
                  child: InkWell(
                    onTap: () => addShape(index), // Handle your callback
                    child: Center(
                      child: _shapes[index],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Container(
          height: (MediaQuery.of(context).size.height - // total height
              kToolbarHeight - // top AppBar height
              MediaQuery.of(context).padding.top - // top padding
              kBottomNavigationBarHeight - //nav bar
              MediaQuery.of(context).size.width * 0.8) //hashTag Container
              /
              2,
          width: MediaQuery.of(context).size.width * 1,
          color: _bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(_winningPhrases[_winner],
                  style: TextStyle(
                      fontSize: 22,
                      backgroundColor: _shapesColor,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600)),
              Align(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(25, 25, 25, 1),
                      borderRadius: BorderRadius.circular(50.0)),
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: IconButton(
                    onPressed: restart,
                    icon: const Icon(Icons.restart_alt),
                    color: Colors.white70,
                    iconSize: MediaQuery.of(context).size.width * 0.06,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
class RectClipper extends CustomClipper<Rect> {
  double clipSize;

  RectClipper({required this.clipSize});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(clipSize, clipSize, size.width - clipSize, size.height - clipSize);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}