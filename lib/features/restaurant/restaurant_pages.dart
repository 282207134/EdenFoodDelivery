import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../shared/widgets.dart';

class RestaurantPage extends StatefulWidget {
  final String mode;
  const RestaurantPage(this.mode, {super.key});
  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  int tab = 0, feeling = 0;
  final feedback = TextEditingController();
  @override
  void dispose() {
    feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == 'feedback') {
      return PageShell(
        title: 'How do you feel?',
        bottom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Primary('Confirm', () {
              if (feedback.text.trim().isEmpty) {
                notice(context, 'Tell us about your experience');
                return;
              }
              notice(context, 'Thank you for your feedback.');
              home(context);
            }),
            Secondary('Back to home', () => home(context)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We would love to hear more about your experience!',
              style: TextStyle(color: EdenColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                for (var i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: IconButton.filledTonal(
                      tooltip: ['Happy', 'Okay', 'Unhappy'][i],
                      style: IconButton.styleFrom(
                        backgroundColor: feeling == i
                            ? EdenColors.red
                            : EdenColors.pale,
                        foregroundColor: feeling == i
                            ? Colors.white
                            : EdenColors.ink,
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed: () => setState(() => feeling = i),
                      icon: Icon(
                        [
                          Icons.sentiment_satisfied_alt,
                          Icons.sentiment_neutral,
                          Icons.sentiment_dissatisfied,
                        ][i],
                      ),
                    ),
                  ),
              ],
            ),
            const Subheading('Give us feedback'),
            TextField(
              controller: feedback,
              maxLength: 100,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your suggestion here',
              ),
            ),
          ],
        ),
      );
    }
    return PageShell(
      scroll: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF909090), Color(0xFFBBBBBB)],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Dhaka, Restaurant',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Gotham Street 451',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 22),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Pill('◷ Open', color: EdenColors.teal),
                      SizedBox(width: 14),
                      Pill('☆ 9.6'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                        tooltip: 'Call restaurant',
                        onPressed: () => go(context, '/call'),
                        icon: const Icon(Icons.phone_outlined),
                      ),
                      const SizedBox(width: 24),
                      IconButton.filled(
                        tooltip: 'Message restaurant',
                        onPressed: () => go(context, '/restaurant-chat'),
                        icon: const Icon(Icons.chat_bubble_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EdenTabs(
                    const ['Recommend', 'Info', 'Menu', 'Photo'],
                    tab,
                    (i) => setState(() => tab = i),
                  ),
                  const SizedBox(height: 20),
                  if (tab == 2) ...[
                    Secondary('Browse the menu', () => go(context, '/popular')),
                    const Art(
                      'food-bowl',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ] else if (tab == 3) ...[
                    const Art(
                      'food-chicken',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    const Art(
                      'food-street',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ] else ...[
                    const Art(
                      'food-chicken',
                      width: double.infinity,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      '32/1B, West Sukrabad, Dhaka, Bangladesh.\nClosed in 45 minutes. 11AM to 12 Midnight (Today).\nCasual Dining · Dhaka · PizzaHut.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.8,
                        color: EdenColors.muted,
                      ),
                    ),
                    Subheading(
                      'Reviews',
                      action: 'Read all (344)',
                      onTap: () => go(context, '/reviews'),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(child: Text('S')),
                      title: Text(
                        'Shadhin lablu',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'A week ago\nLove it! The staff are friendly and they have amazing lunch deals.',
                        style: TextStyle(fontSize: 12, height: 1.7),
                      ),
                    ),
                    Secondary(
                      'Give us feedback',
                      () => go(context, '/feedback'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final bool driver;
  const ChatPage({super.key, this.driver = false});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final message = TextEditingController();
  final scroll = ScrollController();
  final messages = <(String, bool)>[
    ('Hello, may I ask some question to you?', false),
    ('Are you happy with my delivery services?', false),
    ('Sure, I’m happy', true),
  ];
  @override
  void initState() {
    super.initState();
    if (widget.driver) {
      messages.clear();
      messages.add((
        'I’m Jonan, your driver. I will pick up your food soon.',
        false,
      ));
    }
  }

  @override
  void dispose() {
    message.dispose();
    scroll.dispose();
    super.dispose();
  }

  void send([String? text]) {
    final value = (text ?? message.text).trim();
    if (value.isEmpty) return;
    setState(() => messages.add((value, true)));
    message.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => PageShell(
    title: null,
    scroll: false,
    actions: [
      IconButton(
        tooltip: 'Call',
        onPressed: () => go(context, '/call'),
        icon: const Icon(Icons.phone_outlined),
      ),
    ],
    bottom: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: message,
                onSubmitted: (_) => send(),
                decoration: const InputDecoration(
                  hintText: 'Type something text',
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              tooltip: 'Send message',
              onPressed: send,
              icon: const Icon(Icons.send_outlined),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            for (final text in ['Hello', 'May I ask', 'I’m okay'])
              TextButton(
                onPressed: () => send(text),
                child: Text(text, style: const TextStyle(fontSize: 10)),
              ),
          ],
        ),
      ],
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Heading(widget.driver ? 'From Jonan' : 'Burger Restaurant'),
        ),
        const Text(
          'Today',
          style: TextStyle(fontSize: 11, color: EdenColors.muted),
        ),
        Expanded(
          child: ListView.builder(
            controller: scroll,
            padding: const EdgeInsets.all(28),
            itemCount: messages.length,
            itemBuilder: (c, i) {
              final m = messages[i];
              return Align(
                alignment: m.$2 ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 240),
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: m.$2 ? EdenColors.pale : EdenColors.gold,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    m.$1,
                    style: TextStyle(
                      fontSize: 13,
                      color: m.$2 ? EdenColors.ink : Colors.white,
                      height: 1.7,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class CallPage extends StatefulWidget {
  const CallPage({super.key});
  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool muted = false, held = false, speaker = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: EdenColors.ink,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              'Burger Restaurant',
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Gotham Street 451',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            const Text(
              'Demo call preview',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final item in [
                  (
                    Icons.mic_off_outlined,
                    'Mute',
                    muted,
                    () => setState(() => muted = !muted),
                  ),
                  (
                    Icons.pause,
                    'Hold',
                    held,
                    () => setState(() => held = !held),
                  ),
                  (
                    Icons.volume_up_outlined,
                    'Speaker',
                    speaker,
                    () => setState(() => speaker = !speaker),
                  ),
                ])
                  Column(
                    children: [
                      IconButton(
                        tooltip: item.$2,
                        onPressed: item.$4,
                        icon: Icon(
                          item.$1,
                          color: item.$3 ? EdenColors.gold : Colors.white60,
                          size: 30,
                        ),
                      ),
                      Text(
                        item.$2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 40),
            IconButton.filled(
              tooltip: 'End call',
              style: IconButton.styleFrom(padding: const EdgeInsets.all(26)),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.call_end, size: 32),
            ),
            const Spacer(),
          ],
        ),
      ),
    ),
  );
}
