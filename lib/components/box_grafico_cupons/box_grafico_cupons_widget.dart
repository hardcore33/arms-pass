import 'package:fl_chart/fl_chart.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoxGraficoCuponsWidget extends StatelessWidget {
  const BoxGraficoCuponsWidget({
    super.key,
    required this.json,
  });

  final dynamic json;

  @override
  Widget build(BuildContext context) {
    // Extract coupon data from API response
    double validados = castToType<double>(getJsonField(json, r'''$.cuponsUtilizados''')) ?? 0.0;
    if (validados == 0.0) {
      final compraAnual = getJsonField(json, r'''$.compraAnual''');
      if (compraAnual is List && compraAnual.isNotEmpty) {
        for (final item in compraAnual) {
          validados += castToType<double>(getJsonField(item, r'''$.valor''')) ?? 0.0;
        }
      }
      if (validados == 0.0) {
        final compraMensal = getJsonField(json, r'''$.compraMensal''');
        if (compraMensal is List && compraMensal.isNotEmpty) {
          for (final item in compraMensal) {
            validados += castToType<double>(getJsonField(item, r'''$.valor''')) ?? 0.0;
          }
        }
      }
      if (validados == 0.0) {
        validados = castToType<double>(getJsonField(json, r'''$.qtdUsuariosComprasPeriodo''')) ?? 0.0;
      }
    }
    final double ativos = castToType<double>(getJsonField(json, r'''$.cuponsAtivos''')) ?? 0.0;
    final double total = validados + ativos;

    const cardBgColor = Color(0xFFFAF7F2);
    const borderColor = Color(0xFFE2E8F0);
    const validatedColor = Color(0xFF10B981); // Emerald Green
    const nonValidatedColor = Color(0xFFCBD5E1); // Slate 300

    return Container(
      height: 120.0,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 8.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Donut Chart
            SizedBox(
              width: 90.0,
              height: 90.0,
              child: total > 0
                  ? PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 28,
                        startDegreeOffset: -90,
                        sections: [
                          PieChartSectionData(
                            color: validatedColor, // Esmeralda (Validados)
                            value: validados,
                            title: '',
                            radius: 12,
                          ),
                          PieChartSectionData(
                            color: nonValidatedColor, // Slate Suave (Não validados)
                            value: ativos,
                            title: '',
                            radius: 12,
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text(
                        '0',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 16.0),
            // Legends & Values
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Proporção de Cupons',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: validatedColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'Validados: ${validados.toInt()}',
                        style: GoogleFonts.openSans(
                          color: const Color(0xFF64748B),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: nonValidatedColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'Não Validados: ${ativos.toInt()}',
                        style: GoogleFonts.openSans(
                          color: const Color(0xFF64748B),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
