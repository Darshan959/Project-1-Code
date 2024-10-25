// Darshan Nair and Raahul Nair
import 'package:flutter/material.dart';

class StressManagementScreen extends StatefulWidget {
  @override
  _StressManagementScreenState createState() => _StressManagementScreenState();
}

class _StressManagementScreenState extends State<StressManagementScreen> {
  final List<Map<String, String>> exercises = [
    {
      'title': 'Deep Breathing Exercise - 5 mins',
      'description':
          'Focus on your breath and let go of tension with deep breathing.',
    },
    {
      'title': 'Body Scan Meditation - 15 mins',
      'description':
          'Pay attention to different parts of your body to relax deeply.',
    },
    {
      'title': 'Visualization Practice - 10 mins',
      'description':
          'Imagine a peaceful scene to reduce stress and promote calmness.',
    },
  ];

  String _emotionalStateBefore = 'Neutral';
  String _emotionalStateAfter = 'Neutral';
  String _stressReductionGoal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stress Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Current Stress Reduction Goal: ${_stressReductionGoal.isEmpty ? "Set a goal" : _stressReductionGoal}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.blueGrey),
                onPressed: _setStressReductionGoal,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(exercises[index]['title']!,
                          style: Theme.of(context).textTheme.bodyLarge),
                      subtitle: Text(exercises[index]['description']!,
                          style: Theme.of(context).textTheme.bodyMedium),
                      trailing: ElevatedButton(
                        onPressed: () => _startExercise(exercises[index]),
                        child: Text('Start'),
                      ),
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

  void _setStressReductionGoal() {
    // Implement this function to open dialog and set stress goal.
  }

  void _startExercise(Map<String, String> exercise) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Starting ${exercise['title']}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              Text(
                'Description: ${exercise['description']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _executeExercise(exercise);
                },
                child: Text('Proceed'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _executeExercise(Map<String, String> exercise) {
    // Implement this function to handle what happens when the exercise starts.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You are now doing: ${exercise['title']}'),
      ),
    );
  }
}
