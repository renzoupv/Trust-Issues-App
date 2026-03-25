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

  // "10:00 m" while minutes remain, "0:58 s" when under a minute
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
        builder: (_) => SummaryScreen(
          gameState: widget.gameState,
          settings: widget.settings,
        ),
      ),
    );
  }

  void _newRound() {
    _timer?.cancel();
    final newState = GameState.fromSettings(widget.settings);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WordRevealScreen(
          gameState: newState,
          settings: widget.settings,
        ),
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
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
    final activePlayer = widget.gameState.players.first;

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

                  // Discussion time
                  Text(
                    _timeIsUp ? 'End of\nRound!' : 'Discussion\nTime!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D2D2D), // dark charcoal — matches screenshot
                      height: 1.05,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // White Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
                    ),
                    child: Column(
                      children: [

                        // Player name 
                        Text(
                          activePlayer.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          _timeIsUp
                              ? 'Time to vote who\'s the Imposter!'
                              : 'Start the conversation!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),

                        // Timer (only when time limit is on)
                        if (widget.settings.hasTimeLimit) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Time:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              // Red while counting, gray when done
                              color: _timeIsUp
                                  ? const Color(0xFF9E9E9E)
                                  : AppColors.coral,
                            ),
                          ),
                          Text(
                            _timerDisplay,
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              color: _timeIsUp
                                  ? const Color(0xFF9E9E9E)
                                  : AppColors.coral,
                            ),
                          ),
                        ],

                        // ── No timer message (when time limit is OFF) ──
                        if (!widget.settings.hasTimeLimit) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Discuss until everyone is ready to vote.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9E9E9E),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Discussion Tips
                  const Text(
                    'Discussion Tips',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bullet tips 
                  ...[
                    'Describe the word without saying it.',
                    'Pay attention to suspicious answers.',
                    'The imposter will try to blend in!',
                    'Vote together on who you think the imposter is.',
                  ].map((tip) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
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

                  // Reveal Button
                  SizedBox(
                    width: double.infinity,
                    height: 67,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A8A8A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _revealImposter,
                      child: const Text(
                        'Reveal the\nImposter & Word',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // New Round Button
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C2B3A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _newRound,
                      child: const Text(
                        'New Round',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Close Button
            Positioned(
              top: 12,
              right: 16,
              child: GestureDetector(
                onTap: _close,
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