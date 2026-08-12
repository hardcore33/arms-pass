import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_cupons_parceiro/listagem_de_cupons_parceiro_widget.dart';
import '/components/menu_mobile/menu_mobile_widget.dart';
import '/components/menu_parceiro/menu_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/components/header_pagina/header_pagina_widget.dart';
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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CuponsParceiroModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: ObterCuponsDoParceiroCall.call(
        partnerId: currentUserUid,
      ),
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
        final cuponsParceiroObterCuponsDoParceiroResponse = snapshot.data!;

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
                        width: MediaQuery.sizeOf(context).width * 0.22,
                        height: MediaQuery.sizeOf(context).height * 1.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).secondary,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 30.0, 0.0, 20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.13,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.1,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 2.0,
                              indent: 20.0,
                              endIndent: 20.0,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: wrapWithModel(
                                  model: _model.menuParceiroModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: MenuParceiroWidget(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 1.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 20.0, 24.0, 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const HeaderPaginaWidget(
                                  titulo: 'Meus Cupons',
                                  breadcrumb: 'Parceiro',
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: wrapWithModel(
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
                                    ),
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
                    decoration: BoxDecoration(),
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
                          Spacer(),
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
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
