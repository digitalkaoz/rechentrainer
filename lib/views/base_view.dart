import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseView extends StatelessWidget {
  final String title;

  final Widget body;

  final FloatingActionButton? action;

  const BaseView({
    Key? key,
    required this.title,
    required this.body,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
      ),
      body: body,
      floatingActionButton: action,
    );
  }
}
