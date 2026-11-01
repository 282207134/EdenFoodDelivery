import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class DeliveryPage extends StatefulWidget {
  final String mode;
  const DeliveryPage(this.mode, {super.key});
  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  int rating = 0;
  final thoughts = TextEditingController();
  @override
  void dispose() {
    thoughts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context), mode = widget.mode;
    if (mode == 'delivery-success') {
      return Outcome(
        title: 'Delivery Successful',
        description:
            'Your order has been delivered successfully. Please rate it now.',
        art: 'delivery-success',
        primary: 'Rate your order',
        secondary: 'Cancel',
        onPrimary: () {
          s.orderStatus = 'Delivered';
          s.save();
          go(context, '/rate-order');
        },
      );
    }
    if (mode == 'rate-order') {
      return PageShell(
        title: 'Rate your order',
        bottom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Primary('Submit', () {
              if (rating == 0) {
                notice(context, 'Choose a star rating');
                return;
              }
              s.rating = rating;
              s.orderStatus = 'Delivered';
              s.save();
              notice(context, 'Thanks for your $rating-star review');
              home(context);
            }),
            Secondary('Back to home', () => home(context)),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'We would love to hear more about your experience!',
              style: TextStyle(color: EdenColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 30),
            const ClipOval(
              child: Art(
                'food-tacos',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Kue Dadar Telur',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    tooltip: 'Rate $i stars',
                    onPressed: () => setState(() => rating = i),
                    icon: Icon(
                      i <= rating ? Icons.star : Icons.star_outline,
                      color: EdenColors.gold,
                    ),
                  ),
              ],
            ),
            const Text(
              '225 Reviews',
              style: TextStyle(fontSize: 11, color: EdenColors.muted),
            ),
            const SizedBox(height: 30),
            FormFieldBox(
              'Add your thoughts here …',
              controller: thoughts,
              lines: 4,
            ),
          ],
        ),
      );
    }
    if (mode == 'find-driver') {
      return PageShell(
        title: 'Find driver',
        bottom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Primary('Follow driver', () => go(context, '/tracking-map')),
            Secondary(
              'Find different driver',
              () => notice(
                context,
                'Mr. John Watson is the nearest available demo driver',
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              '⌖ ${s.address}',
              style: const TextStyle(color: EdenColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 48),
            const Art('drivers', height: 300),
            const SizedBox(height: 36),
            Surface(
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: EdenColors.gold,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  'Mr. John Watson',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                subtitle: Text('Your driver', style: TextStyle(fontSize: 12)),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      );
    }
    if (mode == 'tracking-route') {
      return PageShell(
        title: 'Tracking route',
        bottom: Primary('Follow driver', () => go(context, '/follow-driver')),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Allow push notifications to get real-time updates on your order status.',
              style: TextStyle(fontSize: 12, color: EdenColors.muted),
            ),
            const SizedBox(height: 22),
            const FoodStore(),
            Subheading(
              'Payment method',
              action: 'Show all',
              onTap: () => go(context, '/bill'),
            ),
            for (final e in const [
              (
                Icons.check_circle_outline,
                'Complete at 8.39 AM',
                'Arrived order\non Sleman, DIY',
              ),
              (
                Icons.delivery_dining,
                'Driver on the way',
                'Sarwoto is your courier',
              ),
              (
                Icons.schedule,
                'Driver pickup item at 8.00 AM',
                'Andalas store',
              ),
            ])
              IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6E3E8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(e.$1, color: EdenColors.red),
                        ),
                        Expanded(
                          child: Container(width: 2, color: EdenColors.pale),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.$2, style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 14),
                            Surface(
                              color: EdenColors.pale,
                              child: Text(
                                e.$3,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: EdenColors.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
    if (mode == 'follow-driver') {
      return PageShell(
        scroll: false,
        bottom: Primary(
          'Confirm delivery received',
          () => go(context, '/delivery-success'),
        ),
        child: Column(
          children: [
            const Expanded(
              child: Art('map', width: double.infinity, fit: BoxFit.cover),
            ),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.location_on, color: EdenColors.gold, size: 36),
                  SizedBox(height: 14),
                  Text(
                    'Downtown West',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'St. Louis, MO, USA',
                    style: TextStyle(fontSize: 12, color: EdenColors.muted),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'The driver is taking food for you. Please wait 15 minutes!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: EdenColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return PageShell(
      scroll: false,
      actions: [
        IconButton(
          tooltip: 'Tracking route',
          onPressed: () => go(context, '/tracking-route'),
          icon: const Icon(Icons.route_outlined),
        ),
        IconButton(
          tooltip: 'Follow driver',
          onPressed: () => go(context, '/follow-driver'),
          icon: const Icon(Icons.near_me_outlined),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Art(
                  'map',
                  height: 330,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 170,
                  height: 200,
                  child: CustomPaint(painter: RoutePainter()),
                ),
                Positioned(
                  bottom: 40,
                  right: 65,
                  child: IconButton.filled(
                    tooltip: 'Follow driver',
                    onPressed: () => go(context, '/follow-driver'),
                    icon: const Icon(Icons.delivery_dining),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Heading('Tracking map'),
                  const SizedBox(height: 12),
                  const Text(
                    'Your order should be at your location in',
                    style: TextStyle(color: EdenColors.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: EdenColors.gold,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sergio Pliego',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'ID - 68A4566',
                              style: TextStyle(
                                color: EdenColors.muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filled(
                        tooltip: 'Call driver',
                        onPressed: () => go(context, '/call'),
                        icon: const Icon(Icons.call, size: 20),
                      ),
                      IconButton.filled(
                        tooltip: 'Message driver',
                        onPressed: () => go(context, '/driver-chat'),
                        icon: const Icon(Icons.chat_bubble_outline, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Surface(
                    color: EdenColors.gold,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order code      #${s.orderId}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Arrival time       12:42 min',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => go(context, '/tracking-route'),
                          child: const Text('Route'),
                        ),
                      ],
                    ),
                  ),
                  Secondary(
                    'Follow driver',
                    () => go(context, '/follow-driver'),
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

class FoodStore extends StatelessWidget {
  const FoodStore({super.key});
  @override
  Widget build(BuildContext context) => const ListTile(
    contentPadding: EdgeInsets.zero,
    leading: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Art('food-chicken', width: 52, height: 52, fit: BoxFit.cover),
    ),
    title: Text(
      'Andalas store',
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
    subtitle: Text('30 minute', style: TextStyle(fontSize: 11)),
  );
}

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = EdenColors.red
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(20, 20)
      ..lineTo(45, 65)
      ..lineTo(92, 85)
      ..lineTo(92, 155)
      ..lineTo(145, 180);
    canvas.drawPath(path, p);
    p.style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(20, 20), 9, p);
    canvas.drawCircle(const Offset(145, 180), 9, p);
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) => false;
}
