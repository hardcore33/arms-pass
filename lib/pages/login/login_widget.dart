import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'Login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final isDesktop = MediaQuery.sizeOf(context).width >= 860.0;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: isDesktop
            ? Row(
                children: [
                  // Lado Esquerdo: Fundo Preto com Logo Oficial ARMS PASS
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: double.infinity,
                      color: Colors.black,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420.0, maxHeight: 420.0),
                            child: Image.asset(
                              'assets/images/arms_pass_icon.png',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Lado Direito: Fundo Areia Sofisticado com Formulário de Login
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: double.infinity,
                      color: const Color(0xFFEFECE6),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 40.0),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 420.0),
                              child: _buildLoginForm(context, isDesktop: true),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            // Layout Mobile / Telas Pequenas
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Image.asset(
                                'assets/images/arms_pass_icon.png',
                                width: 180.0,
                                height: 120.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(maxWidth: 400.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFECE6),
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: const Color(0xFFD4CFC5),
                                  width: 1.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 20.0,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(28.0),
                              child: _buildLoginForm(context, isDesktop: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, {required bool isDesktop}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Entrar',
          style: GoogleFonts.openSans(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF14181B),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          'Bem-vindo de volta! Insira suas credenciais.',
          style: GoogleFonts.openSans(
            fontSize: 14.0,
            color: const Color(0xFF5D5950),
          ),
        ),
        const SizedBox(height: 28.0),
        Form(
          key: _model.formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo E-mail / CNPJ
              Text(
                'E-mail ou CNPJ',
                style: GoogleFonts.openSans(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF14181B),
                ),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                controller: _model.textController1,
                focusNode: _model.textFieldFocusNode1,
                autofocus: false,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Digite seu e-mail ou CNPJ',
                  hintStyle: GoogleFonts.openSans(
                    fontSize: 14.0,
                    color: const Color(0xFF8C887E),
                  ),
                  prefixIcon: const Icon(
                    Icons.badge_outlined,
                    color: Color(0xFF7A756B),
                    size: 20.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFD4CFC5),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF14181B),
                      width: 1.8,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                ),
                style: GoogleFonts.openSans(
                  fontSize: 14.0,
                  color: const Color(0xFF14181B),
                ),
                validator: _model.textController1Validator.asValidator(context),
              ),

              const SizedBox(height: 18.0),

              // Campo Senha
              Text(
                'Senha',
                style: GoogleFonts.openSans(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF14181B),
                ),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                controller: _model.textController2,
                focusNode: _model.textFieldFocusNode2,
                autofocus: false,
                obscureText: !_model.passwordVisibility,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Digite sua senha',
                  hintStyle: GoogleFonts.openSans(
                    fontSize: 14.0,
                    color: const Color(0xFF8C887E),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Color(0xFF7A756B),
                    size: 20.0,
                  ),
                  suffixIcon: InkWell(
                    onTap: () async {
                      safeSetState(() => _model.passwordVisibility = !_model.passwordVisibility);
                    },
                    focusNode: FocusNode(skipTraversal: true),
                    child: Icon(
                      _model.passwordVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: const Color(0xFF7A756B),
                      size: 20.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFD4CFC5),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF14181B),
                      width: 1.8,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                ),
                style: GoogleFonts.openSans(
                  fontSize: 14.0,
                  color: const Color(0xFF14181B),
                ),
                validator: _model.textController2Validator.asValidator(context),
              ),

              const SizedBox(height: 12.0),

              // Esqueceu sua senha
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () async {
                    context.pushNamed(EsqueceuSuaSenhaWidget.routeName);
                  },
                  child: Text(
                    'Esqueceu sua senha?',
                    style: GoogleFonts.openSans(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF14181B),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Botão Entrar
              FFButtonWidget(
                onPressed: () async {
                  if (_model.formKey.currentState == null || !_model.formKey.currentState!.validate()) {
                    return;
                  }
                  _model.usuario = await LoginCall.call(
                    login: _model.textController1.text,
                    senha: _model.textController2.text,
                  );

                  if ((_model.usuario?.succeeded ?? true)) {
                    GoRouter.of(context).prepareAuthEvent();
                    final dynamic rawToken = getJsonField(_model.usuario?.jsonBody, r'''$.token''') ??
                        getJsonField(_model.usuario?.jsonBody, r'''$.accessToken''') ??
                        getJsonField(_model.usuario?.jsonBody, r'''$.jwt''');
                    final String? token = rawToken?.toString();
                    await authManager.signIn(
                      authenticationToken: token,
                      authUid: getJsonField(
                        (_model.usuario?.jsonBody ?? ''),
                        r'''$.id''',
                      ).toString(),
                    );
                    if (token != null && token.isNotEmpty) {
                      ApiManager.setAccessToken(token);
                    }
                    if (LoginCall.role((_model.usuario?.jsonBody ?? '')) == 2) {
                      FFAppState().indexPage = 1;
                      safeSetState(() {});
                      context.pushNamedAuth(DashboardWidget.routeName, context.mounted);
                    } else if (LoginCall.role((_model.usuario?.jsonBody ?? '')) == 1) {
                      FFAppState().parceiro = (_model.usuario?.jsonBody ?? '');
                      // DEBUG: imprime a estrutura do JSON do parceiro no console
                      debugPrint('[PARCEIRO_JSON] ${(_model.usuario?.jsonBody ?? '').toString()}');
                      safeSetState(() {});
                      FFAppState().indexPage = 1;
                      safeSetState(() {});
                      context.pushNamedAuth(DashboardParceiroWidget.routeName, context.mounted);
                    }
                  } else {
                    await showDialog(
                      context: context,
                      builder: (alertDialogContext) {
                        return AlertDialog(
                          title: const Row(
                            children: [
                              Icon(Icons.error_outline_rounded, color: Colors.red, size: 24.0),
                              SizedBox(width: 8.0),
                              Text('Falha no Acesso'),
                            ],
                          ),
                          content: const Text('Usuário ou senha incorretos. Por favor, tente novamente.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(alertDialogContext),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }

                  safeSetState(() {});
                },
                text: 'Entrar no Painel',
                icon: const Icon(Icons.login_rounded, size: 18.0),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 48.0,
                  color: const Color(0xFF14181B),
                  textStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14.5,
                  ),
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),

              const SizedBox(height: 14.0),

              // Botão Seja um parceiro
              OutlinedButton(
                onPressed: () async {
                  context.pushNamed(PreCadastroWidget.routeName);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48.0),
                  side: const BorderSide(
                    color: Color(0xFF14181B),
                    width: 1.4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Seja um Parceiro Credenciado',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF14181B),
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
