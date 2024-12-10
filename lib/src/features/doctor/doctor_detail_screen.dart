import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myapp/src/features/checkout/book_appointment.dart';
import 'package:myapp/src/features/checkout/consultation_payment_screen.dart';
import 'package:myapp/src/features/doctor/user_appointment.dart';
import 'package:myapp/src/models/doctor.dart';
import 'package:intl/intl.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF87CF3A),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF87CF3A), Color(0xFF5EA625)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: doctor.imageUri.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: doctor.imageUri,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => _buildDoctorInitials(),
                        )
                            : _buildDoctorInitials(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check_circle,
                          color: doctor.isOnline ? Colors.white : Colors.white54,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeaderInfo(Icons.star, '${doctor.rating}'),
                        _buildHeaderDivider(),
                        _buildHeaderInfo(Icons.medical_services_outlined, doctor.specialty),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(doctor),
                  const SizedBox(height: 24),
                  _buildAboutSection(doctor),
                  const SizedBox(height: 24),
                  _buildScheduleSection(doctor),
                  const SizedBox(height: 24),
                  _buildReviewsSection(doctor),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: doctor.isOnline ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConsultationPaymentScreen(
                        doctor: doctor,
                      ),
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87CF3A),
                  disabledBackgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  doctor.isOnline ? 'Chat Consultation' : 'Doctor Offline',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookAppointmentScreen(doctor: doctor)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87CF3A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 4,
      width: 4,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDoctorInitials() {
    return Container(
      width: 96,
      height: 96,
      color: Colors.white,
      child: Center(
        child: Text(
          doctor.name.substring(0, 2).toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF87CF3A),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(Doctor doctor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoCard('Experience', doctor.experience),
        _buildInfoCard('Reviews', '${doctor.totalReviews}+'),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Doctor doctor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Doctor',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          doctor.about,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.medical_services, color: Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Specialty: ${doctor.specialty}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.attach_money, color: Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Consultation Fee: Rp ${NumberFormat('#,###').format(doctor.price)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleSection(Doctor doctor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schedule',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.access_time, color: Color(0xFF87CF3A)),
                  SizedBox(width: 12),
                  Text(
                    'Mon - Fri',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: doctor.availableTimes.map((time) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF87CF3A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFF87CF3A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(Doctor doctor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Patient Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${doctor.totalReviews} Reviews',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...doctor.reviews.map((review) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildReviewCard(
            review['name'] ?? 'Anonymous',
            (review['rating'] ?? 0.0).toDouble(),
            review['comment'] ?? '',
            review['date'] ?? 'Recently',
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildReviewCard(
      String name,
      double rating,
      String comment,
      String time,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(rating.toString()),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}