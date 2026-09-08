import '/components/menu_mobile/menu_mobile_widget.dart';
import '/components/menu_parceiro/menu_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import 'contrato_parceiro_model.dart';
export 'contrato_parceiro_model.dart';

class ContratoParceiroWidget extends StatefulWidget {
  const ContratoParceiroWidget({super.key});

  static String routeName = 'Contrato_Parceiro';
  static String routePath = '/partner/contract';

  @override
  State<ContratoParceiroWidget> createState() => _ContratoParceiroWidgetState();
}

class _ContratoParceiroWidgetState extends State<ContratoParceiroWidget> {
  late ContratoParceiroModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContratoParceiroModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildContractCard(BuildContext context, {required bool isDesktop}) {
    final contractUrl = getJsonField(
      FFAppState().parceiro,
      r'''$.partner.contract''',
    )?.toString().trim() ?? '';

    final partnerName = getJsonField(
      FFAppState().parceiro,
      r'''$.partner.name''',
    )?.toString() ??
    getJsonField(
      FFAppState().parceiro,
      r'''$.partner.fantasy_name''',
    )?.toString() ??
    'Estabelecimento Parceiro';

    final partnerCnpj = getJsonField(
      FFAppState().parceiro,
      r'''$.partner.cnpj''',
    )?.toString() ?? 'Não informado';

    final cardBgColor = const Color(0xFF1E1E1E);
    final borderColor = const Color(0xFF2C2C2C);
    final goldColor = FlutterFlowTheme.of(context).secondary;

    return Material(
      color: Colors.transparent,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: isDesktop ? 860.0 : double.infinity,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
        ),
        padding: EdgeInsets.all(isDesktop ? 28.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Bar: Document Header & Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: goldColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: goldColor.withOpacity(0.3),
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    Icons.description_rounded,
                    color: goldColor,
                    size: 26.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contrato de Adesão & Termos Comerciais',
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: isDesktop ? 18.0 : 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Instrumento particular de parceria com o Clube Procard',
                        style: GoogleFonts.openSans(
                          color: const Color(0xFF9E9E9E),
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B382B),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: const Color(0xFF2E7D32),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'Vigente',
                        style: GoogleFonts.openSans(
                          color: const Color(0xFF81C784),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24.0),
            const Divider(color: Color(0xFF2C2C2C), thickness: 1.0),
            const SizedBox(height: 20.0),

            // Metadata Grid
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: const Color(0xFF262626),
                  width: 1.0,
                ),
              ),
              child: Wrap(
                spacing: 24.0,
                runSpacing: 16.0,
                children: [
                  _buildMetadataItem(
                    label: 'Razão Social / Parceiro',
                    value: partnerName,
                    icon: Icons.store_rounded,
                  ),
                  _buildMetadataItem(
                    label: 'CNPJ Cadastrado',
                    value: partnerCnpj,
                    icon: Icons.badge_outlined,
                  ),
                  _buildMetadataItem(
                    label: 'Tipo de Adesão',
                    value: 'Credenciamento Oficial Procard',
                    icon: Icons.verified_outlined,
                  ),
                  _buildMetadataItem(
                    label: 'Formato do Documento',
                    value: 'PDF Assinado Digitalmente',
                    icon: Icons.picture_as_pdf_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24.0),

            // Description Box
            Text(
              'Este instrumento legal regulamenta a concessão de benefícios, regras de aceitação de cupons promocionais e obrigações mútuas entre sua empresa e os associados Procard. Mantenha uma cópia deste documento para controle contábil e conformidade jurídica.',
              style: GoogleFonts.openSans(
                color: const Color(0xFFB0B0B0),
                fontSize: 13.5,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28.0),

            // Action Buttons
            Wrap(
              spacing: 16.0,
              runSpacing: 12.0,
              children: [
                // Primary Action: Open/Download PDF
                FFButtonWidget(
                  onPressed: () async {
                    if (contractUrl.isNotEmpty && contractUrl != 'null') {
                      await launchURL(contractUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'O link do contrato está em processamento pela equipe Procard.',
                          ),
                          backgroundColor: Color(0xFFD97706),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  text: 'Visualizar / Baixar Contrato (PDF)',
                  icon: const Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 20.0,
                  ),
                  options: FFButtonOptions(
                    height: 48.0,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    color: goldColor,
                    textStyle: GoogleFonts.openSans(
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),

                // Secondary Action: Copy Link
                if (contractUrl.isNotEmpty && contractUrl != 'null')
                  OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: contractUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link do contrato copiado com sucesso!'),
                          backgroundColor: Color(0xFF2E7D32),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 18.0,
                      color: goldColor,
                    ),
                    label: Text(
                      'Copiar Link Seguro',
                      style: GoogleFonts.openSans(
                        color: goldColor,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: goldColor.withOpacity(0.5), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24.0),

            // Security note footer
            Row(
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF757575),
                  size: 16.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Documento assinado digitalmente com validade jurídica em conformidade com a MP nº 2.200-2/2001.',
                    style: GoogleFonts.openSans(
                      color: const Color(0xFF757575),
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18.0, color: const Color(0xFF888888)),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.openSans(
                color: const Color(0xFF888888),
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
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
            // Desktop Version
            if (responsiveVisibility(
              context: context,
              phone: false,
              tablet: false,
              tabletLandscape: false,
            ))
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Sidebar
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
                  // Content Area
                  Expanded(
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 1.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 20.0, 24.0, 30.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const HeaderPaginaWidget(
                                titulo: 'Termo & Contrato',
                                breadcrumb: 'Parceiro',
                                descricao: 'Gerencie e visualize o contrato de adesão firmado com o Clube Procard',
                              ),
                              const SizedBox(height: 24.0),
                              _buildContractCard(context, isDesktop: true),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            // Mobile Version
            if (responsiveVisibility(
              context: context,
              desktop: false,
            ))
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      wrapWithModel(
                        model: _model.menuMobileModel,
                        updateCallback: () => safeSetState(() {}),
                        child: const MenuMobileWidget(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HeaderPaginaWidget(
                              titulo: 'Termo & Contrato',
                              breadcrumb: 'Parceiro',
                            ),
                            const SizedBox(height: 20.0),
                            _buildContractCard(context, isDesktop: false),
                          ],
                        ),
                      ),
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
