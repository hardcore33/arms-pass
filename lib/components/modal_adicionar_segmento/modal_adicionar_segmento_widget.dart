import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modal_adicionar_segmento_model.dart';
export 'modal_adicionar_segmento_model.dart';

class ModalAdicionarSegmentoWidget extends StatefulWidget {
  const ModalAdicionarSegmentoWidget({super.key});

  @override
  State<ModalAdicionarSegmentoWidget> createState() =>
      _ModalAdicionarSegmentoWidgetState();
}

class _ModalAdicionarSegmentoWidgetState
    extends State<ModalAdicionarSegmentoWidget> {
  late ModalAdicionarSegmentoModel _model;
  List<dynamic> _segmentosList = [];
  bool _carregandoLista = true;
  bool _salvando = false;
  String? _idEditando;
  String _buscaSegmento = '';
  final TextEditingController _buscaController = TextEditingController();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalAdicionarSegmentoModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _carregarSegmentos();
    });
  }

  Future<void> _carregarSegmentos() async {
    setState(() => _carregandoLista = true);
    try {
      final response = await ObterSegmentosCall.call();
      if (response.succeeded) {
        final body = response.jsonBody;
        if (body is List) {
          _segmentosList = body;
        } else if (body is Map && body['data'] is List) {
          _segmentosList = body['data'];
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar segmentos: $e');
    } finally {
      if (mounted) {
        setState(() => _carregandoLista = false);
      }
    }
  }

  @override
  void dispose() {
    _buscaController.dispose();
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _salvarSegmento() async {
    final nome = _model.textController?.text.trim() ?? '';
    if (nome.isEmpty) {
      showWarningToast(context, 'Por favor, informe o nome do segmento.');
      return;
    }

    setState(() => _salvando = true);

    try {
      if (_idEditando != null) {
        // Editando
        final res = await EditarSegmentoCall.call(
          id: _idEditando,
          nome: nome,
          url: _model.imageUrl ?? '',
        );
        if (res.succeeded) {
          if (mounted) {
            showSuccessToast(
              context,
              'Segmento atualizado com sucesso!',
              title: 'Segmento Atualizado',
            );
          }
          _limparFormulario();
          await _carregarSegmentos();
        } else {
          if (mounted) {
            showErrorToast(
              context,
              'Erro ao atualizar segmento.',
            );
          }
        }
      } else {
        // Criando novo
        final res = await AdicionarSegmentoCall.call(
          nome: nome,
          url: _model.imageUrl ?? '',
        );
        if (res.succeeded) {
          if (mounted) {
            showSuccessToast(
              context,
              'Segmento cadastrado com sucesso!',
              title: 'Segmento Cadastrado',
            );
          }
          _limparFormulario();
          await _carregarSegmentos();
        } else {
          if (mounted) {
            showErrorToast(
              context,
              'Erro ao cadastrar segmento.',
            );
          }
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

  void _selecionarParaEdicao(dynamic segmento) {
    setState(() {
      _idEditando = segmento['id']?.toString();
      _model.textController?.text = segmento['name']?.toString() ?? '';
      _model.imageUrl = (segmento['photo'] ?? segmento['url'])?.toString();
      _model.hasUploadedFile = _model.imageUrl != null && _model.imageUrl!.isNotEmpty;
    });
  }

  void _limparFormulario() {
    setState(() {
      _idEditando = null;
      _model.textController?.clear();
      _model.imageUrl = null;
      _model.hasUploadedFile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    final listaFiltrada = _segmentosList.where((seg) {
      if (_buscaSegmento.isEmpty) return true;
      final nome = (seg['name'] ?? '').toString().toLowerCase();
      return nome.contains(_buscaSegmento.toLowerCase().trim());
    }).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Container(
        width: (MediaQuery.sizeOf(context).width * 0.7).clamp(620.0, 800.0),
        height: 520.0,
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
          children: [
            // Header do Modal
            Padding(
              padding: const EdgeInsets.fromLTRB(22.0, 18.0, 18.0, 14.0),
              child: Row(
                children: [
                  Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(
                      Icons.category_rounded,
                      color: theme.secondary,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gerenciar Segmentos',
                          style: GoogleFonts.readexPro(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryText,
                          ),
                        ),
                        Text(
                          'Cadastre novas categorias comerciais ou consulte as já existentes.',
                          style: GoogleFonts.readexPro(
                            fontSize: 12.0,
                            color: theme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.secondaryText, size: 22.0),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            ),
            const Divider(height: 1.0),

            // Corpo Dividido em 2 Colunas: Formulário (Esq) e Lista de Existentes (Dir)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Coluna Esquerda: Formulário de Adicionar / Editar
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _idEditando != null ? 'Editar Segmento' : 'Novo Segmento',
                                style: GoogleFonts.readexPro(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryText,
                                ),
                              ),
                              if (_idEditando != null) ...[
                                const Spacer(),
                                InkWell(
                                  onTap: _limparFormulario,
                                  child: Text(
                                    '+ Criar Novo',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: theme.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          // Nome do Segmento
                          Text(
                            'Nome do Segmento *',
                            style: GoogleFonts.readexPro(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryText,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Ex: Restaurante, Academia, Saúde...',
                              hintStyle: GoogleFonts.readexPro(
                                fontSize: 12.5,
                                color: theme.secondaryText.withOpacity(0.6),
                              ),
                              isDense: true,
                              filled: true,
                              fillColor: theme.primaryBackground,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: theme.alternate, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: theme.secondary, width: 1.5),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            style: GoogleFonts.readexPro(fontSize: 13.0, color: theme.primaryText),
                          ),

                          const SizedBox(height: 18.0),

                          // Ícone / Foto do Segmento
                          Text(
                            'Ícone / Imagem do Segmento',
                            style: GoogleFonts.readexPro(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: theme.primaryBackground,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: theme.alternate),
                            ),
                            child: Row(
                              children: [
                                // Preview da Imagem
                                Container(
                                  width: 44.0,
                                  height: 44.0,
                                  decoration: BoxDecoration(
                                    color: theme.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: theme.secondary.withOpacity(0.4)),
                                  ),
                                  child: (_model.imageUrl != null && _model.imageUrl!.isNotEmpty && _model.imageUrl != 'null')
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(7.0),
                                          child: Image.network(
                                            _model.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.category_outlined,
                                              color: theme.secondary,
                                              size: 20.0,
                                            ),
                                          ),
                                        )
                                      : Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: theme.secondary,
                                          size: 22.0,
                                        ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () async {
                                          final selectedMedia = await selectMediaWithSourceBottomSheet(
                                            context: context,
                                            allowPhoto: true,
                                          );
                                          if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                            showUploadMessage(context, 'Enviando imagem...', showLoading: true);
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
                                          _model.imageUrl != null ? Icons.check_circle_rounded : Icons.upload_rounded,
                                          size: 16.0,
                                          color: _model.imageUrl != null ? theme.success : theme.secondary,
                                        ),
                                        label: Text(
                                          _model.imageUrl != null ? 'Trocar Imagem' : 'Escolher Ícone',
                                          style: GoogleFonts.readexPro(fontSize: 12.0, color: theme.primaryText),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                          side: BorderSide(color: theme.alternate),
                                          backgroundColor: theme.secondaryBackground,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24.0),

                          // Botão de Ação
                          Row(
                            children: [
                              if (_idEditando != null)
                                OutlinedButton(
                                  onPressed: _limparFormulario,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                                    side: BorderSide(color: theme.alternate),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                  ),
                                  child: Text(
                                    'Cancelar',
                                    style: GoogleFonts.readexPro(
                                      color: theme.secondaryText,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                              if (_idEditando != null) const SizedBox(width: 8.0),
                              Expanded(
                                child: FFButtonWidget(
                                  onPressed: _salvando ? null : _salvarSegmento,
                                  text: _salvando
                                      ? 'Salvando...'
                                      : (_idEditando != null ? 'Atualizar Segmento' : 'Cadastrar Segmento'),
                                  icon: _salvando
                                      ? null
                                      : Icon(
                                          Icons.check_rounded,
                                          color: theme.secondary,
                                          size: 17.0,
                                        ),
                                  options: FFButtonOptions(
                                    height: 42.0,
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    color: theme.primary,
                                    textStyle: GoogleFonts.readexPro(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    elevation: 0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Divisor Vertical
                  VerticalDivider(width: 1.0, thickness: 1.0, color: theme.alternate),

                  // Coluna Direita: Lista de Segmentos Existentes
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabeçalho da Lista & Busca
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Segmentos Cadastrados',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryText,
                                    ),
                                  ),
                                  const SizedBox(width: 6.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: theme.primary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      '${_segmentosList.length}',
                                      style: GoogleFonts.readexPro(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                        color: theme.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              // Campo de Busca
                              SizedBox(
                                height: 36.0,
                                child: TextFormField(
                                  controller: _buscaController,
                                  onChanged: (val) => setState(() => _buscaSegmento = val),
                                  decoration: InputDecoration(
                                    hintText: 'Filtrar segmento...',
                                    hintStyle: GoogleFonts.readexPro(
                                      fontSize: 12.0,
                                      color: theme.secondaryText.withOpacity(0.6),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      size: 16.0,
                                      color: theme.secondary,
                                    ),
                                    isDense: true,
                                    filled: true,
                                    fillColor: theme.primaryBackground,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: theme.alternate, width: 1.0),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: theme.secondary, width: 1.5),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                  ),
                                  style: GoogleFonts.readexPro(fontSize: 12.5, color: theme.primaryText),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1.0),

                        // Lista
                        Expanded(
                          child: _carregandoLista
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: theme.secondary,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : listaFiltrada.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Nenhum segmento encontrado.',
                                        style: GoogleFonts.readexPro(
                                          fontSize: 12.5,
                                          color: theme.secondaryText,
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                                      itemCount: listaFiltrada.length,
                                      separatorBuilder: (_, __) => Divider(
                                        height: 1.0,
                                        color: theme.alternate.withOpacity(0.5),
                                      ),
                                      itemBuilder: (context, index) {
                                        final seg = listaFiltrada[index];
                                        final name = (seg['name'] ?? '').toString();
                                        final photo = (seg['photo'] ?? seg['url'])?.toString() ?? '';
                                        final isEditingThis = _idEditando == seg['id']?.toString();

                                        return Container(
                                          color: isEditingThis
                                              ? theme.primary.withOpacity(0.06)
                                              : Colors.transparent,
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                          child: Row(
                                            children: [
                                              // Ícone
                                              Container(
                                                width: 32.0,
                                                height: 32.0,
                                                decoration: BoxDecoration(
                                                  color: theme.primary.withOpacity(0.06),
                                                  borderRadius: BorderRadius.circular(6.0),
                                                ),
                                                child: photo.isNotEmpty && photo != 'null'
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(6.0),
                                                        child: Image.network(
                                                          photo,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (_, __, ___) => Icon(
                                                            Icons.category_rounded,
                                                            color: theme.secondary,
                                                            size: 16.0,
                                                          ),
                                                        ),
                                                      )
                                                    : Icon(
                                                        Icons.category_rounded,
                                                        color: theme.secondary,
                                                        size: 16.0,
                                                      ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Expanded(
                                                child: Text(
                                                  name,
                                                  style: GoogleFonts.readexPro(
                                                    fontSize: 12.5,
                                                    fontWeight: isEditingThis ? FontWeight.bold : FontWeight.w500,
                                                    color: theme.primaryText,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => _selecionarParaEdicao(seg),
                                                borderRadius: BorderRadius.circular(4.0),
                                                child: Container(
                                                  padding: const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                    color: theme.primary.withOpacity(0.06),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.edit_rounded,
                                                    size: 14.0,
                                                    color: theme.secondary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                        ),
                      ],
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
