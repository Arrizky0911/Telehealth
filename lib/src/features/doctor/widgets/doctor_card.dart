import 'package:flutter/material.dart';
import 'package:myapp/src/models/doctor.dart';
import 'package:myapp/src/features/doctor/doctor_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final bool isCheckout;

  const DoctorCard({super.key, required this.doctor, required this.isCheckout});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:  isCheckout ? () {} :
          () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailScreen(doctor: doctor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildDoctorImage(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoctorNameAndStatus(),
                  const SizedBox(height: 4),
                  _buildDoctorInfo(),
                  const SizedBox(height: 4),
                  _buildDoctorRating(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: doctor.imageUri.isNotEmpty
          ? CachedNetworkImage(
        imageUrl: doctor.imageUri,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => _buildDoctorInitials(),
      )
          : _buildDoctorInitials(),
    );
  }

  Widget _buildDoctorInitials() {
    return Container(
      width: 80,
      height: 80,
      color: const Color(0xFF7986CB),
      child: Center(
        child: Text(
          doctor.name.substring(0, 2).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorNameAndStatus() {
    return Row(
      children: [
        Expanded(
          child: Text(
            doctor.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Icon(
          Icons.check_circle,
          color: doctor.isOnline ? const Color(0xFF87CF3A) : Colors.grey,
          size: 16,
        ),
      ],
    );
  }

  Widget _buildDoctorInfo() {
    return Row(
      children: [
        Icon(Icons.medical_services_outlined, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          doctor.specialty,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDoctorRating() {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < doctor.rating.floor() ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 16,
          );
        }),
        const SizedBox(width: 4),
        Text(
          doctor.rating.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

