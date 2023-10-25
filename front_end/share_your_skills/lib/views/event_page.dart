import 'package:flutter/material.dart';
import 'package:share_your_skills/components/event_card.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/views/show_post_page.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool currentEventsExpanded = true;
  bool completedEventsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final postViewModel =
        Provider.of<UserViewModel>(context, listen: false).postViewModel;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            postViewModel.fetchAllPosts();
          });
        },
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  'Current Posts',
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
                  child: Consumer<UserViewModel>(
                    builder: (context, userViewModel, child) {
                      final postViewModel = userViewModel.postViewModel;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: postViewModel.userAssignedPosts.length,
                        itemBuilder: (context, index) {
                          final post = postViewModel.userAssignedPosts[index];
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
                                          isEditable: false,
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
                  'Completed Posts',
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
                  child: Consumer<UserViewModel>(
                    builder: (context, userViewModel, child) {
                      final postViewModel = userViewModel.postViewModel;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: postViewModel.userCompletedPosts.length,
                        itemBuilder: (context, index) {
                          final post = postViewModel.userCompletedPosts[index];
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
            ],
          ),
        ),
      ),
    );
  }
}
