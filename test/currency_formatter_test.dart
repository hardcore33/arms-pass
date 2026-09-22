import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:procard_teste_de_melhorias/flutter_flow/currency_formatter.dart';

void main() {
  group('CurrencyInputFormatter Tests', () {
    final formatter = CurrencyInputFormatter();

    test('formata centavos progressivamente', () {
      var val = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '7'),
      );
      expect(val.text, '0,07');

      val = formatter.formatEditUpdate(
        val,
        const TextEditingValue(text: '0,079'),
      );
      expect(val.text, '0,79');

      val = formatter.formatEditUpdate(
        val,
        const TextEditingValue(text: '0,795'),
      );
      expect(val.text, '7,95');

      val = formatter.formatEditUpdate(
        val,
        const TextEditingValue(text: '7,951'),
      );
      expect(val.text, '79,51');
    });

    test('formata valores com milhares', () {
      var val = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '125000'),
      );
      expect(val.text, '1.250,00');
    });

    test('toApiString converte corretamente', () {
      expect(CurrencyInputFormatter.toApiString('79,51'), '79.51');
      expect(CurrencyInputFormatter.toApiString('1.250,00'), '1250.00');
      expect(CurrencyInputFormatter.toApiString('0,05'), '0.05');
      expect(CurrencyInputFormatter.toApiString(''), '');
    });

    test('toDouble converte corretamente', () {
      expect(CurrencyInputFormatter.toDouble('79,51'), 79.51);
      expect(CurrencyInputFormatter.toDouble('1.250,00'), 1250.00);
      expect(CurrencyInputFormatter.toDouble(''), 0.0);
    });
  });
}
