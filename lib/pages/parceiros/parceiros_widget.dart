import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_parceiros/listagem_de_parceiros_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
import 'parceiros_model.dart';
export 'parceiros_model.dart';

class ParceirosWidget extends StatefulWidget {
  const ParceirosWidget({super.key});

  static String routeName = 'Parceiros';
  static String routePath = '/parceiros';

  @override
  State<ParceirosWidget> createState() => _ParceirosWidgetState();
}

class _ParceirosWidgetState extends State<ParceirosWidget> {
  late ParceirosModel _model;
  Future<ApiCallResponse>? _parceirosFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ParceirosModel());
    _parceirosFuture = ObterUsuariosCall.call();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _recarregar() {
    setState(() {
      _parceirosFuture = ObterUsuariosCall.call();
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
                  child: const MenuWidget(activeIndex: 4),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 30.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderPaginaWidget(
                            titulo: 'Parceiros',
                            breadcrumb: 'Painel',
                          ),
                          const SizedBox(height: 20.0),
                          FutureBuilder<ApiCallResponse>(
                            future: _parceirosFuture,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const LoadingTableShimmerWidget(
                                  titulo: 'Parceiros',
                                  rowCount: 6,
                                );
                              }
                              final parceirosObterUsuariosResponse = snapshot.data!;

                              return wrapWithModel(
                                model: _model.listagemDeParceirosModel,
                                updateCallback: () => safeSetState(() {}),
                                child: ListagemDeParceirosWidget(
                                  parceiros: functions.obterParceiros(
                                      parceirosObterUsuariosResponse.jsonBody)!,
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
