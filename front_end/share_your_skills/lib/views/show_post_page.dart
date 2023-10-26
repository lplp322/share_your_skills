import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/views/create_event_details_page.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ShowPostPage extends StatefulWidget {
  final Post post;
  final bool isEditable;
  final String? username;

  ShowPostPage({required this.post, this.isEditable = false, this.username});

  @override
  _ShowPostPageState createState() => _ShowPostPageState();
}

class _ShowPostPageState extends State<ShowPostPage> {
  void deletePost(BuildContext context) async {
    final postViewModel =
        Provider.of<UserViewModel>(context, listen: false).postViewModel;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Delete Post"),
          content: Text("Are you sure you want to delete this post?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                await postViewModel.deletePost(widget.post.id!);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Post deleted, please reload the page'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.of(dialogContext).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the ShowPostPage
              },
            ),
          ],
        );
      },
    );
  }

  void editPost() {
    // Navigate to the CreateEventPage for editing
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateEventDetailPage(
          postId: widget.post.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(widget.post.deadline);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Flexible(
                    child: Center(
                      child: Text(
                        '${widget.post.title}',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  Spacer(),
                  if (widget.isEditable)
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editPost();
                      },
                    ),
                ],
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    image: AssetImage(getImageAssetPath(widget.post.title)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Status: ${widget.post.status}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16.0),
              Text(
                'Date: $formattedDate',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16.0),
              Text(
                'Publisher name: ${widget.username}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16.0),
              Text(
                'Description: ${widget.post.content}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.isEditable)
                    EasyButton(
                      type: EasyButtonType.elevated,
                      idleStateWidget: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        deletePost(context);
                      },
                      loadingStateWidget: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                      width: 395,
                      height: 40.0,
                      borderRadius: 4.0,
                      elevation: 0.0,
                      contentGap: 6.0,
                      buttonColor: Colors.red,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getImageAssetPath(String title) {
    switch (title) {
      case "Cooking":
        return 'images/cooking.jpg';
      case "Gardening":
        return 'images/gardening.webp';
      case "Cleaning":
        return 'images/cleaning.jpeg';
      default:
        return 'images/cleaning.jpeg';
    }
  }
}
