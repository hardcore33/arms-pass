import 'package:flutter_test/flutter_test.dart';
import 'package:procard_teste_de_melhorias/custom_code/actions/format_decimal_input.dart';

void main() {
  group('formatDecimalInput Tests', () {
    test('converte valores com ponto e virgula sem crash', () async {
      expect(await formatDecimalInput('7951'), '7951.00');
      expect(await formatDecimalInput('79,51'), '79.51');
      expect(await formatDecimalInput('1.250,50'), '1250.50');
      expect(await formatDecimalInput(''), '0.00');
      expect(await formatDecimalInput('abc'), '0.00');
    });
  });
}
