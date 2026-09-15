import 'package:flutter/material.dart';
import 'flutter_flow/flutter_flow_util.dart';

abstract class FFAppConstants {
  static const String tenantId = '1';

  /// URL Base da API REST - Altere aqui ao migrar de domínio
  static const String apiBaseUrl = 'https://codeflowbr.online:8080/api/v1';

  /// WhatsApp oficial de suporte aos parceiros e administradores
  static const String whatsappSupportNumber = '5545999620924';

  /// Largura mínima (em px) para exibir layouts em modo "largo"
  /// (ex.: KPIs em linha em vez de Wrap, preview lateral do celular).
  static const double kWideLayoutBreakpoint = 900.0;
}

