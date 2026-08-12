import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/box_grafico_cupons/box_grafico_cupons_widget.dart';
import '/components/box_graficos_compras_anuais/box_graficos_compras_anuais_widget.dart';
import '/components/box_graficos_compras_anuais_mobile/box_graficos_compras_anuais_mobile_widget.dart';
import '/components/box_graficos_compras_mensais/box_graficos_compras_mensais_widget.dart';
import '/components/box_graficos_compras_mensais_mobile/box_graficos_compras_mensais_mobile_widget.dart';
import '/components/box_indicadores/box_indicadores_widget.dart';
import '/components/box_indicadores_mobile/box_indicadores_mobile_widget.dart';
import '/components/box_segmentos_destaque/box_segmentos_destaque_widget.dart';
import '/components/menu_mobile/menu_mobile_widget.dart';
import '/components/menu_parceiro/menu_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'dashboard_parceiro_widget.dart' show DashboardParceiroWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardParceiroModel extends FlutterFlowModel<DashboardParceiroWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Menu_Parceiro component.
  late MenuParceiroModel menuParceiroModel;
  // Row 1 — cards destaque
  late BoxIndicadoresModel boxIndicadoresModel1; // Total de vendas
  late BoxIndicadoresModel boxIndicadoresModel2; // Cupons ativos
  // Row 2 — cards normais + donut
  late BoxIndicadoresModel boxIndicadoresModel3; // Usuários ativos
  late BoxIndicadoresModel boxIndicadoresModel4; // Compras totais
  // Gráficos
  late BoxGraficosComprasMensaisModel boxGraficosComprasMensaisModel;
  late BoxGraficosComprasAnuaisModel boxGraficosComprasAnuaisModel;
  // Mobile
  late MenuMobileModel menuMobileModel;
  late BoxIndicadoresMobileModel boxIndicadoresMobileModel1;
  late BoxIndicadoresMobileModel boxIndicadoresMobileModel2;
  late BoxIndicadoresMobileModel boxIndicadoresMobileModel3;
  late BoxIndicadoresMobileModel boxIndicadoresMobileModel4;
  late BoxGraficosComprasMensaisMobileModel boxGraficosComprasMensaisMobileModel;
  late BoxGraficosComprasAnuaisMobileModel boxGraficosComprasAnuaisMobileModel;

  @override
  void initState(BuildContext context) {
    menuParceiroModel = createModel(context, () => MenuParceiroModel());
    boxIndicadoresModel1 = createModel(context, () => BoxIndicadoresModel());
    boxIndicadoresModel2 = createModel(context, () => BoxIndicadoresModel());
    boxIndicadoresModel3 = createModel(context, () => BoxIndicadoresModel());
    boxIndicadoresModel4 = createModel(context, () => BoxIndicadoresModel());
    boxGraficosComprasMensaisModel =
        createModel(context, () => BoxGraficosComprasMensaisModel());
    boxGraficosComprasAnuaisModel =
        createModel(context, () => BoxGraficosComprasAnuaisModel());
    menuMobileModel = createModel(context, () => MenuMobileModel());
    boxIndicadoresMobileModel1 =
        createModel(context, () => BoxIndicadoresMobileModel());
    boxIndicadoresMobileModel2 =
        createModel(context, () => BoxIndicadoresMobileModel());
    boxIndicadoresMobileModel3 =
        createModel(context, () => BoxIndicadoresMobileModel());
    boxIndicadoresMobileModel4 =
        createModel(context, () => BoxIndicadoresMobileModel());
    boxGraficosComprasMensaisMobileModel =
        createModel(context, () => BoxGraficosComprasMensaisMobileModel());
    boxGraficosComprasAnuaisMobileModel =
        createModel(context, () => BoxGraficosComprasAnuaisMobileModel());
  }

  @override
  void dispose() {
    menuParceiroModel.dispose();
    boxIndicadoresModel1.dispose();
    boxIndicadoresModel2.dispose();
    boxIndicadoresModel3.dispose();
    boxIndicadoresModel4.dispose();
    boxGraficosComprasMensaisModel.dispose();
    boxGraficosComprasAnuaisModel.dispose();
    menuMobileModel.dispose();
    boxIndicadoresMobileModel1.dispose();
    boxIndicadoresMobileModel2.dispose();
    boxIndicadoresMobileModel3.dispose();
    boxIndicadoresMobileModel4.dispose();
    boxGraficosComprasMensaisMobileModel.dispose();
    boxGraficosComprasAnuaisMobileModel.dispose();
  }
}
