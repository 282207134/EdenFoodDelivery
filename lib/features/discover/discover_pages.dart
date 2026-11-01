import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../domain/models.dart';
import '../../shared/widgets.dart';

class DiscoverPage extends StatefulWidget {
  final String mode;
  const DiscoverPage(this.mode, {super.key});
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final followed = <String>{};
  bool liked = false, playing = false, muted = false;
  int tab = 0;
  double progress = .23;
  Timer? timer;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void togglePlay() {
    setState(() => playing = !playing);
    timer?.cancel();
    if (playing) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {
            progress += .01;
            if (progress >= 1) {
              progress = 0;
              playing = false;
              timer?.cancel();
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.mode, s = AppScope.of(context);
    if (mode == 'connect') {
      return PageShell(
        location: true,
        tab: 1,
        child: Column(
          children: [
            SizedBox(
              height: 106,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final f in foods.take(4))
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () => go(context, '/gallery'),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Art(
                            f.image,
                            width: 76,
                            height: 96,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            EdenTabs(
              const ['Highlight', 'Following', 'Friend', 'Interests'],
              tab,
              (i) => setState(() => tab = i),
            ),
            const SizedBox(height: 22),
            for (final n
                in (tab == 1
                    ? followed.toList()
                    : ['Chinaza Akachi', 'Tô Anh Đức']))
              Surface(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: EdenColors.gold,
                        child: Text(
                          n[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        n,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      subtitle: const Text(
                        '30 minute',
                        style: TextStyle(fontSize: 10),
                      ),
                      trailing: OutlinedButton(
                        onPressed: () => setState(() {
                          if (!followed.add(n)) followed.remove(n);
                        }),
                        child: Text(
                          followed.contains(n) ? 'Following' : 'Follow',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => go(context, '/study'),
                      child: const Art(
                        'food-bowl',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Wrap(
                      children: [
                        TextButton.icon(
                          onPressed: () => setState(() => liked = !liked),
                          icon: Icon(
                            liked ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                          ),
                          label: Text(
                            '${liked ? 251 : 250} love',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => go(context, '/restaurant-chat'),
                          icon: const Icon(Icons.chat_bubble_outline, size: 16),
                          label: const Text(
                            '2 comments',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (tab == 1 && followed.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'Follow a food lover to see their posts here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: EdenColors.muted),
                ),
              ),
          ],
        ),
      );
    }
    if (mode == 'gallery' || mode == 'collection') {
      final collection = mode == 'collection';
      return PageShell(
        title: 'Gallery',
        actions: [
          IconButton(
            tooltip: 'Add to collection',
            onPressed: () {
              s.toggleFavorite(foods[1]);
              notice(context, 'Recipe collection updated');
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: 'Search',
            onPressed: () => go(context, '/search'),
            icon: const Icon(Icons.search),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EdenTabs(
              const ['Cook study', 'Collection'],
              collection ? 1 : 0,
              (i) => go(context, i == 0 ? '/gallery' : '/collection'),
            ),
            const SizedBox(height: 26),
            if (collection) ...[
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: const Art(
                      'food-bowl',
                      height: 210,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Italian\n360 photo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Subheading('Share with me'),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      child: Art('food-street', height: 270, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      children: [
                        for (final label in ['Sea Food', 'Drink', 'Place'])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => go(context, '/study'),
                              child: Container(
                                height: 78,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: EdenColors.pale,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              const Subheading('Favorite'),
              SizedBox(
                height: 325,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final f in [foods[2], foods[1]])
                      SizedBox(
                        width: 240,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Surface(
                            padding: EdgeInsets.zero,
                            onTap: () => go(context, '/study'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Art(
                                    f.image,
                                    height: 184,
                                    width: 240,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        f.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Text(
                                        'World Food · 6.2K cooked\n☆ 4.8',
                                        style: TextStyle(
                                          fontSize: 11,
                                          height: 1.7,
                                          color: EdenColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Subheading('Cooked Recipes'),
              FoodRow(foods[1], onTap: () => go(context, '/study')),
              FoodRow(
                foods[5],
                onTap: () => go(context, '/recipe-ingredients'),
              ),
            ],
          ],
        ),
      );
    }
    final recipe = mode.startsWith('recipe');
    final video = mode == 'video';
    return PageShell(
      title: recipe ? 'Egg Benedict' : 'Spicy Scrambled\nEgg Tacos',
      actions: [
        IconButton(
          tooltip: 'Save recipe',
          onPressed: () {
            s.toggleFavorite(foods[1]);
            notice(context, 'Recipe collection updated');
          },
          icon: Icon(
            s.favorites.contains(foods[1].id)
                ? Icons.bookmark
                : Icons.bookmark_border,
          ),
        ),
        IconButton(
          tooltip: 'Collection',
          onPressed: () => go(context, '/collection'),
          icon: const Icon(Icons.collections_bookmark_outlined),
        ),
      ],
      bottom: recipe || video
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Primary(
                  'Continue Cooking',
                  () => go(context, '/recipe-ingredients'),
                ),
                Secondary('+ Add to list', () {
                  s.toggleFavorite(foods[1]);
                  notice(context, 'Recipe collection updated');
                }),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!recipe) ...[
            Stack(
              alignment: Alignment.center,
              children: [
                Art(
                  progress < .5 ? 'food-bowl' : 'food-street',
                  height: 245,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                IconButton.filled(
                  tooltip: video
                      ? (playing ? 'Pause preview' : 'Play preview')
                      : 'Open recipe preview',
                  onPressed: video ? togglePlay : () => go(context, '/video'),
                  iconSize: 38,
                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                ),
              ],
            ),
            const SizedBox(height: 22),
            if (video) ...[
              Slider(
                value: progress,
                onChanged: (v) => setState(() => progress = v),
              ),
              const Text(
                'Recipe slideshow preview',
                style: TextStyle(color: EdenColors.muted, fontSize: 11),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    tooltip: 'Mute preview',
                    onPressed: () => setState(() => muted = !muted),
                    icon: Icon(
                      muted ? Icons.volume_off : Icons.volume_up_outlined,
                    ),
                  ),
                  IconButton.filled(
                    tooltip: 'Play or pause',
                    onPressed: togglePlay,
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                  ),
                  IconButton(
                    tooltip: 'Restart preview',
                    onPressed: () => setState(() => progress = 0),
                    icon: const Icon(Icons.replay),
                  ),
                ],
              ),
            ],
          ],
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 18,
            children: [
              const Text(
                '☆ 34.9k rating',
                style: TextStyle(fontSize: 11, color: EdenColors.muted),
              ),
              TextButton.icon(
                onPressed: () => setState(() => liked = !liked),
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                ),
                label: const Text('2,450 love', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RecipeStat('Servings', '2pp'),
              RecipeStat('Prep. Time', '25m'),
              RecipeStat('Cook Time', '20m'),
            ],
          ),
          if (recipe) ...[
            const Subheading('Description'),
            const Text(
              'The classic pile-up of toasted English muffins topped with seared Canadian bacon, poached eggs and creamy hollandaise sauce you usually reserve for weekend brunch plans.',
              style: TextStyle(
                fontSize: 12,
                color: EdenColors.muted,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 20),
            EdenTabs(
              const ['Ingredients', 'Directions'],
              mode == 'recipe-ingredients' ? 0 : 1,
              (i) => go(
                context,
                i == 0 ? '/recipe-ingredients' : '/recipe-directions',
              ),
            ),
            const SizedBox(height: 20),
            if (mode == 'recipe-ingredients')
              for (final text in [
                '2 – Sticks unsalted butter',
                '3 – English muffins, opened',
                '6 – Eggs, plus 3 egg yolks',
                '2 – Tablespoons lemon juice',
              ])
                Surface(
                  color: EdenColors.pale,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(text, style: const TextStyle(fontSize: 12)),
                      ),
                      const Icon(Icons.info_outline, size: 18),
                    ],
                  ),
                )
            else
              for (final text in [
                'Make the clarified butter',
                'Make the sauce',
                'Poach the eggs and serve',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Heat a small saucepan filled with 1 inch of water over medium heat until steaming. Place a heatproof bowl over the water. Add the ingredients and stir gently until smooth.',
                        style: TextStyle(
                          color: EdenColors.muted,
                          fontSize: 12,
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class RecipeStat extends StatelessWidget {
  final String label, value;
  const RecipeStat(this.label, this.value, {super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        label,
        style: const TextStyle(color: EdenColors.muted, fontSize: 11),
      ),
      const SizedBox(height: 8),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
  );
}
