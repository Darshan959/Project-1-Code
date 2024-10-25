// Darshan Nair and Raahul Nair
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final TextEditingController _hydrationController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();
  List<Map<String, dynamic>> _logs = [];

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<Database> _initializeDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'progress.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE logs(id INTEGER PRIMARY KEY AUTOINCREMENT, hydration INTEGER, sleep INTEGER, date TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _fetchLogs() async {
    final db = await _initializeDatabase();
    final List<Map<String, dynamic>> logs = await db.query('logs');
    setState(() {
      _logs = logs;
    });
  }

  Future<void> _submitLog() async {
    final db = await _initializeDatabase();
    final hydration = int.tryParse(_hydrationController.text) ?? 0;
    final sleep = int.tryParse(_sleepController.text) ?? 0;

    await db.insert(
      'logs',
      {
        'hydration': hydration,
        'sleep': sleep,
        'date': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _hydrationController.clear();
    _sleepController.clear();
    _fetchLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Tracking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Log Hydration and Sleep', style: TextStyle(fontSize: 20)),
            TextField(
              controller: _hydrationController,
              decoration: InputDecoration(labelText: 'Hydration (in oz)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _sleepController,
              decoration: InputDecoration(labelText: 'Sleep (in hours)'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _submitLog,
              child: Text('Log'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  return ListTile(
                    title: Text(
                      'Date: ${log['date'].split('T')[0]}, Hydration: ${log['hydration']} oz, Sleep: ${log['sleep']} hours',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
