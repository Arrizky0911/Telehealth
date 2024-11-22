class User {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  
  User({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.role = 'patient', // default role
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      role: map['role'] ?? 'patient',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
    };
  }
}