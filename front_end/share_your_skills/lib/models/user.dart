class User {
  final String userId;
  final String name;
  final String email;
  final List<String>? skills;
  final String token; // Add a token property

  User({
    required this.userId,
    required this.name,
    required this.email,
    this.skills,
    this.token ='', // Initialize the token property in the constructor
  });
}
