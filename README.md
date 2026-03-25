# Trust Issues 🕵️
### Word Guessing Party Game

> *Find the imposter among you!*

A mobile party game built with Flutter where most players share the same secret word — but one player (the imposter) gets a different word and has to blend in without getting caught.

---

## How to Play

1. **Pass the phone** to each player one at a time
2. Each player taps **"Show my Word"** to secretly view their word
3. Most players see the **same word** — but the imposter sees a **different word**
4. After everyone has seen their word, the **Discussion** phase begins
5. Players describe their word without saying it out loud
6. Everyone **votes** on who they think the imposter is
7. Tap **"Reveal the Imposter & Word"** to find out who it was

---

## Features

- **3–20 players** supported with a draggable slider
- **3 word categories** — Foods & Drinks, Everyday Objects, Animals (20 words each)
- **Configurable imposters** — 1 imposter for 3–5 players, up to 2 for 6–9, up to 3 for 10+
- **Optional discussion timer** — 1 to 10 minutes
- **Player names saved locally** — names persist between sessions using SharedPreferences
- **Pass-the-phone word reveal** — each player sees their word privately before passing the device

---

## Screens

| Screen | Description |
|---|---|
| **Home** | Configure players, category, imposters, and time limit |
| **Manage Players** | Add, remove, or rename players using a slider or individual controls |
| **Select Category** | Choose a word category for the round |
| **Time Limit** | Pick a discussion time limit (1–10 min) or leave it disabled |
| **Word Reveal** | Each player privately views their word one at a time |
| **Discussion** | Timer countdown, discussion tips, reveal and new round controls |
| **Summary** | Shows who the imposter was and what the secret word was |

---

## Project Structure

```
lib/
├── main.dart                        # App entry point
│
├── models/
│   ├── player.dart                  # Player name + imposter role
│   ├── game_settings.dart           # Player list, category, imposter count, time limit
│   └── game_state.dart              # Live round data — word assignment, imposter picking
│
├── data/
│   └── word_categories.dart         # All 3 categories × 20 words each
│
├── utils/
│   ├── app_theme.dart               # All colors, button styles, and theme
│   └── player_storage.dart          # SharedPreferences save/load for player names
│
├── widgets/
│   └── common_widgets.dart          # Reusable widgets: TrustIssuesHeader, BigGreenButton, etc.
│
└── screens/
    ├── home_screen.dart             # Settings + START GAME
    ├── manage_players_screen.dart   # Add/remove/rename players
    ├── select_category_screen.dart  # Pick a word category
    ├── time_limit_screen.dart       # Pick discussion time limit
    ├── word_reveal_screen.dart      # Pass-the-phone word reveal
    ├── discussion_screen.dart       # Timer + discussion tips
    └── summary_screen.dart          # Reveals imposter and word
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (Dart SDK `>=3.0.0`)
- Android Studio, VS Code, or any Flutter-compatible IDE
- A connected device or emulator

### Installation

```bash
# 1. Clone or download the project
cd trust_issues

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Dependencies

| Package | Version | Purpose |
|---|---|---|
| `shared_preferences` | `^2.2.2` | Saves player names to local device storage |

---

## Imposter Rules

The number of allowed imposters scales with the player count to keep the game balanced:

| Players | Max Imposters |
|---|---|
| 3 – 5 | 1 |
| 6 – 9 | 2 |
| 10+ | 3 |

---

## Word Categories

| Category | Sample Words |
|---|---|
| Foods & Drinks | Pizza, Sushi, Ramen, Milk Tea, Ice Cream… |
| Everyday Objects | Backpack, Umbrella, Headphones, Stapler… |
| Animals | Penguin, Kangaroo, Dolphin, Hamster… |

To add a new category, open `lib/data/word_categories.dart` and add a new entry to the `categories` map — no other file needs to change.

---

## Built By

**Renz Rendel De Arroz** and **Johann Ross Yap**
