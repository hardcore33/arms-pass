import '/backend/api_requests/api_calls.dart';
import '/components/modal_adicionar_desconto/modal_adicionar_desconto_widget.dart';
import '/components/modal_alterar_desconto/modal_alterar_desconto_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'listagem_de_cupom_model.dart';
export 'listagem_de_cupom_model.dart';

class ListagemDeCupomWidget extends StatefulWidget {
  const ListagemDeCupomWidget({
    super.key,
    required this.cupons,
  });

  final List<dynamic>? cupons;

  @override
  State<ListagemDeCupomWidget> createState() => _ListagemDeCupomWidgetState();
}

class _ListagemDeCupomWidgetState extends State<ListagemDeCupomWidget> {
  late ListagemDeCupomModel _model;
  int _paginaAtual = 1;
  static const int _itensPorPagina = 10;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    // Paginação, ordenação e filtros locais não disparam rebuild do pai nem chamadas de rede.
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeCupomModel());
    _model.cuponsLocal = widget.cupons?.toList().cast<dynamic>() ?? [];

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void didUpdateWidget(covariant ListagemDeCupomWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cupons != widget.cupons) {
      _model.cuponsLocal = widget.cupons?.toList().cast<dynamic>() ?? [];
      safeSetState(() {});
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  List<String> _distinctSegmentos() {
    final nomes = <String>{};
    for (final cupom in _model.cuponsLocal) {
      final nome = getJsonField(cupom, r'''$.segment.name''')?.toString();
      if (nome != null && nome.isNotEmpty && nome != 'null') {
        nomes.add(nome);
      }
    }
    final lista = nomes.toList()..sort();
    return lista;
  }

  List<dynamic> _filtrarEOrdenar(List<dynamic> input) {
    final termoBusca = _model.textController?.text.toLowerCase().trim() ?? '';
    final termoNumerico = termoBusca.replaceAll(RegExp(r'[^0-9]'), '');

    final filtrados = input.where((cupom) {
      // Filtro por Segmento
      if (_model.segmentoFiltro != null && _model.segmentoFiltro!.isNotEmpty) {
        final nomeSeg = getJsonField(cupom, r'''$.segment.name''')?.toString();
        if (nomeSeg != _model.segmentoFiltro) return false;
      }

      if (termoBusca.isEmpty) return true;

      final fantasia = (getJsonField(cupom, r'''$.partner.fantasia''') ?? '').toString().toLowerCase();
      final razao = (getJsonField(cupom, r'''$.partner.razao''') ?? '').toString().toLowerCase();
      final cnpj = (getJsonField(cupom, r'''$.partner.cnpj''') ?? '').toString().toLowerCase();
      final cnpjNumerico = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
      final descricao = (getJsonField(cupom, r'''$.description''') ?? '').toString().toLowerCase();
      final id = (getJsonField(cupom, r'''$.id''') ?? '').toString().toLowerCase();
      final segName = (getJsonField(cupom, r'''$.segment.name''') ?? '').toString().toLowerCase();

      final bateNome = fantasia.contains(termoBusca) || razao.contains(termoBusca);
      final bateCnpj = cnpj.contains(termoBusca) || (termoNumerico.isNotEmpty && cnpjNumerico.contains(termoNumerico));
      final bateDescricao = descricao.contains(termoBusca);
      final bateId = id.contains(termoBusca);
      final bateSeg = segName.contains(termoBusca);

      return bateNome || bateCnpj || bateDescricao || bateId || bateSeg;
    }).toList();

    dynamic keyOf(dynamic cupom) {
      switch (_model.sortField) {
        case 'id':
          return getJsonField(cupom, r'''$.id''');
        case 'partner':
          return getJsonField(cupom, r'''$.partner.fantasia''')?.toString().toLowerCase() ?? '';
        case 'segment':
          return getJsonField(cupom, r'''$.segment.name''')?.toString().toLowerCase() ?? '';
        case 'discount':
          return getJsonField(cupom, r'''$.discount''') ?? 0;
        case 'validity':
          return getJsonField(cupom, r'''$.validity''')?.toString() ?? '';
        case 'description':
        default:
          return getJsonField(cupom, r'''$.description''')?.toString().toLowerCase() ?? '';
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
        (_model.sortField == '' && field == 'description');
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

  Future<void> _abrirModalEditar(BuildContext context, dynamic cupom) async {
    _model.listaParceiros = await ObterParceirosCall.call();
    _model.listaDeNomesDeParceiros = await actions.obterListaDeParceiros(
      (_model.listaParceiros?.jsonBody ?? ''),
    );
    _model.segmentos = await ObterSegmentosCall.call();
    _model.listaDeNomesDeSegmentos = await actions.obterListaDeSegmentos(
      (_model.segmentos?.jsonBody ?? ''),
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
          child: ModalAlterarDescontoWidget(
            titulo: 'cupom',
            desconto: cupom,
            nomeParceiros: _model.listaDeNomesDeParceiros ?? [],
            parceiros: (_model.listaParceiros?.jsonBody ?? ''),
            nomeSegmentos: _model.listaDeNomesDeSegmentos ?? [],
            segmentos: (_model.segmentos?.jsonBody ?? ''),
          ),
        );
      },
    );

    _model.apiResult1bg = await ObterCuponsCall.call();
    if ((_model.apiResult1bg?.succeeded ?? true)) {
      _model.cuponsLocal = (_model.apiResult1bg?.jsonBody ?? []).toList().cast<dynamic>();
      safeSetState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final listaFiltrada = _filtrarEOrdenar(_model.cuponsLocal);
    final totalItens = listaFiltrada.length;
    final totalPaginas = (totalItens / _itensPorPagina).ceil().clamp(1, 9999);
    final paginaSegura = _paginaAtual.clamp(1, totalPaginas);
    final startIndex = (paginaSegura - 1) * _itensPorPagina;
    final endIndex = (startIndex + _itensPorPagina).clamp(0, totalItens);
    final itemCupons = totalItens > 0 ? listaFiltrada.sublist(startIndex, endIndex) : <dynamic>[];

    final segmentosDisponiveis = _distinctSegmentos();

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
          // Barra Superior: Contagem, Filtro por Segmento, Busca por Nome/CNPJ e Botão Cadastrar
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gestão de Cupons & Benefícios',
                        style: GoogleFonts.readexPro(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      Text(
                        totalItens > 0
                            ? '$totalItens benefícios cadastrados'
                            : 'Nenhum benefício encontrado',
                        style: GoogleFonts.readexPro(
                          fontSize: 12.5,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filtro por Segmento Dropdown
                Container(
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: theme.alternate),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _model.segmentoFiltro,
                      menuMaxHeight: 280.0,
                      dropdownColor: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                      icon: Icon(Icons.filter_list_rounded, size: 18.0, color: theme.secondary),
                      hint: Text(
                        'Todos os Segmentos',
                        style: GoogleFonts.readexPro(fontSize: 12.5, color: theme.secondaryText),
                      ),
                      style: GoogleFonts.readexPro(fontSize: 12.5, color: theme.primaryText),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Todos os Segmentos', style: GoogleFonts.readexPro(fontSize: 12.5, color: theme.primaryText)),
                        ),
                        ...segmentosDisponiveis.map((seg) {
                          return DropdownMenuItem<String?>(
                            value: seg,
                            child: Text(seg, style: GoogleFonts.readexPro(fontSize: 12.5, color: theme.primaryText)),
                          );
                        }),
                      ],
                      onChanged: (novo) {
                        setState(() {
                          _model.segmentoFiltro = novo;
                          _paginaAtual = 1;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),

                // Campo de Busca Assertiva (Parceiro / CNPJ / Descrição)
                SizedBox(
                  width: 280.0,
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
                      hintText: 'Buscar parceiro, CNPJ, regra...',
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

                // Botão Cadastrar Cupom
                FFButtonWidget(
                  onPressed: () async {
                    _model.listaParceiros = await ObterParceirosCall.call();
                    _model.listaDeNomesDeParceiros = await actions.obterListaDeParceiros(
                      (_model.listaParceiros?.jsonBody ?? ''),
                    );
                    _model.segmentos = await ObterSegmentosCall.call();
                    _model.listaDeNomesDeSegmentos = await actions.obterListaDeSegmentos(
                      (_model.segmentos?.jsonBody ?? ''),
                    );

                    await showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return Dialog(
                          elevation: 0,
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                          child: ModalAdicionarDescontoWidget(
                            titulo: 'cupom',
                            nomeParceiros: _model.listaDeNomesDeParceiros ?? [],
                            parceiros: (_model.listaParceiros?.jsonBody ?? ''),
                            nomeSegmentos: _model.listaDeNomesDeSegmentos ?? [],
                            segmentos: (_model.segmentos?.jsonBody ?? ''),
                          ),
                        );
                      },
                    );

                    _model.apiResult1bg = await ObterCuponsCall.call();
                    if ((_model.apiResult1bg?.succeeded ?? true)) {
                      _model.cuponsLocal = (_model.apiResult1bg?.jsonBody ?? []).toList().cast<dynamic>();
                      safeSetState(() {});
                    }
                  },
                  text: 'Cadastrar Cupom',
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
                  width: 55.0,
                  child: _buildSortableHeader(context, 'id', 'ID', theme, alignment: Alignment.center),
                ),
                Expanded(
                  flex: 5,
                  child: _buildSortableHeader(context, 'partner', 'PARCEIRO & CNPJ', theme),
                ),
                Expanded(
                  flex: 3,
                  child: _buildSortableHeader(context, 'segment', 'SEGMENTO', theme),
                ),
                Expanded(
                  flex: 5,
                  child: _buildSortableHeader(context, 'description', 'BENEFÍCIO / REGRA', theme),
                ),
                SizedBox(
                  width: 100.0,
                  child: _buildSortableHeader(context, 'discount', 'DESCONTO', theme, alignment: Alignment.center),
                ),
                SizedBox(
                  width: 110.0,
                  child: _buildSortableHeader(context, 'validity', 'VALIDADE', theme, alignment: Alignment.center),
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

          // Lista dos Cupons
          if (itemCupons.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 56.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: BoxDecoration(
                        color: theme.secondary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search_off_rounded,
                        size: 32.0,
                        color: theme.secondary,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Nenhum benefício encontrado',
                      style: GoogleFonts.readexPro(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      _model.textController?.text.isNotEmpty == true && _model.segmentoFiltro != null
                          ? 'Nenhum cupom para "${_model.textController?.text}" na categoria "${_model.segmentoFiltro}".'
                          : (_model.textController?.text.isNotEmpty == true
                              ? 'Nenhum cupom encontrado para "${_model.textController?.text}".'
                              : (_model.segmentoFiltro != null
                                  ? 'Nenhum cupom cadastrado na categoria "${_model.segmentoFiltro}".'
                                  : 'Nenhum cupom cadastrado no momento.')),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.readexPro(
                        color: theme.secondaryText,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 10.0,
                      alignment: WrapAlignment.center,
                      children: [
                        if (_model.segmentoFiltro != null)
                          FFButtonWidget(
                            onPressed: () {
                              setState(() {
                                _model.segmentoFiltro = null;
                                _paginaAtual = 1;
                              });
                            },
                            text: 'Buscar em todas as categorias',
                            icon: Icon(Icons.apps_rounded, size: 16.0, color: theme.primary),
                            options: FFButtonOptions(
                              height: 38.0,
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              color: theme.secondary,
                              textStyle: GoogleFonts.readexPro(
                                color: theme.primary,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        if ((_model.textController?.text.isNotEmpty ?? false) || _model.segmentoFiltro != null)
                          FFButtonWidget(
                            onPressed: () {
                              _model.textController?.clear();
                              setState(() {
                                _model.segmentoFiltro = null;
                                _paginaAtual = 1;
                              });
                            },
                            text: 'Limpar busca e filtros',
                            icon: Icon(Icons.filter_alt_off_rounded, size: 16.0, color: theme.primaryText),
                            options: FFButtonOptions(
                              height: 38.0,
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              color: theme.primaryBackground,
                              textStyle: GoogleFonts.readexPro(
                                color: theme.primaryText,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                              elevation: 0,
                              borderSide: BorderSide(color: theme.alternate, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: itemCupons.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final id = getJsonField(item, r'''$.id''')?.toString() ?? '';
                final fantasia = (getJsonField(item, r'''$.partner.fantasia''') ?? 'Parceiro').toString();
                final cnpj = getJsonField(item, r'''$.partner.cnpj''')?.toString() ?? '';
                final partnerPhoto = getJsonField(item, r'''$.partner.photo''')?.toString() ?? '';
                final segmentName = getJsonField(item, r'''$.segment.name''')?.toString() ?? 'Geral';
                final segmentPhoto = getJsonField(item, r'''$.segment.photo''')?.toString() ?? '';
                final description = getJsonField(item, r'''$.description''')?.toString() ?? '';
                final discount = getJsonField(item, r'''$.discount''')?.toString() ?? '0';
                final validityRaw = getJsonField(item, r'''$.validity''')?.toString() ?? '';
                final validityFormatted = functions.formataDataDeExibicao(validityRaw);
                final rules = (getJsonField(item, r'''$.rules''') ?? '').toString();

                final isArmsPro = rules.contains('[ARMS_PRO]') || description.contains('[ARMS_PRO]');
                final matchLimite = RegExp(r'\[LIMITE:(\d+)\]').firstMatch(rules) ?? RegExp(r'\[LIMITE:(\d+)\]').firstMatch(description);
                final limiteStr = matchLimite != null ? matchLimite.group(1) : null;
                final cleanDesc = description.replaceAll('[ARMS_PRO]', '').replaceAll(RegExp(r'\[LIMITE:\d+\]'), '').trim();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index > 0)
                      Divider(height: 1.0, thickness: 1.0, color: theme.alternate),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      child: Row(
                        children: [
                          // ID
                          SizedBox(
                            width: 55.0,
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

                          // Parceiro (Foto + Nome Fantasia + CNPJ)
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: theme.primary.withValues(alpha: 0.06),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: theme.secondary.withValues(alpha: 0.3), width: 1.0),
                                  ),
                                  child: partnerPhoto.isNotEmpty && partnerPhoto != 'null'
                                      ? ClipOval(
                                          child: Image.network(
                                            partnerPhoto,
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
                                      if (cnpj.isNotEmpty && cnpj != 'null')
                                        Text(
                                          'CNPJ: $cnpj',
                                          style: GoogleFonts.readexPro(
                                            fontSize: 11.0,
                                            color: theme.secondaryText,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Segmento
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: theme.primaryBackground,
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(color: theme.alternate),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (segmentPhoto.isNotEmpty && segmentPhoto != 'null')
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4.0),
                                          child: Image.network(
                                            segmentPhoto,
                                            width: 14.0,
                                            height: 14.0,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.category_outlined,
                                              size: 13.0,
                                              color: theme.secondary,
                                            ),
                                          ),
                                        )
                                      else
                                        Icon(Icons.category_outlined, size: 13.0, color: theme.secondary),
                                      const SizedBox(width: 5.0),
                                      Flexible(
                                        child: Text(
                                          segmentName,
                                          style: GoogleFonts.readexPro(
                                            fontSize: 11.5,
                                            color: theme.primaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Benefício / Regra
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  cleanDesc.isNotEmpty ? cleanDesc : '—',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 12.5,
                                    color: theme.primaryText,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (isArmsPro || limiteStr != null) ...[
                                  const SizedBox(height: 4.0),
                                  Wrap(
                                    spacing: 6.0,
                                    runSpacing: 4.0,
                                    children: [
                                      if (isArmsPro)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: theme.secondary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4.0),
                                            border: Border.all(color: theme.secondary, width: 0.8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.star_rounded, color: theme.secondary, size: 12.0),
                                              const SizedBox(width: 3.0),
                                              Text(
                                                'Arms Pró VIP',
                                                style: GoogleFonts.readexPro(
                                                  color: theme.secondary,
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (limiteStr != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: theme.alternate.withValues(alpha: 0.3),
                                            borderRadius: BorderRadius.circular(4.0),
                                            border: Border.all(color: theme.alternate, width: 0.8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.inventory_2_outlined, color: theme.secondaryText, size: 11.0),
                                              const SizedBox(width: 3.0),
                                              Text(
                                                'Estoque: $limiteStr un.',
                                                style: GoogleFonts.readexPro(
                                                  color: theme.secondaryText,
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Desconto
                          SizedBox(
                            width: 100.0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: theme.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(color: theme.secondary.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  '$discount%',
                                  style: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: theme.primaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Validade
                          SizedBox(
                            width: 110.0,
                            child: Text(
                              (validityFormatted != null && validityFormatted.isNotEmpty)
                                  ? validityFormatted
                                  : '—',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.readexPro(
                                fontSize: 12.0,
                                color: theme.secondaryText,
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
                                  onTap: () => _abrirModalEditar(context, item),
                                  borderRadius: BorderRadius.circular(6.0),
                                  child: Container(
                                    width: 30.0,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      color: theme.primary.withValues(alpha: 0.06),
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
                                      title: 'Excluir benefício',
                                      message: 'Tem certeza que deseja excluir o benefício "$description"? Essa ação não pode ser desfeita.',
                                      confirmText: 'Excluir',
                                    );
                                    if (!confirm) return;

                                    _model.apiResult8yh = await DeletarCuponsCall.call(
                                      idDiscount: id,
                                    );

                                    setState(() {
                                      _model.cuponsLocal.removeWhere((c) => getJsonField(c, r'''$.id''')?.toString() == id);
                                    });

                                    if (mounted) {
                                      showSuccessToast(
                                        context,
                                        'Cupom excluído com sucesso!',
                                        title: 'Cupom Excluído',
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(6.0),
                                  child: Container(
                                    width: 30.0,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      color: theme.error.withValues(alpha: 0.08),
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
                  ],
                );
              }).toList(),
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
                      ? 'Exibindo ${startIndex + 1}–$endIndex de $totalItens cupons'
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
}
