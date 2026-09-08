import '/flutter_flow/flutter_flow_util.dart';
import 'modal_plano_widget.dart' show ModalPlanoWidget;
import 'package:flutter/material.dart';

class ModalPlanoModel extends FlutterFlowModel<ModalPlanoWidget> {
  final formKey = GlobalKey<FormState>();

  TextEditingController? nomeController;
  FocusNode? nomeFocusNode;

  TextEditingController? valorController;
  FocusNode? valorFocusNode;

  TextEditingController? tagController;
  FocusNode? tagFocusNode;

  TextEditingController? beneficioController;
  FocusNode? beneficioFocusNode;

  String cicloSelecionado = 'Mensal';
  bool statusAtivo = true;
  List<String> beneficios = [];
  List<int> parceirosSelecionados = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomeController?.dispose();
    nomeFocusNode?.dispose();

    valorController?.dispose();
    valorFocusNode?.dispose();

    tagController?.dispose();
    tagFocusNode?.dispose();

    beneficioController?.dispose();
    beneficioFocusNode?.dispose();
  }
}
