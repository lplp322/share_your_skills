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
}
