import 'package:flutter/material.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // Wrap everything with SafeArea
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
                      mainAxisSize: MainAxisSize.min, // Ensures content doesn't exceed height
                      children: [
                        Flexible(child: _buildSearchBar()), // Add Flexible for dynamic sizing
                        const SizedBox(height: 8),
                        Flexible(child: _buildFilterChips()), // Add Flexible for filter chips
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Dummy doctor
                    final doctors = [
                      {
                        'name': 'Dr. Hannibal Lector',
                        'rating': '4.0',
                        'specialty': 'Orthopedics',
                        'time': '9:00 AM - 10:00 AM'
                      },
                      {
                        'name': 'Dr. Johann Liebert',
                        'rating': '4.1',
                        'specialty': 'Cardiologist',
                        'time': '10:00 AM - 11:00 AM'
                      },
                      {
                        'name': 'Dr. Emily Rodriguez',
                        'rating': '4.0',
                        'specialty': 'Cardiologist',
                        'time': '11:00 AM - 12:00 PM'
                      },
                      {
                        'name': 'Dr. James Wilson',
                        'rating': '4.1',
                        'specialty': 'Orthopedics',
                        'time': '12:00 PM - 1:00 PM'
                      },
                      {
                        'name': 'Dr. Lisa Kim',
                        'rating': '4.0',
                        'specialty': 'Cardiologist',
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

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildDoctorCard(
                        doctors[index]['name']!,
                        doctors[index]['rating']!,
                        doctors[index]['specialty']!,
                        doctors[index]['time']!,
                      ),
                    );
                  },
                  childCount: 10,
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
      height: 45, // consistent height
      child: TextField(
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
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 32, 
      child: ListView( // Change SingleChildScrollView with ListView
        scrollDirection: Axis.horizontal,
        children: [
          _buildChip('All', true),
          _buildChip('Cardiologist', false),
          _buildChip('Orthopedics', false),
          _buildChip('Pediatrician', false),
          _buildChip('Neurologist', false),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
        onSelected: (bool value) {},
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

  Widget _buildDoctorCard(String name, String rating, String specialty, String time) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to doctor detail  page
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF7986CB),
              child: Text(
                name.substring(0, 2),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded( // Use Expanded to avoid overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.check_circle, color: Color(0xFF5C6BC0), size: 16),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(rating),
                      const SizedBox(width: 8),
                      Text(specialty, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
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
