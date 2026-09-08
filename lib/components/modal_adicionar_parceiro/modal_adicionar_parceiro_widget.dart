import '/backend/api_requests/api_calls.dart';
import '/components/modal_adicionar_segmento/modal_adicionar_segmento_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'modal_adicionar_parceiro_model.dart';
export 'modal_adicionar_parceiro_model.dart';

class ModalAdicionarParceiroWidget extends StatefulWidget {
  const ModalAdicionarParceiroWidget({
    super.key,
    required this.titulo,
    required this.nomeDeSegmentos,
    required this.segmentos,
    this.nomeDeEstados,
  });

  final String? titulo;
  final List<String>? nomeDeSegmentos;
  final List<dynamic>? segmentos;
  final List<String>? nomeDeEstados;

  @override
  State<ModalAdicionarParceiroWidget> createState() =>
      _ModalAdicionarParceiroWidgetState();
}

class _ModalAdicionarParceiroWidgetState
    extends State<ModalAdicionarParceiroWidget> {
  late ModalAdicionarParceiroModel _model;
  bool _senhaOculta = true;
  bool _salvando = false;
  bool _buscandoCnpj = false;

  Future<void> _consultarCnpj(String val) async {
    final digits = val.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 14) {
      if (val.isNotEmpty) {
        showWarningToast(context, 'Por favor, informe um CNPJ completo com 14 dígitos.');
      }
      return;
    }

    setState(() => _buscandoCnpj = true);
    try {
      final data = await actions.getCompanyByCnpj(digits);
      if (data != null && data is Map) {
        if (data['razaoSocial'] != null && data['razaoSocial'].toString().isNotEmpty) {
          _model.razaoTextController?.text = data['razaoSocial'].toString();
        }
        final fantasia = data['nomeFantasia']?.toString() ?? '';
        if (fantasia.isNotEmpty) {
          _model.nomeTextController?.text = fantasia;
        } else if (data['razaoSocial'] != null) {
          _model.nomeTextController?.text = data['razaoSocial'].toString();
        }
        if (data['logradouro'] != null && data['logradouro'].toString().isNotEmpty) {
          _model.endTextController?.text = data['logradouro'].toString();
        }
        if (data['numero'] != null && data['numero'].toString().isNotEmpty) {
          _model.numTextController?.text = data['numero'].toString();
        }
        if (data['bairro'] != null && data['bairro'].toString().isNotEmpty) {
          _model.bairroTextController?.text = data['bairro'].toString();
        }
        if (data['cidade'] != null && data['cidade'].toString().isNotEmpty) {
          _model.cidadeTextController?.text = data['cidade'].toString();
        }
        if (data['uf'] != null && data['uf'].toString().isNotEmpty) {
          _model.estadoValue = data['uf'].toString().toUpperCase();
        }
        if (data['cep'] != null && data['cep'].toString().isNotEmpty) {
          final cepRaw = data['cep'].toString().replaceAll(RegExp(r'[^0-9]'), '');
          if (cepRaw.length == 8) {
            _model.cepTextController?.text = '${cepRaw.substring(0, 5)}-${cepRaw.substring(5)}';
          } else {
            _model.cepTextController?.text = data['cep'].toString();
          }
        }
        if (data['telefone'] != null && data['telefone'].toString().isNotEmpty) {
          _model.foneTextController?.text = data['telefone'].toString();
        }
        if (data['email'] != null && data['email'].toString().isNotEmpty) {
          _model.emailTextController?.text = data['email'].toString();
        }
        if (mounted) {
          showSuccessToast(
            context,
            'Dados da empresa "${_model.nomeTextController?.text ?? 'CNPJ'}" preenchidos automaticamente!',
            title: 'CNPJ Localizado',
          );
        }
        safeSetState(() {});
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          'CNPJ não encontrado na Receita Federal.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _buscandoCnpj = false);
      }
    }
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAdicionarParceiroModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.nomeDeSegmentos = widget.nomeDeSegmentos?.toList().cast<String>() ?? [];
      safeSetState(() {});
    });

    _model.switchValue = false;
    _model.cnpjTextController ??= TextEditingController();
    _model.cnpjFocusNode ??= FocusNode();
    _model.cnpjMask = MaskTextInputFormatter(mask: '##.###.###/####-##');

    _model.nomeTextController ??= TextEditingController();
    _model.nomeFocusNode ??= FocusNode();

    _model.razaoTextController ??= TextEditingController();
    _model.razaoFocusNode ??= FocusNode();

    _model.bairroTextController ??= TextEditingController();
    _model.bairroFocusNode ??= FocusNode();

    _model.cepTextController ??= TextEditingController();
    _model.cepFocusNode ??= FocusNode();
    _model.cepMask = MaskTextInputFormatter(mask: '#####-###');

    _model.endTextController ??= TextEditingController();
    _model.endFocusNode ??= FocusNode();

    _model.numTextController ??= TextEditingController();
    _model.numFocusNode ??= FocusNode();

    _model.cidadeTextController ??= TextEditingController();
    _model.cidadeFocusNode ??= FocusNode();

    _model.foneTextController ??= TextEditingController();
    _model.foneFocusNode ??= FocusNode();
    _model.foneMask = MaskTextInputFormatter(mask: '(##) # ####-####');

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.instagramTextController ??= TextEditingController();
    _model.instagramFocusNode ??= FocusNode();

    _model.nomeRepTextController ??= TextEditingController();
    _model.nomeRepFocusNode ??= FocusNode();

    _model.rgRepTextController ??= TextEditingController();
    _model.rgRepFocusNode ??= FocusNode();
    _model.rgRepMask = MaskTextInputFormatter(mask: '##.###.###-#');

    _model.cpfRepTextController ??= TextEditingController();
    _model.cpfRepFocusNode ??= FocusNode();
    _model.cpfRepMask = MaskTextInputFormatter(mask: '###.###.###-##');

    _model.foneRepTextController ??= TextEditingController();
    _model.foneRepFocusNode ??= FocusNode();
    _model.foneRepMask = MaskTextInputFormatter(mask: '(##) # ####-####');

    _model.mailRepTextController ??= TextEditingController();
    _model.mailRepFocusNode ??= FocusNode();

    _model.passwordRepTextController ??= TextEditingController();
    _model.passwordRepFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(
    String label,
    FlutterFlowTheme theme, {
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.readexPro(
        fontSize: 13.0,
        color: theme.secondaryText,
      ),
      hintText: hint,
      hintStyle: GoogleFonts.readexPro(
        fontSize: 12.5,
        color: theme.secondaryText.withOpacity(0.6),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: true,
      filled: true,
      fillColor: theme.primaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.alternate, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.secondary, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Icon(icon, color: theme.secondary, size: 18.0),
          ),
          const SizedBox(width: 10.0),
          Text(
            title,
            style: GoogleFonts.readexPro(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: theme.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submeterFormulario() async {
    if (_model.nomeTextController.text.trim().isEmpty) {
      showWarningToast(context, 'Por favor, informe o Nome Fantasia da empresa.');
      return;
    }

    setState(() => _salvando = true);

    try {
      _model.apiResult88s = await CriarParceiroCall.call(
        idTenant: functions.convertToInt(FFAppConstants.tenantId),
        email: _model.emailTextController.text,
        senha: _model.passwordRepTextController.text,
        razao: _model.razaoTextController.text,
        cnpj: _model.cnpjTextController.text,
        cep: _model.cepTextController.text,
        rua: _model.endTextController.text,
        bairro: _model.bairroTextController.text,
        numero: _model.numTextController.text,
        cidade: _model.cidadeTextController.text.trim(),
        telefoneRepresentante: _model.foneRepTextController.text,
        representanteNome: _model.nomeRepTextController.text,
        selecionado: _model.switchValue,
        contract: _model.fileUrl,
        photo: _model.imageUrl,
        state: _model.estadoValue,
        cpf: _model.cpfRepTextController.text,
        rg: _model.rgRepTextController.text,
        emailRepresentante: _model.mailRepTextController.text,
        fantasia: _model.nomeTextController.text,
        idSegmento: _model.idSegmento?.toString(),
        instagram: _model.instagramTextController.text,
      );

      if ((_model.apiResult88s?.succeeded ?? false)) {
        _model.atualizarParceiro = await AtualizarParceiroCall.call(
          idTenant: functions.convertToInt(FFAppConstants.tenantId),
          email: _model.emailTextController.text,
          senha: _model.passwordRepTextController.text,
          razao: _model.razaoTextController.text,
          cnpj: _model.cnpjTextController.text,
          cep: _model.cepTextController.text,
          rua: _model.endTextController.text,
          bairro: _model.bairroTextController.text,
          numero: _model.numTextController.text,
          cidade: _model.cidadeTextController.text,
          telefoneRepresentante: _model.foneRepTextController.text,
          representanteNome: _model.nomeRepTextController.text,
          selecionado: _model.switchValue,
          contract: _model.fileUrl,
          photo: _model.imageUrl,
          state: _model.estadoValue,
          cpf: _model.cpfRepTextController.text,
          rg: _model.rgRepTextController.text,
          emailRepresentante: _model.mailRepTextController.text,
          fantasia: _model.nomeTextController.text,
          idSegmento: _model.idSegmento?.toString(),
          proposal: 'off',
          idCustomer: getJsonField((_model.apiResult88s?.jsonBody ?? ''), r'''$.id''').toString(),
          phone: _model.foneTextController.text,
          idPartner: getJsonField((_model.apiResult88s?.jsonBody ?? ''), r'''$.partner.id''').toString(),
          idWallet: getJsonField((_model.apiResult88s?.jsonBody ?? ''), r'''$.wallet.id''').toString(),
          idUser: getJsonField((_model.apiResult88s?.jsonBody ?? ''), r'''$.user.id''').toString(),
          instagram: _model.instagramTextController.text,
        );

        if (mounted) {
          showSuccessToast(
            context,
            'Parceiro cadastrado com sucesso!',
            title: 'Parceiro Cadastrado',
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          showErrorToast(
            context,
            'Erro ao criar parceiro. Verifique os dados e tente novamente.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context,
          'Erro: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final listaEstados = widget.nomeDeEstados ?? functions.obterEstados();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Container(
        width: (MediaQuery.sizeOf(context).width * 0.8).clamp(560.0, 920.0),
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 24.0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modal Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 20.0, 16.0),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(
                      Icons.storefront_rounded,
                      color: theme.secondary,
                      size: 22.0,
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cadastrar Novo Parceiro',
                          style: GoogleFonts.readexPro(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryText,
                          ),
                        ),
                        Text(
                          'Preencha os dados cadastrais da empresa e o responsável de acesso.',
                          style: GoogleFonts.readexPro(
                            fontSize: 12.5,
                            color: theme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.secondaryText, size: 22.0),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1.0),

            // Form Body (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _model.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seção 1: Dados da Empresa
                      _buildSectionHeader('1. Dados da Empresa & Estabelecimento', Icons.business_rounded, theme),
                      Container(
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                          color: theme.primaryBackground.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // CNPJ
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _model.cnpjTextController,
                                    focusNode: _model.cnpjFocusNode,
                                    inputFormatters: [_model.cnpjMask],
                                    onChanged: (val) {
                                      final digits = val.replaceAll(RegExp(r'[^0-9]'), '');
                                      if (digits.length == 14) {
                                        _consultarCnpj(val);
                                      }
                                    },
                                    decoration: _buildInputDecoration(
                                      'CNPJ *',
                                      theme,
                                      hint: '00.000.000/0000-00',
                                      suffixIcon: _buscandoCnpj
                                          ? Padding(
                                              padding: const EdgeInsets.all(11.0),
                                              child: SizedBox(
                                                width: 14.0,
                                                height: 14.0,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  color: theme.secondary,
                                                ),
                                              ),
                                            )
                                          : IconButton(
                                              icon: Icon(
                                                Icons.search_rounded,
                                                color: theme.secondary,
                                                size: 19.0,
                                              ),
                                              tooltip: 'Consultar CNPJ na Receita Federal',
                                              onPressed: () => _consultarCnpj(_model.cnpjTextController?.text ?? ''),
                                            ),
                                    ),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Segmento com Dropdown e Botão Adicionar
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value: _model.segmentoValue,
                                          decoration: _buildInputDecoration('Segmento *', theme),
                                          style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                          items: _model.nomeDeSegmentos.map((seg) {
                                            return DropdownMenuItem<String>(
                                              value: seg,
                                              child: Text(seg, style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText)),
                                            );
                                          }).toList(),
                                          onChanged: (novo) async {
                                            _model.segmentoValue = novo;
                                            if (novo != null) {
                                              _model.idSegmento = await actions.obterIdDoSegmentoPorNome(
                                                widget.segmentos ?? [],
                                                novo,
                                              );
                                            }
                                            safeSetState(() {});
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      InkWell(
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (dialogContext) => const Dialog(
                                              backgroundColor: Colors.transparent,
                                              insetPadding: EdgeInsets.zero,
                                              child: ModalAdicionarSegmentoWidget(),
                                            ),
                                          );
                                          _model.apiResult230s = await ObterSegmentosCall.call();
                                          if ((_model.apiResult230s?.succeeded ?? true)) {
                                            _model.segmentosAtualizados = await actions.obterListaDeSegmentos(
                                              (_model.apiResult230s?.jsonBody ?? ''),
                                            );
                                            _model.nomeDeSegmentos = _model.segmentosAtualizados?.toList().cast<String>() ?? [];
                                            safeSetState(() {});
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Container(
                                          height: 44.0,
                                          width: 44.0,
                                          decoration: BoxDecoration(
                                            color: theme.primary,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Icon(Icons.add_rounded, color: theme.secondary, size: 22.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14.0),
                            Row(
                              children: [
                                // Nome Fantasia
                                Expanded(
                                  child: TextFormField(
                                    controller: _model.nomeTextController,
                                    focusNode: _model.nomeFocusNode,
                                    decoration: _buildInputDecoration('Nome Fantasia *', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Razão Social
                                Expanded(
                                  child: TextFormField(
                                    controller: _model.razaoTextController,
                                    focusNode: _model.razaoFocusNode,
                                    decoration: _buildInputDecoration('Razão Social *', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14.0),
                            Row(
                              children: [
                                // Telefone
                                Expanded(
                                  child: TextFormField(
                                    controller: _model.foneTextController,
                                    focusNode: _model.foneFocusNode,
                                    inputFormatters: [_model.foneMask],
                                    decoration: _buildInputDecoration('Telefone Comercial', theme, hint: '(00) 0 0000-0000'),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Email
                                Expanded(
                                  child: TextFormField(
                                    controller: _model.emailTextController,
                                    focusNode: _model.emailFocusNode,
                                    decoration: _buildInputDecoration('E-mail Comercial', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Instagram
                                Expanded(
                                  child: TextFormField(
                                    controller: _model.instagramTextController,
                                    focusNode: _model.instagramFocusNode,
                                    decoration: _buildInputDecoration('Instagram', theme, hint: '@seuperfil'),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14.0),
                            // Destaque e Uploads
                            Row(
                              children: [
                                // Switch Destaque
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: theme.secondaryBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: theme.alternate),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Destaque no App:',
                                        style: GoogleFonts.readexPro(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: theme.primaryText,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Switch.adaptive(
                                        value: _model.switchValue ?? false,
                                        activeColor: theme.secondary,
                                        activeTrackColor: theme.primary,
                                        onChanged: (val) => setState(() => _model.switchValue = val),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14.0),
                                // Upload Foto
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      final selectedMedia = await selectMediaWithSourceBottomSheet(
                                        context: context,
                                        allowPhoto: true,
                                      );
                                      if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                        showUploadMessage(context, 'Enviando foto...', showLoading: true);
                                        _model.imageUrl = await actions.uploadPhoto(
                                          FFUploadedFile(
                                            name: selectedMedia.first.storagePath.split('/').last,
                                            bytes: selectedMedia.first.bytes,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        safeSetState(() {});
                                      }
                                    },
                                    icon: Icon(
                                      _model.imageUrl != null ? Icons.check_circle_rounded : Icons.add_photo_alternate_outlined,
                                      color: _model.imageUrl != null ? theme.success : theme.secondary,
                                      size: 18.0,
                                    ),
                                    label: Text(
                                      _model.imageUrl != null ? 'Logo Carregada' : 'Upload Logotipo/Foto',
                                      style: GoogleFonts.readexPro(fontSize: 12.5, color: theme.primaryText),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                                      side: BorderSide(color: theme.alternate),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                      backgroundColor: theme.secondaryBackground,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Upload Contrato
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      final selectedMedia = await selectMediaWithSourceBottomSheet(
                                        context: context,
                                        allowPhoto: true,
                                      );
                                      if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                        showUploadMessage(context, 'Enviando contrato...', showLoading: true);
                                        _model.fileUrl = await actions.uploadPhoto(
                                          FFUploadedFile(
                                            name: selectedMedia.first.storagePath.split('/').last,
                                            bytes: selectedMedia.first.bytes,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        safeSetState(() {});
                                      }
                                    },
                                    icon: Icon(
                                      _model.fileUrl != null ? Icons.check_circle_rounded : Icons.description_outlined,
                                      color: _model.fileUrl != null ? theme.success : theme.secondary,
                                      size: 18.0,
                                    ),
                                    label: Text(
                                      _model.fileUrl != null ? 'Contrato Anexado' : 'Upload Contrato (PDF)',
                                      style: GoogleFonts.readexPro(fontSize: 12.5, color: theme.primaryText),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                                      side: BorderSide(color: theme.alternate),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                      backgroundColor: theme.secondaryBackground,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24.0),

                      // Seção 2: Endereço & Localização
                      _buildSectionHeader('2. Endereço & Localização', Icons.place_rounded, theme),
                      Container(
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                          color: theme.primaryBackground.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // CEP
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _model.cepTextController,
                                    focusNode: _model.cepFocusNode,
                                    inputFormatters: [_model.cepMask],
                                    decoration: _buildInputDecoration('CEP *', theme, hint: '00000-000'),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Endereço / Rua
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    controller: _model.endTextController,
                                    focusNode: _model.endFocusNode,
                                    decoration: _buildInputDecoration('Logradouro / Rua *', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Número
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _model.numTextController,
                                    focusNode: _model.numFocusNode,
                                    decoration: _buildInputDecoration('Número *', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14.0),
                            Row(
                              children: [
                                // Bairro
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _model.bairroTextController,
                                    focusNode: _model.bairroFocusNode,
                                    decoration: _buildInputDecoration('Bairro *', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Cidade
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _model.cidadeTextController,
                                    focusNode: _model.cidadeFocusNode,
                                    decoration: _buildInputDecoration('Cidade *', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Estado (UF)
                                Expanded(
                                  flex: 2,
                                  child: DropdownButtonFormField<String>(
                                    value: _model.estadoValue,
                                    decoration: _buildInputDecoration('Estado (UF) *', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                    items: listaEstados.map((uf) {
                                      return DropdownMenuItem<String>(
                                        value: uf,
                                        child: Text(uf, style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText)),
                                      );
                                    }).toList(),
                                    onChanged: (novo) => setState(() => _model.estadoValue = novo),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24.0),

                      // Seção 3: Responsável & Acesso
                      _buildSectionHeader('3. Responsável & Credenciais de Acesso', Icons.lock_person_rounded, theme),
                      Container(
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                          color: theme.primaryBackground.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Nome do Representante
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _model.nomeRepTextController,
                                    focusNode: _model.nomeRepFocusNode,
                                    decoration: _buildInputDecoration('Nome do Representante *', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // CPF
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _model.cpfRepTextController,
                                    focusNode: _model.cpfRepFocusNode,
                                    inputFormatters: [_model.cpfRepMask],
                                    decoration: _buildInputDecoration('CPF do Representante *', theme, hint: '000.000.000-00'),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // RG
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _model.rgRepTextController,
                                    focusNode: _model.rgRepFocusNode,
                                    inputFormatters: [_model.rgRepMask],
                                    decoration: _buildInputDecoration('RG', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14.0),
                            Row(
                              children: [
                                // Telefone do Representante
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _model.foneRepTextController,
                                    focusNode: _model.foneRepFocusNode,
                                    inputFormatters: [_model.foneRepMask],
                                    decoration: _buildInputDecoration('Telefone Celular *', theme, hint: '(00) 0 0000-0000'),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Email de Login
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _model.mailRepTextController,
                                    focusNode: _model.mailRepFocusNode,
                                    decoration: _buildInputDecoration('E-mail de Login do Painel *', theme),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // Senha de Acesso
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _model.passwordRepTextController,
                                    focusNode: _model.passwordRepFocusNode,
                                    obscureText: _senhaOculta,
                                    decoration: _buildInputDecoration(
                                      'Senha de Acesso *',
                                      theme,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _senhaOculta ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                          size: 18.0,
                                          color: theme.secondaryText,
                                        ),
                                        onPressed: () => setState(() => _senhaOculta = !_senhaOculta),
                                      ),
                                    ),
                                    style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Modal Footer
            const Divider(height: 1.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _salvando ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                      side: BorderSide(color: theme.alternate),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.readexPro(
                        color: theme.secondaryText,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  FFButtonWidget(
                    onPressed: _salvando ? null : _submeterFormulario,
                    text: _salvando ? 'Cadastrando...' : 'Cadastrar Parceiro',
                    icon: _salvando
                        ? null
                        : Icon(
                            Icons.check_rounded,
                            color: theme.secondary,
                            size: 18.0,
                          ),
                    options: FFButtonOptions(
                      height: 44.0,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      color: theme.primary,
                      textStyle: GoogleFonts.readexPro(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
