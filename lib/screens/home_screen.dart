import 'package:flutter/material.dart';
import '../models/game_settings.dart';
import '../models/game_state.dart';
import '../utils/app_theme.dart';
import '../utils/player_storage.dart';
import '../widgets/common_widgets.dart';
import 'manage_players_screen.dart';
import 'select_category_screen.dart';
import 'word_reveal_screen.dart';
import 'time_limit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GameSettings settings;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    settings = GameSettings(playerNames: ['Player 1', 'Player 2', 'Player 3']);
    _loadSavedPlayers();
  }

  Future<void> _loadSavedPlayers() async {
    final saved = await PlayerStorage.loadPlayers();
    setState(() {
      if (saved.isNotEmpty) settings.playerNames = saved;
      isLoading = false;
    });
  }

  void _openManagePlayers() async {
    final updated = await showDialog<List<String>>(
      context: context,
      barrierColor: Colors.black54, // dim the background
      barrierDismissible: true, // tap outside to cancel
      builder: (_) => ManagePlayersScreen(currentNames: settings.playerNames),
    );
    if (updated != null) {
      setState(() {
        settings.playerNames = updated;
        // Clamp imposterCount in case the new player count is lower
        settings.clampImposterCount();
      });
      await PlayerStorage.savePlayers(updated);
    }
  }

  // Opens an AlertDialog letting the user pick how many imposters they want.
  // The available options depend on how many players are in the game:
  //   3–5  players → 1 imposter only
  //   6–9  players → 1 or 2 imposters
  //   10+  players → 1, 2, or 3 imposters
  void _openImposterPicker() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        int tempSelected = settings.imposterCount;
        final allowed = settings.allowedImposterCounts;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Number of Imposters',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _imposterRuleLabel(settings.playerNames.length),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // One option row per allowed count
                  ...allowed.map((count) {
                    final isSelected = count == tempSelected;
                    return GestureDetector(
                      onTap: () => setDialogState(() => tempSelected = count),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.coral.withOpacity(0.1)
                              : AppColors.offWhite,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.coral
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$count Imposter${count > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.coral
                                    : AppColors.textDark,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.coral,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() => settings.imposterCount = tempSelected);
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.textGray),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.textGray),
                      ),
                    ),
                  ),
                ],
              ),
              actions: const [],
              actionsPadding: EdgeInsets.zero,
            );
          },
        );
      },
    );
  }

  // Returns a human-readable rule description for the current player count
  String _imposterRuleLabel(int playerCount) {
    if (playerCount >= 10) return '10+ players: up to 3 imposters allowed';
    if (playerCount >= 6) return '6–9 players: up to 2 imposters allowed';
    return '3–5 players: 1 imposter allowed';
  }

  void _openSelectCategory() async {
    final selected = await showDialog<String>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (_) => SelectCategoryScreen(currentCategory: settings.category),
    );
    if (selected != null) setState(() => settings.category = selected);
  }

  void _openTimeLimitPicker() async {
    final minutes = await showDialog<int>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (_) =>
          TimeLimitScreen(currentMinutes: settings.timeLimitMinutes),
    );
    if (minutes != null) {
      setState(() => settings.timeLimitMinutes = minutes);
    }
  }

  void _startGame() {
    if (settings.playerNames.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need at least 3 players to start!')),
      );
      return;
    }
    final gameState = GameState.fromSettings(settings);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WordRevealScreen(gameState: gameState, settings: settings),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 115, 115),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Column(
                      children: [
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
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'Find the imposter among you!',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Column(
                      children: [
                      // How to Play Card
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'How to Play:',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...[
                              'Pass the device to each player to see their word',
                              'Most players get the same word',
                              '1 impostor gets a different word',
                              'Discuss and find the impostor!',
                            ].asMap().entries.map(
                              (e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Text(
                                  '${e.key + 1}. ${e.value}',
                                  style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Players tile
                      _SettingRow(
                        icon: Icons.people,
                        iconColor: Colors.purple,
                        title: '${settings.playerNames.length} Players',
                        subtitle: settings.imposterLabel,
                        actionLabel: 'Manage →',
                        onTap: _openManagePlayers,
                      ),
                      const SizedBox(height: 10),

                      // Category tile
                      _SettingRow(
                        icon: Icons.local_bar,
                        iconColor: Colors.orange,
                        title: settings.category,
                        subtitle: 'Tap to change',
                        actionLabel: 'Change →',
                        onTap: _openSelectCategory,
                      ),
                      const SizedBox(height: 10),

                      // Imposters tile — tappable, opens the imposter picker dialog
                      _SettingRow(
                        icon: Icons.person_off,
                        iconColor: AppColors.textDark,
                        title: 'Imposters',
                        subtitle: settings.imposterLabel,
                        actionLabel: 'Change →',
                        onTap: _openImposterPicker,
                      ),
                      const SizedBox(height: 10),

                      // Time Limit tile with toggle
                      _TimeLimitRow(
                        hasTimeLimit: settings.hasTimeLimit,
                        timeLimitLabel: settings.timeLimitLabel,
                        onToggle: (val) {
                          if (val) {
                            _openTimeLimitPicker();
                          } else {
                            setState(() => settings.timeLimitMinutes = null);
                          }
                        },
                        onTap: settings.hasTimeLimit
                            ? _openTimeLimitPicker
                            : null,
                      ),

                      const SizedBox(height: 24),

                      // Start Game Button
                      BigGreenButton(
                        label: 'START GAME',
                        icon: Icons.play_arrow,
                        onPressed: _startGame,
                      ),
                      ],
                    ),
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

// Individual setting row tile
class _SettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  const _SettingRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.coral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Time Limit row with toggle switch
class _TimeLimitRow extends StatelessWidget {
  final bool hasTimeLimit;
  final String timeLimitLabel;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTap;

  const _TimeLimitRow({
    required this.hasTimeLimit,
    required this.timeLimitLabel,
    required this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Time Limit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    timeLimitLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: hasTimeLimit
                          ? AppColors.coral
                          : AppColors.textGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: hasTimeLimit,
            onChanged: onToggle,
            activeColor: AppColors.toggleGreen,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
