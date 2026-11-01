import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models.dart';

class AppState extends ChangeNotifier {
  final SharedPreferences? preferences;
  final List<CartLine> cart = [];
  final Set<String> favorites = {};
  final Map<String, String> profile = {};
  List<Map<String, dynamic>> lastOrderItems = [];
  String filterCategory = 'All', filterDiet = 'Any';
  double maxPrice = 125;
  int minRating = 0;
  bool onlyPromotions = false;
  final List<String> schedules = ['Daily dinner delivery', 'Food tour'];
  String name = 'Jack', address = 'Hanoi, VietNam', cardLast4 = '';
  String orderStatus = '', orderId = '82A2959';
  int lastOrderTotal = 0, rating = 0;
  bool signedIn = false, onboarded = false, promo = false;
  bool notifications = false, offers = true, newsletters = true;
  Food selectedFood = foods[4];
  String selectedOptions = 'Basic';
  int optionExtra = 0;

  AppState([this.preferences]) {
    final p = preferences;
    if (p == null) return;
    name = p.getString('name') ?? name;
    profile.addAll(
      (jsonDecode(p.getString('profile') ?? '{}') as Map)
          .cast<String, String>(),
    );
    lastOrderItems = (jsonDecode(p.getString('lastOrderItems') ?? '[]') as List)
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
    address = p.getString('address') ?? address;
    cardLast4 = p.getString('cardLast4') ?? '';
    onboarded = p.getBool('onboarded') ?? false;
    signedIn = p.getBool('signedIn') ?? false;
    notifications = p.getBool('notifications') ?? false;
    offers = p.getBool('offers') ?? true;
    newsletters = p.getBool('newsletters') ?? true;
    favorites.addAll(p.getStringList('favorites') ?? []);
    schedules.clear();
    schedules.addAll(
      p.getStringList('schedules') ?? ['Daily dinner delivery', 'Food tour'],
    );
    final raw = p.getString('cart');
    if (raw != null) {
      try {
        for (final item in jsonDecode(raw) as List) {
          final f = foods.where((f) => f.id == item['id']);
          if (f.isNotEmpty) {
            cart.add(
              CartLine(
                f.first,
                quantity: item['quantity'] as int,
                options: item['options'] as String,
                extra: item['extra'] as int,
              ),
            );
          }
        }
      } on FormatException {
        cart.clear();
      }
    }
    orderStatus = p.getString('orderStatus') ?? '';
    lastOrderTotal = p.getInt('lastOrderTotal') ?? 0;
    promo = p.getBool('promo') ?? false;
  }

  int get subtotal => cart.fold(0, (sum, line) => sum + line.total);
  int get discount => promo ? (subtotal * .15).round() : 0;
  int get deliveryFee => cart.isEmpty ? 0 : 200;
  int get total => subtotal - discount + deliveryFee;
  int get count => cart.fold(0, (n, line) => n + line.quantity);

  Future<void> save() async {
    notifyListeners();
    final p = preferences;
    if (p == null) return;
    await Future.wait([
      p.setString('name', name),
      p.setString('profile', jsonEncode(profile)),
      p.setString('lastOrderItems', jsonEncode(lastOrderItems)),
      p.setString('address', address),
      p.setString('cardLast4', cardLast4),
      p.setBool('signedIn', signedIn),
      p.setBool('onboarded', onboarded),
      p.setBool('notifications', notifications),
      p.setBool('offers', offers),
      p.setBool('newsletters', newsletters),
      p.setStringList('favorites', favorites.toList()),
      p.setStringList('schedules', schedules),
      p.setString('cart', jsonEncode(cart.map((e) => e.toJson()).toList())),
      p.setString('orderStatus', orderStatus),
      p.setInt('lastOrderTotal', lastOrderTotal),
      p.setBool('promo', promo),
    ]);
  }

  void select(Food food) {
    selectedFood = food;
    selectedOptions = 'Basic';
    optionExtra = 0;
  }

  void add(Food food, {int quantity = 1}) {
    final same = cart.where(
      (e) => e.food.id == food.id && e.options == selectedOptions,
    );
    if (same.isNotEmpty) {
      same.first.quantity += quantity;
    } else {
      cart.add(
        CartLine(
          food,
          quantity: quantity,
          options: selectedOptions,
          extra: optionExtra,
        ),
      );
    }
    save();
  }

  void change(CartLine line, int delta) {
    line.quantity += delta;
    if (line.quantity <= 0) cart.remove(line);
    save();
  }

  void toggleFavorite(Food food) {
    if (!favorites.add(food.id)) favorites.remove(food.id);
    save();
  }

  void placeOrder() {
    lastOrderTotal = total;
    lastOrderItems = cart
        .map(
          (line) => <String, dynamic>{
            'name': line.food.name,
            'quantity': line.quantity,
            'total': line.total,
          },
        )
        .toList();
    orderStatus = 'On its way';
    cart.clear();
    promo = false;
    save();
  }

  bool matches(Food food) {
    final tags = switch (food.id) {
      'pizza' => ['Pizza', 'Dinner', 'Vegetarian'],
      'tacos' => ['Breakfast', 'Lunch', 'Vegetarian'],
      'chicken' => ['Soups', 'Dinner', 'Chinese'],
      'salmon' => ['Salads', 'Dinner', 'Special offers'],
      'banana' => ['Breakfast', 'Vegan', 'Vegetarian', 'Special offers'],
      _ => ['Burgers', 'Vegetarian', 'Vegan', 'Lunch'],
    };
    return food.price <= maxPrice * 100 &&
        minRating <= 4.8 &&
        (filterCategory == 'All' || tags.contains(filterCategory)) &&
        (filterDiet == 'Any' ||
            tags.contains(filterDiet) ||
            filterDiet == 'Lacto ovo' && tags.contains('Vegetarian')) &&
        (!onlyPromotions || tags.contains('Special offers'));
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
