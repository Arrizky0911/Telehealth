import 'package:flutter/material.dart';
import 'package:myapp/src/features/main/doctor/doctor_detail_screen.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final List<Map<String, String>> doctors = [
    {
      'name': 'Dr. Hannibal Lectore',
      'rating': '4.0',
      'specialty': 'Neurologist',
      'time': '9:00 AM - 10:00 AM'
    },
    {
      'name': 'Dr. Johann Liebert',
      'rating': '4.1',
      'specialty': 'Pediatrician',
      'time': '10:00 AM - 11:00 AM'
    },
    {
      'name': 'Dr. Emily Rodriguez',
      'rating': '4.0',
      'specialty': 'Pediatrician',
      'time': '11:00 AM - 12:00 PM'
    },
    {
      'name': 'Dr. James Wilson',
      'rating': '4.1',
      'specialty': 'Neurologist',
      'time': '12:00 PM - 1:00 PM'
    },
    {
      'name': 'Dr. Lisa Kim',
      'rating': '4.0',
      'specialty': 'Pediatrician',
      'time': '1:00 PM - 2:00 PM'
    },
    {
      'name': 'Dr. David Patel',
      'rating': '4.1',
      'specialty': 'Orthopedics',
      'time': '2:00 PM - 3:00 PM'
    },
    {
      'name': 'Dr. Maria Garcia',
      'rating': '4.0',
      'specialty': 'Cardiologist',
      'time': '3:00 PM - 4:00 PM'
    },
    {
      'name': 'Dr. Robert Lee',
      'rating': '4.1',
      'specialty': 'Orthopedics',
      'time': '4:00 PM - 5:00 PM'
    },
    {
      'name': 'Dr. Amanda Taylor',
      'rating': '4.0',
      'specialty': 'Cardiologist',
      'time': '5:00 PM - 6:00 PM'
    },
    {
      'name': 'Dr. Thomas Brown',
      'rating': '4.1',
      'specialty': 'Orthopedics',
      'time': '6:00 PM - 7:00 PM'
    },
  ];

  List<Map<String, String>> filteredDoctors = [];
  final TextEditingController _searchController = TextEditingController();
  String selectedSpecialty = 'All';

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        final name = doctor['name']!.toLowerCase();
        final specialty = doctor['specialty']!.toLowerCase();
        final matchesSearch = name.contains(query) || specialty.contains(query);
        final matchesFilter = selectedSpecialty == 'All' || 
                            doctor['specialty'] == selectedSpecialty;
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Wrap everything with SafeArea
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, 
                      children: [
                        Flexible(
                            child:
                                _buildSearchBar()), // Add Flexible for dynamic sizing
                        const SizedBox(height: 8),
                        Flexible(
                            child:
                                _buildFilterChips()), // Add Flexible for filter chips
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8, // Sesuaikan rasio sesuai kebutuhan
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final doctor = filteredDoctors[index];
                    return _buildDoctorCard(
                      doctor['name']!,
                      doctor['rating']!,
                      doctor['specialty']!,
                      doctor['time']!,
                    );
                  },
                  childCount: filteredDoctors.length,
                ),
              ),
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

  Widget _buildDoctorCard(
      String name, String rating, String specialty, String time) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailScreen(
              name: name,
              rating: rating,
              specialty: specialty,
              time: time,
            ),
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
                name.substring(0, 2),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
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
                Text(rating, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              specialty,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
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
