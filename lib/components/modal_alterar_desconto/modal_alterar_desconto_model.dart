import '/backend/api_requests/api_calls.dart';
import '/components/fonte_titulo_modal/fonte_titulo_modal_widget.dart';
import '/components/modal_adicionar_segmento/modal_adicionar_segmento_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'modal_alterar_desconto_widget.dart' show ModalAlterarDescontoWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalAlterarDescontoModel
    extends FlutterFlowModel<ModalAlterarDescontoWidget> {
  ///  Local state fields for this component.

  bool hasData = false;

  List<String> nomeSegmentos = [];
  void addToNomeSegmentos(String item) => nomeSegmentos.add(item);
  void removeFromNomeSegmentos(String item) => nomeSegmentos.remove(item);
  void removeAtIndexFromNomeSegmentos(int index) =>
      nomeSegmentos.removeAt(index);
  void insertAtIndexInNomeSegmentos(int index, String item) =>
      nomeSegmentos.insert(index, item);
  void updateNomeSegmentosAtIndex(int index, Function(String) updateFn) =>
      nomeSegmentos[index] = updateFn(nomeSegmentos[index]);

  List<String> parceirosfiltrados = [];
  void addToParceirosfiltrados(String item) => parceirosfiltrados.add(item);
  void removeFromParceirosfiltrados(String item) =>
      parceirosfiltrados.remove(item);
  void removeAtIndexFromParceirosfiltrados(int index) =>
      parceirosfiltrados.removeAt(index);
  void insertAtIndexInParceirosfiltrados(int index, String item) =>
      parceirosfiltrados.insert(index, item);
  void updateParceirosfiltradosAtIndex(int index, Function(String) updateFn) =>
      parceirosfiltrados[index] = updateFn(parceirosfiltrados[index]);

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();

  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel1;
  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel2;
  // State field(s) for Descricao widget.
  FocusNode? descricaoFocusNode;
  TextEditingController? descricaoTextController;
  String? Function(BuildContext, String?)? descricaoTextControllerValidator;
  String? _descricaoTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }

    return null;
  }

  // State field(s) for Segmento widget.
  String? segmentoValue;
  FormFieldController<String>? segmentoValueController;
  // Stores action output result for [Custom Action - obterIdDoSegmentoPorNome] action in Segmento widget.
  int? idSegmento;
  // Stores action output result for [Backend Call - API (obterSegmentos)] action in Icon widget.
  ApiCallResponse? apiResult2po;
  // Stores action output result for [Custom Action - obterListaDeSegmentos] action in Icon widget.
  List<String>? segmentosAtualizados;
  // State field(s) for Porcentagem widget.
  FocusNode? porcentagemFocusNode;
  TextEditingController? porcentagemTextController;
  String? Function(BuildContext, String?)? porcentagemTextControllerValidator;
  String? _porcentagemTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo necessário';
    }
    final parsed = double.tryParse(val.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0 || parsed > 100) {
      return 'Informe uma porcentagem entre 1 e 100';
    }

    return null;
  }

  // State field(s) for Parceiro widget.
  String? parceiroValue;
  FormFieldController<String>? parceiroValueController;
  // Stores action output result for [Custom Action - obterIdDoParceiroPorNome] action in Parceiro widget.
  int? idParceiro;
  DateTime? datePicked;
  // Stores action output result for [Backend Call - API (adicionarDesconto)] action in Button widget.
  ApiCallResponse? apiResultEdicao;

  @override
  void initState(BuildContext context) {
    fonteTituloModalModel1 =
        createModel(context, () => FonteTituloModalModel());
    fonteTituloModalModel2 =
        createModel(context, () => FonteTituloModalModel());
    descricaoTextControllerValidator = _descricaoTextControllerValidator;
    porcentagemTextControllerValidator = _porcentagemTextControllerValidator;
  }

  @override
  void dispose() {
    fonteTituloModalModel1.dispose();
    fonteTituloModalModel2.dispose();
    descricaoFocusNode?.dispose();
    descricaoTextController?.dispose();

    porcentagemFocusNode?.dispose();
    porcentagemTextController?.dispose();
  }
}
