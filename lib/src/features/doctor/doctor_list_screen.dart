import 'package:flutter/material.dart';
import 'package:myapp/src/features/doctor/doctor_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/src/models/doctor.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Doctor> filteredDoctors = [];
  final TextEditingController _searchController = TextEditingController();
  String selectedSpecialty = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // Filter akan dihandle oleh StreamBuilder
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Available Doctors'),
              centerTitle: true,
              pinned: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
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
                        Flexible(child: _buildSearchBar()),
                        const SizedBox(height: 8),
                        Flexible(child: _buildFilterChips()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder<List<Doctor>>(
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
                  
                  final matchesSearch = name.contains(query) || 
                                      specialty.contains(query);
                  final matchesFilter = selectedSpecialty == 'All' || 
                                      doctor.specialty == selectedSpecialty;
                  
                  return matchesSearch && matchesFilter;
                }).toList();

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final doctor = filtered[index];
                        return _buildDoctorCard(doctor);
                      },
                      childCount: filtered.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search doctors...',
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
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
            _onSearchChanged(); // Trigger filter
          });
        },
        selectedColor: const Color(0xFF5C6BC0),
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

  Widget _buildDoctorCard(Doctor doctor) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailScreen(doctor: doctor),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: const Color(0xFF7986CB),
              child: Text(
                doctor.name.substring(0, 2),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              doctor.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(doctor.rating.toString(), style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              doctor.specialty,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              doctor.availableTimes.isNotEmpty 
                  ? doctor.availableTimes.first 
                  : 'No available time',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
