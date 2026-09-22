import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formata a entrada numérica como moeda em Reais (0,00)
/// da direita para a esquerda (padrão de maquininhas de cartão e PDV).
/// Exemplos:
/// Digita "7" -> "0,07"
/// Digita "9" -> "0,79"
/// Digita "5" -> "7,95"
/// Digita "1" -> "79,51"
class CurrencyInputFormatter extends TextInputFormatter {
  final int maxDigits;

  CurrencyInputFormatter({this.maxDigits = 9}); // Até R$ 9.999.999,99

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Extrai somente números
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    final double value = (int.tryParse(digits) ?? 0) / 100.0;
    final formatter = NumberFormat('#,##0.00', 'pt_BR');
    final formatted = formatter.format(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Converte o texto formatado (ex: "79,51" ou "1.250,00") para string no formato de API ("79.51" ou "1250.00")
  static String toApiString(String? text) {
    if (text == null || text.trim().isEmpty) return '';
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';
    final double value = (int.tryParse(digits) ?? 0) / 100.0;
    return value.toStringAsFixed(2);
  }

  /// Converte o texto formatado para double (ex: "79,51" -> 79.51)
  static double toDouble(String? text) {
    if (text == null || text.trim().isEmpty) return 0.0;
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0.0;
    return (int.tryParse(digits) ?? 0) / 100.0;
  }
}
