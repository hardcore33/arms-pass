// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:fl_chart/fl_chart.dart'; // Importa o pacote para gráficos de barras

class BarChartSampleTrocaMensal extends StatefulWidget {
  const BarChartSampleTrocaMensal({
    super.key,
    this.width,
    this.height,
    required this.jsonData, // Agora recebemos o JSON completo
  });

  final double? width;
  final double? height;
  final Map<String, dynamic> jsonData; // JSON completo que você passa

  @override
  State<BarChartSampleTrocaMensal> createState() =>
      _BarChartSampleTrocaMensalState();
}

class _BarChartSampleTrocaMensalState extends State<BarChartSampleTrocaMensal> {
  @override
  Widget build(BuildContext context) {
    // Extrai a lista trocaMensal do JSON completo
    List<dynamic> trocaMensal = widget.jsonData['trocaMensal'] ?? [];

    // Verifica se há dados em trocaMensal
    List<BarChartGroupData> barGroups = trocaMensal.isNotEmpty
        ? trocaMensal.map((item) {
            int mes =
                item['mes'] - 1; // Ajusta o índice do mês (Jan = 0, Dez = 11)
            double valor = item['valor'].toDouble();

            return BarChartGroupData(
              x: mes,
              barRods: [
                BarChartRodData(
                  toY: valor,
                  color: FlutterFlowTheme.of(context).secondary,
                  width: 14.0,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
              ],
            );
          }).toList()
        : []; // Se não houver dados, retorna uma lista vazia

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 400,
      child: barGroups.isNotEmpty // Verifica se há dados para exibir
          ? BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => FlutterFlowTheme.of(context).secondaryBackground,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(0)} trocas',
                        TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32.0,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final style = TextStyle(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                        );
                        switch (value.toInt()) {
                          case 0:
                            return Text('Jan', style: style);
                          case 1:
                            return Text('Fev', style: style);
                          case 2:
                            return Text('Mar', style: style);
                          case 3:
                            return Text('Abr', style: style);
                          case 4:
                            return Text('Mai', style: style);
                          case 5:
                            return Text('Jun', style: style);
                          case 6:
                            return Text('Jul', style: style);
                          case 7:
                            return Text('Ago', style: style);
                          case 8:
                            return Text('Set', style: style);
                          case 9:
                            return Text('Out', style: style);
                          case 10:
                            return Text('Nov', style: style);
                          case 11:
                            return Text('Dez', style: style);
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40.0,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: FlutterFlowTheme.of(context).alternate.withOpacity(0.5),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: barGroups,
              ),
            )
          : Center(
              child: Text(
                'Sem dados para exibir',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 14.0,
                ),
              ),
            ), // Exibe uma mensagem quando não há dados
    );
  }
}
