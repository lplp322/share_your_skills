class Post {
  String? id;
  String title;
  String content;
  DateTime deadline;
  String? status;
  String location;
  String? userId;
  List<String> skillIds;
  String? assignedUserId;

  Post({
     this.id,
    required this.title,
    required this.content,
    required this.deadline,
     this.status,
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
  // to json
   Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'deadline': deadline.toIso8601String(),
      'status': status,
      'location': location,
      'userId': userId,
      'skillIds': skillIds,
      'assignedUserId': assignedUserId,
    };
  }
   // to json
   Map<String, dynamic> toJsonUpdate() {
   // print('POST id: $id, title: $title, content: $content, deadline: $deadline, location: $location, userId: $userId, skillIds: $skillIds, assignedUserId: $assignedUserId');
    return {
      'postId': id,
      'title': title,
      'content': content,
      'deadline': deadline.toIso8601String(),
      'location': location,
      'userId': userId,
      'skillIds': skillIds,
      'assignedUserId': assignedUserId,
    };
  }
   @override
  String toString() {
    return 'Post {\n'
        '  id: $id,\n'
        '  title: $title,\n'
        '  content: $content,\n'
        '  location: $location,\n'
        '  deadline: $deadline,\n'
        '  userId: $userId,\n'
        '  skillIds: $skillIds,\n'
        '  assignedUserId: $assignedUserId,\n'
        '}';
  }
}
