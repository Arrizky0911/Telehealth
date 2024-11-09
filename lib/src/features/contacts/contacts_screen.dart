import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      Contact(
        name: "Dr. Oliver Aalami",
        title: "Director",
        description: "Dr. Aalami is the director of the CardinalKit project.",
        image: "assets/images/placeholder.png",
        location: "318 Campus Drive, Stanford, California, USA, 94305",
      ),
      Contact(
        name: "Dr. Vishnu Ravi",
        title: "Lead Architect",
        description: "Dr. Ravi is the lead architect and software engineer of the CardinalKit project.",
        image: "assets/images/placeholder.png",
        location: "318 Campus Drive, Stanford, California, USA, 94305",
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contacts',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contacts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return ImprovedContactCard(contact: contacts[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImprovedContactCard extends StatelessWidget {
  final Contact contact;

  const ImprovedContactCard({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(contact.image),
                  child: contact.image.isEmpty
                      ? Text(
                    contact.name.split(' ').map((n) => n[0]).join(''),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        contact.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              contact.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5C6BC0),
                      side: const BorderSide(color: Color(0xFF5C6BC0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message, size: 18),
                    label: const Text('SMS'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5C6BC0),
                      side: const BorderSide(color: Color(0xFF5C6BC0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.email, size: 18),
                    label: const Text('Email'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5C6BC0),
                      side: const BorderSide(color: Color(0xFF5C6BC0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    contact.location,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Contact {
  final String name;
  final String title;
  final String description;
  final String image;
  final String location;

  Contact({
    required this.name,
    required this.title,
    required this.description,
    required this.image,
    required this.location,
  });
}