import '/backend/api_requests/api_calls.dart';
import '/components/fonte_titulo_modal/fonte_titulo_modal_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'modal_alterar_produto_widget.dart' show ModalAlterarProdutoWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalAlterarProdutoModel
    extends FlutterFlowModel<ModalAlterarProdutoWidget> {
  ///  Local state fields for this component.

  bool hasUploadedFile = false;

  bool hasUploadedPhoto = false;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();

  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel1;
  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel2;
  // State field(s) for TextField widget. (Nome)
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }

    return null;
  }

  // State field(s) for TextField widget. (Valor em pontos)
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }
    if (int.tryParse(val) == null) {
      return 'Informe um número válido';
    }

    return null;
  }

  // Stores action output result for [Custom Action - formatDecimalInput] action in TextField widget.
  String? teste;
  // State field(s) for reais widget. (Valor em reais)
  FocusNode? reaisFocusNode;
  TextEditingController? reaisTextController;
  String? Function(BuildContext, String?)? reaisTextControllerValidator;
  String? _reaisTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }
    if (double.tryParse(val.replaceAll(',', '.')) == null) {
      return 'Informe um valor válido';
    }

    return null;
  }

  // Stores action output result for [Custom Action - formatDecimalInput] action in reais widget.
  String? reaisl;
  // State field(s) for TextField widget. (Estoque)
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  String? _textController4Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }
    if (int.tryParse(val) == null) {
      return 'Informe um número válido';
    }

    return null;
  }

  bool isDataUploading_uploadData3m7 = false;
  FFUploadedFile uploadedLocalFile_uploadData3m7 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - uploadPhoto] action in Button widget.
  String? imageUrl;
  // Stores action output result for [Backend Call - API (atualizarProduto)] action in Button widget.
  ApiCallResponse? apiResult82y;

  @override
  void initState(BuildContext context) {
    fonteTituloModalModel1 =
        createModel(context, () => FonteTituloModalModel());
    fonteTituloModalModel2 =
        createModel(context, () => FonteTituloModalModel());
    textController1Validator = _textController1Validator;
    textController2Validator = _textController2Validator;
    reaisTextControllerValidator = _reaisTextControllerValidator;
    textController4Validator = _textController4Validator;
  }

  @override
  void dispose() {
    fonteTituloModalModel1.dispose();
    fonteTituloModalModel2.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    reaisFocusNode?.dispose();
    reaisTextController?.dispose();

    textFieldFocusNode3?.dispose();
    textController4?.dispose();
  }
}
