import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TimeAndDateStep extends StatelessWidget {
  final DateTime selectedDate;
  final String? selectedTime;
  final List<String> availableTimes;
  final Function(DateTime) onDateSelected;
  final Function(String) onTimeSelected;

  const TimeAndDateStep({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.availableTimes,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendar(),
          const SizedBox(height: 24),
          const Text(
            'Select Time Slot',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimeSlots(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: selectedDate,
        selectedDayPredicate: (day) => isSameDay(selectedDate, day),
        onDaySelected: (selectedDay, _,) {
          onDateSelected(selectedDay);
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF87CF3A),
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: const Color(0xFF87CF3A).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: availableTimes.map((time) {
        final isSelected = selectedTime == time;
        return InkWell(
          onTap: () => onTimeSelected(time),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF87CF3A) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? const Color(0xFF87CF3A) : Colors.grey[300]!,
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

