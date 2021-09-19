import 'dart:math';

import 'package:confetti/confetti.dart' as c;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rechentrainer/utils/shape.dart';

class ConfettiWidget extends StatefulWidget {
  final List<Widget>? children;
  final int particles;

  const ConfettiWidget({Key? key, this.children, required this.particles})
      : super(key: key);

  @override
  _ConfettiWidgetState createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget> {
  late c.ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController =
        c.ConfettiController(duration: const Duration(seconds: 5));

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: c.ConfettiWidget(
            confettiController: _confettiController,
            emissionFrequency: 0,
            blastDirectionality: c.BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            numberOfParticles: max(widget.particles, 1),
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
            createParticlePath: drawStar, // define a custom shape/
          ),
        ),
        ...?widget.children
      ],
    );
  }
}
