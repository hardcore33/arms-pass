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
import 'dart:collection'; // Importa para trabalhar com Map

class BarChartTrocaAnualSample extends StatefulWidget {
  const BarChartTrocaAnualSample({
    super.key,
    this.width,
    this.height,
    required this.jsonData, // Agora recebemos o JSON completo
  });

  final double? width;
  final double? height;
  final Map<String, dynamic> jsonData; // JSON completo que você passa

  @override
  State<BarChartTrocaAnualSample> createState() =>
      _BarChartTrocaAnualSampleState();
}

class _BarChartTrocaAnualSampleState extends State<BarChartTrocaAnualSample> {
  @override
  Widget build(BuildContext context) {
    // Extrai a lista trocaMensal do JSON completo
    List<dynamic> trocaMensal = widget.jsonData['trocaMensal'] ?? [];

    // Cria um mapa para somar os valores de trocas por ano
    Map<int, double> trocasPorAno = {};

    // Itera pela lista de trocas mensais e soma os valores por ano
    for (var item in trocaMensal) {
      int ano = item['ano'];
      double valor = item['valor'].toDouble();

      // Se o ano já existe no mapa, soma o valor, senão, adiciona o ano
      if (trocasPorAno.containsKey(ano)) {
        trocasPorAno[ano] = trocasPorAno[ano]! + valor;
      } else {
        trocasPorAno[ano] = valor;
      }
    }

    // Converte o mapa para uma lista de BarChartGroupData para o gráfico
    List<BarChartGroupData> barGroups = trocasPorAno.entries.map((entry) {
      int anoIndex = entry.key - 2020; // Ajusta o índice do ano para o gráfico
      double valor = entry.value;

      return BarChartGroupData(
        x: anoIndex,
        barRods: [
          BarChartRodData(
            toY: valor,
            color: FlutterFlowTheme.of(context).secondary,
            width: 18.0,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
        ],
      );
    }).toList();

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
                        final year = (value.toInt() + 2020).toString();
                        return Text(year, style: style);
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
            ),
    );
  }
}
