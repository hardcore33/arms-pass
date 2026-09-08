import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'listagem_de_cupom_widget.dart' show ListagemDeCupomWidget;
import 'package:flutter/material.dart';

class ListagemDeCupomModel extends FlutterFlowModel<ListagemDeCupomWidget> {
  ///  Local state fields for this component.

  List<dynamic> cuponsLocal = [];
  void addToCuponsLocal(dynamic item) => cuponsLocal.add(item);
  void removeFromCuponsLocal(dynamic item) => cuponsLocal.remove(item);
  void removeAtIndexFromCuponsLocal(int index) => cuponsLocal.removeAt(index);
  void insertAtIndexInCuponsLocal(int index, dynamic item) =>
      cuponsLocal.insert(index, item);
  void updateCuponsLocalAtIndex(int index, Function(dynamic) updateFn) =>
      cuponsLocal[index] = updateFn(cuponsLocal[index]);

  String? segmentoFiltro;
  String sortField = '';
  bool sortAscending = true;

  ///  State fields for stateful widgets in this component.

  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  ApiCallResponse? listaParceiros;
  List<String>? listaDeNomesDeParceiros;
  ApiCallResponse? segmentos;
  List<String>? listaDeNomesDeSegmentos;
  ApiCallResponse? apiResult1bg;
  ApiCallResponse? apiResult8yh;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
