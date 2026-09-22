// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> formatDecimalInput(String input) async {
  final clean = input.trim().replaceAll(RegExp(r'[^0-9,.]'), '');
  if (clean.isEmpty) return '0.00';

  String normalized = clean;
  if (normalized.contains(',') && normalized.contains('.')) {
    if (normalized.lastIndexOf(',') > normalized.lastIndexOf('.')) {
      normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
    } else {
      normalized = normalized.replaceAll(',', '');
    }
  } else if (normalized.contains(',')) {
    normalized = normalized.replaceAll(',', '.');
  }

  double? value = double.tryParse(normalized);
  if (value == null) return '0.00';
  return value.toStringAsFixed(2);
}
