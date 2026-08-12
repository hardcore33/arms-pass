import '/auth/custom_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'menu_parceiro_model.dart';
export 'menu_parceiro_model.dart';

class MenuParceiroWidget extends StatefulWidget {
  const MenuParceiroWidget({super.key});

  @override
  State<MenuParceiroWidget> createState() => _MenuParceiroWidgetState();
}

class _MenuParceiroWidgetState extends State<MenuParceiroWidget> {
  late MenuParceiroModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuParceiroModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pushNamed(
                DashboardParceiroWidget.routeName,
                extra: <String, dynamic>{
                  '__transition_info__': TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.fade,
                    duration: Duration(milliseconds: 0),
                  ),
                },
              );

              FFAppState().indexPage = 1;
              safeSetState(() {});
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.23,
              height: 55.0,
              decoration: BoxDecoration(
                color: valueOrDefault<Color>(
                  FFAppState().indexPage != 1
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryBackground,
                  FlutterFlowTheme.of(context).primary,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.home_rounded,
                      color: valueOrDefault<Color>(
                        FFAppState().indexPage != 1
                            ? FlutterFlowTheme.of(context).secondary
                            : FlutterFlowTheme.of(context).tertiary,
                        FlutterFlowTheme.of(context).secondary,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Home',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.openSans(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: valueOrDefault<Color>(
                                FFAppState().indexPage != 1
                                    ? FlutterFlowTheme.of(context).secondary
                                    : FlutterFlowTheme.of(context).tertiary,
                                FlutterFlowTheme.of(context).secondary,
                              ),
                              fontSize: 15.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(
                  ValidarParceiroWidget.routeName,
                  extra: <String, dynamic>{
                    '__transition_info__': TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.fade,
                      duration: Duration(milliseconds: 0),
                    ),
                  },
                );

                FFAppState().indexPage = 3;
                safeSetState(() {});
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.23,
                height: 55.0,
                decoration: BoxDecoration(
                  color: valueOrDefault<Color>(
                    FFAppState().indexPage != 3
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryBackground,
                    FlutterFlowTheme.of(context).primary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.people_alt,
                        color: valueOrDefault<Color>(
                          FFAppState().indexPage != 3
                              ? FlutterFlowTheme.of(context).secondary
                              : FlutterFlowTheme.of(context).tertiary,
                          FlutterFlowTheme.of(context).secondary,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Validar',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: valueOrDefault<Color>(
                                  FFAppState().indexPage != 3
                                      ? FlutterFlowTheme.of(context).secondary
                                      : FlutterFlowTheme.of(context).tertiary,
                                  FlutterFlowTheme.of(context).secondary,
                                ),
                                fontSize: 15.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(
                  CuponsParceiroWidget.routeName,
                  extra: <String, dynamic>{
                    '__transition_info__': TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.fade,
                      duration: Duration(milliseconds: 0),
                    ),
                  },
                );

                FFAppState().indexPage = 2;
                safeSetState(() {});
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.23,
                height: 55.0,
                decoration: BoxDecoration(
                  color: valueOrDefault<Color>(
                    FFAppState().indexPage != 2
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryBackground,
                    FlutterFlowTheme.of(context).primary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.list_alt,
                        color: valueOrDefault<Color>(
                          FFAppState().indexPage != 2
                              ? FlutterFlowTheme.of(context).secondary
                              : FlutterFlowTheme.of(context).tertiary,
                          FlutterFlowTheme.of(context).secondary,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Cupons',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: valueOrDefault<Color>(
                                  FFAppState().indexPage != 2
                                      ? FlutterFlowTheme.of(context).secondary
                                      : FlutterFlowTheme.of(context).tertiary,
                                  FlutterFlowTheme.of(context).secondary,
                                ),
                                fontSize: 15.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(ContratoParceiroWidget.routeName);

                FFAppState().indexPage = 4;
                safeSetState(() {});
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.23,
                height: 55.0,
                decoration: BoxDecoration(
                  color: valueOrDefault<Color>(
                    FFAppState().indexPage != 4
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryBackground,
                    FlutterFlowTheme.of(context).primary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.edit_document,
                        color: valueOrDefault<Color>(
                          FFAppState().indexPage != 4
                              ? FlutterFlowTheme.of(context).secondary
                              : FlutterFlowTheme.of(context).tertiary,
                          FlutterFlowTheme.of(context).secondary,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Contrato',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: valueOrDefault<Color>(
                                  FFAppState().indexPage != 4
                                      ? FlutterFlowTheme.of(context).secondary
                                      : FlutterFlowTheme.of(context).tertiary,
                                  FlutterFlowTheme.of(context).secondary,
                                ),
                                fontSize: 15.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                GoRouter.of(context).prepareAuthEvent();
                await authManager.signOut();
                GoRouter.of(context).clearRedirectLocation();

                context.goNamedAuth(LoginWidget.routeName, context.mounted);
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.23,
                height: 55.0,
                decoration: BoxDecoration(
                  color: valueOrDefault<Color>(
                    FFAppState().indexPage != 10
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryBackground,
                    FlutterFlowTheme.of(context).primary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.logout,
                        color: valueOrDefault<Color>(
                          FFAppState().indexPage != 10
                              ? FlutterFlowTheme.of(context).secondary
                              : FlutterFlowTheme.of(context).tertiary,
                          FlutterFlowTheme.of(context).secondary,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(7.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Sair',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: valueOrDefault<Color>(
                                  FFAppState().indexPage != 10
                                      ? FlutterFlowTheme.of(context).secondary
                                      : FlutterFlowTheme.of(context).tertiary,
                                  FlutterFlowTheme.of(context).secondary,
                                ),
                                fontSize: 15.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
