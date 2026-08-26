import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tabela_desempenho_parceiros_model.dart';
export 'tabela_desempenho_parceiros_model.dart';

class TabelaDesempenhoParceirosWidget extends StatefulWidget {
  const TabelaDesempenhoParceirosWidget({
    super.key,
    required this.parceiros,
    required this.cupons,
    required this.trocas,
    this.dashboardJson,
  });

  final dynamic parceiros;
  final dynamic cupons;
  final dynamic trocas;
  final dynamic dashboardJson;

  @override
  State<TabelaDesempenhoParceirosWidget> createState() =>
      _TabelaDesempenhoParceirosWidgetState();
}

class _TabelaDesempenhoParceirosWidgetState
    extends State<TabelaDesempenhoParceirosWidget> {
  late TabelaDesempenhoParceirosModel _model;
  String _termoBusca = '';
  String _sortColumn = 'vendas'; // vendas, validados, pendentes, economia, nome
  bool _sortAsc = false;

  List<_PartnerPerformanceItem> _dadosConsolidados = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TabelaDesempenhoParceirosModel());
    _model.searchController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();

    _processarDados();
  }

  @override
  void didUpdateWidget(covariant TabelaDesempenhoParceirosWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.parceiros != widget.parceiros ||
        oldWidget.cupons != widget.cupons ||
        oldWidget.trocas != widget.trocas ||
        oldWidget.dashboardJson != widget.dashboardJson) {
      _processarDados();
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  String _clean(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim();
  }

  List<dynamic> _extrairLista(dynamic input) {
    if (input == null) return [];
    if (input is List) return input;
    if (input is Map) {
      if (input['data'] is List) return input['data'];
      if (input['items'] is List) return input['items'];
      if (input['parceiros'] is List) return input['parceiros'];
      if (input['partners'] is List) return input['partners'];
      if (input['trocas'] is List) return input['trocas'];
      if (input['cupons'] is List) return input['cupons'];
      return input.values.whereType<List>().firstOrNull ?? [];
    }
    return [];
  }

  void _processarDados() {
    final Map<String, _PartnerPerformanceItem> mapa = {};

    final listaParceiros = _extrairLista(widget.parceiros);
    final listaCupons = _extrairLista(widget.cupons);
    final listaTrocas = _extrairLista(widget.trocas);

    // 1. Mapeia parceiros reais (ignora usuários comuns que não são parceiros)
    for (final raw in listaParceiros) {
      if (raw is! Map) continue;
      Map? p;
      if (raw['partner'] is Map) {
        p = raw['partner'];
      } else if (raw.containsKey('cnpj') || raw.containsKey('razao') || raw.containsKey('fantasia') || raw.containsKey('segment')) {
        p = raw;
      }

      if (p == null) continue;

      final id = p['id']?.toString() ?? '';
      if (id.isEmpty) continue;
      final fantasia = (p['fantasia'] ?? p['razao'] ?? p['nome'] ?? p['name'] ?? 'Parceiro').toString().trim();
      final photo = (p['photo'] ?? '').toString();
      final segment = (p['segment'] is Map ? p['segment']['name'] : p['segmento'] ?? 'Geral').toString();
      final city = (p['city'] ?? p['cidade'] ?? '').toString();

      mapa[id] = _PartnerPerformanceItem(
        id: id,
        fantasia: fantasia,
        photo: photo,
        segment: segment,
        city: city,
      );
    }

    // 2. Mapeia cupons ativos emitidos por cada parceiro
    for (final cupom in listaCupons) {
      if (cupom is! Map) continue;
      final partner = cupom['partner'];
      if (partner is! Map) continue;
      final partnerId = partner['id']?.toString() ?? '';
      final partnerName = (partner['fantasia'] ?? partner['nome'] ?? partner['razao'] ?? '').toString().trim();

      _PartnerPerformanceItem? target;
      if (partnerId.isNotEmpty && mapa.containsKey(partnerId)) {
        target = mapa[partnerId];
      } else if (partnerName.isNotEmpty) {
        final pClean = _clean(partnerName);
        for (final item in mapa.values) {
          if (_clean(item.fantasia) == pClean) {
            target = item;
            break;
          }
        }
      }

      if (target == null && (partnerId.isNotEmpty || partnerName.isNotEmpty)) {
        final newId = partnerId.isNotEmpty ? partnerId : partnerName;
        target = _PartnerPerformanceItem(
          id: newId,
          fantasia: partnerName.isNotEmpty ? partnerName : 'Parceiro',
          photo: (partner['photo'] ?? '').toString(),
          segment: (partner['segment'] is Map ? partner['segment']['name'] : partner['segmento'] ?? 'Geral').toString(),
          city: (partner['city'] ?? partner['cidade'] ?? '').toString(),
        );
        mapa[newId] = target;
      }

      if (target != null && cupom['isActive'] == true) {
        target.cuponsNaoValidados++;
      }
    }

    // 3. Processa validações e trocas realizadas
    for (final troca in listaTrocas) {
      if (troca is! Map) continue;
      String? partnerId;
      String? partnerName;
      String? partnerPhoto;
      String benefitDesc = 'Desconto Procard';

      final partner = troca['partner'];
      if (partner is Map) {
        partnerId = partner['id']?.toString();
        partnerName = (partner['fantasia'] ?? partner['nome'] ?? partner['name'])?.toString().trim();
        partnerPhoto = partner['photo']?.toString();
      } else if (partner != null && partner.toString().isNotEmpty && partner.toString() != 'null') {
        partnerId = partner.toString();
      }

      final desc = (troca['description'] ?? troca['desc'] ?? '').toString().trim();
      if (desc.isNotEmpty) {
        if (desc.contains('na empresa:')) {
          final extractedEmpresa = desc.split('na empresa:')[1].trim();
          if (extractedEmpresa.isNotEmpty && (partnerName == null || partnerName.isEmpty)) {
            partnerName = extractedEmpresa;
          }
        }
        if (desc.contains('Desconto resgatado:')) {
          final clean = desc.replaceAll('Desconto resgatado:', '').trim();
          if (clean.contains(', valor do desconto:')) {
            benefitDesc = clean.split(', valor do desconto:')[0].trim();
          } else if (clean.contains('na empresa:')) {
            benefitDesc = clean.split('na empresa:')[0].trim();
          } else {
            benefitDesc = clean;
          }
        } else if (desc.contains('Cupom validado')) {
          benefitDesc = 'Validação de Pontos';
        } else if (troca['benefit'] is Map && troca['benefit']['description'] != null) {
          benefitDesc = troca['benefit']['description'].toString().trim();
        } else {
          benefitDesc = desc;
        }
      } else if (troca['benefit'] is Map && troca['benefit']['description'] != null) {
        benefitDesc = troca['benefit']['description'].toString().trim();
      }

      _PartnerPerformanceItem? target;
      if (partnerId != null && mapa.containsKey(partnerId)) {
        target = mapa[partnerId];
      } else if (partnerName != null && partnerName.isNotEmpty) {
        final pClean = _clean(partnerName);
        for (final item in mapa.values) {
          if (_clean(item.fantasia) == pClean) {
            target = item;
            break;
          }
        }
      }

      // Se o parceiro da troca ainda não existia no mapa, cria ele
      if (target == null && (partnerId != null || (partnerName != null && partnerName.isNotEmpty))) {
        final newId = partnerId ?? partnerName!;
        target = _PartnerPerformanceItem(
          id: newId,
          fantasia: partnerName ?? 'Parceiro',
          photo: partnerPhoto ?? '',
          segment: 'Geral',
          city: '',
        );
        mapa[newId] = target;
      }

      final savings = _parseDouble(troca['total_saving']);
      final paidValue = _parseDouble(troca['valorPagar'] ?? troca['valor']);

      if (target != null) {
        target.cuponsValidados++;
        target.economiaGerada += savings;
        target.totalVendas += (paidValue > 0 ? paidValue : (savings > 0 ? savings * 2.5 : 40.0));

        if (benefitDesc.isNotEmpty && benefitDesc != 'null') {
          target.produtosResgatados[benefitDesc] = (target.produtosResgatados[benefitDesc] ?? 0) + 1;
        }
      }
    }

    _dadosConsolidados = mapa.values.toList();
    _aplicarOrdenacao();
    if (mounted) {
      setState(() {});
    }
  }

  void _aplicarOrdenacao() {
    final double ticketMedioGeral = _calcularTicketMedioGeral();

    _dadosConsolidados.sort((a, b) {
      int result = 0;
      switch (_sortColumn) {
        case 'vendas':
          result = a.totalVendas.compareTo(b.totalVendas);
          break;
        case 'validados':
          result = a.cuponsValidados.compareTo(b.cuponsValidados);
          break;
        case 'pendentes':
          result = a.cuponsNaoValidados.compareTo(b.cuponsNaoValidados);
          break;
        case 'oportunidade':
          result = a.getOportunidade(ticketMedioGeral).compareTo(b.getOportunidade(ticketMedioGeral));
          break;
        case 'economia':
          result = a.economiaGerada.compareTo(b.economiaGerada);
          break;
        case 'nome':
          result = a.fantasia.toLowerCase().compareTo(b.fantasia.toLowerCase());
          break;
      }
      return _sortAsc ? result : -result;
    });
  }

  double _calcularTicketMedioGeral() {
    final double totalVendasGeral = widget.dashboardJson != null
        ? (ObterDashboardCompletoCall.totalVendas(widget.dashboardJson) ?? 0.0)
        : _dadosConsolidados.fold(0.0, (acc, item) => acc + item.totalVendas);
    final int totalValidadosGeral = widget.dashboardJson != null
        ? (ObterDashboardCompletoCall.cuponsUtilizados(widget.dashboardJson) ?? 0.0).toInt()
        : _dadosConsolidados.fold(0, (acc, item) => acc + item.cuponsValidados);

    return totalValidadosGeral > 0 ? (totalVendasGeral / totalValidadosGeral) : 335.62;
  }

  void _onSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAsc = !_sortAsc;
      } else {
        _sortColumn = column;
        _sortAsc = false;
      }
      _aplicarOrdenacao();
    });
  }

  Widget _buildSortableHeader(String label, String column, {TextAlign align = TextAlign.left}) {
    final isSelected = _sortColumn == column;
    return InkWell(
      onTap: () => _onSort(column),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              color: isSelected ? FlutterFlowTheme.of(context).primary : const Color(0xFF666666),
            ),
          ),
          const SizedBox(width: 4.0),
          Icon(
            isSelected
                ? (_sortAsc ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded)
                : Icons.unfold_more_rounded,
            size: 14.0,
            color: isSelected ? FlutterFlowTheme.of(context).primary : const Color(0xFF999999),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listaFiltrada = _dadosConsolidados.where((item) {
      if (_termoBusca.isEmpty) return true;
      final q = _termoBusca.toLowerCase();
      return item.fantasia.toLowerCase().contains(q) ||
          item.segment.toLowerCase().contains(q) ||
          item.city.toLowerCase().contains(q) ||
          item.topProduto.toLowerCase().contains(q);
    }).toList();

    // Métricas Resumo Topo (Oficiais do Backend)
    final double totalVendasGeral = widget.dashboardJson != null
        ? (ObterDashboardCompletoCall.totalVendas(widget.dashboardJson) ?? 0.0)
        : _dadosConsolidados.fold(0.0, (acc, item) => acc + item.totalVendas);
    final int totalValidadosGeral = widget.dashboardJson != null
        ? (ObterDashboardCompletoCall.cuponsUtilizados(widget.dashboardJson) ?? 0.0).toInt()
        : _dadosConsolidados.fold(0, (acc, item) => acc + item.cuponsValidados);
    final int totalPendentesGeral = widget.dashboardJson != null
        ? (ObterDashboardCompletoCall.cuponsAtivos(widget.dashboardJson) ?? 0.0).toInt()
        : _dadosConsolidados.fold(0, (acc, item) => acc + item.cuponsNaoValidados);
    final double totalEconomiaGeral = widget.dashboardJson != null
        ? (ObterDashboardCompletoCall.descontosAplicados(widget.dashboardJson) ?? 0.0)
        : _dadosConsolidados.fold(0.0, (acc, item) => acc + item.economiaGerada);

    final double ticketMedioGeral = _calcularTicketMedioGeral();
    final double oportunidadesTotais = totalPendentesGeral * ticketMedioGeral;

    return Material(
      color: Colors.transparent,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFFE5E5E5),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header do Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(
                      Icons.analytics_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 24.0,
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Desempenho Consolidado & Oportunidades dos Parceiros',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 17.0,
                              ),
                        ),
                        Text(
                          'Acompanhe as vendas brutas, cupons resgatados, cupons disponíveis, oportunidades em aberto e produtos líderes.',
                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                font: GoogleFonts.openSans(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 13.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Mini Cards de Resumo Geral (KPIs com Oportunidades em Aberto)
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  return isWide
                      ? Row(
                          children: [
                            Expanded(child: _buildKpiMiniCard('Vendas Realizadas', 'R\$ ${totalVendasGeral.toStringAsFixed(2).replaceAll('.', ',')}', Icons.payments_rounded, const Color(0xFF2E7D32))),
                            const SizedBox(width: 12.0),
                            Expanded(child: _buildKpiMiniCard('Cupons Validados', '$totalValidadosGeral resgatados', Icons.check_circle_rounded, const Color(0xFF1976D2))),
                            const SizedBox(width: 12.0),
                            Expanded(child: _buildKpiMiniCard('Cupons Disponíveis', '$totalPendentesGeral ativos', Icons.pending_actions_rounded, const Color(0xFF00796B))),
                            const SizedBox(width: 12.0),
                            Expanded(child: _buildKpiMiniCard('Oportunidades em Aberto', 'R\$ ${oportunidadesTotais.toStringAsFixed(2).replaceAll('.', ',')}', Icons.trending_up_rounded, const Color(0xFFE65100), destaque: true)),
                            const SizedBox(width: 12.0),
                            Expanded(child: _buildKpiMiniCard('Economia Gerada', 'R\$ ${totalEconomiaGeral.toStringAsFixed(2).replaceAll('.', ',')}', Icons.savings_rounded, const Color(0xFF7B1FA2))),
                          ],
                        )
                      : Wrap(
                          spacing: 12.0,
                          runSpacing: 12.0,
                          children: [
                            _buildKpiMiniCard('Vendas Realizadas', 'R\$ ${totalVendasGeral.toStringAsFixed(2).replaceAll('.', ',')}', Icons.payments_rounded, const Color(0xFF2E7D32)),
                            _buildKpiMiniCard('Cupons Validados', '$totalValidadosGeral resgatados', Icons.check_circle_rounded, const Color(0xFF1976D2)),
                            _buildKpiMiniCard('Cupons Disponíveis', '$totalPendentesGeral ativos', Icons.pending_actions_rounded, const Color(0xFF00796B)),
                            _buildKpiMiniCard('Oportunidades em Aberto', 'R\$ ${oportunidadesTotais.toStringAsFixed(2).replaceAll('.', ',')}', Icons.trending_up_rounded, const Color(0xFFE65100), destaque: true),
                            _buildKpiMiniCard('Economia Gerada', 'R\$ ${totalEconomiaGeral.toStringAsFixed(2).replaceAll('.', ',')}', Icons.savings_rounded, const Color(0xFF7B1FA2)),
                          ],
                        );
                },
              ),
            ),

            // Barra de Busca
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
              child: SizedBox(
                height: 44.0,
                child: TextField(
                  controller: _model.searchController,
                  onChanged: (val) => setState(() => _termoBusca = val),
                  decoration: InputDecoration(
                    hintText: 'Filtrar parceiro por nome, segmento, cidade ou produto líder...',
                    hintStyle: GoogleFonts.openSans(fontSize: 13.5, color: const Color(0xFF909090)),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9A9A9A), size: 20.0),
                    suffixIcon: _termoBusca.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18.0),
                            onPressed: () {
                              _model.searchController?.clear();
                              setState(() => _termoBusca = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 1.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  style: GoogleFonts.openSans(fontSize: 13.5),
                ),
              ),
            ),

            // Tabela Analítica
            if (listaFiltrada.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'Nenhum parceiro encontrado com os filtros informados.',
                    style: GoogleFonts.openSans(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(const Color(0xFFF8F9FA)),
                  headingRowHeight: 46.0,
                  dataRowHeight: 68.0,
                  horizontalMargin: 24.0,
                  columnSpacing: 24.0,
                  columns: [
                    DataColumn(
                      label: _buildSortableHeader('PARCEIRO', 'nome'),
                    ),
                    DataColumn(
                      label: _buildSortableHeader('VENDAS REALIZADAS', 'vendas'),
                    ),
                    DataColumn(
                      label: _buildSortableHeader('CUPONS VALIDADOS', 'validados'),
                    ),
                    DataColumn(
                      label: _buildSortableHeader('NÃO VALIDADOS (DISPONÍVEIS)', 'pendentes'),
                    ),
                    DataColumn(
                      label: _buildSortableHeader('🎯 OPORTUNIDADE EM ABERTO', 'oportunidade'),
                    ),
                    DataColumn(
                      label: Text(
                        'PRODUTO / BENEFÍCIO LÍDER',
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: _buildSortableHeader('ECONOMIA GERADA', 'economia'),
                    ),
                  ],
                  rows: listaFiltrada.map((item) {
                    final oportunidadeItem = item.getOportunidade(ticketMedioGeral);

                    return DataRow(
                      cells: [
                        // Parceiro (Logo + Nome + Segmento/Cidade)
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 42.0,
                                height: 42.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEEEE),
                                  shape: BoxShape.circle,
                                ),
                                child: item.photo.isNotEmpty && item.photo != 'null'
                                    ? ClipOval(
                                        child: Image.network(
                                          item.photo,
                                          width: 42.0,
                                          height: 42.0,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => const Icon(
                                            Icons.storefront_rounded,
                                            color: Color(0xFF888888),
                                            size: 20.0,
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.storefront_rounded,
                                        color: Color(0xFF888888),
                                        size: 20.0,
                                      ),
                              ),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.fantasia,
                                    style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    '${item.segment}${item.city.isNotEmpty ? ' • ${item.city}' : ''}',
                                    style: GoogleFonts.openSans(
                                      fontSize: 12.0,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Total de Vendas
                        DataCell(
                          Text(
                            'R\$ ${item.totalVendas.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                        ),

                        // Cupons Validados
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 14.0, color: Color(0xFF2E7D32)),
                                const SizedBox(width: 5.0),
                                Text(
                                  '${item.cuponsValidados} validados',
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: const Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Cupons Não Validados
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2F1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.inventory_2_outlined, size: 14.0, color: Color(0xFF00796B)),
                                const SizedBox(width: 5.0),
                                Text(
                                  '${item.cuponsNaoValidados} disponíveis',
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: const Color(0xFF00796B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Oportunidade em Aberto (Potencial)
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: const Color(0xFFFFD54F), width: 1.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.trending_up_rounded, size: 15.0, color: Color(0xFFE65100)),
                                const SizedBox(width: 5.0),
                                Text(
                                  'R\$ ${oportunidadeItem.toStringAsFixed(2).replaceAll('.', ',')}',
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                    color: const Color(0xFFE65100),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Produto / Benefício Líder
                        DataCell(
                          SizedBox(
                            width: 240.0,
                            child: Row(
                              children: [
                                const Icon(Icons.stars_rounded, size: 16.0, color: Color(0xFFF57C00)),
                                const SizedBox(width: 6.0),
                                Expanded(
                                  child: Text(
                                    item.topProduto,
                                    style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.0,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Economia Gerada
                        DataCell(
                          Text(
                            'R\$ ${item.economiaGerada.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiMiniCard(String label, String value, IconData icon, Color color, {bool destaque = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: destaque ? color.withOpacity(0.12) : color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: destaque ? color : color.withOpacity(0.20), width: destaque ? 1.5 : 1.0),
      ),
      child: Row(
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: color, size: 20.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.openSans(
                    fontSize: 11.5,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  value,
                  style: GoogleFonts.openSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: destaque ? color : FlutterFlowTheme.of(context).primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerPerformanceItem {
  final String id;
  final String fantasia;
  final String photo;
  final String segment;
  final String city;
  double totalVendas;
  int cuponsValidados;
  int cuponsNaoValidados;
  double economiaGerada;
  Map<String, int> produtosResgatados;

  _PartnerPerformanceItem({
    required this.id,
    required this.fantasia,
    required this.photo,
    required this.segment,
    required this.city,
    this.totalVendas = 0.0,
    this.cuponsValidados = 0,
    this.cuponsNaoValidados = 0,
    this.economiaGerada = 0.0,
    Map<String, int>? produtosResgatados,
  }) : produtosResgatados = produtosResgatados ?? {};

  double getTicketMedio(double ticketMedioGeral) {
    return cuponsValidados > 0 ? (totalVendas / cuponsValidados) : ticketMedioGeral;
  }

  double getOportunidade(double ticketMedioGeral) {
    return cuponsNaoValidados * getTicketMedio(ticketMedioGeral);
  }

  String get topProduto {
    if (produtosResgatados.isEmpty) return 'Nenhum cupom resgatado';
    var best = '';
    var bestCount = -1;
    produtosResgatados.forEach((prod, count) {
      if (count > bestCount) {
        bestCount = count;
        best = prod;
      }
    });
    return best;
  }
}
