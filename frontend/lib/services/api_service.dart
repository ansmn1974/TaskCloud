import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';
import '../config/api_config.dart';

/// Service for interacting with the TaskCloud REST API
class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch all tasks from the API
  Future<List<Task>> fetchTasks() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConfig.tasksUrl))
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  /// Create a new task on the API
  Future<Task> createTask(Task task) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConfig.tasksUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(task.toJson()),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 201) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  /// Update an existing task on the API
  Future<Task> updateTask(Task task) async {
    try {
      final response = await _client
          .put(
            Uri.parse(ApiConfig.taskDetailUrl(task.id)),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(task.toJson()),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  /// Delete a task from the API
  Future<void> deleteTask(String taskId) async {
    try {
      final response = await _client
          .delete(Uri.parse(ApiConfig.taskDetailUrl(taskId)))
          .timeout(ApiConfig.timeout);

      if (response.statusCode != 204) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  /// Check API health
  Future<bool> checkHealth() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConfig.healthUrl))
          .timeout(ApiConfig.timeout);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Dispose of resources
  void dispose() {
    _client.close();
  }
}
