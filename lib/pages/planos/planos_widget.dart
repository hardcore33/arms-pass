import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/backend/plans_and_subscriptions_service.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/menu/menu_widget.dart';
import '/components/modal_plano/modal_plano_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'planos_model.dart';
export 'planos_model.dart';

class PlanosWidget extends StatefulWidget {
  const PlanosWidget({super.key});

  static String routeName = 'Planos';
  static String routePath = '/planos';

  @override
  State<PlanosWidget> createState() => _PlanosWidgetState();
}

class _PlanosWidgetState extends State<PlanosWidget> {
  late PlanosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PlansAndSubscriptionsService _plansService = PlansAndSubscriptionsService();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlanosModel());
    FFAppState().indexPage = 12;
    _plansService.initialize();
    _plansService.addListener(_onServiceUpdate);
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _onServiceUpdate() {
    if (mounted) safeSetState(() {});
  }

  @override
  void dispose() {
    _plansService.removeListener(_onServiceUpdate);
    _model.dispose();
    super.dispose();
  }

  void _abrirModalPlano([PlanModel? plano]) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => ModalPlanoWidget(planoToEdit: plano),
    );
    if (result == true) {
      safeSetState(() {});
    }
  }

  void _confirmarExclusao(PlanModel plano) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF14120E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFF2C2820)),
        ),
        title: Text(
          'Excluir Plano',
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Tem certeza que deseja excluir o plano "${plano.name}"? Membros já inscritos continuarão com seu histórico.',
          style: GoogleFonts.readexPro(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: GoogleFonts.readexPro(color: Colors.white60),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE57373),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await _plansService.deletePlan(plano.id);
              if (mounted) {
                showSuccessToast(context, 'Plano excluído com sucesso!');
              }
            },
            child: Text('Excluir', style: GoogleFonts.readexPro(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final plans = _plansService.plans;
    final totalAtivos = plans.where((p) => p.isActive).length;
    final totalParceirosVinculados = plans.fold<int>(0, (sum, p) => sum + p.eligiblePartnerIds.length);

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
              // Barra Lateral de Navegação
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
                  child: const MenuWidget(activeIndex: 12),
                ),
              ),

              // Área de Conteúdo Principal
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
                          HeaderPaginaWidget(
                            titulo: 'Gestão de Planos Arms Pró',
                            breadcrumb: 'Painel',
                            descricao: 'Cadastre e gerencie planos, precificação, tags promocionais e rede de parceiros credenciados.',
                            action: ElevatedButton.icon(
                              onPressed: () => _abrirModalPlano(),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: Text(
                                'Novo Plano',
                                style: GoogleFonts.readexPro(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.secondary,
                                foregroundColor: const Color(0xFF14120E),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 3,
                              ),
                            ),
                          ),

                          // Cards de Resumo
                          Row(
                            children: [
                              _buildMetricCard(
                                title: 'Total de Planos',
                                value: '${plans.length}',
                                icon: Icons.workspace_premium_rounded,
                                color: theme.secondary,
                                subtitle: 'Configurados no catálogo',
                                theme: theme,
                              ),
                              const SizedBox(width: 16),
                              _buildMetricCard(
                                title: 'Planos Ativos',
                                value: '$totalAtivos',
                                icon: Icons.check_circle_rounded,
                                color: const Color(0xFF249689),
                                subtitle: 'Disponíveis para contratação',
                                theme: theme,
                              ),
                              const SizedBox(width: 16),
                              _buildMetricCard(
                                title: 'Vínculos de Parceiros',
                                value: '$totalParceirosVinculados',
                                icon: Icons.handshake_rounded,
                                color: const Color(0xFFE5A93B),
                                subtitle: 'Pontos de rede credenciada',
                                theme: theme,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Grid dos Planos
                          if (plans.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: theme.secondaryBackground,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: theme.alternate, width: 1.0),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.inventory_2_outlined, size: 48, color: theme.secondary.withValues(alpha: 0.5)),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Nenhum plano cadastrado no momento.',
                                      style: GoogleFonts.outfit(fontSize: 16, color: theme.primaryText),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Clique no botão "Novo Plano" para criar seu primeiro plano Arms Pró.',
                                      style: GoogleFonts.readexPro(fontSize: 13, color: theme.secondaryText),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth > 900;
                                final crossAxisCount = isWide ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
                                return Wrap(
                                  spacing: 20,
                                  runSpacing: 20,
                                  children: plans.map((plano) {
                                    final cardWidth = (constraints.maxWidth - (crossAxisCount - 1) * 20) / crossAxisCount;
                                    return SizedBox(
                                      width: cardWidth,
                                      child: _buildPlanCard(plano, theme),
                                    );
                                  }).toList(),
                                );
                              },
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

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
    required FlutterFlowTheme theme,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.alternate, width: 1.0),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.readexPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.readexPro(
                      fontSize: 10.5,
                      color: theme.secondaryText.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(PlanModel plano, FlutterFlowTheme theme) {
    final isPopular = plano.highlightTag?.toLowerCase().contains('popular') == true;

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? theme.secondary : theme.alternate,
          width: isPopular ? 1.8 : 1.0,
        ),
        boxShadow: isPopular
            ? [
                BoxShadow(
                  color: theme.secondary.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topo do Card com Tag Promocional e Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: isPopular ? theme.secondary.withValues(alpha: 0.10) : theme.primaryBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              border: Border(
                bottom: BorderSide(color: theme.alternate, width: 1.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (plano.highlightTag != null && plano.highlightTag!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPopular ? theme.secondary : theme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.stars_rounded,
                          size: 13,
                          color: isPopular ? const Color(0xFF14120E) : theme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          plano.highlightTag!,
                          style: GoogleFonts.readexPro(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: isPopular ? const Color(0xFF14120E) : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: plano.isActive ? const Color(0xFF249689) : const Color(0xFFE57373),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      plano.isActive ? 'Ativo' : 'Inativo',
                      style: GoogleFonts.readexPro(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: plano.isActive ? const Color(0xFF249689) : const Color(0xFFE57373),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Informações do Plano
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plano.name,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'R\$ ${plano.price.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: theme.secondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '/${plano.billingCycle.toLowerCase()}',
                      style: GoogleFonts.readexPro(
                        fontSize: 12,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Lista de Benefícios
                Text(
                  'BENEFÍCIOS INCLUSOS:',
                  style: GoogleFonts.readexPro(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: theme.secondaryText,
                  ),
                ),
                const SizedBox(height: 8),
                ...plano.benefits.take(5).map((beneficio) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 14, color: const Color(0xFF249689)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            beneficio,
                            style: GoogleFonts.readexPro(
                              fontSize: 12,
                              color: theme.primaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                if (plano.benefits.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '+ mais ${plano.benefits.length - 5} benefícios...',
                      style: GoogleFonts.readexPro(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: theme.secondary,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),
                Divider(color: theme.alternate, height: 1),
                const SizedBox(height: 12),

                // Parceiros Elegíveis
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storefront_outlined, size: 16, color: theme.secondary),
                        const SizedBox(width: 6),
                        Text(
                          '${plano.eligiblePartnerIds.length} parceiros credenciados',
                          style: GoogleFonts.readexPro(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: theme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: plano.isActive,
                      activeColor: theme.secondary,
                      activeTrackColor: theme.secondary.withValues(alpha: 0.3),
                      inactiveThumbColor: theme.secondaryText.withValues(alpha: 0.4),
                      inactiveTrackColor: theme.alternate,
                      onChanged: (_) async {
                        await _plansService.togglePlanStatus(plano.id);
                        if (mounted) {
                          showSuccessToast(
                            context,
                            plano.isActive ? 'Plano pausado.' : 'Plano ativado!',
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Ações do Card
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _abrirModalPlano(plano),
                        icon: const Icon(Icons.edit_outlined, size: 14),
                        label: Text('Editar', style: GoogleFonts.readexPro(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.primaryText,
                          backgroundColor: theme.primaryBackground,
                          side: BorderSide(color: theme.alternate),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFE57373)),
                      onPressed: () => _confirmarExclusao(plano),
                      tooltip: 'Excluir plano',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
