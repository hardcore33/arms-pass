import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'modal_de_alterar_customer_widget.dart'
    show ModalDeAlterarCustomerWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ModalDeAlterarCustomerModel
    extends FlutterFlowModel<ModalDeAlterarCustomerWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();

  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;

  FocusNode? identificacaoFocusNode;
  TextEditingController? identificacaoTextController;
  late MaskTextInputFormatter identificacaoMask;

  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;

  // Status Arms Pró
  bool armspassValue = false;

  ApiCallResponse? apiResult005;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();
    identificacaoFocusNode?.dispose();
    identificacaoTextController?.dispose();
    emailFocusNode?.dispose();
    emailTextController?.dispose();
  }
}
