// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> getAddressByCep(String cep) async {
  final String url = 'https://viacep.com.br/ws/$cep/json/';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Verifica se o CEP é válido
    if (data.containsKey('erro')) {
      throw Exception('CEP inválido');
    }

    // Retorna os dados do endereço
    return {
      'logradouro': data['logradouro'],
      'bairro': data['bairro'],
      'cidade': data['localidade'],
      'uf': data['uf'],
      'cep': data['cep']
    };
  } else {
    throw Exception('Falha ao buscar o endereço');
  }
}
