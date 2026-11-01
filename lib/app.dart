import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/app_state.dart';
import 'core/screen_catalog.dart';
import 'core/theme.dart';
import 'features/auth/auth_pages.dart';
import 'features/home/home_page.dart';
import 'features/location/location_pages.dart';
import 'features/schedule/schedule_pages.dart';
import 'features/catalog/catalog_pages.dart';
import 'features/catalog/product_pages.dart';
import 'features/restaurant/restaurant_pages.dart';
import 'features/orders/cart_pages.dart';
import 'features/orders/checkout_pages.dart';
import 'features/delivery/delivery_pages.dart';
import 'features/discover/discover_pages.dart';
import 'features/profile/profile_pages.dart';
import 'shared/widgets.dart';

class EdenApp extends StatelessWidget {
  final AppState state;
  final String? initialRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  const EdenApp({
    super.key,
    required this.state,
    this.initialRoute,
    this.navigatorKey,
  });
  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: MaterialApp(
      title: 'Mino Food · Eden',
      debugShowCheckedModeBanner: false,
      theme: edenTheme,
      navigatorKey: navigatorKey,
      initialRoute:
          initialRoute ??
          (state.signedIn
              ? '/home'
              : state.onboarded
              ? '/auth'
              : '/welcome'),
      onGenerateRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => pageFor(settings.name ?? '/home'),
      ),
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFEFEFEF),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ),
    ),
  );
}

Widget pageFor(String route) {
  if (route == '/') return const WelcomePage();
  final mode = route.replaceFirst('/', '');
  if (mode == 'welcome') return const WelcomePage();
  if (mode.startsWith('walkthrough-')) {
    return WelcomePage(step: int.parse(mode.split('-').last) - 1);
  }
  if (mode == 'home') return const HomePage();
  if (mode == 'call') return const CallPage();
  if (mode == 'restaurant-chat' || mode == 'driver-chat') {
    return ChatPage(driver: mode == 'driver-chat');
  }
  if (mode == 'about') return const ProfilePage('about');
  if (mode == 'screens' && kDebugMode) return const ScreenGallery();
  final spec = screenCatalog.where((s) => s.route == route);
  if (spec.isEmpty) return const HomePage();
  return switch (spec.first.category) {
    'login' => AuthPage(mode),
    'map' => LocationPage(mode),
    'schedule' => SchedulePage(mode),
    'search' => CatalogPage(mode),
    'restaurant' => RestaurantPage(mode),
    'item' =>
      ['popular', 'best-seller'].contains(mode)
          ? CatalogPage(mode)
          : ProductPage(mode),
    'cart' => CartPage(mode),
    'checkout' => CheckoutPage(mode),
    'logistic' => DeliveryPage(mode),
    'discover' => DiscoverPage(mode),
    'profile' => ProfilePage(mode),
    _ => const HomePage(),
  };
}
