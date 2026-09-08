import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'listagem_de_parceiros_widget.dart' show ListagemDeParceirosWidget;
import 'package:flutter/material.dart';

class ListagemDeParceirosModel
    extends FlutterFlowModel<ListagemDeParceirosWidget> {
  ///  Local state fields for this component.

  List<dynamic> parceirosLocal = [];
  void addToParceirosLocal(dynamic item) => parceirosLocal.add(item);
  void removeFromParceirosLocal(dynamic item) => parceirosLocal.remove(item);
  void removeAtIndexFromParceirosLocal(int index) =>
      parceirosLocal.removeAt(index);
  void insertAtIndexInParceirosLocal(int index, dynamic item) =>
      parceirosLocal.insert(index, item);
  void updateParceirosLocalAtIndex(int index, Function(dynamic) updateFn) =>
      parceirosLocal[index] = updateFn(parceirosLocal[index]);

  String sortField = '';
  bool sortAscending = true;

  ///  State fields for stateful widgets in this component.

  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  bool? switchValue;
  ApiCallResponse? segmentos;
  List<String>? nomeDeSegmentos;
  ApiCallResponse? apiResultl4kl;
  ApiCallResponse? segmentosEditar;
  List<String>? nomeDeSegmentosEditar;
  ApiCallResponse? apiResultl4k;
  ApiCallResponse? apiResulttxp;
  ApiCallResponse? inativandoParceiro;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
