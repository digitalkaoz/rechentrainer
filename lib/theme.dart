import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const primary = Color(0xFF00BCD4);

final platformTheme = ThemeData(
  cupertinoOverrideTheme: const CupertinoThemeData(
    primaryColor: primary,
  ),
  primarySwatch: Colors.cyan,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.cyan),
      padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
      foregroundColor: MaterialStateProperty.all(Colors.cyan),
    ),
  ),
);
