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
    List<dynamic> jsonList, String? nome, int searchType, bool? filter) async {
  String nomeLower = nome!.toLowerCase();
  /* 
  1 - Por nome
  2 - Pela razão social
  3 - Pelo nome do cliente
  4 - Pelo nome fantasia
  5 - Pelo nome da imagem
  */
  if (searchType == 1) {
    return jsonList
        .where((element) =>
            element['name'].toString().toLowerCase().contains(nomeLower))
        .toList();
  } else if (searchType == 2) {
    return jsonList
        .where((element) =>
            element['razao'].toString().toLowerCase().contains(nomeLower))
        .toList();
  } else if (searchType == 3) {
    return jsonList
        .where((element) => element['customer']['name']
            .toString()
            .toLowerCase()
            .contains(nomeLower))
        .toList();
  } else if (searchType == 4) {
    return jsonList
        .where((element) => element['partner']['fantasia']
            .toString()
            .toLowerCase()
            .contains(nomeLower))
        .toList();
  } else if (searchType == 5) {
    return jsonList
        .where((element) =>
            element['imagem'].toString().toLowerCase().contains(nomeLower))
        .toList();
  } else if (searchType == 6) {
    return jsonList
        .where((element) =>
            element['description'].toString().toLowerCase().contains(nomeLower))
        .toList();
  }
}
