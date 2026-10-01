import 'dart:async';

import 'package:flutter/material.dart';

import 'pet_personality.dart';

void main() => runApp(const SmileyApp());

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  String _petName = 'Perry the Platypus';
  int _happiness = 50;
  int _hunger = 50;

  bool _gameOver = false;
  bool _hasWon = false;
  bool _paused = false;

  final TextEditingController _nameController = TextEditingController(
    text: 'Perry the Platypus',
  );

  Timer? _hungerTimer;
  Timer? _highMoodTimer;

  bool get _careDisabled => _gameOver || _hasWon || _paused;

  int _clampMeter(int value) => value.clamp(0, 100).toInt();

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  void _startHungerTimer() {
    _hungerTimer?.cancel();
    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!mounted || _careDisabled) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_hunger + 5 > 100) {
          _hunger = 100;
          _happiness = _clampMeter(_happiness - 20);
        } else {
          _hunger += 5;
        }
      });
      _updateOutcome();
    });
  }

  void _cancelTimers() {
    _hungerTimer?.cancel();
    _hungerTimer = null;
    _highMoodTimer?.cancel();
    _highMoodTimer = null;
  }

  void _updateOutcome() {
    if (_careDisabled) return;

    if (_hunger == 100 && _happiness <= 10) {
      _cancelTimers();
      setState(() => _gameOver = true);
      return;
    }

    if (_happiness <= 80) {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;
      return;
    }

    _highMoodTimer ??= Timer(const Duration(minutes: 3), () {
      _highMoodTimer = null;
      if (!mounted || _careDisabled || _happiness <= 80) return;

      setState(() => _hasWon = true);
      _hungerTimer?.cancel();
      _hungerTimer = null;
    });
  }

  void _feedPet() {
    if (_careDisabled) return;

    final nextHunger = _clampMeter(_hunger - 10);
    final happinessChange = nextHunger < 30 ? -20 : 10;
    final nextHappiness = _clampMeter(_happiness + happinessChange);

    setState(() {
      _hunger = nextHunger;
      _happiness = nextHappiness;
    });
    _updateOutcome();
  }

  void _playWithPet() {
    if (_careDisabled) return;

    setState(() {
      _hunger = _clampMeter(_hunger + 10);
      _happiness = _clampMeter(_happiness + 15);
    });
    _updateOutcome();
  }

  void _confirmName() {
    if (_careDisabled) return;

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a pet name.')));
      return;
    }

    setState(() => _petName = name);
    FocusScope.of(context).unfocus();
    _updateOutcome();
  }

  void _togglePause() {
    if (_gameOver || _hasWon) return;

    _cancelTimers();
    setState(() => _paused = !_paused);

    if (!_paused) {
      _startHungerTimer();
      _updateOutcome();
    }
  }

  void _resetGame() {
    _cancelTimers();

    setState(() {
      _happiness = 50;
      _hunger = 50;
      _gameOver = false;
      _hasWon = false;
      _paused = false;
      _nameController.text = _petName;
    });

    _startHungerTimer();
    _updateOutcome();
  }

  @override
  void dispose() {
    _cancelTimers();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Pet')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                enabled: !_careDisabled,
                maxLength: 40,
                decoration: const InputDecoration(
                  labelText: 'Pet name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _confirmName(),
              ),
              ElevatedButton(
                onPressed: _careDisabled ? null : _confirmName,
                child: const Text('Confirm name'),
              ),
              const SizedBox(height: 16),
              PetPersonality(
                petName: _petName,
                happiness: _happiness,
                hunger: _hunger,
                gameOver: _gameOver,
                hasWon: _hasWon,
              ),
              const SizedBox(height: 20),
              Text(
                'Happiness: $_happiness / 100',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _happiness / 100,
                semanticsLabel: 'Happiness',
                semanticsValue: '$_happiness',
              ),
              const SizedBox(height: 20),
              Text(
                'Hunger: $_hunger / 100',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _hunger / 100,
                semanticsLabel: 'Hunger',
                semanticsValue: '$_hunger',
              ),
              const SizedBox(height: 20),
              Semantics(
                liveRegion: true,
                child: Text(
                  _gameOver
                      ? 'Game Over — restart to try again.'
                      : _hasWon
                      ? 'You Win! — restart to play again.'
                      : _paused
                      ? 'Paused — the win streak is cleared.'
                      : 'Keep happiness above 80 for 3 minutes.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Feed: hunger −10; happiness +10, or −20 '
                'when the resulting hunger is below 30.\n'
                'Play: happiness +15 and hunger +10.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _careDisabled ? null : _feedPet,
                    child: const Text('Feed'),
                  ),
                  ElevatedButton(
                    onPressed: _careDisabled ? null : _playWithPet,
                    child: const Text('Play'),
                  ),
                  ElevatedButton(
                    onPressed: _gameOver || _hasWon ? null : _togglePause,
                    child: Text(_paused ? 'Resume' : 'Pause'),
                  ),
                  ElevatedButton(
                    onPressed: _resetGame,
                    child: const Text('Reset / Restart'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({required this.mood});
  final double mood;

  @override
  void paint(Canvas canvas, Size size) {
    // Modules 2–3: add eyes and mouth here. Base every position on size, center, or radius.
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.4;

    final facePaint = Paint()
      ..color = Colors.yellow.shade600
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, facePaint);

    final border = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, border);
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood;
  }
}
