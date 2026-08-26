import '/backend/api_requests/api_calls.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import 'mensagens_model.dart';
export 'mensagens_model.dart';

class MensagensWidget extends StatefulWidget {
  const MensagensWidget({super.key});

  static String routeName = 'Mensagens';
  static String routePath = '/mensagens';

  @override
  State<MensagensWidget> createState() => _MensagensWidgetState();
}

class _MensagensWidgetState extends State<MensagensWidget> {
  late MensagensModel _model;
  bool _isSending = false;
  int _selectedTab = 0; // 0 = Disparo Manual, 1 = Histórico de Envios, 2 = Cerca Digital & Automações

  // Controle de Validade / Expiração do Disparo
  String _validadeSelecionada = 'Sem expiração';

  // Histórico de Notificações
  bool _isLoadingHistory = false;
  List<Map<String, dynamic>> _historicoNotificacoes = [];
  String _filtroHistorico = 'todos'; // todos, ativos, expirados
  String _termoBuscaHistorico = '';
  final TextEditingController _buscaHistoricoController = TextEditingController();

  // Estados das Automações / Cerca Digital
  bool _geofenceEnabled = true;
  String _geofenceRadius = '500m';
  late TextEditingController _geofenceMsgController;

  bool _posCompraEnabled = true;
  late TextEditingController _posCompraMsgController;

  bool _inatividadeEnabled = true;
  String _inatividadeDias = '15 dias';
  late TextEditingController _inatividadeMsgController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MensagensModel());

    _model.enviadoPorTextController ??= TextEditingController(text: 'Clube Procard');
    _model.enviadoPorFocusNode ??= FocusNode();

    _model.tituloTextController ??= TextEditingController();
    _model.tituloFocusNode ??= FocusNode();

    _model.urlTextController ??= TextEditingController();
    _model.urlFocusNode ??= FocusNode();

    _model.mensagemTextController ??= TextEditingController();
    _model.mensagemFocusNode ??= FocusNode();

    _geofenceMsgController = TextEditingController(
      text: '📍 Você está perto de {parceiro}! Aproveite seu desconto exclusivo com o Procard.',
    );
    _posCompraMsgController = TextEditingController(
      text: '🎉 Parabéns, {cliente}! Você economizou R\$ {economia} na {parceiro} e ganhou {pontos} pontos.',
    );
    _inatividadeMsgController = TextEditingController(
      text: '👋 Sentimos sua falta, {cliente}! Confira os novos cupons disponíveis perto de você esta semana.',
    );

    _model.tituloTextController?.addListener(() => safeSetState(() {}));
    _model.mensagemTextController?.addListener(() => safeSetState(() {}));

    _carregarHistorico();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _buscaHistoricoController.dispose();
    _geofenceMsgController.dispose();
    _posCompraMsgController.dispose();
    _inatividadeMsgController.dispose();
    super.dispose();
  }

  Future<void> _carregarHistorico() async {
    setState(() => _isLoadingHistory = true);
    try {
      final response = await ObterNotificacoesCall.call(
        tenantId: FFAppConstants.tenantId,
      );

      if (response.succeeded && response.jsonBody is List) {
        final List<dynamic> list = response.jsonBody as List<dynamic>;
        setState(() {
          _historicoNotificacoes = list.map((item) {
            final map = item is Map<String, dynamic> ? item : <String, dynamic>{};
            return {
              'id': map['id'] ?? DateTime.now().millisecondsSinceEpoch,
              'title': map['title'] ?? 'Sem título',
              'description': map['description'] ?? '',
              'sendby': map['sendby'] ?? 'Clube Procard',
              'url': map['url'] ?? '',
              'data': map['data'] ?? functions.obterDataAtual(),
              'active': map['active'] ?? true,
              'validade': map['validade'] ?? 'Sem expiração',
            };
          }).toList();
        });
      } else {
        // Mock fallback seguro com exemplos caso a API retorne vazia
        setState(() {
          _historicoNotificacoes = [
            {
              'id': 101,
              'title': '🔥 Super Desconto de Fim de Semana!',
              'description': 'Aproveite até 30% OFF em todos os restaurantes parceiros neste sábado e domingo.',
              'sendby': 'Clube Procard',
              'url': 'https://procard.com.br/restaurantes',
              'data': '26/08/2026',
              'active': true,
              'validade': '3 dias',
            },
            {
              'id': 102,
              'title': '🎉 Novo parceiro na sua cidade!',
              'description': 'A Academia TopFit agora faz parte do Clube Procard. Venha conhecer!',
              'sendby': 'Procard Benefícios',
              'url': '',
              'data': '24/08/2026',
              'active': true,
              'validade': '7 dias',
            },
            {
              'id': 103,
              'title': '⏰ Promoção Relâmpago 24h',
              'description': 'Descontos em farmácias selecionadas válidos apenas hoje até 23h59.',
              'sendby': 'Clube Procard',
              'url': '',
              'data': '18/08/2026',
              'active': false,
              'validade': 'Expirado',
            },
          ];
        });
      }
    } catch (_) {
      // Ignora erro de rede mantendo fallback
    } finally {
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  void _alternarStatusNotificacao(int id) {
    setState(() {
      final index = _historicoNotificacoes.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        final currentActive = _historicoNotificacoes[index]['active'] as bool? ?? true;
        _historicoNotificacoes[index]['active'] = !currentActive;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Status da notificação atualizado com sucesso.'),
        backgroundColor: Color(0xFF2E7D32),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _preencherParaReenvio(Map<String, dynamic> item) {
    _model.enviadoPorTextController?.text = item['sendby'] ?? '';
    _model.tituloTextController?.text = item['title'] ?? '';
    _model.urlTextController?.text = item['url'] ?? '';
    _model.mensagemTextController?.text = item['description'] ?? '';

    setState(() => _selectedTab = 0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.replay_rounded, color: Colors.white, size: 20.0),
            SizedBox(width: 8.0),
            Text('Dados carregados no formulário de envio.'),
          ],
        ),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _excluirDoHistorico(int id) {
    showDialog(
      context: context,
      builder: (alertDialogContext) => AlertDialog(
        title: const Text('Excluir do Histórico'),
        content: const Text('Deseja realmente remover esta notificação do histórico de envios?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(alertDialogContext);
              setState(() {
                _historicoNotificacoes.removeWhere((n) => n['id'] == id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notificação excluída do histórico.'),
                  backgroundColor: Color(0xFFE53935),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _insertTag(String tag) {
    final controller = _model.mensagemTextController;
    if (controller == null) return;
    final text = controller.text;
    final selection = controller.selection;
    if (selection.start >= 0 && selection.end >= 0) {
      final newText = text.replaceRange(selection.start, selection.end, tag);
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start + tag.length),
      );
    } else {
      controller.text = text + tag;
    }
    safeSetState(() {});
  }

  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
            font: GoogleFonts.openSans(),
            color: const Color(0xFF909090),
            fontSize: 14.0,
          ),
      prefixIcon: Icon(
        prefixIcon,
        color: const Color(0xFF9A9A9A),
        size: 20.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xFFCCCCCC),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      contentPadding: const EdgeInsetsDirectional.fromSTEB(16.0, 14.0, 16.0, 14.0),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.openSans(
                fontWeight: FontWeight.w600,
              ),
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 14.0,
            ),
      ),
    );
  }

  Widget _buildTagChip(String tag, String description) {
    return InkWell(
      onTap: () => _insertTag(tag),
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              size: 14.0,
              color: FlutterFlowTheme.of(context).primary,
            ),
            const SizedBox(width: 4.0),
            Text(
              tag,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                    ),
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 12.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Preview de Notificação Estilo Celular / Lockscreen
  Widget _buildMobilePreview({required String title, required String message, required String sender}) {
    final displayTitle = title.trim().isNotEmpty ? title : 'Título da notificação aparecerá aqui';
    final displayMsg = message.trim().isNotEmpty ? message : 'O conteúdo da sua notificação push aparecerá neste espaço.';
    final displaySender = sender.trim().isNotEmpty ? sender : 'Procard';

    return Container(
      width: 320.0,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16.0,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF333333),
          width: 2.0,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          Row(
            children: [
              const Icon(Icons.phone_iphone_rounded, color: Colors.white70, size: 16.0),
              const SizedBox(width: 6.0),
              Text(
                'Prévia no Celular do Cliente',
                style: GoogleFonts.openSans(
                  color: Colors.white70,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E).withOpacity(0.95),
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.local_offer_rounded,
                          color: Colors.white,
                          size: 12.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        displaySender.toUpperCase(),
                        style: GoogleFonts.openSans(
                          color: Colors.white70,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Agora',
                      style: GoogleFonts.openSans(
                        color: Colors.white38,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  displayTitle,
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  displayMsg,
                  style: GoogleFonts.openSans(
                    color: Colors.white70,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Center(
            child: Text(
              'A notificação chegará em tempo real na tela de bloqueio',
              style: GoogleFonts.openSans(
                color: Colors.white38,
                fontSize: 10.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Aba 1: Formulário de Disparo Manual
  Widget _buildManualTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Form(
                key: _model.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Enviado por *'),
                              TextFormField(
                                controller: _model.enviadoPorTextController,
                                focusNode: _model.enviadoPorFocusNode,
                                autofocus: false,
                                decoration: _buildInputDecoration(
                                  context: context,
                                  hintText: 'Ex: Clube Procard',
                                  prefixIcon: Icons.business_rounded,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.openSans(),
                                      fontSize: 14.0,
                                    ),
                                validator: _model.enviadoPorTextControllerValidator.asValidator(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Título *'),
                              TextFormField(
                                controller: _model.tituloTextController,
                                focusNode: _model.tituloFocusNode,
                                autofocus: false,
                                decoration: _buildInputDecoration(
                                  context: context,
                                  hintText: 'Ex: Desconto exclusivo esta semana!',
                                  prefixIcon: Icons.title_rounded,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.openSans(),
                                      fontSize: 14.0,
                                    ),
                                validator: _model.tituloTextControllerValidator.asValidator(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // URL e Seletor de Expiração em 2 colunas
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('URL de Destino / Deep Link (Opcional)'),
                              TextFormField(
                                controller: _model.urlTextController,
                                focusNode: _model.urlFocusNode,
                                autofocus: false,
                                decoration: _buildInputDecoration(
                                  context: context,
                                  hintText: 'https://seusite.com.br/promocao ou procard://cupons',
                                  prefixIcon: Icons.link_rounded,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.openSans(),
                                      fontSize: 14.0,
                                    ),
                                validator: _model.urlTextControllerValidator.asValidator(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Validade / Expiração do Push'),
                              Container(
                                height: 48.0,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: const Color(0xFFCCCCCC)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _validadeSelecionada,
                                    isExpanded: true,
                                    icon: const Icon(Icons.timer_outlined, color: Color(0xFF9A9A9A), size: 20.0),
                                    items: [
                                      'Sem expiração',
                                      '24 horas',
                                      '3 dias',
                                      '7 dias',
                                      '15 dias',
                                      '30 dias',
                                    ].map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(
                                          val,
                                          style: GoogleFonts.openSans(
                                            fontSize: 14.0,
                                            color: FlutterFlowTheme.of(context).primaryText,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _validadeSelecionada = val);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFieldLabel('Mensagem *'),
                        Row(
                          children: [
                            Text(
                              'Inserir tag: ',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.openSans(),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 12.0,
                                  ),
                            ),
                            const SizedBox(width: 6.0),
                            _buildTagChip('{cliente}', 'Nome do usuário'),
                            const SizedBox(width: 6.0),
                            _buildTagChip('{cidade}', 'Cidade do usuário'),
                          ],
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _model.mensagemTextController,
                      focusNode: _model.mensagemFocusNode,
                      autofocus: false,
                      maxLines: 4,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Digite o conteúdo completo da mensagem que será disparada para os usuários...',
                        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                              font: GoogleFonts.openSans(),
                              color: const Color(0xFF909090),
                              fontSize: 14.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFCCCCCC),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.openSans(),
                            fontSize: 14.0,
                          ),
                      validator: _model.mensagemTextControllerValidator.asValidator(context),
                    ),
                    const SizedBox(height: 24.0),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: FFButtonWidget(
                        onPressed: _isSending
                            ? null
                            : () async {
                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  return;
                                }
                                setState(() => _isSending = true);

                                try {
                                  final title = _model.tituloTextController.text;
                                  final msg = _model.mensagemTextController.text;
                                  final sendby = _model.enviadoPorTextController.text;
                                  final url = _model.urlTextController.text;

                                  _model.apiResulti0l = await EnviarNotificacaoCall.call(
                                    title: title,
                                    message: msg,
                                    url: url,
                                    data: functions.obterDataAtual(),
                                    tenantId: FFAppConstants.tenantId,
                                    mensageiro: sendby,
                                  );

                                  if ((_model.apiResulti0l?.succeeded ?? true)) {
                                    // Adiciona localmente ao histórico
                                    setState(() {
                                      _historicoNotificacoes.insert(0, {
                                        'id': DateTime.now().millisecondsSinceEpoch,
                                        'title': title,
                                        'description': msg,
                                        'sendby': sendby,
                                        'url': url,
                                        'data': functions.obterDataAtual(),
                                        'active': true,
                                        'validade': _validadeSelecionada,
                                      });
                                    });

                                    safeSetState(() {
                                      _model.tituloTextController?.clear();
                                      _model.urlTextController?.clear();
                                      _model.mensagemTextController?.clear();
                                    });
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Row(
                                            children: const [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                color: Color(0xFF2E7D32),
                                                size: 24.0,
                                              ),
                                              SizedBox(width: 8.0),
                                              Text('Notificação enviada'),
                                            ],
                                          ),
                                          content: const Text(
                                              'A notificação foi disparada com sucesso para todos os usuários e registrada no histórico.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(alertDialogContext),
                                              child: const Text('OK'),
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
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.error_outline_rounded,
                                                color: FlutterFlowTheme.of(context).error,
                                                size: 24.0,
                                              ),
                                              const SizedBox(width: 8.0),
                                              const Text('Erro ao enviar'),
                                            ],
                                          ),
                                          content: const Text(
                                              'Não foi possível enviar a notificação. Verifique sua conexão e tente novamente.'),
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
                                } finally {
                                  setState(() => _isSending = false);
                                }
                              },
                        text: _isSending ? 'Disparando Notificação...' : 'Disparar Notificação para Todos',
                        icon: _isSending
                            ? null
                            : const Icon(
                                Icons.send_rounded,
                                size: 16.0,
                              ),
                        options: FFButtonOptions(
                          width: 280.0,
                          height: 48.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                fontSize: 14.0,
                              ),
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isWide) ...[
              const SizedBox(width: 32.0),
              _buildMobilePreview(
                title: _model.tituloTextController?.text ?? '',
                message: _model.mensagemTextController?.text ?? '',
                sender: _model.enviadoPorTextController?.text ?? 'Procard',
              ),
            ],
          ],
        );
      },
    );
  }

  // Aba 2: Histórico de Envios & Gestão de Expiração
  Widget _buildHistoryTab() {
    final filteredList = _historicoNotificacoes.where((n) {
      final title = (n['title'] ?? '').toString().toLowerCase();
      final desc = (n['description'] ?? '').toString().toLowerCase();
      final sender = (n['sendby'] ?? '').toString().toLowerCase();
      final search = _termoBuscaHistorico.toLowerCase();

      final matchesSearch = search.isEmpty || title.contains(search) || desc.contains(search) || sender.contains(search);

      if (_filtroHistorico == 'ativos') {
        return matchesSearch && (n['active'] == true);
      } else if (_filtroHistorico == 'expirados') {
        return matchesSearch && (n['active'] == false);
      }
      return matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barra de Ferramentas do Histórico (Filtros e Busca)
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44.0,
                child: TextField(
                  controller: _buscaHistoricoController,
                  onChanged: (val) => setState(() => _termoBuscaHistorico = val),
                  decoration: InputDecoration(
                    hintText: 'Buscar no histórico por título, conteúdo ou remetente...',
                    hintStyle: GoogleFonts.openSans(fontSize: 13.5, color: const Color(0xFF909090)),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9A9A9A), size: 20.0),
                    suffixIcon: _termoBuscaHistorico.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18.0),
                            onPressed: () {
                              _buscaHistoricoController.clear();
                              setState(() => _termoBuscaHistorico = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 1.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  style: GoogleFonts.openSans(fontSize: 13.5),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            // Filtros de Status (Pills)
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: const Color(0xFFCCCCCC)),
              ),
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: [
                  _buildHistoryFilterChip('Todos', 'todos'),
                  _buildHistoryFilterChip('Ativos', 'ativos'),
                  _buildHistoryFilterChip('Expirados / Inativos', 'expirados'),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF666666)),
              tooltip: 'Atualizar Histórico',
              onPressed: _carregarHistorico,
            ),
          ],
        ),

        const SizedBox(height: 20.0),

        // Tabela de Histórico
        if (_isLoadingHistory)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: SpinKitRing(color: Color(0xFFD6A43B), size: 40.0),
            ),
          )
        else if (filteredList.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: Column(
              children: [
                const Icon(Icons.mark_email_unread_outlined, size: 48.0, color: Color(0xFFBDBDBD)),
                const SizedBox(height: 12.0),
                Text(
                  'Nenhuma notificação encontrada no histórico.',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(const Color(0xFFF7F7F7)),
                headingRowHeight: 46.0,
                dataRowHeight: 68.0,
                horizontalMargin: 18.0,
                columnSpacing: 20.0,
                columns: [
                  DataColumn(
                    label: Text(
                      'STATUS',
                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 12.0, color: const Color(0xFF666666)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'DATA',
                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 12.0, color: const Color(0xFF666666)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'TÍTULO & MENSAGEM',
                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 12.0, color: const Color(0xFF666666)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'REMETENTE',
                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 12.0, color: const Color(0xFF666666)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'EXPIRAÇÃO',
                      style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 12.0, color: const Color(0xFF666666)),
                    ),
                  ),
                  DataColumn(
                    label: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'AÇÕES',
                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 12.0, color: const Color(0xFF666666)),
                      ),
                    ),
                  ),
                ],
                rows: filteredList.map((item) {
                  final bool isActive = item['active'] == true;
                  final int id = item['id'] is int ? item['id'] as int : 0;
                  final String title = item['title'] ?? '';
                  final String desc = item['description'] ?? '';
                  final String sender = item['sendby'] ?? 'Procard';
                  final String date = item['data'] ?? '';
                  final String validade = item['validade'] ?? 'Sem expiração';

                  return DataRow(
                    cells: [
                      // Status Badge
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7.0,
                                height: 7.0,
                                decoration: BoxDecoration(
                                  color: isActive ? const Color(0xFF2E7D32) : const Color(0xFF757575),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                isActive ? 'Ativo' : 'Expirado',
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                  color: isActive ? const Color(0xFF2E7D32) : const Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Data
                      DataCell(
                        Text(
                          date,
                          style: GoogleFonts.openSans(fontSize: 13.0, color: const Color(0xFF555555)),
                        ),
                      ),
                      // Título & Mensagem
                      DataCell(
                        SizedBox(
                          width: 320.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 13.5, color: FlutterFlowTheme.of(context).primaryText),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                desc,
                                style: GoogleFonts.openSans(fontSize: 12.0, color: FlutterFlowTheme.of(context).secondaryText),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Remetente
                      DataCell(
                        Text(
                          sender,
                          style: GoogleFonts.openSans(fontSize: 13.0, fontWeight: FontWeight.w600, color: const Color(0xFF444444)),
                        ),
                      ),
                      // Expiração
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timelapse_rounded, size: 14.0, color: Color(0xFF888888)),
                            const SizedBox(width: 4.0),
                            Text(
                              validade,
                              style: GoogleFonts.openSans(fontSize: 12.5, color: const Color(0xFF666666)),
                            ),
                          ],
                        ),
                      ),
                      // Ações
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Botão Reenviar / Carregar no Formulário
                            IconButton(
                              icon: const Icon(Icons.replay_rounded, color: Color(0xFF1976D2), size: 19.0),
                              tooltip: 'Reenviar / Carregar no formulário',
                              onPressed: () => _preencherParaReenvio(item),
                            ),
                            // Botão Alternar Ativo/Expirado
                            IconButton(
                              icon: Icon(
                                isActive ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
                                color: isActive ? const Color(0xFFF57C00) : const Color(0xFF2E7D32),
                                size: 19.0,
                              ),
                              tooltip: isActive ? 'Expirar / Desativar notificação' : 'Reativar notificação',
                              onPressed: () => _alternarStatusNotificacao(id),
                            ),
                            // Botão Excluir
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE53935), size: 19.0),
                              tooltip: 'Excluir do histórico',
                              onPressed: () => _excluirDoHistorico(id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryFilterChip(String label, String value) {
    final isSelected = _filtroHistorico == value;
    return InkWell(
      onTap: () => setState(() => _filtroHistorico = value),
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? FlutterFlowTheme.of(context).primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
      ),
    );
  }

  // Aba 3: Cerca Digital & Automações Inteligentes
  Widget _buildAutomationsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Regra 1: Cerca Digital (Geofencing)
        _buildAutomationCard(
          icon: Icons.location_on_rounded,
          iconColor: const Color(0xFFE53935),
          title: '📍 Cerca Digital por Proximidade',
          subtitle: 'Envia uma mensagem no celular do cliente quando ele se aproxima de um estabelecimento parceiro credenciado.',
          isEnabled: _geofenceEnabled,
          onToggle: (val) => setState(() => _geofenceEnabled = val),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Raio de detecção:',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.openSans(fontWeight: FontWeight.w600),
                          fontSize: 13.5,
                        ),
                  ),
                  const SizedBox(width: 12.0),
                  Wrap(
                    spacing: 8.0,
                    children: ['200m', '500m', '1 km', '2 km'].map((radius) {
                      final isSelected = _geofenceRadius == radius;
                      return ChoiceChip(
                        label: Text(radius),
                        selected: isSelected,
                        selectedColor: FlutterFlowTheme.of(context).primary,
                        labelStyle: GoogleFonts.openSans(
                          color: isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _geofenceRadius = radius);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 14.0),
              _buildFieldLabel('Modelo da Mensagem (com tags automáticas):'),
              TextFormField(
                controller: _geofenceMsgController,
                maxLines: 2,
                decoration: _buildInputDecoration(
                  context: context,
                  hintText: 'Digite o texto de proximidade...',
                  prefixIcon: Icons.chat_rounded,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.openSans(),
                      fontSize: 13.5,
                    ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Tags disponíveis: {parceiro}, {desconto}, {distancia}',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.openSans(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20.0),

        // Regra 2: Pós-Validação
        _buildAutomationCard(
          icon: Icons.celebration_rounded,
          iconColor: const Color(0xFF2E7D32),
          title: '🎉 Notificação Pós-Validação',
          subtitle: 'Disparada imediatamente no celular do cliente após o parceiro validar o cupom ou desconto.',
          isEnabled: _posCompraEnabled,
          onToggle: (val) => setState(() => _posCompraEnabled = val),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Modelo da Mensagem Pós-Compra:'),
              TextFormField(
                controller: _posCompraMsgController,
                maxLines: 2,
                decoration: _buildInputDecoration(
                  context: context,
                  hintText: 'Digite o texto pós-validação...',
                  prefixIcon: Icons.card_giftcard_rounded,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.openSans(),
                      fontSize: 13.5,
                    ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Tags disponíveis: {cliente}, {parceiro}, {economia}, {pontos}',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.openSans(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20.0),

        // Regra 3: Reengajamento por Inatividade
        _buildAutomationCard(
          icon: Icons.timer_outlined,
          iconColor: const Color(0xFFF57C00),
          title: '⏰ Reengajamento por Inatividade',
          subtitle: 'Relembra os usuários que estão há muito tempo sem abrir o aplicativo ou resgatar benefícios.',
          isEnabled: _inatividadeEnabled,
          onToggle: (val) => setState(() => _inatividadeEnabled = val),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Disparar após:',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.openSans(fontWeight: FontWeight.w600),
                          fontSize: 13.5,
                        ),
                  ),
                  const SizedBox(width: 12.0),
                  Wrap(
                    spacing: 8.0,
                    children: ['7 dias', '15 dias', '30 dias', '45 dias'].map((dias) {
                      final isSelected = _inatividadeDias == dias;
                      return ChoiceChip(
                        label: Text(dias),
                        selected: isSelected,
                        selectedColor: FlutterFlowTheme.of(context).primary,
                        labelStyle: GoogleFonts.openSans(
                          color: isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _inatividadeDias = dias);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 14.0),
              _buildFieldLabel('Modelo da Mensagem de Inatividade:'),
              TextFormField(
                controller: _inatividadeMsgController,
                maxLines: 2,
                decoration: _buildInputDecoration(
                  context: context,
                  hintText: 'Digite o texto de reengajamento...',
                  prefixIcon: Icons.notifications_none_rounded,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.openSans(),
                      fontSize: 13.5,
                    ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Tags disponíveis: {cliente}, {cidade}',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.openSans(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24.0),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FFButtonWidget(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: const [
                      Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.0),
                      SizedBox(width: 8.0),
                      Text('Regras de automação salvas com sucesso!'),
                    ],
                  ),
                  backgroundColor: const Color(0xFF2E7D32),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            text: 'Salvar Configurações de Automação',
            icon: const Icon(Icons.save_rounded, size: 16.0),
            options: FFButtonOptions(
              width: 300.0,
              height: 48.0,
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.openSans(fontWeight: FontWeight.w600),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    fontSize: 14.0,
                  ),
              elevation: 2.0,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAutomationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isEnabled,
    required ValueChanged<bool> onToggle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isEnabled ? FlutterFlowTheme.of(context).primary.withOpacity(0.3) : const Color(0xFFE0E0E0),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(icon, color: iconColor, size: 20.0),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 15.0,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.openSans(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12.5,
                          ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                activeColor: FlutterFlowTheme.of(context).primary,
                onChanged: onToggle,
              ),
            ],
          ),
          if (isEnabled) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Divider(height: 1.0, thickness: 1.0, color: Color(0xFFEEEEEE)),
            ),
            child,
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: FFAppState().sidebarCollapsed
                    ? 80.0
                    : MediaQuery.sizeOf(context).width * 0.22,
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondary,
                ),
                child: wrapWithModel(
                  model: _model.menuModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const MenuWidget(),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderPaginaWidget(
                          titulo: 'Mensagens & Notificações',
                          breadcrumb: 'Painel',
                        ),
                        const SizedBox(height: 14.0),

                        // Navegação por Abas (Disparo Manual vs Histórico vs Automações)
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1.0,
                            ),
                          ),
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildNavTab(
                                index: 0,
                                icon: Icons.send_rounded,
                                label: 'Disparo Manual',
                              ),
                              const SizedBox(width: 4.0),
                              _buildNavTab(
                                index: 1,
                                icon: Icons.history_rounded,
                                label: 'Histórico de Envios',
                                badgeCount: _historicoNotificacoes.length,
                              ),
                              const SizedBox(width: 4.0),
                              _buildNavTab(
                                index: 2,
                                icon: Icons.radar_rounded,
                                label: 'Cerca Digital & Automações',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14.0),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    FlutterFlowTheme.of(context).designToken.radius.md,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(
                                      FlutterFlowTheme.of(context).designToken.radius.md,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(28.0),
                                  child: _selectedTab == 0
                                      ? _buildManualTab()
                                      : _selectedTab == 1
                                          ? _buildHistoryTab()
                                          : _buildAutomationsTab(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTab({
    required int index,
    required IconData icon,
    required String label,
    int? badgeCount,
  }) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? FlutterFlowTheme.of(context).primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.0,
              color: isSelected ? Colors.white : FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
                color: isSelected ? Colors.white : FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            if (badgeCount != null && badgeCount > 0) ...[
              const SizedBox(width: 6.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.25) : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  '$badgeCount',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.0,
                    color: isSelected ? Colors.white : const Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
