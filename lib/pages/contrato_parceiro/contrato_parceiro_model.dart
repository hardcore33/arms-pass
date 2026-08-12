import '/components/menu_mobile/menu_mobile_widget.dart';
import '/components/menu_parceiro/menu_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'contrato_parceiro_widget.dart' show ContratoParceiroWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ContratoParceiroModel extends FlutterFlowModel<ContratoParceiroWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Menu_Parceiro component.
  late MenuParceiroModel menuParceiroModel;
  // Model for Menu_Mobile component.
  late MenuMobileModel menuMobileModel;

  @override
  void initState(BuildContext context) {
    menuParceiroModel = createModel(context, () => MenuParceiroModel());
    menuMobileModel = createModel(context, () => MenuMobileModel());
  }

  @override
  void dispose() {
    menuParceiroModel.dispose();
    menuMobileModel.dispose();
  }
}
