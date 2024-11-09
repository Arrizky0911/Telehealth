import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/features/profile/widgets/menu_item.dart';
import 'package:myapp/src/features/welcome/enter_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = 'First Name';
  String lastName = 'Last Name';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen or initial screen after sign out
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EnterScreen()));
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5C6BC0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                MenuItem(
                  icon: Icons.person_outline,
                  title: 'Personal Information',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                MenuItem(
                  icon: Icons.medical_services_outlined,
                  title: 'Medical History',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                MenuItem(
                  icon: Icons.translate_outlined,
                  title: 'Languages',
                  onTap: () {},
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF786083),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

