import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String location;
  final DateTime date;

  EventCard({
    required this.title,
    required this.location,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

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
                      'images/gardening.webp',
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
                    SizedBox(height: 6),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                    Text(
                      formattedDate, // Use the manually formatted date
                      style: TextStyle(
                        fontSize: 25,
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
