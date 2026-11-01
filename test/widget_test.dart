import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eden_food_delivery/app.dart';
import 'package:eden_food_delivery/core/app_state.dart';
import 'package:eden_food_delivery/core/screen_catalog.dart';
import 'package:eden_food_delivery/domain/models.dart';

void main() {
  setUpAll(() async {
    final loader = FontLoader('Poppins');
    for (final style in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      loader.addFont(rootBundle.load('assets/fonts/Poppins-$style.ttf'));
    }
    await loader.load();
  });
  test(
    'Cart uses integer cents, merges options, discounts and clears on checkout',
    () {
      final s = AppState();
      s.add(foods[0], quantity: 2);
      s.add(foods[0]);
      expect(s.cart.length, 1);
      expect(s.subtotal, 2550);
      s.selectedOptions = 'Extra cheese';
      s.optionExtra = 50;
      s.add(foods[0]);
      expect(s.cart.length, 2);
      expect(s.subtotal, 3450);
      s.promo = true;
      expect(s.total, 3132);
      s.placeOrder();
      expect(s.lastOrderTotal, 3132);
      expect(s.lastOrderItems.first['quantity'], 3);
      expect(s.lastOrderItems.first['total'], 2550);
      expect(s.cart, isEmpty);
      expect(s.orderStatus, 'On its way');
    },
  );
  test('Local state restores cart, settings and masked payment', () async {
    SharedPreferences.setMockInitialValues({});
    final p = await SharedPreferences.getInstance();
    final s = AppState(p)
      ..name = 'Mino'
      ..cardLast4 = '2203'
      ..notifications = true;
    s.add(foods[1]);
    s.toggleFavorite(foods[1]);
    await s.save();
    final restored = AppState(p);
    expect(restored.name, 'Mino');
    expect(restored.cardLast4, '2203');
    expect(restored.notifications, isTrue);
    expect(restored.count, 1);
    expect(restored.favorites, contains('tacos'));
  });
  test('Filters use dietary tags, category and maximum price', () {
    final s = AppState()..filterDiet = 'Vegan';
    expect(
      foods.where(s.matches).map((f) => f.id),
      containsAll(['banana', 'vegetable']),
    );
    expect(s.matches(foods[2]), isFalse);
    s.filterDiet = 'Any';
    s.filterCategory = 'Pizza';
    expect(foods.where(s.matches).length, 1);
    s.maxPrice = 5;
    expect(foods.where(s.matches), isEmpty);
  });
  for (final size in [const Size(375, 812), const Size(320, 740)]) {
    testWidgets('Every design route renders without layout errors at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final s = AppState()..cardLast4 = '2203';
      s.add(foods[0]);
      s.add(foods[1]);
      s.favorites.add('tacos');
      final errors = <String>[];
      for (final page in screenCatalog) {
        await tester.pumpWidget(
          EdenApp(
            key: ValueKey(page.route),
            state: s,
            initialRoute: page.route,
          ),
        );
        await tester.pumpAndSettle();
        final error = tester.takeException();
        if (error != null) errors.add('${page.route}: $error');
      }
      expect(errors, isEmpty);
    });
  }
  testWidgets('User can add food, change quantity and proceed to delivery', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final s = AppState();
    await tester.pumpWidget(EdenApp(state: s, initialRoute: '/product'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();
    expect(s.count, 1);
    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add Banana fruit'));
    await tester.pumpAndSettle();
    expect(s.count, 2);
    await tester.ensureVisible(find.text('Review order'));
    await tester.tap(find.text('Review order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Shipping Address'), findsOneWidget);
  });
}
