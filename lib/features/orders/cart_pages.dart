import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../domain/models.dart';
import '../../shared/widgets.dart';

class CartPage extends StatefulWidget {
  final String mode;
  const CartPage(this.mode, {super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final promoCode = TextEditingController();
  @override
  void dispose() {
    promoCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final mode = widget.mode;
    if (mode == 'remove-order') {
      return Outcome(
        title: 'Remove order #456123?',
        description:
            'If you delete it, it will not appear in your order list anymore.',
        art: 'remove-order',
        primary: 'Yes, Remove order',
        secondary: 'No, I want to keep it',
        onPrimary: () {
          s.cart.clear();
          s.save();
          Navigator.pop(context);
        },
        onSecondary: () => Navigator.pop(context),
      );
    }
    if (mode == 'voucher') {
      return Outcome(
        title: 'Promo code',
        description: 'Do you want to use the code SF478DT?\nSave 15% on your food order.',
        art: 'intro-delivery',
        primary: 'Apply code',
        secondary: 'Cancel',
        onPrimary: () {
          s.promo = true;
          s.save();
          notice(context, '15% discount applied');
          Navigator.pop(context);
        },
        onSecondary: () => Navigator.pop(context),
      );
    }
    if (mode == 'offers') {
      return PageShell(
        title: 'Personal Offer',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: promoCode,
              decoration: InputDecoration(
                hintText: 'Enter promo code',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: 'Apply promo code',
                  onPressed: () {
                    if ([
                      'SF478DT',
                      'SKTHN4',
                      'MINO15',
                    ].contains(promoCode.text.trim().toUpperCase())) {
                      go(context, '/voucher');
                    } else {
                      notice(context, 'Use demo promo code MINO15');
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Surface(
              color: EdenColors.teal,
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '40% Discount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Fresh drink\nBlueberry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const Art(
                      'banana',
                      width: 110,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const Subheading('Promo code'),
            for (final entry in const [
              ('15%', 'Black friday day', 'SF478DT'),
              ('23%', 'Promote Day', 'SKTHN4'),
            ])
              Surface(
                onTap: () => go(context, '/voucher'),
                color: EdenColors.pale,
                child: Row(
                  children: [
                    Text(
                      entry.$1,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.$2,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            'All you can eat',
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            entry.$3,
                            style: const TextStyle(
                              color: EdenColors.gold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
          ],
        ),
      );
    }
    if (mode == 'qr') {
      return PageShell(
        title: 'QR code',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scan for demo invoice details',
              style: TextStyle(color: EdenColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 38),
            Surface(
              child: Column(
                children: [
                  QrImageView(
                    data:
                        'MINO|${s.orderId}|${money(s.lastOrderTotal)}|${s.address}',
                    size: 265,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: EdenColors.gold,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: EdenColors.gold,
                    ),
                  ),
                  const Divider(height: 40),
                  Text(
                    '#${s.orderId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Matthew Copeland Store',
                    style: TextStyle(fontSize: 12, color: EdenColors.muted),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (mode == 'bill') {
      return PageShell(
        title: 'Detail order',
        bottom: Primary('Copy invoice', () async {
          await Clipboard.setData(
            ClipboardData(
              text:
                  'Mino Food\nOrder #${s.orderId}\n${s.address}\nTotal: ${money(s.lastOrderTotal)}\n${s.orderStatus}',
            ),
          );
          if (context.mounted) {
            notice(context, 'Invoice copied. You can paste it into an email.');
          }
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${s.orderId}, ${s.orderStatus.isEmpty ? 'Demo invoice' : s.orderStatus}',
              style: const TextStyle(color: EdenColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 50),
            Text(
              '#${s.orderId}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            for (final item in s.lastOrderItems)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['name'] as String,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      "${item['quantity']} × ${money((item['total'] as int) ~/ (item['quantity'] as int))}",
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            const Divider(),
            totals(context, invoice: true),
            Secondary('Show QR code', () => go(context, '/qr')),
          ],
        ),
      );
    }
    final isMain = mode == 'cart' || mode == 'empty-cart';
    final empty =
        mode == 'empty-cart' ||
        (s.cart.isEmpty && (s.orderStatus.isEmpty || !isMain));
    return PageShell(
      title: isMain ? 'Cart' : 'Order #456123',
      location: isMain,
      tab: isMain ? 2 : null,
      bottom: isMain
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Primary(
                  'Checkout',
                  s.cart.isEmpty ? null : () => go(context, '/delivery'),
                ),
                Secondary(
                  'Add to schedule',
                  () => go(context, '/create-schedule'),
                ),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (empty) ...[
            const SizedBox(height: 28),
            const Center(child: Art('empty-cart', height: 225)),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Today is a good day for you\nto make a choice',
                textAlign: TextAlign.center,
                style: TextStyle(color: EdenColors.muted, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
            Secondary('Discover food', () => go(context, '/popular')),
          ] else if (s.cart.isEmpty) ...[
            Surface(
              onTap: () => go(context, '/tracking-map'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Order #${s.orderId}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Pill(s.orderStatus),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FoodRow(foods[1]),
                  const Divider(),
                  totals(context, invoice: true),
                ],
              ),
            ),
            Primary('Track your order', () => go(context, '/tracking-map')),
          ] else ...[
            if (!isMain)
              Text(
                '${s.count} items added to cart',
                style: const TextStyle(fontSize: 12, color: EdenColors.muted),
              ),
            const SizedBox(height: 12),
            Surface(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Order #456123',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove order',
                        onPressed: () => go(context, '/remove-order'),
                        icon: const Icon(Icons.delete_outline, size: 20),
                      ),
                    ],
                  ),
                  for (final line in s.cart)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Art(
                              line.food.image,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  line.food.name,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  line.options,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: EdenColors.muted,
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      height: 32,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        tooltip: 'Remove ${line.food.name}',
                                        onPressed: () => s.change(line, -1),
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${line.quantity}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: 30,
                                      height: 32,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        tooltip: 'Add ${line.food.name}',
                                        onPressed: () => s.change(line, 1),
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            money(line.total),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Secondary('Add more item', () => go(context, '/popular')),
                  const Divider(),
                  totals(context),
                ],
              ),
            ),
            if (isMain)
              Primary('Review order', () => go(context, '/order-detail')),
          ],
          const SizedBox(height: 20),
          if (isMain && !empty) ...[
            const Subheading('History order'),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: EdenColors.pale,
              title: Text(
                'Order #${s.orderId}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                s.orderStatus.isEmpty
                    ? 'Demo order · Delivered'
                    : s.orderStatus,
                style: const TextStyle(color: EdenColors.gold, fontSize: 11),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => go(context, '/bill'),
            ),
          ],
        ],
      ),
    );
  }
}

Widget totals(BuildContext context, {bool invoice = false}) {
  final s = AppScope.of(context);
  final rows = invoice
      ? [('Total', s.lastOrderTotal)]
      : [
          ('Subtotal', s.subtotal),
          ('Delivery', s.deliveryFee),
          if (s.promo) ('Discount', -s.discount),
          ('Total', s.total),
        ];
  return Column(
    children: [
      for (var i = 0; i < rows.length; i++)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  rows[i].$1,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                money(rows[i].$2),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: i == rows.length - 1
                      ? EdenColors.gold
                      : EdenColors.ink,
                ),
              ),
            ],
          ),
        ),
    ],
  );
}
