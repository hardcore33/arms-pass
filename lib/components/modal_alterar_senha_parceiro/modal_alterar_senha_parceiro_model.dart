import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'modal_alterar_senha_parceiro_widget.dart' show ModalAlterarSenhaParceiroWidget;

class ModalAlterarSenhaParceiroModel extends FlutterFlowModel<ModalAlterarSenhaParceiroWidget> {
  FocusNode? senhaFocusNode;
  TextEditingController? senhaTextController;
  late bool senhaVisibility;

  FocusNode? confirmSenhaFocusNode;
  TextEditingController? confirmSenhaTextController;
  late bool confirmSenhaVisibility;

  @override
  void initState(BuildContext context) {
    senhaVisibility = false;
    confirmSenhaVisibility = false;
  }

  @override
  void dispose() {
    senhaFocusNode?.dispose();
    senhaTextController?.dispose();
    confirmSenhaFocusNode?.dispose();
    confirmSenhaTextController?.dispose();
  }
}
