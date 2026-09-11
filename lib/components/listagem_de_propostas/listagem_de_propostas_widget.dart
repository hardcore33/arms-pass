import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'listagem_de_propostas_model.dart';
export 'listagem_de_propostas_model.dart';

class ListagemDePropostasWidget extends StatefulWidget {
  const ListagemDePropostasWidget({
    super.key,
    required this.propostas,
    this.onAction,
  });

  final List<dynamic>? propostas;
  final Future Function()? onAction;

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
    if (widget.propostas != null) {
      _model.propostasLocal = widget.propostas!.toList().cast<dynamic>();
    }

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void didUpdateWidget(covariant ListagemDePropostasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.propostas != oldWidget.propostas) {
      _model.propostasLocal = widget.propostas?.toList().cast<dynamic>() ?? [];
      safeSetState(() {});
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  String _getRazao(dynamic item) {
    final val = getJsonField(item, r'''$.razao''') ?? getJsonField(item, r'''$.razaoSocial''');
    return val != null ? val.toString() : '';
  }

  String _getNome(dynamic item) {
    final val = getJsonField(item, r'''$.nomeRepresentante''') ?? getJsonField(item, r'''$.responsavel''');
    return val != null ? val.toString() : '';
  }

  String _getTelefone(dynamic item) {
    final val = getJsonField(item, r'''$.telefoneRepresentante''') ?? getJsonField(item, r'''$.phone''');
    return val != null ? val.toString() : '';
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
            Container(
              decoration: BoxDecoration(
                color: theme.alternate,
                borderRadius: BorderRadius.circular(
                  theme.designToken.radius.sm,
                ),
              ),
              padding: const EdgeInsetsDirectional.fromSTEB(
                  16.0, 12.0, 16.0, 12.0),
              child: const Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 60.0,
                    child: Text(
                      'ID',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF909090),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'RAZÃO',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF909090),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'NOME',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF909090),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'TELEFONE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF909090),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'PROPOSTA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF909090),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 85.0,
                    child: Text(
                      'AÇÕES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF909090),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                final itemPropostas = _model.propostasLocal.toList();
                if (itemPropostas.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            color: theme.secondaryText,
                            size: 48.0,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'Nenhuma proposta encontrada',
                            style: GoogleFonts.openSans(
                              fontSize: 15.0,
                              color: theme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: itemPropostas.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: theme.alternate,
                  ),
                  itemBuilder: (context, itemPropostasIndex) {
                    final itemPropostasItem =
                        itemPropostas[itemPropostasIndex];
                    final id = getJsonField(itemPropostasItem, r'''$.id''')
                            ?.toString() ??
                        '';
                    final razao = _getRazao(itemPropostasItem);
                    final nome = _getNome(itemPropostasItem);
                    final telefone = _getTelefone(itemPropostasItem);
                    final proposta = getJsonField(
                            itemPropostasItem, r'''$.proposta''')
                        ?.toString() ??
                        '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 60.0,
                            child: Text(
                              id,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.readexPro(
                                fontSize: 13.5,
                                color: theme.primaryText,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              razao,
                              style: GoogleFonts.readexPro(
                                fontSize: 13.5,
                                color: theme.primaryText,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              nome,
                              style: GoogleFonts.readexPro(
                                fontSize: 13.5,
                                color: theme.primaryText,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              telefone,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.readexPro(
                                fontSize: 13.5,
                                color: theme.primaryText,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              proposta.isNotEmpty ? proposta : '-',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.readexPro(
                                fontSize: 13.5,
                                color: theme.secondaryText,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 85.0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Tooltip(
                                  message: 'Aprovar proposta',
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.0),
                                    onTap: () async {
                                      final confirmDialogResponse =
                                          await showConfirmationDialog(
                                        context,
                                        title: 'Aprovar proposta',
                                        message:
                                            'Tem certeza que deseja aprovar a proposta de "$razao"? Um novo parceiro será criado e a proposta não poderá ser recuperada.',
                                        confirmText: 'Aprovar',
                                        isDestructive: false,
                                      );
                                      if (!confirmDialogResponse) {
                                        return;
                                      }
                                      _model.apiResultrv3 =
                                          await CriarUsuarioCall.call(
                                        idTenant: FFAppConstants.tenantId,
                                        email: getJsonField(
                                          itemPropostasItem,
                                          r'''$.email''',
                                        )?.toString() ??
                                            '',
                                        senha: getJsonField(
                                          itemPropostasItem,
                                          r'''$.senha''',
                                        )?.toString() ??
                                            '',
                                        razao: razao,
                                        cnpj: getJsonField(
                                          itemPropostasItem,
                                          r'''$.cnpj''',
                                        )?.toString() ??
                                            '',
                                        cep: getJsonField(
                                          itemPropostasItem,
                                          r'''$.cep''',
                                        )?.toString() ??
                                            '',
                                        rua: getJsonField(
                                          itemPropostasItem,
                                          r'''$.rua''',
                                        )?.toString() ??
                                            '',
                                        bairro: getJsonField(
                                          itemPropostasItem,
                                          r'''$.bairro''',
                                        )?.toString() ??
                                            '',
                                        numero: getJsonField(
                                          itemPropostasItem,
                                          r'''$.numero''',
                                        )?.toString() ??
                                            '',
                                        cidade: getJsonField(
                                          itemPropostasItem,
                                          r'''$.cidade''',
                                        )?.toString() ??
                                            '',
                                        telefoneRepresentante: telefone,
                                        representanteNome: nome,
                                      );

                                      if ((_model.apiResultrv3?.succeeded ??
                                          true)) {
                                        await DeletarPropostaCall.call(
                                            idProposta: id);
                                        _model.removeFromPropostasLocal(
                                            itemPropostasItem);
                                        safeSetState(() {});
                                        ApiManager.clearCache('obterPropostas');
                                        if (widget.onAction != null) {
                                          await widget.onAction!.call();
                                        }
                                        if (context.mounted) {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Proposta aceita'),
                                                content: const Text(
                                                    'O parceiro foi adicionado com sucesso.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: const Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Algo deu errado'),
                                                content: const Text(
                                                    'Não foi possível aprovar a proposta, tente novamente.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: const Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3E9F4C)
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        color: Color(0xFF3E9F4C),
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Tooltip(
                                  message: 'Recusar proposta',
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.0),
                                    onTap: () async {
                                      final confirmDialogResponse =
                                          await showConfirmationDialog(
                                        context,
                                        title: 'Recusar proposta',
                                        message:
                                            'Tem certeza que deseja recusar a proposta de "$razao"? Essa ação não pode ser desfeita.',
                                        confirmText: 'Recusar',
                                        isDestructive: true,
                                      );
                                      if (!confirmDialogResponse) {
                                        return;
                                      }

                                      // Atualização imediata da UI
                                      _model.removeFromPropostasLocal(
                                          itemPropostasItem);
                                      safeSetState(() {});

                                      final result =
                                          await DeletarPropostaCall.call(
                                              idProposta: id);

                                      if (result.succeeded) {
                                        ApiManager.clearCache('obterPropostas');
                                        if (widget.onAction != null) {
                                          await widget.onAction!.call();
                                        }
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Proposta recusada com sucesso.'),
                                              backgroundColor:
                                                  Color(0xFFBC1616),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      } else {
                                        _model.addToPropostasLocal(
                                            itemPropostasItem);
                                        safeSetState(() {});
                                        if (context.mounted) {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Algo deu errado'),
                                                content: const Text(
                                                    'Não foi possível recusar a proposta.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: const Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFBC1616)
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Color(0xFFBC1616),
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            ],
          ),
        ),
      );
    }
  }
