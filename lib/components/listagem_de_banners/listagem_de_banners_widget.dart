import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_dados_tabela_com_limite/fonte_dados_tabela_com_limite_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/components/modal_adicionar_banner/modal_adicionar_banner_widget.dart';
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
import 'listagem_de_banners_model.dart';
export 'listagem_de_banners_model.dart';

class ListagemDeBannersWidget extends StatefulWidget {
  const ListagemDeBannersWidget({
    super.key,
    required this.banners,
  });

  final List<dynamic>? banners;

  @override
  State<ListagemDeBannersWidget> createState() =>
      _ListagemDeBannersWidgetState();
}

class _ListagemDeBannersWidgetState extends State<ListagemDeBannersWidget> {
  late ListagemDeBannersModel _model;
  String sortField = 'id';
  bool sortAscending = true;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeBannersModel());

    final list = widget.banners;
    if (list is List) {
      _model.bannersLocal = list.toList().cast<dynamic>();
    } else {
      _model.bannersLocal = [];
    }

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didUpdateWidget(covariant ListagemDeBannersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.banners != oldWidget.banners) {
      final list = widget.banners;
      if (list is List) {
        _model.bannersLocal = list.toList().cast<dynamic>();
      } else {
        _model.bannersLocal = [];
      }
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  List<dynamic> _applySort(List<dynamic> input) {
    final result = input.toList();
    result.sort((a, b) {
      dynamic valA;
      dynamic valB;
      switch (sortField) {
        case 'id':
          valA = getJsonField(a, r'''$.id''');
          valB = getJsonField(b, r'''$.id''');
          break;
        case 'url':
          valA = (getJsonField(a, r'''$.url''') ?? '').toString().toLowerCase();
          valB = (getJsonField(b, r'''$.url''') ?? '').toString().toLowerCase();
          break;
        default:
          valA = '';
          valB = '';
      }
      int comp;
      if (valA is num && valB is num) {
        comp = valA.compareTo(valB);
      } else {
        comp = valA.toString().compareTo(valB.toString());
      }
      return sortAscending ? comp : -comp;
    });
    return result;
  }

  Widget _buildSortableHeader(
    BuildContext context,
    String field,
    Widget label,
  ) {
    final isActive = sortField == field;
    return InkWell(
      onTap: () {
        safeSetState(() {
          if (sortField == field) {
            sortAscending = !sortAscending;
          } else {
            sortField = field;
            sortAscending = true;
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
                ? (sortAscending
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
    final theme = FlutterFlowTheme.of(context);
    final count = _model.bannersLocal.length;

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
            // Top Bar: Title & Count, Search Bar, Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gerenciamento de Banners',
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
                        border: Border.all(
                          color: theme.primary.withOpacity(0.2),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        '$count banners',
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
                    SizedBox(
                      width: 280.0,
                      height: 42.0,
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.textController',
                          const Duration(milliseconds: 300),
                          () async {
                            final rawBanners = widget.banners is List
                                ? widget.banners!.toList()
                                : [];
                            _model.bannersFiltrados =
                                await actions.filtrarPorNome(
                              rawBanners,
                              _model.textController.text,
                              5,
                              true,
                            );
                            _model.bannersLocal = _model.bannersFiltrados != null
                                ? _model.bannersFiltrados!.toList().cast<dynamic>()
                                : rawBanners.cast<dynamic>();
                            safeSetState(() {});
                          },
                        ),
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Pesquisar banners...',
                          hintStyle: GoogleFonts.readexPro(
                            color: theme.secondaryText,
                            fontSize: 13.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.alternate,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.primary,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: theme.primaryBackground,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: theme.secondaryText,
                            size: 18.0,
                          ),
                        ),
                        style: GoogleFonts.readexPro(
                          fontSize: 13.0,
                          color: theme.primaryText,
                        ),
                        cursorColor: theme.primary,
                        validator: _model.textControllerValidator.asValidator(context),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Builder(
                      builder: (context) => FFButtonWidget(
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
                                child: ModalAdicionarBannerWidget(
                                  titulo: 'banner',
                                ),
                              );
                            },
                          );

                          _model.apiResultdku =
                              await ObterBannersCall.call();

                          if ((_model.apiResultdku?.succeeded ?? true)) {
                            final updated = _model.apiResultdku?.jsonBody;
                            if (updated is List) {
                              _model.bannersLocal =
                                  updated.toList().cast<dynamic>();
                            }
                            safeSetState(() {});
                          }

                          safeSetState(() {});
                        },
                        text: 'Novo Banner',
                        icon: const Icon(
                          Icons.add_rounded,
                          size: 18.0,
                        ),
                        options: FFButtonOptions(
                          height: 42.0,
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          color: theme.primary,
                          textStyle: GoogleFonts.readexPro(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Container(
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
                          flex: 3,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Text(
                                'IMAGEM',
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
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: _buildSortableHeader(
                                context,
                                'url',
                                Text(
                                  'DESTINO',
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
                              child: Text(
                                'AÇÕES',
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
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Builder(
                      builder: (context) {
                        final itemBanners = _applySort(_model.bannersLocal);

                        if (itemBanners.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'Nenhum banner encontrado',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.openSans(),
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                    ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: itemBanners.length,
                          itemBuilder: (context, itemBannersIndex) {
                          final itemBannersItem = itemBanners[itemBannersIndex];
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
                                      decoration: const BoxDecoration(),
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(0.0, 0.0),
                                        child: wrapWithModel(
                                          model: _model.fonteDadosTabelaModels1
                                              .getModel(
                                            itemBannersItem.toString(),
                                            itemBannersIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Keyadj_${itemBannersItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemBannersItem,
                                              r'''$.id''',
                                            ).toString(),
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
                                        alignment:
                                            const AlignmentDirectional(0.0, 0.0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            child: Image.network(
                                              getJsonField(
                                                itemBannersItem,
                                                r'''$.imagem''',
                                              ).toString(),
                                              width: 80.0,
                                              height: 48.0,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 80.0,
                                                  height: 48.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.broken_image_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 20.0,
                                                  ),
                                                );
                                              },
                                            ),
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
                                        alignment:
                                            const AlignmentDirectional(0.0, 0.0),
                                        child: wrapWithModel(
                                          model: _model.fonteDadosTabelaModels2
                                              .getModel(
                                            itemBannersItem.toString(),
                                            itemBannersIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Keyf2v_${itemBannersItem.toString()}',
                                            ),
                                            text: (getJsonField(
                                              itemBannersItem,
                                              r'''$.url''',
                                            ) ?? '-').toString(),
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
                                        alignment:
                                            const AlignmentDirectional(0.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            final confirmDialogResponse =
                                                await showConfirmationDialog(
                                              context,
                                              title: 'Excluir banner',
                                              message:
                                                  'Tem certeza que deseja excluir este banner? Essa ação não pode ser desfeita.',
                                              confirmText: 'Excluir',
                                            );
                                            if (!confirmDialogResponse) {
                                              return;
                                            }
                                            _model.apiResult8yh =
                                                await DeletarBannersCall.call(
                                              idBanner: getJsonField(
                                                itemBannersItem,
                                                r'''$.id''',
                                              ).toString(),
                                            );

                                            if ((_model
                                                    .apiResult8yh?.succeeded ??
                                                true)) {
                                              _model.removeFromBannersLocal(
                                                  itemBannersItem);
                                              safeSetState(() {});
                                            }

                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.delete_outline_rounded,
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 6.0, 0.0, 6.0),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 0.5,
                                  decoration: const BoxDecoration(
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
