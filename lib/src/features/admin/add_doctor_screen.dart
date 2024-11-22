import 'package:flutter/material.dart';
import 'package:myapp/src/services/doctor_service.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _experienceController = TextEditingController();
  final _priceController = TextEditingController();
  final _aboutController = TextEditingController();
  final List<String> _selectedTimes = [];
  bool _isLoading = false;

  final _doctorService = DoctorService();

  Future<void> _addDoctor() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi availableTimes
    if (_selectedTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal 1 jadwal tersedia')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final password = await _doctorService.addDoctor(
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        specialty: _specialtyController.text.trim(),
        experience: _experienceController.text.trim(),
        price: int.parse(_priceController.text.trim()),
        about: _aboutController.text.trim(),
        availableTimes: _selectedTimes,
      );

      if (!mounted) return;

      // Show success dialog with generated password
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dokter Berhasil Ditambahkan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${_emailController.text}'),
              const SizedBox(height: 8),
              Text('Password: $password'),
              const SizedBox(height: 16),
              const Text(
                'Simpan password ini! Password akan digunakan dokter untuk login pertama kali.',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Clear form
                _emailController.clear();
                _nameController.clear();
                _specialtyController.clear();
                _experienceController.clear();
                _priceController.clear();
                _aboutController.clear();
                setState(() => _selectedTimes.clear());
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Dokter'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _specialtyController,
              decoration: const InputDecoration(labelText: 'Spesialisasi'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Spesialisasi tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _experienceController,
              decoration: const InputDecoration(labelText: 'Pengalaman'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pengalaman tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Harga Konsultasi'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harga tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Harga harus berupa angka';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _aboutController,
              decoration: const InputDecoration(labelText: 'About Doctor'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'About tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Available Times'),
            Wrap(
              spacing: 8,
              children: [
                '08:00', '09:00', '10:00', '11:00', '13:00', 
                '14:00', '15:00', '16:00'
              ].map((time) => FilterChip(
                label: Text(time),
                selected: _selectedTimes.contains(time),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTimes.add(time);
                    } else {
                      _selectedTimes.remove(time);
                    }
                  });
                },
              )).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _addDoctor,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Tambah Dokter'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _specialtyController.dispose();
    _experienceController.dispose();
    _priceController.dispose();
    _aboutController.dispose();
    super.dispose();
  }
}