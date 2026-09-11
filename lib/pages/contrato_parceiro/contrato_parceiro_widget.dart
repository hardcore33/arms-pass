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
    final theme = FlutterFlowTheme.of(context);
    final parceiroJson = FFAppState().parceiro;

    // O jsonBody do login tem estrutura { token, user: { name, partner: { fantasy, cnpj, ... } } }
    final String partnerFantasy = (getJsonField(parceiroJson, r'''$.user.partner.fantasy''') ??
                                   getJsonField(parceiroJson, r'''$.user.partner.nomeFantasia''') ??
                                   getJsonField(parceiroJson, r'''$.partner.fantasy''') ??
                                   getJsonField(parceiroJson, r'''$.partner.nomeFantasia''') ??
                                   '').toString().trim();
    final String partnerRazao = (getJsonField(parceiroJson, r'''$.user.partner.razao''') ??
                                 getJsonField(parceiroJson, r'''$.user.partner.razaoSocial''') ??
                                 getJsonField(parceiroJson, r'''$.partner.razao''') ??
                                 getJsonField(parceiroJson, r'''$.partner.razaoSocial''') ??
                                 '').toString().trim();
    final String customerName = (getJsonField(parceiroJson, r'''$.user.name''') ??
                                 getJsonField(parceiroJson, r'''$.name'''))?.toString().trim() ?? '';

    final String partnerName = partnerFantasy.isNotEmpty
        ? partnerFantasy
        : (partnerRazao.isNotEmpty ? partnerRazao : (customerName.isNotEmpty ? customerName : 'Parceiro Credenciado'));

    final String partnerCnpj = (getJsonField(parceiroJson, r'''$.user.partner.cnpj''') ??
                                getJsonField(parceiroJson, r'''$.partner.cnpj''') ??
                                getJsonField(parceiroJson, r'''$.cnpj'''))?.toString().trim() ?? 'Não informado';

    final String partnerCity = (getJsonField(parceiroJson, r'''$.user.partner.city''') ??
                                getJsonField(parceiroJson, r'''$.partner.city''') ??
                                getJsonField(parceiroJson, r'''$.city'''))?.toString().trim() ?? '';
    final String partnerState = (getJsonField(parceiroJson, r'''$.user.partner.state''') ??
                                 getJsonField(parceiroJson, r'''$.partner.state''') ??
                                 getJsonField(parceiroJson, r'''$.state'''))?.toString().trim() ?? '';

    final String segmentName = (getJsonField(parceiroJson, r'''$.user.partner.segment.name''') ??
                                getJsonField(parceiroJson, r'''$.partner.segment.name''') ??
                                getJsonField(parceiroJson, r'''$.segment.name'''))?.toString().trim() ?? 'Gastronomia & Alimentação';

    final String contractUrl = (getJsonField(parceiroJson, r'''$.user.partner.contract''') ??
                                getJsonField(parceiroJson, r'''$.user.partner.contractUrl''') ??
                                getJsonField(parceiroJson, r'''$.partner.contract''') ??
                                getJsonField(parceiroJson, r'''$.partner.contractUrl''') ??
                                getJsonField(parceiroJson, r'''$.contract'''))?.toString().trim() ?? '';

    final bool hasValidContractUrl = contractUrl.isNotEmpty && contractUrl != 'null';

    return Material(
      color: Colors.transparent,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: theme.alternate,
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
                  width: 52.0,
                  height: 52.0,
                  decoration: BoxDecoration(
                    color: theme.secondary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: theme.secondary.withOpacity(0.3),
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    Icons.description_rounded,
                    color: theme.secondary,
                    size: 28.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Termo de Adesão & Parceria Comercial',
                        style: GoogleFonts.readexPro(
                          color: Colors.white,
                          fontSize: isDesktop ? 18.0 : 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Instrumento oficial de credenciamento junto ao Clube Procard',
                        style: GoogleFonts.readexPro(
                          color: theme.secondaryText,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
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
                        style: GoogleFonts.readexPro(
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
            Divider(color: theme.alternate, thickness: 1.0),
            const SizedBox(height: 20.0),

            // Informações Cadastrais da Unidade Parceira
            Text(
              'Dados Cadastrais do Estabelecimento',
              style: GoogleFonts.readexPro(
                color: theme.secondary,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12.0),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: theme.primary,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: theme.alternate,
                  width: 1.0,
                ),
              ),
              child: Wrap(
                spacing: 32.0,
                runSpacing: 18.0,
                children: [
                  _buildMetadataItem(
                    theme: theme,
                    label: 'Razão Social',
                    value: partnerRazao.isNotEmpty ? partnerRazao : partnerName,
                    icon: Icons.business_rounded,
                  ),
                  _buildMetadataItem(
                    theme: theme,
                    label: 'Nome Fantasia',
                    value: partnerName,
                    icon: Icons.storefront_rounded,
                  ),
                  _buildMetadataItem(
                    theme: theme,
                    label: 'CNPJ',
                    value: partnerCnpj,
                    icon: Icons.badge_outlined,
                  ),
                  _buildMetadataItem(
                    theme: theme,
                    label: 'Segmento',
                    value: segmentName,
                    icon: Icons.category_outlined,
                  ),
                  if (partnerCity.isNotEmpty)
                    _buildMetadataItem(
                      theme: theme,
                      label: 'Localidade',
                      value: partnerState.isNotEmpty ? '$partnerCity - $partnerState' : partnerCity,
                      icon: Icons.location_on_outlined,
                    ),
                  _buildMetadataItem(
                    theme: theme,
                    label: 'Status do Credenciamento',
                    value: 'Homologado & Ativo',
                    icon: Icons.verified_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24.0),

            // Diretrizes Operacionais da Parceria
            Text(
              'Diretrizes e Regras do Convênio',
              style: GoogleFonts.readexPro(
                color: theme.secondary,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12.0),

            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 650;
                final cards = [
                  _buildGuidelineCard(
                    theme: theme,
                    icon: Icons.qr_code_scanner_rounded,
                    title: 'Validação no Caixa',
                    description:
                        'A aplicação dos benefícios e descontos é feita mediante validação do código do cupom ou do CPF do associado no validador.',
                  ),
                  _buildGuidelineCard(
                    theme: theme,
                    icon: Icons.local_offer_outlined,
                    title: 'Controle de Promoções',
                    description:
                        'A unidade parceira gerencia livremente suas promoções, prazos e quantidades de cupons através da aba Meus Cupons.',
                  ),
                  _buildGuidelineCard(
                    theme: theme,
                    icon: Icons.support_agent_rounded,
                    title: 'Canal de Atendimento',
                    description:
                        'Dúvidas sobre o convênio, alterações cadastrais ou solicitações de banners são atendidas pelo suporte oficial Procard.',
                  ),
                ];

                if (isNarrow) {
                  return Column(
                    children: cards
                        .map((c) => Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: c,
                            ))
                        .toList(),
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 14.0),
                    Expanded(child: cards[1]),
                    const SizedBox(width: 14.0),
                    Expanded(child: cards[2]),
                  ],
                );
              },
            ),

            const SizedBox(height: 28.0),

            // Action Buttons
            Wrap(
              spacing: 16.0,
              runSpacing: 12.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Primary Action: Open/Download PDF
                FFButtonWidget(
                  onPressed: () async {
                    if (hasValidContractUrl) {
                      await launchURL(contractUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.info_outline_rounded, color: Colors.white, size: 20.0),
                              const SizedBox(width: 10.0),
                              const Expanded(
                                child: Text(
                                  'Contrato digital homologado no sistema. O documento em PDF está disponível junto à equipe Procard.',
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: const Color(0xFFD97706),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  text: 'Visualizar Contrato Digital (PDF)',
                  icon: const Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 20.0,
                  ),
                  options: FFButtonOptions(
                    height: 48.0,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    color: theme.secondary,
                    textStyle: GoogleFonts.readexPro(
                      color: theme.primary,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),

                // Secondary Action: Copy Link
                if (hasValidContractUrl)
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
                      color: theme.secondary,
                    ),
                    label: Text(
                      'Copiar Link Seguro',
                      style: GoogleFonts.readexPro(
                        color: theme.secondary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.secondary.withOpacity(0.5), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24.0),
            Divider(color: theme.alternate, thickness: 0.8),
            const SizedBox(height: 16.0),

            // Security note footer
            Row(
              children: [
                Icon(
                  Icons.verified_outlined,
                  color: theme.secondaryText,
                  size: 16.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Termo de credenciamento homologado e vinculado à conta do estabelecimento parceiro no Clube Procard.',
                    style: GoogleFonts.readexPro(
                      color: theme.secondaryText,
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

  Widget _buildGuidelineCard({
    required FlutterFlowTheme theme,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: theme.alternate,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.0, color: theme.secondary),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.readexPro(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: GoogleFonts.readexPro(
              color: theme.secondaryText,
              fontSize: 12.0,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem({
    required FlutterFlowTheme theme,
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34.0,
          height: 34.0,
          decoration: BoxDecoration(
            color: theme.secondary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(icon, size: 18.0, color: theme.secondary),
        ),
        const SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.readexPro(
                color: theme.secondaryText,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              value,
              style: GoogleFonts.readexPro(
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
                                descricao: 'Consulte os dados cadastrais da sua empresa e o termo de credenciamento oficial junto ao Clube Procard',
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
