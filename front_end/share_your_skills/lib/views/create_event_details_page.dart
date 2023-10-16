import 'package:flutter/material.dart';
import 'package:share_your_skills/models/post.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController locationController;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
    locationController = TextEditingController();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    'Create Event', // Title for the page
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Title', style: TextStyle(fontSize: 20)),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Enter title'),
              ),
              SizedBox(height: 16),
              Text('Content', style: TextStyle(fontSize: 20)),
              TextFormField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Enter content'),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              Text('Location', style: TextStyle(fontSize: 20)),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Enter location'),
              ),
              SizedBox(height: 16),
              Text('Date', style: TextStyle(fontSize: 20)),
              InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  });
                },
                child: InputDecorator(
                  decoration: InputDecoration(labelText: 'Select date'),
                  child: Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Time', style: TextStyle(fontSize: 20)),
              InkWell(
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  ).then((time) {
                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                      });
                    }
                  });
                },
                child: InputDecorator(
                  decoration: InputDecoration(labelText: 'Select time'),
                  child: Text(
                    selectedTime.format(context),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Handle the "Create" button click
                  // Retrieve user input and create a formatted deadline
                  final deadline = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  final newEvent = Post(
                    id: '', // Assign an empty ID or generate one on the server
                    title: titleController.text,
                    content: contentController.text,
                    location: locationController.text,
                    deadline: deadline.toUtc(), // Format the deadline
                    status: 'pending', // Set status as needed
                    userId: '', // Set the user ID as needed
                    skillIds: [], // Add skill IDs if required
                    assignedUserId: null, // Set assigned user ID as needed
                  );

                  // Send an API request to create the new event
                  // Handle success or error responses
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFF588F2C), // Set the color to #588F2C
                  ),
                ),
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
