import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/menu_mobile/menu_mobile_widget.dart';
import '/components/menu_parceiro/menu_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/components/header_pagina/header_pagina_widget.dart';
import '/components/loading_table_shimmer/loading_table_shimmer_widget.dart';
import 'validar_parceiro_model.dart';
export 'validar_parceiro_model.dart';

class ValidarParceiroWidget extends StatefulWidget {
  const ValidarParceiroWidget({super.key});

  static String routeName = 'Validar_Parceiro';
  static String routePath = '/partner/validar';

  @override
  State<ValidarParceiroWidget> createState() => _ValidarParceiroWidgetState();
}

class _ValidarParceiroWidgetState extends State<ValidarParceiroWidget> {
  late ValidarParceiroModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Controle local para forçar a atualização do histórico de validações
  Key _historyKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ValidarParceiroModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.codigoMobileTextController ??= TextEditingController();
    _model.codigoMobileFocusNode ??= FocusNode();

    _model.valorMobileTextController ??= TextEditingController();
    _model.valorMobileFocusNode ??= FocusNode();

    _carregarDescontos();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _carregarDescontos() async {
    safeSetState(() {
      _model.isLoadingDiscounts = true;
    });
    try {
      final res = await ObterDescontosDoParceiroPorIdCall.call(
        partnerId: currentUserUid,
      );
      if (res.succeeded && res.jsonBody is List) {
        final list = (res.jsonBody as List)
            .where((d) => d['isActive'] == true)
            .toList();
        _model.partnerDiscounts = list;
        if (list.isNotEmpty && _model.selectedDiscountId == null) {
          _model.selectedDiscountId = list.first['id']?.toString();
        }
      }
    } catch (_) {}
    if (mounted) {
      safeSetState(() {
        _model.isLoadingDiscounts = false;
      });
    }
  }

  void _atualizarHistorico() {
    setState(() {
      _historyKey = UniqueKey();
    });
  }

  Widget _buildDiscountSelector() {
    if (_model.isLoadingDiscounts) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            SizedBox(
              width: 14.0,
              height: 14.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: FlutterFlowTheme.of(context).secondary,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              'Carregando regras de desconto ativas...',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      );
    }

    if (_model.partnerDiscounts.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = FlutterFlowTheme.of(context);

    // Se tiver apenas 1 desconto
    if (_model.partnerDiscounts.length == 1) {
      final d = _model.partnerDiscounts.first;
      final discVal = (d['discount'] is num) ? d['discount'].toInt() : d['discount']?.toString() ?? '0';
      final desc = d['description']?.toString() ?? 'Desconto padrão';
      final rawValidity = d['validity']?.toString() ?? '';
      String formattedDate = '';
      if (rawValidity.isNotEmpty) {
        final parsed = DateTime.tryParse(rawValidity);
        if (parsed != null) {
          formattedDate = '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
        }
      }

      return Container(
        margin: const EdgeInsets.only(top: 18.0, bottom: 6.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: theme.secondary.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: theme.secondary,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                '$discVal% OFF',
                style: GoogleFonts.readexPro(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desc,
                    style: GoogleFonts.readexPro(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.0,
                    ),
                  ),
                  if (formattedDate.isNotEmpty)
                    Text(
                      'Válido até $formattedDate',
                      style: TextStyle(color: theme.secondaryText, fontSize: 11.5),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Se tiver múltiplos descontos: seletor interativo
    return Container(
      margin: const EdgeInsets.only(top: 18.0, bottom: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer_rounded, color: theme.secondary, size: 15.0),
              const SizedBox(width: 8.0),
              Text(
                'Selecione a regra/promoção desta compra (para validação por CPF):',
                style: GoogleFonts.readexPro(
                  color: theme.secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: _model.partnerDiscounts.map((d) {
              final idStr = d['id']?.toString() ?? '';
              final isSelected = _model.selectedDiscountId == idStr;
              final discVal = (d['discount'] is num) ? d['discount'].toInt() : d['discount']?.toString() ?? '0';
              final desc = d['description']?.toString() ?? 'Benefício';
              final rawValidity = d['validity']?.toString() ?? '';
              String formattedDate = '';
              if (rawValidity.isNotEmpty) {
                final parsed = DateTime.tryParse(rawValidity);
                if (parsed != null) {
                  formattedDate = '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
                }
              }

              return InkWell(
                onTap: () {
                  safeSetState(() {
                    _model.selectedDiscountId = idStr;
                  });
                },
                borderRadius: BorderRadius.circular(10.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.secondary.withValues(alpha: 0.15)
                        : theme.primary,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: isSelected ? theme.secondary : const Color(0xFF404040),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                        color: isSelected ? theme.secondary : Colors.grey,
                        size: 16.0,
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.secondary : Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          '$discVal% OFF',
                          style: GoogleFonts.readexPro(
                            color: isSelected ? theme.primary : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            desc,
                            style: GoogleFonts.readexPro(
                              color: isSelected ? Colors.white : Colors.grey[300],
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12.0,
                            ),
                          ),
                          if (formattedDate.isNotEmpty)
                            Text(
                              'Até $formattedDate',
                              style: TextStyle(
                                color: isSelected ? theme.secondaryText : Colors.grey[500],
                                fontSize: 10.5,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Desktop Version
            if (responsiveVisibility(
              context: context,
              phone: false,
              tablet: false,
              tabletLandscape: false,
            ))
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sidebar Menu
                    Container(
                    width: FFAppState().sidebarCollapsed
                        ? 80.0
                        : (MediaQuery.sizeOf(context).width * 0.22).clamp(220.0, 320.0),
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondary,
                    ),
                    child: wrapWithModel(
                      model: _model.menuParceiroModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const MenuParceiroWidget(),
                    ),
                  ),
                    // Main Content
                    Expanded(
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * 1.0,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 20.0, 24.0, 30.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const HeaderPaginaWidget(
                                  titulo: 'Validação de Cupom / CPF',
                                  breadcrumb: 'Parceiro',
                                  descricao:
                                      'Valide os códigos de cupons ou o CPF dos associados para aplicar descontos e benefícios',
                                ),
                                const SizedBox(height: 25.0),
                                Material(
                                  color: Colors.transparent,
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Row containing both fields
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Code Field
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Código do Cupom ou CPF do Associado*',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.readexPro(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8.0),
                                                  TextFormField(
                                                    controller: _model.textController1,
                                                    focusNode: _model.textFieldFocusNode1,
                                                    autofocus: false,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText: 'Ex: XYZ-1234 ou 000.000.000-00',
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFC5C4C4),
                                                          width: 0.5,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme.of(context).secondary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                      filled: true,
                                                      fillColor: FlutterFlowTheme.of(context).primary,
                                                      contentPadding: EdgeInsets.all(18.0),
                                                    ),
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.readexPro(),
                                                      color: Colors.white,
                                                    ),
                                                    validator: _model.textController1Validator.asValidator(context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 20.0),
                                            // Value Field
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    r'Valor da Compra R$*',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.readexPro(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8.0),
                                                  TextFormField(
                                                    controller: _model.textController2,
                                                    focusNode: _model.textFieldFocusNode2,
                                                    onChanged: (_) => EasyDebounce.debounce(
                                                      '_model.textController2',
                                                      Duration(milliseconds: 500),
                                                      () async {
                                                        _model.formatacao =
                                                            await actions.formatDecimalInput(
                                                          _model.textController2.text,
                                                        );
                                                        safeSetState(() {
                                                          _model.textController2?.text =
                                                              _model.formatacao!;
                                                        });
                                                      },
                                                    ),
                                                    autofocus: false,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText: '0,00',
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFC5C4C4),
                                                          width: 0.5,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme.of(context).secondary,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                      filled: true,
                                                      fillColor: FlutterFlowTheme.of(context).primary,
                                                      contentPadding: EdgeInsets.all(18.0),
                                                    ),
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.readexPro(),
                                                      color: Colors.white,
                                                    ),
                                                    validator: _model.textController2Validator.asValidator(context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        _buildDiscountSelector(),
                                        const SizedBox(height: 18.0),
                                        // Submit Button
                                        Align(
                                          alignment: AlignmentDirectional.bottomEnd,
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              final code = _model.textController1?.text.trim() ?? '';
                                              if (code.isEmpty) {
                                                showWarningToast(
                                                  context,
                                                  'Por favor, informe o código do cupom ou CPF.',
                                                );
                                                return;
                                              }

                                              _model.apiResultr69 = await ValidarCupomCall.call(
                                                code: code,
                                                value: _model.textController2?.text ?? '',
                                                paidValue: _model.textController2?.text ?? '',
                                                partnerId: currentUserUid,
                                                discountId: _model.selectedDiscountId,
                                              );

                                              if (_model.apiResultr69?.succeeded == true) {
                                                _atualizarHistorico();
                                                _model.textController1?.clear();
                                                _model.textController2?.clear();
                                                
                                                if (context.mounted) {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: const Text('Validação Concluída'),
                                                        content: const Text(
                                                            'O benefício do cliente foi validado com sucesso.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(alertDialogContext),
                                                            child: const Text('Ok'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              } else {
                                                String errorMsg = 'Cupom ou CPF inválido, não encontrado ou benefício expirado.';
                                                final bodyText = _model.apiResultr69?.response?.body ?? '';
                                                if (bodyText.contains('Cliente não possui assinatura Arms Pro')) {
                                                  errorMsg = 'Cliente não possui assinatura Arms Pro ativa ou está inativo.';
                                                } else if (bodyText.contains('Nenhum desconto ativo')) {
                                                  errorMsg = 'Nenhum desconto ativo ou válido encontrado para este parceiro.';
                                                }

                                                if (context.mounted) {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: const Text('Falha na validação'),
                                                        content: Text(errorMsg),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(alertDialogContext),
                                                            child: const Text('Ok'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                            text: 'Validar Benefício',
                                            options: FFButtonOptions(
                                              width: 180.0,
                                              height: 50.0,
                                              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: FlutterFlowTheme.of(context).secondary,
                                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                font: GoogleFonts.readexPro(),
                                                color: FlutterFlowTheme.of(context).primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              elevation: 3.0,
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 35.0),
                              // Recent Validations (History List)
                              Text(
                                'Últimas Validações de Hoje',
                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                  font: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                width: double.infinity,
                                child: _buildHistorySection(desktop: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Mobile Version
            if (responsiveVisibility(
              context: context,
              desktop: false,
            ))
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      wrapWithModel(
                        model: _model.menuMobileModel,
                        updateCallback: () => safeSetState(() {}),
                        child: MenuMobileWidget(),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20.0, 30.0, 20.0, 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Validação de Cupom',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: FlutterFlowTheme.of(context).secondary,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            // Form Mobile Container
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Code input
                                    Text(
                                      'Código do Cupom ou CPF do Associado*',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    TextFormField(
                                      controller: _model.codigoMobileTextController,
                                      focusNode: _model.codigoMobileFocusNode,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Ex: XYZ-1234 ou 000.000.000-00',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFC5C4C4),
                                            width: 0.5,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).secondary,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context).primary,
                                        contentPadding: EdgeInsets.all(18.0),
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.readexPro(),
                                        color: Colors.white,
                                      ),
                                      validator: _model.codigoMobileTextControllerValidator.asValidator(context),
                                    ),
                                    const SizedBox(height: 16.0),
                                    // Value input
                                    Text(
                                      r'Valor da Compra R$*',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    TextFormField(
                                      controller: _model.valorMobileTextController,
                                      focusNode: _model.valorMobileFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.valorMobileTextController',
                                        Duration(milliseconds: 500),
                                        () async {
                                          _model.formatacaoMobile =
                                              await actions.formatDecimalInput(
                                            _model.valorMobileTextController.text,
                                          );
                                          safeSetState(() {
                                            _model.valorMobileTextController?.text =
                                                _model.formatacaoMobile!;
                                          });
                                        },
                                      ),
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: '0,00',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFC5C4C4),
                                            width: 0.5,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).secondary,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context).primary,
                                        contentPadding: EdgeInsets.all(18.0),
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.readexPro(),
                                        color: Colors.white,
                                      ),
                                      validator: _model.valorMobileTextControllerValidator.asValidator(context),
                                    ),
                                    const SizedBox(height: 25.0),
                                    // Submit mobile button
                                    FFButtonWidget(
                                      onPressed: () async {
                                        _model.apiResultr699 = await ValidarCupomCall.call(
                                          code: _model.codigoMobileTextController?.text ?? '',
                                          value: _model.valorMobileTextController?.text ?? '',
                                          paidValue: _model.valorMobileTextController?.text ?? '',
                                          partnerId: currentUserUid,
                                        );

                                        if ((_model.apiResultr699?.succeeded ?? true)) {
                                          _atualizarHistorico();
                                          _model.codigoMobileTextController?.clear();
                                          _model.valorMobileTextController?.clear();

                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Validação Concluída'),
                                                content: Text(
                                                    'O benefício do cliente foi validado com sucesso.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(alertDialogContext),
                                                    child: Text('Ok'),
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
                                                title: Text('Falha na validação'),
                                                content: Text(
                                                    'Cupom ou CPF inválido, não encontrado ou já utilizado.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      text: 'Validar Benefício',
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 50.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context).secondary,
                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          font: GoogleFonts.readexPro(),
                                          color: FlutterFlowTheme.of(context).primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 35.0),
                            // Recent list Mobile
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Últimas Validações',
                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                  font: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            _buildHistorySection(desktop: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Componente dinâmico de Histórico usando a chamada GetHistoricoRecenteCall
  Widget _buildHistorySection({required bool desktop}) {
    // Usando o UniqueKey local para forçar a re-execução do FutureBuilder ao validar
    return FutureBuilder<ApiCallResponse>(
      key: _historyKey,
      future: GetHistoricoRecenteCall.call(
        partnerId: int.tryParse(currentUserUid),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingTableShimmerWidget(
            titulo: 'Histórico Recente',
            rowCount: 3,
          );
        }

        final response = snapshot.data!;
        final historyList = ((response.jsonBody as List?) ?? [])
            .where((item) => getJsonField(item, r'''$.is_point''') == true || getJsonField(item, r'''$.qtd_point''') != null || getJsonField(item, r'''$.total_saving''') != null)
            .toList();

        if (historyList.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: const Color(0xFF26221A),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.history_toggle_off_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 40.0,
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Nenhuma validação registrada hoje',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: const Color(0xFF26221A),
            ),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: historyList.length > 6 ? 6 : historyList.length,
            separatorBuilder: (context, index) => Divider(
              color: const Color(0xFF26221A),
              height: 20.0,
            ),
            itemBuilder: (context, index) {
              final item = historyList[index];
              final customerName = getJsonField(item, r'''$.customer.name''')?.toString() ?? 
                                   getJsonField(item, r'''$.customer.cpf''')?.toString() ?? 'Associado';
              final desc = getJsonField(item, r'''$.description''')?.toString() ?? '';
              String displaySubtitle = 'Benefício Validado';
              if (desc.contains('Desconto resgatado:')) {
                displaySubtitle = desc.replaceAll('Desconto resgatado:', '').trim();
              } else if (desc.contains('Cupom validado')) {
                displaySubtitle = 'Benefício Validado no Caixa';
              } else if (desc.isNotEmpty) {
                displaySubtitle = desc;
              }

              final rawValue = getJsonField(item, r'''$.qtd_point''') ?? 
                               getJsonField(item, r'''$.qtdPoint''') ?? 
                               getJsonField(item, r'''$.total_saving''') ?? 
                               getJsonField(item, r'''$.totalSaving''') ?? 
                               getJsonField(item, r'''$.value''') ?? 
                               getJsonField(item, r'''$.valorPagar''');
              
              double? parsedVal;
              if (rawValue != null) {
                if (rawValue is num) {
                  parsedVal = rawValue.toDouble();
                } else if (rawValue is String) {
                  parsedVal = double.tryParse(rawValue);
                }
              }
              final formattedValue = parsedVal != null 
                  ? 'R\$ ' + parsedVal.toStringAsFixed(2).replaceAll('.', ',')
                  : 'R\$ 0,00';

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 38.0,
                          height: 38.0,
                          decoration: const BoxDecoration(
                            color: Color(0x2000C853),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF00C853),
                            size: 20.0,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.readexPro(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                displaySubtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    formattedValue,
                    style: GoogleFonts.readexPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: FlutterFlowTheme.of(context).secondary,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
