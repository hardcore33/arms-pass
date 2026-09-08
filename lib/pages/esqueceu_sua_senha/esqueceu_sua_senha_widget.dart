import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'esqueceu_sua_senha_model.dart';
export 'esqueceu_sua_senha_model.dart';

class EsqueceuSuaSenhaWidget extends StatefulWidget {
  const EsqueceuSuaSenhaWidget({super.key});

  static String routeName = 'EsqueceuSuaSenha';
  static String routePath = '/esqueceuSuaSenha';

  @override
  State<EsqueceuSuaSenhaWidget> createState() => _EsqueceuSuaSenhaWidgetState();
}

class _EsqueceuSuaSenhaWidgetState extends State<EsqueceuSuaSenhaWidget> {
  late EsqueceuSuaSenhaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EsqueceuSuaSenhaModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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
    final goldColor = FlutterFlowTheme.of(context).secondary;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            // Background Gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF111111),
                    FlutterFlowTheme.of(context).primary,
                  ],
                  begin: const AlignmentDirectional(-1.0, -1.0),
                  end: const AlignmentDirectional(1.0, 1.0),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      width: 440.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: const Color(0xFF2C2C2C),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30.0,
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(0.0, 10.0),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Procard Logo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 140.0,
                              height: 65.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 24.0),

                          // Title
                          Text(
                            'Recuperar Acesso',
                            style: GoogleFonts.readexPro(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),

                          // Subtitle
                          Text(
                            'Informe seu e-mail cadastrado para enviarmos as instruções de redefinição de senha.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.readexPro(
                              fontSize: 13.5,
                              color: const Color(0xFF9E9E9E),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 28.0),

                          // Form
                          Form(
                            key: _model.formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'E-mail cadastrado',
                                  style: GoogleFonts.readexPro(
                                    color: const Color(0xFFD4D4D4),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                TextFormField(
                                  controller: _model.textController,
                                  focusNode: _model.textFieldFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'exemplo@empresa.com.br',
                                    hintStyle: GoogleFonts.readexPro(
                                      color: const Color(0xFF6A7074),
                                      fontSize: 14.0,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFF383838),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: goldColor,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF141414),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 16.0,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF8E8E8E),
                                      size: 20.0,
                                    ),
                                  ),
                                  style: GoogleFonts.readexPro(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                  cursorColor: goldColor,
                                  validator: _model.textControllerValidator.asValidator(context),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24.0),

                          // Submit Button
                          FFButtonWidget(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!.validate()) {
                                      return;
                                    }
                                    setState(() => _isLoading = true);
                                    try {
                                      _model.apiResultuyq = await EsqueceuASenhaCall.call(
                                        login: _model.textController.text.trim(),
                                      );

                                      if ((_model.apiResultuyq?.succeeded ?? true)) {
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              backgroundColor: const Color(0xFF222222),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14.0),
                                              ),
                                              title: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.check_circle_rounded,
                                                    color: Color(0xFF4CAF50),
                                                    size: 22.0,
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  Text(
                                                    'E-mail Enviado',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              content: const Text(
                                                'Um e-mail para redefinição de senha foi enviado para você. Verifique sua caixa de entrada e spam.',
                                                style: TextStyle(color: Color(0xFFCCCCCC)),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(alertDialogContext);
                                                    context.pushNamed(LoginWidget.routeName);
                                                  },
                                                  child: Text(
                                                    'Fazer Login',
                                                    style: TextStyle(color: goldColor),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              backgroundColor: const Color(0xFF222222),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14.0),
                                              ),
                                              title: const Text(
                                                'Algo deu errado',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              content: const Text(
                                                'Não foi possível solicitar a redefinição. Verifique o e-mail digitado e tente novamente.',
                                                style: TextStyle(color: Color(0xFFCCCCCC)),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(alertDialogContext),
                                                  child: Text(
                                                    'Ok',
                                                    style: TextStyle(color: goldColor),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    } finally {
                                      if (mounted) setState(() => _isLoading = false);
                                    }
                                  },
                            text: _isLoading ? 'Enviando...' : 'Enviar Instruções',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50.0,
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              color: goldColor,
                              textStyle: GoogleFonts.readexPro(
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                              ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          const SizedBox(height: 20.0),

                          // Back to Login Link
                          InkWell(
                            onTap: () async {
                              context.pushNamed(LoginWidget.routeName);
                            },
                            borderRadius: BorderRadius.circular(8.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_back_rounded,
                                    size: 16.0,
                                    color: goldColor,
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    'Voltar para o Login',
                                    style: GoogleFonts.readexPro(
                                      color: goldColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
