// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<int?> obterIdDoParceiroPorNome(
  String? nome,
  List<dynamic> parceiros,
) async {
  for (var element in parceiros) {
    if (element is Map) {
      final matchRazao = element['razao']?.toString() == nome;
      final matchFantasia = element['fantasia']?.toString() == nome;
      final matchCnpj = element['cnpj']?.toString() == nome;
      if (matchRazao || matchFantasia || matchCnpj) {
        if (element['id'] is int) return element['id'] as int;
        if (element['id'] != null) return int.tryParse(element['id'].toString());
      }
    }
  }

  return null;
}
