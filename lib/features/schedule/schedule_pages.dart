import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class SchedulePage extends StatefulWidget {
  final String mode;
  const SchedulePage(this.mode, {super.key});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final name = TextEditingController();
  final participants = TextEditingController();
  final location = TextEditingController();
  final thoughts = TextEditingController();
  DateTime? date;
  TimeOfDay? time;
  @override
  void initState() {
    super.initState();
    if (widget.mode == 'schedule-form') {
      name.text = 'Daily dinner delivery';
      participants.text = 'John, Xemesis';
      location.text = 'Tel-Aviv';
    }
  }

  @override
  void dispose() {
    for (final c in [name, participants, location, thoughts]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (widget.mode == 'schedule-success') {
      return Outcome(
        title: 'Schedule Successful',
        description:
            'Reminders inform you of the dates, good food is waiting for you',
        art: 'schedule-success',
        primary: 'Come detail',
        onPrimary: () => go(context, '/schedule-detail'),
      );
    }
    if (widget.mode == 'schedule-detail') {
      return PageShell(
        title: state.schedules.last,
        bottom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Primary('I’m going', () {
              notice(context, 'You joined this dinner');
              home(context);
            }),
            Secondary('Sorry I could not join', () {
              notice(context, 'Your response was saved');
              home(context);
            }),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jennifer · Helsinki',
              style: TextStyle(color: EdenColors.muted),
            ),
            const SizedBox(height: 22),
            const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Art(
                'map',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const Subheading('Participants'),
            const Row(
              children: [
                CircleAvatar(child: Text('J')),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: EdenColors.gold,
                  child: Text('N'),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: EdenColors.teal,
                  child: Text('+3'),
                ),
              ],
            ),
            const Subheading('Description'),
            const Text(
              '◷ 8:00 PM                 ♧ 5 people',
              style: TextStyle(color: EdenColors.muted),
            ),
            const SizedBox(height: 14),
            const Text(
              'A dinner together, a new place to discover. Join your friends for fresh food and a memorable evening.',
              style: TextStyle(color: EdenColors.muted, height: 1.8),
            ),
          ],
        ),
      );
    }
    if (widget.mode == 'schedule') {
      return PageShell(
        title: 'My Schedule',
        actions: [
          IconButton(
            tooltip: 'Create schedule',
            onPressed: () => go(context, '/create-schedule'),
            icon: const Icon(Icons.add),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have ${state.schedules.length} submissions today',
              style: const TextStyle(color: EdenColors.muted, fontSize: 12),
            ),
            const Subheading('Upcoming events'),
            SizedBox(
              height: 330,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.schedules.length,
                separatorBuilder: (_, i) => const SizedBox(width: 14),
                itemBuilder: (context, i) => SizedBox(
                  width: 240,
                  child: Surface(
                    color: i == 0 ? EdenColors.red : Colors.white,
                    onTap: () => go(context, '/schedule-detail'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i == 0 ? '8:00 PM' : '6:00',
                          style: TextStyle(
                            color: i == 0 ? Colors.white : EdenColors.ink,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Art(
                            i == 0 ? 'food-chicken' : 'food-bowl',
                            height: 90,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.schedules[i],
                          style: TextStyle(
                            color: i == 0 ? Colors.white : EdenColors.ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '♧ Helsinki',
                          style: TextStyle(
                            color: i == 0 ? Colors.white70 : EdenColors.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: EdenColors.gold,
                              child: Text('J', style: TextStyle(fontSize: 12)),
                            ),
                            CircleAvatar(
                              radius: 14,
                              child: Text('+2', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Subheading('History schedule'),
            for (final s in state.schedules)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                onTap: () => go(context, '/schedule-detail'),
                leading: const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Art(
                    'food-bowl',
                    width: 86,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  s,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  '♧ 5 people\n◷ 8:00 PM',
                  style: TextStyle(fontSize: 12, height: 1.8),
                ),
              ),
          ],
        ),
      );
    }
    return PageShell(
      title: 'Create Schedule',
      bottom: Primary('Add new schedule', () {
        if (name.text.trim().isEmpty ||
            location.text.trim().isEmpty ||
            date == null) {
          notice(context, 'Please add a name, location and date');
          return;
        }
        state.schedules.add(name.text.trim());
        state.save();
        go(context, '/schedule-success');
      }),
      child: Column(
        children: [
          FormFieldBox(
            'Name schedule',
            icon: Icons.menu_book_outlined,
            controller: name,
          ),
          FormFieldBox(
            'Location',
            icon: Icons.location_on_outlined,
            controller: location,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: EdenColors.pale,
              leading: const Icon(Icons.calendar_month_outlined),
              title: Text(
                date == null
                    ? 'Set date'
                    : '${date!.year}-${date!.month}-${date!.day}   ${time?.format(context) ?? ''}',
                style: const TextStyle(fontSize: 13),
              ),
              trailing: const Icon(Icons.expand_more),
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 730)),
                );
                if (selected == null || !context.mounted) return;
                final t = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 20, minute: 0),
                );
                if (mounted) {
                  setState(() {
                    date = selected;
                    time = t;
                  });
                }
              },
            ),
          ),
          FormFieldBox('Participants', controller: participants),
          FormFieldBox(
            'Add your thoughts here …',
            controller: thoughts,
            lines: 4,
          ),
          Secondary('Add order', () => go(context, '/popular')),
        ],
      ),
    );
  }
}
