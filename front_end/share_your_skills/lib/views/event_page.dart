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
                  child: Consumer<UserViewModel>(
                    builder: (context, userViewModel, child) {
                      final postViewModel = userViewModel.postViewModel;
                      print(postViewModel.userAssignedPosts.length);
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: postViewModel.userAssignedPosts.length,
                        itemBuilder: (context, index) {
                          final post = postViewModel.userAssignedPosts[index];
                          /*
                          final skillName = postViewModel
                              .fetchSkillIdByName(post.skillIds[0]);*/
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShowPostPage(post: post),
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
                  child: Consumer<UserViewModel>(
                    builder: (context, userViewModel, child) {
                      final postViewModel = userViewModel.postViewModel;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: postViewModel.userCompletedPosts.length,
                        itemBuilder: (context, index) {
                          final post = postViewModel.userCompletedPosts[index];
                          print(post);
                          return FutureBuilder(
                            future: userViewModel.fetchUserName(userViewModel.user!, post.assignedUserId!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Display a loading indicator while fetching data.
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                post.userId = snapshot.data;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ShowPostPage(
                                          post: post,
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
