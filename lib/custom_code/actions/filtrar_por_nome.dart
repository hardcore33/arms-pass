// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<dynamic>?> filtrarPorNome(
    List<dynamic>? jsonList, String? nome, int searchType, bool? filter) async {
  if (jsonList == null || jsonList.isEmpty) return [];
  if (nome == null || nome.isEmpty) return jsonList;
  String nomeLower = nome.toLowerCase();

  if (searchType == 1) {
    return jsonList
        .where((element) =>
            element is Map &&
            (element['name'] ?? '').toString().toLowerCase().contains(nomeLower))
        .toList();
  } else if (searchType == 2) {
    return jsonList
        .where((element) =>
            element is Map &&
            (element['razao'] ?? '').toString().toLowerCase().contains(nomeLower))
        .toList();
  } else if (searchType == 3) {
    return jsonList
        .where((element) =>
            element is Map &&
            element['customer'] is Map &&
            (element['customer']['name'] ?? '').toString().toLowerCase().contains(nomeLower))
        .toList();
  } else if (searchType == 4) {
    return jsonList
        .where((element) =>
            element is Map &&
            element['partner'] is Map &&
            (element['partner']['fantasia'] ?? element['partner']['nome'] ?? '').toString().toLowerCase().contains(nomeLower))
        .toList();
  } else if (searchType == 5) {
    return jsonList
        .where((element) =>
            element is Map &&
            (element['imagem'] ?? '').toString().toLowerCase().contains(nomeLower))
        .toList();
  } else if (searchType == 6) {
    return jsonList
        .where((element) =>
            element is Map &&
            (element['description'] ?? '').toString().toLowerCase().contains(nomeLower))
        .toList();
  }
  return jsonList;
}
