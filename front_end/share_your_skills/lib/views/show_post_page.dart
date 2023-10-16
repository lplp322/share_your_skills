import 'package:flutter/material.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:share_your_skills/views/create_event_details_page.dart';
import 'package:share_your_skills/models/post.dart';
class ShowPostPage extends StatelessWidget {
  final Post post;

  ShowPostPage({required this.post});

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

  void deletePost(BuildContext context) {
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
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the ShowPostPage
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<UserViewModel>(context).postViewModel;
    final isEditable = post.status != "completed"; // Check if the post is editable

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
                  Text(
                    '${post.title}',
                    style: TextStyle(fontSize: 30),
                  ),
                  Spacer(),
                  if (isEditable) // Only show the "Edit" button if the post is editable
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to the CreateEventPage for editing
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateEventPage(
                              postId: post.id!,
                            ),
                          ),
                        );
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
                    image: AssetImage(getImageAssetPath(post.title)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Status: ${post.status}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16.0),
              Text(
                'Date: ${post.deadline}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16.0),
              Text(
                'User ID: ${post.userId}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16.0),
              Text(
                'Description: ${post.content}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle cancel button action
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 148, 71, 47)),
                    ),
                    child: Container(
                      width: 150,
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  if (isEditable) // Only show the "Delete" button if the post is editable
                    ElevatedButton(
                      onPressed: () {
                        deletePost(context); // Prompt the user for post deletion
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red), // Use red color for delete button
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
}
