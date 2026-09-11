import '/backend/api_requests/api_calls.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
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

  // Estados das Automações / Motor Inteligente
  bool _geofenceEnabled = true;
  String _geofenceRadius = '500m';
  final TextEditingController _geofenceMsgController = TextEditingController(
    text: '📍 Você está perto de parceiros credenciados! Apresente seu app Arms Pass e aproveite descontos exclusivos agora mesmo.',
  );
  bool _geofenceGroupClusters = true;
  String _geofenceCooldown = '4 horas';
  bool _geofenceDiscoveryMode = true;

  bool _posCompraEnabled = true;
  final TextEditingController _posCompraMsgController = TextEditingController(
    text: '🎉 Parabéns! Sua economia com o plano Arms Pro foi confirmada. Continue aproveitando todas as vantagens da rede!',
  );

  bool _inatividadeEnabled = true;
  String _inatividadeDias = '15 dias';
  final TextEditingController _inatividadeMsgController = TextEditingController(
    text: '👋 Sentimos sua falta! Novos cupons e descontos imperdíveis foram liberados no seu Arms Pass esta semana. Confira no app!',
  );

  bool _sextouEnabled = true;
  String _sextouHorario = 'Sexta às 18:00';
  final TextEditingController _sextouMsgController = TextEditingController(
    text: '🍻 Sextou com economia! Aproveite o fim de semana com descontos exclusivos nos melhores restaurantes e bares credenciados.',
  );


  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MensagensModel());

    _model.enviadoPorTextController ??= TextEditingController(text: 'Arms Pass');
    _model.enviadoPorFocusNode ??= FocusNode();

    _model.tituloTextController ??= TextEditingController();
    _model.tituloFocusNode ??= FocusNode();

    _model.urlTextController ??= TextEditingController();
    _model.urlFocusNode ??= FocusNode();

    _model.mensagemTextController ??= TextEditingController();
    _model.mensagemFocusNode ??= FocusNode();

    _model.tituloTextController?.addListener(() => safeSetState(() {}));
    _model.mensagemTextController?.addListener(() => safeSetState(() {}));

    _carregarHistorico();
    _carregarConfiguracoesAutomacao();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _carregarConfiguracoesAutomacao() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _geofenceEnabled = prefs.getBool('auto_geofence_enabled') ?? _geofenceEnabled;
        _geofenceRadius = prefs.getString('auto_geofence_radius') ?? _geofenceRadius;
        final gMsg = prefs.getString('auto_geofence_msg');
        if (gMsg != null && gMsg.isNotEmpty) _geofenceMsgController.text = gMsg;
        _geofenceGroupClusters = prefs.getBool('auto_geofence_group') ?? _geofenceGroupClusters;
        _geofenceCooldown = prefs.getString('auto_geofence_cooldown') ?? _geofenceCooldown;
        _geofenceDiscoveryMode = prefs.getBool('auto_geofence_discovery') ?? _geofenceDiscoveryMode;

        _posCompraEnabled = prefs.getBool('auto_poscompra_enabled') ?? _posCompraEnabled;
        final pcMsg = prefs.getString('auto_poscompra_msg');
        if (pcMsg != null && pcMsg.isNotEmpty) _posCompraMsgController.text = pcMsg;

        _inatividadeEnabled = prefs.getBool('auto_inatividade_enabled') ?? _inatividadeEnabled;
        _inatividadeDias = prefs.getString('auto_inatividade_dias') ?? _inatividadeDias;
        final inMsg = prefs.getString('auto_inatividade_msg');
        if (inMsg != null && inMsg.isNotEmpty) _inatividadeMsgController.text = inMsg;

        _sextouEnabled = prefs.getBool('auto_sextou_enabled') ?? _sextouEnabled;
        _sextouHorario = prefs.getString('auto_sextou_horario') ?? _sextouHorario;
        final sexMsg = prefs.getString('auto_sextou_msg');
        if (sexMsg != null && sexMsg.isNotEmpty) _sextouMsgController.text = sexMsg;
      });
    } catch (_) {}
  }

  Future<void> _salvarConfiguracoesAutomacao() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auto_geofence_enabled', _geofenceEnabled);
      await prefs.setString('auto_geofence_radius', _geofenceRadius);
      await prefs.setString('auto_geofence_msg', _geofenceMsgController.text);
      await prefs.setBool('auto_geofence_group', _geofenceGroupClusters);
      await prefs.setString('auto_geofence_cooldown', _geofenceCooldown);
      await prefs.setBool('auto_geofence_discovery', _geofenceDiscoveryMode);

      await prefs.setBool('auto_poscompra_enabled', _posCompraEnabled);
      await prefs.setString('auto_poscompra_msg', _posCompraMsgController.text);

      await prefs.setBool('auto_inatividade_enabled', _inatividadeEnabled);
      await prefs.setString('auto_inatividade_dias', _inatividadeDias);
      await prefs.setString('auto_inatividade_msg', _inatividadeMsgController.text);

      await prefs.setBool('auto_sextou_enabled', _sextouEnabled);
      await prefs.setString('auto_sextou_horario', _sextouHorario);
      await prefs.setString('auto_sextou_msg', _sextouMsgController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.0),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Regras de automação e motor inteligente salvas com sucesso!',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar configurações: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testarDisparoAutomacao({
    required String title,
    required String message,
    required String sender,
    String? url,
  }) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.flash_on_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 24.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Testar Disparo da Regra',
                style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deseja disparar um push de teste real agora com este padrão configurado para validar no seu celular?',
                style: GoogleFonts.openSans(fontSize: 13.5, color: FlutterFlowTheme.of(context).primaryText),
              ),
              const SizedBox(height: 12.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F8),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: const Color(0xFFE0E3E7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Remetente: ', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 12.0)),
                        Text(sender, style: GoogleFonts.openSans(fontSize: 12.0, color: const Color(0xFF14181B))),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text('Título: $title',
                        style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 13.0, color: const Color(0xFF14181B))),
                    const SizedBox(height: 4.0),
                    Text(message, style: GoogleFonts.openSans(fontSize: 12.5, color: const Color(0xFF3F464E))),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext, false),
              child: Text(
                'Cancelar',
                style: GoogleFonts.openSans(color: FlutterFlowTheme.of(context).secondaryText),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
              ),
              onPressed: () => Navigator.pop(alertDialogContext, true),
              icon: const Icon(Icons.send_rounded, size: 16.0),
              label: Text('Disparar Teste Agora', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    final res = await EnviarNotificacaoCall.call(
      title: title,
      message: message,
      url: url ?? '',
      data: functions.obterDataAtual(),
      tenantId: FFAppConstants.tenantId,
      mensageiro: sender,
    );

    if (res.succeeded) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.0),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text('Teste de automação disparado com sucesso! Verifique o app e sininho.'),
                ),
              ],
            ),
            backgroundColor: Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao disparar teste de automação.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _buscaHistoricoController.dispose();
    _geofenceMsgController.dispose();
    _posCompraMsgController.dispose();
    _inatividadeMsgController.dispose();
    _sextouMsgController.dispose();
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
            final map = item is Map ? item : <dynamic, dynamic>{};
            String rawData = map['data']?.toString() ?? '';
            String formattedData = rawData;
            if (rawData.isNotEmpty) {
              final dt = DateTime.tryParse(rawData);
              if (dt != null) {
                final d = dt.day.toString().padLeft(2, '0');
                final m = dt.month.toString().padLeft(2, '0');
                final y = dt.year;
                final h = dt.hour.toString().padLeft(2, '0');
                final min = dt.minute.toString().padLeft(2, '0');
                formattedData = '$d/$m/$y • $h:$min';
              }
            }
            return {
              'id': map['id'] ?? DateTime.now().millisecondsSinceEpoch,
              'title': map['title']?.toString() ?? 'Sem título',
              'description': map['description']?.toString() ?? '',
              'sendby': map['sendby']?.toString() ?? 'Arms Pass',
              'url': map['url']?.toString() ?? '',
              'data': formattedData.isNotEmpty
                  ? formattedData
                  : functions.obterDataAtual(),
              'active': map['active'] == true,
              'validade': map['validade']?.toString() ?? 'Sem expiração',
            };
          }).toList();
        });
      } else {
        setState(() {
          _historicoNotificacoes = [];
        });
      }
    } catch (_) {
      setState(() {
        _historicoNotificacoes = [];
      });
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
        content: const Row(
          children: [
            Icon(Icons.replay_rounded, color: Colors.white, size: 20.0),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Dados carregados no formulário de envio.',
                overflow: TextOverflow.ellipsis,
              ),
            ),
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


  void _aplicarModelo({
    required String sender,
    required String title,
    required String message,
    String? url,
  }) {
    _model.enviadoPorTextController?.text = sender;
    _model.tituloTextController?.text = title;
    _model.mensagemTextController?.text = message;
    if (url != null) {
      _model.urlTextController?.text = url;
    }
    safeSetState(() {});
  }

  Widget _buildQuickTemplateChip({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: color.withOpacity(0.25),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15.0, color: color),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSenderChip(String sender) {
    final isSelected =
        _model.enviadoPorTextController?.text.trim().toLowerCase() == sender.toLowerCase();
    return InkWell(
      onTap: () {
        _model.enviadoPorTextController?.text = sender;
        safeSetState(() {});
      },
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary.withOpacity(0.12)
              : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : const Color(0xFFE0E0E0),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                Icons.check_rounded,
                size: 13.0,
                color: FlutterFlowTheme.of(context).primary,
              ),
              const SizedBox(width: 4.0),
            ],
            Text(
              sender,
              style: GoogleFonts.openSans(
                fontSize: 12.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? FlutterFlowTheme.of(context).primary
                    : const Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSenderBadge(String sender) {
    final lower = sender.toLowerCase();
    final bool isGym = lower.contains('gym');
    final bool isArms = lower.contains('arms') || lower.contains('pass');

    final Color bgColor = isGym
        ? const Color(0xFF212121)
        : isArms
            ? const Color(0xFFFFF3E0)
            : const Color(0xFFEDE7F6);
    final Color textColor = isGym
        ? const Color(0xFFFFD54F)
        : isArms
            ? const Color(0xFFE65100)
            : const Color(0xFF5E35B1);
    final IconData icon = isGym
        ? Icons.fitness_center_rounded
        : isArms
            ? Icons.bolt_rounded
            : Icons.storefront_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.0, color: textColor),
          const SizedBox(width: 5.0),
          Text(
            sender,
            style: GoogleFonts.openSans(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(String sender) {
    final isGym = sender.toLowerCase().contains('gym');

    if (isGym) {
      return Container(
        width: 22.0,
        height: 22.0,
        decoration: BoxDecoration(
          color: const Color(0xFF14181B),
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: const Color(0xFFA49C88).withValues(alpha: 0.4),
            width: 0.8,
          ),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.fitness_center_rounded,
          size: 13.0,
          color: Color(0xFFA49C88),
        ),
      );
    }

    // Badge Oficial Arms Pass (100% Vectorial, ultra nítido, sem falhas de codec)
    return Container(
      width: 22.0,
      height: 22.0,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1113),
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: const Color(0xFFA49C88).withValues(alpha: 0.45),
          width: 0.8,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ARMS',
              style: GoogleFonts.outfit(
                color: const Color(0xFFA49C88),
                fontSize: 6.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
                height: 0.95,
              ),
            ),
            Text(
              'PASS',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 5.2,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                height: 0.95,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Preview de Notificação Estilo Celular / Lockscreen
  Widget _buildMobilePreview({
    required String title,
    required String message,
    required String sender,
    String? url,
  }) {
    final displayTitle = title.trim().isNotEmpty
        ? title
        : 'Título da notificação aparecerá aqui';
    final displayMsg = message.trim().isNotEmpty
        ? message
        : 'O conteúdo da sua notificação push aparecerá neste espaço.';
    final displaySender = sender.trim().isNotEmpty ? sender : 'Arms Pass';
    final hasUrl = url != null && url.trim().isNotEmpty;

    return Container(
      width: 330.0,
      decoration: BoxDecoration(
        color: const Color(0xFFEFECE6), // Fundo sofisticado tom areia Arms
        borderRadius: BorderRadius.circular(36.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20.0,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD4CFC5),
          width: 2.5,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dynamic Island Pill
          Center(
            child: Container(
              width: 96.0,
              height: 24.0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: Colors.black12, width: 0.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    width: 9.0,
                    height: 9.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C1C24),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),

          // Status Bar (Time, Signals)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '09:41',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF14181B),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.signal_cellular_alt_rounded, color: Color(0xFF14181B), size: 13.0),
                  SizedBox(width: 4.0),
                  Icon(Icons.wifi_rounded, color: Color(0xFF14181B), size: 13.0),
                  SizedBox(width: 4.0),
                  Icon(Icons.battery_full_rounded, color: Color(0xFF14181B), size: 14.0),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20.0),

          // Lockscreen Clock Header
          Center(
            child: Column(
              children: [
                Text(
                  'Quarta-feira, 9 de setembro',
                  style: GoogleFonts.openSans(
                    color: const Color(0xFF68645C),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  '09:41',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF14181B),
                    fontSize: 48.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          // iOS Push Card Banner (Padrão Claro com Cores Oficiais Arms Pro)
          Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18.0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildAppIcon(displaySender),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        displaySender.toUpperCase(),
                        style: GoogleFonts.openSans(
                          color: const Color(0xFF14181B),
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Agora',
                      style: GoogleFonts.openSans(
                        color: const Color(0xFF8A8A8E),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  displayTitle,
                  style: GoogleFonts.openSans(
                    color: const Color(0xFF14181B),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  displayMsg,
                  style: GoogleFonts.openSans(
                    color: const Color(0xFF3F464E),
                    fontSize: 12.8,
                    height: 1.35,
                  ),
                ),
                if (hasUrl) ...[
                  const SizedBox(height: 9.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA49C88).withOpacity(0.14),
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(
                        color: const Color(0xFFA49C88).withOpacity(0.4),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          url.contains('instagram')
                              ? Icons.camera_alt_outlined
                              : Icons.link_rounded,
                          size: 13.0,
                          color: const Color(0xFF7A705B),
                        ),
                        const SizedBox(width: 5.0),
                        Flexible(
                          child: Text(
                            url,
                            style: GoogleFonts.openSans(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF7A705B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20.0),

          // Lockscreen Actions & Home Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flashlight_on_rounded, color: Color(0xFF14181B), size: 16.0),
              ),
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF14181B), size: 16.0),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          Center(
            child: Container(
              width: 110.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2.0),
              ),
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
        final isWide = constraints.maxWidth > FFAppConstants.kWideLayoutBreakpoint;
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
                    // Container de Modelos Rápidos
                    Container(
                      margin: const EdgeInsets.only(bottom: 22.0),
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 16.0,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    'Modelos Rápidos (Padrão Oficial Arms Pro)',
                                    style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '• Clique para carregar',
                                style: GoogleFonts.openSans(
                                  fontSize: 12.0,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              _buildQuickTemplateChip(
                                label: '🍔 Gastronomia & Lazer',
                                icon: Icons.restaurant_rounded,
                                color: const Color(0xFFE65100),
                                onTap: () => _aplicarModelo(
                                  sender: 'Arms Pass',
                                  title: 'Sabor com Desconto Exclusivo! 🍔',
                                  message:
                                      'Membro Arms tem desconto especial nos melhores restaurantes, cafés e lanchonetes da cidade. Apresente seu app e aproveite!',
                                  url: 'https://www.instagram.com/',
                                ),
                              ),
                              _buildQuickTemplateChip(
                                label: '💪 Treino ARMS GYM',
                                icon: Icons.fitness_center_rounded,
                                color: const Color(0xFF14181B),
                                onTap: () => _aplicarModelo(
                                  sender: 'ARMS GYM',
                                  title: 'Seu Treino Está Liberado! 💪',
                                  message:
                                      'Bora treinar? Aproveite toda a estrutura de alto nível da ARMS GYM e supere suas metas hoje mesmo!',
                                ),
                              ),
                              _buildQuickTemplateChip(
                                label: '⛽ Auto & Postos',
                                icon: Icons.local_gas_station_rounded,
                                color: const Color(0xFF00796B),
                                onTap: () => _aplicarModelo(
                                  sender: 'Arms Pass',
                                  title: 'Abasteça com Desconto ARMS! ⛽',
                                  message:
                                      'Mais economia no seu dia a dia! Membros Arms têm desconto especial por litro no combustível nos postos credenciados. Aproveite!',
                                ),
                              ),
                              _buildQuickTemplateChip(
                                label: '✂️ Beleza & Barbearia',
                                icon: Icons.content_cut_rounded,
                                color: const Color(0xFF5D4037),
                                onTap: () => _aplicarModelo(
                                  sender: 'Arms Pass',
                                  title: 'Hora de Renovar o Visual! ✂️',
                                  message:
                                      'Corte alinhado e cuidados especiais com economia de membro. Apresente seu app nas barbearias e salões parceiros!',
                                  url: 'https://www.instagram.com/',
                                ),
                              ),
                              _buildQuickTemplateChip(
                                label: '💊 Saúde & Farmácia',
                                icon: Icons.local_pharmacy_rounded,
                                color: const Color(0xFF1565C0),
                                onTap: () => _aplicarModelo(
                                  sender: 'Arms Pass',
                                  title: 'Saúde & Bem-Estar com Desconto 💊',
                                  message:
                                      'Cuide da sua saúde economizando. Vantagens exclusivas em farmácias, manipulação e clínicas parceiras da rede Arms.',
                                ),
                              ),
                              _buildQuickTemplateChip(
                                label: '👕 Moda & Vestuário',
                                icon: Icons.checkroom_rounded,
                                color: const Color(0xFF6A1B9A),
                                onTap: () => _aplicarModelo(
                                  sender: 'Arms Pass',
                                  title: 'Estilo & Roupas com Desconto Arms! 👕',
                                  message:
                                      'Renove seus looks casuais e fitness com condições exclusivas nas lojas de vestuário e calçados parceiras.',
                                  url: 'https://www.instagram.com/',
                                ),
                              ),
                              _buildQuickTemplateChip(
                                label: '🤝 Novo Parceiro',
                                icon: Icons.storefront_rounded,
                                color: const Color(0xFF2E7D32),
                                onTap: () => _aplicarModelo(
                                  sender: 'Arms Pass',
                                  title: 'Tem Parceiro Novo na Área! 🤝',
                                  message:
                                      'Mais um parceiro credenciado para você economizar ainda mais! Abra o app Arms Pass e confira o benefício.',
                                  url: 'https://www.instagram.com/',
                                ),
                              ),
                              _buildQuickTemplateChip(
                                label: '🔥 Desconto da Semana',
                                icon: Icons.local_fire_department_rounded,
                                color: const Color(0xFFD32F2F),
                                onTap: () => _aplicarModelo(
                                  sender: 'Arms Pass',
                                  title: 'Desconto Especial Liberado! 🔥',
                                  message:
                                      'Oferta por tempo limitado! Apresente sua carteirinha digital no app nos parceiros participantes e garanta economia máxima.',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

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
                                  hintText: 'Ex: Arms Pass',
                                  prefixIcon: Icons.verified_user_rounded,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.openSans(),
                                      fontSize: 14.0,
                                    ),
                                validator: _model.enviadoPorTextControllerValidator.asValidator(context),
                              ),
                              const SizedBox(height: 6.0),
                              Wrap(
                                spacing: 6.0,
                                runSpacing: 6.0,
                                children: [
                                  _buildSenderChip('Arms Pass'),
                                  _buildSenderChip('ARMS GYM'),
                                  _buildSenderChip('Parceiro Credenciado'),
                                ],
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
                                  hintText: 'https://instagram.com/seuperfil ou https://arms.com.br',
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildFieldLabel('Mensagem *'),
                        Text(
                          'Disparo geral para todos os membros',
                          style: GoogleFonts.openSans(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
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
                                          title: const Row(
                                            children: [
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
                sender: _model.enviadoPorTextController?.text ?? 'Arms Pass',
                url: _model.urlTextController?.text,
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
          const LoadingTableShimmerWidget(
            titulo: 'Histórico de Disparos',
            rowCount: 4,
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
                  final String sender = item['sendby'] ?? 'Arms Pass';
                  final String url = item['url'] ?? '';
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_rounded, size: 14.0, color: Color(0xFF888888)),
                            const SizedBox(width: 5.0),
                            Text(
                              date,
                              style: GoogleFonts.openSans(fontSize: 12.5, color: const Color(0xFF555555)),
                            ),
                          ],
                        ),
                      ),
                      // Título, Mensagem & Link
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: SizedBox(
                            width: 340.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  desc,
                                  style: GoogleFonts.openSans(
                                    fontSize: 12.0,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (url.trim().isNotEmpty) ...[
                                  const SizedBox(height: 3.0),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        url.contains('instagram')
                                            ? Icons.camera_alt_outlined
                                            : Icons.link_rounded,
                                        size: 12.0,
                                        color: url.contains('instagram')
                                            ? const Color(0xFFC2185B)
                                            : const Color(0xFF1976D2),
                                      ),
                                      const SizedBox(width: 4.0),
                                      Flexible(
                                        child: Text(
                                          url,
                                          style: GoogleFonts.openSans(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500,
                                            color: url.contains('instagram')
                                                ? const Color(0xFFC2185B)
                                                : const Color(0xFF1976D2),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Remetente (Badge Estilizado)
                      DataCell(
                        _buildSenderBadge(sender),
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
                            // Botão Carregar como Modelo / Reenviar
                            IconButton(
                              icon: const Icon(Icons.content_copy_rounded, color: Color(0xFF1976D2), size: 18.0),
                              tooltip: 'Carregar e usar como modelo no formulário',
                              onPressed: () => _preencherParaReenvio(item),
                            ),
                            // Botão Alternar Ativo/Expirado
                            IconButton(
                              icon: Icon(
                                isActive ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
                                color: isActive ? const Color(0xFFF57C00) : const Color(0xFF2E7D32),
                                size: 18.0,
                              ),
                              tooltip: isActive ? 'Expirar / Desativar notificação' : 'Reativar notificação',
                              onPressed: () => _alternarStatusNotificacao(id),
                            ),
                            // Botão Excluir
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE53935), size: 18.0),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Raio de detecção:',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.openSans(fontWeight: FontWeight.w600),
                          fontSize: 13.5,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
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
              const SizedBox(height: 14.0),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => _testarDisparoAutomacao(
                    sender: 'Arms Pass',
                    title: '📍 Parceiro Perto de Você!',
                    message: _geofenceMsgController.text,
                  ),
                  icon: const Icon(Icons.flash_on_rounded, size: 16.0, color: Color(0xFFE53935)),
                  label: Text(
                    'Testar Disparo Desta Regra Agora',
                    style: GoogleFonts.openSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE53935),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE53935), width: 1.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  ),
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
          title: '🎉 Notificação Pós-Validação do Cupom',
          subtitle: 'Disparada imediatamente no celular do cliente após o parceiro validar o cupom ou desconto no caixa.',
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
              const SizedBox(height: 14.0),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => _testarDisparoAutomacao(
                    sender: 'Arms Pass',
                    title: '🎉 Parabéns pela Economia!',
                    message: _posCompraMsgController.text,
                  ),
                  icon: const Icon(Icons.flash_on_rounded, size: 16.0, color: Color(0xFF2E7D32)),
                  label: Text(
                    'Testar Disparo Desta Regra Agora',
                    style: GoogleFonts.openSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2E7D32), width: 1.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disparar após inatividade de:',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.openSans(fontWeight: FontWeight.w600),
                          fontSize: 13.5,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
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
              const SizedBox(height: 14.0),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => _testarDisparoAutomacao(
                    sender: 'Arms Pass',
                    title: '👋 Sentimos sua Falta no Clube!',
                    message: _inatividadeMsgController.text,
                  ),
                  icon: const Icon(Icons.flash_on_rounded, size: 16.0, color: Color(0xFFF57C00)),
                  label: Text(
                    'Testar Disparo Desta Regra Agora',
                    style: GoogleFonts.openSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF57C00),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFF57C00), width: 1.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20.0),

        // Regra 4: Campanha Periódica Sextou & Fim de Semana
        _buildAutomationCard(
          icon: Icons.sports_bar_rounded,
          iconColor: const Color(0xFF673AB7),
          title: '🍻 Campanha Recorrente: Sextou & Fim de Semana',
          subtitle: 'Disparo autônomo semanal promovendo restaurantes, bares e lazer para o fim de semana dos membros.',
          isEnabled: _sextouEnabled,
          onToggle: (val) => setState(() => _sextouEnabled = val),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Horário programado:',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.openSans(fontWeight: FontWeight.w600),
                          fontSize: 13.5,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: ['Sexta às 18:00', 'Sexta às 19:30', 'Sábado às 11:30', 'Domingo às 19:00'].map((h) {
                      final isSelected = _sextouHorario == h;
                      return ChoiceChip(
                        label: Text(h),
                        selected: isSelected,
                        selectedColor: FlutterFlowTheme.of(context).primary,
                        labelStyle: GoogleFonts.openSans(
                          color: isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _sextouHorario = h);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 14.0),
              _buildFieldLabel('Modelo da Mensagem Semanal:'),
              TextFormField(
                controller: _sextouMsgController,
                maxLines: 2,
                decoration: _buildInputDecoration(
                  context: context,
                  hintText: 'Digite o texto da campanha de fim de semana...',
                  prefixIcon: Icons.weekend_rounded,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.openSans(),
                      fontSize: 13.5,
                    ),
              ),
              const SizedBox(height: 14.0),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => _testarDisparoAutomacao(
                    sender: 'Arms Pass',
                    title: '🍻 Sextou com Desconto no Clube!',
                    message: _sextouMsgController.text,
                    url: 'https://www.instagram.com/',
                  ),
                  icon: const Icon(Icons.flash_on_rounded, size: 16.0, color: Color(0xFF673AB7)),
                  label: Text(
                    'Testar Disparo Desta Regra Agora',
                    style: GoogleFonts.openSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF673AB7),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF673AB7), width: 1.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24.0),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FFButtonWidget(
            onPressed: _salvarConfiguracoesAutomacao,
            text: 'Salvar Configurações de Automação',
            icon: const Icon(Icons.save_rounded, size: 16.0),
            options: FFButtonOptions(
              width: 320.0,
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Divider(height: 1.0, thickness: 1.0, color: Color(0xFFEEEEEE)),
          ),
          AnimatedOpacity(
            opacity: isEnabled ? 1.0 : 0.45,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !isEnabled,
              child: child,
            ),
          ),
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
                    : (MediaQuery.sizeOf(context).width * 0.22).clamp(220.0, 320.0),
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondary,
                ),
                child: wrapWithModel(
                  model: _model.menuModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const MenuWidget(activeIndex: 9),
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
