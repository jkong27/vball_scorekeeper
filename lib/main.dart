import 'package:flutter/material.dart';

void main() {
  runApp(VolleyballScorekeeperApp());
}

class VolleyballScorekeeperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volleyball Scorekeeper',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScoreKeeperPage(),
    );
  }
}

class MatchState {
  int teamAScore;
  int teamBScore;
  int teamASets;
  int teamBSets;
  bool isTeamAServing;

  MatchState({
    required this.teamAScore,
    required this.teamBScore,
    required this.teamASets,
    required this.teamBSets,
    required this.isTeamAServing,
  });

  // Clone for history
  MatchState copy() => MatchState(
    teamAScore: teamAScore,
    teamBScore: teamBScore,
    teamASets: teamASets,
    teamBSets: teamBSets,
    isTeamAServing: isTeamAServing,
  );
}

class ScoreKeeperPage extends StatefulWidget {
  @override
  _ScoreKeeperPageState createState() => _ScoreKeeperPageState();
}

class _ScoreKeeperPageState extends State<ScoreKeeperPage> {
  late MatchState state;
  final List<MatchState> history = [];

  @override
  void initState() {
    super.initState();
    state = MatchState(
      teamAScore: 0,
      teamBScore: 0,
      teamASets: 0,
      teamBSets: 0,
      isTeamAServing: true,
    );
  }

  void saveState() {
    history.add(state.copy());
  }

  void addPoint(bool teamA) {
    setState(() {
      saveState();
      if (teamA) {
        state.teamAScore++;
        state.isTeamAServing = true;
      } else {
        state.teamBScore++;
        state.isTeamAServing = false;
      }
    });
  }

  void undo() {
    setState(() {
      if (history.isNotEmpty) {
        state = history.removeLast();
      }
    });
  }

  void resetMatch() {
    setState(() {
      state = MatchState(
        teamAScore: 0,
        teamBScore: 0,
        teamASets: 0,
        teamBSets: 0,
        isTeamAServing: true,
      );
      history.clear();
    });
  }

  void addSet(bool teamA) {
    setState(() {
      saveState();
      if (teamA) {
        state.teamASets++;
      } else {
        state.teamBSets++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volleyball Scorekeeper'),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: resetMatch)],
      ),
      body: Row(
        children: [
          _teamColumn(
            'Team A',
            state.teamAScore,
            state.teamASets,
            true,
            Colors.blue,
          ),
          _teamColumn(
            'Team B',
            state.teamBScore,
            state.teamBSets,
            false,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Expanded _teamColumn(
    String name,
    int score,
    int sets,
    bool teamA,
    Color color,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => addPoint(teamA),
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            // Swiping down
            undo();
          }
        },
        child: Container(
          color: color.withOpacity(0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: TextStyle(fontSize: 28)),
              SizedBox(height: 20),
              Text('$score', style: TextStyle(fontSize: 80)),
              SizedBox(height: 20),
              Text('Sets: $sets', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              if ((teamA && state.isTeamAServing) ||
                  (!teamA && !state.isTeamAServing))
                Icon(Icons.sports_volleyball, size: 40, color: Colors.orange),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => addSet(teamA),
                child: Text('Add Set'),
              ),
              SizedBox(height: 10),
              Text('Swipe down to undo', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
