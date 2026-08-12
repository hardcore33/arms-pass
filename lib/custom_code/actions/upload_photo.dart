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

Future<String> uploadPhoto(FFUploadedFile? uploadedFile) async {
  if (uploadedFile == null || uploadedFile.bytes == null) {
    print('Nenhum arquivo foi selecionado.');
    return 'Erro: Nenhum arquivo foi selecionado.';
  }

  final uri = Uri.parse('https://codeflowbr.online:8080/api/v1/photo');
  final request = http.MultipartRequest('POST', uri);

  request.files.add(http.MultipartFile.fromBytes(
    'photo',
    uploadedFile.bytes!,
    filename: uploadedFile.name,
  ));

  try {
    final response = await request.send();

    final responseBody = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      final imageUrl = responseBody.body;
      print('Imagem enviada com sucesso: $imageUrl');
      return imageUrl;
    } else {
      print('Erro ao enviar imagem: ${response.statusCode}');
      return 'Erro: Falha ao enviar imagem. Código ${response.statusCode}';
    }
  } catch (e) {
    print('Erro ao enviar o arquivo: $e');
    return 'Erro: ${e.toString()}';
  }
}
