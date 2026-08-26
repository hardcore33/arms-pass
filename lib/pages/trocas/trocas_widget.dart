import '/backend/api_requests/api_calls.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/listagem_de_trocas/listagem_de_trocas_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrocasModel());

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
      future: GetHistoricoCompletoCall.call(),
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
        final validacoesResponse = snapshot.data!;

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
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(50.0, 30.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderPaginaWidget(
                            titulo: 'Validações de Cupons',
                            breadcrumb: 'Painel',
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 50.0, 0.0),
                            child: wrapWithModel(
                              model: _model.listagemDeTrocasModel,
                              updateCallback: () => safeSetState(() {}),
                              child: ListagemDeTrocasWidget(
                                trocas: validacoesResponse.jsonBody,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
