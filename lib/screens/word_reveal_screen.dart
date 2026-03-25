import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/game_settings.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'discussion_screen.dart';

class WordRevealScreen extends StatefulWidget {
  final GameState gameState;
  final GameSettings settings;

  const WordRevealScreen({
    super.key,
    required this.gameState,
    required this.settings,
  });

  @override
  State<WordRevealScreen> createState() => _WordRevealScreenState();
}

class _WordRevealScreenState extends State<WordRevealScreen> {
  bool isWordVisible = false;

  get currentPlayer => widget.gameState.currentPlayer;

  void _showWord() => setState(() => isWordVisible = true);

  void _hideAndPass() {
    setState(() => isWordVisible = false);
    widget.gameState.advanceToNextPlayer();

    if (widget.gameState.allPlayersHaveSeen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DiscussionScreen(
            gameState: widget.gameState,
            settings: widget.settings,
          ),
        ),
      );
    } else {
      setState(() {});
    }
  }

  void _close() {
    // Close Button
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave Game?'),
        content: const Text('Are you sure you want to quit this round?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close Dialog
              Navigator.pop(context); // Go Back to Homescreen
            },
            child: const Text(
              'Leave',
              style: TextStyle(color: AppColors.coral),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 115, 115),
      body: SafeArea(
        child: Column(
          children: [
            SafeArea(
              child: SizedBox(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'TRUST',
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 3,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              'ISSUES',
                              style: TextStyle(
                                fontSize: 67,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 3,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 12,
                      right: 12,
                      child: IconButton(
                        onPressed: _close,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        splashRadius: 22,
                        tooltip: 'Close',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // White body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Center card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 80, 24, 80),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Player name
                              Text(
                                currentPlayer.name,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 14),

                              if (!isWordVisible) ...[
                                // Hidden: show same tip for everyone to avoid hinting imposter role
                                const Text(
                                  'Tip: Do not let anyone\nsee your word!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textGray,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                BigGreenButton(
                                  label: 'Show my Word',
                                  onPressed: _showWord,
                                ),
                              ] else if (currentPlayer.isImposter) ...[
                                // Revealed: imposter
                                const Text(
                                  'You are the:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Imposter',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                BigGreenButton(
                                  label: 'Hide Word & Pass',
                                  onPressed: _hideAndPass,
                                ),
                              ] else ...[
                                // Revealed: word
                                const Text(
                                  'Your Word is:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.gameState.secretWord,
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tip: Keep the word to yourself!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGray,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                BigGreenButton(
                                  label: 'Hide Word & Pass',
                                  onPressed: _hideAndPass,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Progress indicator
                      Text(
                        'Player ${widget.gameState.currentPlayerIndex + 1} of ${widget.gameState.players.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
