import 'package:myapp/src/models/doctor.dart';

class Appointment {
  final Doctor doctor;
  final String type;
  final String time;

  Appointment({
    required this.doctor,
    required this.type,
    required this.time,
  });
}