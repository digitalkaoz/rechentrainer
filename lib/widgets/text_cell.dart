import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextCell extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final EdgeInsets padding;
  final bool center;
  final Color borderColor;

  const TextCell({
    Key? key,
    required this.text,
    this.style,
    this.padding = const EdgeInsets.all(20),
    this.center = false,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: center
          ? Center(
              child: Text(
              text,
              style: style?.copyWith(fontSize: 20),
            ))
          : Text(
              text,
              style: style?.copyWith(fontSize: 20),
            ),
    );
  }
}
