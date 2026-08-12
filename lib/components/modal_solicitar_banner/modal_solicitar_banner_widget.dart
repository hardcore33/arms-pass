import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modal_solicitar_banner_model.dart';
export 'modal_solicitar_banner_model.dart';

class ModalSolicitarBannerWidget extends StatefulWidget {
  const ModalSolicitarBannerWidget({
    super.key,
    required this.partnerId,
  });

  final String partnerId;

  @override
  State<ModalSolicitarBannerWidget> createState() =>
      _ModalSolicitarBannerWidgetState();
}

class _ModalSolicitarBannerWidgetState
    extends State<ModalSolicitarBannerWidget> {
  late ModalSolicitarBannerModel _model;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalSolicitarBannerModel());
    _model.urlTextController ??= TextEditingController();
    _model.urlFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _enviarSolicitacao() async {
    if (!_model.formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      // 1. Obter a lista global de parceiros para localizar o nome fantasia da unidade logada
      final partnersResponse = await ObterParceirosCall.call();
      String partnerName = 'Unidade Parceira';

      if (partnersResponse.succeeded) {
        final partnersList = (partnersResponse.jsonBody as List?) ?? [];
        final logado = partnersList.firstWhere(
          (p) => getJsonField(p, r'''$.id''').toString() == widget.partnerId,
          orElse: () => null,
        );
        if (logado != null) {
          partnerName = getJsonField(logado, r'''$.fantasia''')?.toString() ?? 'Unidade Parceira';
        }
      }

      // 2. Montar texto e URL de envio via WhatsApp
      final String linkDestino = _model.urlTextController.text;
      final String mensagem = 
          'Olá Administrador, sou o parceiro *$partnerName* e gostaria de solicitar a exibição de um banner promocional no aplicativo.\n\n'
          '🔗 *Link de Redirecionamento:* $linkDestino\n\n'
          '🖼️ *Estou enviando a imagem do banner em anexo a esta conversa para análise e publicação.*';

      // WhatsApp real do Administrador (configurável)
      final String whatsappNum = '5551999999999'; 
      final String whatsappUrl = 'https://wa.me/$whatsappNum?text=${Uri.encodeComponent(mensagem)}';

      // 3. Abrir o link
      await launchURL(whatsappUrl);

      // Fechar modal
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao processar solicitação: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cores explícitas Dark Premium para evitar conflito com tema Light do FlutterFlow
    final cardBgColor = const Color(0xFF1E1E1E);
    final inputBgColor = const Color(0xFF121212);
    final borderColor = const Color(0xFF2C2C2C);
    final highlightColor = FlutterFlowTheme.of(context).secondary;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Material(
        color: Colors.transparent,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.45,
          constraints: const BoxConstraints(maxHeight: 520.0),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: highlightColor,
                  ),
                )
              : Form(
                  key: _model.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solicitar Banner Promocional',
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                            font: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                            ),
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          'Envie a arte do seu banner e o link de destino para publicação no aplicativo',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 13.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        // Box Informativo de Recomendações (Tema Escuro Integrado)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: inputBgColor,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: highlightColor.withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline_rounded, color: highlightColor, size: 18.0),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    'Especificações recomendadas do Banner:',
                                    style: TextStyle(
                                      color: highlightColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                '• Formato: Retangular Horizontal\n'
                                '• Resolução ideal: 1080 x 450 pixels (proporção 2.4:1)\n'
                                '• Formato de arquivo: PNG ou JPG em alta definição\n'
                                '• Layout: Evite excesso de textos e garanta boa legibilidade',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.0,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        // Link Input
                        Text(
                          'Link de Redirecionamento (URL)*',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        TextFormField(
                          controller: _model.urlTextController,
                          focusNode: _model.urlFocusNode,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Ex: https://meusite.com.br/promocao',
                            hintStyle: const TextStyle(color: Colors.grey),
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
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: _model.urlTextControllerValidator.asValidator(context),
                        ),
                        const Spacer(),
                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FFButtonWidget(
                              onPressed: () => Navigator.pop(context),
                              text: 'Cancelar',
                              options: FFButtonOptions(
                                width: 120.0,
                                height: 45.0,
                                padding: EdgeInsets.zero,
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: borderColor,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            FFButtonWidget(
                              onPressed: _enviarSolicitacao,
                              text: 'Solicitar via WhatsApp',
                              options: FFButtonOptions(
                                width: 200.0,
                                height: 45.0,
                                padding: EdgeInsets.zero,
                                color: highlightColor,
                                textStyle: TextStyle(
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                elevation: 2.0,
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
