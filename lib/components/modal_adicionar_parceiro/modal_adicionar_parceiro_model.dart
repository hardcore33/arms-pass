import '/backend/api_requests/api_calls.dart';
import '/components/fonte_titulo_modal/fonte_titulo_modal_widget.dart';
import '/components/modal_adicionar_segmento/modal_adicionar_segmento_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'modal_adicionar_parceiro_widget.dart' show ModalAdicionarParceiroWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ModalAdicionarParceiroModel
    extends FlutterFlowModel<ModalAdicionarParceiroWidget> {
  ///  Local state fields for this component.

  bool hasUploadedFile = false;

  List<String> nomeDeSegmentos = [];
  void addToNomeDeSegmentos(String item) => nomeDeSegmentos.add(item);
  void removeFromNomeDeSegmentos(String item) => nomeDeSegmentos.remove(item);
  void removeAtIndexFromNomeDeSegmentos(int index) =>
      nomeDeSegmentos.removeAt(index);
  void insertAtIndexInNomeDeSegmentos(int index, String item) =>
      nomeDeSegmentos.insert(index, item);
  void updateNomeDeSegmentosAtIndex(int index, Function(String) updateFn) =>
      nomeDeSegmentos[index] = updateFn(nomeDeSegmentos[index]);

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel1;
  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel2;
  // State field(s) for Switch widget.
  bool? switchValue;
  // State field(s) for cnpj widget.
  FocusNode? cnpjFocusNode;
  TextEditingController? cnpjTextController;
  late MaskTextInputFormatter cnpjMask;
  String? Function(BuildContext, String?)? cnpjTextControllerValidator;
  String? _cnpjTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for Segmento widget.
  String? segmentoValue;
  FormFieldController<String>? segmentoValueController;
  // Stores action output result for [Custom Action - obterIdDoSegmentoPorNome] action in Segmento widget.
  int? idSegmento;
  // Stores action output result for [Backend Call - API (obterSegmentos)] action in Icon widget.
  ApiCallResponse? apiResult230s;
  // Stores action output result for [Custom Action - obterListaDeSegmentos] action in Icon widget.
  List<String>? segmentosAtualizados;
  // State field(s) for nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;
  String? _nomeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for razao widget.
  FocusNode? razaoFocusNode;
  TextEditingController? razaoTextController;
  String? Function(BuildContext, String?)? razaoTextControllerValidator;
  String? _razaoTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for bairro widget.
  FocusNode? bairroFocusNode;
  TextEditingController? bairroTextController;
  String? Function(BuildContext, String?)? bairroTextControllerValidator;
  String? _bairroTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for cep widget.
  FocusNode? cepFocusNode;
  TextEditingController? cepTextController;
  late MaskTextInputFormatter cepMask;
  String? Function(BuildContext, String?)? cepTextControllerValidator;
  String? _cepTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for end widget.
  FocusNode? endFocusNode;
  TextEditingController? endTextController;
  String? Function(BuildContext, String?)? endTextControllerValidator;
  String? _endTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for num widget.
  FocusNode? numFocusNode;
  TextEditingController? numTextController;
  String? Function(BuildContext, String?)? numTextControllerValidator;
  String? _numTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for cidade widget.
  FocusNode? cidadeFocusNode;
  TextEditingController? cidadeTextController;
  String? Function(BuildContext, String?)? cidadeTextControllerValidator;
  String? _cidadeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for estado widget.
  String? estadoValue;
  FormFieldController<String>? estadoValueController;
  // State field(s) for fone widget.
  FocusNode? foneFocusNode;
  TextEditingController? foneTextController;
  late MaskTextInputFormatter foneMask;
  String? Function(BuildContext, String?)? foneTextControllerValidator;
  String? _foneTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for Instagram widget.
  FocusNode? instagramFocusNode;
  TextEditingController? instagramTextController;
  String? Function(BuildContext, String?)? instagramTextControllerValidator;
  bool isDataUploading_uploadData3m3 = false;
  FFUploadedFile uploadedLocalFile_uploadData3m3 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - uploadPhoto] action in Button widget.
  String? imageUrl;
  // State field(s) for nome_rep widget.
  FocusNode? nomeRepFocusNode;
  TextEditingController? nomeRepTextController;
  String? Function(BuildContext, String?)? nomeRepTextControllerValidator;
  String? _nomeRepTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for rg_rep widget.
  FocusNode? rgRepFocusNode;
  TextEditingController? rgRepTextController;
  late MaskTextInputFormatter rgRepMask;
  String? Function(BuildContext, String?)? rgRepTextControllerValidator;
  String? _rgRepTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for cpf_rep widget.
  FocusNode? cpfRepFocusNode;
  TextEditingController? cpfRepTextController;
  late MaskTextInputFormatter cpfRepMask;
  String? Function(BuildContext, String?)? cpfRepTextControllerValidator;
  String? _cpfRepTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for fone_rep widget.
  FocusNode? foneRepFocusNode;
  TextEditingController? foneRepTextController;
  late MaskTextInputFormatter foneRepMask;
  String? Function(BuildContext, String?)? foneRepTextControllerValidator;
  String? _foneRepTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for mail_rep widget.
  FocusNode? mailRepFocusNode;
  TextEditingController? mailRepTextController;
  String? Function(BuildContext, String?)? mailRepTextControllerValidator;
  String? _mailRepTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for password_rep widget.
  FocusNode? passwordRepFocusNode;
  TextEditingController? passwordRepTextController;
  String? Function(BuildContext, String?)? passwordRepTextControllerValidator;
  String? _passwordRepTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  bool isDataUploading_uploadDataFt7 = false;
  FFUploadedFile uploadedLocalFile_uploadDataFt7 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - uploadPhoto] action in Button widget.
  String? fileUrl;
  // Stores action output result for [Backend Call - API (criarParceiro)] action in Button widget.
  ApiCallResponse? apiResult88s;
  // Stores action output result for [Backend Call - API (atualizarParceiro)] action in Button widget.
  ApiCallResponse? atualizarParceiro;

  @override
  void initState(BuildContext context) {
    fonteTituloModalModel1 =
        createModel(context, () => FonteTituloModalModel());
    fonteTituloModalModel2 =
        createModel(context, () => FonteTituloModalModel());
    cnpjTextControllerValidator = _cnpjTextControllerValidator;
    nomeTextControllerValidator = _nomeTextControllerValidator;
    razaoTextControllerValidator = _razaoTextControllerValidator;
    bairroTextControllerValidator = _bairroTextControllerValidator;
    cepTextControllerValidator = _cepTextControllerValidator;
    endTextControllerValidator = _endTextControllerValidator;
    numTextControllerValidator = _numTextControllerValidator;
    cidadeTextControllerValidator = _cidadeTextControllerValidator;
    foneTextControllerValidator = _foneTextControllerValidator;
    emailTextControllerValidator = _emailTextControllerValidator;
    nomeRepTextControllerValidator = _nomeRepTextControllerValidator;
    rgRepTextControllerValidator = _rgRepTextControllerValidator;
    cpfRepTextControllerValidator = _cpfRepTextControllerValidator;
    foneRepTextControllerValidator = _foneRepTextControllerValidator;
    mailRepTextControllerValidator = _mailRepTextControllerValidator;
    passwordRepTextControllerValidator = _passwordRepTextControllerValidator;
  }

  @override
  void dispose() {
    fonteTituloModalModel1.dispose();
    fonteTituloModalModel2.dispose();
    cnpjFocusNode?.dispose();
    cnpjTextController?.dispose();

    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    razaoFocusNode?.dispose();
    razaoTextController?.dispose();

    bairroFocusNode?.dispose();
    bairroTextController?.dispose();

    cepFocusNode?.dispose();
    cepTextController?.dispose();

    endFocusNode?.dispose();
    endTextController?.dispose();

    numFocusNode?.dispose();
    numTextController?.dispose();

    cidadeFocusNode?.dispose();
    cidadeTextController?.dispose();

    foneFocusNode?.dispose();
    foneTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    instagramFocusNode?.dispose();
    instagramTextController?.dispose();

    nomeRepFocusNode?.dispose();
    nomeRepTextController?.dispose();

    rgRepFocusNode?.dispose();
    rgRepTextController?.dispose();

    cpfRepFocusNode?.dispose();
    cpfRepTextController?.dispose();

    foneRepFocusNode?.dispose();
    foneRepTextController?.dispose();

    mailRepFocusNode?.dispose();
    mailRepTextController?.dispose();

    passwordRepFocusNode?.dispose();
    passwordRepTextController?.dispose();
  }
}
