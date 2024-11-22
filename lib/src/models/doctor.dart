class Doctor {
  final String uid;
  final String email;
  final String name;
  final String specialty;
  final String experience;
  final String about;
  final int price;
  final double rating;
  final List<String> availableTimes;
  final bool isOnline;
  final bool isActive;
  final int totalReviews;
  final List<Map<String, dynamic>> reviews;

  Doctor({
    required this.uid,
    required this.email,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.about,
    required this.price,
    this.rating = 0.0,
    required this.availableTimes,
    this.isOnline = false,
    this.isActive = true,
    this.totalReviews = 0,
    this.reviews = const [],
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      experience: map['experience'] ?? '',
      about: map['about'] ?? '',
      price: map['price'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      availableTimes: List<String>.from(map['availableTimes'] ?? []),
      isOnline: map['isOnline'] ?? false,
      isActive: map['isActive'] ?? false,
      totalReviews: map['totalReviews'] ?? 0,
      reviews: List<Map<String, dynamic>>.from(map['reviews'] ?? []),
    );
  }
}