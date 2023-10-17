import 'user.dart';
class Post {
  String id;
  String title;
  String content;
  DateTime deadline;
  String status;
  String location;
  String? userId;
  List<String> skillIds;
  String? assignedUserId;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.deadline,
    required this.status,
    required this.location,
    required this.userId,
    required this.skillIds,
    this.assignedUserId,
  });
  // fromjson to list of events
 factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? 'No Id',
      title: json['title'] ?? 'No Title',
      content: json['content'] ?? 'No Content',
      deadline: DateTime.parse(json['deadline']),
      status: json['status'] ?? 'No Status',
      location: json['location'] ?? 'No Location',
      userId: json['userId'] ?? 'No User',
      skillIds: List<String>.from(json['skillIds']),
      assignedUserId: json['assignedUserId'] ?? 'No User Assigned',
    );
  }
  
}
