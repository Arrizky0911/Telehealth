import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/src/models/doctor.dart';
import 'package:myapp/src/features/doctor/user_consultation.dart';
import 'package:myapp/src/features/doctor/user_appointment.dart';
import 'package:myapp/src/features/doctor/widgets/search_bar.dart';
import 'package:myapp/src/features/doctor/widgets/doctor_card.dart';

class DoctorListScreen extends StatefulWidget {
  final bool showAppBarArrow;

  const DoctorListScreen({super.key, this.showAppBarArrow = true});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedSpecialty = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 100,
                maxHeight: 100,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: SearchBarCustom(controller: _searchController, onChanged: _onSearchChanged)),
                        const SizedBox(height: 8),
                        Flexible(child: _buildFilterChips()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildDoctorList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          widget.showAppBarArrow? Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const Text('Consultation & Appointment')
            ],
          ) :
          const Text('Consultation & Appointment'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserConsultation()),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 20),
                label: const Text('My Consultation'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserAppointment()),
                  );
                },
                icon: const Icon(Icons.calendar_today, size: 20),
                label: const Text('My Appointment'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: true,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      toolbarHeight: 100,
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildChip('All', selectedSpecialty == 'All'),
          _buildChip('Cardiologist', selectedSpecialty == 'Cardiologist'),
          _buildChip('Orthopedics', selectedSpecialty == 'Orthopedics'),
          _buildChip('Pediatrician', selectedSpecialty == 'Pediatrician'),
          _buildChip('Neurologist', selectedSpecialty == 'Neurologist'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
        onSelected: (bool value) {
          setState(() {
            selectedSpecialty = label;
          });
        },
        selectedColor: const Color(0xFFFF4081),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildDoctorList() {
    return StreamBuilder<List<Doctor>>(
      stream: getDoctors(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final doctors = snapshot.data!;
        final filtered = doctors.where((doctor) {
          final name = doctor.name.toLowerCase();
          final specialty = doctor.specialty.toLowerCase();
          final query = _searchController.text.toLowerCase();

          final matchesSearch = name.contains(query) || specialty.contains(query);
          final matchesFilter = selectedSpecialty == 'All' || doctor.specialty == selectedSpecialty;

          return matchesSearch && matchesFilter;
        }).toList();

        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Doctors Near You (${filtered.length})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                final doctor = filtered[index - 1];
                return DoctorCard(doctor: doctor, isCheckout: false,);
              },
              childCount: filtered.length + 1,
            ),
          ),
        );
      },
    );
  }

  Stream<List<Doctor>> getDoctors() {
    return FirebaseFirestore.instance
        .collection('doctors')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Doctor.fromMap(doc.data()))
        .toList());
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

