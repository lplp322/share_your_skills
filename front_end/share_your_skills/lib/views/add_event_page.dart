import 'package:flutter/material.dart';
import 'package:share_your_skills/components/event_card.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/viewmodels/post_viewmodel.dart';
import 'package:share_your_skills/views/show_post_page.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:share_your_skills/views/create_event_details_page.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/views/create_event_details_page.dart';

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
    final postViewModel =
        Provider.of<UserViewModel>(context, listen: false).postViewModel;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
        },
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateEventDetailPage(),
                      ),
                    );
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

              if (ongoingPostsExpanded)
                Expanded(
                  child: Consumer<UserViewModel>(
                    builder: (context, userViewModel, child) {
                      final postViewModel = userViewModel.postViewModel;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: postViewModel.userPosts.length,
                        itemBuilder: (context, index) {
                          final post = postViewModel.userPosts[index];
                          return FutureBuilder<String>(
                            future: userViewModel.fetchUserName(
                                userViewModel.user!, post.userId!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Loading indicator
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final String username = snapshot.data ??
                                    ''; // Provide a default value ('') if snapshot.data is null
                                return GestureDetector(
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ShowPostPage(
                                          post: post,
                                          username: username,
                                          isEditable: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: EventCard(
                                    title: post.title,
                                    location: post.location,
                                    date: post.deadline,
                                    // Now you can use the 'username' variable here
                                  ),
                                );
                              }
                            },
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
                        itemCount: postViewModel.userPastPosts.length,
                        itemBuilder: (context, index) {
                          final post = postViewModel.userPastPosts[index];
                          return FutureBuilder<String>(
                            future: userViewModel.fetchUserName(
                                userViewModel.user!, post.userId!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final String username = snapshot.data ?? '';
                                return GestureDetector(
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ShowPostPage(
                                          post: post,
                                          username: username,
                                          isEditable: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: EventCard(
                                    title: post.title,
                                    location: post.location,
                                    date: post.deadline,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
