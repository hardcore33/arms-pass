import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modal_de_alterar_usuario_model.dart';
export 'modal_de_alterar_usuario_model.dart';

class ModalDeAlterarUsuarioWidget extends StatefulWidget {
  const ModalDeAlterarUsuarioWidget({
    super.key,
    required this.titulo,
    required this.senha,
    required this.usuario,
    required this.role,
    required this.inviteCode,
    required this.id,
  });

  final String? titulo;
  final String? senha;
  final String? usuario;
  final int? role;
  final String? inviteCode;
  final String? id;

  @override
  State<ModalDeAlterarUsuarioWidget> createState() =>
      _ModalDeAlterarUsuarioWidgetState();
}

class _ModalDeAlterarUsuarioWidgetState
    extends State<ModalDeAlterarUsuarioWidget> {
  late ModalDeAlterarUsuarioModel _model;
  bool _salvando = false;
  bool _senhaVisivel = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalDeAlterarUsuarioModel());

    _model.textController1 ??= TextEditingController(text: widget.usuario != 'null' ? widget.usuario : '');
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(text: (widget.senha != null && widget.senha != 'null') ? widget.senha : '');
    _model.textFieldFocusNode2 ??= FocusNode();

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
    Widget? suffixIcon,
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
      suffixIcon: suffixIcon,
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

  Future<void> _submeterEdicao() async {
    if (_model.textController1?.text.trim().isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, informe o e-mail / login.')),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      _model.apiResult004 = await AtualizarDadosCall.call(
        id: widget.id,
        email: _model.textController1?.text.trim() ?? '',
        password: _model.textController2?.text.trim() ?? '',
        inviteCode: widget.inviteCode,
        role: widget.role,
      );

      if ((_model.apiResult004?.succeeded ?? false)) {
        if (mounted) {
          showSuccessToast(
            context,
            'Usuário atualizado com sucesso!',
            title: 'Usuário Atualizado',
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          showErrorToast(
            context,
            'Não foi possível atualizar o usuário.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          'Erro: $e',
        );
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
        width: (MediaQuery.sizeOf(context).width * 0.50).clamp(440.0, 560.0),
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
                      Icons.manage_accounts_rounded,
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
                          'Editar ${widget.titulo ?? 'Usuário'}',
                          style: GoogleFonts.readexPro(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryText,
                          ),
                        ),
                        Text(
                          'Atualize as credenciais de acesso ao painel.',
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
                    // E-mail / Login
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
                      controller: _model.textController1,
                      focusNode: _model.textFieldFocusNode1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(
                        'usuario@email.com',
                        theme,
                        prefixIcon: Icon(Icons.mail_outline_rounded, color: theme.secondary, size: 18.0),
                      ),
                      style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                    ),

                    const SizedBox(height: 16.0),

                    // Senha
                    Text(
                      'Senha de Acesso',
                      style: GoogleFonts.readexPro(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    TextFormField(
                      controller: _model.textController2,
                      focusNode: _model.textFieldFocusNode2,
                      obscureText: !_senhaVisivel,
                      decoration: _buildInputDecoration(
                        'Deixe em branco para manter a senha atual',
                        theme,
                        prefixIcon: Icon(Icons.lock_outline_rounded, color: theme.secondary, size: 18.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _senhaVisivel ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: theme.secondaryText,
                            size: 20.0,
                          ),
                          onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                        ),
                      ),
                      style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
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
