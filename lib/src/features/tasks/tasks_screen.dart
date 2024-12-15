import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final Map<DateTime, List<Task>> _tasksByDate = {};

  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Fetch tasks when the screen loads
  }

  List<Task> _getTasksForSelectedDate() {
    final dateKey = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return _tasksByDate[dateKey] ?? [];
  }

  void _addNewTask(String title, String subtitle, [int? progress, int? total]) async {
    final userAuthUID = FirebaseAuth.instance.currentUser?.uid;
    if (userAuthUID == null) {
      print('User not authenticated');
      return;
    }

    final dateKey = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    try {
      // Save task data to Firestore and get the document reference
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userAuthUID)
          .collection('tasks')
          .add({
        'date': dateKey,
        'title': title,
        'subtitle': subtitle,
        'progress': progress ?? 0,
        'total': total,
        'completed': false,
      });

      // Get the document ID
      final documentId = docRef.id;

      // Create the Task object with the document ID
      final newTask = Task(
        id: documentId, // Store the document ID
        title: title,
        subtitle: subtitle,
        progress: progress ?? 0,
        total: total,
      );

      // Update UI
      setState(() {
        if (_tasksByDate.containsKey(dateKey)) {
          _tasksByDate[dateKey]!.add(newTask);
        } else {
          _tasksByDate[dateKey] = [newTask];
        }
      });
    } catch (e) {
      print('Error adding task: $e');
      // Handle the error, e.g., show a snackbar
    }
  }

  void _toggleTaskStatus(String taskId) async {
    final userAuthUID = FirebaseAuth.instance.currentUser?.uid;
    if (userAuthUID == null) {
      print('User not authenticated');
      return;
    }

    final dateKey = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final tasks = _tasksByDate[dateKey];

    if (tasks != null) {
      final taskIndex = tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        try {
          // Use the documentId to update the task
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userAuthUID)
              .collection('tasks')
              .doc(taskId) // Use taskId directly
              .update({'completed': !tasks[taskIndex].completed});

          // Update UI
          setState(() {
            tasks[taskIndex].completed = !tasks[taskIndex].completed;
          });
        } catch (e) {
          print('Error toggling task status: $e');
          // Handle the error
        }
      }
    }
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    final progressController = TextEditingController();
    final totalController = TextEditingController();
    bool useProgress = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'Enter task title',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Task Description',
                  hintText: 'Enter task description',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: useProgress,
                    onChanged: (value) {
                      setState(() {
                        useProgress = value ?? false;
                      });
                    },
                  ),
                  const Text('Add Progress Tracker'),
                ],
              ),
              if (useProgress) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: progressController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Current Progress',
                          hintText: '0',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: totalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Target',
                          hintText: '100',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _addNewTask(
                    titleController.text,
                    subtitleController.text,
                    useProgress ? int.tryParse(progressController.text) ?? 0 : null,
                    useProgress ? int.tryParse(totalController.text) ?? 100 : null,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTaskProgress(String taskId, int newProgress) async {
  final userAuthUID = FirebaseAuth.instance.currentUser?.uid;
  if (userAuthUID == null) {
    print('User not authenticated');
    return;
  }

  try {
    // Use the taskId (documentId) to update the task in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userAuthUID)
        .collection('tasks')
        .doc(taskId)
        .update({'progress': newProgress});

    // Update UI
    setState(() {
      final dateKey = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      final tasks = _tasksByDate[dateKey];
      if (tasks != null) {
        final taskIndex = tasks.indexWhere((task) => task.id == taskId);
        if (taskIndex != -1 && tasks[taskIndex].total != null) {
          tasks[taskIndex].progress = newProgress.clamp(0, tasks[taskIndex].total!);
        }
      }
    });
  } catch (e) {
    print('Error updating task progress: $e');
  }
}

  void _fetchTasks() async {
    final userAuthUID = FirebaseAuth.instance.currentUser?.uid;
    if (userAuthUID == null) {
      print('User not authenticated');
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userAuthUID)
          .collection('tasks')
          .where('date',
          isEqualTo: DateTime(_selectedDate.year, _selectedDate.month,
              _selectedDate.day))
          .get();

      setState(() {
        _tasksByDate[DateTime(_selectedDate.year, _selectedDate.month,
            _selectedDate.day)] = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return Task(
            id: doc.id, // Get the document ID
            title: data['title'],
            subtitle: data['subtitle'],
            progress: data['progress'],
            total: data['total'],
            completed: data['completed'],
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching tasks: $e');
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDate = _getTasksForSelectedDate();

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
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                          _fetchTasks(); // Fetch tasks for the new date
                        });
                      },
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
                    onPressed: () {
                      // Handle "Today" button press
                      // This might involve setting _selectedDate to today's date
                    },
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: const Text('Today'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF4D4F),
                      side: const BorderSide(color: Color(0xFFFF4D4F)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: tasksForSelectedDate.isEmpty
                  ? Center(
                child: Text(
                  'No tasks for this date',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: tasksForSelectedDate.length,
                itemBuilder: (context, index) {
                  final task = tasksForSelectedDate[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _TaskCard(
                      task: task,
                      onToggle: () => _toggleTaskStatus(task.id),
                      onProgressUpdate: (taskId, newProgress) =>
                          _updateTaskProgress(taskId, newProgress),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: const Color(0xFFFF4D4F),
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
          color: isSelected ? const Color(0xFFFF4D4F) : Colors.transparent,
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
  final VoidCallback onToggle;
  final Function(String, int) onProgressUpdate;

  const _TaskCard({
    required this.task,
    required this.onToggle,
    required this.onProgressUpdate,
  });

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
              value: task.completed,
              onChanged: (_) => onToggle(),
              shape: const CircleBorder(),
              activeColor: const Color(0xFFFF4D4F),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: task.completed ? TextDecoration.lineThrough : null,
                      color: task.completed ? Colors.grey : Colors.black,
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
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF4D4F)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${task.progress} / ${task.total}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () => onProgressUpdate(task.id, task.progress! - 1),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () => onProgressUpdate(task.id, task.progress! + 1),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String id; // Now stores the document ID
  final String title;
  final String subtitle;
  int? progress;
  final int? total;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    this.progress,
    this.total,
    this.completed = false,
  });
}