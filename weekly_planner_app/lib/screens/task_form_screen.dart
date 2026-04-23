import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedDay;
  int? _selectedCategoryId;
  bool _isDone = false;
  bool _isLoading = false;

  final List<String> _days = [
    'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  final List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'Kuliah'},
    {'id': 2, 'name': 'Kerja'},
    {'id': 3, 'name': 'Olahraga'},
    {'id': 4, 'name': 'Ibadah'},
    {'id': 5, 'name': 'Hiburan'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _timeController.text = widget.task!.time ?? '';
      _selectedDay = widget.task!.day;
      _selectedCategoryId = widget.task!.categoryId;
      _isDone = widget.task!.isDone;
    }
  }

Future<void> _pickTime() async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFFE8544A)),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      // Kirim format H:i (tanpa detik) sesuai validasi Laravel
      _timeController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf8c8d4), Color(0xFFd4c8f8), Color(0xFFc8e0f8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar custom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      isEdit ? 'Edit Task' : 'Tambah Task',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, 8))],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Text('Judul Task', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan judul task',
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Day & Time row
                          Row(
                            children: [
                              // Day dropdown
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Hari', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      value: _selectedDay,
                                      hint: const Text('Pilih hari', style: TextStyle(fontSize: 13)),
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xFFF5F5F5),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      ),
                                      items: _days.map((day) => DropdownMenuItem(
                                        value: day,
                                        child: Text(day, style: const TextStyle(fontSize: 13)),
                                      )).toList(),
                                      onChanged: (value) => setState(() => _selectedDay = value),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Time picker
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Jam', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: _pickTime,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.access_time, size: 18, color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Text(
                                              _timeController.text.isEmpty ? '--:--' : _timeController.text.substring(0, 5),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: _timeController.text.isEmpty ? Colors.grey : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Category dropdown
                          const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value: _selectedCategoryId,
                            hint: const Text('Pilih kategori'),
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: _categories.map((cat) => DropdownMenuItem<int>(
                              value: cat['id'],
                              child: Text(cat['name']),
                            )).toList(),
                            onChanged: (value) => setState(() => _selectedCategoryId = value),
                          ),
                          const SizedBox(height: 16),

                          // Is Done toggle
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SwitchListTile(
                              title: const Text('Sudah selesai?'),
                              value: _isDone,
                              activeColor: const Color(0xFFE8544A),
                              onChanged: (value) => setState(() => _isDone = value),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : () async {
                                if (_titleController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Judul tidak boleh kosong!')),
                                  );
                                  return;
                                }
                                if (_selectedDay == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Pilih hari dulu!')),
                                  );
                                  return;
                                }
                                if (_timeController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Pilih jam dulu!')),
                                  );
                                  return;
                                }
                                if (_selectedCategoryId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Pilih kategori dulu!')),
                                  );
                                  return;
                                }
                                setState(() => _isLoading = true);
                                final body = {
                                  'title': _titleController.text.trim(),
                                  'day': _selectedDay,
                                  'time': _timeController.text,
                                  'category_id': _selectedCategoryId,
                                  'is_done': _isDone,
                                };
                                if (isEdit) {
                                  await context.read<TaskProvider>().editTask(widget.task!.id, body);
                                } else {
                                  await context.read<TaskProvider>().addTask(body);
                                }
                                setState(() => _isLoading = false);
                                if (context.mounted) Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8544A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      isEdit ? 'Simpan Perubahan' : 'Tambah Task',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}