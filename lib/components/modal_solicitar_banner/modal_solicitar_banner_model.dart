import '/flutter_flow/flutter_flow_util.dart';
import 'modal_solicitar_banner_widget.dart' show ModalSolicitarBannerWidget;
import 'package:flutter/material.dart';

class ModalSolicitarBannerModel extends FlutterFlowModel<ModalSolicitarBannerWidget> {
  final formKey = GlobalKey<FormState>();

  // State fields for stateful widgets in this component.
  FocusNode? urlFocusNode;
  TextEditingController? urlTextController;
  String? Function(BuildContext, String?)? urlTextControllerValidator;

  @override
  void initState(BuildContext context) {
    urlTextControllerValidator = (context, val) {
      if (val == null || val.isEmpty) {
        return 'Link de redirecionamento obrigatório';
      }
      if (!val.startsWith('http://') && !val.startsWith('https://')) {
        return 'Insira uma URL válida (http:// ou https://)';
      }
      return null;
    };
  }

  @override
  void dispose() {
    urlFocusNode?.dispose();
    urlTextController?.dispose();
  }
}
