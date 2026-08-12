import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
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

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeTrocasModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.trocasLocal = widget!.trocas!.toList().cast<dynamic>();
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
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.74,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
              child: Material(
                color: Colors.transparent,
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.74,
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(6.0),
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
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      height: 65.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              30.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Lista de trocas',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 19.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 30.0, 20.0, 0.0),
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.textController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.trocasFiltradas =
                                    await actions.filtrarPorNome(
                                  widget!.trocas!.toList(),
                                  _model.textController.text,
                                  3,
                                  true,
                                );
                                _model.trocasLocal = _model.trocasFiltradas!
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
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF8B8B8B),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF8B8B8B),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 10.0, 20.0, 10.0),
                              suffixIcon: Icon(
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
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: wrapWithModel(
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
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: wrapWithModel(
                              model: _model.fonteTituloTabelaModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: FonteTituloTabelaWidget(
                                text: 'PRODUTO',
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
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: wrapWithModel(
                              model: _model.fonteTituloTabelaModel3,
                              updateCallback: () => safeSetState(() {}),
                              child: FonteTituloTabelaWidget(
                                text: 'Usuário',
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
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: wrapWithModel(
                              model: _model.fonteTituloTabelaModel4,
                              updateCallback: () => safeSetState(() {}),
                              child: FonteTituloTabelaWidget(
                                text: 'SITUAÇÃO',
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
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: wrapWithModel(
                              model: _model.fonteTituloTabelaModel5,
                              updateCallback: () => safeSetState(() {}),
                              child: FonteTituloTabelaWidget(
                                text: 'ENTREGAR',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 6.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 0.5,
                    decoration: BoxDecoration(
                      color: Color(0xFFC7C7C7),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.56,
                  decoration: BoxDecoration(),
                  child: Builder(
                    builder: (context) {
                      final itemTrocas = _model.trocasLocal.toList();

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: itemTrocas.length,
                        itemBuilder: (context, itemTrocasIndex) {
                          final itemTrocasItem = itemTrocas[itemTrocasIndex];
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
                                            itemTrocasItem.toString(),
                                            itemTrocasIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Key9h0_${itemTrocasItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemTrocasItem,
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
                                            itemTrocasItem.toString(),
                                            itemTrocasIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Keyr7u_${itemTrocasItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemTrocasItem,
                                              r'''$.product.name''',
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
                                            itemTrocasItem.toString(),
                                            itemTrocasIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Keyfww_${itemTrocasItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemTrocasItem,
                                              r'''$.customer.name''',
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
                                            if (!functions.obterEstadoDeTroca(
                                                getJsonField(
                                              itemTrocasItem,
                                              r'''$.status''',
                                            ).toString()))
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: wrapWithModel(
                                                  model: _model
                                                      .fonteDadosTabelaModels4
                                                      .getModel(
                                                    itemTrocasItem.toString(),
                                                    itemTrocasIndex,
                                                  ),
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child: FonteDadosTabelaWidget(
                                                    key: Key(
                                                      'Key0jb_${itemTrocasItem.toString()}',
                                                    ),
                                                    text: 'Entregue',
                                                  ),
                                                ),
                                              )
                                            else
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Text(
                                                  'Pendente',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .openSans(),
                                                        color: const Color(
                                                            0xFFFFB300),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if (functions
                                              .obterEstadoDeTroca(getJsonField(
                                            itemTrocasItem,
                                            r'''$.status''',
                                          ).toString()))
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                final confirmDialogResponse =
                                                    await showConfirmationDialog(
                                                  context,
                                                  title: 'Marcar como entregue',
                                                  message:
                                                      'Tem certeza que deseja marcar essa troca como entregue? Essa ação não pode ser desfeita.',
                                                  confirmText:
                                                      'Confirmar entrega',
                                                  isDestructive: false,
                                                );
                                                if (!confirmDialogResponse) {
                                                  return;
                                                }
                                                _model.apiResultwbc =
                                                    await AtualizarStatusDaTrocaCall
                                                        .call(
                                                  idTroca: getJsonField(
                                                    itemTrocasItem,
                                                    r'''$.id''',
                                                  ).toString(),
                                                  idProduto: getJsonField(
                                                    itemTrocasItem,
                                                    r'''$.product.id''',
                                                  ).toString(),
                                                  idCustomer: getJsonField(
                                                    itemTrocasItem,
                                                    r'''$.customer.id''',
                                                  ).toString(),
                                                  idTenant: getJsonField(
                                                    itemTrocasItem,
                                                    r'''$.tenant.id''',
                                                  ).toString(),
                                                  takeout: getJsonField(
                                                    itemTrocasItem,
                                                    r'''$.takeout''',
                                                  ).toString(),
                                                );

                                                if ((_model.apiResultwbc
                                                        ?.succeeded ??
                                                    true)) {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Item entregue'),
                                                        content: Text(
                                                            'O item foi entregue e seu status atualizado.'),
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
                                                  _model.apiResultcev =
                                                      await ObterTrocasCall
                                                          .call();

                                                  if ((_model.apiResultcev
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.trocasLocal = (_model
                                                                .apiResultcev
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
                                                            'Não foi possível realizar essa ação, tente novamente mais tarde.'),
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
                                              child: Icon(
                                                Icons.forward_to_inbox,
                                                color: Color(0xFF1CA723),
                                                size: 24.0,
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
                                    color: Color(0xFFC7C7C7),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
