class User {
  final String userId;
  final String name;

  final String token; // Add a token property

  User({
    required this.userId,
    required this.name,
   
    this.token ='', // Initialize the token property in the constructor
  });
}
