import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhysicalInformationData {
  String gender = 'Male';
  double height = 150.0;
  double weight = 70.0;
  DateTime dateOfBirth = DateTime(2000, 1, 1);

  void loadFromMap(Map<String, dynamic> data) {
    gender = data['gender'] ?? 'Male';
    height = (data['height'] ?? 150.0).toDouble();
    weight = (data['weight'] ?? 70.0).toDouble();
    dateOfBirth = (data['dateOfBirth'] as Timestamp?)?.toDate() ?? DateTime(2000, 1, 1);
  }

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'height': height,
      'weight': weight,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
    };
  }
}

class PhysicalInformationWidget extends StatefulWidget {
  final PhysicalInformationData data;
  final bool isEditing;

  const PhysicalInformationWidget({
    Key? key,
    required this.data,
    required this.isEditing,
  }) : super(key: key);

  @override
  _PhysicalInformationWidgetState createState() => _PhysicalInformationWidgetState();
}

class _PhysicalInformationWidgetState extends State<PhysicalInformationWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Physical Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildGenderSelection(),
        const SizedBox(height: 24),
        _buildHeightSlider(),
        const SizedBox(height: 16),
        _buildWeightSlider(),
        const SizedBox(height: 24),
        _buildDateOfBirth(),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: widget.isEditing
                ? () => setState(() => widget.data.gender = 'Male')
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget.data.gender == 'Male'
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.male,
                    color: widget.data.gender == 'Male'
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Male',
                    style: TextStyle(
                      color: widget.data.gender == 'Male'
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: widget.isEditing
                ? () => setState(() => widget.data.gender = 'Female')
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget.data.gender == 'Female'
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.female,
                    color: widget.data.gender == 'Female'
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Female',
                    style: TextStyle(
                      color: widget.data.gender == 'Female'
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeightSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Height'),
            Text(
              '${widget.data.height.toStringAsFixed(1)} cm',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Slider(
          value: widget.data.height,
          min: 100,
          max: 220,
          activeColor: Theme.of(context).primaryColor,
          onChanged: widget.isEditing
              ? (value) => setState(() => widget.data.height = value)
              : null,
        ),
      ],
    );
  }

  Widget _buildWeightSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Weight'),
            Text(
              '${widget.data.weight.toStringAsFixed(1)} kg',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Slider(
          value: widget.data.weight,
          min: 30,
          max: 150,
          activeColor: Theme.of(context).primaryColor,
          onChanged: widget.isEditing
              ? (value) => setState(() => widget.data.weight = value)
              : null,
        ),
      ],
    );
  }

  Widget _buildDateOfBirth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date of Birth'),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: widget.isEditing
              ? () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: widget.data.dateOfBirth,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() => widget.data.dateOfBirth = picked);
            }
          }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              color: widget.isEditing ? null : Colors.grey[100],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMMM dd, yyyy').format(widget.data.dateOfBirth),
                  style: TextStyle(
                    color: widget.isEditing ? Colors.black : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

