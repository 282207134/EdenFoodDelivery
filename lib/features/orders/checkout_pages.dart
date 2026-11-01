import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../domain/models.dart';
import '../../shared/widgets.dart';
import 'cart_pages.dart';

class CheckoutPage extends StatefulWidget {
  final String mode;
  const CheckoutPage(this.mode, {super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final form = GlobalKey<FormState>();
  final holder = TextEditingController(),
      number = TextEditingController(),
      expiry = TextEditingController(),
      cvv = TextEditingController();
  @override
  void dispose() {
    for (final c in [holder, number, expiry, cvv]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget steps() => const Padding(
    padding: EdgeInsets.only(bottom: 26),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.location_on_outlined, color: EdenColors.red),
        Text('• • •', style: TextStyle(color: EdenColors.red)),
        Icon(Icons.credit_card, color: EdenColors.red),
        Text('• • •', style: TextStyle(color: EdenColors.muted)),
        Icon(Icons.check_circle_outline, color: EdenColors.red),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context), mode = widget.mode;
    if (mode == 'card-success') {
      return Outcome(
        title: 'Add card success!',
        description:
            'You have successfully added the demo card and can use it to pay.',
        art: 'card-success',
        primary: 'Continue process',
        secondary: 'Come to list card',
        onPrimary: () => go(context, '/payment'),
        onSecondary: () => go(context, '/payment'),
      );
    }
    if (mode == 'order-success') {
      return Outcome(
        title: 'Order successful!',
        description: 'Your food order is completed!\nIn about 50 minutes it should be at your door.',
        art: 'order-success',
        primary: 'Track your order',
        secondary: 'Back to home',
        onPrimary: () => go(context, '/find-driver'),
        extra: Column(
          children: [
            Text(
              'Your order ID: ${s.orderId}',
              style: const TextStyle(color: EdenColors.gold),
            ),
            const SizedBox(height: 8),
            Text('Order cost: ${money(s.lastOrderTotal)}'),
          ],
        ),
      );
    }
    if (mode == 'add-card') {
      return PageShell(
        title: 'Credit new card',
        bottom: Primary('Save Card', () {
          if (!form.currentState!.validate()) return;
          s.cardLast4 = number.text.replaceAll(' ', '').substring(12);
          s.save();
          go(context, '/card-success');
        }),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter demo credit card details.',
                style: TextStyle(color: EdenColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 22),
              const Center(child: Art('credit-card', height: 170)),
              const SizedBox(height: 28),
              FormFieldBox(
                'Holder name',
                controller: holder,
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Enter cardholder name' : null,
              ),
              FormFieldBox(
                'Card number',
                controller: number,
                icon: Icons.credit_card,
                keyboard: TextInputType.number,
                validator: (v) =>
                    !RegExp(r'^\d{16}$').hasMatch((v ?? '').replaceAll(' ', ''))
                    ? 'Enter 16 digits'
                    : null,
              ),
              FormFieldBox(
                'Exp. Date (MM/YY)',
                controller: expiry,
                icon: Icons.calendar_month_outlined,
                keyboard: TextInputType.datetime,
                validator: (v) =>
                    !RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(v ?? '')
                    ? 'Use MM/YY'
                    : null,
              ),
              FormFieldBox(
                'CVV',
                controller: cvv,
                icon: Icons.lock_outline,
                keyboard: TextInputType.number,
                password: true,
                validator: (v) => !RegExp(r'^\d{3,4}$').hasMatch(v ?? '')
                    ? 'Enter 3 or 4 digits'
                    : null,
              ),
              const Text(
                'Demo only. No payment is charged. Only the last four digits are stored.',
                style: TextStyle(fontSize: 11, color: EdenColors.muted),
              ),
            ],
          ),
        ),
      );
    }
    if (mode == 'empty-payment' || mode == 'payment') {
      final empty = mode == 'empty-payment' || s.cardLast4.isEmpty;
      return PageShell(
        title: 'Payment mode',
        bottom: empty
            ? null
            : Primary('Confirm payment', () => go(context, '/checkout')),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            steps(),
            if (empty) ...[
              const SizedBox(height: 45),
              const Center(child: Art('credit-card', height: 170)),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Card not set',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'You don’t have any credit cards\nassociated with your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: EdenColors.muted),
                ),
              ),
            ] else ...[
              const Subheading('Payment method'),
              const Text(
                'Select what payment method you want to use.',
                style: TextStyle(fontSize: 12, color: EdenColors.muted),
              ),
              const SizedBox(height: 24),
              Container(
                width: 230,
                height: 145,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: EdenColors.red,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.credit_card,
                      color: EdenColors.gold,
                      size: 32,
                    ),
                    Text(
                      '**** **** **** ${s.cardLast4}',
                      style: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const Text(
                      'MINO  /  DEMO',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Surface(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.credit_card, color: EdenColors.red),
                  title: Text(
                    '**** **** ${s.cardLast4}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  subtitle: const Text(
                    'Grace Bank · Demo',
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: EdenColors.red,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 18),
            Secondary('+ Add new card', () => go(context, '/add-card')),
          ],
        ),
      );
    }
    if (mode == 'delivery') {
      return PageShell(
        title: 'Delivery',
        bottom: Primary(
          'Continue',
          () =>
              go(context, s.cardLast4.isEmpty ? '/empty-payment' : '/payment'),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            steps(),
            Surface(
              color: EdenColors.gold,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    s.address,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Shipping method',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Icon(Icons.delivery_dining, color: Colors.white),
                    ],
                  ),
                  const Text(
                    'Standard delivery · 30–50 min',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Subheading('Shipping Address'),
            const Text(
              'Select address to order information',
              style: TextStyle(color: EdenColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.map_outlined,
                size: 38,
                color: EdenColors.gold,
              ),
              title: const Text(
                'Delivery to',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(s.address, style: const TextStyle(fontSize: 12)),
              onTap: () => go(context, '/location-form'),
            ),
            Secondary(
              '+ Add another location',
              () => go(context, '/location-form'),
            ),
          ],
        ),
      );
    }
    final summary = mode == 'checkout-summary';
    return PageShell(
      title: summary ? 'Check out' : 'Detail order',
      bottom: Primary(
        summary ? 'Place order · ${money(s.total)}' : 'Checkout',
        () {
          if (s.cart.isEmpty) {
            notice(context, 'Add food to your cart first');
            return;
          }
          if (s.cardLast4.isEmpty) {
            go(context, '/empty-payment');
            return;
          }
          if (summary) {
            s.placeOrder();
            go(context, '/order-success');
          } else {
            go(context, '/checkout-summary');
          }
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!summary) steps(),
          Surface(
            onTap: () => go(context, summary ? '/payment' : '/delivery'),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                summary ? Icons.credit_card : Icons.location_on_outlined,
                color: EdenColors.red,
              ),
              title: Text(
                summary
                    ? '**** **** ${s.cardLast4.isEmpty ? 'No card' : s.cardLast4}'
                    : 'Delivery to',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              subtitle: Text(
                summary ? 'Grace Bank · Demo' : s.address,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          if (!summary) ...[
            const Subheading('Item'),
            for (final line in s.cart)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        line.food.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      '×${line.quantity}     ${money(line.total)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            const Divider(),
          ],
          Surface(child: totals(context)),
          if (summary)
            Surface(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.sell_outlined),
                    title: const Text(
                      'Promo code',
                      style: TextStyle(fontSize: 13),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => go(context, '/offers'),
                  ),
                  if (s.promo)
                    const Text(
                      '15% discount on your food',
                      style: TextStyle(color: EdenColors.teal, fontSize: 11),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          const Text(
            'This is a local checkout demo. Your card will not be charged.',
            style: TextStyle(fontSize: 11, color: EdenColors.muted),
          ),
        ],
      ),
    );
  }
}
