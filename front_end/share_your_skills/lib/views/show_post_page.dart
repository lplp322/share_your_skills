import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/views/create_event_details_page.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ShowPostPage extends StatefulWidget {
  final Post post;
  final bool isEditable;

  ShowPostPage({required this.post, this.isEditable = false});

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                'Publisher ID: ${widget.post.userId}',
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
                    ElevatedButton(
                      onPressed: () {
                        deletePost(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red),
                      ),
                      child: Container(
                        width: 150,
                        child: Center(
                          child: Text(
                            'Delete',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
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
