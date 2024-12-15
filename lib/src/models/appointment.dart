import 'package:myapp/src/models/order.dart';

class Appointment { // Changed class name to Appointment
  final String id;
  final String userId;
  final String doctorId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final Address address;
  final int age;
  final String gender;
  final String bloodType;
  final String allergies;
  final String medications;
  final String complaint;
  final String comments;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String paymentMethod;
  final int consultationFee;
  final String status;
  final DateTime createdAt;

  Appointment({ // Changed constructor name to Appointment
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.age,
    required this.gender,
    required this.bloodType,
    required this.allergies,
    required this.medications,
    required this.complaint,
    required this.comments,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.paymentMethod,
    required this.consultationFee,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address.toMap(),
      'age': age,
      'gender': gender,
      'bloodType': bloodType,
      'allergies': allergies,
      'medications': medications,
      'complaint': complaint,
      'comments': comments,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'paymentMethod': paymentMethod,
      'consultationFee': consultationFee,
      'status': status,
      'createdAt': createdAt,
    };
  }
}