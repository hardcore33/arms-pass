import '/components/listagem_de_cupom/listagem_de_cupom_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'cupons_widget.dart' show CuponsWidget;
import 'package:flutter/material.dart';

class CuponsModel extends FlutterFlowModel<CuponsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Menu component.
  late MenuModel menuModel;
  // Model for Listagem_de_Cupom component.
  late ListagemDeCupomModel listagemDeCupomModel;

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
    listagemDeCupomModel = createModel(context, () => ListagemDeCupomModel());
  }

  @override
  void dispose() {
    menuModel.dispose();
    listagemDeCupomModel.dispose();
  }
}
