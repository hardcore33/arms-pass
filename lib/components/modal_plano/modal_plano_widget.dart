import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/plans_and_subscriptions_service.dart';
import '/components/seletor_parceiros_plano/seletor_parceiros_plano_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'modal_plano_model.dart';
export 'modal_plano_model.dart';

class ModalPlanoWidget extends StatefulWidget {
  const ModalPlanoWidget({
    super.key,
    this.planoToEdit,
  });

  final PlanModel? planoToEdit;

  @override
  State<ModalPlanoWidget> createState() => _ModalPlanoWidgetState();
}

class _ModalPlanoWidgetState extends State<ModalPlanoWidget> {
  late ModalPlanoModel _model;
  bool _isSaving = false;

  final List<String> _ciclos = ['Mensal', 'Trimestral', 'Semestral', 'Anual'];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalPlanoModel());

    final p = widget.planoToEdit;
    _model.nomeController = TextEditingController(text: p?.name ?? '');
    _model.nomeFocusNode = FocusNode();

    _model.valorController = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(2) : '',
    );
    _model.valorFocusNode = FocusNode();

    _model.tagController = TextEditingController(text: p?.highlightTag ?? '');
    _model.tagFocusNode = FocusNode();

    _model.beneficioController = TextEditingController();
    _model.beneficioFocusNode = FocusNode();

    _model.cicloSelecionado = p?.billingCycle ?? 'Mensal';
    _model.statusAtivo = p?.isActive ?? true;
    _model.beneficios = p != null ? List<String>.from(p.benefits) : [];
    _model.parceirosSelecionados = p != null ? List<int>.from(p.eligiblePartnerIds) : [];
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  void _adicionarBeneficio() {
    final texto = _model.beneficioController?.text.trim() ?? '';
    if (texto.isNotEmpty && !_model.beneficios.contains(texto)) {
      setState(() {
        _model.beneficios.add(texto);
        _model.beneficioController?.clear();
      });
    }
  }

  void _removerBeneficio(String b) {
    setState(() {
      _model.beneficios.remove(b);
    });
  }

  Future<void> _salvar() async {
    final nome = _model.nomeController?.text.trim() ?? '';
    if (nome.isEmpty) {
      showErrorToast(context, 'Por favor, informe o nome do plano.');
      return;
    }

    final valorStr = _model.valorController?.text.replaceAll(',', '.').trim() ?? '';
    final valor = double.tryParse(valorStr);
    if (valor == null || valor < 0) {
      showErrorToast(context, r'Por favor, informe um valor válido em R$.');
      return;
    }

    if (_model.beneficios.isEmpty) {
      showWarningToast(context, 'Adicione pelo menos um benefício para o plano.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final id = widget.planoToEdit?.id ?? 'plan_${DateTime.now().millisecondsSinceEpoch}';
      final tag = _model.tagController?.text.trim();

      final planToSave = PlanModel(
        id: id,
        name: nome,
        price: valor,
        billingCycle: _model.cicloSelecionado,
        highlightTag: tag?.isNotEmpty == true ? tag : null,
        benefits: _model.beneficios,
        isActive: _model.statusAtivo,
        eligiblePartnerIds: _model.parceirosSelecionados,
      );

      await PlansAndSubscriptionsService().savePlan(planToSave);

      if (mounted) {
        Navigator.pop(context, true);
        showSuccessToast(
          context,
          widget.planoToEdit == null ? 'Plano cadastrado com sucesso!' : 'Plano atualizado com sucesso!',
          title: 'Gestão de Planos',
        );
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(context, 'Erro ao salvar plano: $e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isEdit = widget.planoToEdit != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 680,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.90,
        ),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.alternate, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header do Modal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.alternate, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isEdit ? Icons.edit_note_rounded : Icons.add_card_rounded,
                      color: theme.secondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Editar Plano Arms Pró' : 'Novo Plano Arms Pró',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryText,
                          ),
                        ),
                        Text(
                          'Configure os valores, ciclo, benefícios e parceiros credenciados',
                          style: GoogleFonts.readexPro(
                            fontSize: 12,
                            color: theme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.secondaryText, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Conteúdo Rolável do Formulário
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome do Plano
                    Text(
                      'Nome do Plano *',
                      style: GoogleFonts.readexPro(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _model.nomeController,
                      focusNode: _model.nomeFocusNode,
                      style: GoogleFonts.readexPro(fontSize: 13, color: theme.primaryText),
                      decoration: InputDecoration(
                        hintText: 'Ex.: Arms Pró Black Anual, Arms Pró Mensal...',
                        hintStyle: GoogleFonts.readexPro(
                          fontSize: 12.5,
                          color: theme.secondaryText,
                        ),
                        filled: true,
                        fillColor: theme.primaryBackground,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: theme.alternate),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: theme.alternate),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: theme.secondary, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Valor, Ciclo e Tag
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Valor
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r'Valor (R$) *',
                                style: GoogleFonts.readexPro(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: theme.primaryText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _model.valorController,
                                focusNode: _model.valorFocusNode,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                style: GoogleFonts.readexPro(fontSize: 13, color: theme.primaryText),
                                decoration: InputDecoration(
                                  prefixText: 'R\$ ',
                                  prefixStyle: GoogleFonts.readexPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.secondary,
                                  ),
                                  hintText: '99.90',
                                  hintStyle: GoogleFonts.readexPro(
                                    fontSize: 12.5,
                                    color: theme.secondaryText,
                                  ),
                                  filled: true,
                                  fillColor: theme.primaryBackground,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: theme.alternate),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: theme.alternate),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: theme.secondary, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Ciclo de Cobrança
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ciclo de Cobrança *',
                                style: GoogleFonts.readexPro(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: theme.primaryText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: theme.primaryBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: theme.alternate),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _model.cicloSelecionado,
                                    isExpanded: true,
                                    dropdownColor: theme.secondaryBackground,
                                    icon: Icon(Icons.arrow_drop_down, color: theme.secondary),
                                    style: GoogleFonts.readexPro(fontSize: 13, color: theme.primaryText),
                                    items: _ciclos.map((c) {
                                      return DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => _model.cicloSelecionado = val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Tag Promocional
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tag de Destaque',
                                style: GoogleFonts.readexPro(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: theme.primaryText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _model.tagController,
                                focusNode: _model.tagFocusNode,
                                style: GoogleFonts.readexPro(fontSize: 13, color: theme.primaryText),
                                decoration: InputDecoration(
                                  hintText: 'Ex: Mais Popular',
                                  hintStyle: GoogleFonts.readexPro(
                                    fontSize: 12.5,
                                    color: theme.secondaryText,
                                  ),
                                  filled: true,
                                  fillColor: theme.primaryBackground,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: theme.alternate),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: theme.alternate),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: theme.secondary, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Status (Ativo / Inativo)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.primaryBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.alternate),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _model.statusAtivo ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
                                color: _model.statusAtivo ? const Color(0xFF249689) : const Color(0xFFE57373),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status do Plano',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.primaryText,
                                    ),
                                  ),
                                  Text(
                                    _model.statusAtivo
                                        ? 'Plano visível e elegível para novas contratações'
                                        : 'Plano pausado/inativo no aplicativo',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 11,
                                      color: theme.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Switch(
                            value: _model.statusAtivo,
                            activeColor: theme.secondary,
                            activeTrackColor: theme.secondary.withValues(alpha: 0.3),
                            inactiveThumbColor: theme.secondaryText.withValues(alpha: 0.4),
                            inactiveTrackColor: theme.alternate,
                            onChanged: (val) => setState(() => _model.statusAtivo = val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Lista de Benefícios Gerais
                    Text(
                      'Lista de Benefícios do Plano *',
                      style: GoogleFonts.readexPro(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _model.beneficioController,
                            focusNode: _model.beneficioFocusNode,
                            onSubmitted: (_) => _adicionarBeneficio(),
                            style: GoogleFonts.readexPro(fontSize: 13, color: theme.primaryText),
                            decoration: InputDecoration(
                              hintText: 'Ex.: Acesso livre à academia, Concierge VIP, Desconto na rede...',
                              hintStyle: GoogleFonts.readexPro(
                                fontSize: 12.5,
                                color: theme.secondaryText,
                              ),
                              filled: true,
                              fillColor: theme.primaryBackground,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: theme.alternate),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: theme.alternate),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: theme.secondary, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _adicionarBeneficio,
                          icon: const Icon(Icons.add, size: 16),
                          label: Text(
                            'Adicionar',
                            style: GoogleFonts.readexPro(fontSize: 12.5, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.secondary,
                            foregroundColor: const Color(0xFF14120E),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                    if (_model.beneficios.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _model.beneficios.map((b) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.primaryBackground,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: theme.alternate),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, size: 14, color: const Color(0xFF249689)),
                                const SizedBox(width: 6),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 420),
                                  child: Text(
                                    b,
                                    style: GoogleFonts.readexPro(
                                      fontSize: 12,
                                      color: theme.primaryText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                InkWell(
                                  onTap: () => _removerBeneficio(b),
                                  child: const Icon(Icons.close, size: 14, color: Color(0xFFE57373)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 22),

                    // Seletor de Parceiros Elegíveis (Vínculo)
                    SeletorParceirosPlanoWidget(
                      selectedPartnerIds: _model.parceirosSelecionados,
                      onChanged: (updated) {
                        setState(() => _model.parceirosSelecionados = updated);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Footer com Botões de Ação
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme.alternate, width: 1.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.secondaryText,
                      side: BorderSide(color: theme.alternate),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.readexPro(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.secondary,
                      foregroundColor: const Color(0xFF14120E),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 2,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF14120E),
                            ),
                          )
                        : Text(
                            isEdit ? 'Salvar Alterações' : 'Cadastrar Plano',
                            style: GoogleFonts.readexPro(fontSize: 13, fontWeight: FontWeight.bold),
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
