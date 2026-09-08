import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'listagem_de_propostas_model.dart';
export 'listagem_de_propostas_model.dart';

class ListagemDePropostasWidget extends StatefulWidget {
  const ListagemDePropostasWidget({
    super.key,
    required this.propostas,
  });

  final List<dynamic>? propostas;

  @override
  State<ListagemDePropostasWidget> createState() =>
      _ListagemDePropostasWidgetState();
}

class _ListagemDePropostasWidgetState extends State<ListagemDePropostasWidget> {
  late ListagemDePropostasModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDePropostasModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.propostasLocal = widget!.propostas!.toList().cast<dynamic>();
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

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final count = _model.propostasLocal.length;

    return Material(
      color: Colors.transparent,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: theme.alternate,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Title & Count, Search Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Propostas de Credenciamento',
                      style: GoogleFonts.readexPro(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        '$count registros',
                        style: GoogleFonts.readexPro(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 280.0,
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.textController',
                      const Duration(milliseconds: 300),
                      () async {
                        _model.propostasFiltradas = await actions.filtrarPorNome(
                          widget.propostas?.toList() ?? [],
                          _model.textController.text,
                          2,
                          true,
                        );
                        _model.propostasLocal = _model.propostasFiltradas?.toList().cast<dynamic>() ?? [];
                        safeSetState(() {});
                      },
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Buscar por razão ou responsável...',
                      hintStyle: GoogleFonts.readexPro(
                        color: const Color(0xFF909090),
                        fontSize: 13.5,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.alternate,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.primary,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: theme.secondaryBackground,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF9A9A9A),
                        size: 20.0,
                      ),
                    ),
                    style: GoogleFonts.readexPro(
                      color: theme.primaryText,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.zero,
              child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(
                          FlutterFlowTheme.of(context)
                              .designToken
                              .radius
                              .sm),
                    ),
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 12.0, 16.0, 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: wrapWithModel(
                                model: _model.fonteTituloTabelaModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: const FonteTituloTabelaWidget(
                                  text: 'ID',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: wrapWithModel(
                                model: _model.fonteTituloTabelaModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: const FonteTituloTabelaWidget(
                                  text: 'RAZÃO',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: wrapWithModel(
                                model: _model.fonteTituloTabelaModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: const FonteTituloTabelaWidget(
                                  text: 'NOME',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: wrapWithModel(
                                model: _model.fonteTituloTabelaModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: const FonteTituloTabelaWidget(
                                  text: 'TELEFONE',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: wrapWithModel(
                                model: _model.fonteTituloTabelaModel5,
                                updateCallback: () => safeSetState(() {}),
                                child: const FonteTituloTabelaWidget(
                                  text: 'PROPOSTA',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 100.0,
                            height: 20.0,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Builder(
                    builder: (context) {
                      final itemPropostas = _model.propostasLocal.toList();

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: itemPropostas.length,
                        itemBuilder: (context, itemPropostasIndex) {
                          final itemPropostasItem =
                              itemPropostas[itemPropostasIndex];
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: wrapWithModel(
                                          model: _model.fonteDadosTabelaModels1
                                              .getModel(
                                            itemPropostasItem.toString(),
                                            itemPropostasIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Keymom_${itemPropostasItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemPropostasItem,
                                              r'''$.id''',
                                            ).toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: wrapWithModel(
                                          model: _model.fonteDadosTabelaModels2
                                              .getModel(
                                            itemPropostasItem.toString(),
                                            itemPropostasIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Keyx16_${itemPropostasItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemPropostasItem,
                                              r'''$.razaoSocial''',
                                            ).toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: wrapWithModel(
                                          model: _model.fonteDadosTabelaModels3
                                              .getModel(
                                            itemPropostasItem.toString(),
                                            itemPropostasIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Key32n_${itemPropostasItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemPropostasItem,
                                              r'''$.responsavel''',
                                            ).toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: wrapWithModel(
                                                model: _model
                                                    .fonteDadosTabelaModels4
                                                    .getModel(
                                                  itemPropostasItem.toString(),
                                                  itemPropostasIndex,
                                                ),
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: FonteDadosTabelaWidget(
                                                  key: Key(
                                                    'Keysf2_${itemPropostasItem.toString()}',
                                                  ),
                                                  text: getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.phone''',
                                                  ).toString(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Text(
                                        getJsonField(
                                          itemPropostasItem,
                                          r'''$.proposta''',
                                        ).toString().maybeHandleOverflow(
                                              maxChars: 15,
                                              replacement: '…',
                                            ),
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.openSans(
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 15.5,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 100.0,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final confirmDialogResponse =
                                                    await showConfirmationDialog(
                                                  context,
                                                  title: 'Aprovar proposta',
                                                  message:
                                                      'Tem certeza que deseja aprovar a proposta de "${getJsonField(itemPropostasItem, r'''$.razaoSocial''')}"? Um novo parceiro será criado e a proposta não poderá ser recuperada.',
                                                  confirmText: 'Aprovar',
                                                  isDestructive: false,
                                                );
                                                if (!confirmDialogResponse) {
                                                  return;
                                                }
                                                _model.apiResultrv3 =
                                                    await CriarUsuarioCall.call(
                                                  idTenant:
                                                      FFAppConstants.tenantId,
                                                  email: getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.email''',
                                                  ).toString(),
                                                  senha: getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.senha''',
                                                  ).toString(),
                                                  razao: getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.razaoSocial''',
                                                  ).toString(),
                                                  cnpj: getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.cnpj''',
                                                  ).toString(),
                                                  cep: getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.cep''',
                                                  ).toString(),
                                                  rua: getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.rua''',
                                                  ).toString(),
                                                  bairro: getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.bairro''',
                                                  ).toString(),
                                                  numero: getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.numero''',
                                                  ).toString(),
                                                  cidade: getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.cidade''',
                                                  ).toString(),
                                                  telefoneRepresentante:
                                                      getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.phone''',
                                                  ).toString(),
                                                  representanteNome:
                                                      getJsonField(
                                                    itemPropostasItem,
                                                    r'''$.responsavel''',
                                                  ).toString(),
                                                );

                                                if ((_model.apiResultrv3
                                                        ?.succeeded ??
                                                    true)) {
                                                  await DeletarPropostaCall
                                                      .call(
                                                    idProposta: getJsonField(
                                                      itemPropostasItem,
                                                      r'''$.id''',
                                                    ).toString(),
                                                  );

                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Proposta aceita'),
                                                        content: Text(
                                                            'O parceiro foi adicionado com sucesso.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext),
                                                            child: Text('Ok'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  _model.apiResultv7s =
                                                      await ObterPropostasCall
                                                          .call();

                                                  if ((_model.apiResultv7s
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.propostasLocal =
                                                        (_model.apiResultv7s
                                                                    ?.jsonBody ??
                                                                '')
                                                            .toList()
                                                            .cast<dynamic>();
                                                    safeSetState(() {});
                                                  }
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Algo deu errado'),
                                                        content: Text(
                                                            'Não foi possível aprovar a proposta, tente novamente.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext),
                                                            child: Text('Ok'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }

                                                safeSetState(() {});
                                              },
                                              child: FaIcon(
                                                FontAwesomeIcons.check,
                                                color: Color(0xFF3E9F4C),
                                                size: 19.0,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 0.0, 0.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  final confirmDialogResponse =
                                                      await showConfirmationDialog(
                                                    context,
                                                    title: 'Recusar proposta',
                                                    message:
                                                        'Tem certeza que deseja recusar a proposta de "${getJsonField(itemPropostasItem, r'''$.razaoSocial''')}"? Essa ação não pode ser desfeita.',
                                                    confirmText: 'Recusar',
                                                  );
                                                  if (!confirmDialogResponse) {
                                                    return;
                                                  }
                                                  _model.apiResultyd0 =
                                                      await DeletarPropostaCall
                                                          .call(
                                                    idProposta: getJsonField(
                                                      itemPropostasItem,
                                                      r'''$.id''',
                                                    ).toString(),
                                                  );

                                                  if ((_model.apiResultyd0
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model
                                                        .removeFromPropostasLocal(
                                                            itemPropostasItem);
                                                    safeSetState(() {});
                                                  } else {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Algo deu errado'),
                                                          content: Text(
                                                              'Não foi possível recusar a proposta.'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      alertDialogContext),
                                                              child: Text(
                                                                  'Tentar novamente'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }

                                                  safeSetState(() {});
                                                },
                                                child: Icon(
                                                  Icons.close_rounded,
                                                  color: Color(0xFFBC1616),
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 6.0, 0.0, 6.0),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 1.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
