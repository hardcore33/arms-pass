import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modal_alterar_senha_parceiro_model.dart';
export 'modal_alterar_senha_parceiro_model.dart';

class ModalAlterarSenhaParceiroWidget extends StatefulWidget {
  const ModalAlterarSenhaParceiroWidget({super.key});

  @override
  State<ModalAlterarSenhaParceiroWidget> createState() =>
      _ModalAlterarSenhaParceiroWidgetState();
}

class _ModalAlterarSenhaParceiroWidgetState
    extends State<ModalAlterarSenhaParceiroWidget> {
  late ModalAlterarSenhaParceiroModel _model;
  bool _salvando = false;
  String? _erroValidacao;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAlterarSenhaParceiroModel());

    _model.senhaTextController ??= TextEditingController();
    _model.senhaFocusNode ??= FocusNode();

    _model.confirmSenhaTextController ??= TextEditingController();
    _model.confirmSenhaFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _salvarNovaSenha() async {
    setState(() => _erroValidacao = null);

    final novaSenha = _model.senhaTextController?.text.trim() ?? '';
    final confirmSenha = _model.confirmSenhaTextController?.text.trim() ?? '';

    if (novaSenha.isEmpty) {
      setState(() => _erroValidacao = 'Por favor, digite a nova senha.');
      return;
    }

    if (novaSenha.length < 6) {
      setState(() => _erroValidacao = 'A nova senha deve ter no mínimo 6 caracteres.');
      return;
    }

    if (novaSenha != confirmSenha) {
      setState(() => _erroValidacao = 'A confirmação de senha não confere.');
      return;
    }

    setState(() => _salvando = true);

    try {
      final parceiroJson = FFAppState().parceiro;
      final userId = castToType<int>(getJsonField(parceiroJson, r'$.user.id'));
      final userLogin = getJsonField(parceiroJson, r'$.user.login')?.toString() ?? '';

      if (userId == null) {
        throw Exception('Identificador do usuário da loja não encontrado na sessão.');
      }

      final res = await AtualizarDadosCall.call(
        id: userId.toString(),
        email: userLogin,
        password: novaSenha,
        role: 1,
      );

      if (res.succeeded) {
        if (mounted) {
          showSuccessToast(context, 'Senha de acesso atualizada com sucesso!');
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          setState(() {
            _salvando = false;
            _erroValidacao = 'Não foi possível salvar a nova senha. Tente novamente.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _salvando = false;
          _erroValidacao = 'Erro ao atualizar: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final parceiroJson = FFAppState().parceiro;
    final partnerName = getJsonField(parceiroJson, r'$.partner.fantasia')?.toString() ??
        getJsonField(parceiroJson, r'$.partner.fantasy')?.toString() ??
        getJsonField(parceiroJson, r'$.name')?.toString() ??
        'Minha Loja';
    final userLogin = getJsonField(parceiroJson, r'$.user.login')?.toString() ?? '';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: 480.0,
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F2),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFFC5BCA8),
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x140F172A),
              blurRadius: 24.0,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C8268).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: const Color(0xFF8C8268).withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: Color(0xFF8C8268),
                        size: 22.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alterar Senha de Acesso',
                          style: GoogleFonts.readexPro(
                            color: const Color(0xFF0F172A),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          partnerName,
                          style: GoogleFonts.openSans(
                            color: const Color(0xFF64748B),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 20.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Informação do login da loja
            if (userLogin.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFECE4),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: const Color(0xFFC5BCA8)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_circle_outlined, color: Color(0xFF524B3E), size: 18.0),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Login de Acesso: $userLogin',
                        style: GoogleFonts.openSans(
                          color: const Color(0xFF0F172A),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20.0),

            // Nova Senha
            Text(
              'Nova Senha',
              style: GoogleFonts.readexPro(
                color: const Color(0xFF524B3E),
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6.0),
            TextFormField(
              controller: _model.senhaTextController,
              focusNode: _model.senhaFocusNode,
              obscureText: !_model.senhaVisibility,
              style: GoogleFonts.readexPro(color: const Color(0xFF0F172A), fontSize: 14.0),
              decoration: InputDecoration(
                hintText: 'Digite no mínimo 6 caracteres',
                hintStyle: GoogleFonts.readexPro(color: const Color(0xFF94A3B8), fontSize: 13.0),
                filled: true,
                fillColor: const Color(0xFFEFECE4),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFC5BCA8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFC5BCA8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFF8C8268)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _model.senhaVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: const Color(0xFF64748B),
                    size: 20.0,
                  ),
                  onPressed: () => setState(() => _model.senhaVisibility = !_model.senhaVisibility),
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Confirmar Senha
            Text(
              'Confirmar Nova Senha',
              style: GoogleFonts.readexPro(
                color: const Color(0xFF524B3E),
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6.0),
            TextFormField(
              controller: _model.confirmSenhaTextController,
              focusNode: _model.confirmSenhaFocusNode,
              obscureText: !_model.confirmSenhaVisibility,
              style: GoogleFonts.readexPro(color: const Color(0xFF0F172A), fontSize: 14.0),
              decoration: InputDecoration(
                hintText: 'Repita a nova senha',
                hintStyle: GoogleFonts.readexPro(color: const Color(0xFF94A3B8), fontSize: 13.0),
                filled: true,
                fillColor: const Color(0xFFEFECE4),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFC5BCA8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFC5BCA8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFF8C8268)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _model.confirmSenhaVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: const Color(0xFF64748B),
                    size: 20.0,
                  ),
                  onPressed: () => setState(() => _model.confirmSenhaVisibility = !_model.confirmSenhaVisibility),
                ),
              ),
            ),

            if (_erroValidacao != null) ...[
              const SizedBox(height: 14.0),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18.0),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        _erroValidacao!,
                        style: GoogleFonts.openSans(color: Colors.redAccent, fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24.0),

            // Ações
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _salvando ? null : () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.openSans(color: const Color(0xFF64748B), fontSize: 13.0),
                  ),
                ),
                const SizedBox(width: 12.0),
                FFButtonWidget(
                  onPressed: _salvando ? null : _salvarNovaSenha,
                  text: _salvando ? 'Salvando...' : 'Salvar Nova Senha',
                  options: FFButtonOptions(
                    height: 42.0,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    color: const Color(0xFF8C8268),
                    textStyle: GoogleFonts.readexPro(
                      color: const Color(0xFFFAF7F2),
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
