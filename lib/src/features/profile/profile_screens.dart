import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/features/history/history_screen.dart';
import 'package:myapp/src/features/profile/widgets/menu_item.dart';
import 'package:myapp/src/features/welcome/enter_screen.dart';
import 'package:myapp/src/features/profile/personal_information_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = 'First Name';
  String lastName = 'Last Name';
  String email = '';
  String phone = '';
  String? profileImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          setState(() {
            firstName = userData.data()?['firstName'] ?? 'First Name';
            lastName = userData.data()?['lastName'] ?? 'Last Name';
            email = user.email ?? '';
            phone = userData.data()?['phone'] ?? '';
            profileImageUrl = userData.data()?['profileImageUrl'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9BA3EB),
              Color(0xFF8E97E9),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: profileImageUrl != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    )
                        : const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const PersonalInformationScreen(),
                          ),
                        ).then((_) => _loadUserData());
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInfoRow(Icons.person_outline, '$firstName $lastName'),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.email_outlined, email),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.phone_outlined,
                phone.isEmpty ? 'Add phone number' : phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white.withOpacity(0.7),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EnterScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildPersonalInfoCard(),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    'General',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                MenuItem(
                  icon: Icons.person_outline,
                  title: 'Personal Information',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalInformationScreen(),
                      ),
                    ).then((_) => _loadUserData());
                  },
                ),
                MenuItem(
                  icon: Icons.medical_services_outlined,
                  title: 'Medical History',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    );
                  },
                ),
                MenuItem(
                  icon: Icons.translate_outlined,
                  title: 'Languages',
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: false,  // Replace with actual dark mode state
                    onChanged: (bool value) {
                      // Implement dark mode toggle
                    },
                  ),
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.devices_outlined,
                  title: 'Linked Devices',
                  subtitle: 'iPhone 16 Pro',
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'Chatbot Preference',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Beta',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.notifications_none,
                  title: 'Smart Notifications',
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    'Security & Privacy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.security_outlined,
                  title: 'Security Settings',
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    'Danger Zone',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                MenuItem(
                  icon: Icons.close_rounded,
                  title: 'Close Account',
                  isDanger: true,
                  onTap: () {
                    // Implement close account functionality
                  },
                ),
                const SizedBox(height: 24),
                MenuItem(
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  onTap: _signOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}