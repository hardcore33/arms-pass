import '/backend/api_requests/api_calls.dart';
import '/components/modal_adicionar_parceiro/modal_adicionar_parceiro_widget.dart';
import '/components/modal_editar_parceiro/modal_editar_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'listagem_de_parceiros_model.dart';
export 'listagem_de_parceiros_model.dart';

class ListagemDeParceirosWidget extends StatefulWidget {
  const ListagemDeParceirosWidget({
    super.key,
    required this.parceiros,
  });

  final List<dynamic>? parceiros;

  @override
  State<ListagemDeParceirosWidget> createState() =>
      _ListagemDeParceirosWidgetState();
}

class _ListagemDeParceirosWidgetState extends State<ListagemDeParceirosWidget> {
  late ListagemDeParceirosModel _model;
  int _paginaAtual = 1;
  static const int _itensPorPagina = 10;
  String _filtroStatus = 'todos'; // 'todos', 'ativos', 'inativos'

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    // Paginação, ordenação e filtros locais não disparam rebuild do pai nem chamadas de rede.
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeParceirosModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.parceirosLocal = widget.parceiros?.toList().cast<dynamic>() ?? [];
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.switchValue = true;

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didUpdateWidget(covariant ListagemDeParceirosWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.parceiros != widget.parceiros) {
      _model.parceirosLocal = widget.parceiros?.toList().cast<dynamic>() ?? [];
      safeSetState(() {});
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _abrirModalEditar(dynamic item) async {
    _model.segmentosEditar = await ObterSegmentosCall.call();
    _model.nomeDeSegmentosEditar = await actions.obterListaDeSegmentos(
      (_model.segmentosEditar?.jsonBody ?? ''),
    );
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: const AlignmentDirectional(0.0, 0.0)
              .resolve(Directionality.of(context)),
          child: ModalEditarParceiroWidget(
            titulo: 'parceiros',
            dados: item,
            nomeDeSegmentos: _model.nomeDeSegmentosEditar ?? [],
            segmentos: (_model.segmentosEditar?.jsonBody ?? ''),
            nomeDeEstados: functions.obterEstados(),
          ),
        );
      },
    );

    _model.apiResultl4k = await ObterUsuariosCall.call();
    if ((_model.apiResultl4k?.succeeded ?? true)) {
      _model.parceirosLocal = functions.obterParceiros(
              (_model.apiResultl4k?.jsonBody ?? ''))?.toList().cast<dynamic>() ?? [];
      safeSetState(() {});
    }
  }

  List<dynamic> _filtrarEOrdenar(List<dynamic> input) {
    final termoBusca = _model.textController?.text.toLowerCase().trim() ?? '';

    final filtrados = input.where((parceiro) {
      final isActive = getJsonField(parceiro, r'''$.isActive''') == true;

      if (_filtroStatus == 'ativos' && !isActive) return false;
      if (_filtroStatus == 'inativos' && isActive) return false;

      if (termoBusca.isEmpty) return true;

      final fantasia = (getJsonField(parceiro, r'''$.partner.fantasia''') ?? '').toString().toLowerCase();
      final razao = (getJsonField(parceiro, r'''$.partner.razao''') ?? '').toString().toLowerCase();
      final cnpj = (getJsonField(parceiro, r'''$.partner.cnpj''') ?? '').toString().toLowerCase();
      final cidade = (getJsonField(parceiro, r'''$.partner.city''') ?? '').toString().toLowerCase();
      final id = (getJsonField(parceiro, r'''$.partner.id''') ?? '').toString().toLowerCase();

      return fantasia.contains(termoBusca) ||
          razao.contains(termoBusca) ||
          cnpj.contains(termoBusca) ||
          cidade.contains(termoBusca) ||
          id.contains(termoBusca);
    }).toList();

    dynamic keyOf(dynamic parceiro) {
      switch (_model.sortField) {
        case 'id':
          return getJsonField(parceiro, r'''$.partner.id''');
        case 'cnpj':
          return getJsonField(parceiro, r'''$.partner.cnpj''')?.toString() ?? '';
        case 'cidade':
          return getJsonField(parceiro, r'''$.partner.city''')?.toString() ?? '';
        case 'situacao':
          return (getJsonField(parceiro, r'''$.isActive''') == true) ? 1 : 0;
        case 'fantasia':
        default:
          return getJsonField(parceiro, r'''$.partner.fantasia''')?.toString().toLowerCase() ?? '';
      }
    }

    filtrados.sort((a, b) {
      final valorA = keyOf(a);
      final valorB = keyOf(b);
      int comparado;
      if (valorA is num && valorB is num) {
        comparado = valorA.compareTo(valorB);
      } else {
        comparado = valorA.toString().compareTo(valorB.toString());
      }
      return _model.sortAscending ? comparado : -comparado;
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
    final isActive = _model.sortField == field ||
        (_model.sortField == '' && field == 'fantasia');
    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: () {
          safeSetState(() {
            if (_model.sortField == field) {
              _model.sortAscending = !_model.sortAscending;
            } else {
              _model.sortField = field;
              _model.sortAscending = true;
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
                    ? (_model.sortAscending
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded)
                    : Icons.unfold_more_rounded,
                size: 13.0,
                color: isActive
                    ? theme.secondary
                    : theme.secondaryText.withOpacity(0.5),
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
    final listaFiltrada = _filtrarEOrdenar(_model.parceirosLocal);
    final totalItens = listaFiltrada.length;
    final totalPaginas = (totalItens / _itensPorPagina).ceil().clamp(1, 9999);
    final paginaSegura = _paginaAtual.clamp(1, totalPaginas);
    final startIndex = (paginaSegura - 1) * _itensPorPagina;
    final endIndex = (startIndex + _itensPorPagina).clamp(0, totalItens);
    final itemParceiros = totalItens > 0 ? listaFiltrada.sublist(startIndex, endIndex) : <dynamic>[];

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
          // Barra Superior: Contagem, Busca, Filtro de Status e Botão Cadastrar
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rede de Parceiros & Credenciados',
                        style: GoogleFonts.readexPro(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      Text(
                        totalItens > 0
                            ? '$totalItens estabelecimentos encontrados'
                            : 'Nenhum estabelecimento encontrado',
                        style: GoogleFonts.readexPro(
                          fontSize: 12.5,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filtro Status Pill
                Container(
                  height: 40.0,
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: theme.alternate),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFilterChip('Todos', 'todos', theme),
                      _buildFilterChip('Ativos', 'ativos', theme),
                      _buildFilterChip('Inativos', 'inativos', theme),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),

                // Campo de Busca
                SizedBox(
                  width: 260.0,
                  height: 40.0,
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.textController',
                      const Duration(milliseconds: 300),
                      () {
                        setState(() {
                          _paginaAtual = 1;
                        });
                      },
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Buscar parceiro, CNPJ...',
                      hintStyle: GoogleFonts.readexPro(
                        fontSize: 12.5,
                        color: theme.secondaryText.withOpacity(0.7),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
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
                const SizedBox(width: 12.0),

                // Botão Cadastrar
                FFButtonWidget(
                  onPressed: () async {
                    _model.segmentos = await ObterSegmentosCall.call();
                    _model.nomeDeSegmentos = await actions.obterListaDeSegmentos(
                      (_model.segmentos?.jsonBody ?? ''),
                    );
                    await showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return Dialog(
                          elevation: 0,
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          alignment: const AlignmentDirectional(0.0, 0.0)
                              .resolve(Directionality.of(context)),
                          child: ModalAdicionarParceiroWidget(
                            titulo: 'parceiro',
                            nomeDeSegmentos: _model.nomeDeSegmentos ?? [],
                            segmentos: (_model.segmentos?.jsonBody ?? ''),
                            nomeDeEstados: functions.obterEstados(),
                          ),
                        );
                      },
                    );

                    _model.apiResultl4kl = await ObterUsuariosCall.call();
                    if ((_model.apiResultl4kl?.succeeded ?? true)) {
                      _model.parceirosLocal = functions.obterParceiros(
                              (_model.apiResultl4kl?.jsonBody ?? ''))?.toList().cast<dynamic>() ?? [];
                      safeSetState(() {});
                    }
                  },
                  text: 'Cadastrar',
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: theme.secondary,
                    size: 18.0,
                  ),
                  options: FFButtonOptions(
                    height: 40.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    color: theme.primary,
                    textStyle: GoogleFonts.readexPro(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ],
            ),
          ),

          // Cabeçalho da Tabela
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
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
                  width: 65.0,
                  child: _buildSortableHeader(context, 'id', 'ID', theme, alignment: Alignment.center),
                ),
                Expanded(
                  flex: 5,
                  child: _buildSortableHeader(context, 'fantasia', 'ESTABELECIMENTO / PARCEIRO', theme),
                ),
                Expanded(
                  flex: 3,
                  child: _buildSortableHeader(context, 'cnpj', 'CNPJ', theme),
                ),
                Expanded(
                  flex: 3,
                  child: _buildSortableHeader(context, 'cidade', 'CIDADE / UF', theme),
                ),
                SizedBox(
                  width: 110.0,
                  child: _buildSortableHeader(context, 'situacao', 'SITUAÇÃO', theme, alignment: Alignment.center),
                ),
                const SizedBox(
                  width: 80.0,
                  child: Text(
                    'AÇÕES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista dos Parceiros
          if (itemParceiros.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded, size: 36.0, color: theme.secondaryText.withOpacity(0.5)),
                    const SizedBox(height: 8.0),
                    Text(
                      'Nenhum parceiro encontrado com os filtros selecionados.',
                      style: GoogleFonts.readexPro(color: theme.secondaryText, fontSize: 13.5),
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
              itemCount: itemParceiros.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.0,
                thickness: 1.0,
                color: theme.alternate,
              ),
              itemBuilder: (context, index) {
                final item = itemParceiros[index];
                final id = getJsonField(item, r'''$.partner.id''')?.toString() ?? '';
                final fantasia = (getJsonField(item, r'''$.partner.fantasia''') ?? getJsonField(item, r'''$.partner.razao''') ?? 'Parceiro').toString();
                final razao = (getJsonField(item, r'''$.partner.razao''') ?? '').toString();
                final photo = getJsonField(item, r'''$.partner.photo''')?.toString() ?? '';
                final cnpj = getJsonField(item, r'''$.partner.cnpj''')?.toString() ?? '';
                final city = getJsonField(item, r'''$.partner.city''')?.toString() ?? '';
                final state = getJsonField(item, r'''$.partner.state''')?.toString() ?? '';
                final isActive = getJsonField(item, r'''$.isActive''') == true;

                return InkWell(
                  onTap: () => _abrirModalEditar(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Row(
                      children: [
                        // ID
                        SizedBox(
                          width: 65.0,
                          child: Text(
                            id,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.readexPro(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryText,
                            ),
                          ),
                        ),

                        // Estabelecimento (Logo + Nome + Razão)
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Container(
                                width: 36.0,
                                height: 36.0,
                                decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(0.06),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: theme.secondary.withOpacity(0.3), width: 1.0),
                                ),
                                child: photo.isNotEmpty && photo != 'null'
                                    ? ClipOval(
                                        child: Image.network(
                                          photo,
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      fantasia,
                                      style: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.0,
                                        color: theme.primaryText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (razao.isNotEmpty && razao != fantasia)
                                      Text(
                                        razao,
                                        style: GoogleFonts.readexPro(
                                          fontSize: 11.0,
                                          color: theme.secondaryText,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    Builder(
                                      builder: (context) {
                                        final proposal = getJsonField(item, r'''$.partner.proposal''')?.toString().trim() ?? '';
                                        if (proposal.isNotEmpty && proposal != 'off' && proposal != 'null') {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 3.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.local_offer_outlined, size: 11.0, color: Color(0xFF00C853)),
                                                const SizedBox(width: 3.0),
                                                Flexible(
                                                  child: Text(
                                                    proposal,
                                                    style: GoogleFonts.readexPro(
                                                      fontSize: 11.0,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF00C853),
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      // CNPJ
                      Expanded(
                        flex: 3,
                        child: Text(
                          cnpj.isNotEmpty ? cnpj : '—',
                          style: GoogleFonts.readexPro(
                            fontSize: 12.5,
                            color: theme.primaryText,
                          ),
                        ),
                      ),

                      // Cidade / UF
                      Expanded(
                        flex: 3,
                        child: Text(
                          city.isNotEmpty ? (state.isNotEmpty ? '$city - $state' : city) : '—',
                          style: GoogleFonts.readexPro(
                            fontSize: 12.5,
                            color: theme.secondaryText,
                          ),
                        ),
                      ),

                      // Situação
                      SizedBox(
                        width: 110.0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0x2000C853) : const Color(0x15909090),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Text(
                              isActive ? 'ATIVO' : 'INATIVO',
                              style: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 11.0,
                                color: isActive ? const Color(0xFF00C853) : theme.secondaryText,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Ações (Editar e Excluir)
                      SizedBox(
                        width: 80.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                _model.segmentosEditar = await ObterSegmentosCall.call();
                                _model.nomeDeSegmentosEditar = await actions.obterListaDeSegmentos(
                                  (_model.segmentosEditar?.jsonBody ?? ''),
                                );
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment: const AlignmentDirectional(0.0, 0.0)
                                          .resolve(Directionality.of(context)),
                                      child: ModalEditarParceiroWidget(
                                        titulo: 'parceiros',
                                        dados: item,
                                        nomeDeSegmentos: _model.nomeDeSegmentosEditar ?? [],
                                        segmentos: (_model.segmentosEditar?.jsonBody ?? ''),
                                        nomeDeEstados: functions.obterEstados(),
                                      ),
                                    );
                                  },
                                );

                                _model.apiResultl4k = await ObterUsuariosCall.call();
                                if ((_model.apiResultl4k?.succeeded ?? true)) {
                                  _model.parceirosLocal = functions.obterParceiros(
                                          (_model.apiResultl4k?.jsonBody ?? ''))?.toList().cast<dynamic>() ?? [];
                                  safeSetState(() {});
                                }
                              },
                              borderRadius: BorderRadius.circular(6.0),
                              child: Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: theme.secondary,
                                  size: 16.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            InkWell(
                              onTap: () async {
                                final confirm = await showConfirmationDialog(
                                  context,
                                  title: 'Excluir parceiro',
                                  message: 'Tem certeza que deseja excluir o parceiro "$fantasia"? Essa ação não pode ser desfeita.',
                                  confirmText: 'Excluir',
                                );
                                if (!confirm) return;

                                _model.apiResulttxp = await DeletarParceiroCall.call(
                                  customerId: getJsonField(item, r'''$.id''').toString(),
                                );

                                if ((_model.apiResulttxp?.succeeded ?? true)) {
                                  _model.inativandoParceiro = await ObterUsuariosCall.call();
                                  _model.parceirosLocal = functions.obterParceiros(
                                          (_model.inativandoParceiro?.jsonBody ?? ''))?.toList().cast<dynamic>() ?? [];
                                  safeSetState(() {});
                                }
                              },
                              borderRadius: BorderRadius.circular(6.0),
                              child: Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: theme.error.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  color: theme.error,
                                  size: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            ),

          // Rodapé Conectado de Paginação
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
                      color: paginaSegura > 1
                          ? theme.primary
                          : theme.secondaryText.withOpacity(0.3),
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
                      color: paginaSegura < totalPaginas
                          ? theme.primary
                          : theme.secondaryText.withOpacity(0.3),
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

  Widget _buildFilterChip(String label, String value, FlutterFlowTheme theme) {
    final isSelected = _filtroStatus == value;
    return InkWell(
      onTap: () {
        setState(() {
          _filtroStatus = value;
          _paginaAtual = 1;
        });
      },
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          label,
          style: GoogleFonts.readexPro(
            fontSize: 12.0,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? theme.secondary : theme.secondaryText,
          ),
        ),
      ),
    );
  }
}
