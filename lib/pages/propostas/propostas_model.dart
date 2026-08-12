import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_propostas/listagem_de_propostas_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'propostas_widget.dart' show PropostasWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PropostasModel extends FlutterFlowModel<PropostasWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Menu component.
  late MenuModel menuModel;
  // Model for Listagem_de_Propostas component.
  late ListagemDePropostasModel listagemDePropostasModel;

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
    listagemDePropostasModel =
        createModel(context, () => ListagemDePropostasModel());
  }

  @override
  void dispose() {
    menuModel.dispose();
    listagemDePropostasModel.dispose();
  }
}
