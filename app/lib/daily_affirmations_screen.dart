// Darshan Nair and Raahul Nair
import 'package:flutter/material.dart';
import 'db_helper.dart';

class DailyAffirmationsScreen extends StatefulWidget {
  @override
  _DailyAffirmationsScreenState createState() =>
      _DailyAffirmationsScreenState();
}

class _DailyAffirmationsScreenState extends State<DailyAffirmationsScreen> {
  List<String> affirmations = [];
  final TextEditingController _affirmationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAffirmations(); // Load saved affirmations when screen is opened
  }

  Future<void> _loadAffirmations() async {
    final savedAffirmations = await DBHelper.instance.getAffirmations();
    setState(() {
      affirmations = savedAffirmations.map((e) => e['text'] as String).toList();
    });
  }

  void _addAffirmation() async {
    if (_affirmationController.text.isNotEmpty) {
      setState(() {
        affirmations.add(_affirmationController.text);
      });
      await DBHelper.instance.insertAffirmation(
          _affirmationController.text); // Save affirmation to DB
      _affirmationController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Affirmation added!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Affirmations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _affirmationController,
              decoration: InputDecoration(
                hintText: 'Enter your affirmation',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addAffirmation,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: affirmations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(affirmations[index]),
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
