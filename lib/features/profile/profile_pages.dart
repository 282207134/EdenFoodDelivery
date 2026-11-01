import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../domain/models.dart';
import '../../shared/widgets.dart';

class ProfilePage extends StatefulWidget {
  final String mode;
  const ProfilePage(this.mode, {super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int membership = 0;
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context), mode = widget.mode;
    if (mode == 'menu') {
      return PageShell(
        tab: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 55),
            InkWell(
              onTap: () => go(context, '/membership'),
              child: const Pill('☆ Go Membership'),
            ),
            const SizedBox(height: 28),
            Text(
              s.name == 'Jack' ? 'Victor Niculici' : s.name,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            for (final e in const [
              (Icons.people_outline, 'Friend', '/connect'),
              (Icons.person_outline, 'My profile', '/profile'),
              (Icons.settings_outlined, 'Settings', '/settings'),
              (Icons.chat_outlined, 'Contact', '/restaurant-chat'),
              (Icons.sell_outlined, 'Personal Offer', '/offers'),
              (Icons.history, 'History active', '/cart'),
              (Icons.info_outline, 'About us', '/about'),
            ])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(e.$1, size: 23),
                title: Text(
                  e.$2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => go(context, e.$3),
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () {
                s.signedIn = false;
                s.save();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/auth',
                  (_) => false,
                );
              },
            ),
          ],
        ),
      );
    }
    if (mode == 'settings') {
      return PageShell(
        title: 'Settings',
        child: Column(
          children: [
            Surface(
              child: Column(
                children: [
                  settingsRow(
                    'Language',
                    'English',
                    () => notice(context, 'The original UI kit uses English.'),
                  ),
                  settingsRow(
                    'Change Password',
                    '••••••••',
                    () => go(context, '/forgot-password'),
                  ),
                  settingsRow(
                    'Location',
                    s.address,
                    () => go(context, '/location-form'),
                  ),
                  settingsRow(
                    'Payment method',
                    s.cardLast4.isEmpty
                        ? 'Card not set'
                        : 'Card Visa · ${s.cardLast4}',
                    () => go(context, '/payment'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Surface(
              child: Column(
                children: [
                  for (final entry in [
                    (
                      'Receive notifications',
                      s.notifications,
                      (bool v) {
                        s.notifications = v;
                        s.save();
                      },
                    ),
                    (
                      'Receive special offers',
                      s.offers,
                      (bool v) {
                        s.offers = v;
                        s.save();
                      },
                    ),
                    (
                      'Receive newsletters',
                      s.newsletters,
                      (bool v) {
                        s.newsletters = v;
                        s.save();
                      },
                    ),
                  ])
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        entry.$1,
                        style: const TextStyle(
                          fontSize: 11,
                          color: EdenColors.muted,
                        ),
                      ),
                      subtitle: Text(
                        entry.$2 ? 'Enabled' : 'Disabled',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: entry.$2,
                      onChanged: entry.$3,
                    ),
                ],
              ),
            ),
            if (kDebugMode)
              Secondary('Page collection', () => go(context, '/screens')),
          ],
        ),
      );
    }
    if (mode == 'membership') {
      return PageShell(
        title: 'Membership',
        bottom: Primary(
          'Buy ${membership == 0 ? '3' : '12'} months membership',
          () => notice(
            context,
            'Membership preview selected. Purchase is not connected.',
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Applicable to all stores in the city using our system',
              style: TextStyle(fontSize: 12, color: EdenColors.muted),
            ),
            const SizedBox(height: 24),
            const Surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subheading('Select membership'),
                  Text(
                    '☆ +5% points in bill\n♧ Free shipping within 5km',
                    style: TextStyle(
                      color: EdenColors.muted,
                      height: 2,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Registrations prior to 1/6 will also receive an additional bonus',
                    style: TextStyle(color: EdenColors.muted, fontSize: 11),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('1 + 1\non food'),
                      Text('2 + 2\non drinks'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                for (var i = 0; i < 2; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i == 0 ? 16 : 0),
                      child: Surface(
                        color: membership == i
                            ? EdenColors.red
                            : EdenColors.pale,
                        onTap: () => setState(() => membership = i),
                        padding: const EdgeInsets.all(22),
                        child: Text(
                          '${i == 0 ? 3 : 12} months\n\nmembership\n\n${i == 0 ? '\$799' : '\$1,899'}',
                          style: TextStyle(
                            color: membership == i
                                ? Colors.white
                                : EdenColors.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }
    if (mode == 'about') {
      return const PageShell(
        title: 'Mino Food',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Art('logo', height: 110),
            SizedBox(height: 24),
            Text(
              'Find food you love.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Text(
              'Discover local food, plan dinner with friends and learn a new recipe. Eden is a Flutter UI implementation of the Mino Food design in Pixso.',
              style: TextStyle(height: 1.8, color: EdenColors.muted),
            ),
          ],
        ),
      );
    }
    final edit = mode == 'edit-profile';
    return PageShell(
      bottom: null,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: EdenColors.pale,
            child: Icon(Icons.person_outline, size: 60, color: EdenColors.gold),
          ),
          const SizedBox(height: 24),
          Text(
            edit ? s.name : 'Natalie Adams',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Senior Food Traveler',
            style: TextStyle(color: EdenColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 24),
          if (edit)
            Surface(
              child: Column(
                children: [
                  settingsRow('Name', s.name, () => editName(context)),
                  settingsRow(
                    'Email',
                    s.profile['Email'] ?? 'natalie@example.com',
                    () => editValue(
                      context,
                      'Email',
                      s.profile['Email'] ?? 'natalie@example.com',
                    ),
                  ),
                  settingsRow(
                    'Phone number',
                    s.profile['Phone number'] ?? '+4 0767 217 315',
                    () => editValue(
                      context,
                      'Phone number',
                      s.profile['Phone number'] ?? '+4 0767 217 315',
                    ),
                  ),
                  settingsRow(
                    'Current location',
                    s.address,
                    () => go(context, '/location-form'),
                  ),
                  settingsRow(
                    'Gender',
                    s.profile['Gender'] ?? 'Female',
                    () => editValue(
                      context,
                      'Gender',
                      s.profile['Gender'] ?? 'Female',
                    ),
                  ),
                  settingsRow(
                    'Date of birth',
                    s.profile['Date of birth'] ?? '16/04/1988',
                    () => editValue(
                      context,
                      'Date of birth',
                      s.profile['Date of birth'] ?? '16/04/1988',
                    ),
                  ),
                ],
              ),
            )
          else ...[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1.2K\nFollowers',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, height: 1.8),
                ),
                SizedBox(width: 40),
                Text(
                  '500\nFollowings',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, height: 1.8),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in const [
                  (Icons.chat_bubble_outline, 'Message', '/restaurant-chat'),
                  (Icons.favorite_outline, 'Favorite', '/library'),
                  (Icons.bookmark_outline, 'Mark', '/collection'),
                  (Icons.info_outline, 'Info', '/edit-profile'),
                ])
                  InkWell(
                    onTap: () => go(context, e.$3),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: EdenColors.pale,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(e.$1, size: 21),
                          const SizedBox(height: 5),
                          Text(e.$2, style: const TextStyle(fontSize: 9)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Subheading(
              'Favorite Recipes',
              action: 'View all »',
              onTap: () => go(context, '/gallery'),
            ),
            if (s.favorites.isEmpty)
              const Text(
                'Save dishes and recipes to build your collection.',
                style: TextStyle(fontSize: 12, color: EdenColors.muted),
              ),
            for (final f in foods.where((f) => s.favorites.contains(f.id)))
              FoodRow(f),
            Subheading(
              'Food Photos',
              action: 'Show all',
              onTap: () => go(context, '/collection'),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: const Art(
                'food-street',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget settingsRow(String title, String value, VoidCallback onTap) =>
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(color: EdenColors.muted, fontSize: 11),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        trailing: TextButton(
          onPressed: onTap,
          child: const Text('Change', style: TextStyle(fontSize: 10)),
        ),
      );
  Future<void> editName(BuildContext context) async {
    final s = AppScope.of(context);
    final value = await editValue(context, 'Name', s.name);
    if (value != null) {
      s.name = value;
      s.save();
    }
  }

  Future<String?> editValue(
    BuildContext context,
    String label,
    String value,
  ) async {
    final c = TextEditingController(text: value);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (c.text.trim().isNotEmpty) {
                Navigator.pop(context, c.text.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    // The dialog owns its TextField until its closing animation completes.
    Future<void>.delayed(const Duration(milliseconds: 400), c.dispose);
    if (result != null && mounted) {
      final state = AppScope.of(this.context);
      if (label != 'Name') {
        state.profile[label] = result;
        state.save();
      }
    }
    if (result != null && mounted) {
      notice(this.context, 'Your changes have been saved.');
    }
    return result;
  }
}
