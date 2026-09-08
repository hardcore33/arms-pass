import '/backend/api_requests/api_calls.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/listagem_de_trocas/listagem_de_trocas_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'trocas_model.dart';
export 'trocas_model.dart';

class TrocasWidget extends StatefulWidget {
  const TrocasWidget({super.key});

  static String routeName = 'Validações';
  static String routePath = '/validacoes';

  @override
  State<TrocasWidget> createState() => _TrocasWidgetState();
}

class _TrocasWidgetState extends State<TrocasWidget> {
  late TrocasModel _model;
  Future<ApiCallResponse>? _trocasFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrocasModel());
    _trocasFuture = GetHistoricoCompletoCall.call();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _recarregar() {
    setState(() {
      _trocasFuture = GetHistoricoCompletoCall.call();
    });
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
                  child: const MenuWidget(activeIndex: 7),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        30.0, 20.0, 30.0, 30.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderPaginaWidget(
                            titulo: 'Validações de Cupons',
                            breadcrumb: 'Painel',
                          ),
                          const SizedBox(height: 20.0),
                          FutureBuilder<ApiCallResponse>(
                            future: _trocasFuture,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const LoadingTableShimmerWidget(
                                  titulo: 'Validações de Cupons',
                                  rowCount: 6,
                                );
                              }
                              final validacoesResponse = snapshot.data!;

                              return wrapWithModel(
                                model: _model.listagemDeTrocasModel,
                                updateCallback: () => safeSetState(() {}),
                                child: ListagemDeTrocasWidget(
                                  trocas: validacoesResponse.jsonBody,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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
