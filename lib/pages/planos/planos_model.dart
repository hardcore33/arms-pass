import '/components/menu/menu_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'planos_widget.dart' show PlanosWidget;
import 'package:flutter/material.dart';

class PlanosModel extends FlutterFlowModel<PlanosWidget> {
  late MenuModel menuModel;

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
  }

  @override
  void dispose() {
    menuModel.dispose();
  }
}
