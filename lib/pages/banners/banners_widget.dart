import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_banners/listagem_de_banners_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'banners_model.dart';
export 'banners_model.dart';

class BannersWidget extends StatefulWidget {
  const BannersWidget({super.key});

  static String routeName = 'Banners';
  static String routePath = '/banners';

  @override
  State<BannersWidget> createState() => _BannersWidgetState();
}

class _BannersWidgetState extends State<BannersWidget> {
  late BannersModel _model;
  Future<ApiCallResponse>? _bannersFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BannersModel());
    _bannersFuture = ObterBannersCall.call();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _recarregar() {
    setState(() {
      _bannersFuture = ObterBannersCall.call();
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
                  child: const MenuWidget(activeIndex: 8),
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
                        const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderPaginaWidget(
                          titulo: 'Banners',
                          breadcrumb: 'Painel',
                        ),
                        const SizedBox(height: 16.0),
                        Expanded(
                          child: FutureBuilder<ApiCallResponse>(
                            future: _bannersFuture,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const LoadingTableShimmerWidget(
                                  titulo: 'Banners',
                                  rowCount: 5,
                                );
                              }
                              final bannersObterBannersResponse = snapshot.data!;

                              return wrapWithModel(
                                model: _model.listagemDeBannersModel,
                                updateCallback: () => safeSetState(() {}),
                                child: ListagemDeBannersWidget(
                                  banners: bannersObterBannersResponse.jsonBody,
                                ),
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
