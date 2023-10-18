class Address {
  final String? city;
  final String? street;
  final String? houseNumber;

  Address({this.city, this.street, this.houseNumber});

  @override
  String toString() {
    // Customize the string representation of the address here
    String addressString = '';

    if (city != null) {
      addressString += 'City: $city, ';
    }

    if (street != null) {
      addressString += 'Street: $street, ';
    }

    if (houseNumber != null) {
      addressString += 'House Number: $houseNumber';
    }

    return addressString.trim(); // Remove trailing comma and whitespace
  }
}

class User {
  final String? userId;
  final String email;
  final String name;
  final String token;
  final List<String>? skillIds;
  final Address? address;

  User({
    required this.email,
    this.userId,
    required this.name,
    this.token = '',
    this.skillIds,
    this.address,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> userJson = json['user'];
    final String userId = userJson['_id'];
    final String email = userJson['login'];
    final String name = userJson['name'];

    final Map<String, dynamic>? addressData = userJson['address'];
    final String? city = addressData?['city'];
    final String? street = addressData?['street'];
    final String? houseNumber = addressData?['houseNumber'];

    final String token = json['token'];

    return User(
      userId: userId,
      email: email,
      name: name,
      token: token, // Assign the token to the User object
      skillIds: (userJson['skillIds'] as List<dynamic>?)
          ?.map((id) => id.toString())
          .toList(),
      address: Address(
        city: city,
        street: street,
        houseNumber: houseNumber,
      ),
    );
  }
}
