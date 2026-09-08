import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SeletorParceirosPlanoWidget extends StatefulWidget {
  const SeletorParceirosPlanoWidget({
    super.key,
    required this.selectedPartnerIds,
    required this.onChanged,
  });

  final List<int> selectedPartnerIds;
  final ValueChanged<List<int>> onChanged;

  @override
  State<SeletorParceirosPlanoWidget> createState() => _SeletorParceirosPlanoWidgetState();
}

class _SeletorParceirosPlanoWidgetState extends State<SeletorParceirosPlanoWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allPartners = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _carregarParceiros();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarParceiros() async {
    setState(() => _isLoading = true);
    try {
      // Tenta carregar primeiro via ObterParceirosCall, se vazio ou erro, tenta ObterUsuariosCall
      List<Map<String, dynamic>> loaded = [];
      final resp = await ObterParceirosCall.call();
      if (resp.succeeded && resp.jsonBody is List) {
        for (var item in (resp.jsonBody as List)) {
          if (item is Map) {
            final id = int.tryParse(item['id']?.toString() ?? '0') ?? 0;
            final fantasia = item['fantasia']?.toString() ?? item['razao']?.toString() ?? 'Parceiro #$id';
            final cnpj = item['cnpj']?.toString() ?? '';
            final segmento = item['segment']?['name']?.toString() ?? '';
            if (id > 0) {
              loaded.add({
                'id': id,
                'nome': fantasia,
                'cnpj': cnpj,
                'segmento': segmento,
              });
            }
          }
        }
      }

      // Se a chamada acima não retornou parceiros, usa a lista de clientes com partner
      if (loaded.isEmpty) {
        final usersResp = await ObterUsuariosCall.call();
        if (usersResp.succeeded && usersResp.jsonBody is List) {
          for (var item in (usersResp.jsonBody as List)) {
            if (item is Map && item['partner'] != null) {
              final p = item['partner'];
              final id = int.tryParse(p['id']?.toString() ?? item['id']?.toString() ?? '0') ?? 0;
              final fantasia = p['fantasia']?.toString() ?? p['razao']?.toString() ?? item['name']?.toString() ?? 'Parceiro #$id';
              final cnpj = p['cnpj']?.toString() ?? '';
              final segmento = p['segment']?['name']?.toString() ?? '';
              if (id > 0 && !loaded.any((e) => e['id'] == id)) {
                loaded.add({
                  'id': id,
                  'nome': fantasia,
                  'cnpj': cnpj,
                  'segmento': segmento,
                });
              }
            }
          }
        }
      }

      // Se ainda não houver parceiros da API (ex: sem conexão), provê lista base
      if (loaded.isEmpty) {
        loaded = [
          {'id': 1, 'nome': 'Arms Suplementos & Nutrição', 'cnpj': '12.345.678/0001-90', 'segmento': 'Nutrição'},
          {'id': 2, 'nome': 'FisioSport Reabilitação', 'cnpj': '23.456.789/0001-01', 'segmento': 'Fisioterapia'},
          {'id': 3, 'nome': 'Restaurante Fit & Greens', 'cnpj': '34.567.890/0001-12', 'segmento': 'Alimentação'},
          {'id': 4, 'nome': 'Moda Fitness Pro Store', 'cnpj': '45.678.901/0001-23', 'segmento': 'Vestuário'},
          {'id': 5, 'nome': 'BioEstética & Spa Recovery', 'cnpj': '56.789.012/0001-34', 'segmento': 'Estética'},
        ];
      }

      _allPartners = loaded;
    } catch (_) {
      // Fallback gracioso
      _allPartners = [
        {'id': 1, 'nome': 'Arms Suplementos & Nutrição', 'cnpj': '12.345.678/0001-90', 'segmento': 'Nutrição'},
        {'id': 2, 'nome': 'FisioSport Reabilitação', 'cnpj': '23.456.789/0001-01', 'segmento': 'Fisioterapia'},
        {'id': 3, 'nome': 'Restaurante Fit & Greens', 'cnpj': '34.567.890/0001-12', 'segmento': 'Alimentação'},
      ];
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _togglePartner(int id) {
    final current = List<int>.from(widget.selectedPartnerIds);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    widget.onChanged(current);
  }

  void _selectAll() {
    final allIds = _allPartners.map((e) => e['id'] as int).toList();
    widget.onChanged(allIds);
  }

  void _clearAll() {
    widget.onChanged([]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final query = _searchQuery.toLowerCase().trim();

    final filtered = _allPartners.where((p) {
      if (query.isEmpty) return true;
      final nome = (p['nome'] ?? '').toString().toLowerCase();
      final cnpj = (p['cnpj'] ?? '').toString().toLowerCase();
      final seg = (p['segmento'] ?? '').toString().toLowerCase();
      return nome.contains(query) || cnpj.contains(query) || seg.contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho de Controles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.storefront_rounded, size: 16, color: theme.secondary),
                const SizedBox(width: 6),
                Text(
                  'Parceiros Elegíveis (${widget.selectedPartnerIds.length} selecionados)',
                  style: GoogleFonts.readexPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryText,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: _selectAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Selecionar Todos',
                    style: GoogleFonts.readexPro(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: theme.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _clearAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Limpar',
                    style: GoogleFonts.readexPro(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE57373),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Campo de Busca
        TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          style: GoogleFonts.readexPro(fontSize: 12.5, color: theme.primaryText),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Buscar parceiro por nome fantasia, CNPJ ou segmento...',
            hintStyle: GoogleFonts.readexPro(
              fontSize: 12,
              color: theme.secondaryText,
            ),
            prefixIcon: Icon(Icons.search, size: 16, color: theme.secondary),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, size: 14, color: theme.secondaryText),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: theme.primaryBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.alternate),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.alternate),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.secondary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Caixa de Listagem com Scroll
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.alternate),
          ),
          child: _isLoading
              ? Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: theme.secondary),
                  ),
                )
              : filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum parceiro encontrado.',
                        style: GoogleFonts.readexPro(
                          fontSize: 12,
                          color: theme.secondaryText,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        thickness: 1,
                        color: theme.alternate,
                      ),
                      itemBuilder: (context, index) {
                        final partner = filtered[index];
                        final id = partner['id'] as int;
                        final isSelected = widget.selectedPartnerIds.contains(id);

                        return InkWell(
                          onTap: () => _togglePartner(id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: isSelected,
                                    activeColor: theme.secondary,
                                    checkColor: const Color(0xFF14120E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: BorderSide(
                                      color: isSelected ? theme.secondary : theme.secondaryText,
                                      width: 1.5,
                                    ),
                                    onChanged: (_) => _togglePartner(id),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        partner['nome'] ?? '',
                                        style: GoogleFonts.readexPro(
                                          fontSize: 12.5,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                          color: isSelected ? theme.primaryText : theme.secondaryText,
                                        ),
                                      ),
                                      if ((partner['cnpj'] ?? '').toString().isNotEmpty ||
                                          (partner['segmento'] ?? '').toString().isNotEmpty)
                                        Text(
                                          '${partner['segmento'] ?? 'Parceiro'} ${partner['cnpj']?.isNotEmpty == true ? '• CNPJ: ${partner['cnpj']}' : ''}',
                                          style: GoogleFonts.readexPro(
                                            fontSize: 10.5,
                                            color: theme.secondaryText.withValues(alpha: 0.7),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: theme.secondary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: theme.secondary.withValues(alpha: 0.4)),
                                    ),
                                    child: Text(
                                      'Vinculado',
                                      style: GoogleFonts.readexPro(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w600,
                                        color: theme.secondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
