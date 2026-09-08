import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/modal_adicionar_desconto_parceiro/modal_adicionar_desconto_parceiro_widget.dart';
import '/components/modal_alterar_desconto/modal_alterar_desconto_widget.dart';
import '/components/modal_solicitar_banner/modal_solicitar_banner_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'listagem_de_cupons_parceiro_model.dart';
export 'listagem_de_cupons_parceiro_model.dart';

class ListagemDeCuponsParceiroWidget extends StatefulWidget {
  const ListagemDeCuponsParceiroWidget({
    super.key,
    required this.cupons,
    this.onChanged,
  });

  final List<dynamic>? cupons;
  final Future Function()? onChanged;

  @override
  State<ListagemDeCuponsParceiroWidget> createState() =>
      _ListagemDeCuponsParceiroWidgetState();
}

class _ListagemDeCuponsParceiroWidgetState
    extends State<ListagemDeCuponsParceiroWidget> {
  late ListagemDeCuponsParceiroModel _model;
  int _paginaAtual = 1;
  static const int _itensPorPagina = 10;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    // Paginação e filtros locais são instantâneos em memória (0ms).
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeCuponsParceiroModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.cuponsLocais = widget.cupons?.toList().cast<dynamic>() ?? [];
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didUpdateWidget(covariant ListagemDeCuponsParceiroWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cupons != widget.cupons) {
      _model.cuponsLocais = widget.cupons?.toList().cast<dynamic>() ?? [];
      safeSetState(() {});
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definimos paleta de cores Dark Premium explícita para consistência visual
    final cardBgColor = const Color(0xFF1E1E1E);
    final inputBgColor = const Color(0xFF121212);
    final borderColor = const Color(0xFF2C2C2C);
    final highlightColor = FlutterFlowTheme.of(context).secondary;

    return Material(
      color: Colors.transparent,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.74,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header / Search Bar Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lista de Cupons Ativos',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                    ),
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                // Botões de Ação + Input de Busca lado a lado
                Row(
                  children: [
                    // Botão de Solicitar Banner Promocional
                    FFButtonWidget(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (dialogContext) =>
                              ModalSolicitarBannerWidget(
                            partnerId: currentUserUid,
                          ),
                        );
                      },
                      text: 'Solicitar Banner',
                      options: FFButtonOptions(
                        width: 160.0,
                        height: 42.0,
                        color: Colors.transparent,
                        textStyle: TextStyle(
                          color: highlightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: highlightColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    // Botão de Cadastrar Promoção
                    FFButtonWidget(
                      onPressed: () async {
                        final res = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) =>
                              ModalAdicionarDescontoParceiroWidget(
                            partnerId: currentUserUid,
                          ),
                        );
                        if (res == true && widget.onChanged != null) {
                          await widget.onChanged!();
                        }
                      },
                      text: 'Cadastrar Promoção',
                      options: FFButtonOptions(
                        width: 180.0,
                        height: 42.0,
                        color: highlightColor,
                        textStyle: TextStyle(
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Container(
                      width: 250.0,
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.textController',
                          const Duration(milliseconds: 500),
                          () async {
                            _model.usuariosFiltrados = await actions.filtrarPorNome(
                              widget.cupons?.toList() ?? [],
                              _model.textController.text,
                              1,
                              true,
                            );
                            _model.cuponsLocais = _model.usuariosFiltrados!
                                .toList()
                                .cast<dynamic>();
                            _paginaAtual = 1;
                            safeSetState(() {});
                          },
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Buscar promoção...',
                          labelStyle: TextStyle(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 14.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: highlightColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: inputBgColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          suffixIcon: Icon(
                            Icons.search_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 20.0,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            // Table Header
            Container(
              decoration: BoxDecoration(
                color: inputBgColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'ID',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        'DESCRIÇÃO',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        'DESCONTO',
                        style: TextStyle(
                          color: highlightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        'VALIDADE',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        'AÇÕES',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            // Table Body
            Builder(
              builder: (context) {
                final totalItens = _model.cuponsLocais.length;
                final totalPaginas = (totalItens / _itensPorPagina).ceil().clamp(1, 9999);
                final paginaSegura = _paginaAtual.clamp(1, totalPaginas);
                final startIndex = (paginaSegura - 1) * _itensPorPagina;
                final endIndex = (startIndex + _itensPorPagina).clamp(0, totalItens);
                final itemCupons = totalItens > 0 ? _model.cuponsLocais.sublist(startIndex, endIndex) : <dynamic>[];

                return Expanded(
                  child: _model.cuponsLocais.isEmpty
                      ? Center(
                          child: Text(
                            'Nenhuma promoção cadastrada',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14.0,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: itemCupons.length,
                          separatorBuilder: (context, index) => Divider(
                            color: borderColor,
                            height: 1.0,
                          ),
                          itemBuilder: (context, index) {
                            final item = itemCupons[index];
                            final idCupom = getJsonField(item, r'''$.id''').toString();
                        final description = getJsonField(item, r'''$.description''')?.toString() ?? '';
                        final discount = getJsonField(item, r'''$.discount''')?.toString() ?? '0';
                        final validity = getJsonField(item, r'''$.validity''')?.toString() ?? '';
                        final rules = (getJsonField(item, r'''$.rules''') ?? '').toString();

                        final isArmsPro = rules.contains('[ARMS_PRO]') || description.contains('[ARMS_PRO]');
                        final matchLimite = RegExp(r'\[LIMITE:(\d+)\]').firstMatch(rules) ?? RegExp(r'\[LIMITE:(\d+)\]').firstMatch(description);
                        final limiteStr = matchLimite != null ? matchLimite.group(1) : null;
                        final cleanDesc = description.replaceAll('[ARMS_PRO]', '').replaceAll(RegExp(r'\[LIMITE:\d+\]'), '').trim();

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                          child: Row(
                            children: [
                              // ID
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    idCupom,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              // Description
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        cleanDesc.isNotEmpty ? cleanDesc : 'Sem descrição',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      if (isArmsPro || limiteStr != null) ...[
                                        const SizedBox(height: 5.0),
                                        Wrap(
                                          spacing: 6.0,
                                          runSpacing: 4.0,
                                          children: [
                                            if (isArmsPro)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                                                decoration: BoxDecoration(
                                                  color: const Color(0x25FFD700),
                                                  borderRadius: BorderRadius.circular(4.0),
                                                  border: Border.all(color: highlightColor, width: 0.8),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.star_rounded, color: highlightColor, size: 12.0),
                                                    const SizedBox(width: 3.0),
                                                    Text(
                                                      'Arms Pró VIP',
                                                      style: TextStyle(
                                                        color: highlightColor,
                                                        fontSize: 10.5,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (limiteStr != null)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                                                decoration: BoxDecoration(
                                                  color: const Color(0x20FFFFFF),
                                                  borderRadius: BorderRadius.circular(4.0),
                                                  border: Border.all(color: Colors.white30, width: 0.8),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.inventory_2_outlined, color: Colors.white70, size: 11.0),
                                                    const SizedBox(width: 3.0),
                                                    Text(
                                                      'Estoque: $limiteStr un.',
                                                      style: const TextStyle(
                                                        color: Colors.white70,
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
                              ),
                              // Discount
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0x15FFD700),
                                      borderRadius: BorderRadius.circular(6.0),
                                      border: Border.all(
                                        color: highlightColor.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      '$discount %',
                                      style: TextStyle(
                                        color: highlightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Validity
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    functions.formataDataDeExibicao(validity) ?? '',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              // Actions (Edit & Delete)
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit_rounded,
                                        color: highlightColor,
                                        size: 19.0,
                                      ),
                                      tooltip: 'Editar Promoção',
                                      onPressed: () async {
                                        final res = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => Dialog(
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            child: ModalAlterarDescontoWidget(
                                              titulo: 'cupom',
                                              desconto: item,
                                              nomeParceiros: const [],
                                              parceiros: const [],
                                              nomeSegmentos: const [],
                                              segmentos: const [],
                                            ),
                                          ),
                                        );
                                        if (res == true && widget.onChanged != null) {
                                          await widget.onChanged!();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Color(0xFFFF5252),
                                        size: 19.0,
                                      ),
                                      tooltip: 'Excluir Promoção',
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Excluir Cupom'),
                                            content: const Text(
                                                'Tem certeza que deseja excluir essa promoção? Esta ação não pode ser desfeita.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(ctx, false),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(ctx, true),
                                                child: const Text(
                                                  'Excluir',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          final deleteRes = await DeletarCuponsCall.call(
                                            idDiscount: idCupom,
                                          );
                                          if (deleteRes.succeeded) {
                                            setState(() {
                                              _model.cuponsLocais.removeWhere((c) => getJsonField(c, r'''$.id''')?.toString() == idCupom);
                                            });
                                            if (context.mounted) {
                                              showSuccessToast(
                                                context,
                                                'Cupom excluído com sucesso!',
                                                title: 'Cupom Excluído',
                                              );
                                            }
                                            if (widget.onChanged != null) {
                                              await widget.onChanged!();
                                            }
                                          } else {
                                            if (context.mounted) {
                                              showErrorToast(
                                                context,
                                                'Erro ao excluir cupom.',
                                              );
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                );
              },
            ),
            // Rodapé Conectado de Paginação
            Builder(
              builder: (context) {
                final totalItens = _model.cuponsLocais.length;
                final totalPaginas = (totalItens / _itensPorPagina).ceil().clamp(1, 9999);
                final paginaSegura = _paginaAtual.clamp(1, totalPaginas);
                final startIndex = (paginaSegura - 1) * _itensPorPagina;
                final endIndex = (startIndex + _itensPorPagina).clamp(0, totalItens);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: borderColor, width: 1.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        totalItens > 0
                            ? 'Exibindo ${startIndex + 1}–$endIndex de $totalItens promoções'
                            : 'Nenhum registro',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded, size: 20.0),
                            color: paginaSegura > 1 ? highlightColor : Colors.white24,
                            onPressed: paginaSegura > 1
                                ? () => setState(() => _paginaAtual = paginaSegura - 1)
                                : null,
                          ),
                          Text(
                            'Página $paginaSegura de $totalPaginas',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded, size: 20.0),
                            color: paginaSegura < totalPaginas ? highlightColor : Colors.white24,
                            onPressed: paginaSegura < totalPaginas
                                ? () => setState(() => _paginaAtual = paginaSegura + 1)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
