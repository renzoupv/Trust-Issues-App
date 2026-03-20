// lib/models/player.dart
//
// A Player is just a name + whether they are the imposter this round.
// Keeping this in its own file makes it easy to find and extend later.

class Player {
  final String name;       // The player's display name
  bool isImposter;         // True only for the one imposter each round
  bool hasSeenWord;        // Tracks whether this player has already viewed their word

  Player({
    required this.name,
    this.isImposter = false,
    this.hasSeenWord = false,
  });

  // Creates a copy of this player with optional overrides.
  // Useful when we want to reset round state without changing the name.
  Player copyWith({
    String? name,
    bool? isImposter,
    bool? hasSeenWord,
  }) {
    return Player(
      name: name ?? this.name,
      isImposter: isImposter ?? this.isImposter,
      hasSeenWord: hasSeenWord ?? this.hasSeenWord,
    );
  }

  @override
  String toString() => 'Player(name: $name, isImposter: $isImposter)';
}