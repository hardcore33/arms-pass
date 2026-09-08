import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_cupons_parceiro/listagem_de_cupons_parceiro_widget.dart';
import '/components/menu_mobile/menu_mobile_widget.dart';
import '/components/menu_parceiro/menu_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
import 'cupons_parceiro_model.dart';
export 'cupons_parceiro_model.dart';

class CuponsParceiroWidget extends StatefulWidget {
  const CuponsParceiroWidget({super.key});

  static String routeName = 'Cupons_Parceiro';
  static String routePath = '/partner/cupom';

  @override
  State<CuponsParceiroWidget> createState() => _CuponsParceiroWidgetState();
}

class _CuponsParceiroWidgetState extends State<CuponsParceiroWidget> {
  late CuponsParceiroModel _model;
  Future<ApiCallResponse>? _cuponsFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CuponsParceiroModel());
    _cuponsFuture = ObterCuponsDoParceiroCall.call(partnerId: currentUserUid);
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _recarregar() {
    setState(() {
      _cuponsFuture = ObterCuponsDoParceiroCall.call(partnerId: currentUserUid);
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (responsiveVisibility(
              context: context,
              phone: false,
              tablet: false,
              tabletLandscape: false,
            ))
              Row(
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
                      model: _model.menuParceiroModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const MenuParceiroWidget(),
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
                            24.0, 20.0, 24.0, 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HeaderPaginaWidget(
                              titulo: 'Meus Cupons',
                              breadcrumb: 'Parceiro',
                            ),
                            const SizedBox(height: 16.0),
                            Expanded(
                              child: FutureBuilder<ApiCallResponse>(
                                future: _cuponsFuture,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const LoadingTableShimmerWidget(
                                      titulo: 'Lista de Cupons Ativos',
                                      rowCount: 5,
                                    );
                                  }
                                  final cuponsParceiroObterCuponsDoParceiroResponse =
                                      snapshot.data!;

                                  return wrapWithModel(
                                    model: _model.listagemDeCuponsParceiroModel,
                                    updateCallback: () => safeSetState(() {}),
                                    child: ListagemDeCuponsParceiroWidget(
                                      cupons:
                                          cuponsParceiroObterCuponsDoParceiroResponse
                                              .jsonBody,
                                      onChanged: () async {
                                        setState(() {});
                                      },
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
            if (responsiveVisibility(
              context: context,
              desktop: false,
            ))
              Container(
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: const BoxDecoration(),
                child: Visibility(
                  visible: responsiveVisibility(
                    context: context,
                    desktop: false,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      wrapWithModel(
                        model: _model.menuMobileModel,
                        updateCallback: () => safeSetState(() {}),
                        child: MenuMobileWidget(),
                      ),
                      const Spacer(),
                      Text(
                        'Não disponível na versão mobile.',
                        style: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              font: GoogleFonts.readexPro(),
                              color: FlutterFlowTheme.of(context).secondary,
                              letterSpacing: 0.0,
                            ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
