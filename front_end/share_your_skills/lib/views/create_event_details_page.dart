import 'package:flutter/material.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

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
  String? selectedSkill;
  List<String> predefinedSkills = [
    "Cleaning",
    "Cooking",
    "Gardening",
  ];

  // Map skill names to their corresponding IDs
  final Map<String, String> skillIdToName = {
    "65256b8601db3b3814171c5f": "Cleaning",
    "65256b7a01db3b3814171c5d": "Gardening",
    "65256b7101db3b3814171c5b": "Cooking",
  };

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
    final postViewModel = Provider.of<UserViewModel>(context).postViewModel;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                      'Create Event',
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
                Text('Description', style: TextStyle(fontSize: 20)),
                TextFormField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: 'Enter description'),
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
                SizedBox(height: 16),
                Text('Select a skill:', style: TextStyle(fontSize: 20)),
                Row(
                  children: predefinedSkills.map((skill) {
                    return Row(
                      children: [
                        Radio<String>(
                          value: skill,
                          groupValue: selectedSkill,
                          onChanged: (String? value) {
                            setState(() {
                              selectedSkill = value;
                            });
                          },
                        ),
                        Text(skill),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedSkill == null) {
                      // Handle the case where no skill is selected
                      return;
                    }

                    // Use the selectedSkill directly as the skill name
                    final deadline = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    // Use the skill ID directly from the map
                    final skillId = skillIdToName[selectedSkill!];

                    final newEvent = Post(
                      id: '', // Assign an empty ID or generate one on the server
                      title: titleController.text,
                      content: contentController.text,
                      location: locationController.text,
                      deadline: deadline.toUtc(), // Format the deadline
                      status: 'pending', // Set status as needed
                      userId: '', // Set the user ID as needed
                      skillIds: [skillId!], // Use the selected skill
                      assignedUserId: null, // Set assigned user ID as needed
                    );
                    postViewModel.addPost(newEvent);
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
      ),
    );
  }
}
