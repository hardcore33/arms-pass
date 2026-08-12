import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_segmentos/listagem_de_segmentos_widget.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'segmentos_widget.dart' show SegmentosWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SegmentosModel extends FlutterFlowModel<SegmentosWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Menu component.
  late MenuModel menuModel;
  // Model for Listagem_de_segmentos component.
  late ListagemDeSegmentosModel listagemDeSegmentosModel;

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
    listagemDeSegmentosModel =
        createModel(context, () => ListagemDeSegmentosModel());
  }

  @override
  void dispose() {
    menuModel.dispose();
    listagemDeSegmentosModel.dispose();
  }
}
