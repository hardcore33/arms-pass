import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modal_adicionar_desconto_parceiro_model.dart';
export 'modal_adicionar_desconto_parceiro_model.dart';

class ModalAdicionarDescontoParceiroWidget extends StatefulWidget {
  const ModalAdicionarDescontoParceiroWidget({
    super.key,
    required this.partnerId,
  });

  final String partnerId;

  @override
  State<ModalAdicionarDescontoParceiroWidget> createState() =>
      _ModalAdicionarDescontoParceiroWidgetState();
}

class _ModalAdicionarDescontoParceiroWidgetState
    extends State<ModalAdicionarDescontoParceiroWidget> {
  late ModalAdicionarDescontoParceiroModel _model;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAdicionarDescontoParceiroModel());
    _model.descricaoTextController ??= TextEditingController();
    _model.descricaoFocusNode ??= FocusNode();
    _model.porcentagemTextController ??= TextEditingController();
    _model.porcentagemFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _salvarPromo() async {
    if (!_model.formKey.currentState!.validate()) return;
    if (_model.dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma data de validade')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      // 1. Obter a lista global de parceiros para localizar o tenantId e segmentId do parceiro logado
      final partnersResponse = await ObterParceirosCall.call();
      if (!partnersResponse.succeeded) {
        throw Exception('Erro ao buscar metadados do parceiro');
      }

      final partnersList = (partnersResponse.jsonBody as List?) ?? [];
      final logado = partnersList.firstWhere(
        (p) => getJsonField(p, r'''$.id''').toString() == widget.partnerId,
        orElse: () => null,
      );

      if (logado == null) {
        throw Exception('Parceiro logado não encontrado na lista');
      }

      final tenantId = getJsonField(logado, r'''$.tenant.id''').toString();
      final segmentId = getJsonField(logado, r'''$.segment.id''').toString();

      // 2. Chamar a API de adicionar desconto
      final addResult = await AdicionarDescontoCall.call(
        descricao: _model.descricaoTextController.text,
        porcentagem: _model.porcentagemTextController.text,
        idParceiro: widget.partnerId,
        data: dateTimeFormat(r'yyyy-MM-dd', _model.dataSelecionada),
        idTenant: tenantId,
        idSegmento: segmentId,
      );

      if (addResult.succeeded) {
        Navigator.pop(context, true); // Retorna true para indicar que salvou
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar promoção: ${addResult.response?.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
            ),
          ),
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).secondary,
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
                          'Cadastrar Nova Promoção',
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
                          'Crie um cupom de desconto que ficará disponível para os seus clientes',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 13.0,
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        // Descricao
                        Text(
                          'Nome/Descrição da Promoção*',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        TextFormField(
                          controller: _model.descricaoTextController,
                          focusNode: _model.descricaoFocusNode,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Ex: 15% desc. Whey Protein',
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
                            contentPadding: const EdgeInsets.all(16.0),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: _model.descricaoTextControllerValidator.asValidator(context),
                        ),
                        const SizedBox(height: 16.0),
                        // Porcentagem & Validade
                        Row(
                          children: [
                            // Porcentagem
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Desconto (%)*',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  TextFormField(
                                    controller: _model.porcentagemTextController,
                                    focusNode: _model.porcentagemFocusNode,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Ex: 15',
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
                                      contentPadding: const EdgeInsets.all(16.0),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    validator: _model.porcentagemTextControllerValidator.asValidator(context),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            // Data de Validade
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Validade*',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  InkWell(
                                    onTap: () async {
                                      final selected = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now().add(const Duration(days: 30)),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                                      );
                                      if (selected != null) {
                                        setState(() {
                                          _model.dataSelecionada = selected;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).primary,
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: const Color(0xFFC5C4C4),
                                          width: 0.5,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _model.dataSelecionada == null
                                                ? 'Selecionar data'
                                                : dateTimeFormat(r'dd/MM/yyyy', _model.dataSelecionada),
                                            style: TextStyle(
                                              color: _model.dataSelecionada == null
                                                  ? Colors.grey
                                                  : Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            color: FlutterFlowTheme.of(context).secondary,
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            FFButtonWidget(
                              onPressed: _salvarPromo,
                              text: 'Salvar Promoção',
                              options: FFButtonOptions(
                                width: 160.0,
                                height: 45.0,
                                padding: EdgeInsets.zero,
                                color: FlutterFlowTheme.of(context).secondary,
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
