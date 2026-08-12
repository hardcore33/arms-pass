import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'listagem_de_cupons_parceiro_mobile_widget.dart'
    show ListagemDeCuponsParceiroMobileWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListagemDeCuponsParceiroMobileModel
    extends FlutterFlowModel<ListagemDeCuponsParceiroMobileWidget> {
  ///  Local state fields for this component.

  List<dynamic> cuponsLocais = [];
  void addToCuponsLocais(dynamic item) => cuponsLocais.add(item);
  void removeFromCuponsLocais(dynamic item) => cuponsLocais.remove(item);
  void removeAtIndexFromCuponsLocais(int index) => cuponsLocais.removeAt(index);
  void insertAtIndexInCuponsLocais(int index, dynamic item) =>
      cuponsLocais.insert(index, item);
  void updateCuponsLocaisAtIndex(int index, Function(dynamic) updateFn) =>
      cuponsLocais[index] = updateFn(cuponsLocais[index]);

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - filtrarPorNome] action in TextField widget.
  List<dynamic>? usuariosFiltrados;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel1;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel2;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel3;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel4;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels1;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels2;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels3;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels4;

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
    fonteDadosTabelaModels1.dispose();
    fonteDadosTabelaModels2.dispose();
    fonteDadosTabelaModels3.dispose();
    fonteDadosTabelaModels4.dispose();
  }
}
