import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:share_your_skills/models/skill.dart';
import 'package:share_your_skills/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class CreateEventDetailPage extends StatefulWidget {
  final String? postId;

  CreateEventDetailPage({Key? key, this.postId}) : super(key: key);

  @override
  _CreateEventDetailPageState createState() => _CreateEventDetailPageState();
}

class _CreateEventDetailPageState extends State<CreateEventDetailPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController locationController;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? selectedSkill;
  Post? existingPost;
  String? skillId;
  final List<String> predefinedSkills = [];

  String selectedDateText = '';
  String selectedTimeText = '';

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
    locationController = TextEditingController();
    _fetchSkills();
    if (widget.postId != null) {
      fetchExistingPost(widget.postId!);
    }
  }

  Future<void> _fetchSkills() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final fetchedskills = await userViewModel.fetchSkills();

    setState(() {
      fetchedskills.forEach((key, value) {
        predefinedSkills.add(value);
      });
      ;
    });
  }

  void fetchExistingPost(String postId) {
    final postViewModel =
        Provider.of<UserViewModel>(context, listen: false).postViewModel;
    final post =
        postViewModel.userPosts.firstWhere((post) => post.id == postId);

    titleController.text = post.title;
    contentController.text = post.content;
    locationController.text = post.location;
    selectedDate = post.deadline;
    selectedTime = TimeOfDay.fromDateTime(selectedDate);
    selectedSkill = post.skillIds.isNotEmpty ? post.skillIds[0] : null;

    existingPost = post;
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
                      widget.postId != null ? 'Edit Event' : 'Create Event',
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
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                        selectedDateText = DateFormat('MMM dd, yyyy')
                            .format(date); // Format the date
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF588F2C)),
                  ),
                  child: Text("Select Date"),
                ),
                Text('Selected Date: $selectedDateText'),

                SizedBox(height: 16),
                Text('Time', style: TextStyle(fontSize: 20)),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );

                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                        selectedTimeText =
                            time.format(context); // Format the time
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF588F2C)),
                  ),
                  child: Text("Select Time"),
                ),
                Text(
                    'Selected Time: $selectedTimeText'), // Display selected time

                SizedBox(height: 16),
                Text('Skill', style: TextStyle(fontSize: 20)),
                Row(
                  children: predefinedSkills.map((skill) {
                    return Row(
                      children: <Widget>[
                        Radio(
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
                      return;
                    }

                    if (widget.postId != null) {
                      // Update an existing post
                      Post updatedPost = Post(
                        id: widget.postId, // Include the post ID for updating
                        title: titleController.text,
                        content: contentController.text,
                        location: locationController.text,
                        deadline: DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute),
                        userId: existingPost?.userId,
                        skillIds: [selectedSkill!],
                        assignedUserId: existingPost?.assignedUserId,
                      );
                      //update post
                      await postViewModel.updatePost(updatedPost);
                    } else {
                    
                      final String skillId = await postViewModel
                          .fetchSkillIdByName(selectedSkill!);
                      Post newPost = Post(
                          id: null,
                          title: titleController.text,
                          content: contentController.text,
                          location: locationController.text,
                          deadline: DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute),
                          skillIds: [skillId],
                          userId: postViewModel.user?.userId!,
                          assignedUserId: null);

                    
                      await postViewModel.addPost(newPost);
                    }

                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF588F2C)),
                  ),
                  child:
                      Text(widget.postId != null ? 'Save Changes' : 'Create'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
