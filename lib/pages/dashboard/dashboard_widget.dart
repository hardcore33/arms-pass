import '/backend/api_requests/api_calls.dart';
import '/components/box_graficos_compras_anuais/box_graficos_compras_anuais_widget.dart';
import '/components/box_graficos_compras_mensais/box_graficos_compras_mensais_widget.dart';
import '/components/box_graficos_trocas_anuais/box_graficos_trocas_anuais_widget.dart';
import '/components/box_graficos_trocas_mensais/box_graficos_trocas_mensais_widget.dart';
import '/components/box_indicadores/box_indicadores_widget.dart';
import '/components/box_segmentos_destaque/box_segmentos_destaque_widget.dart';
import '/components/box_parceiros_destaque/box_parceiros_destaque_widget.dart';
import '/components/tabela_desempenho_parceiros/tabela_desempenho_parceiros_widget.dart';
import '/components/box_grafico_cupons/box_grafico_cupons_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  static String routeName = 'Dashboard';
  static String routePath = '/dashboard';

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late DashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    return FutureBuilder<ApiCallResponse>(
      future: ObterDashboardCompletoCall.call(),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            body: Center(
              child: SizedBox(
                width: 30.0,
                height: 30.0,
                child: SpinKitFadingFour(
                  color: FlutterFlowTheme.of(context).secondary,
                  size: 30.0,
                ),
              ),
            ),
          );
        }
        final dashboardObterDashboardCompletoResponse = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            body: SafeArea(
              top: true,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: FFAppState().sidebarCollapsed
                        ? 80.0
                        : MediaQuery.sizeOf(context).width * 0.22,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondary,
                    ),
                    child: wrapWithModel(
                      model: _model.menuModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const MenuWidget(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 1.0,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 20.0, 24.0, 0.0),
                              child: HeaderPaginaWidget(
                                titulo: 'Dashboard',
                                breadcrumb: 'Painel',
                                descricao:
                                    'Bem-vindo de volta ao painel ARMS GYM',
                              ),
                            ),
                            Container(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 20.0, 20.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // Row 1 (Financial Indicators - Highlighted)
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: wrapWithModel(
                                          model: _model.boxIndicadoresModel1,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: BoxIndicadoresWidget(
                                            titulo: 'Total de vendas',
                                            dado: 'R\$ ' +
                                                (ObterDashboardCompletoCall
                                                            .totalVendas(
                                                                dashboardObterDashboardCompletoResponse
                                                                    .jsonBody) ??
                                                        0.0)
                                                    .toStringAsFixed(2)
                                                    .replaceAll('.', ','),
                                            destaque: true,
                                            icon: Icon(
                                              Icons.shopping_cart,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 26.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: wrapWithModel(
                                          model: _model.boxIndicadoresModel3,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: BoxIndicadoresWidget(
                                            titulo: 'Descontos aplicados',
                                            dado: 'R\$ ' +
                                                (ObterDashboardCompletoCall
                                                            .descontosAplicados(
                                                                dashboardObterDashboardCompletoResponse
                                                                    .jsonBody) ??
                                                        0.0)
                                                    .toStringAsFixed(2)
                                                    .replaceAll('.', ','),
                                            destaque: true,
                                            icon: Icon(
                                              Icons.discount_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                  const SizedBox(height: 16.0),
                                  // Row 2 (Detailed KPI indicators + Coupons Donut)
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: wrapWithModel(
                                          model: _model.boxIndicadoresModel5,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: BoxIndicadoresWidget(
                                            titulo: 'Usuários ativos',
                                            dado: (ObterDashboardCompletoCall
                                                        .usuariosAtivos(
                                                      dashboardObterDashboardCompletoResponse
                                                          .jsonBody,
                                                    ) ??
                                                    0.0)
                                                .toInt()
                                                .toString(),
                                            icon: Icon(
                                              Icons.people,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 26.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: wrapWithModel(
                                          model: _model.boxIndicadoresModel7,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: BoxIndicadoresWidget(
                                            titulo: 'Parceiros ativos',
                                            dado: (ObterDashboardCompletoCall
                                                        .parceirosAtivos(
                                                      dashboardObterDashboardCompletoResponse
                                                          .jsonBody,
                                                    ) ??
                                                    0.0)
                                                .toInt()
                                                .toString(),
                                            icon: Icon(
                                              Icons.business_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 26.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: BoxGraficoCuponsWidget(
                                          json:
                                              dashboardObterDashboardCompletoResponse
                                                  .jsonBody,
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                ],
                              ),
                            ),
                          // Charts block (Compras mensais & Compras anuais)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 25.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 20.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: wrapWithModel(
                                        model: _model
                                            .boxGraficosComprasMensaisModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: BoxGraficosComprasMensaisWidget(
                                          titulo: 'Compras mensais',
                                          json:
                                              dashboardObterDashboardCompletoResponse
                                                  .jsonBody,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: wrapWithModel(
                                        model: _model
                                            .boxGraficosComprasAnuaisModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: BoxGraficosComprasAnuaisWidget(
                                          titulo: 'Compras anuais',
                                          json:
                                              dashboardObterDashboardCompletoResponse
                                                  .jsonBody,
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 10.0)),
                                ),
                              ),
                            ),
                          ),
                          // Bottom Section: Dynamic highlights (Segmentos Ranking & Parceiros Carrossel)
                          // Bottom Section: Tabela Consolidada de Desempenho dos Parceiros
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20.0, 25.0, 20.0, 30.0),
                            child: FutureBuilder<List<ApiCallResponse>>(
                              future: Future.wait([
                                ObterParceirosCall.call(),
                                ObterCuponsCall.call(),
                                GetHistoricoCompletoCall.call(),
                              ]),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                    height: 250.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                return TabelaDesempenhoParceirosWidget(
                                  parceiros: snapshot.data![0].jsonBody,
                                  cupons: snapshot.data![1].jsonBody,
                                  trocas: snapshot.data![2].jsonBody,
                                  dashboardJson: dashboardObterDashboardCompletoResponse.jsonBody,
                                );
                              },
                            ),
                          ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
