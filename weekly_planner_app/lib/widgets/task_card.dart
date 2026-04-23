import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle; // ← tambah ini

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle, // ← tambah ini
  });

  final List<Map<String, dynamic>> _categories = const [
    {'id': 1, 'name': 'Kuliah'},
    {'id': 2, 'name': 'Kerja'},
    {'id': 3, 'name': 'Olahraga'},
    {'id': 4, 'name': 'Ibadah'},
    {'id': 5, 'name': 'Hiburan'},
  ];

  String _getCategoryName(int? id) {
    if (id == null) return '';
    final cat = _categories.firstWhere((c) => c['id'] == id, orElse: () => {'name': ''});
    return cat['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Toggle is_done
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isDone ? Colors.green : Colors.white,
                border: Border.all(
                  color: task.isDone ? Colors.green : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: task.isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                    color: task.isDone ? Colors.grey : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (task.day != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECEB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          task.day!,
                          style: const TextStyle(fontSize: 11, color: Color(0xFFE8544A), fontWeight: FontWeight.w500),
                        ),
                      ),
                    if (task.day != null && task.time != null) const SizedBox(width: 6),
                    if (task.time != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF0FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          task.time!.length >= 5 ? task.time!.substring(0, 5) : task.time!,
                          style: const TextStyle(fontSize: 11, color: Colors.indigo, fontWeight: FontWeight.w500),
                        ),
                      ),
                    if (task.categoryId != null) const SizedBox(width: 6),
                    if (task.categoryId != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getCategoryName(task.categoryId),
                          style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w500),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFE8544A), size: 20),
            onPressed: onDelete,
            tooltip: 'Hapus',
          ),
        ],
      ),
    );
  }
}