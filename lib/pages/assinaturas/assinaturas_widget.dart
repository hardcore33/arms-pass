import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/backend/plans_and_subscriptions_service.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/menu/menu_widget.dart';
import '/components/modal_acao_assinatura/modal_acao_assinatura_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'assinaturas_model.dart';
export 'assinaturas_model.dart';

class AssinaturasWidget extends StatefulWidget {
  const AssinaturasWidget({super.key});

  static String routeName = 'Assinaturas';
  static String routePath = '/assinaturas';

  @override
  State<AssinaturasWidget> createState() => _AssinaturasWidgetState();
}

class _AssinaturasWidgetState extends State<AssinaturasWidget> {
  late AssinaturasModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PlansAndSubscriptionsService _service = PlansAndSubscriptionsService();

  int _paginaAtual = 1;
  static const int _itensPorPagina = 8;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AssinaturasModel());
    FFAppState().indexPage = 13;
    _service.initialize();
    _service.addListener(_onServiceUpdate);
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _onServiceUpdate() {
    if (mounted) safeSetState(() {});
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    _model.dispose();
    super.dispose();
  }

  String _mascararCpf(String cpf) {
    final digits = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 11) {
      return '***.${digits.substring(3, 6)}.${digits.substring(6, 9)}-**';
    }
    return cpf;
  }

  void _abrirModalAcao(SubscriptionMemberModel sub, TipoAcaoAssinatura acao) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ModalAcaoAssinaturaWidget(
        subscription: sub,
        tipoAcao: acao,
      ),
    );
    if (result == true) {
      safeSetState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final allSubs = _service.subscriptions;
    final allPlans = _service.plans;

    // Métricas
    final ativas = allSubs.where((s) => s.status == 'Ativa').length;
    final pendentes = allSubs.where((s) => s.status == 'Pendente de Pagamento').length;
    final vencidas = allSubs.where((s) => s.status == 'Vencida').length;
    final canceladas = allSubs.where((s) => s.status == 'Cancelada').length;
    final mrr = allSubs
        .where((s) => s.status == 'Ativa')
        .fold<double>(0.0, (acc, s) => acc + s.amountPaid);

    // Filtros e Busca
    final termoBusca = _model.searchController?.text.toLowerCase().trim() ?? '';
    final termoNumerico = termoBusca.replaceAll(RegExp(r'[^0-9]'), '');

    final filtrados = allSubs.where((sub) {
      // Filtro Status
      if (_model.statusFilter != 'Todos' && sub.status != _model.statusFilter) {
        return false;
      }
      // Filtro Plano
      if (_model.planFilter != 'Todos' && sub.planId != _model.planFilter) {
        return false;
      }
      // Filtro Texto
      if (termoBusca.isEmpty) return true;

      final nome = sub.userName.toLowerCase();
      final cpf = sub.userCpf.toLowerCase();
      final cpfNum = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      final email = sub.userEmail.toLowerCase();
      final plano = sub.planName.toLowerCase();

      return nome.contains(termoBusca) ||
          email.contains(termoBusca) ||
          plano.contains(termoBusca) ||
          (termoNumerico.isNotEmpty && cpfNum.contains(termoNumerico));
    }).toList();

    final totalItens = filtrados.length;
    final totalPaginas = (totalItens / _itensPorPagina).ceil().clamp(1, 9999);
    if (_paginaAtual > totalPaginas) _paginaAtual = totalPaginas;

    final startIndex = (_paginaAtual - 1) * _itensPorPagina;
    final endIndex = (startIndex + _itensPorPagina).clamp(0, totalItens);
    final itensPaginados = totalItens > 0 ? filtrados.sublist(startIndex, endIndex) : <SubscriptionMemberModel>[];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primary,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Barra Lateral
              Container(
                width: FFAppState().sidebarCollapsed
                    ? 80.0
                    : (MediaQuery.sizeOf(context).width * 0.22).clamp(220.0, 320.0),
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: BoxDecoration(
                  color: theme.secondary,
                ),
                child: wrapWithModel(
                  model: _model.menuModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const MenuWidget(activeIndex: 13),
                ),
              ),

              // Conteúdo Principal
              Expanded(
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: theme.primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 30.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderPaginaWidget(
                            titulo: 'Gestão de Assinaturas e Membros',
                            breadcrumb: 'Painel',
                            descricao: 'Acompanhe a base de membros Arms Pró, renovações, faturamentos e ações de suporte.',
                          ),

                          // Cards de Métricas
                          Row(
                            children: [
                              _buildMetricItem(
                                'Assinaturas Ativas',
                                '$ativas',
                                Icons.check_circle_rounded,
                                const Color(0xFF249689),
                                'Membros recorrentes',
                                theme,
                              ),
                              const SizedBox(width: 14),
                              _buildMetricItem(
                                'Pendentes',
                                '$pendentes',
                                Icons.hourglass_top_rounded,
                                const Color(0xFFE5A93B),
                                'Aguardando pagamento',
                                theme,
                              ),
                              const SizedBox(width: 14),
                              _buildMetricItem(
                                'Vencidas',
                                '$vencidas',
                                Icons.warning_amber_rounded,
                                const Color(0xFFE57373),
                                'Necessitam renovação',
                                theme,
                              ),
                              const SizedBox(width: 14),
                              _buildMetricItem(
                                'Receita em Assinaturas',
                                'R\$ ${mrr.toStringAsFixed(2).replaceAll('.', ',')}',
                                Icons.monetization_on_outlined,
                                theme.secondary,
                                'Base ativa estimada',
                                theme,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Container da Tabela com Filtros
                          Container(
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(color: theme.alternate, width: 1.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Barra de Ferramentas (Busca e Filtros)
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    children: [
                                      // Busca
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          height: 40,
                                          child: TextField(
                                            controller: _model.searchController,
                                            focusNode: _model.searchFocusNode,
                                            onChanged: (_) => EasyDebounce.debounce(
                                              'assinaturas_search',
                                              const Duration(milliseconds: 200),
                                              () => setState(() => _paginaAtual = 1),
                                            ),
                                            style: GoogleFonts.readexPro(fontSize: 12.5, color: theme.primaryText),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              hintText: 'Buscar por nome, CPF ou plano...',
                                              hintStyle: GoogleFonts.readexPro(
                                                fontSize: 12,
                                                color: theme.secondaryText.withValues(alpha: 0.7),
                                              ),
                                              prefixIcon: Icon(Icons.search, size: 16, color: theme.secondary),
                                              suffixIcon: (_model.searchController?.text.isNotEmpty ?? false)
                                                  ? IconButton(
                                                      icon: Icon(Icons.close, size: 14, color: theme.secondaryText),
                                                      onPressed: () {
                                                        _model.searchController?.clear();
                                                        setState(() => _paginaAtual = 1);
                                                      },
                                                    )
                                                  : null,
                                              filled: true,
                                              fillColor: theme.primaryBackground,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(color: theme.alternate),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(color: theme.alternate),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(color: theme.secondary, width: 1.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),

                                      // Filtro Status
                                      Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: theme.primaryBackground,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: theme.alternate),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _model.statusFilter,
                                            dropdownColor: theme.secondaryBackground,
                                            icon: Icon(Icons.filter_list_rounded, size: 16, color: theme.secondary),
                                            style: GoogleFonts.readexPro(fontSize: 12, color: theme.primaryText),
                                            items: const [
                                              DropdownMenuItem(value: 'Todos', child: Text('Status: Todos')),
                                              DropdownMenuItem(value: 'Ativa', child: Text('Status: Ativa')),
                                              DropdownMenuItem(value: 'Pendente de Pagamento', child: Text('Status: Pendente')),
                                              DropdownMenuItem(value: 'Vencida', child: Text('Status: Vencida')),
                                              DropdownMenuItem(value: 'Cancelada', child: Text('Status: Cancelada')),
                                            ],
                                            onChanged: (val) {
                                              if (val != null) {
                                                setState(() {
                                                  _model.statusFilter = val;
                                                  _paginaAtual = 1;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Filtro por Plano
                                      Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: theme.primaryBackground,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: theme.alternate),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _model.planFilter,
                                            dropdownColor: theme.secondaryBackground,
                                            icon: Icon(Icons.card_membership_rounded, size: 16, color: theme.secondary),
                                            style: GoogleFonts.readexPro(fontSize: 12, color: theme.primaryText),
                                            items: [
                                              const DropdownMenuItem(value: 'Todos', child: Text('Plano: Todos')),
                                              ...allPlans.map((p) => DropdownMenuItem(
                                                    value: p.id,
                                                    child: Text(p.name),
                                                  )),
                                            ],
                                            onChanged: (val) {
                                              if (val != null) {
                                                setState(() {
                                                  _model.planFilter = val;
                                                  _paginaAtual = 1;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Cabeçalho da Tabela
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: theme.primaryBackground,
                                    border: Border(
                                      top: BorderSide(color: theme.alternate, width: 1),
                                      bottom: BorderSide(color: theme.alternate, width: 1),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 3, child: _headerText('MEMBRO / USUÁRIO', theme)),
                                      Expanded(flex: 2, child: _headerText('CPF (LGPD)', theme)),
                                      Expanded(flex: 2, child: _headerText('PLANO CONTRATADO', theme)),
                                      Expanded(flex: 2, child: _headerText('INÍCIO', theme)),
                                      Expanded(flex: 2, child: _headerText('PRÓXIMA RENOVAÇÃO', theme)),
                                      Expanded(flex: 2, child: _headerText('STATUS', theme, align: TextAlign.center)),
                                      SizedBox(width: 120, child: Text('AÇÕES', textAlign: TextAlign.center, style: GoogleFonts.readexPro(fontWeight: FontWeight.w600, fontSize: 11.5, color: theme.secondaryText))),
                                    ],
                                  ),
                                ),

                                // Linhas da Tabela
                                if (itensPaginados.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.person_search_rounded, size: 40, color: theme.secondaryText.withValues(alpha: 0.4)),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Nenhum membro encontrado com os filtros selecionados.',
                                            style: GoogleFonts.readexPro(fontSize: 13, color: theme.secondaryText),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: itensPaginados.length,
                                    separatorBuilder: (_, __) => Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: theme.alternate,
                                    ),
                                    itemBuilder: (context, index) {
                                      final sub = itensPaginados[index];
                                      return _buildMemberRow(sub, theme);
                                    },
                                  ),

                                // Paginação
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: theme.alternate, width: 1),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        totalItens > 0
                                            ? 'Exibindo ${startIndex + 1}–$endIndex de $totalItens membros'
                                            : 'Nenhum registro',
                                        style: GoogleFonts.readexPro(fontSize: 12, color: theme.secondaryText),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.chevron_left_rounded),
                                            color: _paginaAtual > 1 ? theme.primary : theme.secondaryText.withValues(alpha: 0.3),
                                            onPressed: _paginaAtual > 1
                                                ? () => setState(() => _paginaAtual--)
                                                : null,
                                          ),
                                          Text(
                                            'Página $_paginaAtual de $totalPaginas',
                                            style: GoogleFonts.readexPro(fontSize: 12, fontWeight: FontWeight.w600, color: theme.primaryText),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.chevron_right_rounded),
                                            color: _paginaAtual < totalPaginas ? theme.primary : theme.secondaryText.withValues(alpha: 0.3),
                                            onPressed: _paginaAtual < totalPaginas
                                                ? () => setState(() => _paginaAtual++)
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerText(String text, FlutterFlowTheme theme, {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.readexPro(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: theme.secondaryText,
      ),
    );
  }

  Widget _buildMetricItem(String title, String value, IconData icon, Color color, String subtitle, FlutterFlowTheme theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.alternate, width: 1.0),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.readexPro(fontSize: 11.5, color: theme.secondaryText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryText),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.readexPro(fontSize: 10.5, color: theme.secondaryText.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberRow(SubscriptionMemberModel sub, FlutterFlowTheme theme) {
    Color statusColor;
    Color statusBg;
    IconData statusIcon;

    switch (sub.status) {
      case 'Ativa':
        statusColor = const Color(0xFF2E7D32);
        statusBg = const Color(0xFFE8F5E9);
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'Pendente de Pagamento':
        statusColor = const Color(0xFFF57F17);
        statusBg = const Color(0xFFFFF8E1);
        statusIcon = Icons.access_time_rounded;
        break;
      case 'Vencida':
        statusColor = const Color(0xFFC62828);
        statusBg = const Color(0xFFFFEBEE);
        statusIcon = Icons.warning_amber_rounded;
        break;
      default: // Cancelada
        statusColor = const Color(0xFF546E7A);
        statusBg = const Color(0xFFECEFF1);
        statusIcon = Icons.cancel_outlined;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Nome / Membro
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.secondary.withValues(alpha: 0.15),
                  child: Text(
                    sub.userName.isNotEmpty ? sub.userName[0].toUpperCase() : 'M',
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: theme.primary),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sub.userName,
                        style: GoogleFonts.readexPro(fontSize: 12.5, fontWeight: FontWeight.w600, color: theme.primaryText),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        sub.userEmail,
                        style: GoogleFonts.readexPro(fontSize: 11, color: theme.secondaryText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // CPF LGPD
          Expanded(
            flex: 2,
            child: Text(
              _mascararCpf(sub.userCpf),
              style: GoogleFonts.readexPro(fontSize: 12, color: theme.primaryText),
            ),
          ),

          // Plano
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: theme.alternate),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_rounded, size: 12, color: theme.secondary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        sub.planName,
                        style: GoogleFonts.readexPro(fontSize: 11, fontWeight: FontWeight.w600, color: theme.primaryText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Data Início
          Expanded(
            flex: 2,
            child: Text(
              dateTimeFormat('d/M/y', sub.startDate),
              style: GoogleFonts.readexPro(fontSize: 12, color: theme.secondaryText),
            ),
          ),

          // Próxima Renovação
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  dateTimeFormat('d/M/y', sub.nextBillingDate),
                  style: GoogleFonts.readexPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: sub.status == 'Vencida' ? const Color(0xFFC62828) : theme.primaryText,
                  ),
                ),
              ],
            ),
          ),

          // Status Badge
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        sub.status == 'Pendente de Pagamento' ? 'Pendente' : sub.status,
                        style: GoogleFonts.readexPro(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Ações (Cancelar, Renovar, Estornar)
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Renovar
                Tooltip(
                  message: 'Renovar manualmente',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => _abrirModalAcao(sub, TipoAcaoAssinatura.renovar),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.autorenew_rounded, size: 18, color: theme.secondary),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Cancelar
                Tooltip(
                  message: 'Cancelar plano',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => _abrirModalAcao(sub, TipoAcaoAssinatura.cancelar),
                    child: const Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.cancel_outlined, size: 18, color: Color(0xFFE57373)),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Estornar
                Tooltip(
                  message: 'Estornar pagamento',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => _abrirModalAcao(sub, TipoAcaoAssinatura.estornar),
                    child: const Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.currency_exchange_rounded, size: 18, color: Color(0xFFFFA726)),
                    ),
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
