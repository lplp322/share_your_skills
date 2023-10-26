import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_your_skills/models/post.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
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
  final List<String> skills = [];

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
        skills.add(key);
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
            padding: EdgeInsets.all(16.0),
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
                  decoration: InputDecoration(labelText: 'Enter title *'),
                ),
                SizedBox(height: 16),
                Text('Description', style: TextStyle(fontSize: 20)),
                TextFormField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: 'Enter description *'),
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                Text('Location', style: TextStyle(fontSize: 20)),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Enter location *'),
                ),
                SizedBox(height: 16),
                Text('Date', style: TextStyle(fontSize: 20)),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().subtract(Duration(days: 7)),
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
                EasyButton(
                  type: EasyButtonType.elevated,
                  idleStateWidget: Text(
                    widget.postId != null ? 'Save Changes' : 'Create',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (selectedSkill == null) {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Please choose desired skill'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    if (titleController.text.isEmpty || contentController.text.isEmpty || locationController.text.isEmpty){
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all fields'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    if (widget.postId != null) {
                      // Update an existing post
                      final skillId =
                          skills[predefinedSkills.indexOf(selectedSkill!)];

                      Post updatedPost = Post(
                        id: widget.postId, // Include the post ID for updating
                        title: titleController.text,
                        content: contentController.text,
                        status: existingPost?.status,
                        location: locationController.text,
                        deadline: DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        ),
                        userId: existingPost?.userId,
                        skillIds: [skillId],
                      );
                      //update post
                      await postViewModel.updatePost(updatedPost);
                      postViewModel.fetchAllPosts();

                      // Show a SnackBar to notify the user
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(
                              'Post updated successfully'), // Change the message as needed
                          duration: Duration(seconds: 2), // Adjust the duration
                        ),
                      );
                      Navigator.of(context).pop();
                    } else {
                      // Create a new post
                      final skillId =
                          skills[predefinedSkills.indexOf(selectedSkill!)];
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
                          selectedTime.minute,
                        ),
                        skillIds: [skillId],
                        userId: postViewModel.user?.userId,
                        assignedUserId: null,
                      );

                      await postViewModel.addPost(newPost);
                      postViewModel.fetchAllPosts();
                      // Show a SnackBar to notify the user
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Post created, please reload the page twice'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  loadingStateWidget: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                  width: double
                      .infinity, // Use double.infinity to make it full-width
                  height: 40.0,
                  borderRadius: 4.0,
                  elevation: 0.0,
                  contentGap: 6.0,
                  buttonColor: Color(0xFF588F2C),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
