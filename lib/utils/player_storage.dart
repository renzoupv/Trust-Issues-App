import 'package:shared_preferences/shared_preferences.dart';

class PlayerStorage {
  // The key used to store the list in SharedPreferences
  static const String _storageKey = 'saved_player_names';

  // Saves a list of player names to local storage.
  // Overwrites any previously saved list.
  static Future<void> savePlayers(List<String> names) async {
    // SharedPreferences.getInstance() opens (or creates) the local storage
    final prefs = await SharedPreferences.getInstance();

    // setStringList stores a List<String> under the given key
    await prefs.setStringList(_storageKey, names);
  }

  // Loads the saved player names from local storage.
  // Returns an empty list if nothing has been saved yet.
  static Future<List<String>> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();

    // getStringList returns null if the key doesn't exist yet,
    // so we use ?? [] to fall back to an empty list safely.
    return prefs.getStringList(_storageKey) ?? [];
  }

  // Removes the saved player list (useful for a "reset" option in the future).
  static Future<void> clearPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}