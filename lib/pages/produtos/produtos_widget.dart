import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_produtos/listagem_de_produtos_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'produtos_model.dart';
export 'produtos_model.dart';

class ProdutosWidget extends StatefulWidget {
  const ProdutosWidget({super.key});

  static String routeName = 'Produtos';
  static String routePath = '/produtos';

  @override
  State<ProdutosWidget> createState() => _ProdutosWidgetState();
}

class _ProdutosWidgetState extends State<ProdutosWidget> {
  late ProdutosModel _model;
  Future<ApiCallResponse>? _produtosFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProdutosModel());
    _produtosFuture = ObterProdutosCall.call();

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
                  child: const MenuWidget(activeIndex: 6),
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
                        24.0, 20.0, 24.0, 30.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderPaginaWidget(
                            titulo: 'Produtos & Recompensas',
                            breadcrumb: 'Painel',
                          ),
                          const SizedBox(height: 20.0),
                          FutureBuilder<ApiCallResponse>(
                            future: _produtosFuture,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const LoadingTableShimmerWidget(
                                  titulo: 'Produtos',
                                  rowCount: 5,
                                );
                              }
                              final produtosObterProdutosResponse = snapshot.data!;
                              final produtosList = produtosObterProdutosResponse.jsonBody is List
                                  ? (produtosObterProdutosResponse.jsonBody as List)
                                  : [];
                              if (produtosList.isEmpty) {
                                return Container(
                                  width: double.infinity,
                                  height: 300.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).alternate,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        color: FlutterFlowTheme.of(context).secondary,
                                        size: 64.0,
                                      ),
                                      const SizedBox(height: 16.0),
                                      Text(
                                        'Nenhum produto cadastrado ainda',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              font: GoogleFonts.openSans(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              fontSize: 16.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return wrapWithModel(
                                model: _model.listagemDeProdutosModel,
                                updateCallback: () => safeSetState(() {}),
                                child: ListagemDeProdutosWidget(
                                  products: produtosList,
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
