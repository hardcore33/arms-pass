import '/backend/api_requests/api_calls.dart';
import '/components/fonte_titulo_modal/fonte_titulo_modal_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'modal_de_alterar_usuario_widget.dart' show ModalDeAlterarUsuarioWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalDeAlterarUsuarioModel
    extends FlutterFlowModel<ModalDeAlterarUsuarioWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();

  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel1;
  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  late bool senhaVisibility;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }

    return null;
  }

  // Stores action output result for [Backend Call - API (atualizarDados)] action in Button widget.
  ApiCallResponse? apiResult004;

  @override
  void initState(BuildContext context) {
    fonteTituloModalModel1 =
        createModel(context, () => FonteTituloModalModel());
    fonteTituloModalModel2 =
        createModel(context, () => FonteTituloModalModel());
    textController1Validator = _textController1Validator;
    senhaVisibility = false;
    textController2Validator = _textController2Validator;
  }

  @override
  void dispose() {
    fonteTituloModalModel1.dispose();
    fonteTituloModalModel2.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
