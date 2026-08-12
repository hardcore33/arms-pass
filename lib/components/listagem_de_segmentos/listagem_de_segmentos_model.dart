import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/components/modal_adicionar_segmento/modal_adicionar_segmento_widget.dart';
import '/components/modal_alterar_segmento/modal_alterar_segmento_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'listagem_de_segmentos_widget.dart' show ListagemDeSegmentosWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListagemDeSegmentosModel
    extends FlutterFlowModel<ListagemDeSegmentosWidget> {
  ///  Local state fields for this component.

  List<dynamic> cuponsLocal = [];
  void addToCuponsLocal(dynamic item) => cuponsLocal.add(item);
  void removeFromCuponsLocal(dynamic item) => cuponsLocal.remove(item);
  void removeAtIndexFromCuponsLocal(int index) => cuponsLocal.removeAt(index);
  void insertAtIndexInCuponsLocal(int index, dynamic item) =>
      cuponsLocal.insert(index, item);
  void updateCuponsLocalAtIndex(int index, Function(dynamic) updateFn) =>
      cuponsLocal[index] = updateFn(cuponsLocal[index]);

  String sortField = '';
  bool sortAscending = true;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (obterSegmentos)] action in Listagem_de_segmentos widget.
  ApiCallResponse? obterSegmentos;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - filtrarPorNome] action in TextField widget.
  List<dynamic>? cuponsFiltrados;
  // Stores action output result for [Backend Call - API (obterSegmentos)] action in Button widget.
  ApiCallResponse? apiResult230s;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel1;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel2;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels1;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels2;
  // Stores action output result for [Backend Call - API (obterSegmentos)] action in Icon widget.
  ApiCallResponse? apiResult230ss;

  @override
  void initState(BuildContext context) {
    fonteTituloTabelaModel1 =
        createModel(context, () => FonteTituloTabelaModel());
    fonteTituloTabelaModel2 =
        createModel(context, () => FonteTituloTabelaModel());
    fonteDadosTabelaModels1 =
        FlutterFlowDynamicModels(() => FonteDadosTabelaModel());
    fonteDadosTabelaModels2 =
        FlutterFlowDynamicModels(() => FonteDadosTabelaModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    fonteTituloTabelaModel1.dispose();
    fonteTituloTabelaModel2.dispose();
    fonteDadosTabelaModels1.dispose();
    fonteDadosTabelaModels2.dispose();
  }
}
