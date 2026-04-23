import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TaskProvider>().fetchTasks());
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    if (hour < 20) return 'Good Evening!';
    return 'Good Night!';
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 8))],
                    ),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Hello, ',
                                style: const TextStyle(color: Colors.black87, fontSize: 14),
                                children: [
                                  const TextSpan(text: 'Teman ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: _getGreeting(), style: const TextStyle(color: Color(0xFFE8544A), fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Text('Time: ', style: TextStyle(fontSize: 13)),
                                StatefulBuilder(
                                  builder: (context, setStateTimer) {
                                    Future.delayed(const Duration(seconds: 1), () {
                                      if (mounted) setStateTimer(() {});
                                    });
                                    final n = DateTime.now();
                                    final t = '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}:${n.second.toString().padLeft(2, '0')}';
                                    return Text(t, style: const TextStyle(color: Color(0xFFE8544A), fontWeight: FontWeight.bold, fontSize: 13));
                                  },
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.logout, color: Colors.grey, size: 20),
                                  onPressed: () => context.read<AuthProvider>().logout(),
                                  tooltip: 'Logout',
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Weekly Planner', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Text('🗓️', style: TextStyle(fontSize: 22)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Search Bar
                        TextField(
                          controller: _searchController,
                          onChanged: (value) => context.read<TaskProvider>().search(value),
                          decoration: InputDecoration(
                            hintText: 'Cari task...',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      context.read<TaskProvider>().search('');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Add Task Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TaskFormScreen()),
                            ).then((_) => context.read<TaskProvider>().fetchTasks()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE8544A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah Task', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 3 State UI
                        Expanded(
                          child: taskProvider.state == TaskState.loading
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(color: Color(0xFFE8544A)),
                                      SizedBox(height: 16),
                                      Text('Memuat tasks...', style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                )
                              : taskProvider.state == TaskState.error
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                          const SizedBox(height: 12),
                                          Text(taskProvider.error ?? 'Terjadi kesalahan',
                                              style: const TextStyle(color: Colors.red)),
                                          const SizedBox(height: 12),
                                          ElevatedButton.icon(
                                            onPressed: () => context.read<TaskProvider>().fetchTasks(),
                                            icon: const Icon(Icons.refresh),
                                            label: const Text('Coba Lagi'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFFE8544A),
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : taskProvider.tasks.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Belum ada task. Tambahin yang pertama yuk 👇',
                                            style: TextStyle(color: Colors.grey.shade500),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : RefreshIndicator(
                                          color: const Color(0xFFE8544A),
                                          onRefresh: () => context.read<TaskProvider>().fetchTasks(),
                                          child: ListView.builder(
                                            itemCount: taskProvider.tasks.length,
                                            itemBuilder: (context, index) {
                                              final task = taskProvider.tasks[index];
                                              return TaskCard(
                                                task: task,
                                                onToggle: () async {
                                                  await context.read<TaskProvider>().editTask(
                                                    task.id,
                                                    {
                                                      'title': task.title,
                                                      'day': task.day,
                                                      'time': task.time != null && task.time!.length >= 5
                                                          ? task.time!.substring(0, 5)
                                                          : task.time,
                                                      'category_id': task.categoryId,
                                                      'is_done': !task.isDone,
                                                    },
                                                  );
                                                },
                                                onEdit: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
                                                ).then((_) => context.read<TaskProvider>().fetchTasks()),
                                                onDelete: () async {
                                                  final confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                      title: const Text('Hapus Task'),
                                                      content: const Text('Yakin mau hapus task ini?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context, false),
                                                          child: const Text('Batal'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context, true),
                                                          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm == true && context.mounted) {
                                                    await context.read<TaskProvider>().removeTask(task.id);
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: const Text('Task berhasil dihapus!'),
                                                          backgroundColor: Colors.green.shade400,
                                                          behavior: SnackBarBehavior.floating,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}