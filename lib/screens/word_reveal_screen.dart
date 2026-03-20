// lib/screens/word_reveal_screen.dart
//
// Design:
//   - Coral header: "TRUST ISSUES" stacked + X close button top-right
//   - White body: plain white background
//   - Center card: white with rounded corners, player name, tip, button inside
//   - Hidden state: "Renz" + tip + green "Show my Word" button
//   - Revealed state (word): "Renz / Your Word is: / Cat (italic)" + green "Hide Word & Pass"
//   - Revealed state (imposter): "Johann / You are the: / Imposter (italic)" + green "Hide Word & Pass"

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
    // X button: confirm before leaving the game
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave Game?'),
        content: const Text('Are you sure you want to quit this round?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to home
            },
            child: const Text('Leave', style: TextStyle(color: AppColors.coral)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.coral,
      body: SafeArea(
        child: Column(
          children: [
            // ── Coral header: TRUST ISSUES + X button ──
            Stack(
              alignment: Alignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        'TRUST',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        'ISSUES',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // X close button top-right
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _close,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.close, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ],
            ),

            // ── White body ──
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Center card ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 14),

                            if (!isWordVisible) ...[
                              // ── Hidden: show tip ──
                              Text(
                                currentPlayer.isImposter
                                    ? 'Tip: Do not let anyone\nknow you\'re the imposter!'
                                    : 'Tip: Do not let anyone\nsee your word!',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
                              // ── Revealed: imposter ──
                              const Text(
                                'You are the:',
                                style: TextStyle(fontSize: 14, color: AppColors.textGray),
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
                              const SizedBox(height: 8),
                              const Text(
                                'Tip: Do not let anyone know you\'re the imposter!',
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
                            ] else ...[
                              // ── Revealed: word ──
                              const Text(
                                'Your Word is:',
                                style: TextStyle(fontSize: 14, color: AppColors.textGray),
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
                      style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}