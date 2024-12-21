
class BillingDetails {
   int id;
   String fullName;
   String address;
   String city;
   String postalCode;
   String phoneNumber;
   String email;
   String userId;

  BillingDetails({
    required this.id,
    required this.fullName,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.phoneNumber,
    required this.email,
    required this.userId,
  });

  // Factory constructor for creating a BillingDetails object from JSON
  factory BillingDetails.fromJson(Map<String, dynamic> json) {
    return BillingDetails(
      id: json['id'],
      fullName: json['fullName'],
      address: json['address'],
      city: json['city'],
      postalCode: json['postalCode'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      userId: json['userId'],
    );
  }

  // Method to convert a BillingDetails object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
      'email': email,
      'userId': userId,
    };
  }
}
