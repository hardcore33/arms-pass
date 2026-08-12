import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/components/modal_adicionar_produto/modal_adicionar_produto_widget.dart';
import '/components/modal_alterar_produto/modal_alterar_produto_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'listagem_de_produtos_model.dart';
export 'listagem_de_produtos_model.dart';

class ListagemDeProdutosWidget extends StatefulWidget {
  const ListagemDeProdutosWidget({
    super.key,
    required this.products,
  });

  final List<dynamic>? products;

  @override
  State<ListagemDeProdutosWidget> createState() =>
      _ListagemDeProdutosWidgetState();
}

class _ListagemDeProdutosWidgetState extends State<ListagemDeProdutosWidget> {
  late ListagemDeProdutosModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeProdutosModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.productsLocal = widget!.products!.toList().cast<dynamic>();
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
                            'Lista de produtos',
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
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            35.0, 30.0, 0.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.45,
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.textController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.produtosFiltrados =
                                    await actions.filtrarPorNome(
                                  widget!.products!.toList(),
                                  _model.textController.text,
                                  1,
                                  true,
                                );
                                _model.productsLocal = _model.produtosFiltrados!
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
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Builder(
                        builder: (context) => Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              70.0, 0.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: ModalAdicionarProdutoWidget(
                                      titulo: 'produto',
                                    ),
                                  );
                                },
                              );

                              _model.apiResultusi =
                                  await ObterProdutosCall.call();

                              if ((_model.apiResultusi?.succeeded ?? true)) {
                                _model.productsLocal =
                                    (_model.apiResultusi?.jsonBody ?? '')
                                        .toList()
                                        .cast<dynamic>();
                                safeSetState(() {});
                              }

                              safeSetState(() {});
                            },
                            text: 'Cadastrar',
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              size: 20.0,
                            ),
                            options: FFButtonOptions(
                              width: MediaQuery.sizeOf(context).width * 0.14,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
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
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: wrapWithModel(
                              model: _model.fonteTituloTabelaModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: FonteTituloTabelaWidget(
                                text: 'NOME',
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
                                text: 'PONTOS',
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
                              model: _model.fonteTituloTabelaModel4,
                              updateCallback: () => safeSetState(() {}),
                              child: FonteTituloTabelaWidget(
                                text: 'ESTOQUE',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: 100.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                    height: 1.0,
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
                      final itemProdutos = _model.productsLocal.toList();

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: itemProdutos.length,
                        itemBuilder: (context, itemProdutosIndex) {
                          final itemProdutosItem =
                              itemProdutos[itemProdutosIndex];
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
                                            itemProdutosItem.toString(),
                                            itemProdutosIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Key149_${itemProdutosItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemProdutosItem,
                                              r'''$.id''',
                                            ).toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: wrapWithModel(
                                          model: _model.fonteDadosTabelaModels2
                                              .getModel(
                                            itemProdutosItem.toString(),
                                            itemProdutosIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Key8nr_${itemProdutosItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemProdutosItem,
                                              r'''$.name''',
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
                                                    .fonteDadosTabelaModels3
                                                    .getModel(
                                                  itemProdutosItem.toString(),
                                                  itemProdutosIndex,
                                                ),
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: FonteDadosTabelaWidget(
                                                  key: Key(
                                                    'Key12r_${itemProdutosItem.toString()}',
                                                  ),
                                                  text: '${getJsonField(
                                                    itemProdutosItem,
                                                    r'''$.cost''',
                                                  ).toString()}${getJsonField(
                                                        itemProdutosItem,
                                                        r'''$.valorDinheiro''',
                                                      ) != null ? ' + R\$ ${getJsonField(
                                                      itemProdutosItem,
                                                      r'''$.valorDinheiro''',
                                                    ).toString()}' : ''}',
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
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: wrapWithModel(
                                          model: _model.fonteDadosTabelaModels4
                                              .getModel(
                                            itemProdutosItem.toString(),
                                            itemProdutosIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Keyf5k_${itemProdutosItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemProdutosItem,
                                              r'''$.inventory''',
                                            ).toString(),
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
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Builder(
                                          builder: (context) => InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    alignment:
                                                        AlignmentDirectional(
                                                                0.0, 0.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    child:
                                                        ModalAlterarProdutoWidget(
                                                      titulo: 'produto',
                                                      produto: itemProdutosItem,
                                                    ),
                                                  );
                                                },
                                              );

                                              _model.apiResult89c =
                                                  await ObterProdutosCall
                                                      .call();

                                              if ((_model.apiResult89c
                                                      ?.succeeded ??
                                                  true)) {
                                                _model.productsLocal = (_model
                                                            .apiResult89c
                                                            ?.jsonBody ??
                                                        '')
                                                    .toList()
                                                    .cast<dynamic>();
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: Color(0xFF3E9F4C),
                                              size: 22.0,
                                            ),
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
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            final confirmDialogResponse =
                                                await showConfirmationDialog(
                                              context,
                                              title: 'Excluir produto',
                                              message:
                                                  'Tem certeza que deseja excluir o produto "${getJsonField(itemProdutosItem, r'''$.name''')}"? Essa ação não pode ser desfeita.',
                                              confirmText: 'Excluir',
                                            );
                                            if (!confirmDialogResponse) {
                                              return;
                                            }
                                            _model.apiResulttxp =
                                                await DeletarProdutoCall.call(
                                              idProduto: getJsonField(
                                                itemProdutosItem,
                                                r'''$.id''',
                                              ).toString(),
                                            );

                                            if ((_model
                                                    .apiResulttxp?.succeeded ??
                                                true)) {
                                              _model.removeFromProductsLocal(
                                                  itemProdutosItem);
                                              safeSetState(() {});
                                            }

                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.delete_sharp,
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            size: 22.0,
                                          ),
                                        ),
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
