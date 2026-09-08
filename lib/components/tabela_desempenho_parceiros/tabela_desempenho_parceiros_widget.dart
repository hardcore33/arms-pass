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
    this.usuarios,
  });

  final dynamic parceiros;
  final dynamic cupons;
  final dynamic trocas;
  final dynamic dashboardJson;
  final dynamic usuarios;

  @override
  State<TabelaDesempenhoParceirosWidget> createState() =>
      _TabelaDesempenhoParceirosWidgetState();
}

class _TabelaDesempenhoParceirosWidgetState
    extends State<TabelaDesempenhoParceirosWidget> {
  late TabelaDesempenhoParceirosModel _model;
  String _termoBusca = '';
  String _segmentoSelecionado = 'Todos';
  String _sortColumn = 'vendas'; // vendas, validados, pendentes, economia, nome
  bool _sortAsc = false;

  int _paginaAtual = 1;
  static const int _itensPorPagina = 8;

  List<_PartnerPerformanceItem> _dadosConsolidados = [];
  List<String> _segmentosDisponiveis = ['Todos'];

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
        oldWidget.dashboardJson != widget.dashboardJson ||
        oldWidget.usuarios != widget.usuarios) {
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

  String _formatInt(int val) {
    return val.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  String _formatCurrency(double val) {
    final parts = val.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return 'R\$ $intPart,${parts[1]}';
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
    final Set<String> segmentos = {'Todos'};

    final listaParceiros = _extrairLista(widget.parceiros);
    final listaCupons = _extrairLista(widget.cupons);
    final listaTrocas = _extrairLista(widget.trocas);

    // 1. Mapeia parceiros reais
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
      final segment = (p['segment'] is Map ? p['segment']['name'] : p['segmento'] ?? 'Geral').toString().trim();
      final city = (p['city'] ?? p['cidade'] ?? '').toString().trim();

      if (segment.isNotEmpty && segment != 'null') {
        segmentos.add(segment);
      }

      mapa[id] = _PartnerPerformanceItem(
        id: id,
        fantasia: fantasia,
        photo: photo,
        segment: segment.isNotEmpty ? segment : 'Geral',
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
        final seg = (partner['segment'] is Map ? partner['segment']['name'] : partner['segmento'] ?? 'Geral').toString().trim();
        if (seg.isNotEmpty && seg != 'null') segmentos.add(seg);

        target = _PartnerPerformanceItem(
          id: newId,
          fantasia: partnerName.isNotEmpty ? partnerName : 'Parceiro',
          photo: (partner['photo'] ?? '').toString(),
          segment: seg.isNotEmpty ? seg : 'Geral',
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
    _segmentosDisponiveis = segmentos.toList()..sort();
    _aplicarOrdenacao();
    if (mounted) {
      setState(() {});
    }
  }

  void _aplicarOrdenacao() {
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

  void _onSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAsc = !_sortAsc;
      } else {
        _sortColumn = column;
        _sortAsc = false;
      }
      _paginaAtual = 1;
      _aplicarOrdenacao();
    });
  }

  Widget _buildSortableHeader(String label, String column) {
    final theme = FlutterFlowTheme.of(context);
    final isSelected = _sortColumn == column;
    return InkWell(
      onTap: () => _onSort(column),
      borderRadius: BorderRadius.circular(4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.readexPro(
                fontWeight: FontWeight.w600,
                fontSize: 11.5,
                color: isSelected ? theme.primary : theme.secondaryText,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 4.0),
            Icon(
              isSelected
                  ? (_sortAsc ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded)
                  : Icons.unfold_more_rounded,
              size: 14.0,
              color: isSelected ? theme.secondary : theme.secondaryText.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirDetalhesParceiro(_PartnerPerformanceItem item) {
    final theme = FlutterFlowTheme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: theme.secondaryBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Container(
            width: (MediaQuery.sizeOf(context).width * 0.5).clamp(360.0, 560.0),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.secondary.withOpacity(0.4), width: 1.5),
                      ),
                      child: item.photo.isNotEmpty && item.photo != 'null'
                          ? ClipOval(
                              child: Image.network(
                                item.photo,
                                width: 48.0,
                                height: 48.0,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.storefront_rounded,
                                  color: theme.secondary,
                                  size: 24.0,
                                ),
                              ),
                            )
                          : Icon(Icons.storefront_rounded, color: theme.secondary, size: 24.0),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.fantasia,
                            style: GoogleFonts.readexPro(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryText,
                            ),
                          ),
                          Text(
                            '${item.segment}${item.city.isNotEmpty ? ' • ${item.city}' : ''}',
                            style: GoogleFonts.readexPro(
                              fontSize: 13.0,
                              color: theme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: theme.secondaryText),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Divider(height: 1.0),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildModalMetricBox(
                        'Total de Vendas',
                        'R\$ ${item.totalVendas.toStringAsFixed(2).replaceAll('.', ',')}',
                        Icons.payments_rounded,
                        theme,
                        destaque: true,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: _buildModalMetricBox(
                        'Economia Gerada',
                        'R\$ ${item.economiaGerada.toStringAsFixed(2).replaceAll('.', ',')}',
                        Icons.savings_rounded,
                        theme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildModalMetricBox(
                        'Cupons Validados',
                        '${item.cuponsValidados} resgates',
                        Icons.check_circle_outline_rounded,
                        theme,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: _buildModalMetricBox(
                        'Cupons Disponíveis',
                        '${item.cuponsNaoValidados} ativos',
                        Icons.inventory_2_outlined,
                        theme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Benefícios & Produtos Resgatados',
                  style: GoogleFonts.readexPro(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  constraints: const BoxConstraints(maxHeight: 180.0),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: theme.alternate),
                  ),
                  child: item.produtosResgatados.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Nenhum produto resgatado ainda.',
                              style: GoogleFonts.readexPro(
                                fontSize: 12.5,
                                color: theme.secondaryText,
                              ),
                            ),
                          ),
                        )
                      : ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                          children: item.produtosResgatados.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Icon(Icons.stars_rounded, size: 16.0, color: theme.secondary),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: GoogleFonts.readexPro(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: theme.primaryText,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: theme.secondary.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      '${entry.value}x',
                                      style: GoogleFonts.readexPro(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: theme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalMetricBox(String label, String value, IconData icon, FlutterFlowTheme theme, {bool destaque = false}) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: destaque ? theme.secondary.withOpacity(0.12) : theme.primaryBackground,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: destaque ? theme.secondary : theme.alternate),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.0, color: destaque ? theme.primary : theme.secondary),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.readexPro(
                    fontSize: 11.0,
                    color: theme.secondaryText,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.readexPro(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Filtragem combinada (Busca + Segmento)
    final listaFiltrada = _dadosConsolidados.where((item) {
      final matchesSearch = _termoBusca.isEmpty ||
          item.fantasia.toLowerCase().contains(_termoBusca.toLowerCase()) ||
          item.segment.toLowerCase().contains(_termoBusca.toLowerCase()) ||
          item.city.toLowerCase().contains(_termoBusca.toLowerCase()) ||
          item.topProduto.toLowerCase().contains(_termoBusca.toLowerCase());

      final matchesSegment = _segmentoSelecionado == 'Todos' ||
          item.segment.toLowerCase() == _segmentoSelecionado.toLowerCase();

      return matchesSearch && matchesSegment;
    }).toList();

    // Paginação
    final totalItens = listaFiltrada.length;
    final totalPaginas = (totalItens / _itensPorPagina).ceil().clamp(1, 9999);
    final paginaSegura = _paginaAtual.clamp(1, totalPaginas);
    final startIndex = (paginaSegura - 1) * _itensPorPagina;
    final endIndex = (startIndex + _itensPorPagina).clamp(0, totalItens);
    final listaPaginada = totalItens > 0 ? listaFiltrada.sublist(startIndex, endIndex) : <_PartnerPerformanceItem>[];

    // Métricas Resumo Topo Oficiais
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

    // Quantidade de Usuários
    int totalUsuarios = 0;
    if (widget.dashboardJson != null &&
        ObterDashboardCompletoCall.usuariosAtivos(widget.dashboardJson) != null &&
        (ObterDashboardCompletoCall.usuariosAtivos(widget.dashboardJson) ?? 0) > 0) {
      totalUsuarios = (ObterDashboardCompletoCall.usuariosAtivos(widget.dashboardJson) ?? 0.0).toInt();
    } else if (widget.usuarios is List) {
      totalUsuarios = (widget.usuarios as List).length;
    }

    final int usuariosComCompras = widget.dashboardJson != null
        ? (ObterDashboardCompletoCall.qtdDeUsuariosComprasPeriodo(widget.dashboardJson) ?? 0.0).toInt()
        : 0;

    // Total de Negócios / Parceiros Credenciados
    int totalNegociosAtivos = _dadosConsolidados.length;
    if (widget.dashboardJson != null &&
        ObterDashboardCompletoCall.parceirosAtivos(widget.dashboardJson) != null &&
        (ObterDashboardCompletoCall.parceirosAtivos(widget.dashboardJson) ?? 0) > 0) {
      totalNegociosAtivos = (ObterDashboardCompletoCall.parceirosAtivos(widget.dashboardJson) ?? 0.0).toInt();
    }
    final int totalNegociosCadastrados = _dadosConsolidados.length;

    // Trocas Solicitadas / Pendentes
    final int trocasSolicitadas = widget.dashboardJson != null
        ? (ObterDashboardCompletoCall.trocaSolicitada(widget.dashboardJson) ?? 0.0).toInt()
        : 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Elegante
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
            child: Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    Icons.store_mall_directory_rounded,
                    color: theme.secondary,
                    size: 22.0,
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Desempenho Geral do Clube & Parceiros',
                        style: GoogleFonts.readexPro(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      Text(
                        'Acompanhe usuários cadastrados, estabelecimentos credenciados, vendas e resgates.',
                        style: GoogleFonts.readexPro(
                          fontSize: 12.5,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 6 KPIs Completos e Alinhados à Marca
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                int crossAxisCount;
                if (width >= 1280) {
                  crossAxisCount = 6;
                } else if (width >= 750) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 2;
                }

                const double spacing = 10.0;
                final double itemWidth =
                    (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;

                final items = [
                  _buildSystemKpiCard(
                    'Total de Usuários',
                    _formatInt(totalUsuarios),
                    Icons.people_alt_rounded,
                    theme,
                    subtitle: usuariosComCompras > 0
                        ? '$usuariosComCompras ativos no período'
                        : 'Clientes cadastrados',
                  ),
                  _buildSystemKpiCard(
                    'Total de Negócios',
                    _formatInt(totalNegociosAtivos),
                    Icons.storefront_rounded,
                    theme,
                    subtitle: totalNegociosCadastrados > 0
                        ? '$totalNegociosCadastrados credenciados'
                        : 'Parceiros ativos',
                  ),
                  _buildSystemKpiCard(
                    'Vendas Realizadas',
                    _formatCurrency(totalVendasGeral),
                    Icons.payments_outlined,
                    theme,
                    isHighlight: true,
                    subtitle: 'Volume transacionado',
                  ),
                  _buildSystemKpiCard(
                    'Economia Gerada',
                    _formatCurrency(totalEconomiaGeral),
                    Icons.savings_outlined,
                    theme,
                    subtitle: 'Descontos concedidos',
                  ),
                  _buildSystemKpiCard(
                    'Cupons Resgatados',
                    '${_formatInt(totalValidadosGeral)} validados',
                    Icons.check_circle_outline_rounded,
                    theme,
                    subtitle: trocasSolicitadas > 0
                        ? '$trocasSolicitadas pendentes'
                        : 'Resgates efetuados',
                  ),
                  _buildSystemKpiCard(
                    'Cupons Ativos',
                    '${_formatInt(totalPendentesGeral)} disponíveis',
                    Icons.confirmation_number_outlined,
                    theme,
                    subtitle: 'Disponíveis no clube',
                  ),
                ];

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: items
                      .map((w) => SizedBox(
                            width: itemWidth,
                            child: w,
                          ))
                      .toList(),
                );
              },
            ),
          ),

          const SizedBox(height: 16.0),

          // Barra de Filtros e Busca Inteligente
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                // Campo de Busca
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 42.0,
                    child: TextField(
                      controller: _model.searchController,
                      onChanged: (val) {
                        setState(() {
                          _termoBusca = val;
                          _paginaAtual = 1;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar por parceiro, segmento, cidade ou benefício...',
                        hintStyle: GoogleFonts.readexPro(
                          fontSize: 12.5,
                          color: theme.secondaryText.withOpacity(0.7),
                        ),
                        prefixIcon: Icon(Icons.search_rounded, size: 18.0, color: theme.secondary),
                        suffixIcon: _termoBusca.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded, size: 16.0),
                                onPressed: () {
                                  _model.searchController?.clear();
                                  setState(() {
                                    _termoBusca = '';
                                    _paginaAtual = 1;
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: theme.primaryBackground,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.alternate, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.secondary, width: 1.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                // Dropdown de Segmento
                Container(
                  height: 42.0,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: theme.alternate),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _segmentoSelecionado,
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Icon(Icons.keyboard_arrow_down_rounded, size: 20.0, color: theme.secondary),
                      ),
                      menuMaxHeight: 280.0,
                      borderRadius: BorderRadius.circular(10.0),
                      dropdownColor: theme.secondaryBackground,
                      elevation: 4,
                      style: GoogleFonts.readexPro(
                        fontSize: 12.5,
                        color: theme.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String? novo) {
                        if (novo != null) {
                          setState(() {
                            _segmentoSelecionado = novo;
                            _paginaAtual = 1;
                          });
                        }
                      },
                      items: _segmentosDisponiveis.map((seg) {
                        final isSelected = seg == _segmentoSelecionado;
                        return DropdownMenuItem<String>(
                          value: seg,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (seg == 'Todos')
                                  Icon(
                                    Icons.apps_rounded,
                                    size: 16.0,
                                    color: isSelected ? theme.primary : theme.secondaryText,
                                  )
                                else
                                  Container(
                                    width: 6.0,
                                    height: 6.0,
                                    decoration: BoxDecoration(
                                      color: isSelected ? theme.secondary : theme.alternate,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                const SizedBox(width: 8.0),
                                Text(
                                  seg == 'Todos' ? 'Todos os Segmentos' : seg,
                                  style: GoogleFonts.readexPro(
                                    fontSize: 12.5,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? theme.primary : theme.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14.0),

          // Tabela Compacta
          if (listaFiltrada.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded, size: 36.0, color: theme.secondaryText.withOpacity(0.5)),
                    const SizedBox(height: 8.0),
                    Text(
                      'Nenhum parceiro encontrado para os filtros selecionados.',
                      style: GoogleFonts.readexPro(color: theme.secondaryText, fontSize: 13.5),
                    ),
                  ],
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.sizeOf(context).width - 320,
                ),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(theme.primaryBackground),
                  headingRowHeight: 40.0,
                  dataRowMinHeight: 56.0,
                  dataRowMaxHeight: 56.0,
                  horizontalMargin: 24.0,
                  columnSpacing: 28.0,
                  columns: [
                    DataColumn(label: _buildSortableHeader('PARCEIRO', 'nome')),
                    DataColumn(label: _buildSortableHeader('TOTAL EM VENDAS', 'vendas')),
                    DataColumn(label: _buildSortableHeader('CUPONS (RESGATADOS / ATIVOS)', 'validados')),
                    DataColumn(label: _buildSortableHeader('ECONOMIA GERADA', 'economia')),
                    DataColumn(
                      label: Text(
                        'PRODUTO LÍDER',
                        style: GoogleFonts.readexPro(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                          color: theme.secondaryText,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'AÇÃO',
                        style: GoogleFonts.readexPro(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                          color: theme.secondaryText,
                        ),
                      ),
                    ),
                  ],
                  rows: listaPaginada.map((item) {
                    return DataRow(
                      cells: [
                        // Parceiro (Logo + Nome + Segmento)
                        DataCell(
                          InkWell(
                            onTap: () => _abrirDetalhesParceiro(item),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: theme.primary.withOpacity(0.06),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: theme.secondary.withOpacity(0.3), width: 1.0),
                                  ),
                                  child: item.photo.isNotEmpty && item.photo != 'null'
                                      ? ClipOval(
                                          child: Image.network(
                                            item.photo,
                                            width: 36.0,
                                            height: 36.0,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.storefront_rounded,
                                              color: theme.secondary,
                                              size: 18.0,
                                            ),
                                          ),
                                        )
                                      : Icon(Icons.storefront_rounded, color: theme.secondary, size: 18.0),
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.fantasia,
                                      style: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.0,
                                        color: theme.primaryText,
                                      ),
                                    ),
                                    Text(
                                      '${item.segment}${item.city.isNotEmpty ? ' • ${item.city}' : ''}',
                                      style: GoogleFonts.readexPro(
                                        fontSize: 11.0,
                                        color: theme.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Total em Vendas
                        DataCell(
                          Text(
                            'R\$ ${item.totalVendas.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: GoogleFonts.readexPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              color: theme.primaryText,
                            ),
                          ),
                        ),

                        // Cupons (Validados / Ativos)
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(color: theme.secondary.withOpacity(0.3)),
                                ),
                                child: Text(
                                  '${item.cuponsValidados} validados',
                                  style: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.5,
                                    color: theme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                '/ ${item.cuponsNaoValidados} ativos',
                                style: GoogleFonts.readexPro(
                                  fontSize: 11.5,
                                  color: theme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Economia Gerada
                        DataCell(
                          Text(
                            'R\$ ${item.economiaGerada.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: GoogleFonts.readexPro(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                              color: theme.secondary,
                            ),
                          ),
                        ),

                        // Produto Líder
                        DataCell(
                          SizedBox(
                            width: 180.0,
                            child: Text(
                              item.topProduto,
                              style: GoogleFonts.readexPro(
                                fontSize: 12.0,
                                color: theme.primaryText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        // Ação
                        DataCell(
                          InkWell(
                            onTap: () => _abrirDetalhesParceiro(item),
                            borderRadius: BorderRadius.circular(6.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color: theme.primary,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Detalhes',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: theme.secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Icon(Icons.chevron_right_rounded, size: 14.0, color: theme.secondary),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

          // Rodapé com Paginação
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme.alternate, width: 1.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalItens > 0
                      ? 'Exibindo ${startIndex + 1}–$endIndex de $totalItens parceiros'
                      : 'Nenhum registro',
                  style: GoogleFonts.readexPro(
                    fontSize: 12.0,
                    color: theme.secondaryText,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, size: 20.0),
                      color: paginaSegura > 1 ? theme.primary : theme.secondaryText.withOpacity(0.3),
                      onPressed: paginaSegura > 1
                          ? () => setState(() => _paginaAtual = paginaSegura - 1)
                          : null,
                    ),
                    Text(
                      'Página $paginaSegura de $totalPaginas',
                      style: GoogleFonts.readexPro(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, size: 20.0),
                      color: paginaSegura < totalPaginas ? theme.primary : theme.secondaryText.withOpacity(0.3),
                      onPressed: paginaSegura < totalPaginas
                          ? () => setState(() => _paginaAtual = paginaSegura + 1)
                          : null,
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

  Widget _buildSystemKpiCard(
    String label,
    String value,
    IconData icon,
    FlutterFlowTheme theme, {
    bool isHighlight = false,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isHighlight ? theme.primary : theme.primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isHighlight ? theme.secondary : theme.alternate,
          width: 1.0,
        ),
        boxShadow: isHighlight
            ? [
                BoxShadow(
                  color: theme.secondary.withOpacity(0.15),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              color: isHighlight
                  ? theme.secondary.withOpacity(0.2)
                  : theme.secondary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              icon,
              color: isHighlight ? theme.secondary : theme.primary,
              size: 20.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.readexPro(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: isHighlight ? theme.secondary : theme.secondaryText,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Text(
                  value,
                  style: GoogleFonts.readexPro(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: isHighlight ? Colors.white : theme.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    style: GoogleFonts.readexPro(
                      fontSize: 10.5,
                      fontWeight: FontWeight.normal,
                      color: isHighlight
                          ? Colors.white.withOpacity(0.7)
                          : theme.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
    Map<String, int>? produtosResgatados,
  })  : totalVendas = 0.0,
        cuponsValidados = 0,
        cuponsNaoValidados = 0,
        economiaGerada = 0.0,
        produtosResgatados = produtosResgatados ?? {};

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
