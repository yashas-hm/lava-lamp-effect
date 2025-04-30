import 'package:flutter/material.dart';
import 'package:lava_lamp_effect/lava_lamp_effect.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lava Lamp Effect Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, 
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _color = Colors.deepPurple;
  int _lavaCount = 10;
  int _speed = 1;
  Duration _repeatDuration = const Duration(seconds: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lava Lamp Effect Demo')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: LavaLampEffect(
                size: const Size(300, 500),
                color: _color,
                lavaCount: _lavaCount,
                speed: _speed,
                repeatDuration: _repeatDuration,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Color',
                  style: TextStyle(fontWeight: FontWeight.bold,),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _colorButton(Colors.deepPurple),
                    _colorButton(Colors.red),
                    _colorButton(Colors.blue),
                    _colorButton(Colors.green),
                    _colorButton(Colors.orange),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lava Count',
                  style: TextStyle(fontWeight: FontWeight.bold,),
                ),
                Slider(
                  value: _lavaCount.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _lavaCount.toString(),
                  onChanged: (value) {
                    setState(() {
                      _lavaCount = value.toInt();
                    });
                  },
                ),
                const Text(
                  'Speed',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _speed.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _speed.toString(),
                  onChanged: (value) {
                    setState(() {
                      _speed = value.toInt();
                    });
                  },
                ),
                const Text(
                  'Repeat Duration',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _repeatDuration.inSeconds.toDouble(),
                  min: 5,
                  max: 30,
                  divisions: 5,
                  label: '${_repeatDuration.inSeconds} seconds',
                  onChanged: (value) {
                    setState(() {
                      _repeatDuration = Duration(seconds: value.toInt());
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _color = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _color == color ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
