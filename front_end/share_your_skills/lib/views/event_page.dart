import 'package:flutter/material.dart';
import 'package:share_your_skills/components/event_card.dart';
import 'package:share_your_skills/views/profile_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: EventCard(
           title: 'Gardening',
           location: 'Solna',
            date: '21 Oct',
            onTap: () {

          },
    ));
  }
}
