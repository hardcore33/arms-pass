import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_parceiros/listagem_de_parceiros_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'parceiros_widget.dart' show ParceirosWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ParceirosModel extends FlutterFlowModel<ParceirosWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Menu component.
  late MenuModel menuModel;
  // Model for Listagem_de_Parceiros component.
  late ListagemDeParceirosModel listagemDeParceirosModel;

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
    listagemDeParceirosModel =
        createModel(context, () => ListagemDeParceirosModel());
  }

  @override
  void dispose() {
    menuModel.dispose();
    listagemDeParceirosModel.dispose();
  }
}
