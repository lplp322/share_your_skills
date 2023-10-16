import 'package:flutter/material.dart';
import 'package:share_your_skills/components/event_card.dart';
import 'package:share_your_skills/viewmodels/post_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/views/show_post_page.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';

class AddEventPage extends StatefulWidget {

  const AddEventPage({Key? key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  bool ongoingPostsExpanded = true; // Track the state of ongoing posts.
  bool pastPostsExpanded = true; // Track the state of past posts.

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Create a New Post',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Navigate to the Create Post Page
                },
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                'Ongoing Posts',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: Icon(ongoingPostsExpanded
                    ? Icons.expand_less
                    : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    ongoingPostsExpanded = !ongoingPostsExpanded;
                  });
                },
              ),
            ),
            // Placeholder for Ongoing Posts list (using userAssignedPosts for now)
            if (ongoingPostsExpanded)
              Expanded(
                child: Consumer<UserViewModel>(
                  builder: (context, userViewModel, child) {
                    final postViewModel = userViewModel.postViewModel;
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
                'Past Posts',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              trailing: IconButton(
                icon: Icon(pastPostsExpanded
                    ? Icons.expand_less
                    : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    pastPostsExpanded = !pastPostsExpanded;
                  });
                },
              ),
            ),
            // Placeholder for Past Posts list (using userAssignedPosts for now)
            if (pastPostsExpanded)
              Expanded(
                child: Consumer<UserViewModel>(
                  builder: (context, userViewModel, child) {
                    final postViewModel = userViewModel.postViewModel;
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
