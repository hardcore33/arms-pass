import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'listagem_de_trocas_model.dart';
export 'listagem_de_trocas_model.dart';

class ListagemDeTrocasWidget extends StatefulWidget {
  const ListagemDeTrocasWidget({
    super.key,
    required this.trocas,
  });

  final List<dynamic>? trocas;

  @override
  State<ListagemDeTrocasWidget> createState() => _ListagemDeTrocasWidgetState();
}

class _ListagemDeTrocasWidgetState extends State<ListagemDeTrocasWidget> {
  late ListagemDeTrocasModel _model;
  String sortField = 'id';
  bool sortAscending = true;
  int _paginaAtual = 1;
  static const int _itensPorPagina = 10;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    // Paginação e filtros locais são instantâneos em memória (0ms).
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  List<dynamic> _groupData(List<dynamic> rawList) {
    final Map<String, Map<String, dynamic>> grouped = {};
    for (var item in rawList) {
      final customer = item['customer'];
      if (customer == null) continue;
      final customerId = customer['id']?.toString() ?? 'unknown';

      final points = _parseDouble(item['qtd_point']);
      final savings = _parseDouble(item['total_saving']);

      if (!grouped.containsKey(customerId)) {
        grouped[customerId] = {
          'id': customerId,
          'customer': customer,
          'total_cupons': 1,
          'qtd_point': points,
          'total_saving': savings,
          'data': item['data'],
        };
      } else {
        grouped[customerId]!['total_cupons'] =
            (grouped[customerId]!['total_cupons'] as int) + 1;
        grouped[customerId]!['qtd_point'] =
            (grouped[customerId]!['qtd_point'] as double) + points;
        grouped[customerId]!['total_saving'] =
            (grouped[customerId]!['total_saving'] as double) + savings;

        final existingDate = grouped[customerId]!['data']?.toString() ?? '';
        final newDate = item['data']?.toString() ?? '';
        if (newDate.compareTo(existingDate) > 0) {
          grouped[customerId]!['data'] = newDate;
        }
      }
    }
    return grouped.values.toList();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeTrocasModel());

    final list = widget.trocas;
    if (list is List) {
      _model.trocasLocal = _groupData(list.toList().cast<dynamic>());
    } else {
      _model.trocasLocal = [];
    }

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final list = widget.trocas;
      if (list is List) {
        _model.trocasLocal = _groupData(list.toList().cast<dynamic>());
      } else {
        _model.trocasLocal = [];
      }
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didUpdateWidget(covariant ListagemDeTrocasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trocas != oldWidget.trocas) {
      final list = widget.trocas;
      if (list is List) {
        _model.trocasLocal = _groupData(list.toList().cast<dynamic>());
      } else {
        _model.trocasLocal = [];
      }
      safeSetState(() {});
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  List<dynamic> _filtrarEOrdenar(List<dynamic> input) {
    final termoBusca = _model.textController?.text.toLowerCase().trim() ?? '';

    final filtrados = input.where((item) {
      if (termoBusca.isEmpty) return true;

      final id = (getJsonField(item, r'''$.id''') ?? '').toString().toLowerCase();
      final nome =
          (getJsonField(item, r'''$.customer.name''') ?? '').toString().toLowerCase();
      final email =
          (getJsonField(item, r'''$.customer.email''') ?? '').toString().toLowerCase();
      final cpf =
          (getJsonField(item, r'''$.customer.cpf''') ?? '').toString().toLowerCase();

      return id.contains(termoBusca) ||
          nome.contains(termoBusca) ||
          email.contains(termoBusca) ||
          cpf.contains(termoBusca);
    }).toList();

    dynamic keyOf(dynamic item) {
      switch (sortField) {
        case 'id':
          final idRaw = getJsonField(item, r'''$.id''');
          return idRaw is num
              ? idRaw
              : int.tryParse(idRaw?.toString() ?? '') ?? 0;
        case 'total_cupons':
          final raw = getJsonField(item, r'''$.total_cupons''');
          return raw is num
              ? raw
              : int.tryParse(raw?.toString() ?? '') ?? 0;
        case 'pontos':
          return _parseDouble(getJsonField(item, r'''$.qtd_point'''));
        case 'economia':
          return _parseDouble(getJsonField(item, r'''$.total_saving'''));
        case 'cliente':
        default:
          return (getJsonField(item, r'''$.customer.name''') ?? '')
              .toString()
              .toLowerCase();
      }
    }

    filtrados.sort((a, b) {
      final valA = keyOf(a);
      final valB = keyOf(b);
      int cmp;
      if (valA is num && valB is num) {
        cmp = valA.compareTo(valB);
      } else {
        cmp = valA.toString().compareTo(valB.toString());
      }
      return sortAscending ? cmp : -cmp;
    });

    return filtrados;
  }

  Widget _buildSortableHeader(
    BuildContext context,
    String field,
    String label,
    FlutterFlowTheme theme, {
    Alignment alignment = Alignment.centerLeft,
  }) {
    final isActive = sortField == field;
    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: () {
          safeSetState(() {
            if (sortField == field) {
              sortAscending = !sortAscending;
            } else {
              sortField = field;
              sortAscending = true;
            }
            _paginaAtual = 1;
          });
        },
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.readexPro(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                  color: isActive ? theme.primary : theme.secondaryText,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 4.0),
              Icon(
                isActive
                    ? (sortAscending
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded)
                    : Icons.unfold_more_rounded,
                size: 13.0,
                color: isActive
                    ? theme.secondary
                    : theme.secondaryText.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final todasTrocas = _filtrarEOrdenar(_model.trocasLocal);
    final totalItens = todasTrocas.length;
    final totalPaginas = (totalItens / _itensPorPagina).ceil().clamp(1, 9999);
    final paginaSegura = _paginaAtual.clamp(1, totalPaginas);
    final startIndex = (paginaSegura - 1) * _itensPorPagina;
    final endIndex = (startIndex + _itensPorPagina).clamp(0, totalItens);
    final itemTrocas =
        totalItens > 0 ? todasTrocas.sublist(startIndex, endIndex) : <dynamic>[];

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
          // Barra Superior: Busca e Contagem
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registro de Trocas & Resgates',
                        style: GoogleFonts.readexPro(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      Text(
                        totalItens > 0
                            ? '$totalItens resgates encontrados'
                            : 'Nenhum resgate encontrado',
                        style: GoogleFonts.readexPro(
                          fontSize: 12.5,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 320.0,
                  height: 42.0,
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.textController',
                      const Duration(milliseconds: 200),
                      () {
                        setState(() {
                          _paginaAtual = 1;
                        });
                      },
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Buscar por usuário, ID ou cupom...',
                      hintStyle: GoogleFonts.readexPro(
                        fontSize: 12.5,
                        color: theme.secondaryText.withValues(alpha: 0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.secondary,
                        size: 18.0,
                      ),
                      suffixIcon: (_model.textController?.text.isNotEmpty ?? false)
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 16.0),
                              onPressed: () {
                                _model.textController?.clear();
                                setState(() {
                                  _paginaAtual = 1;
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.primaryBackground,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 0.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.alternate, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.secondary, width: 1.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: GoogleFonts.readexPro(
                        fontSize: 13.0, color: theme.primaryText),
                  ),
                ),
              ],
            ),
          ),

          // Cabeçalho da Tabela
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              border: Border(
                top: BorderSide(color: theme.alternate, width: 1.0),
                bottom: BorderSide(color: theme.alternate, width: 1.0),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: _buildSortableHeader(context, 'id', 'ID', theme,
                      alignment: Alignment.center),
                ),
                Expanded(
                  flex: 3,
                  child: _buildSortableHeader(
                      context, 'total_cupons', 'TOTAL DE CUPONS', theme,
                      alignment: Alignment.center),
                ),
                Expanded(
                  flex: 6,
                  child: _buildSortableHeader(
                      context, 'cliente', 'USUÁRIO', theme,
                      alignment: Alignment.centerLeft),
                ),
                Expanded(
                  flex: 3,
                  child: _buildSortableHeader(
                      context, 'pontos', 'PONTOS', theme,
                      alignment: Alignment.center),
                ),
                Expanded(
                  flex: 3,
                  child: _buildSortableHeader(
                      context, 'economia', 'ECONOMIA', theme,
                      alignment: Alignment.center),
                ),
              ],
            ),
          ),

          // Linhas dos Resgates
          if (itemTrocas.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 36.0,
                        color: theme.secondaryText.withValues(alpha: 0.5)),
                    const SizedBox(height: 8.0),
                    Text(
                      'Nenhum resgate encontrado.',
                      style: GoogleFonts.readexPro(
                          color: theme.secondaryText, fontSize: 13.5),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemTrocas.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.0,
                thickness: 1.0,
                color: theme.alternate,
              ),
              itemBuilder: (context, index) {
                final item = itemTrocas[index];
                final id = getJsonField(item, r'''$.id''')?.toString() ?? '';
                final cuponsCount = getJsonField(item, r'''$.total_cupons''');
                final customerName =
                    (getJsonField(item, r'''$.customer.name''') ?? '').toString();

                final rawPoints = getJsonField(item, r'''$.qtd_point''');
                String pointsStr = '0 pts';
                if (rawPoints != null) {
                  double? v;
                  if (rawPoints is num) {
                    v = rawPoints.toDouble();
                  } else if (rawPoints is String) {
                    v = double.tryParse(rawPoints);
                  }
                  if (v != null && v > 0) {
                    pointsStr = '${v.toInt()} pts';
                  }
                }

                final rawSaving = getJsonField(item, r'''$.total_saving''');
                String savingStr = 'R\$ 0,00';
                if (rawSaving != null) {
                  double? v;
                  if (rawSaving is num) {
                    v = rawSaving.toDouble();
                  } else if (rawSaving is String) {
                    v = double.tryParse(rawSaving);
                  }
                  if (v != null && v > 0) {
                    savingStr =
                        'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 14.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80.0,
                        child: Text(
                          id,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.readexPro(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            color: theme.primaryText,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          cuponsCount == null
                              ? '0 cupons'
                              : '$cuponsCount ${cuponsCount == 1 ? 'cupom' : 'cupons'}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.readexPro(
                            fontSize: 13.0,
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          customerName.toUpperCase(),
                          style: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0,
                            color: theme.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          pointsStr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.readexPro(
                            fontSize: 13.0,
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          savingStr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0,
                            color: theme.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Rodapé Conectado de Paginação
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: theme.alternate, width: 1.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalItens > 0
                      ? 'Exibindo ${startIndex + 1}–$endIndex de $totalItens resgates'
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
                      color: paginaSegura > 1
                          ? theme.primary
                          : theme.secondaryText.withValues(alpha: 0.3),
                      onPressed: paginaSegura > 1
                          ? () =>
                              setState(() => _paginaAtual = paginaSegura - 1)
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
                      icon:
                          const Icon(Icons.chevron_right_rounded, size: 20.0),
                      color: paginaSegura < totalPaginas
                          ? theme.primary
                          : theme.secondaryText.withValues(alpha: 0.3),
                      onPressed: paginaSegura < totalPaginas
                          ? () =>
                              setState(() => _paginaAtual = paginaSegura + 1)
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
}
