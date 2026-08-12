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

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _atualizarHistorico() {
    setState(() {
      _historyKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      width: MediaQuery.sizeOf(context).width * 0.22,
                      height: MediaQuery.sizeOf(context).height * 1.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).secondary,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 30.0, 0.0, 20.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: MediaQuery.sizeOf(context).width * 0.13,
                                height: MediaQuery.sizeOf(context).height * 0.1,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2.0,
                            indent: 20.0,
                            endIndent: 20.0,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 15.0, 0.0, 0.0),
                              child: wrapWithModel(
                                model: _model.menuParceiroModel,
                                updateCallback: () => safeSetState(() {}),
                                child: MenuParceiroWidget(),
                              ),
                            ),
                          ),
                        ],
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
                                  titulo: 'Validação de Cupom',
                                  breadcrumb: 'Parceiro',
                                  descricao:
                                      'Valide os códigos gerados pelos clientes para aplicar cashbacks e descontos',
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
                                                    'Código do Cupom*',
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
                                                      hintText: 'Ex: XYZ-1234',
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
                                        const SizedBox(height: 25.0),
                                        // Submit Button
                                        Align(
                                          alignment: AlignmentDirectional.bottomEnd,
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              _model.apiResultr69 = await ValidarCupomCall.call(
                                                code: _model.textController1?.text ?? '',
                                                value: _model.textController2?.text ?? '',
                                                paidValue: _model.textController2?.text ?? '',
                                              );

                                              if ((_model.apiResultr69?.succeeded ?? true)) {
                                                _atualizarHistorico();
                                                _model.textController1?.clear();
                                                _model.textController2?.clear();
                                                
                                                await showDialog(
                                                  context: context,
                                                  builder: (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Cupom validado'),
                                                      content: Text(
                                                          'O cupom apresentado foi validado com sucesso.'),
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
                                                          'Código inválido, expirado ou já utilizado.'),
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
                                            text: 'Validar Cupom',
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
                                      'Código do Cupom*',
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
                                        hintText: 'Ex: XYZ-1234',
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
                                        );

                                        if ((_model.apiResultr699?.succeeded ?? true)) {
                                          _atualizarHistorico();
                                          _model.codigoMobileTextController?.clear();
                                          _model.valorMobileTextController?.clear();

                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Cupom validado'),
                                                content: Text(
                                                    'O cupom apresentado foi validado com sucesso.'),
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
                                                    'Código inválido, expirado ou já utilizado.'),
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
                                      text: 'Validar Cupom',
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
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final response = snapshot.data!;
        final historyList = (response.jsonBody as List?) ?? [];

        if (historyList.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
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
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
            ),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: historyList.length > 5 ? 5 : historyList.length,
            separatorBuilder: (context, index) => Divider(
              color: FlutterFlowTheme.of(context).alternate,
              height: 20.0,
            ),
            itemBuilder: (context, index) {
              final item = historyList[index];
              final customerName = getJsonField(item, r'''$.customer.name''')?.toString() ?? 'Cliente';
              final productName = getJsonField(item, r'''$.product.name''')?.toString() ?? 'Benefício';
              final rawValue = getJsonField(item, r'''$.value''') ?? getJsonField(item, r'''$.valorPagar''');
              
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
                  Row(
                    children: [
                      Container(
                        width: 38.0,
                        height: 38.0,
                        decoration: BoxDecoration(
                          color: const Color(0x2000C853),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF00C853),
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customerName,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.bold,
                              ),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            productName,
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    formattedValue,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.bold,
                      ),
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
