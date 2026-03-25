import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/game_settings.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'summary_screen.dart';
import 'word_reveal_screen.dart';

class DiscussionScreen extends StatefulWidget {
  final GameState gameState;
  final GameSettings settings;

  const DiscussionScreen({
    super.key,
    required this.gameState,
    required this.settings,
  });

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _timeIsUp = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!widget.settings.hasTimeLimit) return;
    _secondsRemaining = widget.settings.timeLimitMinutes! * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining <= 0) {
        t.cancel();
        setState(() => _timeIsUp = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String get _timerDisplay {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    final unit = m > 0 ? 'm' : 's';
    return '$m:${s.toString().padLeft(2, '0')} $unit';
  }

  void _revealImposter() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SummaryScreen(gameState: widget.gameState, settings: widget.settings),
      ),
    );
  }

  void _newRound() {
    _timer?.cancel();
    final newState = GameState.fromSettings(widget.settings);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WordRevealScreen(gameState: newState, settings: widget.settings),
      ),
    );
  }

  void _close() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave Game?'),
        content: const Text('Are you sure you want to quit?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _timer?.cancel();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Leave', style: TextStyle(color: AppColors.coral)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use first player's name as the "active" discusser shown in the card
    final activePlayer = widget.gameState.players.first;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _timeIsUp
                        ? 'End of\nRound!'
                        : 'Discussion\nTime!',
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // White center card 
                  Container(
                    padding: const EdgeInsets.all(24),
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
                        // Player name
                        Text(
                          activePlayer.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _timeIsUp
                              ? 'Time to vote who\'s the Imposter!'
                              : 'Start the conversation!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 10, 0, 0),
                          ),
                        ),

                        // Timer display (only shown when time limit is active)
                        if (widget.settings.hasTimeLimit) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Time:',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textGray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _timerDisplay,
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              // Red timer matching the mockup
                              color: _timeIsUp ? AppColors.textGray : AppColors.coral,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Discussion Tips',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                            fontSize: 16,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )),

                  const SizedBox(height: 24),

                  // Reveal button 
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _revealImposter,
                      child: const Text(
                        'Reveal the\nImposter & Word',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BigDarkButton(label: 'New Round', onPressed: _newRound),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // X close button top-right 
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: _close,
                child: const Icon(Icons.close, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}