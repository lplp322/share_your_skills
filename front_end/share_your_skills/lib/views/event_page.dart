import 'package:flutter/material.dart';
import 'package:share_your_skills/components/event_card.dart';
import 'package:share_your_skills/viewmodels/post_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/views/show_post_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool currentEventsExpanded = true; // Track the state of current events.

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'Current Events',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            trailing: IconButton(
              icon: Icon(currentEventsExpanded
                  ? Icons.expand_less
                  : Icons.expand_more),
              onPressed: () {
                setState(() {
                  currentEventsExpanded = !currentEventsExpanded;
                });
              },
            ),
          ),
          if (currentEventsExpanded) // Display current events if expanded.
            Expanded(
              child: ListView.builder(
                itemCount: postViewModel.userAssignedPosts.length,
                itemBuilder: (context, index) {
                  final post = postViewModel.userAssignedPosts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ShowPostPage(post: post),
                        ),
                      );
                    },
                    child: EventCard(
                      title: post.title,
                      location: post.location,
                      date: post.deadline,
                    ),
                  );
                },
              ),
            ),
          ListTile(
            title: Text(
              'Completed Events',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}
