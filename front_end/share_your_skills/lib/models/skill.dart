class Skill {
  final String skillId;
  final String name;
  final List<String>? users;
  final String? icon;

  Skill({
    required this.skillId,
    required this.name,
    this.users,
    this.icon,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      skillId: json['_id'],
      name: json['name'],
      users: List<String>.from(json['users']),
      icon: json['icon'],
    );
  }
}