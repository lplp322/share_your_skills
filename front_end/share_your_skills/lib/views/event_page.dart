import 'package:flutter/material.dart';
import 'package:share_your_skills/components/event_card.dart';
import 'package:share_your_skills/viewmodels/post_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/views/show_post_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool currentEventsExpanded = true; // Track the state of current events.
  bool completedEventsExpanded = true; // Track the state of completed events.

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Column(
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
            if (currentEventsExpanded)
              Expanded(
                child: Consumer<PostViewModel>(
                  builder: (context, postViewModel, child) {
                    return ListView.builder(
                      shrinkWrap: true,
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
                    );
                  },
                ),
              ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                'Completed Events',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: Icon(completedEventsExpanded
                    ? Icons.expand_less
                    : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    completedEventsExpanded = !completedEventsExpanded;
                  });
                },
              ),
            ),
            if (completedEventsExpanded)
              Expanded(
                child: Consumer<PostViewModel>(
                  builder: (context, postViewModel, child) {
                    return ListView.builder(
                      shrinkWrap: true,
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
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
