import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'tabela_desempenho_parceiros_widget.dart' show TabelaDesempenhoParceirosWidget;

class TabelaDesempenhoParceirosModel
    extends FlutterFlowModel<TabelaDesempenhoParceirosWidget> {
  TextEditingController? searchController;
  FocusNode? searchFocusNode;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchController?.dispose();
    searchFocusNode?.dispose();
  }
}
