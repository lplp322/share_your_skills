import 'user.dart';
class Post {
  String id;
  String title;
  String content;
  DateTime deadline;
  String status;
  String? userId;
  List<String> skillIds;
  String? assignedUserId;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.deadline,
    required this.status,
    required this.userId,
    required this.skillIds,
    this.assignedUserId,
  });
  // fromjson to list of events
 factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      deadline: DateTime.parse(json['deadline']),
      status: json['status'],
      userId: json['userId'],
      skillIds: List<String>.from(json['skillIds']),
      assignedUserId: json['assignedUserId'],
    );
  }
  
}
