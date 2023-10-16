class Skill {
  String id;
  String name;


  Skill({
    required this.id,
    required this.name,

  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['_id'],
      name: json['name'],
    );
  }
}
