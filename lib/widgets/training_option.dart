import 'package:flutter/material.dart';

class TrainingOption extends StatelessWidget {
  final String name;
  final List<String> labels;
  final Function(int) callback;

  final List<bool> values;

  const TrainingOption(
      {Key? key,
      required this.callback,
      required this.values,
      required this.labels,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        ToggleButtons(
          children: List.from(labels.map((String e) => Text(e)).cast<Widget>()),
          onPressed: callback,
          isSelected: values,
        ),
      ],
    );
  }
}
