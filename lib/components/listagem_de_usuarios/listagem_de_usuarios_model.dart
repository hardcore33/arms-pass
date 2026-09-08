import '/flutter_flow/flutter_flow_util.dart';
import 'listagem_de_usuarios_widget.dart' show ListagemDeUsuariosWidget;
import 'package:flutter/material.dart';

class ListagemDeUsuariosModel
    extends FlutterFlowModel<ListagemDeUsuariosWidget> {
  ///  Local state fields for this component.

  List<dynamic> usersLocal = [];
  void addToUsersLocal(dynamic item) => usersLocal.add(item);
  void removeFromUsersLocal(dynamic item) => usersLocal.remove(item);
  void removeAtIndexFromUsersLocal(int index) => usersLocal.removeAt(index);
  void insertAtIndexInUsersLocal(int index, dynamic item) =>
      usersLocal.insert(index, item);
  void updateUsersLocalAtIndex(int index, Function(dynamic) updateFn) =>
      usersLocal[index] = updateFn(usersLocal[index]);

  String sortField = '';
  bool sortAscending = true;

  ///  State fields for stateful widgets in this component.

  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  List<dynamic>? usuariosFiltrados;
  bool? resultadoDialog;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
