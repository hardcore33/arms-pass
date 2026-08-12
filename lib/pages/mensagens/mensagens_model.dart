import '/backend/api_requests/api_calls.dart';
import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'mensagens_widget.dart' show MensagensWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MensagensModel extends FlutterFlowModel<MensagensWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();

  // Model for Menu component.
  late MenuModel menuModel;
  // State field(s) for EnviadoPor widget.
  FocusNode? enviadoPorFocusNode;
  TextEditingController? enviadoPorTextController;
  String? Function(BuildContext, String?)? enviadoPorTextControllerValidator;
  String? _enviadoPorTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }

    return null;
  }

  // State field(s) for Titulo widget.
  FocusNode? tituloFocusNode;
  TextEditingController? tituloTextController;
  String? Function(BuildContext, String?)? tituloTextControllerValidator;
  String? _tituloTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }

    return null;
  }

  // State field(s) for Url widget.
  FocusNode? urlFocusNode;
  TextEditingController? urlTextController;
  String? Function(BuildContext, String?)? urlTextControllerValidator;
  // State field(s) for Mensagem widget.
  FocusNode? mensagemFocusNode;
  TextEditingController? mensagemTextController;
  String? Function(BuildContext, String?)? mensagemTextControllerValidator;
  String? _mensagemTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }

    return null;
  }

  // Stores action output result for [Backend Call - API (enviarNotificacao)] action in Button widget.
  ApiCallResponse? apiResulti0l;

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
    enviadoPorTextControllerValidator = _enviadoPorTextControllerValidator;
    tituloTextControllerValidator = _tituloTextControllerValidator;
    mensagemTextControllerValidator = _mensagemTextControllerValidator;
  }

  @override
  void dispose() {
    menuModel.dispose();
    enviadoPorFocusNode?.dispose();
    enviadoPorTextController?.dispose();

    tituloFocusNode?.dispose();
    tituloTextController?.dispose();

    urlFocusNode?.dispose();
    urlTextController?.dispose();

    mensagemFocusNode?.dispose();
    mensagemTextController?.dispose();
  }
}
