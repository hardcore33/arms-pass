import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modal_adicionar_desconto_model.dart';
export 'modal_adicionar_desconto_model.dart';

class ModalAdicionarDescontoWidget extends StatefulWidget {
  const ModalAdicionarDescontoWidget({
    super.key,
    required this.titulo,
    required this.nomeParceiros,
    required this.parceiros,
    required this.nomeSegmentos,
    required this.segmentos,
  });

  final String? titulo;
  final List<String>? nomeParceiros;
  final List<dynamic>? parceiros;
  final List<String>? nomeSegmentos;
  final List<dynamic>? segmentos;

  @override
  State<ModalAdicionarDescontoWidget> createState() =>
      _ModalAdicionarDescontoWidgetState();
}

class _ModalAdicionarDescontoWidgetState
    extends State<ModalAdicionarDescontoWidget> {
  late ModalAdicionarDescontoModel _model;
  bool _salvando = false;
  dynamic _parceiroSelecionado;
  String _buscaParceiro = '';

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAdicionarDescontoModel());

    _model.descricaoTextController ??= TextEditingController();
    _model.descricaoFocusNode ??= FocusNode();

    _model.regrasTextController ??= TextEditingController();
    _model.regrasFocusNode ??= FocusNode();

    _model.porcentagemTextController ??= TextEditingController(text: '10');
    _model.porcentagemFocusNode ??= FocusNode();

    _model.limiteQuantidadeTextController ??= TextEditingController();
    _model.limiteQuantidadeFocusNode ??= FocusNode();

    // Validade padrão: 30 dias a partir de hoje
    _model.datePicked = DateTime.now().add(const Duration(days: 30));

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

  void _selecionarParceiro(dynamic p) {
    setState(() {
      _parceiroSelecionado = p;
      if (p != null) {
        final id = getJsonField(p, r'''$.id''') ?? getJsonField(p, r'''$.partner.id''');
        if (id is int) {
          _model.idParceiro = id;
        } else if (id != null) {
          _model.idParceiro = int.tryParse(id.toString());
        }

        // Segmento herdado automaticamente do parceiro
        final segId = getJsonField(p, r'''$.segment.id''') ?? getJsonField(p, r'''$.partner.segment.id''');
        if (segId is int) {
          _model.idSegmento = segId;
        } else if (segId != null) {
          _model.idSegmento = int.tryParse(segId.toString());
        }
      }
    });
  }

  Future<void> _salvar() async {
    if (_model.idParceiro == null && _parceiroSelecionado == null) {
      showWarningToast(context, 'Por favor, selecione uma empresa parceira.');
      return;
    }
    if (_model.descricaoTextController?.text.trim().isEmpty ?? true) {
      showWarningToast(context, 'Por favor, descreva o benefício ou título do cupom.');
      return;
    }
    if (_model.datePicked == null) {
      showWarningToast(context, 'Por favor, selecione a data de validade.');
      return;
    }

    setState(() => _salvando = true);

    try {
      final idParceiroFinal = _parceiroSelecionado != null
          ? (getJsonField(_parceiroSelecionado, r'''$.id''') ?? getJsonField(_parceiroSelecionado, r'''$.partner.id'''))?.toString()
          : _model.idParceiro?.toString();

      final idSegmentoFinal = _parceiroSelecionado != null
          ? (getJsonField(_parceiroSelecionado, r'''$.segment.id''') ?? getJsonField(_parceiroSelecionado, r'''$.partner.segment.id'''))?.toString()
          : _model.idSegmento?.toString();

      String regrasFormatadas = _model.regrasTextController?.text.trim() ?? '';
      final limite = _model.limiteQuantidadeTextController?.text.trim();
      if (_model.isArmsPro) {
        if (limite != null && limite.isNotEmpty) {
          regrasFormatadas = '[ARMS_PRO][LIMITE:$limite] $regrasFormatadas'.trim();
        } else {
          regrasFormatadas = '[ARMS_PRO] $regrasFormatadas'.trim();
        }
      } else if (limite != null && limite.isNotEmpty) {
        regrasFormatadas = '[LIMITE:$limite] $regrasFormatadas'.trim();
      }

      _model.apiResulthtv = await AdicionarDescontoCall.call(
        descricao: _model.descricaoTextController?.text.trim() ?? '',
        porcentagem: _model.porcentagemTextController?.text.trim() ?? '',
        idParceiro: idParceiroFinal,
        data: DateFormat('yyyy-MM-dd').format(_model.datePicked!),
        idTenant: FFAppConstants.tenantId,
        idSegmento: idSegmentoFinal,
        rules: regrasFormatadas,
      );

      if ((_model.apiResulthtv?.succeeded ?? false)) {
        if (mounted) {
          showSuccessToast(
            context,
            'Cupom cadastrado com sucesso!',
            title: 'Cupom Cadastrado',
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          showErrorToast(
            context,
            'Erro ao cadastrar cupom. Tente novamente.',
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
    final parceirosList = (widget.parceiros ?? []).where((p) {
      if (_buscaParceiro.isEmpty) return true;
      final fantasia = (getJsonField(p, r'''$.fantasia''') ?? getJsonField(p, r'''$.partner.fantasia''') ?? '').toString().toLowerCase();
      final cnpj = (getJsonField(p, r'''$.cnpj''') ?? getJsonField(p, r'''$.partner.cnpj''') ?? '').toString().toLowerCase();
      final cnpjDigits = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
      final query = _buscaParceiro.toLowerCase().trim();
      final queryDigits = query.replaceAll(RegExp(r'[^0-9]'), '');
      return fantasia.contains(query) || cnpj.contains(query) || (queryDigits.isNotEmpty && cnpjDigits.contains(queryDigits));
    }).toList();

    final segNome = _parceiroSelecionado != null
        ? (getJsonField(_parceiroSelecionado, r'''$.segment.name''') ?? getJsonField(_parceiroSelecionado, r'''$.partner.segment.name''') ?? 'Geral').toString()
        : '';
    final segPhoto = _parceiroSelecionado != null
        ? (getJsonField(_parceiroSelecionado, r'''$.segment.photo''') ?? getJsonField(_parceiroSelecionado, r'''$.partner.segment.photo''') ?? '').toString()
        : '';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Container(
        width: (MediaQuery.sizeOf(context).width * 0.75).clamp(540.0, 720.0),
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.90),
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
                      Icons.discount_rounded,
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
                          'Cadastrar Novo Cupom',
                          style: GoogleFonts.readexPro(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryText,
                          ),
                        ),
                        Text(
                          'Ao selecionar o parceiro, seus dados e segmento são vinculados automaticamente.',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _model.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Seleção de Parceiro Inteligente (Busca por CNPJ ou Nome)
                      Text(
                        '1. Selecionar Parceiro / Estabelecimento *',
                        style: GoogleFonts.readexPro(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6.0),

                      DropdownButtonFormField<dynamic>(
                        value: _parceiroSelecionado,
                        isExpanded: true,
                        decoration: _buildInputDecoration(
                          'Buscar por Nome ou CNPJ...',
                          theme,
                          prefixIcon: Icon(Icons.storefront_rounded, color: theme.secondary, size: 18.0),
                        ),
                        style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                        items: parceirosList.map((p) {
                          final fantasia = (getJsonField(p, r'''$.fantasia''') ?? getJsonField(p, r'''$.partner.fantasia''') ?? getJsonField(p, r'''$.razao''') ?? 'Parceiro').toString();
                          final cnpj = (getJsonField(p, r'''$.cnpj''') ?? getJsonField(p, r'''$.partner.cnpj''') ?? '').toString();
                          return DropdownMenuItem<dynamic>(
                            value: p,
                            child: Text(
                              cnpj.isNotEmpty ? '$fantasia — CNPJ: $cnpj' : fantasia,
                              style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: _selecionarParceiro,
                      ),

                      // Card Informativo do Parceiro Selecionado e Segmento Herdado
                      if (_parceiroSelecionado != null) ...[
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: theme.primary.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: theme.secondary.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_rounded, color: theme.secondary, size: 20.0),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (getJsonField(_parceiroSelecionado, r'''$.fantasia''') ?? getJsonField(_parceiroSelecionado, r'''$.partner.fantasia''') ?? '').toString(),
                                      style: GoogleFonts.readexPro(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryText,
                                      ),
                                    ),
                                    Text(
                                      'CNPJ: ${(getJsonField(_parceiroSelecionado, r'''$.cnpj''') ?? getJsonField(_parceiroSelecionado, r'''$.partner.cnpj''') ?? 'Não informado')}',
                                      style: GoogleFonts.readexPro(
                                        fontSize: 11.5,
                                        color: theme.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Badge do Segmento Herdado Automaticamente
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: theme.secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: theme.alternate),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (segPhoto.isNotEmpty && segPhoto != 'null')
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4.0),
                                        child: Image.network(
                                          segPhoto,
                                          width: 14.0,
                                          height: 14.0,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Icon(Icons.category_outlined, size: 14.0, color: theme.secondary),
                                        ),
                                      )
                                    else
                                      Icon(Icons.category_outlined, size: 14.0, color: theme.secondary),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      segNome,
                                      style: GoogleFonts.readexPro(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: theme.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 20.0),

                      // 2. Desconto (%) e Validade Lado a Lado
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Porcentagem de Desconto
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Desconto (%) *',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                TextFormField(
                                  controller: _model.porcentagemTextController,
                                  focusNode: _model.porcentagemFocusNode,
                                  keyboardType: TextInputType.number,
                                  decoration: _buildInputDecoration(
                                    'Ex: 10',
                                    theme,
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 12.0, top: 12.0),
                                      child: Text(
                                        '%',
                                        style: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.bold,
                                          color: theme.secondary,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14.0),

                          // Data de Validade
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Data de Validade *',
                                  style: GoogleFonts.readexPro(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _model.datePicked ?? DateTime.now().add(const Duration(days: 30)),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: theme.primary,
                                              onPrimary: Colors.white,
                                              onSurface: theme.primaryText,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (picked != null) {
                                      setState(() => _model.datePicked = picked);
                                    }
                                  },
                                  child: Container(
                                    height: 44.0,
                                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                    decoration: BoxDecoration(
                                      color: theme.primaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(color: theme.alternate),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today_rounded, size: 16.0, color: theme.secondary),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          _model.datePicked != null
                                              ? DateFormat('dd/MM/yyyy').format(_model.datePicked!)
                                              : 'Expiração',
                                          style: GoogleFonts.readexPro(
                                            fontSize: 13.0,
                                            color: theme.primaryText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(Icons.edit_calendar_rounded, size: 16.0, color: theme.secondaryText),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18.0),

                      // 3. Título / Benefício do Cupom
                      Text(
                        'Título / Benefício Oferecido *',
                        style: GoogleFonts.readexPro(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _model.descricaoTextController,
                        focusNode: _model.descricaoFocusNode,
                        decoration: _buildInputDecoration(
                          'Título do benefício...',
                          theme,
                          hint: 'Ex: 15% de desconto no almoço executivo',
                        ),
                        style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                      ),

                      const SizedBox(height: 18.0),

                      // Card de Exclusividade Arms Pró ⭐
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: _model.isArmsPro
                              ? theme.secondary.withValues(alpha: 0.12)
                              : theme.primaryBackground,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: _model.isArmsPro
                                ? theme.secondary
                                : theme.alternate,
                            width: _model.isArmsPro ? 1.2 : 1.0,
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
                                Icons.star_rounded,
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
                                        'Exclusivo Membros Arms Pró',
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
                                    'Apenas assinantes Arms Pró poderão visualizar e resgatar este benefício',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: theme.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: _model.isArmsPro,
                              activeThumbColor: theme.secondary,
                              onChanged: (val) {
                                setState(() {
                                  _model.isArmsPro = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18.0),

                      // Limite de Estoque / Cupons
                      Text(
                        'Limite de Cupons (Estoque)',
                        style: GoogleFonts.readexPro(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _model.limiteQuantidadeTextController,
                        focusNode: _model.limiteQuantidadeFocusNode,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration(
                          'Ex: 20 (deixe vazio para ilimitado)',
                          theme,
                          hint: 'Quantidade máxima total disponível',
                          prefixIcon: Icon(Icons.inventory_2_outlined, color: theme.secondary, size: 18.0),
                        ),
                        style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                      ),

                      const SizedBox(height: 18.0),

                      // 4. Regras de Utilização & Condições
                      Text(
                        'Regras de Utilização & Condições',
                        style: GoogleFonts.readexPro(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        controller: _model.regrasTextController,
                        focusNode: _model.regrasFocusNode,
                        maxLines: 3,
                        decoration: _buildInputDecoration(
                          'Regras e restrições para uso no app...',
                          theme,
                          hint: 'Ex: Válido de segunda a sexta para consumo no local. Apresentar o cupom antes do fechamento da conta.',
                        ),
                        style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                      ),
                    ],
                  ),
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
                    onPressed: _salvando ? null : _salvar,
                    text: _salvando ? 'Cadastrando...' : 'Cadastrar Cupom',
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
