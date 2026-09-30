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

Future<dynamic> getCompanyByCnpj(String cnpj) async {
  final digits = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length != 14) {
    throw Exception('CNPJ inválido');
  }

  // 1. Tenta BrasilAPI com timeout
  try {
    final response = await http
        .get(Uri.parse('https://brasilapi.com.br/api/cnpj/v1/$digits'))
        .timeout(const Duration(seconds: 6));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return {
        'razaoSocial': data['razao_social'] ?? '',
        'nomeFantasia': data['nome_fantasia'] ?? '',
        'logradouro': data['logradouro'] ?? '',
        'numero': data['numero'] ?? '',
        'bairro': data['bairro'] ?? '',
        'cidade': data['municipio'] ?? '',
        'uf': data['uf'] ?? '',
        'cep': data['cep'] ?? '',
        'telefone': data['ddd_telefone_1'] ?? '',
        'email': data['email'] ?? '',
        'situacaoCadastral': data['descricao_situacao_cadastral'] ?? '',
      };
    }
  } catch (_) {
    // Caso falhe ou ocorra timeout, tenta o fallback
  }

  // 2. Fallback: ReceitaWS
  try {
    final response = await http
        .get(Uri.parse('https://receitaws.com.br/v1/cnpj/$digits'))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK' || data['nome'] != null) {
        return {
          'razaoSocial': data['nome'] ?? '',
          'nomeFantasia': data['fantasia'] ?? '',
          'logradouro': data['logradouro'] ?? '',
          'numero': data['numero'] ?? '',
          'bairro': data['bairro'] ?? '',
          'cidade': data['municipio'] ?? '',
          'uf': data['uf'] ?? '',
          'cep': data['cep'] ?? '',
          'telefone': data['telefone'] ?? '',
          'email': data['email'] ?? '',
          'situacaoCadastral': data['situacao'] ?? '',
        };
      }
    }
  } catch (_) {
    // Falha em ambas as fontes
  }

  throw Exception('CNPJ não encontrado');
}

