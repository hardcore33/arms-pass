import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/api_manager.dart';
import '/components/box_grafico_cupons/box_grafico_cupons_widget.dart';
import '/components/box_indicadores/box_indicadores_widget.dart';
import '/components/box_indicadores_mobile/box_indicadores_mobile_widget.dart';
import '/components/menu_mobile/menu_mobile_widget.dart';
import '/components/menu_parceiro/menu_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/pages/cupons_parceiro/cupons_parceiro_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color(0xFF2C2C2C);
    final cardBgColor = const Color(0xFF1E1E1E);
    final highlightColor = FlutterFlowTheme.of(context).secondary;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar Menu
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
                              width: MediaQuery.sizeOf(context).width * 0.13,
                              height: MediaQuery.sizeOf(context).height * 0.1,
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
        partnerId: currentUserUid,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: isMobile ? 220.0 : 340.0,
            alignment: Alignment.center,
            child: SizedBox(
              width: 30.0,
              height: 30.0,
              child: SpinKitFadingFour(
                color: highlightColor,
                size: 30.0,
              ),
            ),
          );
        }

        final response = snapshot.data!;
        if (!response.succeeded) {
          return _buildDashboardError(
              context, cardBgColor, borderColor, highlightColor);
        }

        final jsonResponse = response.jsonBody;
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
                color: Colors.white,
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
    final descontosAplicados = castToType<double>(
            getJsonField(jsonResponse, r'''$.descontosAplicados''')) ??
        0.0;
    final cuponsUtilizados = castToType<double>(
            getJsonField(jsonResponse, r'''$.cuponsUtilizados''')) ??
        0.0;
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

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Metrics Containers
        Container(
          width: MediaQuery.sizeOf(context).width * 0.78,
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
                        icon: Icon(
                          Icons.shopping_cart,
                          color: FlutterFlowTheme.of(context).secondary,
                          size: 26.0,
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
                        icon: Icon(
                          Icons.discount_rounded,
                          color: FlutterFlowTheme.of(context).secondary,
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
                      icon: Icon(
                        Icons.receipt_long_rounded,
                        color: FlutterFlowTheme.of(context).secondary,
                        size: 24.0,
                      ),
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
                        icon: Icon(
                          Icons.people,
                          color: FlutterFlowTheme.of(context).secondary,
                          size: 26.0,
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
                        dado: (castToType<double>(getJsonField(
                                    jsonResponse, r'''$.trocaSolicitada''')) ??
                                0.0)
                            .toInt()
                            .toString(),
                        icon: Icon(
                          Icons.swap_horiz_rounded,
                          color: FlutterFlowTheme.of(context).secondary,
                          size: 26.0,
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
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.78,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
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
                  // Painel de Insights (produto mais resgatado, horário de
                  // pico e quem validou)
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
    final cuponsUtilizadosMobile = castToType<double>(
            getJsonField(jsonResponse, r'''$.cuponsUtilizados''')) ??
        0.0;
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
                            (castToType<double>(getJsonField(jsonResponse,
                                        r'''$.descontosAplicados''')) ??
                                    0.0)
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
                        dado: (castToType<double>(getJsonField(
                                    jsonResponse, r'''$.trocaSolicitada''')) ??
                                0.0)
                            .toInt()
                            .toString(),
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

  // Builder para o Painel de Últimas Validações de Hoje
  Widget _buildRecentValidationsPanel(
      BuildContext context, Color cardBg, Color border, Color highlight) {
    return FutureBuilder<ApiCallResponse>(
      future: GetHistoricoRecenteCall.call(
        partnerId: int.tryParse(currentUserUid),
      ),
      builder: (context, snapshot) {
        final List<dynamic> validations = [];
        if (snapshot.hasData && snapshot.data!.succeeded) {
          validations.addAll((snapshot.data!.jsonBody as List?) ?? []);
        }

        return Material(
          color: Colors.transparent,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                FlutterFlowTheme.of(context).designToken.radius.md),
          ),
          child: Container(
            height: 290.0,
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
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          FlutterFlowTheme.of(context).designToken.radius.md),
                      topRight: Radius.circular(
                          FlutterFlowTheme.of(context).designToken.radius.md),
                    ),
                    border: Border(bottom: BorderSide(color: border)),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                      vertical: 14.0),
                  child: Row(
                    children: [
                      Icon(Icons.history_rounded, color: highlight, size: 18.0),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Últimas Validações de Hoje',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // Lista de Itens
                Expanded(
                  child: validations.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(FlutterFlowTheme.of(context)
                                .designToken
                                .spacing
                                .md),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.qr_code_scanner_rounded,
                                    color: Colors.grey, size: 28.0),
                                const SizedBox(height: 10.0),
                                const Text(
                                  'Nenhuma validação hoje',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13.0),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Valide o primeiro cupom de um cliente para começar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey.withOpacity(0.7),
                                      fontSize: 11.0),
                                ),
                                const SizedBox(height: 12.0),
                                InkWell(
                                  onTap: () => context.pushNamed(
                                      ValidarParceiroWidget.routeName),
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
                                      'Ir para Validar',
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
                          itemCount:
                              validations.length > 4 ? 4 : validations.length,
                          separatorBuilder: (context, index) =>
                              Divider(color: border, height: 16.0),
                          itemBuilder: (context, index) {
                            final item = validations[index];
                            final customerName =
                                getJsonField(item, r'''$.customer.name''')
                                        ?.toString() ??
                                    'Cliente';
                            final productName =
                                getJsonField(item, r'''$.product.name''')
                                        ?.toString() ??
                                    'Benefício';
                            final rawVal = getJsonField(item, r'''$.value''') ??
                                getJsonField(item, r'''$.valorPagar''');

                            double? parsedVal;
                            if (rawVal != null) {
                              if (rawVal is num)
                                parsedVal = rawVal.toDouble();
                              else if (rawVal is String)
                                parsedVal = double.tryParse(rawVal);
                            }
                            final formattedVal = parsedVal != null
                                ? 'R\$ ' +
                                    parsedVal
                                        .toStringAsFixed(2)
                                        .replaceAll('.', ',')
                                : 'R\$ 0,00';

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                        Icons.check_circle_outline_rounded,
                                        color: Color(0xFF00C853),
                                        size: 16.0),
                                    const SizedBox(width: 10.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          customerName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.0),
                                        ),
                                        Text(
                                          productName,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11.0),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  formattedVal,
                                  style: TextStyle(
                                      color: highlight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0),
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

  // Builder para o Painel de Promoções em Destaque
  Widget _buildPromoPanel(
      BuildContext context, Color cardBg, Color border, Color highlight) {
    return FutureBuilder<ApiCallResponse>(
      future: ObterCuponsDoParceiroCall.call(
        partnerId: currentUserUid,
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
            height: 290.0,
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
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          FlutterFlowTheme.of(context).designToken.radius.md),
                      topRight: Radius.circular(
                          FlutterFlowTheme.of(context).designToken.radius.md),
                    ),
                    border: Border(bottom: BorderSide(color: border)),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                      vertical: 14.0),
                  child: Row(
                    children: [
                      Icon(Icons.local_offer_rounded,
                          color: highlight, size: 18.0),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Promoções em Destaque',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
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
                                        description,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.0),
                                      ),
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
    return FutureBuilder<ApiCallResponse>(
      future: GetHistoricoRecenteCall.call(
        partnerId: int.tryParse(currentUserUid),
      ),
      builder: (context, snapshot) {
        final List<dynamic> validations = [];
        if (snapshot.hasData && snapshot.data!.succeeded) {
          validations.addAll((snapshot.data!.jsonBody as List?) ?? []);
        }

        // Produto/benefício mais resgatado no período — calculável hoje com
        // os dados que já chegam em GetHistoricoRecenteCall.
        String? topProduct;
        var topProductCount = 0;
        if (validations.isNotEmpty) {
          final counts = <String, int>{};
          for (final item in validations) {
            final name =
                getJsonField(item, r'''$.product.name''')?.toString();
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

        // Horário de pico de validações — precisa de um campo de data/hora
        // por item. Tenta alguns nomes candidatos; se nenhum vier
        // preenchido, mostramos que o dado ainda não está disponível.
        final hourCounts = <int, int>{};
        for (final item in validations) {
          final rawDate = _firstJsonField(item, [
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
          if (parsed == null) continue;
          hourCounts[parsed.hour] = (hourCounts[parsed.hour] ?? 0) + 1;
        }
        int? peakHour;
        var peakHourCount = 0;
        hourCounts.forEach((hour, count) {
          if (count > peakHourCount) {
            peakHour = hour;
            peakHourCount = count;
          }
        });

        // Quem mais validou — precisa de um campo de operador/atendente por
        // item, que também ainda não foi confirmado com o backend.
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
            height: 290.0,
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
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          FlutterFlowTheme.of(context).designToken.radius.md),
                      topRight: Radius.circular(
                          FlutterFlowTheme.of(context).designToken.radius.md),
                    ),
                    border: Border(bottom: BorderSide(color: border)),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                      vertical: 14.0),
                  child: Row(
                    children: [
                      Icon(Icons.insights_rounded,
                          color: highlight, size: 18.0),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Insights do Dia',
                        style: TextStyle(
                          color: Colors.white,
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

  // Linha do painel de Insights. Quando `value` é null, o dado depende de um
  // campo que o backend ainda não confirmou — mostra um aviso discreto em
  // vez de esconder a linha ou inventar um valor.
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
          Icon(icon, color: highlight, size: 16.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 11.0),
                ),
                const SizedBox(height: 2.0),
                Text(
                  value ?? 'Aguardando dado do backend',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: value != null
                        ? Colors.white
                        : Colors.grey.withOpacity(0.6),
                    fontWeight:
                        value != null ? FontWeight.bold : FontWeight.normal,
                    fontStyle:
                        value != null ? FontStyle.normal : FontStyle.italic,
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
