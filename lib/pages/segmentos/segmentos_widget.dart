import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_segmentos/listagem_de_segmentos_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'segmentos_model.dart';
export 'segmentos_model.dart';

class SegmentosWidget extends StatefulWidget {
  const SegmentosWidget({super.key});

  static String routeName = 'Segmentos';
  static String routePath = '/segmentos';

  @override
  State<SegmentosWidget> createState() => _SegmentosWidgetState();
}

class _SegmentosWidgetState extends State<SegmentosWidget> {
  late SegmentosModel _model;
  Future<ApiCallResponse>? _segmentosFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SegmentosModel());
    _segmentosFuture = ObterSegmentosCall.call();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _recarregar() {
    setState(() {
      _segmentosFuture = ObterSegmentosCall.call();
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
                  child: const MenuWidget(activeIndex: 11),
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
                            titulo: 'Segmentos de Atuação',
                            breadcrumb: 'Painel',
                          ),
                          const SizedBox(height: 20.0),
                          FutureBuilder<ApiCallResponse>(
                            future: _segmentosFuture,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const LoadingTableShimmerWidget(
                                  titulo: 'Segmentos',
                                  rowCount: 5,
                                );
                              }
                              final segmentosObterSegmentosResponse = snapshot.data!;
                              final raw = segmentosObterSegmentosResponse.jsonBody;
                              final List<dynamic> segmentosList = (raw is List)
                                  ? raw
                                  : (raw is Map && raw['data'] is List)
                                      ? raw['data']
                                      : [];

                              return wrapWithModel(
                                model: _model.listagemDeSegmentosModel,
                                updateCallback: () => safeSetState(() {}),
                                child: ListagemDeSegmentosWidget(
                                  cupons: segmentosList,
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
