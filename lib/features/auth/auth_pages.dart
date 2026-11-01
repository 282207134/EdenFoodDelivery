import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class WelcomePage extends StatefulWidget {
  final int step;
  const WelcomePage({super.key, this.step = -1});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late final controller = PageController(
    initialPage: widget.step < 0 ? 0 : widget.step,
  );
  late int index = widget.step < 0 ? 0 : widget.step;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void finish() {
    final state = AppScope.of(context);
    state.onboarded = true;
    state.save();
    go(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.step == -1) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(38, 36, 38, 22),
            child: Column(
              children: [
                const Spacer(),
                const Art('logo', width: 132),
                const SizedBox(height: 64),
                const Text(
                  'F O\nO D',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 68,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: EdenColors.red,
                  ),
                ),
                const Spacer(),
                Primary('Come to Mino', () => go(context, '/walkthrough-1')),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    }
    const titles = [
      'Find food you love',
      'Fast delivery',
      'Enjoy the experience',
    ];
    const descriptions = [
      'Discover the best menus from over 100\ncuisines and over 1000 places.',
      'Fast & free delivery to your home or office.\nWe will deliver it, wherever you are!',
      'Don’t feel like going out? No problem,\nwe’ll deliver your order. In bed! :)',
    ];
    return Scaffold(
      backgroundColor: EdenColors.gold,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: 3,
                onPageChanged: (i) => setState(() => index = i),
                itemBuilder: (c, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Art(
                        ['intro-food', 'intro-delivery', 'intro-enjoy'][i],
                        height: 240,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        titles[i],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        descriptions[i],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    width: i == index ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: i == index
                          ? EdenColors.red
                          : Colors.white.withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 44, 38, 30),
              child: Column(
                children: [
                  Primary(index == 2 ? 'Get started' : 'Next', () {
                    if (index == 2) {
                      finish();
                    } else {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  }),
                  Secondary('Skip', finish),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  final String mode;
  const AuthPage(this.mode, {super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  final phone = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final otp = TextEditingController();
  bool agreed = false, visible = false;
  @override
  void dispose() {
    for (final c in [phone, password, name, otp]) {
      c.dispose();
    }
    super.dispose();
  }

  String? requiredValue(String? v) =>
      v == null || v.trim().isEmpty ? 'Please complete this field' : null;
  String? phoneValidator(String? v) =>
      (v ?? '').replaceAll(RegExp(r'\D'), '').length < 7
      ? 'Enter a valid phone number'
      : null;
  void submit() {
    if (!form.currentState!.validate()) return;
    if (widget.mode == 'sign-up' && !agreed) {
      notice(context, 'Please accept the terms to continue');
      return;
    }
    final s = AppScope.of(context);
    if (widget.mode == 'forgot-password') {
      notice(context, 'Demo recovery code: 2418');
      go(context, '/verification');
    } else if (widget.mode == 'verification') {
      if (otp.text != '2418') {
        notice(context, 'Use demo code 2418');
        return;
      }
      s.signedIn = true;
      s.save();
      go(context, '/notifications');
    } else {
      if (name.text.trim().isNotEmpty) s.name = name.text.trim();
      s.signedIn = false;
      s.onboarded = true;
      s.save();
      go(context, '/verification');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.mode;
    if (mode == 'auth') {
      return PageShell(
        child: Column(
          children: [
            const SizedBox(height: 70),
            const Icon(Icons.fingerprint, size: 94, color: EdenColors.gold),
            const SizedBox(height: 44),
            const Text(
              'Sign in with Touch ID',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text(
              'Use your touch ID for faster, easy access to your account',
              textAlign: TextAlign.center,
              style: TextStyle(color: EdenColors.muted),
            ),
            const SizedBox(height: 40),
            Primary('Sign in with Phone number', () => go(context, '/sign-in')),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => notice(
                context,
                'Social sign-in is not connected in this demo. Use phone sign-in.',
              ),
              child: const Text('Sign in with Facebook'),
            ),
            Secondary('New user?  Sign up now', () => go(context, '/sign-up')),
            Secondary(
              'Explore Mino Food',
              () => go(context, '/choose-location'),
            ),
          ],
        ),
      );
    }
    if (mode == 'notifications') {
      void next(bool enabled) {
        final s = AppScope.of(context);
        s.notifications = enabled;
        s.save();
        go(context, '/choose-location');
      }

      return PageShell(
        title: 'Set Notification',
        bottom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Primary('Allow Notification', () => next(true)),
            Secondary('Don’t Allow', () => next(false)),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Get updates on your order status! Allow push notifications to get real-time updates on your order.',
              style: TextStyle(color: EdenColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 36),
            const Art('notification', height: 230),
            const SizedBox(height: 26),
            const Text(
              'Notification',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23),
            ),
            const SizedBox(height: 12),
            const Text(
              'Stay notified about new food, updates,\nmenu and recipes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: EdenColors.muted, fontSize: 13),
            ),
          ],
        ),
      );
    }
    final signup = mode == 'sign-up',
        verification = mode == 'verification',
        forgot = mode == 'forgot-password';
    final title = signup
        ? 'Sign up'
        : verification
        ? 'Phone Verification'
        : forgot
        ? 'Forgot password?'
        : 'Sign in';
    return PageShell(
      bottom: Primary(
        signup
            ? 'Sign up'
            : verification
            ? 'Apply'
            : forgot
            ? 'Send link'
            : 'Sign in',
        submit,
      ),
      child: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mode == 'sign-in') ...[
              const Center(child: Art('logo', width: 132, height: 100)),
              const SizedBox(height: 28),
            ],
            Heading(title),
            const SizedBox(height: 16),
            Text(
              verification
                  ? 'Enter your OTP code here'
                  : forgot
                  ? 'Enter your phone number to reset your password.'
                  : signup
                  ? 'Let’s create your Mino Food account.'
                  : 'Enter your credential login. Fill your account detail. By signing up you accept the Terms of Service and Privacy Policy.',
              style: const TextStyle(
                color: EdenColors.muted,
                fontSize: 12,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 30),
            if (signup) ...[
              const Center(
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: EdenColors.ink,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const Center(
                child: Text('Upload Photo', style: TextStyle(fontSize: 11)),
              ),
              const SizedBox(height: 26),
              FormFieldBox(
                'Your name',
                controller: name,
                validator: requiredValue,
              ),
            ],
            if (!verification)
              FormFieldBox(
                'Your phone number',
                icon: Icons.phone_outlined,
                controller: phone,
                keyboard: TextInputType.phone,
                validator: phoneValidator,
              ),
            if (!verification && !forgot) ...[
              TextFormField(
                controller: password,
                obscureText: !visible,
                validator: (v) =>
                    (v ?? '').length < 6 ? 'Use at least 6 characters' : null,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.password, size: 19),
                  suffixIcon: IconButton(
                    tooltip: 'Show password',
                    onPressed: () => setState(() => visible = !visible),
                    icon: Icon(
                      visible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 19,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (signup)
                FormFieldBox(
                  'Repassword',
                  icon: Icons.password,
                  password: true,
                  validator: (v) =>
                      v != password.text ? 'Passwords do not match' : null,
                )
              else
                Secondary(
                  'Forgot password?',
                  () => go(context, '/forgot-password'),
                ),
            ],
            if (signup)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'I agree to the Mino Terms',
                  style: TextStyle(fontSize: 12),
                ),
                value: agreed,
                onChanged: (v) => setState(() => agreed = v!),
              ),
            if (verification) ...[
              TextFormField(
                controller: otp,
                maxLength: 4,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  letterSpacing: 18,
                  color: EdenColors.gold,
                ),
                validator: (v) =>
                    (v ?? '').length != 4 ? 'Enter the 4-digit code' : null,
                decoration: const InputDecoration(
                  hintText: '• • • •',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 24),
              Secondary(
                'Resend a new code',
                () => notice(context, 'Demo verification code: 2418'),
              ),
              const Center(
                child: Text(
                  'Demo code: 2418',
                  style: TextStyle(fontSize: 12, color: EdenColors.muted),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
