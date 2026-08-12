import '/backend/api_requests/api_calls.dart';
import '/components/fonte_dados_tabela/fonte_dados_tabela_widget.dart';
import '/components/fonte_dados_tabela_com_limite/fonte_dados_tabela_com_limite_widget.dart';
import '/components/fonte_titulo_tabela/fonte_titulo_tabela_widget.dart';
import '/components/modal_adicionar_banner/modal_adicionar_banner_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'listagem_de_banners_widget.dart' show ListagemDeBannersWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListagemDeBannersModel extends FlutterFlowModel<ListagemDeBannersWidget> {
  ///  Local state fields for this component.

  List<dynamic> bannersLocal = [];
  void addToBannersLocal(dynamic item) => bannersLocal.add(item);
  void removeFromBannersLocal(dynamic item) => bannersLocal.remove(item);
  void removeAtIndexFromBannersLocal(int index) => bannersLocal.removeAt(index);
  void insertAtIndexInBannersLocal(int index, dynamic item) =>
      bannersLocal.insert(index, item);
  void updateBannersLocalAtIndex(int index, Function(dynamic) updateFn) =>
      bannersLocal[index] = updateFn(bannersLocal[index]);

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - filtrarPorNome] action in TextField widget.
  List<dynamic>? bannersFiltrados;
  // Stores action output result for [Backend Call - API (obterBanners)] action in Button widget.
  ApiCallResponse? apiResultdku;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel1;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel2;
  // Model for Fonte_Titulo_Tabela component.
  late FonteTituloTabelaModel fonteTituloTabelaModel3;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels1;
  // Models for Fonte_Dados_Tabela_Com_Limite dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaComLimiteModel>
      fonteDadosTabelaComLimiteModels;
  // Models for Fonte_Dados_Tabela dynamic component.
  late FlutterFlowDynamicModels<FonteDadosTabelaModel> fonteDadosTabelaModels2;
  // Stores action output result for [Backend Call - API (deletarBanners)] action in Icon widget.
  ApiCallResponse? apiResult8yh;

  @override
  void initState(BuildContext context) {
    fonteTituloTabelaModel1 =
        createModel(context, () => FonteTituloTabelaModel());
    fonteTituloTabelaModel2 =
        createModel(context, () => FonteTituloTabelaModel());
    fonteTituloTabelaModel3 =
        createModel(context, () => FonteTituloTabelaModel());
    fonteDadosTabelaModels1 =
        FlutterFlowDynamicModels(() => FonteDadosTabelaModel());
    fonteDadosTabelaComLimiteModels =
        FlutterFlowDynamicModels(() => FonteDadosTabelaComLimiteModel());
    fonteDadosTabelaModels2 =
        FlutterFlowDynamicModels(() => FonteDadosTabelaModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    fonteTituloTabelaModel1.dispose();
    fonteTituloTabelaModel2.dispose();
    fonteTituloTabelaModel3.dispose();
    fonteDadosTabelaModels1.dispose();
    fonteDadosTabelaComLimiteModels.dispose();
    fonteDadosTabelaModels2.dispose();
  }
}
