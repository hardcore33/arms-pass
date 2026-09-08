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
import 'modal_editar_parceiro_widget.dart' show ModalEditarParceiroWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ModalEditarParceiroModel
    extends FlutterFlowModel<ModalEditarParceiroWidget> {
  ///  Local state fields for this component.

  bool hasUploadedFile = false;

  bool hasNewPhoto = false;

  bool hasNewContract = false;

  List<String> nomeDeSegmentos = [];
  void addToNomeDeSegmentos(String item) => nomeDeSegmentos.add(item);
  void removeFromNomeDeSegmentos(String item) => nomeDeSegmentos.remove(item);
  void removeAtIndexFromNomeDeSegmentos(int index) =>
      nomeDeSegmentos.removeAt(index);
  void insertAtIndexInNomeDeSegmentos(int index, String item) =>
      nomeDeSegmentos.insert(index, item);
  void updateNomeDeSegmentosAtIndex(int index, Function(String) updateFn) =>
      nomeDeSegmentos[index] = updateFn(nomeDeSegmentos[index]);

  String? imagemUrll;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel1;
  // Model for Fonte_Titulo_Modal component.
  late FonteTituloModalModel fonteTituloModalModel2;
  // State field(s) for Switch widget.
  bool? switchValue;
  bool? isActiveValue;
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
  ApiCallResponse? apiResult2sdalk;
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

  // State field(s) for rua widget.
  FocusNode? ruaFocusNode;
  TextEditingController? ruaTextController;
  String? Function(BuildContext, String?)? ruaTextControllerValidator;
  String? _ruaTextControllerValidator(BuildContext context, String? val) {
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
  // State field(s) for phone widget.
  FocusNode? phoneFocusNode;
  TextEditingController? phoneTextController;
  late MaskTextInputFormatter phoneMask;
  String? Function(BuildContext, String?)? phoneTextControllerValidator;
  String? _phoneTextControllerValidator(BuildContext context, String? val) {
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

  // State field(s) for instagram widget.
  FocusNode? instagramFocusNode;
  TextEditingController? instagramTextController;
  String? Function(BuildContext, String?)? instagramTextControllerValidator;
  bool isDataUploading_uploadData3m5 = false;
  FFUploadedFile uploadedLocalFile_uploadData3m5 =
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

  // State field(s) for rg widget.
  FocusNode? rgFocusNode;
  TextEditingController? rgTextController;
  late MaskTextInputFormatter rgMask;
  String? Function(BuildContext, String?)? rgTextControllerValidator;
  String? _rgTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for cpf widget.
  FocusNode? cpfFocusNode;
  TextEditingController? cpfTextController;
  late MaskTextInputFormatter cpfMask;
  String? Function(BuildContext, String?)? cpfTextControllerValidator;
  String? _cpfTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for phone_rep widget.
  FocusNode? phoneRepFocusNode;
  TextEditingController? phoneRepTextController;
  late MaskTextInputFormatter phoneRepMask;
  String? Function(BuildContext, String?)? phoneRepTextControllerValidator;
  String? _phoneRepTextControllerValidator(BuildContext context, String? val) {
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

  // State field(s) for pass_rep widget.
  FocusNode? passRepFocusNode;
  TextEditingController? passRepTextController;
  late bool passRepVisibility;
  String? Function(BuildContext, String?)? passRepTextControllerValidator;
  String? _passRepTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  bool isDataUploading_uploadDataFt8 = false;
  FFUploadedFile uploadedLocalFile_uploadDataFt8 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - uploadFile] action in Button widget.
  String? fileUrl;
  // Stores action output result for [Custom Action - obterIdDoSegmentoPorNome] action in Button widget.
  int? segmentoId;
  // Stores action output result for [Backend Call - API (atualizarParceiro)] action in Button widget.
  ApiCallResponse? apiResultjex;

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
    ruaTextControllerValidator = _ruaTextControllerValidator;
    numTextControllerValidator = _numTextControllerValidator;
    cidadeTextControllerValidator = _cidadeTextControllerValidator;
    phoneTextControllerValidator = _phoneTextControllerValidator;
    emailTextControllerValidator = _emailTextControllerValidator;
    nomeRepTextControllerValidator = _nomeRepTextControllerValidator;
    rgTextControllerValidator = _rgTextControllerValidator;
    cpfTextControllerValidator = _cpfTextControllerValidator;
    phoneRepTextControllerValidator = _phoneRepTextControllerValidator;
    mailRepTextControllerValidator = _mailRepTextControllerValidator;
    passRepVisibility = false;
    passRepTextControllerValidator = _passRepTextControllerValidator;
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

    ruaFocusNode?.dispose();
    ruaTextController?.dispose();

    numFocusNode?.dispose();
    numTextController?.dispose();

    cidadeFocusNode?.dispose();
    cidadeTextController?.dispose();

    phoneFocusNode?.dispose();
    phoneTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    instagramFocusNode?.dispose();
    instagramTextController?.dispose();

    nomeRepFocusNode?.dispose();
    nomeRepTextController?.dispose();

    rgFocusNode?.dispose();
    rgTextController?.dispose();

    cpfFocusNode?.dispose();
    cpfTextController?.dispose();

    phoneRepFocusNode?.dispose();
    phoneRepTextController?.dispose();

    mailRepFocusNode?.dispose();
    mailRepTextController?.dispose();

    passRepFocusNode?.dispose();
    passRepTextController?.dispose();
  }
}
