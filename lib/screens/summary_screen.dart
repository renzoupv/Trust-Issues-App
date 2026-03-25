import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/game_settings.dart';
import '../utils/app_theme.dart';
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

  void _close(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave Game?'),
        content: const Text('Are you sure you want to quit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _newGame(context),
            child: const Text('Leave', style: TextStyle(color: AppColors.coral)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imposterNames = gameState.imposterNames.join(' & ');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Discussion Time Title
                  const Text(
                    'Discussion\nTime!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D2D2D),
                      height: 1.05,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Game Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Game Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFCDD2), 
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'The Imposter is:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFE53935), 
                                ),
                              ),
                              Text(
                                imposterNames,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE53935),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Blue word chip 
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBBDEFB), 
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'The word was:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF1565C0), 
                                ),
                              ),
                              Text(
                                gameState.secretWord,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // New Round Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1C2B3A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _newRound(context),
                            child: const Text(
                              'New Round',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Discussion Tips
                  const Center(
                    child: Text(
                      'Discussion Tips',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bullet Tips
                  ...[
                    'Describe the word without saying it.',
                    'Pay attention to suspicious answers.',
                    'The imposter will try to blend in!',
                    'Vote together on who you think the imposter is.',
                  ].map((tip) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF555555),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tip,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF555555),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 28),

                  // New Game Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _newGame(context),
                      child: const Text(
                        'New Game',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Close Button
            Positioned(
              top: 12,
              right: 16,
              child: GestureDetector(
                onTap: () => _close(context),
                child: const Icon(
                  Icons.close,
                  color: Color(0xFFBBBBBB),
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}