import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'listagem_de_trocas_model.dart';
export 'listagem_de_trocas_model.dart';

class ListagemDeTrocasWidget extends StatefulWidget {
  const ListagemDeTrocasWidget({
    super.key,
    required this.trocas,
  });

  final List<dynamic>? trocas;

  @override
  State<ListagemDeTrocasWidget> createState() => _ListagemDeTrocasWidgetState();
}

class _ListagemDeTrocasWidgetState extends State<ListagemDeTrocasWidget> {
  late ListagemDeTrocasModel _model;
  String sortField = 'data';
  bool sortAscending = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  List<dynamic> _groupData(List<dynamic> rawList) {
    final Map<String, Map<String, dynamic>> grouped = {};
    for (var item in rawList) {
      final customer = item['customer'];
      if (customer == null) continue;
      final customerId = customer['id']?.toString() ?? 'unknown';
      
      final points = _parseDouble(item['qtd_point']);
      final savings = _parseDouble(item['total_saving']);
      
      if (!grouped.containsKey(customerId)) {
        grouped[customerId] = {
          'id': customerId,
          'customer': customer,
          'total_cupons': 1,
          'qtd_point': points,
          'total_saving': savings,
          'data': item['data'],
        };
      } else {
        grouped[customerId]!['total_cupons'] = (grouped[customerId]!['total_cupons'] as int) + 1;
        grouped[customerId]!['qtd_point'] = (grouped[customerId]!['qtd_point'] as double) + points;
        grouped[customerId]!['total_saving'] = (grouped[customerId]!['total_saving'] as double) + savings;
        
        final existingDate = grouped[customerId]!['data']?.toString() ?? '';
        final newDate = item['data']?.toString() ?? '';
        if (newDate.compareTo(existingDate) > 0) {
          grouped[customerId]!['data'] = newDate;
        }
      }
    }
    return grouped.values.toList();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListagemDeTrocasModel());

    final list = widget.trocas;
    if (list is List) {
      _model.trocasLocal = _groupData(list.toList().cast<dynamic>());
    } else {
      _model.trocasLocal = [];
    }

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final list = widget.trocas;
      if (list is List) {
        _model.trocasLocal = _groupData(list.toList().cast<dynamic>());
      } else {
        _model.trocasLocal = [];
      }
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didUpdateWidget(covariant ListagemDeTrocasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trocas != oldWidget.trocas) {
      final list = widget.trocas;
      if (list is List) {
        _model.trocasLocal = _groupData(list.toList().cast<dynamic>());
      } else {
        _model.trocasLocal = [];
      }
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> parseDescription(String desc, dynamic partnerRaw) {
      // Try to get the partner name from the JSON object or just use the ID
      String partnerLabel = 'Parceiro';
      if (partnerRaw is Map) {
        final n = partnerRaw['name'] ?? partnerRaw['nome'];
        if (n != null && n.toString().trim().isNotEmpty) {
          partnerLabel = n.toString().trim();
        } else if (partnerRaw['id'] != null) {
          partnerLabel = 'Parceiro (ID ${partnerRaw['id']})';
        }
      } else if (partnerRaw != null && partnerRaw.toString().isNotEmpty && partnerRaw.toString() != 'null') {
        partnerLabel = 'Parceiro (ID $partnerRaw)';
      }

      try {
        String beneficio = 'Cupom';
        String empresa = partnerLabel;
        final clean = desc.trim();
        if (clean.contains('Desconto resgatado:')) {
          final raw = clean.replaceAll('Desconto resgatado:', '').trim();
          if (raw.contains(', valor do desconto:')) {
            final p = raw.split(', valor do desconto:');
            beneficio = p[0].trim();
            if (p.length > 1) {
              final rest = p[1];
              if (rest.contains('na empresa:')) {
                empresa = rest.split('na empresa:')[1].trim();
              }
            }
          } else if (raw.contains('na empresa:')) {
            final p = raw.split('na empresa:');
            beneficio = p[0].trim();
            if (p.length > 1) {
              empresa = p[1].trim();
            }
          } else {
            beneficio = raw;
          }
        } else if (clean.contains('Cupom validado com sucesso')) {
          beneficio = 'Validação de Pontos';
          if (clean.contains('na empresa:')) {
            empresa = clean.split('na empresa:')[1].trim();
          }
        } else if (clean.contains('valor do desconto:')) {
          final p = clean.split(', valor do desconto:');
          beneficio = p[0].trim();
          if (p.length > 1) {
            final rest = p[1];
            if (rest.contains('na empresa:')) {
              empresa = rest.split('na empresa:')[1].trim();
            }
          }
        } else {
          beneficio = clean;
        }
        return {'beneficio': beneficio, 'empresa': empresa};
      } catch (e) {
        return {'beneficio': desc.isNotEmpty ? desc : 'Cupom', 'empresa': partnerLabel};
      }
    }

    String formatDate(String raw) {
      if (raw.isEmpty) return '-';
      // Try ISO 8601 first (e.g. 2025-09-24T21:21:11)
      try {
        final dt = DateTime.parse(raw);
        final d = '${dt.day.toString().padLeft(2,'0')}/${dt.month.toString().padLeft(2,'0')}/${dt.year}';
        final t = '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
        return '$d $t';
      } catch (_) {}
      // Try "Wed Sep 24 21:21:11 BRT 2025" format
      final monthMap = <String, int>{'Jan': 1,'Feb': 2,'Mar': 3,'Apr': 4,'May': 5,'Jun': 6,'Jul': 7,'Aug': 8,'Sep': 9,'Oct': 10,'Nov': 11,'Dec': 12};
      final regex = RegExp(r'\w{3} (\w{3}) (\d{1,2}) (\d{2}):(\d{2}):(\d{2}) \w+ (\d{4})');
      final m = regex.firstMatch(raw);
      if (m != null) {
        final month = monthMap[m.group(1)] ?? 1;
        final day = int.tryParse(m.group(2)!) ?? 1;
        final hour = int.tryParse(m.group(3)!) ?? 0;
        final minute = int.tryParse(m.group(4)!) ?? 0;
        final year = int.tryParse(m.group(6)!) ?? 0;
        return '${day.toString().padLeft(2,'0')}/${month.toString().padLeft(2,'0')}/$year ${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}';
      }
      return raw;
    }

    Widget _buildSortableHeader(
      BuildContext context,
      String field,
      Widget label,
    ) {
      final isActive = sortField == field;
      return InkWell(
        onTap: () {
          safeSetState(() {
            if (sortField == field) {
              sortAscending = !sortAscending;
            } else {
              sortField = field;
              sortAscending = true;
            }
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            const SizedBox(width: 2.0),
            Icon(
              isActive
                  ? (sortAscending
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded)
                  : Icons.unfold_more_rounded,
              size: 12.0,
              color: isActive
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
            ),
          ],
        ),
      );
    }

    List<dynamic> sortedList(List<dynamic> input) {
      final result = input.toList();
      result.sort((a, b) {
        dynamic valA;
        dynamic valB;
        switch (sortField) {
          case 'id':
            valA = getJsonField(a, r'''$.id''');
            valB = getJsonField(b, r'''$.id''');
            break;
          case 'total_cupons':
            final rawA = getJsonField(a, r'''$.total_cupons''');
            final rawB = getJsonField(b, r'''$.total_cupons''');
            valA = rawA is num ? rawA.toInt() : 0;
            valB = rawB is num ? rawB.toInt() : 0;
            break;
          case 'cliente':
          case 'data':
            valA = getJsonField(a, r'''$.data''')?.toString() ?? '';
            valB = getJsonField(b, r'''$.data''')?.toString() ?? '';
            break;
          case 'pontos':
            final rawA = getJsonField(a, r'''$.qtd_point''');
            final rawB = getJsonField(b, r'''$.qtd_point''');
            double parsedPA = 0.0;
            double parsedPB = 0.0;
            if (rawA is num) parsedPA = rawA.toDouble();
            if (rawA is String) parsedPA = double.tryParse(rawA) ?? 0.0;
            if (rawB is num) parsedPB = rawB.toDouble();
            if (rawB is String) parsedPB = double.tryParse(rawB) ?? 0.0;
            valA = parsedPA;
            valB = parsedPB;
            break;
          case 'economia':
            final rawEA = getJsonField(a, r'''$.total_saving''');
            final rawEB = getJsonField(b, r'''$.total_saving''');
            double parsedEA = 0.0;
            double parsedEB = 0.0;
            if (rawEA is num) parsedEA = rawEA.toDouble();
            if (rawEA is String) parsedEA = double.tryParse(rawEA) ?? 0.0;
            if (rawEB is num) parsedEB = rawEB.toDouble();
            if (rawEB is String) parsedEB = double.tryParse(rawEB) ?? 0.0;
            valA = parsedEA;
            valB = parsedEB;
            break;
          default:
            valA = '';
            valB = '';
        }
        int cmp;
        if (valA is num && valB is num) {
          cmp = valA.compareTo(valB);
        } else {
          cmp = valA.toString().compareTo(valB.toString());
        }
        return sortAscending ? cmp : -cmp;
      });
      return result;
    }

    return Container(
      width: MediaQuery.sizeOf(context).width * 0.74,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
              child: Material(
                color: Colors.transparent,
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.74,
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            35.0, 30.0, 0.0, 0.0),
                        child: Container(
                          width: 250.0,
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.textController',
                              Duration(milliseconds: 2000),
                              () async {
                                final list = widget.trocas;
                                _model.trocasFiltradas =
                                    await actions.filtrarPorNome(
                                  (list is List ? list.toList() : []),
                                  _model.textController.text,
                                  3,
                                  true,
                                );
                                _model.trocasLocal =
                                    (_model.trocasFiltradas ?? [])
                                        .toList()
                                        .cast<dynamic>();
                                safeSetState(() {});
                              },
                            ),
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Procurar',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF909090),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFCCCCCC),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 10.0, 20.0, 10.0),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Color(0xFF9A9A9A),
                                size: 21.0,
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            cursorColor:
                                FlutterFlowTheme.of(context).primaryText,
                            validator: _model.textControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(
                          FlutterFlowTheme.of(context)
                              .designToken
                              .radius
                              .sm),
                    ),
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 12.0, 16.0, 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: _buildSortableHeader(
                                context,
                                'id',
                                Text(
                                  'ID',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: _buildSortableHeader(
                                context,
                                'total_cupons',
                                Text(
                                  'TOTAL DE CUPONS',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: _buildSortableHeader(
                                context,
                                'cliente',
                                Text(
                                  'USUÁRIO',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: _buildSortableHeader(
                                context,
                                'pontos',
                                Text(
                                  'PONTOS',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: _buildSortableHeader(
                                context,
                                'economia',
                                Text(
                                  'ECONOMIA',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        fontSize: 13.5,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.54,
                  decoration: const BoxDecoration(),
                  child: Builder(
                    builder: (context) {
                      final itemTrocas = sortedList(_model.trocasLocal);

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: itemTrocas.length,
                        itemBuilder: (context, itemTrocasIndex) {
                          final itemTrocasItem = itemTrocas[itemTrocasIndex];
                          final parsed = parseDescription(
                            (getJsonField(itemTrocasItem, r'''$.description''') ?? '').toString(),
                            getJsonField(itemTrocasItem, r'''$.partner''')?.toString() ?? '',
                          );
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: wrapWithModel(
                                          model: _model.fonteDadosTabelaModels1
                                              .getModel(
                                            itemTrocasItem.toString(),
                                            itemTrocasIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: FonteDadosTabelaWidget(
                                            key: Key(
                                              'Key9h0_${itemTrocasItem.toString()}',
                                            ),
                                            text: getJsonField(
                                              itemTrocasItem,
                                              r'''$.id''',
                                            ).toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: wrapWithModel(
                                            model: _model.fonteDadosTabelaModels2
                                                .getModel(
                                              itemTrocasItem.toString(),
                                              itemTrocasIndex,
                                            ),
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: FonteDadosTabelaWidget(
                                              key: Key(
                                                'Key_desc_${itemTrocasItem.toString()}',
                                              ),
                                              text: () {
                                                final count = getJsonField(itemTrocasItem, r'''$.total_cupons''');
                                                if (count == null) return '0 cupons';
                                                return '$count ${count == 1 ? 'cupom' : 'cupons'}';
                                              }(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: wrapWithModel(
                                            model: _model.fonteDadosTabelaModels3
                                                .getModel(
                                              itemTrocasItem.toString(),
                                              itemTrocasIndex,
                                            ),
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: FonteDadosTabelaWidget(
                                              key: Key(
                                                'Key_cust_${itemTrocasItem.toString()}',
                                              ),
                                              text: (getJsonField(itemTrocasItem, r'''$.customer.name''') ?? '').toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: const BoxDecoration(),
                                        child: Align(
                                          alignment: const AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            () {
                                              final raw = getJsonField(itemTrocasItem, r'''$.qtd_point''');
                                              if (raw == null) return '0 pts';
                                              double? v;
                                              if (raw is num) v = raw.toDouble();
                                              else if (raw is String) v = double.tryParse(raw);
                                              if (v == null || v <= 0) return '0 pts';
                                              return '${v.toInt()} pts';
                                            }(),
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  font: GoogleFonts.openSans(),
                                                  fontSize: 13.5,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: const BoxDecoration(),
                                        child: Align(
                                          alignment: const AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            () {
                                              final raw = getJsonField(itemTrocasItem, r'''$.total_saving''');
                                              if (raw == null) return 'R\$ 0,00';
                                              double? v;
                                              if (raw is num) v = raw.toDouble();
                                              else if (raw is String) v = double.tryParse(raw);
                                              if (v == null || v <= 0) return 'R\$ 0,00';
                                              return 'R\$ ' + v.toStringAsFixed(2).replaceAll('.', ',');
                                            }(),
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  font: GoogleFonts.openSans(),
                                                  fontSize: 13.5,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 6.0, 0.0, 6.0),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 1.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC7C7C7),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
            ),
          ),
        ],
      ),
    );
  }
}
