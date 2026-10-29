import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/api_manager.dart';
import '/components/box_grafico_cupons/box_grafico_cupons_widget.dart';
import '/components/box_indicadores/box_indicadores_widget.dart';
import '/components/box_indicadores_mobile/box_indicadores_mobile_widget.dart';
import '/components/menu_mobile/menu_mobile_widget.dart';
import '/components/menu_parceiro/menu_parceiro_widget.dart';
import '/components/modal_adicionar_desconto_parceiro/modal_adicionar_desconto_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/pages/cupons_parceiro/cupons_parceiro_widget.dart';
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
import '/pages/validar_parceiro/validar_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import 'dashboard_parceiro_model.dart';
export 'dashboard_parceiro_model.dart';

class DashboardParceiroWidget extends StatefulWidget {
  const DashboardParceiroWidget({super.key});

  static String routeName = 'Dashboard_Parceiro';
  static String routePath = '/partner/dashboard';

  @override
  State<DashboardParceiroWidget> createState() =>
      _DashboardParceiroWidgetState();
}

class _DashboardParceiroWidgetState extends State<DashboardParceiroWidget> {
  late DashboardParceiroModel _model;
  int _selectedValidationTab = 0; // 0: Validados no Caixa, 1: Resgatados no App

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardParceiroModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  String get _effectiveCustomerId {
    final parceiroJson = FFAppState().parceiro;
    final customerId = getJsonField(parceiroJson, r'$.id') ??
                       getJsonField(parceiroJson, r'$.user.id');
    if (customerId != null && customerId.toString().isNotEmpty && customerId.toString() != 'null') {
      return customerId.toString();
    }
    if (currentUserUid.isNotEmpty) {
      return currentUserUid;
    }
    return '';
  }

  String get _effectivePartnerId {
    final parceiroJson = FFAppState().parceiro;
    final partnerIdDynamic = getJsonField(parceiroJson, r'$.partner.id') ??
                             getJsonField(parceiroJson, r'$.user.partner.id');
    if (partnerIdDynamic != null && partnerIdDynamic.toString().isNotEmpty && partnerIdDynamic.toString() != 'null') {
      return partnerIdDynamic.toString();
    }
    final customerId = getJsonField(parceiroJson, r'$.id');
    if (customerId != null && customerId.toString().isNotEmpty && customerId.toString() != 'null') {
      return customerId.toString();
    }
    return currentUserUid;
  }

  void _refreshDashboard() {
    ApiManager.clearCache('obterDashboardParceiro');
    ApiManager.clearCache('obterCuponsDoParceiro');
    safeSetState(() {});
  }

  // Tenta ler o primeiro campo existente dentre vários nomes candidatos.
  // Usado para os dados que ainda não têm um nome de campo confirmado com o
  // backend (variação percentual, horário da validação, quem validou).
  dynamic _firstJsonField(dynamic json, List<String> jsonPaths) {
    for (final path in jsonPaths) {
      final value = getJsonField(json, path);
      if (value != null) return value;
    }
    return null;
  }

  // Calcula a variação percentual em relação a um valor de período anterior,
  // se o backend já estiver retornando algum dos campos candidatos. Retorna
  // null (badge não é exibido) se nenhum campo candidato existir na resposta.
  String? _calcTrend(
      dynamic jsonResponse, List<String> previousFieldCandidates, double current) {
    final previous =
        castToType<double>(_firstJsonField(jsonResponse, previousFieldCandidates));
    if (previous == null || previous == 0) return null;
    final diff = ((current - previous) / previous) * 100;
    final sign = diff >= 0 ? '+' : '';
    return '$sign${diff.toStringAsFixed(1).replaceAll('.', ',')}% vs período anterior';
  }

  double _extractCuponsUtilizados(dynamic jsonResponse) {
    double val = castToType<double>(getJsonField(jsonResponse, r'''$.cuponsUtilizados''')) ?? 0.0;
    if (val > 0) return val;
    final compraAnual = getJsonField(jsonResponse, r'''$.compraAnual''');
    if (compraAnual is List && compraAnual.isNotEmpty) {
      double sum = 0.0;
      for (final item in compraAnual) {
        sum += castToType<double>(getJsonField(item, r'''$.valor''')) ?? 0.0;
      }
      if (sum > 0) return sum;
    }
    final compraMensal = getJsonField(jsonResponse, r'''$.compraMensal''');
    if (compraMensal is List && compraMensal.isNotEmpty) {
      double sum = 0.0;
      for (final item in compraMensal) {
        sum += castToType<double>(getJsonField(item, r'''$.valor''')) ?? 0.0;
      }
      if (sum > 0) return sum;
    }
    final qtdCompras = castToType<double>(getJsonField(jsonResponse, r'''$.qtdUsuariosComprasPeriodo''')) ?? 0.0;
    if (qtdCompras > 0) return qtdCompras;
    return 0.0;
  }

  double _extractTrocasSolicitadas(dynamic jsonResponse) {
    double val = castToType<double>(getJsonField(jsonResponse, r'''$.trocaSolicitada''')) ?? 0.0;
    if (val > 0) return val;
    final trocaAnual = getJsonField(jsonResponse, r'''$.trocaAnual''');
    if (trocaAnual is List && trocaAnual.isNotEmpty) {
      double sum = 0.0;
      for (final item in trocaAnual) {
        sum += castToType<double>(getJsonField(item, r'''$.valor''')) ?? 0.0;
      }
      if (sum > 0) return sum;
    }
    final trocaMensal = getJsonField(jsonResponse, r'''$.trocaMensal''');
    if (trocaMensal is List && trocaMensal.isNotEmpty) {
      double sum = 0.0;
      for (final item in trocaMensal) {
        sum += castToType<double>(getJsonField(item, r'''$.valor''')) ?? 0.0;
      }
      if (sum > 0) return sum;
    }
    return 0.0;
  }

  double _extractDescontosAplicados(dynamic jsonResponse, double totalVendas) {
    double val = castToType<double>(getJsonField(jsonResponse, r'''$.descontosAplicados''')) ?? 0.0;
    if (val > 0) return val;
    final parceiroJson = FFAppState().parceiro;
    final walletSaving = castToType<double>(getJsonField(parceiroJson, r'''$.wallet.totalSavings'''));
    if (walletSaving != null && walletSaving > 0) {
      return walletSaving;
    }
    if (totalVendas > 0) {
      return totalVendas * 0.10;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    const borderColor = Color(0xFFC5BCA8);
    const cardBgColor = Color(0xFFFAF7F2);
    const highlightColor = Color(0xFF8C8268);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFACA48D),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar Menu
                  Container(
                    width: FFAppState().sidebarCollapsed
                        ? 80.0
                        : (MediaQuery.sizeOf(context).width * 0.22).clamp(220.0, 320.0),
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    decoration: const BoxDecoration(
                      color: const Color(0xFFFAF7F2),
                      border: const Border(
                        right: BorderSide(color: Color(0xFFC5BCA8), width: 1.0),
                      ),
                    ),
                    child: wrapWithModel(
                      model: _model.menuParceiroModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const MenuParceiroWidget(),
                    ),
                  ),
                  // Dashboard Content Area
                  Expanded(
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 1.0,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 20.0, 24.0, 0.0),
                              child: HeaderPaginaWidget(
                                titulo: 'Painel do Parceiro',
                                breadcrumb: 'Parceiro',
                                descricao:
                                    'Bem-vindo de volta ao painel de indicadores da sua unidade',
                                action: Tooltip(
                                  message: 'Atualizar dados',
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(
                                        FlutterFlowTheme.of(context)
                                            .designToken
                                            .radius
                                            .full),
                                    onTap: _refreshDashboard,
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: cardBgColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: borderColor,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.refresh_rounded,
                                        color: highlightColor,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Bloco de indicadores + painéis operacionais.
                            // Isolado em seu próprio FutureBuilder para que o
                            // menu/sidebar e o cabeçalho nunca desapareçam
                            // durante o carregamento ou uma atualização.
                            _buildDashboardData(
                              context,
                              cardBgColor,
                              borderColor,
                              highlightColor,
                              isMobile: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            // Mobile Version (Simplificado)
            if (responsiveVisibility(
              context: context,
              desktop: false,
            ))
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        wrapWithModel(
                          model: _model.menuMobileModel,
                          updateCallback: () => safeSetState(() {}),
                          child: MenuMobileWidget(),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 30.0, 0.0, 0.0),
                          child: Text(
                            'Painel do Parceiro',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        // Bloco de indicadores + painéis operacionais.
                        _buildDashboardData(
                          context,
                          cardBgColor,
                          borderColor,
                          highlightColor,
                          isMobile: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Busca os dados do dashboard e renderiza indicadores + painéis
  // operacionais. Fica restrito à área de conteúdo: enquanto carrega (ou se
  // falhar) o menu, a sidebar e o cabeçalho continuam visíveis e a posição
  // de scroll não é perdida.
  Widget _buildDashboardData(
    BuildContext context,
    Color cardBgColor,
    Color borderColor,
    Color highlightColor, {
    required bool isMobile,
  }) {
    return FutureBuilder<ApiCallResponse>(
      future: ObterDashboardParceiroCall.call(
        partnerId: _effectiveCustomerId.isNotEmpty ? _effectiveCustomerId : _effectivePartnerId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingTableShimmerWidget(
            titulo: 'Métricas do Parceiro',
            rowCount: 4,
          );
        }

        final response = snapshot.data!;
        final jsonResponse = response.succeeded ? response.jsonBody : {};
        return isMobile
            ? _buildMobileMetrics(
                context, jsonResponse, cardBgColor, borderColor, highlightColor)
            : _buildDesktopMetrics(
                context, jsonResponse, cardBgColor, borderColor, highlightColor);
      },
    );
  }

  // Estado de erro do carregamento do dashboard, com opção de tentar de novo.
  Widget _buildDashboardError(BuildContext context, Color cardBgColor,
      Color borderColor, Color highlightColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(
              FlutterFlowTheme.of(context).designToken.radius.md),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, color: Colors.grey, size: 32.0),
            const SizedBox(height: 12.0),
            const Text(
              'Não foi possível carregar os dados do painel',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Verifique sua conexão e tente novamente',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 12.0),
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: _refreshDashboard,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: highlightColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: highlightColor.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, color: highlightColor, size: 16.0),
                    const SizedBox(width: 6.0),
                    Text(
                      'Tentar novamente',
                      style: TextStyle(
                        color: highlightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
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

  // Indicadores + painéis operacionais da versão Desktop.
  Widget _buildDesktopMetrics(BuildContext context, dynamic jsonResponse,
      Color cardBgColor, Color borderColor, Color highlightColor) {
    final totalVendas = castToType<double>(
            getJsonField(jsonResponse, r'''$.totalVendas''')) ??
        0.0;
    final cuponsUtilizados = _extractCuponsUtilizados(jsonResponse);
    final descontosAplicados = _extractDescontosAplicados(jsonResponse, totalVendas);
    final trocasSolicitadas = _extractTrocasSolicitadas(jsonResponse);
    // Ticket médio = total vendido / nº de validações do período.
    final ticketMedio =
        cuponsUtilizados > 0 ? totalVendas / cuponsUtilizados : 0.0;
    // Variação % só aparece se o backend já retornar algum desses campos —
    // ainda não confirmado com o backend, então o badge some sozinho até lá.
    final trendVendas = _calcTrend(
        jsonResponse,
        [
          r'''$.totalVendasAnterior''',
          r'''$.totalVendasOntem''',
          r'''$.totalVendasPeriodoAnterior''',
        ],
        totalVendas);
    final trendDescontos = _calcTrend(
        jsonResponse,
        [
          r'''$.descontosAplicadosAnterior''',
          r'''$.descontosAplicadosOntem''',
          r'''$.descontosAplicadosPeriodoAnterior''',
        ],
        descontosAplicados);

    // Dados do parceiro logado para o card de boas-vindas
    // O jsonBody do login tem estrutura { token, user: { name, partner: { ... } } }
    final parceiroJson = FFAppState().parceiro;
    final String partnerFantasy = (getJsonField(parceiroJson, r'$.user.partner.fantasy') ??
                                   getJsonField(parceiroJson, r'$.user.partner.nomeFantasia') ??
                                   getJsonField(parceiroJson, r'$.partner.fantasy') ??
                                   getJsonField(parceiroJson, r'$.partner.nomeFantasia') ??
                                   '').toString().trim();
    final String partnerRazao  = (getJsonField(parceiroJson, r'$.user.partner.razao') ??
                                  getJsonField(parceiroJson, r'$.user.partner.razaoSocial') ??
                                  getJsonField(parceiroJson, r'$.partner.razao') ??
                                  getJsonField(parceiroJson, r'$.partner.razaoSocial') ??
                                  '').toString().trim();
    final String customerName  = (getJsonField(parceiroJson, r'$.user.name') ??
                                  getJsonField(parceiroJson, r'$.name'))?.toString().trim() ?? '';
    final String partnerName   = partnerFantasy.isNotEmpty ? partnerFantasy
        : (partnerRazao.isNotEmpty ? partnerRazao
        : (customerName.isNotEmpty ? customerName : 'Parceiro Credenciado'));
    final String segmentName   = (getJsonField(parceiroJson, r'$.user.partner.segment.name') ??
                                  getJsonField(parceiroJson, r'$.partner.segment.name') ??
                                  getJsonField(parceiroJson, r'$.segment.name'))?.toString().trim() ?? '';
    final String partnerCity   = (getJsonField(parceiroJson, r'$.user.partner.city') ??
                                  getJsonField(parceiroJson, r'$.partner.city') ??
                                  getJsonField(parceiroJson, r'$.city'))?.toString().trim() ?? '';
    final String partnerState  = (getJsonField(parceiroJson, r'$.user.partner.state') ??
                                  getJsonField(parceiroJson, r'$.partner.state') ??
                                  getJsonField(parceiroJson, r'$.state'))?.toString().trim() ?? '';
    final String location      = [partnerCity, partnerState].where((s) => s.isNotEmpty).join(' – ');

    // Taxa de validação = cupons validados / (validados + não validados) — calculável localmente
    final cuponsValidados    = castToType<double>(getJsonField(jsonResponse, r'$.cuponsValidados')) ?? cuponsUtilizados;
    final cuponsAtivos       = castToType<double>(getJsonField(jsonResponse, r'$.cuponsAtivos')) ?? 0.0;
    final cuponsNaoValidados = castToType<double>(getJsonField(jsonResponse, r'$.cuponsNaoValidados')) ?? (cuponsAtivos > 0 ? cuponsAtivos : 0.0);
    final totalCupons        = cuponsValidados + cuponsNaoValidados;
    final taxaValidacao      = totalCupons > 0 ? (cuponsValidados / totalCupons * 100) : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Card de boas-vindas com dados do parceiro
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 0.0),
          child: Material(
            color: Colors.transparent,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  FlutterFlowTheme.of(context).designToken.radius.md),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(
                    FlutterFlowTheme.of(context).designToken.radius.md),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: highlightColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: highlightColor.withOpacity(0.4)),
                    ),
                    child: Icon(Icons.storefront_rounded,
                        color: highlightColor, size: 22.0),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partnerName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        if (segmentName.isNotEmpty || location.isNotEmpty) ...[
                          const SizedBox(height: 3.0),
                          Text(
                            [segmentName, location]
                                .where((s) => s.isNotEmpty)
                                .join('  •  '),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C853).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          color: const Color(0xFF00C853).withOpacity(0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7.0,
                          height: 7.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00C853),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        const Text(
                          'Conectado',
                          style: TextStyle(
                            color: Color(0xFF00C853),
                            fontWeight: FontWeight.bold,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        // Metrics Containers
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Row 1 (Financial Indicators - Highlighted)
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: wrapWithModel(
                      model: _model.boxIndicadoresModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: BoxIndicadoresWidget(
                        titulo: 'Total de vendas',
                        dado: 'R\$ ' +
                            totalVendas.toStringAsFixed(2).replaceAll('.', ','),
                        trend: trendVendas,
                        destaque: true,
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Color(0xFF059669),
                          size: 24.0,
                        ),
                        onTap: () =>
                            context.pushNamed(CuponsParceiroWidget.routeName),
                      ),
                    ),
                  ),
                  Expanded(
                    child: wrapWithModel(
                      model: _model.boxIndicadoresModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: BoxIndicadoresWidget(
                        titulo: 'Descontos aplicados',
                        dado: 'R\$ ' +
                            descontosAplicados
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                        trend: trendDescontos,
                        destaque: true,
                        icon: const Icon(
                          Icons.discount_outlined,
                          color: Color(0xFFD97706),
                          size: 24.0,
                        ),
                        onTap: () =>
                            context.pushNamed(CuponsParceiroWidget.routeName),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BoxIndicadoresWidget(
                      titulo: 'Ticket médio',
                      dado: 'R\$ ' +
                          ticketMedio.toStringAsFixed(2).replaceAll('.', ','),
                      icon: const Icon(
                        Icons.receipt_long_outlined,
                        color: Color(0xFF2563EB),
                        size: 24.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: BoxIndicadoresWidget(
                      titulo: 'Taxa de validação',
                      dado: '${taxaValidacao.toStringAsFixed(1).replaceAll('.', ',')}%',
                      icon: const Icon(
                        Icons.verified_outlined,
                        color: Color(0xFF7C3AED),
                        size: 24.0,
                      ),
                      onTap: () =>
                          context.pushNamed(ValidarParceiroWidget.routeName),
                    ),
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
              const SizedBox(height: 16.0),
              // Row 2 (Detailed KPI indicators + Coupons Donut)
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: wrapWithModel(
                      model: _model.boxIndicadoresModel3,
                      updateCallback: () => safeSetState(() {}),
                      child: BoxIndicadoresWidget(
                        titulo: 'Usuários ativos',
                        dado: (castToType<double>(getJsonField(
                                    jsonResponse, r'''$.usuariosAtivos''')) ??
                                0.0)
                            .toInt()
                            .toString(),
                        icon: const Icon(
                          Icons.group_outlined,
                          color: Color(0xFF0284C7),
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: wrapWithModel(
                      model: _model.boxIndicadoresModel4,
                      updateCallback: () => safeSetState(() {}),
                      child: BoxIndicadoresWidget(
                        titulo: 'Trocas solicitadas',
                        dado: trocasSolicitadas.toInt().toString(),
                        icon: const Icon(
                          Icons.swap_horizontal_circle_outlined,
                          color: Color(0xFF0D9488),
                          size: 24.0,
                        ),
                        onTap: () =>
                            context.pushNamed(ValidarParceiroWidget.routeName),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: BoxGraficoCuponsWidget(
                      json: jsonResponse,
                    ),
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
            ],
          ),
        ),
        // Bloco Operacional (Últimas Validações de Hoje e Minhas Promoções Ativas)
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 25.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Painel de Últimas Validações
                  Expanded(
                    child: _buildRecentValidationsPanel(
                        context, cardBgColor, borderColor, highlightColor),
                  ),
                  // Painel de Promoções em Destaque
                  Expanded(
                    child: _buildPromoPanel(
                        context, cardBgColor, borderColor, highlightColor),
                  ),
                  // Painel de Destaques Operacionais
                  Expanded(
                    child: _buildInsightsPanel(
                        context, cardBgColor, borderColor, highlightColor),
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Indicadores + painéis operacionais da versão Mobile — com paridade em
  // relação ao Desktop (todos os KPIs, o donut de cupons e os dois painéis
  // operacionais, empilhados verticalmente).
  Widget _buildMobileMetrics(BuildContext context, dynamic jsonResponse,
      Color cardBgColor, Color borderColor, Color highlightColor) {
    final totalVendasMobile = castToType<double>(
            getJsonField(jsonResponse, r'''$.totalVendas''')) ??
        0.0;
    final cuponsUtilizadosMobile = _extractCuponsUtilizados(jsonResponse);
    final descontosAplicadosMobile = _extractDescontosAplicados(jsonResponse, totalVendasMobile);
    final trocasSolicitadasMobile = _extractTrocasSolicitadas(jsonResponse);
    final ticketMedioMobile = cuponsUtilizadosMobile > 0
        ? totalVendasMobile / cuponsUtilizadosMobile
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: GestureDetector(
                    onTap: () =>
                        context.pushNamed(CuponsParceiroWidget.routeName),
                    child: wrapWithModel(
                      model: _model.boxIndicadoresMobileModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: BoxIndicadoresMobileWidget(
                        titulo: 'Total de vendas',
                        dado: 'R\$ ' +
                            (castToType<double>(getJsonField(
                                        jsonResponse, r'''$.totalVendas''')) ??
                                    0.0)
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                        icon: Icon(
                          Icons.shopping_cart,
                          color: FlutterFlowTheme.of(context).secondary,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: GestureDetector(
                    onTap: () =>
                        context.pushNamed(CuponsParceiroWidget.routeName),
                    child: wrapWithModel(
                      model: _model.boxIndicadoresMobileModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: BoxIndicadoresMobileWidget(
                        titulo: 'Descontos aplicados',
                        dado: 'R\$ ' +
                            descontosAplicadosMobile
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                        icon: Icon(
                          Icons.discount_rounded,
                          color: FlutterFlowTheme.of(context).secondary,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: wrapWithModel(
                    model: _model.boxIndicadoresMobileModel3,
                    updateCallback: () => safeSetState(() {}),
                    child: BoxIndicadoresMobileWidget(
                      titulo: 'Usuários ativos',
                      dado: (castToType<double>(getJsonField(
                                  jsonResponse, r'''$.usuariosAtivos''')) ??
                              0.0)
                          .toInt()
                          .toString(),
                      icon: Icon(
                        Icons.people,
                        color: FlutterFlowTheme.of(context).secondary,
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: GestureDetector(
                    onTap: () =>
                        context.pushNamed(ValidarParceiroWidget.routeName),
                    child: wrapWithModel(
                      model: _model.boxIndicadoresMobileModel4,
                      updateCallback: () => safeSetState(() {}),
                      child: BoxIndicadoresMobileWidget(
                        titulo: 'Trocas solicitadas',
                        dado: trocasSolicitadasMobile.toInt().toString(),
                        icon: Icon(
                          Icons.swap_horiz_rounded,
                          color: FlutterFlowTheme.of(context).secondary,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: BoxIndicadoresMobileWidget(
                    titulo: 'Ticket médio',
                    dado: 'R\$ ' +
                        ticketMedioMobile.toStringAsFixed(2).replaceAll('.', ','),
                    icon: Icon(
                      Icons.receipt_long_rounded,
                      color: FlutterFlowTheme.of(context).secondary,
                      size: 40.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Donut de proporção de cupons — mesmo componente do desktop.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: BoxGraficoCuponsWidget(
              json: jsonResponse,
            ),
          ),
        ),
        // Painéis operacionais empilhados (Últimas Validações e Promoções).
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: double.infinity,
                child: _buildRecentValidationsPanel(
                    context, cardBgColor, borderColor, highlightColor),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: _buildPromoPanel(
                    context, cardBgColor, borderColor, highlightColor),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: _buildInsightsPanel(
                    context, cardBgColor, borderColor, highlightColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Busca as validações e resgates da unidade parceira.
  // Carrega tanto do histórico recente quanto do histórico completo da unidade.
  Future<List<dynamic>> _fetchPartnerValidations() async {
    final List<dynamic> result = [];
    final Set<String> seenIds = {};

    try {
      final resRecente = await GetHistoricoRecenteCall.call(
        partnerId: int.tryParse(_effectivePartnerId),
      );
      if (resRecente.succeeded && resRecente.jsonBody is List) {
        for (final item in (resRecente.jsonBody as List)) {
          final idStr = getJsonField(item, r'''$.id''')?.toString() ?? '';
          if (idStr.isNotEmpty) seenIds.add(idStr);
          result.add(item);
        }
      }
    } catch (_) {}

    try {
      final resCompleto = await GetHistoricoCompletoCall.call();
      if (resCompleto.succeeded && resCompleto.jsonBody is List) {
        final partnerIdStr = _effectivePartnerId;
        final allList = (resCompleto.jsonBody as List).where((item) {
          final pId = getJsonField(item, r'''$.partner.id''')?.toString() ??
                      getJsonField(item, r'''$.partner''')?.toString();
          return pId == partnerIdStr;
        }).toList();

        allList.sort((a, b) {
          final idA = int.tryParse(getJsonField(a, r'''$.id''')?.toString() ?? '0') ?? 0;
          final idB = int.tryParse(getJsonField(b, r'''$.id''')?.toString() ?? '0') ?? 0;
          return idB.compareTo(idA);
        });

        for (final item in allList) {
          final idStr = getJsonField(item, r'''$.id''')?.toString() ?? '';
          if (idStr.isNotEmpty && seenIds.contains(idStr)) continue;
          if (idStr.isNotEmpty) seenIds.add(idStr);
          result.add(item);
        }
      }
    } catch (_) {}

    return result;
  }

  // Builder para o Painel de Validações e Cupons com Abas
  Widget _buildRecentValidationsPanel(
      BuildContext context, Color cardBg, Color border, Color highlight) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchPartnerValidations(),
      builder: (context, snapshot) {
        final allItems = snapshot.data ?? [];

        // Filtro 1: Validados no Caixa (compras efetivamente faturadas)
        final validados = allItems.where((item) {
          final desc = getJsonField(item, r'''$.description''')?.toString() ?? '';
          final isPoint = getJsonField(item, r'''$.is_point''') == true;
          final rawVal = getJsonField(item, r'''$.qtd_point''') ??
              getJsonField(item, r'''$.qtdPoint''') ??
              getJsonField(item, r'''$.total_saving''') ??
              getJsonField(item, r'''$.totalSaving''');
          double? pVal;
          if (rawVal is num) pVal = rawVal.toDouble();
          else if (rawVal is String) pVal = double.tryParse(rawVal);
          return desc.contains('Cupom validado') || isPoint || (pVal != null && pVal > 0);
        }).toList();

        // Filtro 2: Resgatados no App (cupons gerados no app aguardando compra)
        final resgatados = allItems.where((item) {
          final desc = getJsonField(item, r'''$.description''')?.toString() ?? '';
          final isPoint = getJsonField(item, r'''$.is_point''') == true;
          final rawVal = getJsonField(item, r'''$.qtd_point''') ??
              getJsonField(item, r'''$.qtdPoint''') ??
              getJsonField(item, r'''$.total_saving''') ??
              getJsonField(item, r'''$.totalSaving''');
          double? pVal;
          if (rawVal is num) pVal = rawVal.toDouble();
          else if (rawVal is String) pVal = double.tryParse(rawVal);
          return desc.contains('Desconto resgatado') || (!isPoint && (pVal == null || pVal == 0));
        }).toList();

        final currentList = _selectedValidationTab == 0 ? validados : resgatados;

        return Material(
          color: Colors.transparent,
          elevation: 0.0,
          child: Container(
            height: 330.0,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x080F172A),
                  blurRadius: 8.0,
                  offset: Offset(0, 2.0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header do Painel com Segmented Switcher
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: const Color(0xFFFAF7F2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    border: const Border(bottom: BorderSide(color: Color(0xFFC5BCA8))),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  child: Row(
                    children: [
                      const Text(
                        'Validações',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      const Spacer(),
                      // Tab 0: Validados no Caixa
                      InkWell(
                        onTap: () => safeSetState(() => _selectedValidationTab = 0),
                        borderRadius: BorderRadius.circular(20.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.5),
                          decoration: BoxDecoration(
                            color: _selectedValidationTab == 0
                                ? const Color(0xFFECFDF5)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: _selectedValidationTab == 0
                                  ? const Color(0xFFA7F3D0)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 12.0,
                                color: _selectedValidationTab == 0
                                    ? const Color(0xFF047857)
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                'No Caixa (${validados.length})',
                                style: TextStyle(
                                  color: _selectedValidationTab == 0
                                      ? const Color(0xFF047857)
                                      : const Color(0xFF64748B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      // Tab 1: Resgatados no App
                      InkWell(
                        onTap: () => safeSetState(() => _selectedValidationTab = 1),
                        borderRadius: BorderRadius.circular(20.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.5),
                          decoration: BoxDecoration(
                            color: _selectedValidationTab == 1
                                ? const Color(0xFFFEF3C7)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: _selectedValidationTab == 1
                                  ? const Color(0xFFFDE68A)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.phone_iphone_rounded,
                                size: 12.0,
                                color: _selectedValidationTab == 1
                                    ? const Color(0xFFB45309)
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                'No App (${resgatados.length})',
                                style: TextStyle(
                                  color: _selectedValidationTab == 1
                                      ? const Color(0xFFB45309)
                                      : const Color(0xFF64748B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Lista de Itens
                Expanded(
                  child: currentList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _selectedValidationTab == 0
                                      ? Icons.receipt_long_outlined
                                      : Icons.phone_iphone_rounded,
                                  color: const Color(0xFF94A3B8),
                                  size: 28.0,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  _selectedValidationTab == 0
                                      ? 'Nenhuma validação registrada hoje'
                                      : 'Nenhum cupom aguardando no app',
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  _selectedValidationTab == 0
                                      ? 'As compras validadas no caixa aparecerão aqui.'
                                      : 'Quando clientes gerarem cupom no celular, aparecerão aqui.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Scrollbar(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                            itemCount: currentList.length,
                            separatorBuilder: (context, index) =>
                                const Divider(color: Color(0xFFF1F5F9), height: 14.0),
                            itemBuilder: (context, index) {
                              final item = currentList[index];
                              final customerName =
                                  getJsonField(item, r"""$.customer.name""")
                                          ?.toString() ??
                                      getJsonField(item, r"""$.customer.cpf""")
                                          ?.toString() ??
                                      'Associado Procard';
                              final desc =
                                  getJsonField(item, r"""$.description""")?.toString() ?? '';
                              String displaySubtitle = _selectedValidationTab == 0
                                  ? 'Benefício Validado no Caixa'
                                  : 'Cupom resgatado no App Procard';
                              String? percentageDiscount;
                              if (desc.contains('Desconto resgatado:')) {
                                displaySubtitle = desc.replaceAll('Desconto resgatado:', '').trim();
                              } else if (desc.contains('Cupom validado')) {
                                displaySubtitle = 'Benefício Validado no Caixa';
                              } else if (desc.toLowerCase().contains('desconto')) {
                                final regMatch = RegExp(r'desconto:\s*(\d+)').firstMatch(desc);
                                if (regMatch != null) {
                                  percentageDiscount = '${regMatch.group(1)}% OFF';
                                  displaySubtitle = 'Cupom de ${regMatch.group(1)}% de Desconto';
                                }
                              }

                              final rawVal = getJsonField(item, r"""$.qtd_point""") ??
                                  getJsonField(item, r"""$.qtdPoint""") ??
                                  getJsonField(item, r"""$.total_saving""") ??
                                  getJsonField(item, r"""$.totalSaving""") ??
                                  getJsonField(item, r"""$.value""") ??
                                  getJsonField(item, r"""$.valorPagar""");

                              double? parsedVal;
                              if (rawVal != null) {
                                if (rawVal is num) {
                                  parsedVal = rawVal.toDouble();
                                } else if (rawVal is String) {
                                  parsedVal = double.tryParse(rawVal);
                                }
                              }

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28.0,
                                          height: 28.0,
                                          decoration: BoxDecoration(
                                            color: _selectedValidationTab == 0
                                                ? const Color(0xFFECFDF5)
                                                : const Color(0xFFFEF3C7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _selectedValidationTab == 0
                                                ? Icons.check_circle_rounded
                                                : Icons.phone_iphone_rounded,
                                            color: _selectedValidationTab == 0
                                                ? const Color(0xFF059669)
                                                : const Color(0xFFD97706),
                                            size: 16.0,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                customerName,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: Color(0xFF0F172A),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                              Text(
                                                displaySubtitle,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: Color(0xFF64748B),
                                                  fontSize: 11.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  if (_selectedValidationTab == 0)
                                    Text(
                                      (parsedVal != null && parsedVal > 0)
                                          ? 'R\$ ' +
                                              parsedVal
                                                  .toStringAsFixed(2)
                                                  .replaceAll('.', ',')
                                          : (percentageDiscount ?? 'Validado'),
                                      style: const TextStyle(
                                        color: Color(0xFF0F172A),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(12.0),
                                        border: Border.all(color: const Color(0xFFFDE68A)),
                                      ),
                                      child: Text(
                                        percentageDiscount ?? 'Aguardando no Caixa',
                                        style: const TextStyle(
                                          color: Color(0xFFB45309),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.5,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                ),
                // Rodapé com link para histórico completo
                InkWell(
                  onTap: () =>
                      context.pushNamed(ValidarParceiroWidget.routeName),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                      border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ver histórico completo',
                          style: TextStyle(
                            color: Color(0xFFD97706),
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(width: 6.0),
                        Icon(Icons.arrow_forward_rounded,
                            size: 14.0, color: Color(0xFFD97706)),
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

  // Builder para o Painel de Promoções em Destaque
  Widget _buildPromoPanel(
      BuildContext context, Color cardBg, Color border, Color highlight) {
    return FutureBuilder<ApiCallResponse>(
      future: ObterCuponsDoParceiroCall.call(
        partnerId: _effectiveCustomerId.isNotEmpty ? _effectiveCustomerId : _effectivePartnerId,
      ),
      builder: (context, snapshot) {
        final List<dynamic> promos = [];
        if (snapshot.hasData && snapshot.data!.succeeded) {
          promos.addAll((snapshot.data!.jsonBody as List?) ?? []);
        }

        return Material(
          color: Colors.transparent,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                FlutterFlowTheme.of(context).designToken.radius.md),
          ),
          child: Container(
            height: 330.0,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(
                  FlutterFlowTheme.of(context).designToken.radius.md),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header do Painel
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: const Color(0xFFFAF7F2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    border: const Border(bottom: BorderSide(color: Color(0xFFC5BCA8))),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 11.0),
                  child: Row(
                    children: [
                      Icon(Icons.local_offer_rounded,
                          color: highlight, size: 18.0),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Promoções em Destaque',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          final res = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) =>
                                ModalAdicionarDescontoParceiroWidget(
                              partnerId: _effectivePartnerId,
                            ),
                          );
                          if (res == true) {
                            safeSetState(() {});
                          }
                        },
                        borderRadius: BorderRadius.circular(6.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFA69E89), // Arms Pass Khaki Sand
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_rounded,
                                size: 15.0,
                                color: Color(0xFF121212),
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                'Nova Promoção',
                                style: TextStyle(
                                  color: Color(0xFF121212),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Lista de Itens
                Expanded(
                  child: promos.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(FlutterFlowTheme.of(context)
                                .designToken
                                .spacing
                                .md),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.local_offer_outlined,
                                    color: Colors.grey, size: 28.0),
                                const SizedBox(height: 10.0),
                                const Text(
                                  'Nenhuma promoção ativa',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13.0),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Cadastre seu primeiro desconto para atrair clientes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey.withOpacity(0.7),
                                      fontSize: 11.0),
                                ),
                                const SizedBox(height: 12.0),
                                InkWell(
                                  onTap: () => context.pushNamed(
                                      CuponsParceiroWidget.routeName),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: highlight.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                          color: highlight.withOpacity(0.4)),
                                    ),
                                    child: Text(
                                      'Cadastrar desconto',
                                      style: TextStyle(
                                        color: highlight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.all(FlutterFlowTheme.of(context)
                              .designToken
                              .spacing
                              .md),
                          itemCount: promos.length > 4 ? 4 : promos.length,
                          separatorBuilder: (context, index) =>
                              Divider(color: border, height: 16.0),
                          itemBuilder: (context, index) {
                            final item = promos[index];
                            final description =
                                getJsonField(item, r'''$.description''')
                                        ?.toString() ??
                                    'Desconto';
                            final discount =
                                getJsonField(item, r'''$.discount''')
                                        ?.toString() ??
                                    '0';
                            final validity =
                                getJsonField(item, r'''$.validity''')
                                        ?.toString() ??
                                    '';
                            final rules = (getJsonField(item, r'''$.rules''') ?? '').toString();

                            final isArmsPro = rules.contains('[ARMS_PRO]') || description.contains('[ARMS_PRO]');
                            final matchLimite = RegExp(r'\[LIMITE:(\d+)\]').firstMatch(rules) ?? RegExp(r'\[LIMITE:(\d+)\]').firstMatch(description);
                            final limiteStr = matchLimite != null ? matchLimite.group(1) : null;
                            final cleanDesc = description.replaceAll('[ARMS_PRO]', '').replaceAll(RegExp(r'\[LIMITE:\d+\]'), '').trim();

                            // Status do cupom derivado da data de validade
                            // (o backend não retorna um campo de status —
                            // "pausado" só será possível quando existir).
                            DateTime? validityDate;
                            try {
                              if (validity.isNotEmpty) {
                                validityDate = DateTime.parse(validity);
                              }
                            } catch (_) {}
                            final isExpired = validityDate != null &&
                                validityDate.isBefore(DateTime.now());
                            final statusLabel = validityDate == null
                                ? null
                                : (isExpired ? 'Expirado' : 'Ativo');
                            final statusColor = isExpired
                                ? const Color(0xFFFF5963)
                                : const Color(0xFF00C853);

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cleanDesc.isNotEmpty ? cleanDesc : 'Desconto',
                                        style: const TextStyle(
                                            color: Color(0xFF0F172A),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.0),
                                      ),
                                      if (isArmsPro || limiteStr != null) ...[
                                        const SizedBox(height: 3.0),
                                        Wrap(
                                          spacing: 4.0,
                                          runSpacing: 2.0,
                                          children: [
                                            if (isArmsPro)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5.0, vertical: 1.0),
                                                decoration: BoxDecoration(
                                                  color: const Color(0x25FFD700),
                                                  borderRadius: BorderRadius.circular(3.0),
                                                  border: Border.all(color: highlight, width: 0.6),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.star_rounded, color: highlight, size: 10.0),
                                                    const SizedBox(width: 2.0),
                                                    Text(
                                                      'Arms Pro VIP',
                                                      style: TextStyle(
                                                        color: highlight,
                                                        fontSize: 9.5,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (limiteStr != null)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5.0, vertical: 1.0),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEFECE4),
                                                  borderRadius: BorderRadius.circular(3.0),
                                                  border: Border.all(color: const Color(0xFFC5BCA8), width: 0.6),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.inventory_2_outlined, color: Color(0xFF524B3E), size: 9.0),
                                                    const SizedBox(width: 2.0),
                                                    Text(
                                                      'Estoque: $limiteStr un.',
                                                      style: const TextStyle(
                                                        color: Color(0xFF524B3E),
                                                        fontSize: 9.5,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                      const SizedBox(height: 3.0),
                                      Row(
                                        children: [
                                          Text(
                                            'Validade: ' +
                                                (functions
                                                        .formataDataDeExibicao(
                                                            validity) ??
                                                    ''),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11.0),
                                          ),
                                          if (statusLabel != null) ...[
                                            const SizedBox(width: 6.0),
                                            Container(
                                              width: 6.0,
                                              height: 6.0,
                                              decoration: BoxDecoration(
                                                color: statusColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 4.0),
                                            Text(
                                              statusLabel,
                                              style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11.0),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0x15FFD700),
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(
                                        color: highlight.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    '$discount %',
                                    style: TextStyle(
                                        color: highlight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Builder para o Painel de Insights do Dia: produto mais resgatado (já
  // calculável com os dados atuais), horário de pico e quem mais validou
  // (ambos dependem de campos que o backend ainda não confirmou — enquanto
  // não existirem, o painel avisa isso em vez de mostrar um valor falso).
  Widget _buildInsightsPanel(
      BuildContext context, Color cardBg, Color border, Color highlight) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchPartnerValidations(),
      builder: (context, snapshot) {
        final validations = snapshot.data ?? [];

        // Produto/benefício mais resgatado no período
        String? topProduct;
        var topProductCount = 0;
        if (validations.isNotEmpty) {
          final counts = <String, int>{};
          for (final item in validations) {
            var name = getJsonField(item, r'''$.product.name''')?.toString();
            if (name == null || name.isEmpty) {
              final desc = getJsonField(item, r'''$.description''')?.toString() ?? '';
              if (desc.toLowerCase().contains('desconto')) {
                name = 'Desconto Especial';
              } else if (desc.isNotEmpty) {
                name = 'Cupom de Benefício';
              }
            }
            if (name == null || name.isEmpty) continue;
            counts[name] = (counts[name] ?? 0) + 1;
          }
          counts.forEach((name, count) {
            if (count > topProductCount) {
              topProduct = name;
              topProductCount = count;
            }
          });
        }

        // Horário de pico de validações
        final hourCounts = <int, int>{};
        for (final item in validations) {
          final rawDate = _firstJsonField(item, [
            r'''$.data_point''',
            r'''$.date''',
            r'''$.data''',
            r'''$.dataHora''',
            r'''$.data_hora''',
            r'''$.createdAt''',
            r'''$.created_at''',
            r'''$.dataValidacao''',
            r'''$.horaValidacao''',
            r'''$.timestamp''',
          ]);
          if (rawDate == null) continue;
          final parsed = DateTime.tryParse(rawDate.toString());
          if (parsed != null) {
            hourCounts[parsed.hour] = (hourCounts[parsed.hour] ?? 0) + 1;
          } else {
            final match = RegExp(r'(\d{2}):(\d{2})').firstMatch(rawDate.toString());
            if (match != null) {
              final h = int.tryParse(match.group(1)!);
              if (h != null) {
                hourCounts[h] = (hourCounts[h] ?? 0) + 1;
              }
            }
          }
        }
        int? peakHour;
        var peakHourCount = 0;
        hourCounts.forEach((hour, count) {
          if (count > peakHourCount) {
            peakHour = hour;
            peakHourCount = count;
          }
        });

        // Quem mais validou
        final validatorCounts = <String, int>{};
        for (final item in validations) {
          final rawName = _firstJsonField(item, [
            r'''$.operator.name''',
            r'''$.employee.name''',
            r'''$.attendant.name''',
            r'''$.atendente.name''',
            r'''$.atendente''',
            r'''$.validadoPor''',
            r'''$.validated_by''',
            r'''$.funcionario.name''',
            r'''$.customer.name''',
          ]);
          final name = rawName?.toString();
          if (name == null || name.isEmpty) continue;
          validatorCounts[name] = (validatorCounts[name] ?? 0) + 1;
        }
        String? topValidator;
        var topValidatorCount = 0;
        validatorCounts.forEach((name, count) {
          if (count > topValidatorCount) {
            topValidator = name;
            topValidatorCount = count;
          }
        });

        return Material(
          color: Colors.transparent,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                FlutterFlowTheme.of(context).designToken.radius.md),
          ),
          child: Container(
            height: 330.0,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(
                  FlutterFlowTheme.of(context).designToken.radius.md),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header do Painel
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: const Color(0xFFFAF7F2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    border: const Border(bottom: BorderSide(color: Color(0xFFC5BCA8))),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                  child: Row(
                    children: [
                      Icon(Icons.query_stats_rounded,
                          color: highlight, size: 18.0),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Destaques Operacionais',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(
                        FlutterFlowTheme.of(context).designToken.spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInsightRow(
                          icon: Icons.local_fire_department_rounded,
                          label: 'Produto mais resgatado',
                          value: topProduct != null
                              ? '$topProduct ($topProductCount)'
                              : null,
                          highlight: highlight,
                        ),
                        _buildInsightRow(
                          icon: Icons.schedule_rounded,
                          label: 'Horário de pico',
                          value: peakHour != null
                              ? '${peakHour!.toString().padLeft(2, '0')}h às ${(peakHour! + 1).toString().padLeft(2, '0')}h'
                              : null,
                          highlight: highlight,
                        ),
                        _buildInsightRow(
                          icon: Icons.badge_rounded,
                          label: 'Quem mais validou',
                          value: topValidator != null
                              ? '$topValidator ($topValidatorCount)'
                              : null,
                          highlight: highlight,
                        ),
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

  // Linha do painel de Destaques Operacionais. Quando `value` é null,
  // o campo ainda não chegou do backend — exibe "–" de forma discreta
  // em vez de uma mensagem técnica visível ao usuário.
  Widget _buildInsightRow({
    required IconData icon,
    required String label,
    required String? value,
    required Color highlight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: value != null ? highlight : Colors.grey.withOpacity(0.5), size: 16.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 11.5),
                ),
                const SizedBox(height: 2.0),
                Text(
                  value ?? '—',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: value != null
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF94A3B8),
                    fontWeight:
                        value != null ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
