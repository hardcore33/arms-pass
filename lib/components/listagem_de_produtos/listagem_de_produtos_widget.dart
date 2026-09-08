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
    final theme = FlutterFlowTheme.of(context);
    final count = _model.productsLocal.length;

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
            // Top Bar: Title & Count, Search Bar, Register Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Catálogo de Produtos',
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
                        '$count itens',
                        style: GoogleFonts.readexPro(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 260.0,
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.textController',
                          const Duration(milliseconds: 300),
                          () async {
                            _model.produtosFiltrados = await actions.filtrarPorNome(
                              widget.products?.toList() ?? [],
                              _model.textController.text,
                              1,
                              true,
                            );
                            _model.productsLocal = _model.produtosFiltrados?.toList().cast<dynamic>() ?? [];
                            safeSetState(() {});
                          },
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Buscar produto...',
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
                    const SizedBox(width: 16.0),
                    FFButtonWidget(
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
                        _model.apiResultusi = await ObterProdutosCall.call();
                        if ((_model.apiResultusi?.succeeded ?? true)) {
                          _model.productsLocal = (_model.apiResultusi?.jsonBody ?? '').toList().cast<dynamic>();
                          safeSetState(() {});
                        }
                      },
                      text: 'Cadastrar Produto',
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 18.0,
                      ),
                      options: FFButtonOptions(
                        height: 44.0,
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        color: theme.primary,
                        textStyle: GoogleFonts.readexPro(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                        elevation: 1.0,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ],
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
                          flex: 6,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: wrapWithModel(
                                model: _model.fonteTituloTabelaModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: const FonteTituloTabelaWidget(
                                  text: 'NOME',
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
                                  text: 'PONTOS',
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
                                model: _model.fonteTituloTabelaModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: const FonteTituloTabelaWidget(
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
                            decoration: const BoxDecoration(),
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
              ),
            ],
          ),
        ),
      );
    }
  }
