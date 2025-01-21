class Review{
  int id;
  String firstName;
  String? lastName;
  int offerId;
  String description;
  double rating;

  Review({this.id = 0, required this.firstName, this.lastName, required this.offerId, required this.description, required this.rating});

  factory Review.fromJson(Map<String, dynamic> json) {

    Review res = Review(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
      offerId: json['offerId'] as int,
      description: json['description'] as String,
      rating: json['rating']+.0,
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'offerId': offerId,
      'description': description,
      'rating': rating,

    };
  }

}