import '/backend/api_requests/api_calls.dart';
import '/components/fonte_titulo_modal/fonte_titulo_modal_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'modal_alterar_segmento_widget.dart' show ModalAlterarSegmentoWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalAlterarSegmentoModel
    extends FlutterFlowModel<ModalAlterarSegmentoWidget> {
  ///  Local state fields for this component.

  bool hasUploadedFile = false;

  String? imagemurl;

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

  bool isDataUploading_uploadData3m = false;
  FFUploadedFile uploadedLocalFile_uploadData3m =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - uploadPhoto] action in Button widget.
  String? imageUrl;
  // Stores action output result for [Backend Call - API (editarSegmento)] action in Button widget.
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
