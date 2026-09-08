import '/backend/api_requests/api_calls.dart';
import '/components/tabela_desempenho_parceiros/tabela_desempenho_parceiros_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
import 'package:flutter/material.dart';
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
  Future<List<ApiCallResponse>>? _dashboardDataFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());
    _dashboardDataFuture = Future.wait([
      ObterParceirosCall.call(),
      ObterCuponsCall.call(),
      GetHistoricoCompletoCall.call(),
      ObterDashboardCompletoCall.call(),
      ObterUsuariosCall.call(),
    ]);

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
                    : (MediaQuery.sizeOf(context).width * 0.22).clamp(220.0, 320.0),
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondary,
                ),
                child: wrapWithModel(
                  model: _model.menuModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const MenuWidget(activeIndex: 1),
                ),
              ),
              Expanded(
                child: SizedBox(
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
                        // Painel Consolidado de Desempenho dos Parceiros
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20.0, 20.0, 20.0, 30.0),
                          child: FutureBuilder<List<ApiCallResponse>>(
                            future: _dashboardDataFuture,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const LoadingTableShimmerWidget(
                                  titulo: 'Desempenho dos Parceiros',
                                  rowCount: 6,
                                );
                              }
                              return TabelaDesempenhoParceirosWidget(
                                parceiros: snapshot.data![0].jsonBody,
                                cupons: snapshot.data![1].jsonBody,
                                trocas: snapshot.data![2].jsonBody,
                                dashboardJson: snapshot.data![3].jsonBody,
                                usuarios: snapshot.data![4].jsonBody,
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
  }
}
