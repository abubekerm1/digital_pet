# digital_pet

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Roles---
Team 1: Jalen Artis - Care Systems 
Feed, play, reset, bounded meters, hunger timer, win/loss logic, state-boundary testing.

Team 2: Abubeker Mohammed - Pet Personality
pet messages, mood feedback, licensed pet assets, motion/accessibility polish, and interaction tests.



# 4. Core Application Features

The Digital Pet application core behaviors:

| Feature | Description |
| **Pet Name** | The user can enter and confirm a pet name. |
| **Happiness** | Happiness is displayed on a 0–100 scale. |
| **Hunger** | Hunger is displayed on a 0–100 scale. |
| **Feed** | Feeding decreases hunger and increases happiness. |
| **Play** | Playing increases happiness and affects hunger. |
| **Hunger Timer** | Hunger increases by 5 every 30 seconds. |
| **Win Condition** | Happiness must remain above 80 continuously for 3 minutes. |
| **Loss Condition** | Game Over occurs when hunger reaches 100 and happiness is 10 or lower. |
| **Reset** | Reset restores the initial state and correctly restarts the care loop. |
| **State Bounds** | Happiness and hunger remain between 0 and 100. |
| **Mood Feedback** | The pet's mood is communicated through a readable label and visual feedback. |
| **Timer Lifecycle** | Timers are canceled when they are no longer needed or when the widget is disposed. |



Design Notes---

The application employs Flutter's StatefulWidget and State architecture.
The State object contains the modifiable pet values, but the widget configuration is unchangeable.
State changes utilize setState() so Flutter can rebuild the UI using the changed pet values.
When a timer is no longer required or the widget is disposed of, it is canceled. Timers are generated during the widget lifespan.


Image---

Pet Asset
Asset: Perry the Platypus PNG
**Source:** The United Organization Toons Heroes Wiki (Fandom)
- **Source page:** https://theunitedorganizationtoonsheroes.fandom.com/wiki/Perry_the_Platypus
- **License type:** Copyrighted / non-free image
- **Copyright:** Perry the Platypus and related *Phineas and Ferb* characters are owned by their respective copyright holders.
- **Usage:** Used as a pet image in this educational, non-commercial Flutter course project.
- **Attribution:** Image sourced from The United Organization Toons Heroes Wiki on Fandom.
- **License note:** The Fandom wiki's general CC-BY-SA license does not automatically apply to uploaded images. The image is therefore not being represented as CC-BY-SA, public domain, or otherwise freely licensed.
Usage: Used as the pet image in the Digital Pet application.

