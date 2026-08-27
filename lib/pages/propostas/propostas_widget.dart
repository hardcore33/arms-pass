import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_propostas/listagem_de_propostas_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'propostas_model.dart';
export 'propostas_model.dart';

class PropostasWidget extends StatefulWidget {
  const PropostasWidget({super.key});

  static String routeName = 'Propostas';
  static String routePath = '/propostas';

  @override
  State<PropostasWidget> createState() => _PropostasWidgetState();
}

class _PropostasWidgetState extends State<PropostasWidget> {
  late PropostasModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PropostasModel());

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
      future: ObterPropostasCall.call(),
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
        final propostasObterPropostasResponse = snapshot.data!;

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
                          Text(
                            'Propostas',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 50.0, 50.0, 0.0),
                            child: () {
                              final propostasList = propostasObterPropostasResponse.jsonBody is List
                                  ? (propostasObterPropostasResponse.jsonBody as List)
                                  : [];
                              if (propostasList.isEmpty) {
                                return Container(
                                  width: double.infinity,
                                  height: 300.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).secondary,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        color: FlutterFlowTheme.of(context).secondary,
                                        size: 64.0,
                                      ),
                                      const SizedBox(height: 16.0),
                                      Text(
                                        'Nenhuma proposta cadastrada ainda',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              font: GoogleFonts.openSans(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return wrapWithModel(
                                model: _model.listagemDePropostasModel,
                                updateCallback: () => safeSetState(() {}),
                                child: ListagemDePropostasWidget(
                                  propostas: propostasList,
                                ),
                              );
                            }(),
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
