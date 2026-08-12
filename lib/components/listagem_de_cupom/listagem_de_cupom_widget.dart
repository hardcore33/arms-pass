import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/components/modal_adicionar_desconto/modal_adicionar_desconto_widget.dart';
import '/components/modal_alterar_desconto/modal_alterar_desconto_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeCupomModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.cuponsLocal = widget!.cupons!.toList().cast<dynamic>();
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  List<String> _distinctSegmentos() {
    final nomes = <String>{};
    for (final cupom in widget!.cupons ?? []) {
      final nome = getJsonField(cupom, r'''$.segment.name''')?.toString();
      if (nome != null && nome.isNotEmpty) {
        nomes.add(nome);
      }
    }
    final lista = nomes.toList()..sort();
    return lista;
  }

  List<dynamic> _applyFilterAndSort(List<dynamic> input) {
    var result = input.toList();

    if (_model.segmentoFiltro != null) {
      result = result.where((cupom) {
        final nome = getJsonField(cupom, r'''$.segment.name''')?.toString();
        return nome == _model.segmentoFiltro;
      }).toList();
    }

    if (_model.sortField == 'partner') {
      // Ranking por quantidade de cupons do parceiro, calculado sobre o
      // conjunto já filtrado (respeita o filtro de segmento ativo).
      final Map<String, int> contagemPorParceiro = {};
      for (final cupom in result) {
        final id = getJsonField(cupom, r'''$.partner.id''')?.toString() ??
            getJsonField(cupom, r'''$.partner.fantasia''')?.toString() ??
            '';
        contagemPorParceiro[id] = (contagemPorParceiro[id] ?? 0) + 1;
      }
      int rankOf(dynamic cupom) {
        final id = getJsonField(cupom, r'''$.partner.id''')?.toString() ??
            getJsonField(cupom, r'''$.partner.fantasia''')?.toString() ??
            '';
        return contagemPorParceiro[id] ?? 0;
      }

      result.sort((a, b) {
        // Maior ranking (mais cupons) primeiro por padrão.
        final comparado = rankOf(b).compareTo(rankOf(a));
        return _model.sortAscending ? comparado : -comparado;
      });
    } else if (_model.sortField.isNotEmpty) {
      dynamic keyOf(dynamic cupom) {
        switch (_model.sortField) {
          case 'id':
            return getJsonField(cupom, r'''$.id''');
          case 'description':
            return getJsonField(cupom, r'''$.description''')?.toString() ?? '';
          case 'discount':
            return getJsonField(cupom, r'''$.discount''');
          case 'validity':
            return getJsonField(cupom, r'''$.validity''')?.toString() ?? '';
          default:
            return 0;
        }
      }

      result.sort((a, b) {
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
    }

    return result;
  }

  Widget _buildSortableHeader(
    BuildContext context,
    String field,
    Widget label, {
    String? tooltip,
  }) {
    final isActive = _model.sortField == field;
    final header = InkWell(
      onTap: () {
        safeSetState(() {
          if (_model.sortField == field) {
            _model.sortAscending = !_model.sortAscending;
          } else {
            _model.sortField = field;
            _model.sortAscending = true;
          }
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          label,
          const SizedBox(width: 4.0),
          Icon(
            isActive
                ? (_model.sortAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded)
                : Icons.unfold_more_rounded,
            size: 14.0,
            color: isActive
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
          ),
        ],
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip, child: header) : header;
  }

  Future<void> _openEditModal(
    BuildContext context,
    dynamic itemCuponsItem,
  ) async {
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
          alignment: AlignmentDirectional(0.0, 0.0)
              .resolve(Directionality.of(context)),
          child: ModalAlterarDescontoWidget(
            titulo: 'cupom',
            desconto: itemCuponsItem,
            nomeParceiros: _model.listaDeNomesDeParceiros!,
            parceiros: (_model.listaParceiros?.jsonBody ?? ''),
            nomeSegmentos: _model.listaDeNomesDeSegmentos!,
            segmentos: (_model.segmentos?.jsonBody ?? ''),
          ),
        );
      },
    );

    _model.apiResult1bg = await ObterCuponsCall.call();
    if ((_model.apiResult1bg?.succeeded ?? true)) {
      _model.cuponsLocal =
          (_model.apiResult1bg?.jsonBody ?? '').toList().cast<dynamic>();
      safeSetState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
              child: Material(
                color: Colors.transparent,
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      FlutterFlowTheme.of(context).designToken.radius.md),
                ),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(
                        FlutterFlowTheme.of(context).designToken.radius.md),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            35.0, 30.0, 0.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.textController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.cuponsFiltrados =
                                    await actions.filtrarPorNome(
                                  widget!.cupons!.toList(),
                                  _model.textController.text,
                                  6,
                                  true,
                                );
                                _model.cuponsLocal = _model.cuponsFiltrados!
                                    .toList()
                                    .cast<dynamic>();
                                safeSetState(() {});

                                safeSetState(() {});
                              },
                            ),
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Procurar',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF909090),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFCCCCCC),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 10.0, 20.0, 10.0),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Color(0xFF9A9A9A),
                                size: 21.0,
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            cursorColor:
                                FlutterFlowTheme.of(context).primaryText,
                            validator: _model.textControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 30.0, 0.0, 0.0),
                        child: Container(
                          width: 170.0,
                          height: 44.0,
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(24.0),
                            border: Border.all(
                              color: Color(0xFFCCCCCC),
                              width: 1.0,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: _model.segmentoFiltro,
                              isExpanded: true,
                              isDense: true,
                              borderRadius: BorderRadius.circular(
                                  FlutterFlowTheme.of(context)
                                      .designToken
                                      .radius
                                      .sm),
                              dropdownColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 3,
                              hint: Text(
                                'Segmento',
                                overflow: TextOverflow.ellipsis,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.readexPro(),
                                      color: Color(0xFF909090),
                                    ),
                              ),
                              icon: Icon(
                                Icons.filter_list_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 18.0,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.readexPro(),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                              selectedItemBuilder: (context) => [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Text(
                                    'Todos os segmentos',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                ..._distinctSegmentos().map(
                                  (segmento) => Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Text(
                                      segmento,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                              items: [
                                DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text('Todos os segmentos'),
                                ),
                                ..._distinctSegmentos().map(
                                  (segmento) => DropdownMenuItem<String?>(
                                    value: segmento,
                                    child: Text(segmento),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                safeSetState(() {
                                  _model.segmentoFiltro = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Builder(
                        builder: (context) => Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 0.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              _model.listaParceiros =
                                  await ObterParceirosCall.call();

                              _model.listaDeNomesDeParceiros =
                                  await actions.obterListaDeParceiros(
                                (_model.listaParceiros?.jsonBody ?? ''),
                              );
                              _model.segmentos =
                                  await ObterSegmentosCall.call();

                              _model.listaDeNomesDeSegmentos =
                                  await actions.obterListaDeSegmentos(
                                (_model.segmentos?.jsonBody ?? ''),
                              );
                              await showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: ModalAdicionarDescontoWidget(
                                      titulo: 'cupom',
                                      nomeParceiros:
                                          _model.listaDeNomesDeParceiros!,
                                      parceiros:
                                          (_model.listaParceiros?.jsonBody ??
                                              ''),
                                      nomeSegmentos:
                                          _model.listaDeNomesDeSegmentos!,
                                      segmentos:
                                          (_model.segmentos?.jsonBody ?? ''),
                                    ),
                                  );
                                },
                              );

                              _model.apiResult1bg =
                                  await ObterCuponsCall.call();

                              if ((_model.apiResult1bg?.succeeded ?? true)) {
                                _model.cuponsLocal =
                                    (_model.apiResult1bg?.jsonBody ?? '')
                                        .toList()
                                        .cast<dynamic>();
                                safeSetState(() {});
                              }

                              safeSetState(() {});
                            },
                            text: 'Cadastrar',
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              size: 18.0,
                            ),
                            options: FFButtonOptions(
                              height: 44.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 0.0, 20.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 8.0, 0.0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 1.0,
                              borderRadius: BorderRadius.circular(
                                  FlutterFlowTheme.of(context)
                                      .designToken
                                      .radius
                                      .sm),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(
                          FlutterFlowTheme.of(context).designToken.radius.sm),
                    ),
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: _buildSortableHeader(
                              context,
                              'id',
                              wrapWithModel(
                                model: _model.fonteTituloTabelaModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: FonteTituloTabelaWidget(
                                  text: 'ID',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: _buildSortableHeader(
                              context,
                              'description',
                              wrapWithModel(
                                model: _model.fonteTituloTabelaModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: FonteTituloTabelaWidget(
                                  text: 'DESCRIÇÃO',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: _buildSortableHeader(
                              context,
                              'partner',
                              wrapWithModel(
                                model: _model.fonteTituloTabelaModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: FonteTituloTabelaWidget(
                                  text: 'PARCEIRO',
                                ),
                              ),
                              tooltip:
                                  'Ordenar por ranking (parceiro com mais cupons ativos primeiro, considerando o filtro de segmento aplicado)',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: FonteTituloTabelaWidget(
                              text: 'SEGMENTO',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: _buildSortableHeader(
                              context,
                              'discount',
                              wrapWithModel(
                                model: _model.fonteTituloTabelaModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: FonteTituloTabelaWidget(
                                  text: 'DESCONTO',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: _buildSortableHeader(
                              context,
                              'validity',
                              wrapWithModel(
                                model: _model.fonteTituloTabelaModel5,
                                updateCallback: () => safeSetState(() {}),
                                child: FonteTituloTabelaWidget(
                                  text: 'VALIDADE',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.56,
                  decoration: BoxDecoration(),
                  child: Builder(
                    builder: (context) {
                      final itemCupons =
                          _applyFilterAndSort(_model.cuponsLocal);

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: itemCupons.length,
                        itemBuilder: (context, itemCuponsIndex) {
                          final itemCuponsItem = itemCupons[itemCuponsIndex];
                          final partnerPhoto = getJsonField(
                            itemCuponsItem,
                            r'''$.partner.photo''',
                          )?.toString();
                          final segmentName = getJsonField(
                            itemCuponsItem,
                            r'''$.segment.name''',
                          )?.toString();
                          final segmentPhoto = getJsonField(
                            itemCuponsItem,
                            r'''$.segment.photo''',
                          )?.toString();
                          final canDelete = getJsonField(
                                itemCuponsItem,
                                r'''$.canDelete''',
                              ) !=
                              false;
                          return Container(
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 10.0),
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 16.0, 12.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(
                                  FlutterFlowTheme.of(context)
                                      .designToken
                                      .radius
                                      .sm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: wrapWithModel(
                                      model: _model.fonteDadosTabelaModels1
                                          .getModel(
                                        itemCuponsItem.toString(),
                                        itemCuponsIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: FonteDadosTabelaWidget(
                                        key: Key(
                                          'Key6bl_${itemCuponsItem.toString()}',
                                        ),
                                        text: getJsonField(
                                          itemCuponsItem,
                                          r'''$.id''',
                                        ).toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: wrapWithModel(
                                      model: _model.fonteDadosTabelaModels2
                                          .getModel(
                                        itemCuponsItem.toString(),
                                        itemCuponsIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: FonteDadosTabelaWidget(
                                        key: Key(
                                          'Keynue_${itemCuponsItem.toString()}',
                                        ),
                                        text: getJsonField(
                                          itemCuponsItem,
                                          r'''$.description''',
                                        ).toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondary
                                              .withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                              FlutterFlowTheme.of(context)
                                                  .designToken
                                                  .radius
                                                  .sm),
                                        ),
                                        child: partnerPhoto != null &&
                                                partnerPhoto.isNotEmpty &&
                                                partnerPhoto != 'null'
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .designToken
                                                            .radius
                                                            .sm),
                                                child: Image.network(
                                                  partnerPhoto,
                                                  width: 40.0,
                                                  height: 40.0,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Icon(
                                                    Icons.storefront_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    size: 20.0,
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                Icons.storefront_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                size: 20.0,
                                              ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Expanded(
                                        child: wrapWithModel(
                                          model: _model.fonteDadosTabelaModels3
                                              .getModel(
                                            itemCuponsItem.toString(),
                                            itemCuponsIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Key9aa_${itemCuponsItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemCuponsItem,
                                              r'''$.partner.fantasia''',
                                            ).toString(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20.0),
                                      onTap: () => _openEditModal(
                                          context, itemCuponsItem),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 16.0,
                                              height: 16.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: segmentPhoto != null &&
                                                      segmentPhoto.isNotEmpty &&
                                                      segmentPhoto != 'null'
                                                  ? ClipOval(
                                                      child: Image.network(
                                                        segmentPhoto,
                                                        width: 16.0,
                                                        height: 16.0,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            Icon(
                                                          Icons.sell_rounded,
                                                          size: 12.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                        ),
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.sell_rounded,
                                                      size: 12.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                    ),
                                            ),
                                            const SizedBox(width: 6.0),
                                            Flexible(
                                              child: Text(
                                                segmentName ?? '—',
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 12.0,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondary
                                            .withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Text(
                                        '${getJsonField(itemCuponsItem, r'''$.discount''')}%',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: wrapWithModel(
                                      model: _model.fonteDadosTabelaModels6
                                          .getModel(
                                        itemCuponsItem.toString(),
                                        itemCuponsIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: FonteDadosTabelaWidget(
                                        key: Key(
                                          'Keyfvo_${itemCuponsItem.toString()}',
                                        ),
                                        text: functions
                                            .formataDataDeExibicao(getJsonField(
                                          itemCuponsItem,
                                          r'''$.validity''',
                                        ).toString()),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Tooltip(
                                          message:
                                              'Editar (indisponível até o backend liberar a edição de cupons)',
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () => _openEditModal(
                                                context, itemCuponsItem),
                                            child: Container(
                                              width: 32.0,
                                              height: 32.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary
                                                        .withOpacity(0.15),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Icon(
                                                Icons.edit_outlined,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                size: 16.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6.0),
                                        canDelete
                                            ? InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  final confirmDialogResponse =
                                                      await showConfirmationDialog(
                                                    context,
                                                    title: 'Excluir cupom',
                                                    message:
                                                        'Tem certeza que deseja excluir o cupom "${getJsonField(itemCuponsItem, r'''$.description''')}"? Essa ação não pode ser desfeita.',
                                                    confirmText: 'Excluir',
                                                  );
                                                  if (!confirmDialogResponse) {
                                                    return;
                                                  }
                                                  _model.apiResult8yh =
                                                      await DeletarCuponsCall
                                                          .call(
                                                    idDiscount: getJsonField(
                                                      itemCuponsItem,
                                                      r'''$.id''',
                                                    ).toString(),
                                                  );

                                                  if ((_model.apiResult8yh
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model
                                                        .removeFromCuponsLocal(
                                                            itemCuponsItem);
                                                    safeSetState(() {});
                                                  }

                                                  safeSetState(() {});
                                                },
                                                child: Container(
                                                  width: 32.0,
                                                  height: 32.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    size: 18.0,
                                                  ),
                                                ),
                                              )
                                            : Tooltip(
                                                message:
                                                    'Este cupom não pode ser excluído',
                                                child: Container(
                                                  width: 32.0,
                                                  height: 32.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.lock_outline_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 16.0,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
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
