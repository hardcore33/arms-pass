import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/components/modal_adicionar_parceiro/modal_adicionar_parceiro_widget.dart';
import '/components/modal_editar_parceiro/modal_editar_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'listagem_de_parceiros_widget.dart' show ListagemDeParceirosWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListagemDeParceirosModel
    extends FlutterFlowModel<ListagemDeParceirosWidget> {
  ///  Local state fields for this component.

  List<dynamic> parceirosLocal = [];
  void addToParceirosLocal(dynamic item) => parceirosLocal.add(item);
  void removeFromParceirosLocal(dynamic item) => parceirosLocal.remove(item);
  void removeAtIndexFromParceirosLocal(int index) =>
      parceirosLocal.removeAt(index);
  void insertAtIndexInParceirosLocal(int index, dynamic item) =>
      parceirosLocal.insert(index, item);
  void updateParceirosLocalAtIndex(int index, Function(dynamic) updateFn) =>
      parceirosLocal[index] = updateFn(parceirosLocal[index]);

  // Campo usado para ordenar a lista ('' = alfabética por nome fantasia).
  String sortField = '';
  bool sortAscending = true;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - filtrarPorAtividade] action in TextField widget.
  List<dynamic>? primeiraValidacao;
  // Stores action output result for [Custom Action - filtrarPorNome] action in TextField widget.
  List<dynamic>? parceirosFiltrados;
  // State field(s) for Switch widget.
  bool? switchValue;
  // Stores action output result for [Custom Action - filtrarPorAtividade] action in Switch widget.
  List<dynamic>? parceirosFiltradosPorAtividade;
  // Stores action output result for [Custom Action - filtrarPorAtividade] action in Switch widget.
  List<dynamic>? parceirosFiltradosPorAtividadeOff;
  // Stores action output result for [Backend Call - API (obterSegmentos)] action in Button widget.
  ApiCallResponse? segmentos;
  // Stores action output result for [Custom Action - obterListaDeSegmentos] action in Button widget.
  List<String>? nomeDeSegmentos;
  // Stores action output result for [Backend Call - API (obterUsuarios)] action in Button widget.
  ApiCallResponse? apiResultl4kl;
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
  // Stores action output result for [Backend Call - API (obterSegmentos)] action in Icon widget.
  ApiCallResponse? segmentosEditar;
  // Stores action output result for [Custom Action - obterListaDeSegmentos] action in Icon widget.
  List<String>? nomeDeSegmentosEditar;
  // Stores action output result for [Backend Call - API (obterUsuarios)] action in Icon widget.
  ApiCallResponse? apiResultl4k;
  // Stores action output result for [Backend Call - API (deletarParceiro)] action in Icon widget.
  ApiCallResponse? apiResulttxp;
  // Stores action output result for [Backend Call - API (obterUsuarios)] action in Icon widget.
  ApiCallResponse? inativandoParceiro;

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
  }
}
