import '/backend/api_requests/api_calls.dart';
import '/components/fonte_titulo_modal/fonte_titulo_modal_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'modal_adicionar_produto_widget.dart' show ModalAdicionarProdutoWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalAdicionarProdutoModel
    extends FlutterFlowModel<ModalAdicionarProdutoWidget> {
  ///  Local state fields for this component.

  bool hasUploadedFile = false;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();

  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel1;
  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel2;
  // State field(s) for name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  String? _nameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }

    return null;
  }

  // State field(s) for cost widget.
  FocusNode? costFocusNode;
  TextEditingController? costTextController;
  String? Function(BuildContext, String?)? costTextControllerValidator;
  String? _costTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }
    if (int.tryParse(val) == null) {
      return 'Informe um número válido';
    }

    return null;
  }

  // State field(s) for Real widget.
  FocusNode? realFocusNode;
  TextEditingController? realTextController;
  String? Function(BuildContext, String?)? realTextControllerValidator;
  String? _realTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }
    if (double.tryParse(val.replaceAll(',', '.')) == null) {
      return 'Informe um valor válido';
    }

    return null;
  }

  // State field(s) for inventory widget.
  FocusNode? inventoryFocusNode;
  TextEditingController? inventoryTextController;
  String? Function(BuildContext, String?)? inventoryTextControllerValidator;
  String? _inventoryTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }
    if (int.tryParse(val) == null) {
      return 'Informe um número válido';
    }

    return null;
  }

  bool isDataUploading_uploadData3m4 = false;
  FFUploadedFile uploadedLocalFile_uploadData3m4 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - uploadPhoto] action in Button widget.
  String? imageUrl;
  // Stores action output result for [Backend Call - API (adicionarProduto)] action in Button widget.
  ApiCallResponse? apiResultswh;

  @override
  void initState(BuildContext context) {
    fonteTituloModalModel1 =
        createModel(context, () => FonteTituloModalModel());
    fonteTituloModalModel2 =
        createModel(context, () => FonteTituloModalModel());
    nameTextControllerValidator = _nameTextControllerValidator;
    costTextControllerValidator = _costTextControllerValidator;
    realTextControllerValidator = _realTextControllerValidator;
    inventoryTextControllerValidator = _inventoryTextControllerValidator;
  }

  @override
  void dispose() {
    fonteTituloModalModel1.dispose();
    fonteTituloModalModel2.dispose();
    nameFocusNode?.dispose();
    nameTextController?.dispose();

    costFocusNode?.dispose();
    costTextController?.dispose();

    realFocusNode?.dispose();
    realTextController?.dispose();

    inventoryFocusNode?.dispose();
    inventoryTextController?.dispose();
  }
}
