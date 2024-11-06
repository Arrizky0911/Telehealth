import 'package:flutter/material.dart';
import 'package:myapp/src/features/contacts/contacts_screen.dart';
import 'package:myapp/src/features/profile/profile_screens.dart';
import 'package:myapp/src/features/tasks/tasks_screen.dart';
import 'package:myapp/src/features/main/home/home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        indicatorColor: Colors.white,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.check_box),
            icon: Icon(Icons.check_box_outlined),
            label: 'Tasks',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.contacts),
            icon: Icon(Icons.contacts_outlined),
            label: 'Contacts',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_2_rounded),
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        const HomeScreen(),
        const TasksScreen(),
        const ContactsScreen(),
        const ProfileScreen()
      ][currentPageIndex],
    );
  }
}
