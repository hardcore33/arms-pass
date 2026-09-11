import '/flutter_flow/flutter_flow_util.dart';
import 'modal_adicionar_desconto_parceiro_widget.dart' show ModalAdicionarDescontoParceiroWidget;
import 'package:flutter/material.dart';

class ModalAdicionarDescontoParceiroModel extends FlutterFlowModel<ModalAdicionarDescontoParceiroWidget> {
  final formKey = GlobalKey<FormState>();
  
  // State fields for stateful widgets in this component.
  FocusNode? descricaoFocusNode;
  TextEditingController? descricaoTextController;
  String? Function(BuildContext, String?)? descricaoTextControllerValidator;

  FocusNode? porcentagemFocusNode;
  TextEditingController? porcentagemTextController;
  String? Function(BuildContext, String?)? porcentagemTextControllerValidator;

  // Arms Pro & Limite de Quantidade
  bool isArmsPro = false;

  FocusNode? limiteQuantidadeFocusNode;
  TextEditingController? limiteQuantidadeTextController;

  FocusNode? regrasFocusNode;
  TextEditingController? regrasTextController;

  // State to store selected date
  DateTime? dataSelecionada;
  
  @override
  void initState(BuildContext context) {
    descricaoTextControllerValidator = (context, val) {
      if (val == null || val.isEmpty) {
        return 'Descrição obrigatória';
      }
      return null;
    };
    porcentagemTextControllerValidator = (context, val) {
      if (val == null || val.isEmpty) {
        return 'Desconto obrigatório';
      }
      final numVal = int.tryParse(val);
      if (numVal == null || numVal < 0 || numVal > 100) {
        return 'Valor entre 0 e 100';
      }
      return null;
    };
  }

  @override
  void dispose() {
    descricaoFocusNode?.dispose();
    descricaoTextController?.dispose();
    porcentagemFocusNode?.dispose();
    porcentagemTextController?.dispose();
    limiteQuantidadeFocusNode?.dispose();
    limiteQuantidadeTextController?.dispose();
    regrasFocusNode?.dispose();
    regrasTextController?.dispose();
  }
}
