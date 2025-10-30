import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  const String apiBase = 'https://api.ibn-nabil.com/tasks';
  
  print('Testing TaskCloud API at: $apiBase\n');
  
  // Test 1: Health check
  print('1. Testing health endpoint...');
  try {
    final healthResponse = await http.get(Uri.parse('$apiBase/health/'));
    print('   Status: ${healthResponse.statusCode}');
    print('   Response: ${healthResponse.body}');
    print('   ✅ Health check passed\n');
  } catch (e) {
    print('   ❌ Health check failed: $e\n');
    exit(1);
  }
  
  // Test 2: Get all tasks
  print('2. Testing GET /api/tasks/...');
  try {
    final tasksResponse = await http.get(Uri.parse('$apiBase/api/tasks/'));
    print('   Status: ${tasksResponse.statusCode}');
    print('   Response: ${tasksResponse.body}');
    
    if (tasksResponse.statusCode == 200) {
      final tasks = json.decode(tasksResponse.body) as List;
      print('   ✅ GET tasks passed (${tasks.length} tasks)\n');
    } else {
      print('   ❌ Unexpected status code\n');
    }
  } catch (e) {
    print('   ❌ GET tasks failed: $e\n');
  }
  
  // Test 3: Create a task
  print('3. Testing POST /api/tasks/...');
  try {
    final newTask = {
      'title': 'Test Task from Flutter',
      'description': 'Testing API integration',
      'is_completed': false,
    };
    
    final createResponse = await http.post(
      Uri.parse('$apiBase/api/tasks/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newTask),
    );
    
    print('   Status: ${createResponse.statusCode}');
    print('   Response: ${createResponse.body}');
    
    if (createResponse.statusCode == 201) {
      final created = json.decode(createResponse.body);
      final taskId = created['id'];
      print('   ✅ POST task passed (ID: $taskId)\n');
      
      // Test 4: Update the task
      print('4. Testing PUT /api/tasks/$taskId/...');
      try {
        final updateData = {
          ...created,
          'is_completed': true,
        };
        
        final updateResponse = await http.put(
          Uri.parse('$apiBase/api/tasks/$taskId/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updateData),
        );
        
        print('   Status: ${updateResponse.statusCode}');
        print('   Response: ${updateResponse.body}');
        
        if (updateResponse.statusCode == 200) {
          print('   ✅ PUT task passed\n');
        }
      } catch (e) {
        print('   ❌ PUT task failed: $e\n');
      }
      
      // Test 5: Delete the task
      print('5. Testing DELETE /api/tasks/$taskId/...');
      try {
        final deleteResponse = await http.delete(
          Uri.parse('$apiBase/api/tasks/$taskId/'),
        );
        
        print('   Status: ${deleteResponse.statusCode}');
        
        if (deleteResponse.statusCode == 204) {
          print('   ✅ DELETE task passed\n');
        } else {
          print('   ❌ Unexpected status code\n');
        }
      } catch (e) {
        print('   ❌ DELETE task failed: $e\n');
      }
    } else {
      print('   ❌ Unexpected status code\n');
    }
  } catch (e) {
    print('   ❌ POST task failed: $e\n');
  }
  
  print('\n✅ All API tests completed!');
}
