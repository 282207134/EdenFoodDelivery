import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class LocationPage extends StatefulWidget {
  final String mode;
  const LocationPage(this.mode, {super.key});
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final contact = TextEditingController();
  final address = TextEditingController();
  bool saveLocation = true;
  @override
  void dispose() {
    contact.dispose();
    address.dispose();
    super.dispose();
  }

  void save() {
    if (address.text.trim().isEmpty && widget.mode != 'map') {
      notice(context, 'Please enter your address');
      return;
    }
    final s = AppScope.of(context);
    s.address = address.text.trim().isEmpty
        ? 'Aramaki Residences'
        : address.text.trim();
    s.save();
    home(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == 'choose-location') {
      return PageShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello there',
              style: TextStyle(color: EdenColors.muted),
            ),
            const SizedBox(height: 14),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Welcome to\n'),
                  TextSpan(
                    text: 'Mino Food',
                    style: TextStyle(color: EdenColors.red),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Center(child: Art('location', height: 310)),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'Choose Your Location',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please allow to use your location to show nearby places on the map.',
              textAlign: TextAlign.center,
              style: TextStyle(color: EdenColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 28),
            Center(
              child: IconButton.filled(
                tooltip: 'Choose your location',
                onPressed: () => go(context, '/location-form'),
                iconSize: 32,
                padding: const EdgeInsets.all(18),
                icon: const Icon(Icons.location_on_outlined),
              ),
            ),
          ],
        ),
      );
    }
    return PageShell(
      title: widget.mode == 'map' ? 'Map' : 'Your location',
      bottom: Primary(widget.mode == 'map' ? 'Apply' : 'Save location', save),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.mode == 'location-form') ...[
            const Text(
              'Select address to order information',
              style: TextStyle(color: EdenColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 22),
            FormFieldBox('Name contact', controller: contact),
            FormFieldBox(
              'Place Locality',
              controller: address,
              icon: Icons.apartment_outlined,
            ),
            CheckboxListTile(
              value: saveLocation,
              onChanged: (v) => setState(() => saveLocation = v!),
              title: const Text(
                'Save location',
                style: TextStyle(fontSize: 12),
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Secondary('Select on Map', () => go(context, '/map')),
          ] else
            FormFieldBox(
              'Aramaki Residences',
              controller: address,
              icon: Icons.search,
            ),
          Surface(
            padding: EdgeInsets.zero,
            onTap: widget.mode == 'map' ? null : () => go(context, '/map'),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Art(
                      'map',
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: EdenColors.red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text(
                    'Aramaki Residences',
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    '10:00 – 19:00',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
