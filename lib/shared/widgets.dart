import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/screen_catalog.dart';
import '../core/theme.dart';
import '../domain/models.dart';

void go(BuildContext context, String route) =>
    Navigator.of(context).pushNamed(route);
void home(BuildContext context) =>
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
void notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );

class Art extends StatelessWidget {
  final String name;
  final double? width, height;
  final BoxFit fit;
  const Art(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.png',
    width: width,
    height: height,
    fit: fit,
    excludeFromSemantics: true,
  );
}

class PageShell extends StatelessWidget {
  final String? title;
  final Widget child;
  final Widget? bottom;
  final int? tab;
  final List<Widget>? actions;
  final bool location, scroll;
  final Color? background;
  const PageShell({
    super.key,
    this.title,
    required this.child,
    this.bottom,
    this.tab,
    this.actions,
    this.location = false,
    this.scroll = true,
    this.background,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: background,
    appBar: AppBar(
      backgroundColor: background,
      automaticallyImplyLeading: false,
      leading: location
          ? IconButton(
              tooltip: 'Delivery address',
              onPressed: () => go(context, '/location-form'),
              icon: const Icon(Icons.location_on_outlined, size: 21),
            )
          : IconButton(
              tooltip: 'Back',
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  home(context);
                }
              },
              icon: const Icon(Icons.arrow_back, size: 22),
            ),
      titleSpacing: 0,
      title: location
          ? GestureDetector(
              onTap: () => go(context, '/location-form'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Deliver to', style: TextStyle(fontSize: 10)),
                  Text(
                    AppScope.of(context).address,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: EdenColors.ink,
                    ),
                  ),
                ],
              ),
            )
          : null,
      actions:
          actions ??
          [
            IconButton(
              tooltip: 'Cart',
              onPressed: () => go(context, '/cart'),
              icon: const Icon(Icons.shopping_bag_outlined, size: 22),
            ),
            IconButton(
              tooltip: 'More pages',
              onPressed: () => showPageMenu(context),
              icon: const Icon(Icons.more_horiz),
            ),
          ],
    ),
    body: SafeArea(
      top: false,
      bottom: bottom == null && tab == null,
      child: scroll
          ? SingleChildScrollView(
              key: ValueKey(title),
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Heading(title!),
                    const SizedBox(height: 20),
                  ],
                  child,
                ],
              ),
            )
          : child,
    ),
    bottomNavigationBar: tab != null
        ? EdenNav(tab!)
        : bottom == null
        ? null
        : SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 16),
              child: bottom,
            ),
          ),
  );
}

void showPageMenu(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  builder: (c) => SafeArea(
    child: ListView(
      shrinkWrap: true,
      children: [
        for (final entry in const [
          ('My Schedule', '/schedule', Icons.calendar_month_outlined),
          ('Category', '/categories', Icons.category_outlined),
          ('Gallery', '/gallery', Icons.photo_library_outlined),
          ('Personal Offer', '/offers', Icons.local_offer_outlined),
          ('My Profile', '/profile', Icons.person_outline),
          ('Settings', '/settings', Icons.settings_outlined),
        ])
          ListTile(
            leading: Icon(entry.$3),
            title: Text(entry.$1),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(c);
              go(context, entry.$2);
            },
          ),
      ],
    ),
  ),
);

class Heading extends StatelessWidget {
  final String text;
  const Heading(this.text, {super.key});
  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.headlineMedium);
}

class Subheading extends StatelessWidget {
  final String text;
  final String? action;
  final VoidCallback? onTap;
  const Subheading(this.text, {super.key, this.action, this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            child: Text(action!, style: const TextStyle(fontSize: 11)),
          ),
      ],
    ),
  );
}

class Primary extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const Primary(this.text, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onTap,
    child: Text(text, textAlign: TextAlign.center),
  );
}

class Secondary extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const Secondary(this.text, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: TextButton(
      onPressed: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    ),
  );
}

class Surface extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  const Surface({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        if (color == Colors.white)
          const BoxShadow(
            color: Color(0x16000000),
            blurRadius: 16,
            offset: Offset(0, 9),
          ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

class FormFieldBox extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final bool password;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final int lines;
  const FormFieldBox(
    this.hint, {
    super.key,
    this.icon = Icons.person_outline,
    this.controller,
    this.password = false,
    this.keyboard,
    this.validator,
    this.lines = 1,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      obscureText: password,
      maxLines: lines,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: lines == 1 ? Icon(icon, size: 19) : null,
      ),
    ),
  );
}

class Pill extends StatelessWidget {
  final String text;
  final Color color;
  const Pill(this.text, {super.key, this.color = EdenColors.gold});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

class FoodRow extends StatelessWidget {
  final Food food;
  final VoidCallback? onTap;
  final bool price;
  const FoodRow(this.food, {super.key, this.onTap, this.price = true});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap:
        onTap ??
        () {
          AppScope.of(context).select(food);
          go(context, '/product');
        },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Art(food.image, width: 88, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  food.subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (price)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      money(food.price),
                      style: const TextStyle(
                        color: EdenColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class EdenTabs extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelect;
  const EdenTabs(this.labels, this.selected, this.onSelect, {super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < labels.length; i++)
        Expanded(
          child: InkWell(
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected == i ? EdenColors.red : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: labels.length > 3 ? 10 : 13,
                  fontWeight: FontWeight.w600,
                  color: selected == i ? EdenColors.red : EdenColors.ink,
                ),
              ),
            ),
          ),
        ),
    ],
  );
}

class EdenNav extends StatelessWidget {
  final int selected;
  const EdenNav(this.selected, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: EdenColors.gold,
      borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < 4; i++)
              Semantics(
                selected: i == selected,
                child: InkWell(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    ['/home', '/connect', '/cart', '/menu'][i],
                    (_) => false,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: i == selected
                          ? EdenColors.red
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        if (i == selected) ...[
                          Text(
                            ['Home', 'Connect', 'Cart', 'Menu'][i],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Icon(
                          [
                            Icons.delivery_dining,
                            Icons.public,
                            Icons.shopping_bag_outlined,
                            Icons.grid_view_rounded,
                          ][i],
                          size: 22,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class Outcome extends StatelessWidget {
  final String title, description, art, primary, secondary;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final Widget? extra;
  final bool showArt;
  const Outcome({
    super.key,
    required this.title,
    required this.description,
    required this.art,
    required this.primary,
    required this.onPrimary,
    this.secondary = 'Back to home',
    this.onSecondary,
    this.extra,
    this.showArt = true,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF4B3D4E),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Material(
            color: EdenColors.pale,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (showArt) ...[
                    const SizedBox(height: 28),
                    Art(art, height: 160),
                  ],
                  const SizedBox(height: 24),
                  if (extra != null) ...[extra!, const SizedBox(height: 20)],
                  Primary(primary, onPrimary),
                  Secondary(secondary, onSecondary ?? () => home(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class ScreenGallery extends StatelessWidget {
  const ScreenGallery({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
    title: 'Page collection',
    child: Column(
      children: [
        for (final s in screenCatalog)
          ListTile(
            title: Text(s.title),
            subtitle: Text(s.category),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => go(context, s.route),
          ),
      ],
    ),
  );
}
