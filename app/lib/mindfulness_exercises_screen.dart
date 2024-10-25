// Darshan Nair and Raahul Nair
import 'package:flutter/material.dart';

class MindfulnessExercisesScreen extends StatefulWidget {
  @override
  _MindfulnessExercisesScreenState createState() =>
      _MindfulnessExercisesScreenState();
}

class _MindfulnessExercisesScreenState
    extends State<MindfulnessExercisesScreen> {
  final List<Map<String, String>> exercises = [
    {
      'title': 'Guided Meditation - 10 mins',
      'description':
          'A session that guides you through meditation with calming instructions.',
    },
    {
      'title': 'Breathing Exercise - 5 mins',
      'description':
          'Focus on your breath to reduce stress and enhance awareness.',
    },
    {
      'title': 'Body Scan - 15 mins',
      'description':
          'A practice that involves paying attention to various parts of your body.',
    },
  ];

  String _emotionalStateBefore = 'Neutral';
  String _emotionalStateAfter = 'Neutral';
  String _mindfulnessGoal = '';

  void _startExercise(String exercise) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Emotional State Before'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('How do you feel before $exercise?'),
              DropdownButton<String>(
                value: _emotionalStateBefore,
                items: <String>['Happy', 'Neutral', 'Stressed', 'Anxious']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _emotionalStateBefore = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Start Exercise'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Started $exercise.'),
                  ),
                );

                Future.delayed(Duration(seconds: 5), () {
                  _askForEmotionalStateAfter(exercise);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _askForEmotionalStateAfter(String exercise) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Emotional State After'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('How do you feel after $exercise?'),
              DropdownButton<String>(
                value: _emotionalStateAfter,
                items: <String>['Happy', 'Neutral', 'Stressed', 'Anxious']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _emotionalStateAfter = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Emotional state recorded: Before - $_emotionalStateBefore, After - $_emotionalStateAfter.'),
                  ),
                );
                _emotionalStateBefore = 'Neutral';
                _emotionalStateAfter = 'Neutral';
              },
            ),
          ],
        );
      },
    );
  }

  void _setMindfulnessGoal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Mindfulness Goal'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _mindfulnessGoal = value;
              });
            },
            decoration: InputDecoration(hintText: "Enter your goal"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mindfulness goal set: $_mindfulnessGoal'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mindfulness Exercises'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Current Mindfulness Goal: $_mindfulnessGoal'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: _setMindfulnessGoal,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(exercises[index]['title']!),
                  subtitle: Text(exercises[index]['description']!),
                  trailing: ElevatedButton(
                    onPressed: () => _startExercise(exercises[index]['title']!),
                    child: Text('Start'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
