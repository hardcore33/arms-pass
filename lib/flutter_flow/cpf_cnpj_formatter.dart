import 'package:flutter/services.dart';

/// Formata o campo automaticamente como CPF (###.###.###-##)
/// quando o usuário digita até 11 dígitos, ou como CNPJ
/// (##.###.###/####-##) quando digita 12 ou mais dígitos.
class CpfCnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Extrai somente dígitos
    final digits =
        newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formatted;
    if (digits.length <= 11) {
      formatted = _formatCpf(digits);
    } else {
      // Limita a 14 dígitos (tamanho máximo do CNPJ)
      final cnpjDigits =
          digits.length > 14 ? digits.substring(0, 14) : digits;
      formatted = _formatCnpj(cnpjDigits);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Aplica a máscara de CPF: ###.###.###-##
  String _formatCpf(String digits) {
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// Aplica a máscara de CNPJ: ##.###.###/####-##
  String _formatCnpj(String digits) {
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5) buffer.write('.');
      if (i == 8) buffer.write('/');
      if (i == 12) buffer.write('-');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

/// Retorna o número de dígitos de um CPF/CNPJ formatado ou não.
int cpfCnpjDigitCount(String value) =>
    value.replaceAll(RegExp(r'[^0-9]'), '').length;

/// Retorna true se o valor é um CPF válido (11 dígitos).
bool isCpf(String value) => cpfCnpjDigitCount(value) == 11;

/// Retorna true se o valor é um CNPJ válido (14 dígitos).
bool isCnpj(String value) => cpfCnpjDigitCount(value) == 14;
