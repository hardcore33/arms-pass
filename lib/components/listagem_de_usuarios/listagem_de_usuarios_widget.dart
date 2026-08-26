import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/components/modal_de_alterar_customer/modal_de_alterar_customer_widget.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'listagem_de_usuarios_model.dart';
export 'listagem_de_usuarios_model.dart';

class ListagemDeUsuariosWidget extends StatefulWidget {
  const ListagemDeUsuariosWidget({
    super.key,
    required this.users,
    required this.onUserEdit,
  });

  final List<dynamic>? users;
  final Future Function()? onUserEdit;

  @override
  State<ListagemDeUsuariosWidget> createState() =>
      _ListagemDeUsuariosWidgetState();
}

class _ListagemDeUsuariosWidgetState extends State<ListagemDeUsuariosWidget> {
  late ListagemDeUsuariosModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeUsuariosModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.usersLocal = widget!.users!.toList().cast<dynamic>();
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

  List<dynamic> _applySort(List<dynamic> input) {
    final result = input.toList();

    dynamic keyOf(dynamic user) {
      switch (_model.sortField) {
        case 'id':
          return getJsonField(user, r'''$.id''');
        case 'pass':
          return getJsonField(user, r'''$.armspass''') == true ? 1 : 0;
        case 'status':
          return getJsonField(user, r'''$.isActive''') == true ? 1 : 0;
        case 'identificacao':
          return (getJsonField(user, r'''$.partner''') != null
              ? getJsonField(user, r'''$.partner.cnpj''')
              : getJsonField(user, r'''$.cpf'''))?.toString().toLowerCase() ?? '';
        case 'email':
          return getJsonField(user, r'''$.user.login''')?.toString().toLowerCase() ?? '';
        case 'nome':
        default:
          return getJsonField(user, r'''$.name''')?.toString().toLowerCase() ?? '';
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
        (_model.sortField == '' && field == 'nome');
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
          const SizedBox(width: 2.0),
          Icon(
            isActive
                ? (_model.sortAscending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded)
                : Icons.unfold_more_rounded,
            size: 12.0,
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
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
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
                            width: 250.0,
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.textController',
                                Duration(milliseconds: 2000),
                                () async {
                                  _model.usuariosFiltrados =
                                      await actions.filtrarPorNome(
                                    widget!.users!.toList(),
                                    _model.textController.text,
                                    1,
                                    true,
                                  );
                                  _model.usersLocal = _model.usuariosFiltrados!
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
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
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
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: _buildSortableHeader(
                                context,
                                'id',
                                Text(
                                  'ID',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
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
                              child: _buildSortableHeader(
                                context,
                                'nome',
                                Text(
                                  'NOME',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: _buildSortableHeader(
                                context,
                                'pass',
                                Text(
                                  'PASS',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: _buildSortableHeader(
                                context,
                                'status',
                                Text(
                                  'STATUS',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
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
                              child: _buildSortableHeader(
                                context,
                                'identificacao',
                                Text(
                                  'IDENTIFICAÇÃO',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
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
                              child: _buildSortableHeader(
                                context,
                                'email',
                                Text(
                                  'EMAIL',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 10.0, 0.0),
                          child: SizedBox(
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                      ],
                    ),
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
                        final itemUsuarios = _applySort(_model.usersLocal);

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: itemUsuarios.length,
                          itemBuilder: (context, itemUsuariosIndex) {
                            final itemUsuariosItem =
                                itemUsuarios[itemUsuariosIndex];
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
                                            model: _model
                                                .fonteDadosTabelaModels1
                                                .getModel(
                                              itemUsuariosItem.toString(),
                                              itemUsuariosIndex,
                                            ),
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: FonteDadosTabelaWidget(
                                              key: Key(
                                                'Keydvi_${itemUsuariosItem.toString()}',
                                              ),
                                              text: getJsonField(
                                                itemUsuariosItem,
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
                                            model: _model
                                                .fonteDadosTabelaModels2
                                                .getModel(
                                              itemUsuariosItem.toString(),
                                              itemUsuariosIndex,
                                            ),
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: FonteDadosTabelaWidget(
                                              key: Key(
                                                'Keym2d_${itemUsuariosItem.toString()}',
                                              ),
                                              text: getJsonField(
                                                itemUsuariosItem,
                                                r'''$.name''',
                                              ).toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: const BoxDecoration(),
                                        child: Align(
                                          alignment: const AlignmentDirectional(0.0, 0.0),
                                          child: getJsonField(itemUsuariosItem, r'''$.armspass''') == true
                                              ? const Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Color(0xFF00C853),
                                                  size: 20.0,
                                                )
                                              : const Icon(
                                                  Icons.remove_circle_outline_rounded,
                                                  color: Color(0xFF909090),
                                                  size: 20.0,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(),
                                        child: Align(
                                          alignment: const AlignmentDirectional(0.0, 0.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: (getJsonField(itemUsuariosItem, r'''$.isActive''') == true || getJsonField(itemUsuariosItem, r'''$.user.isActive''') == true)
                                                  ? const Color(0x2000C853)
                                                  : const Color(0x20909090),
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Text(
                                              (getJsonField(itemUsuariosItem, r'''$.isActive''') == true || getJsonField(itemUsuariosItem, r'''$.user.isActive''') == true)
                                                  ? 'Ativo'
                                                  : 'Inativo',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.openSans(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    fontSize: 12.0,
                                                    color: (getJsonField(itemUsuariosItem, r'''$.isActive''') == true || getJsonField(itemUsuariosItem, r'''$.user.isActive''') == true)
                                                        ? const Color(0xFF00C853)
                                                        : const Color(0xFF707070),
                                                  ),
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
                                                    itemUsuariosItem.toString(),
                                                    itemUsuariosIndex,
                                                  ),
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child: FonteDadosTabelaWidget(
                                                    key: Key(
                                                      'Keyozi_${itemUsuariosItem.toString()}',
                                                    ),
                                                    text: getJsonField(
                                                              itemUsuariosItem,
                                                              r'''$.partner''',
                                                            ) !=
                                                            null
                                                        ? getJsonField(
                                                            itemUsuariosItem,
                                                            r'''$.partner.cnpj''',
                                                          ).toString()
                                                        : getJsonField(
                                                            itemUsuariosItem,
                                                            r'''$.cpf''',
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
                                      flex: 4,
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: wrapWithModel(
                                            model: _model
                                                .fonteDadosTabelaModels5
                                                .getModel(
                                              itemUsuariosItem.toString(),
                                              itemUsuariosIndex,
                                            ),
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: FonteDadosTabelaWidget(
                                              key: Key(
                                                'Keytog_${itemUsuariosItem.toString()}',
                                              ),
                                              text: getJsonField(
                                                itemUsuariosItem,
                                                r'''$.user.login''',
                                              ).toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 10.0, 0.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
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
                                                        ModalDeAlterarCustomerWidget(
                                                      customer:
                                                          itemUsuariosItem,
                                                    ),
                                                  );
                                                },
                                              ).then((value) => safeSetState(
                                                  () => _model.resultadoDialog =
                                                      value));

                                              if (_model.resultadoDialog ==
                                                  true) {
                                                await widget.onUserEdit?.call();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Cadastro atualizado com sucesso!',
                                                      style: TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .success,
                                                  ),
                                                );
                                                _model.usersLocal = widget!
                                                    .users!
                                                    .toList()
                                                    .cast<dynamic>();
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.pen,
                                              color: Color(0xFFA49C88),
                                              size: 20.0,
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
                                    width:
                                        MediaQuery.sizeOf(context).width * 1.0,
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
          ),
        ],
      ),
    );
  }
}
