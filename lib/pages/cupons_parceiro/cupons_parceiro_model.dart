import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/listagem_de_cupons_parceiro/listagem_de_cupons_parceiro_widget.dart';
import '/components/menu_mobile/menu_mobile_widget.dart';
import '/components/menu_parceiro/menu_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'cupons_parceiro_widget.dart' show CuponsParceiroWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CuponsParceiroModel extends FlutterFlowModel<CuponsParceiroWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Menu_Parceiro component.
  late MenuParceiroModel menuParceiroModel;
  // Model for Listagem_de_Cupons_Parceiro component.
  late ListagemDeCuponsParceiroModel listagemDeCuponsParceiroModel;
  // Model for Menu_Mobile component.
  late MenuMobileModel menuMobileModel;

  @override
  void initState(BuildContext context) {
    menuParceiroModel = createModel(context, () => MenuParceiroModel());
    listagemDeCuponsParceiroModel =
        createModel(context, () => ListagemDeCuponsParceiroModel());
    menuMobileModel = createModel(context, () => MenuMobileModel());
  }

  @override
  void dispose() {
    menuParceiroModel.dispose();
    listagemDeCuponsParceiroModel.dispose();
    menuMobileModel.dispose();
  }
}
