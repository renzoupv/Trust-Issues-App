class WordCategories {
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

  // Returns just the category names as a list
  static List<String> get categoryNames => categories.keys.toList();

  // Returns the word list for a given category name
  static List<String> wordsFor(String category) {
    return categories[category] ?? [];
  }
}