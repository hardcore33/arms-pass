import '/components/modal_de_alterar_customer/modal_de_alterar_customer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int _paginaAtual = 1;
  static const int _itensPorPagina = 10;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    // Paginação, ordenação e filtros locais não disparam rebuild do pai nem chamadas de rede.
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeUsuariosModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.usersLocal = widget.users?.toList().cast<dynamic>() ?? [];
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didUpdateWidget(covariant ListagemDeUsuariosWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.users != widget.users) {
      _model.usersLocal = widget.users?.toList().cast<dynamic>() ?? [];
      safeSetState(() {});
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  String _mascararDocumento(String doc) {
    if (doc.isEmpty) return '-';
    final digits = doc.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 11) {
      // Formato seguro LGPD: ***.456.789-**
      return '***.${digits.substring(3, 6)}.${digits.substring(6, 9)}-**';
    }
    if (digits.length == 14) {
      // CNPJ mascarado: **.456.789/****-**
      return '**.${digits.substring(2, 5)}.${digits.substring(5, 8)}/****-**';
    }
    if (doc.length > 5) {
      return '${doc.substring(0, 2)}***${doc.substring(doc.length - 2)}';
    }
    return doc;
  }

  List<dynamic> _filtrarEOrdenar(List<dynamic> input) {
    final termoBusca = _model.textController?.text.toLowerCase().trim() ?? '';
    final termoNumerico = termoBusca.replaceAll(RegExp(r'[^0-9]'), '');

    final filtrados = input.where((user) {
      if (termoBusca.isEmpty) return true;

      final nome = (getJsonField(user, r'''$.name''') ?? '').toString().toLowerCase();
      final email = (getJsonField(user, r'''$.user.login''') ?? '').toString().toLowerCase();
      final cpf = (getJsonField(user, r'''$.cpf''') ?? getJsonField(user, r'''$.cardNumber''') ?? '').toString().toLowerCase();
      final cpfNumerico = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      final partnerCnpj = (getJsonField(user, r'''$.partner.cnpj''') ?? '').toString().toLowerCase();
      final partnerCnpjNumerico = partnerCnpj.replaceAll(RegExp(r'[^0-9]'), '');
      final partnerFantasia = (getJsonField(user, r'''$.partner.fantasia''') ?? '').toString().toLowerCase();
      final id = (getJsonField(user, r'''$.id''') ?? '').toString().toLowerCase();

      final bateNome = nome.contains(termoBusca);
      final bateEmail = email.contains(termoBusca);
      final bateCpf = cpf.contains(termoBusca) || (termoNumerico.isNotEmpty && cpfNumerico.contains(termoNumerico));
      final batePartner = partnerFantasia.contains(termoBusca) || partnerCnpj.contains(termoBusca) || (termoNumerico.isNotEmpty && partnerCnpjNumerico.contains(termoNumerico));
      final bateId = id.contains(termoBusca);

      return bateNome || bateEmail || bateCpf || batePartner || bateId;
    }).toList();

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

    filtrados.sort((a, b) {
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

    return filtrados;
  }

  Widget _buildSortableHeader(
    BuildContext context,
    String field,
    String label,
    FlutterFlowTheme theme, {
    Alignment alignment = Alignment.centerLeft,
  }) {
    final isActive = _model.sortField == field ||
        (_model.sortField == '' && field == 'nome');
    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: () {
          safeSetState(() {
            if (_model.sortField == field) {
              _model.sortAscending = !_model.sortAscending;
            } else {
              _model.sortField = field;
              _model.sortAscending = true;
            }
            _paginaAtual = 1;
          });
        },
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.readexPro(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                  color: isActive ? theme.primary : theme.secondaryText,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 4.0),
              Icon(
                isActive
                    ? (_model.sortAscending
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded)
                    : Icons.unfold_more_rounded,
                size: 13.0,
                color: isActive
                    ? theme.secondary
                    : theme.secondaryText.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final todosUsuarios = _filtrarEOrdenar(_model.usersLocal);
    final totalItens = todosUsuarios.length;
    final totalPaginas = (totalItens / _itensPorPagina).ceil().clamp(1, 9999);
    final paginaSegura = _paginaAtual.clamp(1, totalPaginas);
    final startIndex = (paginaSegura - 1) * _itensPorPagina;
    final endIndex = (startIndex + _itensPorPagina).clamp(0, totalItens);
    final itemUsuarios = totalItens > 0 ? todosUsuarios.sublist(startIndex, endIndex) : <dynamic>[];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra Superior: Busca e Contagem
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Base de Clientes & Usuários',
                        style: GoogleFonts.readexPro(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      Text(
                        totalItens > 0
                            ? '$totalItens usuários encontrados'
                            : 'Nenhum usuário encontrado',
                        style: GoogleFonts.readexPro(
                          fontSize: 12.5,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 320.0,
                  height: 42.0,
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.textController',
                      const Duration(milliseconds: 200),
                      () {
                        setState(() {
                          _paginaAtual = 1;
                        });
                      },
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Buscar por nome, CPF ou email...',
                      hintStyle: GoogleFonts.readexPro(
                        fontSize: 12.5,
                        color: theme.secondaryText.withValues(alpha: 0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.secondary,
                        size: 18.0,
                      ),
                      suffixIcon: (_model.textController?.text.isNotEmpty ?? false)
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 16.0),
                              onPressed: () {
                                _model.textController?.clear();
                                setState(() {
                                  _paginaAtual = 1;
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.primaryBackground,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 0.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.alternate, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.secondary, width: 1.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                  ),
                ),
              ],
            ),
          ),

          // Cabeçalho da Tabela
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              border: Border(
                top: BorderSide(color: theme.alternate, width: 1.0),
                bottom: BorderSide(color: theme.alternate, width: 1.0),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 70.0,
                  child: _buildSortableHeader(context, 'id', 'ID', theme, alignment: Alignment.center),
                ),
                Expanded(
                  flex: 4,
                  child: _buildSortableHeader(context, 'nome', 'NOME', theme),
                ),
                SizedBox(
                  width: 80.0,
                  child: _buildSortableHeader(context, 'pass', 'PASS', theme, alignment: Alignment.center),
                ),
                SizedBox(
                  width: 100.0,
                  child: _buildSortableHeader(context, 'status', 'STATUS', theme, alignment: Alignment.center),
                ),
                Expanded(
                  flex: 3,
                  child: _buildSortableHeader(context, 'identificacao', 'IDENTIFICAÇÃO', theme, alignment: Alignment.center),
                ),
                Expanded(
                  flex: 4,
                  child: _buildSortableHeader(context, 'email', 'EMAIL', theme),
                ),
                const SizedBox(
                  width: 50.0,
                  child: Text(
                    'AÇÃO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Linhas dos Usuários
          if (itemUsuarios.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded, size: 36.0, color: theme.secondaryText.withOpacity(0.5)),
                    const SizedBox(height: 8.0),
                    Text(
                      'Nenhum usuário encontrado.',
                      style: GoogleFonts.readexPro(color: theme.secondaryText, fontSize: 13.5),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemUsuarios.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.0,
                thickness: 1.0,
                color: theme.alternate,
              ),
              itemBuilder: (context, index) {
                final item = itemUsuarios[index];
                final id = getJsonField(item, r'''$.id''')?.toString() ?? '';
                final name = getJsonField(item, r'''$.name''')?.toString() ?? '';
                final hasPass = getJsonField(item, r'''$.armspass''') == true;
                final isActive = getJsonField(item, r'''$.isActive''') == true ||
                    getJsonField(item, r'''$.user.isActive''') == true;
                final doc = getJsonField(item, r'''$.partner''') != null
                    ? (getJsonField(item, r'''$.partner.cnpj''')?.toString() ?? '')
                    : (getJsonField(item, r'''$.cpf''')?.toString() ?? '');
                final email = getJsonField(item, r'''$.user.login''')?.toString() ?? '';

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Row(
                    children: [
                      // ID
                      SizedBox(
                        width: 70.0,
                        child: Text(
                          id,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.readexPro(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryText,
                          ),
                        ),
                      ),

                      // Nome
                      Expanded(
                        flex: 4,
                        child: Text(
                          name.isNotEmpty ? name : 'Sem nome',
                          style: GoogleFonts.readexPro(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: theme.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // PASS
                      SizedBox(
                        width: 80.0,
                        child: Center(
                          child: hasPass
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF00C853),
                                  size: 18.0,
                                )
                              : Icon(
                                  Icons.remove_circle_outline_rounded,
                                  color: theme.secondaryText.withOpacity(0.4),
                                  size: 18.0,
                                ),
                        ),
                      ),

                      // Status
                      SizedBox(
                        width: 100.0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0x2000C853) : const Color(0x15909090),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Text(
                              isActive ? 'Ativo' : 'Inativo',
                              style: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
                                color: isActive ? const Color(0xFF00C853) : theme.secondaryText,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Identificação (CPF/CNPJ Mascarado LGPD)
                      Expanded(
                        flex: 3,
                        child: Text(
                          _mascararDocumento(doc),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.readexPro(
                            fontSize: 12.5,
                            color: theme.primaryText,
                          ),
                        ),
                      ),

                      // Email
                      Expanded(
                        flex: 4,
                        child: Text(
                          email,
                          style: GoogleFonts.readexPro(
                            fontSize: 12.5,
                            color: theme.secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Ação (Editar)
                      SizedBox(
                        width: 50.0,
                        child: Center(
                          child: InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: const AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: ModalDeAlterarCustomerWidget(
                                      customer: item,
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() => _model.resultadoDialog = value));

                              if (_model.resultadoDialog == true) {
                                await widget.onUserEdit?.call();
                                if (context.mounted) {
                                  showSuccessToast(
                                    context,
                                    'Cadastro atualizado com sucesso!',
                                    title: 'Usuário Atualizado',
                                  );
                                }
                                _model.usersLocal = widget.users?.toList().cast<dynamic>() ?? [];
                                safeSetState(() {});
                              }
                            },
                            borderRadius: BorderRadius.circular(6.0),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: FaIcon(
                                FontAwesomeIcons.penToSquare,
                                color: theme.secondary,
                                size: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Rodapé Conectado de Paginação
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme.alternate, width: 1.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalItens > 0
                      ? 'Exibindo ${startIndex + 1}–$endIndex de $totalItens usuários'
                      : 'Nenhum registro',
                  style: GoogleFonts.readexPro(
                    fontSize: 12.0,
                    color: theme.secondaryText,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, size: 20.0),
                      color: paginaSegura > 1
                          ? theme.primary
                          : theme.secondaryText.withOpacity(0.3),
                      onPressed: paginaSegura > 1
                          ? () => setState(() => _paginaAtual = paginaSegura - 1)
                          : null,
                    ),
                    Text(
                      'Página $paginaSegura de $totalPaginas',
                      style: GoogleFonts.readexPro(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, size: 20.0),
                      color: paginaSegura < totalPaginas
                          ? theme.primary
                          : theme.secondaryText.withOpacity(0.3),
                      onPressed: paginaSegura < totalPaginas
                          ? () => setState(() => _paginaAtual = paginaSegura + 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
