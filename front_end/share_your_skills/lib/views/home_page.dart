import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/viewmodels/post_viewmodel.dart';
import 'package:share_your_skills/viewmodels/skill_viewmodel.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:share_your_skills/views/home_show_page.dart';
import 'package:share_your_skills/views/login_page.dart';
import 'package:share_your_skills/views/show_post_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/event_card.dart';
import '../components/filter_skills.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void fetchPosts() {
    setState(() {
      final postViewModel =
          Provider.of<UserViewModel>(context, listen: false).postViewModel;
      postViewModel.fetchAllPosts();
    });
  }

  void logoutUser() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skillViewModel = Provider.of<SkillViewModel>(context, listen: false);
    final postViewModel =
        Provider.of<UserViewModel>(context, listen: true).postViewModel;
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              setState(() {
                postViewModel.fetchAllPosts();
              });
            },
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SEARCH COMPONENT
                  // TextField(
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     fillColor: Color(0xFFE9EEF5),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     hintText: "eg: Skiing",
                  //     prefixIcon: Icon(Icons.search_rounded),
                  //     // prefixIconColor:
                  //   ),
                  // ),
                  FilterComponent(
                      skillViewModel: skillViewModel),
                  Expanded(
                    child: Consumer<UserViewModel>(
                      builder: (context, userViewModel, child) {
                        final postViewModel = userViewModel.postViewModel;
                        return ListView.builder(
                          itemCount: postViewModel.displayPosts.length,
                          itemBuilder: (context, index) {
                            final post = postViewModel.displayPosts[index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => HomeShowPostPage(
                                        post: post,
                                        isEditable: false,
                                      ),
                                    ),
                                  );
                                },
                                child: EventCard(
                                  title: post.title,
                                  location: post.location,
                                  date: post.deadline,
                                ));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}