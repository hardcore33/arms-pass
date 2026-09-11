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

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final isCollapsed = FFAppState().sidebarCollapsed;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      hoverColor:
          isActive ? Colors.transparent : theme.primary.withValues(alpha: 0.12),
      splashColor: theme.primary.withValues(alpha: 0.2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 48.0,
        decoration: BoxDecoration(
          color: isActive ? theme.secondaryBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            if (!isCollapsed) ...[
              Container(
                width: 4.0,
                height: 24.0,
                decoration: BoxDecoration(
                  color: isActive ? theme.secondary : Colors.transparent,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(width: 14.0),
            ],
            Icon(
              icon,
              size: 20.0,
              color: isActive
                  ? theme.primary
                  : theme.primaryText.withValues(alpha: 0.85),
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: theme.bodyMedium.override(
                    fontFamily: 'Open Sans',
                    fontSize: 14.0,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive
                        ? theme.primary
                        : theme.primaryText.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final isCollapsed = FFAppState().sidebarCollapsed;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        isCollapsed ? 8.0 : 16.0,
        0.0,
        isCollapsed ? 8.0 : 8.0,
        0.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 15.0),
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (!isCollapsed)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 140.0,
                      height: 50.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                InkWell(
                  onTap: () {
                    FFAppState().sidebarCollapsed = !isCollapsed;
                  },
                  borderRadius: BorderRadius.circular(20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      isCollapsed
                          ? Icons.chevron_right_rounded
                          : Icons.chevron_left_rounded,
                      color: theme.primary,
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2.0,
            color: theme.primary,
          ),
          const SizedBox(height: 15.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildMenuItem(
                    context: context,
                    title: 'Home',
                    icon: Icons.home_rounded,
                    isActive: FFAppState().indexPage == 1,
                    onTap: () {
                      context.pushNamed(DashboardParceiroWidget.routeName);
                      FFAppState().indexPage = 1;
                      safeSetState(() {});
                    },
                  ),
                  const SizedBox(height: 6.0),
                  _buildMenuItem(
                    context: context,
                    title: 'Validar',
                    icon: Icons.qr_code_scanner_rounded,
                    isActive: FFAppState().indexPage == 3,
                    onTap: () {
                      context.pushNamed(ValidarParceiroWidget.routeName);
                      FFAppState().indexPage = 3;
                      safeSetState(() {});
                    },
                  ),
                  const SizedBox(height: 6.0),
                  _buildMenuItem(
                    context: context,
                    title: 'Cupons',
                    icon: Icons.confirmation_number_outlined,
                    isActive: FFAppState().indexPage == 2,
                    onTap: () {
                      context.pushNamed(CuponsParceiroWidget.routeName);
                      FFAppState().indexPage = 2;
                      safeSetState(() {});
                    },
                  ),
                  const SizedBox(height: 6.0),
                  _buildMenuItem(
                    context: context,
                    title: 'Contrato',
                    icon: Icons.description_outlined,
                    isActive: FFAppState().indexPage == 4,
                    onTap: () {
                      context.pushNamed(ContratoParceiroWidget.routeName);
                      FFAppState().indexPage = 4;
                      safeSetState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(
              color: theme.alternate,
              thickness: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 15.0),
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
                width: double.infinity,
                height: 55.0,
                decoration: BoxDecoration(
                  color: valueOrDefault<Color>(
                    FFAppState().indexPage != 10
                        ? theme.primary
                        : theme.secondaryBackground,
                    theme.primary,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: isCollapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (!isCollapsed)
                      const SizedBox(width: 24.0),
                    const Icon(
                      Icons.logout,
                      color: Color(0xFFE57373),
                    ),
                    if (!isCollapsed)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Sair',
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.openSans(
                              fontWeight: FontWeight.w500,
                              fontStyle: theme.bodyMedium.fontStyle,
                            ),
                            color: const Color(0xFFE57373),
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: theme.bodyMedium.fontStyle,
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
    );
  }
}
