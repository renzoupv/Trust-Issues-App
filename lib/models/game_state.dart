import 'dart:math';
import 'player.dart';
import 'game_settings.dart';
import '../data/word_categories.dart';

class GameState {
  final List<Player> players;   // All players with their roles assigned
  final String secretWord;      // The word all non-imposters received
  int currentPlayerIndex;       // Which player is currently viewing their word 

  GameState({
    required this.players,
    required this.secretWord,
    this.currentPlayerIndex = 0,
  });


  // Creates a brand-new GameState from settings:
  //   1. Picks a random word from the chosen category
  //   2. Shuffles the player order so the imposter position is unpredictable
  //   3. Assigns the imposter role to a random player
  factory GameState.fromSettings(GameSettings settings) {
    final random = Random();

    // 1. Pick a random word from the selected category
    final words = WordCategories.wordsFor(settings.category);
    final secretWord = words[random.nextInt(words.length)];

    // 2. Build player list in shuffled order
    final shuffledNames = List<String>.from(settings.playerNames)..shuffle(random);

    // 3. Pick which index(es) are imposters
    final imposterIndexes = <int>{};
    while (imposterIndexes.length < settings.imposterCount) {
      imposterIndexes.add(random.nextInt(shuffledNames.length));
    }

    // 4. Create Player objects with roles assigned
    final players = shuffledNames.asMap().entries.map((entry) {
      return Player(
        name: entry.value,
        isImposter: imposterIndexes.contains(entry.key),
      );
    }).toList();

    return GameState(
      players: players,
      secretWord: secretWord,
    );
  }

  // The player who is currently being shown their word
  Player get currentPlayer => players[currentPlayerIndex];

  // True when all players have seen their word
  bool get allPlayersHaveSeen => currentPlayerIndex >= players.length;

  // Returns the name(s) of all imposters (used in Game Summary)
  List<String> get imposterNames =>
      players.where((p) => p.isImposter).map((p) => p.name).toList();

  // Moves to the next player's turn
  void advanceToNextPlayer() {
    currentPlayerIndex++;
  }
}