import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _ImprovedTasksScreenState();
}

class _ImprovedTasksScreenState extends State<TasksScreen> {
  DateTime _selectedDate = DateTime.now();
  final List<DateTime> _weekDates = List.generate(
    7,
        (index) => DateTime.now().add(Duration(days: index)),
  );

  final List<Task> _tasks = [
    Task(
      id: 1,
      title: "Daily Activity Goal",
      subtitle: "Take 10,000 steps daily.",
      progress: 3500,
      total: 10000,
    ),
    Task(
      id: 2,
      title: "Pain Questionnaire",
      subtitle: "Take this survey daily any time to assess your level of pain.",
    ),
    Task(
      id: 3,
      title: "Take Daily Medication",
      subtitle: "Take 1 tablet by mouth every day with breakfast",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tasks',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 100,
              color: const Color(0xFFE8EAF6),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _weekDates.length,
                itemBuilder: (context, index) {
                  final date = _weekDates[index];
                  final isSelected = DateUtils.isSameDay(date, _selectedDate);
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 16 : 4,
                      right: 4,
                    ),
                    child: _DateButton(
                      date: date,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedDate = date),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'To Do',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: const Text('Today'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5C6BC0),
                      side: const BorderSide(color: Color(0xFF5C6BC0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _TaskCard(task: _tasks[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new task logic here
        },
        backgroundColor: const Color(0xFF5C6BC0),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateButton({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7986CB) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('MMM').format(date).toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Text(
              DateFormat('EEE').format(date).toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: false,
              onChanged: (value) {
                // Handle checkbox state change
              },
              shape: const CircleBorder(),
              activeColor: const Color(0xFF5C6BC0),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  if (task.progress != null && task.total != null) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: task.progress! / task.total!,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5C6BC0)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${task.progress} / ${task.total}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF5C6BC0),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final int id;
  final String title;
  final String subtitle;
  final int? progress;
  final int? total;

  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    this.progress,
    this.total,
  });
}