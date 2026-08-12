import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_produtos/listagem_de_produtos_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'produtos_widget.dart' show ProdutosWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProdutosModel extends FlutterFlowModel<ProdutosWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Menu component.
  late MenuModel menuModel;
  // Model for Listagem_de_Produtos component.
  late ListagemDeProdutosModel listagemDeProdutosModel;

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
    listagemDeProdutosModel =
        createModel(context, () => ListagemDeProdutosModel());
  }

  @override
  void dispose() {
    menuModel.dispose();
    listagemDeProdutosModel.dispose();
  }
}
