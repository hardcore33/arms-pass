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

  // 1. Provedor 1: Open CNPJa (CORS liberado *, alta disponibilidade)
  try {
    final response = await http
        .get(Uri.parse('https://open.cnpja.com/office/$digits'))
        .timeout(const Duration(seconds: 4));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final company = data['company'] as Map<String, dynamic>?;
      final address = data['address'] as Map<String, dynamic>?;
      final phones = data['phones'] as List<dynamic>?;
      final emails = data['emails'] as List<dynamic>?;
      final status = data['status'] as Map<String, dynamic>?;

      String phone = '';
      if (phones != null && phones.isNotEmpty) {
        final p = phones[0] as Map<String, dynamic>;
        final area = p['area']?.toString() ?? '';
        final number = p['number']?.toString() ?? '';
        phone = area.isNotEmpty ? '($area) $number' : number;
      }

      String email = '';
      if (emails != null && emails.isNotEmpty) {
        final e = emails[0] as Map<String, dynamic>;
        email = e['address']?.toString() ?? '';
      }

      return {
        'razaoSocial': company?['name']?.toString() ?? '',
        'nomeFantasia': data['alias']?.toString() ?? '',
        'logradouro': address?['street']?.toString() ?? '',
        'numero': address?['number']?.toString() ?? '',
        'bairro': address?['district']?.toString() ?? '',
        'cidade': address?['city']?.toString() ?? '',
        'uf': address?['state']?.toString() ?? '',
        'cep': address?['zip']?.toString() ?? '',
        'telefone': phone,
        'email': email,
        'situacaoCadastral': status?['text']?.toString() ?? '',
      };
    }
  } catch (_) {}

  // 2. Provedor 2: Publica CNPJ.ws (CORS liberado)
  try {
    final response = await http
        .get(Uri.parse('https://publica.cnpj.ws/cnpj/$digits'))
        .timeout(const Duration(seconds: 4));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final est = data['estabelecimento'] as Map<String, dynamic>?;
      final estado = est?['estado'] as Map<String, dynamic>?;
      final cidade = est?['cidade'] as Map<String, dynamic>?;

      String phone = '';
      final ddd1 = est?['ddd1']?.toString() ?? '';
      final tel1 = est?['telefone1']?.toString() ?? '';
      if (ddd1.isNotEmpty && tel1.isNotEmpty) {
        phone = '($ddd1) $tel1';
      } else if (tel1.isNotEmpty) {
        phone = tel1;
      }

      return {
        'razaoSocial': data['razao_social']?.toString() ?? '',
        'nomeFantasia': est?['nome_fantasia']?.toString() ?? '',
        'logradouro': est?['logradouro']?.toString() ?? '',
        'numero': est?['numero']?.toString() ?? '',
        'bairro': est?['bairro']?.toString() ?? '',
        'cidade': cidade?['nome']?.toString() ?? '',
        'uf': estado?['sigla']?.toString() ?? '',
        'cep': est?['cep']?.toString() ?? '',
        'telefone': phone,
        'email': est?['email']?.toString() ?? '',
        'situacaoCadastral': est?['situacao_cadastral']?.toString() ?? '',
      };
    }
  } catch (_) {}

  // 3. Provedor 3: BrasilAPI
  try {
    final response = await http
        .get(Uri.parse('https://brasilapi.com.br/api/cnpj/v1/$digits'))
        .timeout(const Duration(seconds: 4));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return {
        'razaoSocial': data['razao_social']?.toString() ?? '',
        'nomeFantasia': data['nome_fantasia']?.toString() ?? '',
        'logradouro': data['logradouro']?.toString() ?? '',
        'numero': data['numero']?.toString() ?? '',
        'bairro': data['bairro']?.toString() ?? '',
        'cidade': data['municipio']?.toString() ?? '',
        'uf': data['uf']?.toString() ?? '',
        'cep': data['cep']?.toString() ?? '',
        'telefone': data['ddd_telefone_1']?.toString() ?? '',
        'email': data['email']?.toString() ?? '',
        'situacaoCadastral': data['descricao_situacao_cadastral']?.toString() ?? '',
      };
    }
  } catch (_) {}

  // 4. Provedor 4: ReceitaWS
  try {
    final response = await http
        .get(Uri.parse('https://receitaws.com.br/v1/cnpj/$digits'))
        .timeout(const Duration(seconds: 4));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK' || data['nome'] != null) {
        return {
          'razaoSocial': data['nome']?.toString() ?? '',
          'nomeFantasia': data['fantasia']?.toString() ?? '',
          'logradouro': data['logradouro']?.toString() ?? '',
          'numero': data['numero']?.toString() ?? '',
          'bairro': data['bairro']?.toString() ?? '',
          'cidade': data['municipio']?.toString() ?? '',
          'uf': data['uf']?.toString() ?? '',
          'cep': data['cep']?.toString() ?? '',
          'telefone': data['telefone']?.toString() ?? '',
          'email': data['email']?.toString() ?? '',
          'situacaoCadastral': data['situacao']?.toString() ?? '',
        };
      }
    }
  } catch (_) {}

  throw Exception('CNPJ não encontrado');
}
