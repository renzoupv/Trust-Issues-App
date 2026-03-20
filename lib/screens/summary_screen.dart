// lib/screens/summary_screen.dart
//
// Design: Same dark background as discussion screen. "Discussion Time!" title.
// White "Game Summary" card with:
//   - Pink chip: "The Imposter is: Johann" (red bold text)
//   - Blue chip: "The word was: Cat" (blue italic text)
//   - Dark "New Round" button
// Discussion Tips in white italic below.

import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/game_settings.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'word_reveal_screen.dart';
import 'home_screen.dart';

class SummaryScreen extends StatelessWidget {
  final GameState gameState;
  final GameSettings settings;

  const SummaryScreen({
    super.key,
    required this.gameState,
    required this.settings,
  });

  void _newRound(BuildContext context) {
    final newState = GameState.fromSettings(settings);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WordRevealScreen(gameState: newState, settings: settings),
      ),
    );
  }

  void _newGame(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final imposterNames = gameState.imposterNames.join(' & ');

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── "Discussion Time!" title (same as discussion screen) ──
              const Text(
                'Discussion\nTime!',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 20),

              // ── Game Summary white card ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Game Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Imposter pink chip
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.imposterPink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'The Imposter is:',
                            style: TextStyle(fontSize: 12, color: AppColors.imposterRed),
                          ),
                          Text(
                            imposterNames,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.imposterRed,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Word blue chip
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.wordBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'The word was:',
                            style: TextStyle(fontSize: 12, color: AppColors.wordBlueDark),
                          ),
                          Text(
                            gameState.secretWord,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: AppColors.wordBlueDark,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // New Round dark button (inside the card, matches mockup)
                    BigDarkButton(label: 'New Round', onPressed: () => _newRound(context)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Discussion Tips below the card ──
              const Text(
                'Discussion Tips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 6),
              ...[
                'Describe the word without saying it.',
                'Pay attention to suspicious answers.',
                'The imposter will try to blend in!',
                'Vote together on who you think the imposter is.',
              ].map((tip) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '• $tip',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )),

              const SizedBox(height: 24),

              // ── New Game button ──
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _newGame(context),
                  child: const Text('New Game'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}