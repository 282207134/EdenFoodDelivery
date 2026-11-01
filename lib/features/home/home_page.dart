import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    const tiles = [
      ('Delivery', '17.1', 'lasted', Icons.near_me, '/popular'),
      ('Category', '10', 'Favorite', Icons.pie_chart, '/categories'),
      ('Event', '10', 'Schedule', Icons.calendar_month, '/schedule'),
      ('Explore', '', '4 New!', Icons.local_fire_department, '/search'),
      ('Gallery', '', '4 New!', Icons.school, '/gallery'),
      ('Recent', '10', 'Items', Icons.save, '/cart'),
    ];
    return PageShell(
      location: true,
      tab: 0,
      actions: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: () => go(context, '/notifications'),
          icon: const Icon(Icons.notifications_none),
        ),
        IconButton(
          tooltip: 'Menu',
          onPressed: () => go(context, '/menu'),
          icon: const Icon(Icons.more_horiz),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Hi, '),
                TextSpan(
                  text: '${state.name}!',
                  style: const TextStyle(color: EdenColors.red),
                ),
              ],
            ),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),
          const Text(
            'Well come to Mino Food',
            style: TextStyle(color: EdenColors.muted),
          ),
          const SizedBox(height: 28),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tiles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              mainAxisExtent: 154,
            ),
            itemBuilder: (context, i) {
              final t = tiles[i];
              final red = i == 0;
              return Surface(
                color: red ? EdenColors.red : Colors.white,
                padding: const EdgeInsets.all(18),
                onTap: () => go(context, t.$5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      t.$4,
                      color: red ? Colors.white : const Color(0xFF232A46),
                    ),
                    Text(
                      t.$1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: red ? Colors.white : EdenColors.ink,
                      ),
                    ),
                    if (t.$2.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEFD1),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          t.$3,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFDF9100),
                          ),
                        ),
                      )
                    else
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: t.$2,
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' ${t.$3}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          style: TextStyle(
                            color: red ? Colors.white : EdenColors.ink,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
