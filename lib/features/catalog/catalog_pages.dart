import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../domain/models.dart';
import '../../shared/widgets.dart';

class CatalogPage extends StatefulWidget {
  final String mode;
  const CatalogPage(this.mode, {super.key});
  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final query = TextEditingController();
  int tab = 0;
  String category = 'All', diet = 'Any';
  double price = 125;
  int rating = 0;
  bool promotion = false;
  bool initialized = false;
  final interests = <String>{'Sea food', 'Hamburger', 'Soft drink'};
  static const categories = [
    ('Soft drink', Icons.local_bar_outlined),
    ('High class', Icons.restaurant),
    ('Hamburger', Icons.lunch_dining),
    ('Fried food', Icons.fastfood_outlined),
    ('Cake', Icons.cake_outlined),
    ('Sea food', Icons.set_meal_outlined),
    ('Hot Pot', Icons.soup_kitchen_outlined),
    ('Barbecue', Icons.outdoor_grill_outlined),
    ('Noodle', Icons.ramen_dining_outlined),
    ('Fruit', Icons.apple_outlined),
    ('Fast food', Icons.local_pizza_outlined),
    ('Brand', Icons.storefront_outlined),
    ('Wine', Icons.wine_bar_outlined),
    ('Drink', Icons.local_drink_outlined),
    ('Canned food', Icons.kitchen_outlined),
  ];
  @override
  void initState() {
    super.initState();
    if (widget.mode == 'best-seller') tab = 1;
    if (['search-input', 'search-results'].contains(widget.mode)) {
      query.text = 'Pizza';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final s = AppScope.of(context);
      category = s.filterCategory;
      diet = s.filterDiet;
      price = s.maxPrice;
      rating = s.minRating;
      promotion = s.onlyPromotions;
      initialized = true;
    }
  }

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  Widget searchBox() => TextField(
    controller: query,
    onChanged: (_) => setState(() {}),
    onSubmitted: (_) => setState(() => tab = 0),
    decoration: InputDecoration(
      hintText: 'Search your favorite',
      prefixIcon: const Icon(Icons.search, size: 21),
      suffixIcon: IconButton(
        tooltip: 'Filter',
        onPressed: () => go(context, '/filter'),
        icon: const Icon(Icons.tune, size: 20),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final mode = widget.mode;
    final s = AppScope.of(context);
    if (mode == 'categories') {
      return PageShell(
        title: 'Category',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your interests to get the most suitable products',
              style: TextStyle(fontSize: 12, color: EdenColors.muted),
            ),
            const SizedBox(height: 26),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 104,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (c, i) {
                final item = categories[i];
                final selected = interests.contains(item.$1);
                return Semantics(
                  selected: selected,
                  child: Surface(
                    color: selected ? EdenColors.red : Colors.white,
                    padding: const EdgeInsets.all(8),
                    onTap: () {
                      setState(() {
                        if (!interests.add(item.$1)) interests.remove(item.$1);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.$2,
                          size: 27,
                          color: selected ? Colors.white : EdenColors.red,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.$1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: selected ? Colors.white : EdenColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Secondary('Explore selected food', () => go(context, '/popular')),
          ],
        ),
      );
    }
    if (mode == 'filter') {
      return PageShell(
        title: 'Filter your search',
        bottom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Primary('Apply filters', () {
              s.filterCategory = category;
              s.filterDiet = diet;
              s.maxPrice = price;
              s.minRating = rating;
              s.onlyPromotions = promotion;
              s.save();
              Navigator.pop(context);
            }),
            Secondary(
              'Clear filters',
              () => setState(() {
                category = 'All';
                diet = 'Any';
                price = 125;
                rating = 0;
                promotion = false;
              }),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Subheading('Categories'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in [
                  'All',
                  'Breakfast',
                  'Lunch',
                  'Dinner',
                  'Burgers',
                  'Special offers',
                  'Pasta',
                  'Chinese',
                  'Pizza',
                  'Salads',
                  'Soups',
                ])
                  ChoiceChip(
                    label: Text(c, style: const TextStyle(fontSize: 10)),
                    selected: category == c,
                    onSelected: (_) => setState(() => category = c),
                  ),
              ],
            ),
            const Subheading('Type of food'),
            Wrap(
              spacing: 8,
              children: [
                for (final d in ['Any', 'Vegetarian', 'Vegan', 'Lacto ovo'])
                  ChoiceChip(
                    label: Text(d, style: const TextStyle(fontSize: 10)),
                    selected: diet == d,
                    onSelected: (_) => setState(() => diet = d),
                  ),
              ],
            ),
            const SizedBox(height: 22),
            Text('\$5                         \$${price.round()}'),
            Slider(
              value: price,
              min: 5,
              max: 125,
              label: '\$${price.round()}',
              onChanged: (v) => setState(() => price = v),
            ),
            const Subheading('Rating'),
            Row(
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    tooltip: '$i stars',
                    onPressed: () => setState(() => rating = i),
                    icon: Icon(
                      i <= rating ? Icons.star : Icons.star_border,
                      color: EdenColors.gold,
                    ),
                  ),
              ],
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Promotion', style: TextStyle(fontSize: 12)),
              value: promotion,
              onChanged: (v) => setState(() => promotion = v!),
            ),
          ],
        ),
      );
    }
    final browsing = mode == 'popular' || mode == 'best-seller';
    final needle = query.text.toLowerCase();
    final results = foods
        .where(
          (f) =>
              '${f.name} ${f.subtitle}'.toLowerCase().contains(needle) &&
              s.matches(f) &&
              (!browsing || tab != 2 || ['salmon', 'banana'].contains(f.id)),
        )
        .toList();
    return PageShell(
      location: browsing,
      tab: browsing ? 0 : null,
      title: browsing ? null : 'What would you\nlike to eat?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchBox(),
          const SizedBox(height: 10),
          EdenTabs(
            browsing
                ? ['Popular', 'Best seller', 'Promo', 'Recommend']
                : ['Food', 'Place'],
            tab,
            (i) => setState(() => tab = i),
          ),
          const SizedBox(height: 16),
          if (browsing) ...[
            const Text(
              '#Drink    #Food    #Fastfood    #Seafood',
              style: TextStyle(fontSize: 10, color: EdenColors.muted),
            ),
            const SizedBox(height: 24),
            if (tab == 1)
              for (var i = 0; i < 4; i++)
                Surface(
                  onTap: () => go(context, '/restaurant'),
                  child: Row(
                    children: [
                      const Art(
                        'food-chicken',
                        width: 68,
                        height: 68,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Little Creatures -\nClub Street',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '☆ 4.7 (34.6k ratings)',
                              style: TextStyle(
                                fontSize: 10,
                                color: EdenColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.more_vert, size: 16),
                    ],
                  ),
                )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: results.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 260,
                ),
                itemBuilder: (c, i) => Surface(
                  padding: EdgeInsets.zero,
                  onTap: () {
                    s.select(results[i]);
                    go(context, '/product');
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Art(
                          results[i].image,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              results[i].name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '☆ 4.7',
                              style: TextStyle(
                                fontSize: 10,
                                color: EdenColors.muted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              money(results[i].price),
                              style: const TextStyle(
                                color: EdenColors.gold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ] else if (query.text.isEmpty) ...[
            const Subheading('Recent search'),
            for (final recent in ['Sea food', 'Cheeseburger', 'Nasi Goreng'])
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  recent,
                  style: const TextStyle(color: EdenColors.muted, fontSize: 13),
                ),
                onTap: () => setState(() => query.text = recent),
              ),
            const Subheading('Recommend for you'),
            for (final f in [foods[1], foods[5], foods[3]])
              FoodRow(f, price: false),
          ] else if (tab == 1) ...[
            const Subheading('Restaurants'),
            Surface(
              onTap: () => go(context, '/restaurant'),
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Art(
                  'food-chicken',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text('Dhaka, Restaurant'),
                subtitle: Text('Gotham Street 451 · Open'),
              ),
            ),
          ] else if (mode == 'search-input') ...[
            for (final text in [
              'Pizza Bucharest, Romania',
              'Pizza basic + Hamburgers',
              'Pizza',
            ])
              ListTile(
                title: Text(text, style: const TextStyle(fontSize: 13)),
                subtitle: const Text(
                  '#400 reviewed',
                  style: TextStyle(fontSize: 11),
                ),
                trailing: const Pill('Hot'),
                onTap: () => go(context, '/search-results'),
              ),
          ] else ...[
            if (results.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 48,
                      color: EdenColors.muted,
                    ),
                    const SizedBox(height: 14),
                    const Text('No dishes found'),
                    Secondary(
                      'Browse all food',
                      () => setState(() => query.clear()),
                    ),
                  ],
                ),
              )
            else
              for (final f in results) FoodRow(f),
            const Subheading('Recently viewed'),
            for (final f in foods.take(3)) FoodRow(f),
          ],
        ],
      ),
    );
  }
}
