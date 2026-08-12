import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/components/modal_adicionar_desconto/modal_adicionar_desconto_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'listagem_de_cupom_widget.dart' show ListagemDeCupomWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListagemDeCupomModel extends FlutterFlowModel<ListagemDeCupomWidget> {
  ///  Local state fields for this component.

  List<dynamic> cuponsLocal = [];
  void addToCuponsLocal(dynamic item) => cuponsLocal.add(item);
  void removeFromCuponsLocal(dynamic item) => cuponsLocal.remove(item);
  void removeAtIndexFromCuponsLocal(int index) => cuponsLocal.removeAt(index);
  void insertAtIndexInCuponsLocal(int index, dynamic item) =>
      cuponsLocal.insert(index, item);
  void updateCuponsLocalAtIndex(int index, Function(dynamic) updateFn) =>
      cuponsLocal[index] = updateFn(cuponsLocal[index]);

  // Filtro por segmento (null = todos os segmentos).
  String? segmentoFiltro;
  // Campo usado para ordenar a lista ('' = ordem original da API).
  String sortField = '';
  bool sortAscending = true;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - filtrarPorNome] action in TextField widget.
  List<dynamic>? cuponsFiltrados;
  // Stores action output result for [Backend Call - API (obterParceiros)] action in Button widget.
  ApiCallResponse? listaParceiros;
  // Stores action output result for [Custom Action - obterListaDeParceiros] action in Button widget.
  List<String>? listaDeNomesDeParceiros;
  // Stores action output result for [Backend Call - API (obterSegmentos)] action in Button widget.
  ApiCallResponse? segmentos;
  // Stores action output result for [Custom Action - obterListaDeSegmentos] action in Button widget.
  List<String>? listaDeNomesDeSegmentos;
  // Stores action output result for [Backend Call - API (obterCupons)] action in Button widget.
  ApiCallResponse? apiResult1bg;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel1;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel2;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel3;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel4;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel5;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels1;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels2;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels3;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels4;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels5;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels6;
  // Stores action output result for [Backend Call - API (deletarCupons)] action in Icon widget.
  ApiCallResponse? apiResult8yh;

  @override
  void initState(BuildContext context) {
    fonteTituloTabelaModel1 =
        createModel(context, () => FonteTituloTabelaModel());
    fonteTituloTabelaModel2 =
        createModel(context, () => FonteTituloTabelaModel());
    fonteTituloTabelaModel3 =
        createModel(context, () => FonteTituloTabelaModel());
    fonteTituloTabelaModel4 =
        createModel(context, () => FonteTituloTabelaModel());
    fonteTituloTabelaModel5 =
        createModel(context, () => FonteTituloTabelaModel());
    fonteDadosTabelaModels1 =
        FlutterFlowDynamicModels(() => FonteDadosTabelaModel());
    fonteDadosTabelaModels2 =
        FlutterFlowDynamicModels(() => FonteDadosTabelaModel());
    fonteDadosTabelaModels3 =
        FlutterFlowDynamicModels(() => FonteDadosTabelaModel());
    fonteDadosTabelaModels4 =
        FlutterFlowDynamicModels(() => FonteDadosTabelaModel());
    fonteDadosTabelaModels5 =
        FlutterFlowDynamicModels(() => FonteDadosTabelaModel());
    fonteDadosTabelaModels6 =
        FlutterFlowDynamicModels(() => FonteDadosTabelaModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    fonteTituloTabelaModel1.dispose();
    fonteTituloTabelaModel2.dispose();
    fonteTituloTabelaModel3.dispose();
    fonteTituloTabelaModel4.dispose();
    fonteTituloTabelaModel5.dispose();
    fonteDadosTabelaModels1.dispose();
    fonteDadosTabelaModels2.dispose();
    fonteDadosTabelaModels3.dispose();
    fonteDadosTabelaModels4.dispose();
    fonteDadosTabelaModels5.dispose();
    fonteDadosTabelaModels6.dispose();
  }
}
