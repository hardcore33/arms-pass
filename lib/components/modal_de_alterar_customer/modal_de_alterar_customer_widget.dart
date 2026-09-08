import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'modal_de_alterar_customer_model.dart';
export 'modal_de_alterar_customer_model.dart';

class ModalDeAlterarCustomerWidget extends StatefulWidget {
  const ModalDeAlterarCustomerWidget({
    super.key,
    required this.customer,
  });

  final dynamic customer;

  @override
  State<ModalDeAlterarCustomerWidget> createState() =>
      _ModalDeAlterarCustomerWidgetState();
}

class _ModalDeAlterarCustomerWidgetState
    extends State<ModalDeAlterarCustomerWidget> {
  late ModalDeAlterarCustomerModel _model;
  bool _salvando = false;
  bool _enviandoReset = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalDeAlterarCustomerModel());

    final nome = getJsonField(widget.customer, r'''$.name''')?.toString() ?? '';
    _model.nomeTextController ??= TextEditingController(text: nome != 'null' ? nome : '');
    _model.nomeFocusNode ??= FocusNode();

    final cpfRaw = (getJsonField(widget.customer, r'''$.cpf''') ?? getJsonField(widget.customer, r'''$.cardNumber''') ?? '').toString();
    _model.identificacaoTextController ??= TextEditingController(text: cpfRaw != 'null' ? cpfRaw : '');
    _model.identificacaoFocusNode ??= FocusNode();
    _model.identificacaoMask = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    final login = getJsonField(widget.customer, r'''$.user.login''')?.toString() ?? '';
    _model.emailTextController ??= TextEditingController(text: login != 'null' ? login : '');
    _model.emailFocusNode ??= FocusNode();

    final armspassRaw = getJsonField(widget.customer, r'''$.armspass''');
    _model.armspassValue = armspassRaw == true;

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(
    String label,
    FlutterFlowTheme theme, {
    String? hint,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.readexPro(
        fontSize: 13.0,
        color: theme.secondaryText,
      ),
      hintText: hint,
      hintStyle: GoogleFonts.readexPro(
        fontSize: 12.5,
        color: theme.secondaryText.withValues(alpha: 0.6),
      ),
      prefixIcon: prefixIcon,
      isDense: true,
      filled: true,
      fillColor: theme.primaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.alternate, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.secondary, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Future<void> _enviarResetSenha() async {
    final email = _model.emailTextController?.text.trim() ?? '';
    if (email.isEmpty) {
      showWarningToast(context, 'Por favor, informe o e-mail do usuário.');
      return;
    }

    setState(() => _enviandoReset = true);
    try {
      final res = await EsqueceuASenhaCall.call(login: email);
      if (res.succeeded) {
        if (mounted) {
          showSuccessToast(
            context,
            'Instruções para redefinição de senha enviadas para "$email"!',
            title: 'E-mail Enviado',
          );
        }
      } else {
        if (mounted) {
          showErrorToast(
            context,
            'Não foi possível enviar a mensagem. Verifique se o e-mail está correto.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(context, 'Erro: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _enviandoReset = false);
      }
    }
  }

  Future<void> _submeterEdicao() async {
    if (_model.nomeTextController?.text.trim().isEmpty ?? true) {
      showWarningToast(context, 'Por favor, informe o nome completo.');
      return;
    }
    if (_model.emailTextController?.text.trim().isEmpty ?? true) {
      showWarningToast(context, 'Por favor, informe o e-mail.');
      return;
    }

    setState(() => _salvando = true);

    try {
      _model.apiResult005 = await EditarCustomerCall.call(
        id: getJsonField(widget.customer, r'''$.id'''),
        name: _model.nomeTextController?.text.trim() ?? '',
        armspass: _model.armspassValue,
        cardNumber: _model.identificacaoTextController?.text.trim() ?? '',
        cpf: _model.identificacaoTextController?.text.trim() ?? '',
        isActive: getJsonField(widget.customer, r'''$.isActive'''),
        tenantJson: getJsonField(widget.customer, r'''$.tenant'''),
        walletJson: getJsonField(widget.customer, r'''$.wallet'''),
        partnerJson: getJsonField(widget.customer, r'''$.partner'''),
        userId: getJsonField(widget.customer, r'''$.user.id'''),
        userIsActive: getJsonField(widget.customer, r'''$.user.isActive'''),
        userInviteCode: (getJsonField(widget.customer, r'''$.user.inviteCode''') ?? '').toString(),
        userLogin: _model.emailTextController?.text.trim() ?? '',
        userRole: getJsonField(widget.customer, r'''$.user.role'''),
      );

      if ((_model.apiResult005?.succeeded ?? false)) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          showErrorToast(
            context,
            'Não foi possível atualizar o cadastro.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(context, 'Erro: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: (MediaQuery.sizeOf(context).width * 0.50).clamp(460.0, 580.0),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 24.0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 20.0, 16.0),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: theme.secondary,
                      size: 22.0,
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Editar Usuário',
                          style: GoogleFonts.readexPro(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryText,
                          ),
                        ),
                        Text(
                          'Atualize as informações cadastrais do associado.',
                          style: GoogleFonts.readexPro(
                            fontSize: 12.5,
                            color: theme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.secondaryText, size: 22.0),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1.0),

            // Form Body
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _model.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome Completo
                    Text(
                      'Nome Completo *',
                      style: GoogleFonts.readexPro(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    TextFormField(
                      controller: _model.nomeTextController,
                      focusNode: _model.nomeFocusNode,
                      decoration: _buildInputDecoration(
                        'Nome completo',
                        theme,
                        prefixIcon: Icon(Icons.person_outline_rounded, color: theme.secondary, size: 18.0),
                      ),
                      style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                    ),

                    const SizedBox(height: 16.0),

                    // Identificação (CPF)
                    Text(
                      'Identificação (CPF) *',
                      style: GoogleFonts.readexPro(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    TextFormField(
                      controller: _model.identificacaoTextController,
                      focusNode: _model.identificacaoFocusNode,
                      inputFormatters: [_model.identificacaoMask],
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        '000.000.000-00',
                        theme,
                        prefixIcon: Icon(Icons.badge_outlined, color: theme.secondary, size: 18.0),
                      ),
                      style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                    ),

                    const SizedBox(height: 16.0),

                    // E-mail de Login
                    Text(
                      'E-mail de Login *',
                      style: GoogleFonts.readexPro(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    TextFormField(
                      controller: _model.emailTextController,
                      focusNode: _model.emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(
                        'usuario@email.com',
                        theme,
                        prefixIcon: Icon(Icons.mail_outline_rounded, color: theme.secondary, size: 18.0),
                      ),
                      style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                    ),

                    const SizedBox(height: 18.0),

                    // Card de Status Arms Pró
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: _model.armspassValue
                            ? theme.secondary.withValues(alpha: 0.12)
                            : theme.primaryBackground,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _model.armspassValue
                              ? theme.secondary
                              : theme.alternate,
                          width: _model.armspassValue ? 1.2 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: theme.secondary.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.verified_rounded,
                              color: theme.secondary,
                              size: 22.0,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Membro Arms Pró',
                                      style: GoogleFonts.readexPro(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryText,
                                      ),
                                    ),
                                    const SizedBox(width: 6.0),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: theme.secondary,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        'VIP',
                                        style: GoogleFonts.readexPro(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          color: theme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  _model.armspassValue
                                      ? 'Assinatura ativa. O cliente possui acesso VIP aos benefícios e ginásio.'
                                      : 'Assinatura inativa. O cliente está no plano padrão.',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: theme.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: _model.armspassValue,
                            activeThumbColor: theme.secondary,
                            onChanged: (val) {
                              setState(() {
                                _model.armspassValue = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18.0),

                    // Card de Redefinição de Senha
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: theme.primaryBackground,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: theme.alternate),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_reset_rounded, color: theme.secondary, size: 22.0),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Acesso & Senha',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryText,
                                  ),
                                ),
                                Text(
                                  'Enviar link para o usuário cadastrar ou alterar sua senha.',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 11.0,
                                    color: theme.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          OutlinedButton.icon(
                            onPressed: _enviandoReset ? null : _enviarResetSenha,
                            icon: _enviandoReset
                                ? SizedBox(
                                    width: 14.0,
                                    height: 14.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: theme.secondary,
                                    ),
                                  )
                                : Icon(Icons.send_rounded, size: 14.0, color: theme.primaryText),
                            label: Text(
                              _enviandoReset ? 'Enviando...' : 'Enviar Link',
                              style: GoogleFonts.readexPro(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryText,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              side: BorderSide(color: theme.secondary.withValues(alpha: 0.5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            const Divider(height: 1.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _salvando ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                      side: BorderSide(color: theme.alternate),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.readexPro(
                        color: theme.secondaryText,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  FFButtonWidget(
                    onPressed: _salvando ? null : _submeterEdicao,
                    text: _salvando ? 'Salvando...' : 'Atualizar Dados',
                    icon: _salvando
                        ? null
                        : Icon(
                            Icons.check_rounded,
                            color: theme.secondary,
                            size: 18.0,
                          ),
                    options: FFButtonOptions(
                      height: 44.0,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      color: theme.primary,
                      textStyle: GoogleFonts.readexPro(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
