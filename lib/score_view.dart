import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';

const _scoreStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: primaryPurple,
);

class ScoreView extends StatelessWidget {
  const ScoreView({Key? key}) : super(key: key);

  static get route => MaterialPageRoute(builder: (context) => const ScoreView());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scoreboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('scores').orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) => _buildListItem(doc)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildListItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ListTile(
      title: Text(data['user']),
      subtitle: Text(data['date'].toDate().toString()),
      trailing: Text("${data['player']}:${data['enemy']}", style: _scoreStyle),
    );
  }
}
