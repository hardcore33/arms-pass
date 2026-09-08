import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'assinaturas_widget.dart' show AssinaturasWidget;
import 'package:flutter/material.dart';

class AssinaturasModel extends FlutterFlowModel<AssinaturasWidget> {
  late MenuModel menuModel;

  TextEditingController? searchController;
  FocusNode? searchFocusNode;

  String statusFilter = 'Todos';
  String planFilter = 'Todos';

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    menuModel.dispose();
    searchController?.dispose();
    searchFocusNode?.dispose();
  }
}
