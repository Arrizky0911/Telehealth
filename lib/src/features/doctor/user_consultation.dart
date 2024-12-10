import 'package:flutter/material.dart';
import 'package:myapp/src/models/consultation.dart';
import 'package:myapp/src/features/doctor/widgets/consultation_card.dart';

class UserConsultation extends StatefulWidget {
  const UserConsultation({super.key});

  @override
  State<UserConsultation> createState() => _UserConsultationState();
}

class _UserConsultationState extends State<UserConsultation> {
  final List<Consultation> consultations = [
    Consultation(
      uid: '1',
      doctorName: 'Dr. Spike Brown',
      specialty: 'Cardiologist',
      dateTime: '2023-05-10 10:30',
      status: 'Completed',
    ),
    Consultation(
      uid: '2',
      doctorName: 'Dr. Jane Smith',
      specialty: 'Dermatologist',
      dateTime: '2023-05-09 14:00',
      status: 'Cancelled',
    ),
    Consultation(
      uid: '3',
      doctorName: 'Dr. John Doe',
      specialty: 'Pediatrician',
      dateTime: '2023-05-08 09:15',
      status: 'Completed',
    ),
    Consultation(
      uid: '4',
      doctorName: 'Dr. Emily Johnson',
      specialty: 'Neurologist',
      dateTime: '2023-05-11 15:45',
      status: 'Ongoing',
    ),
  ];

  int selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              children: _groupConsultations(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 30,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF87CF3A)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'My Consultations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _groupConsultations() {
    final now = DateTime.now();
    final groups = {
      'Today': consultations.where((c) => _isToday(c.dateTime)).toList(),
      'Yesterday': consultations.where((c) => _isYesterday(c.dateTime)).toList(),
      'This Week': consultations.where((c) => _isThisWeek(c.dateTime)).toList(),
      'This Month': consultations.where((c) => _isThisMonth(c.dateTime)).toList(),
      'Earlier': consultations.where((c) => _isEarlier(c.dateTime)).toList(),
    };

    return groups.entries
        .where((entry) => entry.value.isNotEmpty)
        .expand((entry) => [
      _buildGroupHeader(entry.key),
      ...entry.value.map((consultation) => ConsultationCard(consultation: consultation)),
    ])
        .toList();
  }

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  bool _isToday(String dateTime) {
    final date = DateTime.parse(dateTime);
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(String dateTime) {
    final date = DateTime.parse(dateTime);
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  bool _isThisWeek(String dateTime) {
    final date = DateTime.parse(dateTime);
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return date.isAfter(startOfWeek) && date.isBefore(now) && !_isToday(dateTime) && !_isYesterday(dateTime);
  }

  bool _isThisMonth(String dateTime) {
    final date = DateTime.parse(dateTime);
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && !_isThisWeek(dateTime) && !_isToday(dateTime) && !_isYesterday(dateTime);
  }

  bool _isEarlier(String dateTime) {
    final date = DateTime.parse(dateTime);
    final startOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    return date.isBefore(startOfMonth);
  }

}