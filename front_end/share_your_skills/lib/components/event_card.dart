import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String location;
  final DateTime date;
  EventCard({
    required this.title,
    required this.location,
    required this.date,

  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  String getImageAssetPath() {
    switch (widget.title) {
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

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${widget.date.year}-${widget.date.month.toString().padLeft(2, '0')}-${widget.date.day.toString().padLeft(2, '0')}";

    return Column(
      children: [
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  height: 150,
                  width: 350,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      getImageAssetPath(), // Use the image asset path based on the title
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 35),
                    Text(
                      widget.location,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                    SizedBox(height: 35),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
