import 'package:flutter/material.dart';
import 'package:share_your_skills/models/app_state.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'app_bar.dart' as MyAppbar;

class CreateEventPage extends StatefulWidget {
  
  const CreateEventPage({Key? key,}) : super(key: key);

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
  bool isCreatingEvent = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
    locationController = TextEditingController();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  List<String> predefinedSkills = [
    "Cleaning",
    "Cooking",
    "Gardening",
  ];

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
    final user = Provider.of<UserViewModel>(context).user;

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
                Column(
                  children: predefinedSkills.map((skill) {
                    return Row(
                      children: [
                        Checkbox(
                          value: selectedSkill == skill,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null && value) {
                                selectedSkill = skill;
                              } else {
                                selectedSkill = null;
                              }
                            });
                          },
                        ),
                        Text(skill),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 32),
                isCreatingEvent
                    ? CircularProgressIndicator() // Show loading indicator when creating the event
                    : ElevatedButton(
                        onPressed: () async {
                          if (selectedSkill == null) {
                            // Handle the case where no skill is selected
                            return;
                          }
                          setState(() {
                            isCreatingEvent = true;
                          });
                          final skillId =
                              await postViewModel.fetchSkillIdByName(
                                  selectedSkill!); // Get the skill ID

                          final newEvent = Post(
                            title: titleController.text,
                            content: contentController.text,
                            location: locationController.text,
                            deadline: DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            ).toUtc(),
                            userId: user?.userId, // Set the user ID as needed
                            skillIds: [skillId], // Use the selected skill
                            assignedUserId:
                                null, // Set assigned user ID as needed
                          );
                          print(newEvent);
                          postViewModel.addPost(newEvent);
                          Provider.of<AppState>(context, listen: false)
                              .setSelectedIndex(1);
                          setState(() {});
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MyAppbar.AppBar(
                                token: user?.token,
                              ),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFF588F2C),
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
