import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eden_food_delivery/app.dart';
import 'package:eden_food_delivery/core/app_state.dart';
import 'package:eden_food_delivery/core/screen_catalog.dart';
import 'package:eden_food_delivery/domain/models.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Android: all design screens and checkout journey', (
    tester,
  ) async {
    final state = AppState()
      ..cardLast4 = '2203'
      ..lastOrderTotal = 4430;
    state.add(foods[0], quantity: 2);
    state.add(foods[1]);
    state.favorites.add('tacos');
    state.lastOrderItems = [
      {'name': foods[0].name, 'quantity': 2, 'total': 1700},
      {'name': foods[1].name, 'quantity': 1, 'total': 2530},
    ];
    final nav = GlobalKey<NavigatorState>();
    final capture = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: capture,
        child: EdenApp(state: state, initialRoute: '/home', navigatorKey: nav),
      ),
    );
    await tester.pumpAndSettle();
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    for (final asset in manifest.listAssets().where(
      (a) => a.startsWith('assets/images/'),
    )) {
      await precacheImage(AssetImage(asset), nav.currentContext!);
    }
    binding.reportData = {'screenshots': <Map<String, dynamic>>[]};
    for (final screen in screenCatalog) {
      debugPrint('Capturing ${screen.route}');
      nav.currentState!.pushNamedAndRemoveUntil(screen.route, (_) => false);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: screen.route);
      // Capture the current Flutter layer tree directly. Android PixelCopy can
      // return an older surface buffer during rapid route changes.
      final boundary =
          capture.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final raster = await boundary.toImage(pixelRatio: 2);
      final bytes = await raster.toByteData(format: ui.ImageByteFormat.png);
      raster.dispose();
      (binding.reportData!['screenshots'] as List).add({
        'screenshotName': '${screen.category}/${screen.route.substring(1)}',
        'bytes': bytes!.buffer.asUint8List(),
      });
    }
    nav.currentState!.pushNamedAndRemoveUntil('/product', (_) => false);
    state.cart.clear();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Order now'));
    await tester.pumpAndSettle();
    expect(state.count, 1);
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm payment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Place order ·'));
    await tester.pumpAndSettle();
    expect(state.cart, isEmpty);
    expect(state.lastOrderTotal, 899);
    await tester.tap(find.text('Track your order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Follow driver'));
    await tester.pumpAndSettle();
    expect(find.text('Tracking map'), findsOneWidget);
  });
}
