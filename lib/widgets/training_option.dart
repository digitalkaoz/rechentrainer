import 'package:flutter/cupertino.dart';
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ToggleButtons(
          children: List.from(labels
              .map((String e) => Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(e),
                  ))
              .cast<Widget>()),
          onPressed: callback,
          isSelected: values,
          selectedBorderColor: Colors.cyan,
        ),
        Divider(
          color: Theme.of(context).primaryColor,
          height: 0,
          thickness: 1,
        ),
      ],
    );
  }
}
