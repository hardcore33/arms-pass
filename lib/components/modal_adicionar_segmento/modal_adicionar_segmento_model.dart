import '/backend/api_requests/api_calls.dart';
import '/components/fonte_titulo_modal/fonte_titulo_modal_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'modal_adicionar_segmento_widget.dart' show ModalAdicionarSegmentoWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalAdicionarSegmentoModel
    extends FlutterFlowModel<ModalAdicionarSegmentoWidget> {
  ///  Local state fields for this component.

  bool hasUploadedFile = false;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();

  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  String? _textControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }

    return null;
  }

  bool isDataUploading_uploadData3m9 = false;
  FFUploadedFile uploadedLocalFile_uploadData3m9 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - uploadPhoto] action in Button widget.
  String? imageUrl;
  // Stores action output result for [Backend Call - API (adicionarSegmento)] action in Button widget.
  ApiCallResponse? apiResultdcr;

  @override
  void initState(BuildContext context) {
    fonteTituloModalModel = createModel(context, () => FonteTituloModalModel());
    textControllerValidator = _textControllerValidator;
  }

  @override
  void dispose() {
    fonteTituloModalModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
