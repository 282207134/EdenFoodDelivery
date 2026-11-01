import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../domain/models.dart';
import '../../shared/widgets.dart';

class ProductPage extends StatefulWidget {
  final String mode;
  const ProductPage(this.mode, {super.key});
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;
  String type = 'Portion basic';
  final toppings = <String>{'Pepper topping'};
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final f = s.selectedFood;
    void add({bool checkout = false}) {
      s.add(f, quantity: quantity);
      if (checkout) {
        go(context, '/order-detail');
      } else {
        notice(context, '${f.name} added to cart');
      }
    }

    final actions = [
      IconButton(
        tooltip: 'Cart',
        onPressed: () => go(context, '/cart'),
        icon: const Icon(Icons.shopping_cart_outlined),
      ),
      IconButton(
        tooltip: 'Favorite',
        onPressed: () => s.toggleFavorite(f),
        icon: Icon(
          s.favorites.contains(f.id) ? Icons.bookmark : Icons.bookmark_border,
        ),
      ),
    ];
    if (widget.mode == 'options') {
      final extra = toppings.where((t) => t != 'Pepper topping').length * 50;
      return Outcome(
        title: 'Option',
        description: '',
        showArt: false,
        art: f.image,
        primary: 'Apply option · ${money(f.price + extra)}',
        onPrimary: () {
          s.selectedOptions = [type, ...toppings].join(', ');
          s.optionExtra = extra;
          Navigator.pop(context);
        },
        secondary: 'Cancel',
        onSecondary: () => Navigator.pop(context),
        extra: Column(
          children: [
            const Subheading('Type'),
            RadioGroup<String>(
              groupValue: type,
              onChanged: (v) => setState(() => type = v!),
              child: Column(
                children: [
                  for (final t in ['Portion basic', 'Hot sauce', 'Salsa sauce'])
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(t, style: const TextStyle(fontSize: 12)),
                      value: t,
                    ),
                ],
              ),
            ),
            const Subheading('Extra topping'),
            for (final t in [
              'Pepper topping',
              'Salami topping',
              'Extra mozzarella',
            ])
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: toppings.contains(t),
                onChanged: (_) => setState(() {
                  if (!toppings.add(t)) toppings.remove(t);
                }),
                title: Text(t, style: const TextStyle(fontSize: 12)),
                secondary: Text(
                  t == 'Pepper topping' ? '+ \$0.00' : '+ \$0.50',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
          ],
        ),
      );
    }
    if (widget.mode == 'reviews') {
      return PageShell(
        title: 'Reviews',
        child: Column(
          children: [
            ClipOval(
              child: Art(f.image, width: 124, height: 124, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Text(
              f.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
            ),
            const Text(
              'Bucharest, Romania',
              style: TextStyle(color: EdenColors.muted),
            ),
            const SizedBox(height: 26),
            Surface(
              child: Row(
                children: [
                  const Column(
                    children: [
                      Text(
                        '4.6',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('out of 5.0', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(width: 26),
                  Expanded(
                    child: Column(
                      children: [
                        for (var i = 0; i < 5; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 54,
                                  child: Text(
                                    [
                                      'Excellent',
                                      'Very Good',
                                      'Average',
                                      'Poor',
                                      'Terrible',
                                    ][i],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: 1 - i * .2,
                                    color: EdenColors.red,
                                    backgroundColor: EdenColors.pale,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Subheading('Popular Foods'),
            for (final n in [
              'Bonnie R. Miller',
              'Armaghan Chukwudi',
              'Shadhin lablu',
            ])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Text(n[0])),
                title: Text(n, style: const TextStyle(fontSize: 13)),
                subtitle: const Text(
                  '★★★★★\nAmazing food, fresh ingredients and quick delivery. I will order again!',
                  style: TextStyle(fontSize: 12, height: 1.8),
                ),
              ),
          ],
        ),
      );
    }
    if (['ingredients', 'combo', 'library'].contains(widget.mode)) {
      final selected = ['combo', 'ingredients', 'library'].indexOf(widget.mode);
      return PageShell(
        scroll: false,
        actions: actions,
        bottom: Surface(
          color: EdenColors.gold,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Subheading(
                'Wishlist',
                action: 'View all »',
                onTap: () => go(context, '/profile'),
              ),
              FoodRow(f),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Art(
                f.image,
                width: double.infinity,
                height: 210,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EdenTabs(
                      const ['Packages', 'Ingredients', 'Review'],
                      selected,
                      (i) => go(
                        context,
                        ['/combo', '/ingredients', '/library'][i],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (selected == 0) ...[
                      const Art(
                        'food-bowl',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Subheading('Combo Food Hot'),
                      const Text('☆ 4.8 (233 ratings)     ◷ 60 Minute'),
                      Text(
                        money(f.price),
                        style: const TextStyle(
                          color: EdenColors.gold,
                          fontSize: 20,
                        ),
                      ),
                      Secondary('Add combo to cart', () => add()),
                    ] else if (selected == 1) ...[
                      const Text(
                        'Grilled salmon and veggies make for a colorful and balanced seafood dinner that’s ready in just minutes. Fresh produce and carefully selected ingredients make every bite memorable.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.9,
                          color: EdenColors.muted,
                        ),
                      ),
                      const Subheading(
                        'All ingredients are fresh and natural!',
                      ),
                      for (final entry in const [
                        ('Ingredients', 'Ramen, Beef, Muer, Cabbage'),
                        ('Calorie portion', '1040 kcal'),
                        ('Protein', '58 Gr.'),
                        ('Fat', '18 Gr.'),
                      ])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  entry.$1,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.$2,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: EdenColors.muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ] else
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: [
                          for (final item in foods.take(4))
                            InkWell(
                              onTap: () => go(context, '/reviews'),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Art(item.image, fit: BoxFit.cover),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (widget.mode == 'product') {
      return PageShell(
        title: f.name,
        actions: actions,
        bottom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Primary('Order now', () => add(checkout: true)),
            Secondary('Add to cart', () => add()),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Pill('Flat sale', color: EdenColors.teal),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                money(f.price),
                style: const TextStyle(
                  color: EdenColors.gold,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ClipOval(
              child: Art(f.image, width: 310, height: 290, fit: BoxFit.cover),
            ),
            const SizedBox(height: 22),
            Text(f.subtitle, style: const TextStyle(color: EdenColors.muted)),
            Secondary('View details and options', () => go(context, '/item')),
          ],
        ),
      );
    }
    return PageShell(
      actions: actions,
      scroll: false,
      bottom: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: EdenColors.gold,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total order',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    money((f.price + s.optionExtra) * quantity),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 110,
              child: Primary('Pay Now', () => add(checkout: true)),
            ),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Art(
              f.image,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          f.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Decrease quantity',
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        tooltip: 'Increase quantity',
                        onPressed: () => setState(() => quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  Text(
                    f.subtitle,
                    style: const TextStyle(color: EdenColors.muted),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => go(context, '/reviews'),
                    child: const Text(
                      '☆ 4.6        ◷ 5 minute',
                      style: TextStyle(color: EdenColors.muted, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      for (var i = 0; i < 3; i++)
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: i == 0 ? EdenColors.red : EdenColors.pale,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              ['30%\nSweet', '30%\nFruit', '40%\nWater'][i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: i == 0 ? Colors.white : EdenColors.ink,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Secondary('Option', () => go(context, '/options')),
                  Text(s.selectedOptions, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 12),
                  Secondary(
                    'Ingredients · Packages · Reviews',
                    () => go(context, '/ingredients'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
