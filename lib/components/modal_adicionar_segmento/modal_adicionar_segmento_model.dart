import '/flutter_flow/flutter_flow_util.dart';
import 'modal_adicionar_segmento_widget.dart' show ModalAdicionarSegmentoWidget;
import 'package:flutter/material.dart';

class ModalAdicionarSegmentoModel
    extends FlutterFlowModel<ModalAdicionarSegmentoWidget> {
  ///  Local state fields for this component.

  bool hasUploadedFile = false;
  String? imageUrl;

  ///  State fields for stateful widgets in this component.

  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
