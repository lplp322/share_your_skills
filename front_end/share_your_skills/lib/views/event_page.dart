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
  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16.0),
            child: Text(
              'Current Events',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ),
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
                    location: post.status,
                    date: post.deadline,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
