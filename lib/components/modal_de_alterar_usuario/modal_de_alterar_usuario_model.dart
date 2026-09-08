import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'modal_de_alterar_usuario_widget.dart' show ModalDeAlterarUsuarioWidget;
import 'package:flutter/material.dart';

class ModalDeAlterarUsuarioModel
    extends FlutterFlowModel<ModalDeAlterarUsuarioWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();

  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;

  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;

  ApiCallResponse? apiResult004;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();
    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
