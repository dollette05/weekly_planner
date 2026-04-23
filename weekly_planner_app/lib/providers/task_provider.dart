import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

enum TaskState { loading, error, loaded }

class TaskProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Task> _tasks = [];
  List<Task> _filtered = [];
  TaskState _state = TaskState.loading;
  String? _error;
  String _searchQuery = '';

  List<Task> get tasks => _filtered;
  TaskState get state => _state;
  String? get error => _error;

  Future<void> fetchTasks() async {
    _state = TaskState.loading;
    notifyListeners();

    try {
      final data = await _api.getTasks();
      _tasks = data.map((e) => Task.fromJson(e)).toList();
      _applyFilter();
      _state = TaskState.loaded;
    } catch (e) {
      _error = 'Gagal memuat tasks. Cek koneksi.';
      _state = TaskState.error;
    }

    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filtered = List.from(_tasks);
    } else {
      _filtered = _tasks
          .where((t) =>
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  Future<void> addTask(Map<String, dynamic> body) async {
    await _api.createTask(body);
    await fetchTasks();
  }

  Future<void> editTask(int id, Map<String, dynamic> body) async {
    await _api.updateTask(id, body);
    await fetchTasks();
  }

  Future<void> removeTask(int id) async {
    await _api.deleteTask(id);
    await fetchTasks();
  }
}