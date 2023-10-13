import 'package:flutter/material.dart';
import 'package:share_your_skills/models/post.dart';

class ShowPostPage extends StatelessWidget {
  final Post post;

  const ShowPostPage({Key? key, required this.post}) : super(key: key);

  String getImageAssetPath(String title) {
    switch (title) {
      case "Cooking":
        return 'images/cooking.jpg';
      case "Garderning":
        return 'images/gardening.webp';
      case "Cleaning":
        return 'images/cleaning.jpeg';
      default:
        return 'images/cleaning.jpeg';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    image: AssetImage(getImageAssetPath(
                        post.title)), // Match image based on the title
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle cancel button action
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 148, 71, 47)),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
