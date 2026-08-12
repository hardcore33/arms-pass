import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/auth/custom_auth/auth_util.dart';

String? formataDataDeExibicao(String? date) {
  if (date != null) {
    DateTime dateTime = DateTime.parse(date!);
    DateFormat formatter = DateFormat('dd/MM/yyyy');

    return formatter.format(dateTime);
  }
}

String defineTipoDeUsuario(String tipo) {
  return tipo == '2'
      ? 'Admin'
      : tipo == '1'
          ? 'Parceiro'
          : 'Usuário';
}

String? obterDataAtual() {
  final now = DateTime.now();
  return now.toIso8601String();
}

String? obterNomeDoArquivo(FFUploadedFile uploadedFile) {
  return uploadedFile.name;
}

dynamic setaJsonDeParceiro(
  dynamic jsonOriginal,
  bool? isSelected,
) {
  return {
    "isActive": true,
    "isSelected": isSelected ?? false,
    "razao": jsonOriginal["razao"],
    "fantasia": jsonOriginal["fantasia"],
    "cnpj": jsonOriginal["cnpj"],
    "segment": {
      "id": jsonOriginal["segment"]["id"],
      "name": jsonOriginal["segment"]["name"],
      "photo": jsonOriginal["segment"]["photo"]
    },
    "number": jsonOriginal["number"],
    "email": jsonOriginal["email"],
    "street": jsonOriginal["street"],
    "number_adress": jsonOriginal["number_adress"],
    "cep": jsonOriginal["cep"],
    "neighborhood": jsonOriginal["neighborhood"],
    "city": jsonOriginal["city"],
    "contract": jsonOriginal["contract"],
    "photo": jsonOriginal["photo"],
    "state": jsonOriginal["state"],
    "representative_cpf": jsonOriginal["representative_cpf"],
    "representative_rg": jsonOriginal["representative_rg"],
    "representative_number": jsonOriginal["representative_number"],
    "representative_name": jsonOriginal["representative_name"],
    "proposal": jsonOriginal["proposal"],
    "tenant": {
      "id": jsonOriginal["tenant"]["id"],
      "name": jsonOriginal["tenant"]["name"],
      "adress": {
        "id": jsonOriginal["tenant"]["adress"]["id"],
        "city": jsonOriginal["tenant"]["adress"]["city"],
        "neighborhood": jsonOriginal["tenant"]["adress"]["neighborhood"],
        "number": jsonOriginal["tenant"]["adress"]["number"],
        "state": jsonOriginal["tenant"]["adress"]["state"],
        "rua": jsonOriginal["tenant"]["adress"]["rua"],
        "zipcode": jsonOriginal["tenant"]["adress"]["zipcode"]
      }
    }
  };
}

List<String> obterEstados() {
  return [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
    'DF'
  ];
}

List<dynamic>? obterParceiros(List<dynamic>? clientes) {
  return clientes!.where((cliente) => cliente['partner'] != null).toList();
}

double? calcularValorAPagar(
  double? valorDoItem,
  int? desconto,
) {
  double valorAPagar = valorDoItem! * (desconto! / 100);
  return valorAPagar;
}

int convertToInt(String valor) {
  return int.parse(valor);
}

bool obterEstadoDeTroca(String status) {
  return status == '0' ? true : false;
}

List<String> criarParceiros(
  List<dynamic> parceiros,
  int idSegmento,
) {
  List<String> partnerNames = parceiros
      .where((item) => item['segment']?['id'] == idSegmento)
      .map((item) => item['razao'] as String)
      .toList();

  return partnerNames;
}

dynamic jsonOrNull(dynamic json) {
  if (json == null) {
    return null;
  }

  Map<String, dynamic>? mapToCheck;

  if (json is Map) {
    mapToCheck = Map<String, dynamic>.from(json);
  } else {
    try {
      mapToCheck = json.toMap();
    } catch (e) {
      return json;
    }
  }

  if (mapToCheck != null) {
    bool isAllNull = true;
    mapToCheck.forEach((key, value) {
      if (value != null && value != '') {
        isAllNull = false;
      }
    });

    if (isAllNull) {
      return null;
    }
  }

  return mapToCheck;
}

List<dynamic>? obterClientes(List<dynamic>? clientes) {
  if (clientes == null) return [];
  return clientes.where((cliente) => cliente['partner'] == null).toList();
}

