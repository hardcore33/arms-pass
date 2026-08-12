import '/backend/api_requests/api_calls.dart';
import '/components/box_graficos_compras_anuais/box_graficos_compras_anuais_widget.dart';
import '/components/box_graficos_compras_mensais/box_graficos_compras_mensais_widget.dart';
import '/components/box_graficos_trocas_anuais/box_graficos_trocas_anuais_widget.dart';
import '/components/box_graficos_trocas_mensais/box_graficos_trocas_mensais_widget.dart';
import '/components/box_indicadores/box_indicadores_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Menu component.
  late MenuModel menuModel;
  // Model for Box_Indicadores component.
  late BoxIndicadoresModel boxIndicadoresModel1;
  // Model for Box_Indicadores component.
  late BoxIndicadoresModel boxIndicadoresModel3;
  // Model for Box_Indicadores component.
  late BoxIndicadoresModel boxIndicadoresModel5;
  // Model for Box_Indicadores component.
  late BoxIndicadoresModel boxIndicadoresModel7;
  // Model for Box_Graficos_ComprasMensais component.
  late BoxGraficosComprasMensaisModel boxGraficosComprasMensaisModel;
  // Model for Box_Graficos_ComprasAnuais component.
  late BoxGraficosComprasAnuaisModel boxGraficosComprasAnuaisModel;
  // Model for Box_Graficos_TrocasMensais component.
  late BoxGraficosTrocasMensaisModel boxGraficosTrocasMensaisModel;
  // Model for Box_Graficos_TrocasAnuais component.
  late BoxGraficosTrocasAnuaisModel boxGraficosTrocasAnuaisModel;

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
    boxIndicadoresModel1 = createModel(context, () => BoxIndicadoresModel());
    boxIndicadoresModel3 = createModel(context, () => BoxIndicadoresModel());
    boxIndicadoresModel5 = createModel(context, () => BoxIndicadoresModel());
    boxIndicadoresModel7 = createModel(context, () => BoxIndicadoresModel());
    boxGraficosComprasMensaisModel =
        createModel(context, () => BoxGraficosComprasMensaisModel());
    boxGraficosComprasAnuaisModel =
        createModel(context, () => BoxGraficosComprasAnuaisModel());
    boxGraficosTrocasMensaisModel =
        createModel(context, () => BoxGraficosTrocasMensaisModel());
    boxGraficosTrocasAnuaisModel =
        createModel(context, () => BoxGraficosTrocasAnuaisModel());
  }

  @override
  void dispose() {
    menuModel.dispose();
    boxIndicadoresModel1.dispose();
    boxIndicadoresModel3.dispose();
    boxIndicadoresModel5.dispose();
    boxIndicadoresModel7.dispose();
    boxGraficosComprasMensaisModel.dispose();
    boxGraficosComprasAnuaisModel.dispose();
    boxGraficosTrocasMensaisModel.dispose();
    boxGraficosTrocasAnuaisModel.dispose();
  }
}
