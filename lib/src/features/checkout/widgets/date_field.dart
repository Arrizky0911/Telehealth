import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatelessWidget {
  final String label;
  final DateTime value;
  final Function(DateTime) onChanged;

  const DateField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              onChanged(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMMM dd, yyyy').format(value),
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

