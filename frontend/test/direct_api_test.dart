import 'package:http/http.dart' as http;

void main() async {
  print('Testing direct API connection...');
  
  try {
    print('1. Testing health endpoint...');
    final healthResponse = await http.get(
      Uri.parse('https://api.ibn-nabil.com/tasks/health/'),
    ).timeout(Duration(seconds: 30));
    print('Health status: ${healthResponse.statusCode}');
    print('Health body: ${healthResponse.body}');
    print('Health headers: ${healthResponse.headers}');
    
    print('\n2. Testing tasks endpoint...');
    final tasksResponse = await http.get(
      Uri.parse('https://api.ibn-nabil.com/tasks/api/tasks/'),
    ).timeout(Duration(seconds: 30));
    print('Tasks status: ${tasksResponse.statusCode}');
    print('Tasks body: ${tasksResponse.body}');
    print('Tasks headers: ${tasksResponse.headers}');
    
    print('\n✅ Connection successful!');
  } catch (e, stackTrace) {
    print('❌ Connection failed!');
    print('Error: $e');
    print('Stack trace: $stackTrace');
  }
}
