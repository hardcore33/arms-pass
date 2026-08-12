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
    final double validados = castToType<double>(getJsonField(json, r'''$.cuponsUtilizados''')) ?? 0.0;
    final double ativos = castToType<double>(getJsonField(json, r'''$.cuponsAtivos''')) ?? 0.0;
    final double total = validados + ativos;

    final cardBgColor = FlutterFlowTheme.of(context).primary;
    final borderColor = FlutterFlowTheme.of(context).secondary;
    final nonValidatedColor = const Color(0xFF4A4A4A);

    return Material(
      color: Colors.transparent,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        height: 120.0,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
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
                              color: FlutterFlowTheme.of(context).secondary, // Bege (Validados)
                              value: validados,
                              title: '',
                              radius: 12,
                            ),
                            PieChartSectionData(
                              color: nonValidatedColor, // Cinza Escuro (Não validados)
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
                            color: Colors.white,
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
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                            ),
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          'Validados: ${validados.toInt()}',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.openSans(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 11.0,
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
                          decoration: BoxDecoration(
                            color: nonValidatedColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          'Não Validados: ${ativos.toInt()}',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.openSans(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 11.0,
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
      ),
    );
  }
}
