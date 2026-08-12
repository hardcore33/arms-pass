import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/components/modal_adicionar_parceiro/modal_adicionar_parceiro_widget.dart';
import '/components/modal_editar_parceiro/modal_editar_parceiro_widget.dart';
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

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeParceirosModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.parceirosLocal = widget!.parceiros!.toList().cast<dynamic>();
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _model.switchValue = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  List<dynamic> _applySort(List<dynamic> input) {
    final result = input.toList();

    dynamic keyOf(dynamic parceiro) {
      switch (_model.sortField) {
        case 'id':
          return getJsonField(parceiro, r'''$.partner.id''');
        case 'cnpj':
          return getJsonField(parceiro, r'''$.partner.cnpj''')?.toString() ??
              '';
        case 'cidade':
          return getJsonField(parceiro, r'''$.partner.city''')?.toString() ??
              '';
        case 'situacao':
          return (getJsonField(parceiro, r'''$.isActive''') == true) ? 1 : 0;
        case 'fantasia':
        default:
          return getJsonField(parceiro, r'''$.partner.fantasia''')
                  ?.toString()
                  .toLowerCase() ??
              '';
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

    return result;
  }

  Widget _buildSortableHeader(
    BuildContext context,
    String field,
    Widget label,
  ) {
    final isActive = _model.sortField == field ||
        (_model.sortField == '' && field == 'fantasia');
    return InkWell(
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              child: Material(
                color: Colors.transparent,
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      FlutterFlowTheme.of(context).designToken.radius.md),
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(
                        FlutterFlowTheme.of(context).designToken.radius.md),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
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
                                _model.primeiraValidacao =
                                    await actions.filtrarPorAtividade(
                                  widget!.parceiros?.toList(),
                                  !_model.switchValue!,
                                );
                                _model.parceirosFiltrados =
                                    await actions.filtrarPorNome(
                                  _model.primeiraValidacao!.toList(),
                                  _model.textController.text,
                                  4,
                                  true,
                                );
                                _model.parceirosLocal = _model
                                    .parceirosFiltrados!
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 30.0, 0.0, 0.0),
                      child: Container(
                        height: 44.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 4.0, 0.0),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: Color(0xFFCCCCCC),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 18.0,
                            ),
                            const SizedBox(width: 6.0),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch.adaptive(
                                value: _model.switchValue!,
                                onChanged: (newValue) async {
                                  safeSetState(
                                      () => _model.switchValue = newValue!);
                                  if (newValue!) {
                                    _model.parceirosFiltradosPorAtividade =
                                        await actions.filtrarPorAtividade(
                                      widget!.parceiros?.toList(),
                                      !_model.switchValue!,
                                    );
                                    _model.parceirosLocal = _model
                                        .parceirosFiltradosPorAtividade!
                                        .toList()
                                        .cast<dynamic>();
                                    safeSetState(() {});

                                    safeSetState(() {});
                                  } else {
                                    _model.parceirosFiltradosPorAtividadeOff =
                                        await actions.filtrarPorAtividade(
                                      widget!.parceiros?.toList(),
                                      true,
                                    );
                                    _model.parceirosLocal = _model
                                        .parceirosFiltradosPorAtividadeOff!
                                        .toList()
                                        .cast<dynamic>();
                                    safeSetState(() {});

                                    safeSetState(() {});
                                  }
                                },
                                activeColor: Colors.white,
                                activeTrackColor: Color(0xFF1CA723),
                                inactiveTrackColor: Color(0xFFF60000),
                                inactiveThumbColor: Colors.white,
                              ),
                            ),
                            Text(
                              _model.switchValue! ? 'Ativos' : 'Inativos',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Builder(
                        builder: (context) => Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 30.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              _model.segmentos =
                                  await ObterSegmentosCall.call();

                              _model.nomeDeSegmentos =
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
                                    child: ModalAdicionarParceiroWidget(
                                      titulo: 'parceiro',
                                      nomeDeSegmentos: _model.nomeDeSegmentos!,
                                      segmentos:
                                          (_model.segmentos?.jsonBody ?? ''),
                                      nomeDeEstados: functions.obterEstados(),
                                    ),
                                  );
                                },
                              );

                              _model.apiResultl4kl =
                                  await ObterUsuariosCall.call();

                              if ((_model.apiResultl4kl?.succeeded ?? true)) {
                                _model.parceirosLocal = functions
                                    .obterParceiros(
                                        (_model.apiResultl4kl?.jsonBody ?? ''))!
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
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
                          flex: 5,
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: _buildSortableHeader(
                              context,
                              'cnpj',
                              wrapWithModel(
                                model: _model.fonteTituloTabelaModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: FonteTituloTabelaWidget(
                                  text: 'CNPJ',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: _buildSortableHeader(
                              context,
                              'fantasia',
                              wrapWithModel(
                                model: _model.fonteTituloTabelaModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: FonteTituloTabelaWidget(
                                  text: 'NOME FANTASIA',
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
                              'cidade',
                              wrapWithModel(
                                model: _model.fonteTituloTabelaModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: FonteTituloTabelaWidget(
                                  text: 'CIDADE',
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
                              'situacao',
                              wrapWithModel(
                                model: _model.fonteTituloTabelaModel5,
                                updateCallback: () => safeSetState(() {}),
                                child: FonteTituloTabelaWidget(
                                  text: 'SITUAÇÃO',
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
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Builder(
                    builder: (context) {
                      final itemParceiros = _applySort(_model.parceirosLocal);

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: itemParceiros.length,
                        itemBuilder: (context, itemParceirosIndex) {
                          final itemParceirosItem =
                              itemParceiros[itemParceirosIndex];
                          final partnerPhoto = getJsonField(
                            itemParceirosItem,
                            r'''$.partner.photo''',
                          )?.toString();
                          final isActive = getJsonField(
                            itemParceirosItem,
                            r'''$.isActive''',
                          ) as bool?;
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
                                        itemParceirosItem.toString(),
                                        itemParceirosIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: FonteDadosTabelaWidget(
                                        key: Key(
                                          'Keyk2p_${itemParceirosItem.toString()}',
                                        ),
                                        text: getJsonField(
                                          itemParceirosItem,
                                          r'''$.partner.id''',
                                        ).toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: wrapWithModel(
                                      model: _model.fonteDadosTabelaModels2
                                          .getModel(
                                        itemParceirosItem.toString(),
                                        itemParceirosIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: FonteDadosTabelaWidget(
                                        key: Key(
                                          'Keyf9j_${itemParceirosItem.toString()}',
                                        ),
                                        text: getJsonField(
                                          itemParceirosItem,
                                          r'''$.partner.cnpj''',
                                        ).toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 32.0,
                                        height: 32.0,
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
                                                  width: 32.0,
                                                  height: 32.0,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Icon(
                                                    Icons.storefront_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary,
                                                    size: 16.0,
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                Icons.storefront_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                size: 16.0,
                                              ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: wrapWithModel(
                                          model: _model.fonteDadosTabelaModels3
                                              .getModel(
                                            itemParceirosItem.toString(),
                                            itemParceirosIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Keyye4_${itemParceirosItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemParceirosItem,
                                              r'''$.partner.fantasia''',
                                            ).toString(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: wrapWithModel(
                                      model: _model.fonteDadosTabelaModels4
                                          .getModel(
                                        itemParceirosItem.toString(),
                                        itemParceirosIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: FonteDadosTabelaWidget(
                                        key: Key(
                                          'Keyhku_${itemParceirosItem.toString()}',
                                        ),
                                        text: '${getJsonField(
                                          itemParceirosItem,
                                          r'''$.partner.city''',
                                        ).toString()} - ${getJsonField(
                                          itemParceirosItem,
                                          r'''$.partner.state''',
                                        ).toString()}',
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: (isActive ?? false)
                                            ? FlutterFlowTheme.of(context)
                                                .successBackground
                                            : FlutterFlowTheme.of(context)
                                                .errorBackground,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Text(
                                        (isActive ?? false)
                                            ? 'ATIVO'
                                            : 'INATIVO',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.openSans(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              color: (isActive ?? false)
                                                  ? FlutterFlowTheme.of(context)
                                                      .successDark
                                                  : FlutterFlowTheme.of(context)
                                                      .errorDark,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Builder(
                                          builder: (context) => InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              _model.segmentosEditar =
                                                  await ObterSegmentosCall
                                                      .call();

                                              _model.nomeDeSegmentosEditar =
                                                  await actions
                                                      .obterListaDeSegmentos(
                                                (_model.segmentosEditar
                                                        ?.jsonBody ??
                                                    ''),
                                              );
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
                                                        ModalEditarParceiroWidget(
                                                      titulo: 'parceiros',
                                                      dados: itemParceirosItem,
                                                      nomeDeSegmentos: _model
                                                          .nomeDeSegmentosEditar,
                                                      segmentos: (_model
                                                              .segmentosEditar
                                                              ?.jsonBody ??
                                                          ''),
                                                      nomeDeEstados: functions
                                                          .obterEstados(),
                                                    ),
                                                  );
                                                },
                                              );

                                              _model.apiResultl4k =
                                                  await ObterUsuariosCall
                                                      .call();

                                              if ((_model.apiResultl4k
                                                      ?.succeeded ??
                                                  true)) {
                                                _model.parceirosLocal =
                                                    functions
                                                        .obterParceiros((_model
                                                                .apiResultl4k
                                                                ?.jsonBody ??
                                                            ''))!
                                                        .toList()
                                                        .cast<dynamic>();
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
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
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            final confirmDialogResponse =
                                                await showConfirmationDialog(
                                              context,
                                              title: 'Excluir parceiro',
                                              message:
                                                  'Tem certeza que deseja excluir o parceiro "${getJsonField(itemParceirosItem, r'''$.partner.fantasia''')}"? Essa ação não pode ser desfeita.',
                                              confirmText: 'Excluir',
                                            );
                                            if (!confirmDialogResponse) {
                                              return;
                                            }
                                            _model.apiResulttxp =
                                                await DeletarParceiroCall.call(
                                              customerId: getJsonField(
                                                itemParceirosItem,
                                                r'''$.id''',
                                              ).toString(),
                                            );

                                            if ((_model
                                                    .apiResulttxp?.succeeded ??
                                                true)) {
                                              _model.inativandoParceiro =
                                                  await ObterUsuariosCall
                                                      .call();

                                              _model.parceirosLocal = functions
                                                  .obterParceiros((_model
                                                          .inativandoParceiro
                                                          ?.jsonBody ??
                                                      ''))!
                                                  .toList()
                                                  .cast<dynamic>();
                                              safeSetState(() {});
                                            }

                                            safeSetState(() {});
                                          },
                                          child: Container(
                                            width: 32.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error
                                                      .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Icon(
                                              Icons.delete_outline_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
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
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }
}
