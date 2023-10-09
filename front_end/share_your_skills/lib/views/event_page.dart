import 'package:flutter/material.dart';
class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 30,),
          Row(
            // create two rows one for an post image and one for post name and date and place
            children: [
              // post image
              Container(
                height: 100,
                width: 100,
                color: Colors.red,
                // get image from images folder
               child: Image.asset(
                 'images/gardening.webp',
                  fit: BoxFit.cover,
                ),
              ),
              // post name and date and place
              Column(
                children: [
                  Text('Post Name'),
                  Text('Post Date'),
                  Text('Post Place'),
                ],
              ),
            ],

          ),
        ],
      ),
    );
  }
}