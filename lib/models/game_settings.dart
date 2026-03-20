// lib/models/game_settings.dart

class GameSettings {
  List<String> playerNames;
  int imposterCount;
  int? timeLimitMinutes;
  String category;

  GameSettings({
    required this.playerNames,
    this.imposterCount = 1,
    this.timeLimitMinutes,
    this.category = 'Foods & Drinks',
  });

  // Convenience getter: true when a time limit is active
  bool get hasTimeLimit => timeLimitMinutes != null;

  // Convenience getter: time limit as a display string
  String get timeLimitLabel {
    if (timeLimitMinutes == null) return 'Disabled';
    return '$timeLimitMinutes Minute${timeLimitMinutes == 1 ? '' : 's'}';
  }

  // ── Imposter rules ──────────────────────────────────────────────────────
  // Returns the allowed imposter counts based on current player count.
  // Rules:
  //   3–5  players → only 1 imposter allowed
  //   6–9  players → 1 or 2 imposters
  //   10+  players → 1, 2, or 3 imposters
  List<int> get allowedImposterCounts {
    final count = playerNames.length;
    if (count >= 10) return [1, 2, 3];
    if (count >= 6)  return [1, 2];
    return [1]; // 3–5 players
  }

  // Returns the maximum imposters allowed for the current player count
  int get maxImposters => allowedImposterCounts.last;

  // Display label for the imposter tile on the home screen
  String get imposterLabel =>
      '$imposterCount Imposter${imposterCount > 1 ? 's' : ''}';

  // Clamps imposterCount to the allowed range.
  // Call this whenever playerNames changes so the count stays valid.
  void clampImposterCount() {
    if (imposterCount > maxImposters) imposterCount = maxImposters;
    if (imposterCount < 1) imposterCount = 1;
  }
}