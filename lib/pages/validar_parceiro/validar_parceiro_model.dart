import '/backend/api_requests/api_calls.dart';
import '/components/menu_mobile/menu_mobile_widget.dart';
import '/components/menu_parceiro/menu_parceiro_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'validar_parceiro_widget.dart' show ValidarParceiroWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ValidarParceiroModel extends FlutterFlowModel<ValidarParceiroWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Menu_Parceiro component.
  late MenuParceiroModel menuParceiroModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Custom Action - formatDecimalInput] action in TextField widget.
  String? formatacao;
  // Stores action output result for [Backend Call - API (validarCupom)] action in Button widget.
  ApiCallResponse? apiResultr69;
  // Model for Menu_Mobile component.
  late MenuMobileModel menuMobileModel;
  // State field(s) for codigo_mobile widget.
  FocusNode? codigoMobileFocusNode;
  TextEditingController? codigoMobileTextController;
  String? Function(BuildContext, String?)? codigoMobileTextControllerValidator;
  // State field(s) for valor_mobile widget.
  FocusNode? valorMobileFocusNode;
  TextEditingController? valorMobileTextController;
  String? Function(BuildContext, String?)? valorMobileTextControllerValidator;
  // Stores action output result for [Custom Action - formatDecimalInput] action in valor_mobile widget.
  String? formatacaoMobile;
  // Stores action output result for [Backend Call - API (validarCupom)] action in Button widget.
  ApiCallResponse? apiResultr699;

  // Lista de descontos ativos do parceiro logado para escolha no caixa
  List<dynamic> partnerDiscounts = [];
  String? selectedDiscountId;
  bool isLoadingDiscounts = false;

  @override
  void initState(BuildContext context) {
    menuParceiroModel = createModel(context, () => MenuParceiroModel());
    menuMobileModel = createModel(context, () => MenuMobileModel());
  }

  @override
  void dispose() {
    menuParceiroModel.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    menuMobileModel.dispose();
    codigoMobileFocusNode?.dispose();
    codigoMobileTextController?.dispose();

    valorMobileFocusNode?.dispose();
    valorMobileTextController?.dispose();
  }
}
