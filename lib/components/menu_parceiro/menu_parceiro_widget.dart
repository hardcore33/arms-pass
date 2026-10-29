import '/auth/custom_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/components/modal_alterar_senha_parceiro/modal_alterar_senha_parceiro_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final isCollapsed = FFAppState().sidebarCollapsed;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      hoverColor: isActive ? Colors.transparent : const Color(0xFFF8FAFC),
      splashColor: const Color(0x15D97706),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 48.0,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFEF3C7) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: isActive
              ? Border.all(color: const Color(0xFFFDE68A), width: 1.0)
              : null,
        ),
        child: Row(
          mainAxisAlignment: isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            if (!isCollapsed) ...[
              Container(
                width: 3.5,
                height: 22.0,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFD97706) : Colors.transparent,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(width: 14.0),
            ],
            Icon(
              icon,
              size: 20.0,
              color: isActive
                  ? const Color(0xFFD97706)
                  : const Color(0xFF64748B),
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    fontSize: 14.0,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF475569),
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
                      color: const Color(0xFF64748B),
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1.0,
            color: Color(0xFFC5BCA8),
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
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              color: theme.alternate,
              thickness: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: const Color(0x1A25D366),
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              onTap: () async {
                final message = Uri.encodeComponent('Olá, sou parceiro do Clube Procard e preciso de suporte.');
                await launchURL('https://wa.me/${FFAppConstants.whatsappSupportNumber}?text=$message');
              },
              child: Container(
                width: double.infinity,
                height: 48.0,
                decoration: BoxDecoration(
                  color: const Color(0x1525D366),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: const Color(0x4025D366),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: isCollapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (!isCollapsed) const SizedBox(width: 18.0),
                    const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Color(0xFF25D366),
                      size: 20.0,
                    ),
                    if (!isCollapsed)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Suporte WhatsApp',
                          style: theme.bodyMedium.override(
                            fontFamily: 'Open Sans',
                            color: const Color(0xFF25D366),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
            child: Tooltip(
              message: isCollapsed ? 'Alterar Senha' : '',
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: const Color(0xFFF1F5F9),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (dialogContext) => const ModalAlterarSenhaParceiroWidget(),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFECE4),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      if (!isCollapsed) const SizedBox(width: 18.0),
                      const Icon(
                        Icons.lock_outline_rounded,
                        color: Color(0xFF0F172A),
                        size: 20.0,
                      ),
                      if (!isCollapsed)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Alterar Senha',
                            style: GoogleFonts.openSans(
                              color: const Color(0xFF0F172A),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
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
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 15.0),
            child: Tooltip(
              message: isCollapsed ? 'Sair' : '',
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: const Color(0xFFFEF2F2),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                onTap: () async {
                  GoRouter.of(context).prepareAuthEvent();
                  await authManager.signOut();
                  GoRouter.of(context).clearRedirectLocation();

                  context.goNamedAuth(LoginWidget.routeName, context.mounted);
                },
                child: Container(
                  width: double.infinity,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: const Color(0xFFFECACA),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      if (!isCollapsed) const SizedBox(width: 18.0),
                      const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFDC2626),
                        size: 20.0,
                      ),
                      if (!isCollapsed)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Sair',
                            style: GoogleFonts.openSans(
                              color: const Color(0xFFDC2626),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
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
