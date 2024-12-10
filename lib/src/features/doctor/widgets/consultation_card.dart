import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/consultation.dart';

class ConsultationCard extends StatelessWidget {
  final Consultation consultation;

  const ConsultationCard({Key? key, required this.consultation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            consultation.doctorName.substring(0, 2),
            style: TextStyle(color: Colors.blue.shade800),
          ),
        ),
        title: Text(
          consultation.doctorName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(consultation.specialty),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM d, yyyy - h:mm a').format(DateTime.parse(consultation.dateTime)),
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        trailing: _buildStatusContainer(),
      ),
    );
  }

  Widget _buildStatusContainer() {
    Color backgroundColor;
    Color textColor;

    switch (consultation.status) {
      case 'Completed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'Cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case 'Ongoing':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        consultation.status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

