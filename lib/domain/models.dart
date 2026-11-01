class Food {
  final String id, name, subtitle, image;
  final int price;
  const Food(this.id, this.name, this.subtitle, this.image, this.price);
}

const foods = [
  Food(
    'pizza',
    'Pizza Capricciosa',
    'Freshly baked · Italian',
    'food-bowl',
    850,
  ),
  Food(
    'tacos',
    'Spicy Scrambled Egg Tacos',
    'World Food · 15 minute',
    'food-tacos',
    2530,
  ),
  Food('chicken', 'Chicken Laksa', 'World Food · 4.8', 'food-chicken', 1400),
  Food(
    'salmon',
    'Grilled salmon and vegetables',
    'Fresh ingredients · Salad',
    'food-street',
    1950,
  ),
  Food('banana', 'Banana fruit', 'Fresh drink · 5 minute', 'banana', 699),
  Food(
    'vegetable',
    'Vegetable dish of Burger',
    'Vegetarian · 20 minute',
    'food-vegetable',
    1299,
  ),
];

String money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

class CartLine {
  final Food food;
  final String options;
  final int extra;
  int quantity;
  CartLine(
    this.food, {
    this.quantity = 1,
    this.options = 'Basic',
    this.extra = 0,
  });
  int get total => (food.price + extra) * quantity;
  Map<String, Object> toJson() => {
    'id': food.id,
    'quantity': quantity,
    'options': options,
    'extra': extra,
  };
}
