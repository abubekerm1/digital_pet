import 'package:flutter/material.dart';

class PetPersonality extends StatelessWidget {
  const PetPersonality({
    super.key,
    required this.petName,
    required this.happiness,
    required this.hunger,
    required this.gameOver,
    required this.hasWon,
  });

  final String petName;
  final int happiness;
  final int hunger;
  final bool gameOver;
  final bool hasWon;

  String get _petMessage {
    if (gameOver) return 'I need a rest.';
    if (hasWon) return 'Best day ever!';
    if (hunger > 80) return "I'm starving!";
    if (happiness <= 30) return 'Play with me?';
    return "Hi, I'm $petName!";
  }

  String get _moodLabel {
    if (happiness > 70) return 'Happy';
    if (happiness >= 30) return 'Neutral';
    return 'Unhappy';
  }

  double get _petScale =>
      happiness > 70 ? 1.06 : happiness < 30 ? 0.94 : 1.0;

  Color get _moodColor {
    if (happiness > 70) return Colors.green;
    if (happiness >= 30) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          petName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Semantics(
          label: '$petName, mood: $_moodLabel',
          image: true,
          child: ExcludeSemantics(
            child: AnimatedScale(
              scale: _petScale,
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _moodColor,
                  BlendMode.modulate,
                ),
                child: Image.asset(
                  'assets/pet.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Mood: $_moodLabel',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Semantics(
          liveRegion: true,
          child: AnimatedSwitcher(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 300),
            child: Text(
              _petMessage,
              key: ValueKey(_petMessage),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}