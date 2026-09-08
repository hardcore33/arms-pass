import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'modal_adicionar_desconto_widget.dart' show ModalAdicionarDescontoWidget;
import 'package:flutter/material.dart';

class ModalAdicionarDescontoModel
    extends FlutterFlowModel<ModalAdicionarDescontoWidget> {
  ///  Local state fields for this component.

  bool hasData = false;
  List<String> nomeSegmentos = [];
  List<String> parceirosfiltrados = [];

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();

  FocusNode? descricaoFocusNode;
  TextEditingController? descricaoTextController;

  FocusNode? regrasFocusNode;
  TextEditingController? regrasTextController;

  String? segmentoValue;
  int? idSegmento;
  ApiCallResponse? apiResult2po;
  List<String>? segmentosAtualizados;

  FocusNode? porcentagemFocusNode;
  TextEditingController? porcentagemTextController;

  // Arms Pró & Limite
  bool isArmsPro = false;
  FocusNode? limiteQuantidadeFocusNode;
  TextEditingController? limiteQuantidadeTextController;

  String? parceiroValue;
  int? idParceiro;
  DateTime? datePicked;
  ApiCallResponse? apiResulthtv;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    descricaoFocusNode?.dispose();
    descricaoTextController?.dispose();
    regrasFocusNode?.dispose();
    regrasTextController?.dispose();
    porcentagemFocusNode?.dispose();
    porcentagemTextController?.dispose();
    limiteQuantidadeFocusNode?.dispose();
    limiteQuantidadeTextController?.dispose();
  }
}
