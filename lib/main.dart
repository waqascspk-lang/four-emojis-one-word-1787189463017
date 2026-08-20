import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Level {
  final int id;
  final List<String> emojis;
  final String answer;
  final List<String> options;

  Level({required this.id, required this.emojis, required this.answer, required this.options});
}

class GameProvider extends ChangeNotifier {
  int _unlockedLevels = 1;
  int _currentLevelIndex = 0;

  int get unlockedLevels => _unlockedLevels;
  int get currentLevelIndex => _currentLevelIndex;

  final List<Level> levels = [
    Level(id: 1, emojis: ['🍎', '🍌', '🍇', '🍓'], answer: 'FRUIT', options: ['F', 'R', 'U', 'I', 'T', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D']),
    Level(id: 2, emojis: ['☀️', '🌙', '⭐', '☁️'], answer: 'SKY', options: ['S', 'K', 'Y', 'P', 'L', 'M', 'N', 'O', 'Q', 'R', 'S', 'T']),
    Level(id: 3, emojis: ['🐶', '🐱', '🐭', '🐹'], answer: 'PETS', options: ['P', 'E', 'T', 'S', 'W', 'A', 'V', 'U', 'I', 'O', 'P', 'L']),
    Level(id: 4, emojis: ['🚗', '🚲', '🚌', '🚂'], answer: 'CARS', options: ['C', 'A', 'R', 'S', 'H', 'J', 'K', 'L', 'M', 'N', 'B', 'V']),
    Level(id: 5, emojis: ['🍔', '🍕', '🍟', '🌭'], answer: 'FOOD', options: ['F', 'O', 'O', 'D', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N']),
    Level(id: 6, emojis: ['⚽', '🏀', '🏈', '🎾'], answer: 'BALL', options: ['B', 'A', 'L', 'L', 'X', 'Y', 'Z', 'W', 'Q', 'R', 'T', 'U']),
    Level(id: 7, emojis: ['🎸', '🎹', '🎻', '🎷'], answer: 'MUSIC', options: ['M', 'U', 'S', 'I', 'C', 'A', 'B', 'D', 'E', 'F', 'G', 'H']),
    Level(id: 8, emojis: ['🗼', '🗽', '🏰', '🏯'], answer: 'CITY', options: ['C', 'I', 'T', 'Y', 'P', 'O', 'I', 'U', 'Y', 'T', 'R', 'E']),
    Level(id: 9, emojis: ['❄️', '🧊', '🌨️', '☃️'], answer: 'COLD', options: ['C', 'O', 'L', 'D', 'S', 'W', 'A', 'M', 'P', 'K', 'J', 'H']),
    Level(id: 10, emojis: ['🦁', '🐯', '🐻', '🦊'], answer: 'WILD', options: ['W', 'I', 'L', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Z', 'X']),
    Level(id: 11, emojis: ['👔', '👗', '👕', '👖'], answer: 'WEAR', options: ['W', 'E', 'A', 'R', 'S', 'T', 'U', 'V', 'X', 'Y', 'Z', 'Q']),
    Level(id: 12, emojis: ['⏰', '📅', '⌛', '🕰️'], answer: 'TIME', options: ['T', 'I', 'M', 'E', 'A', 'B', 'C', 'D', 'F', 'G', 'H', 'J']),
  ];

  void setLevel(int index) {
    _currentLevelIndex = index;
    notifyListeners();
  }

  void completeLevel() {
    if (_currentLevelIndex + 1 >= _unlockedLevels) {
      _unlockedLevels++;
    }
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: '4 Emojis 1 Word',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: Home(),
        routes: {
          '/': (context) => Home(),
          '/selection': (context) => LevelSelection(),
          '/game': (context) => GamePlay(),
          '/victory': (context) => Victory(),
        },
      ),
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '4 Emojis\n1 Word',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => Navigator.pushNamed(context, '/selection'),
              child: Text(
                'PLAY NOW',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LevelSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Select Level')),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: provider.levels.length,
        itemBuilder: (context, index) {
          bool isUnlocked = (index + 1) <= provider.unlockedLevels;
          return GestureDetector(
            onTap: isUnlocked
                ? () {
                    provider.setLevel(index);
                    Navigator.pushNamed(context, '/game');
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: isUnlocked ? Colors.indigo : Colors.grey,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GamePlay extends StatefulWidget {
  @override
  _GamePlayState createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  List<String> userGuess = [];
  List<int> usedIndices = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final level = provider.levels[provider.currentLevelIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${level.id}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            padding: EdgeInsets.all(20),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: level.emojis.map((e) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Center(child: Text(e, style: TextStyle(fontSize: 60))),
            )).toList(),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(level.answer.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  border: Border.all(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    userGuess.length > index ? userGuess[index] : '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 40),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(level.options.length, (index) {
              bool isUsed = usedIndices.contains(index);
              return GestureDetector(
                onTap: isUsed ? null : () {
                  setState(() {
                    if (userGuess.length < level.answer.length) {
                      userGuess.add(level.options[index]);
                      usedIndices.add(index);
                    }
                  });
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isUsed ? Colors.grey : Colors.white,
                    border: Border.all(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      level.options[index],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (userGuess.isNotEmpty) {
                      userGuess.removeLast();
                      usedIndices.removeLast();
                    }
                  });
                },
                child: Text('Undo'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  if (userGuess.join('') == level.answer) {
                    provider.completeLevel();
                    Navigator.pushReplacementNamed(context, '/victory');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong Answer! Try Again')));
                    setState(() {
                      userGuess.clear();
                      usedIndices.clear();
                    });
                  }
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Victory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.indigo,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 100, color: Colors.yellow),
            SizedBox(height: 20),
            Text(
              'LEVEL COMPLETE!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/selection'),
              child: Text('CONTINUE'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}