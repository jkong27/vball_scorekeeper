import 'package:flutter/material.dart';

void main() {
  runApp(const VolleyballScorekeeperApp());
}

class VolleyballScorekeeperApp extends StatelessWidget {
  const VolleyballScorekeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volleyball Scorekeeper',
      debugShowCheckedModeBanner: false,
      home: const ScoreboardPage(),
    );
  }
}

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  static const Color teamBlue = Color(0xFF186CF2);
  static const Color teamRed = Color(0xFFED244C);

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  int blueScore = 0;
  int redScore = 0;

  void _resetScores() {
    setState(() {
      blueScore = 0;
      redScore = 0;
    });
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset scores?'),
        content: const Text('Both teams will return to 00.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _resetScores();
    }
  }

  void _handleTap(Offset position, BoxConstraints constraints) {
    final isBlueSide = position.dx < constraints.maxWidth / 2;
    final isAboveOverlay = position.dy < constraints.maxHeight * 2 / 3;

    setState(() {
      if (isAboveOverlay) {
        if (isBlueSide) {
          blueScore++;
        } else {
          redScore++;
        }
      } else {
        if (isBlueSide) {
          blueScore = blueScore > 0 ? blueScore - 1 : 0;
        } else {
          redScore = redScore > 0 ? redScore - 1 : 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Row(
                children: [
                  _teamSide(ScoreboardPage.teamBlue, blueScore),
                  _teamSide(ScoreboardPage.teamRed, redScore),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: constraints.maxHeight / 3,
                child: IgnorePointer(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) =>
                      _handleTap(details.localPosition, constraints),
                ),
              ),
              Positioned(
                left: constraints.maxWidth * 5 / 6,
                width: constraints.maxWidth / 6,
                bottom: 0,
                height: constraints.maxHeight / 3,
                child: TextButton(
                  onPressed: () => _confirmReset(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    minimumSize: Size(
                      constraints.maxWidth / 6,
                      constraints.maxHeight / 3,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Text(
                    'RESET',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _teamSide(Color color, int score) {
    return Expanded(
      child: Container(
        color: color,
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest.shortestSide * 0.85;
            return Text(
              score.toString().padLeft(2, '0'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1,
                fontSize: size,
              ),
            );
          },
        ),
      ),
    );
  }
}
