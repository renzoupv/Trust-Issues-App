// lib/data/word_categories.dart
//
// All word categories and their word lists live here.
// To add a new category, just add a new entry to the map below — no other file needs to change.

class WordCategories {
  // Map of category name → list of words
  // Each round picks one random word from the chosen category.
  static const Map<String, List<String>> categories = {
    'Foods & Drinks': [
      'Pizza', 'Sushi', 'Burger', 'Pasta', 'Tacos',
      'Coffee', 'Milk Tea', 'Orange Juice', 'Smoothie', 'Lemonade',
      'Ramen', 'Steak', 'Salad', 'Sandwich', 'Ice Cream',
      'Chocolate', 'Donut', 'Pancakes', 'Waffles', 'Cheesecake',
    ],
    'Everyday Objects': [
      'Chair', 'Lamp', 'Toothbrush', 'Mirror', 'Clock',
      'Umbrella', 'Backpack', 'Wallet', 'Keys', 'Notebook',
      'Pencil', 'Scissors', 'Stapler', 'Tape', 'Eraser',
      'Pillow', 'Blanket', 'Remote Control', 'Charger', 'Headphones',
    ],
    'Animals': [
      'Cat', 'Dog', 'Elephant', 'Tiger', 'Penguin',
      'Giraffe', 'Dolphin', 'Parrot', 'Kangaroo', 'Koala',
      'Panda', 'Lion', 'Eagle', 'Shark', 'Turtle',
      'Rabbit', 'Hamster', 'Fox', 'Wolf', 'Bear',
    ],
  };

  // Returns just the category names as a list (used to build the category picker)
  static List<String> get categoryNames => categories.keys.toList();

  // Returns the word list for a given category name
  static List<String> wordsFor(String category) {
    return categories[category] ?? [];
  }
}