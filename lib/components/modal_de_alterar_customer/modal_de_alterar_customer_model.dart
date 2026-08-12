import '/backend/api_requests/api_calls.dart';
import '/components/fonte_titulo_modal/fonte_titulo_modal_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'modal_de_alterar_customer_widget.dart'
    show ModalDeAlterarCustomerWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ModalDeAlterarCustomerModel
    extends FlutterFlowModel<ModalDeAlterarCustomerWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel;
  // State field(s) for Nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;
  String? _nomeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  // State field(s) for Identificacao widget.
  FocusNode? identificacaoFocusNode;
  TextEditingController? identificacaoTextController;
  late MaskTextInputFormatter identificacaoMask;
  String? Function(BuildContext, String?)? identificacaoTextControllerValidator;
  String? _identificacaoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  // State field(s) for Email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo obrigatório';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'E-mail inválido';
    }
    return null;
  }

  // Stores action output result for [Backend Call - API (editarCustomer)] action in Button widget.
  ApiCallResponse? apiResult005;

  @override
  void initState(BuildContext context) {
    fonteTituloModalModel = createModel(context, () => FonteTituloModalModel());
    nomeTextControllerValidator = _nomeTextControllerValidator;
    identificacaoTextControllerValidator =
        _identificacaoTextControllerValidator;
    emailTextControllerValidator = _emailTextControllerValidator;
  }

  @override
  void dispose() {
    fonteTituloModalModel.dispose();
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    identificacaoFocusNode?.dispose();
    identificacaoTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();
  }
}
