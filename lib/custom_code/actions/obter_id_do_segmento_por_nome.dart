// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<int?> obterIdDoSegmentoPorNome(
  List<dynamic> segmentos,
  String? nome,
) async {
  for (var element in segmentos) {
    if (element is Map && element['name'] == nome) {
      if (element['id'] is int) return element['id'] as int;
      if (element['id'] != null) return int.tryParse(element['id'].toString());
    }
  }

  return null;
}
