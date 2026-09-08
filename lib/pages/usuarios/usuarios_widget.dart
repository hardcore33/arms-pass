import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_usuarios/listagem_de_usuarios_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import 'usuarios_model.dart';
export 'usuarios_model.dart';

class UsuariosWidget extends StatefulWidget {
  const UsuariosWidget({super.key});

  static String routeName = 'Usuarios';
  static String routePath = '/usuarios';

  @override
  State<UsuariosWidget> createState() => _UsuariosWidgetState();
}

class _UsuariosWidgetState extends State<UsuariosWidget> {
  late UsuariosModel _model;
  Future<ApiCallResponse>? _usuariosFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UsuariosModel());
    _usuariosFuture = ObterUsuariosCall.call();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _recarregar() {
    setState(() {
      _usuariosFuture = ObterUsuariosCall.call();
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
                  child: const MenuWidget(activeIndex: 3),
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
                        const EdgeInsetsDirectional.fromSTEB(30.0, 20.0, 30.0, 30.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderPaginaWidget(
                            titulo: 'Usuários',
                            breadcrumb: 'Painel',
                          ),
                          const SizedBox(height: 20.0),
                          FutureBuilder<ApiCallResponse>(
                            future: _usuariosFuture,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const LoadingTableShimmerWidget(
                                  titulo: 'Usuários',
                                  rowCount: 6,
                                );
                              }
                              final usuariosObterUsuariosResponse = snapshot.data!;

                              return wrapWithModel(
                                model: _model.listagemDeUsuariosModel,
                                updateCallback: () => safeSetState(() {}),
                                child: ListagemDeUsuariosWidget(
                                  users: functions.obterClientes(
                                      usuariosObterUsuariosResponse.jsonBody),
                                  onUserEdit: () async {
                                    _recarregar();
                                    FFAppState().update(() {});
                                  },
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
