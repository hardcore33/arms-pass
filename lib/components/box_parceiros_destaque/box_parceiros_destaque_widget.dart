import 'dart:async';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoxParceirosDestaqueWidget extends StatefulWidget {
  const BoxParceirosDestaqueWidget({
    super.key,
    required this.cupons,
    this.trocas,
  });

  final List<dynamic> cupons;
  final List<dynamic>? trocas;

  @override
  State<BoxParceirosDestaqueWidget> createState() =>
      _BoxParceirosDestaqueWidgetState();
}

class _BoxParceirosDestaqueWidgetState
    extends State<BoxParceirosDestaqueWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  late List<_PartnerData> partners;

  List<_PartnerData> _buildRanking() {
    final Map<String, _PartnerAggData> byPartner = {};

    // 1. Mapeia parceiros a partir dos cupons
    for (final cupom in widget.cupons) {
      if (cupom is! Map) continue;
      final partner = cupom['partner'];
      if (partner is! Map) continue;
      final id = partner['id']?.toString();
      if (id == null) continue;
      final fantasia = (partner['fantasia'] ?? partner['nome'] ?? '').toString();
      final photo = (partner['photo'] ?? '').toString();
      final agg = byPartner.putIfAbsent(
        id,
        () => _PartnerAggData(id: id, name: fantasia, photo: photo),
      );
      if (cupom['isActive'] == true) {
        agg.activeCount++;
      }
    }

    // 2. Mapeia trocas/validações realizadas em cada parceiro
    for (final troca in widget.trocas ?? []) {
      if (troca is! Map) continue;
      String? partnerId;
      String? partnerName;
      String? partnerPhoto;

      final partner = troca['partner'];
      if (partner is Map) {
        partnerId = partner['id']?.toString();
        partnerName = (partner['fantasia'] ?? partner['nome'] ?? partner['name'])?.toString();
        partnerPhoto = partner['photo']?.toString();
      } else if (partner != null && partner.toString().isNotEmpty && partner.toString() != 'null') {
        partnerId = partner.toString();
      }

      _PartnerAggData? targetAgg;
      if (partnerId != null && byPartner.containsKey(partnerId)) {
        targetAgg = byPartner[partnerId];
      } else if (partnerName != null && partnerName.isNotEmpty) {
        for (final p in byPartner.values) {
          if (p.name.toLowerCase() == partnerName.toLowerCase()) {
            targetAgg = p;
            break;
          }
        }
        if (targetAgg == null) {
          final newKey = partnerId ?? partnerName;
          targetAgg = byPartner.putIfAbsent(
            newKey,
            () => _PartnerAggData(
              id: newKey,
              name: partnerName!,
              photo: partnerPhoto ?? '',
            ),
          );
        }
      }

      if (targetAgg != null) {
        targetAgg.usedCount++;
      }
    }

    // Ordena pelo número de cupons utilizados (se houver empate, por cupons ativos)
    final ranked = byPartner.values.toList()
      ..sort((a, b) {
        final cmp = b.usedCount.compareTo(a.usedCount);
        if (cmp != 0) return cmp;
        return b.activeCount.compareTo(a.activeCount);
      });

    final top = ranked.take(3).toList();
    const highlights = [
      '🏆 Mais cupons utilizados',
      '2º em cupons utilizados',
      '3º em cupons utilizados'
    ];

    if (top.isEmpty) {
      return [
        _PartnerData(
          name: 'Nenhum parceiro',
          photo: '',
          countLabel: '0 cupons utilizados',
          highlight: 'Sem movimentação',
        )
      ];
    }

    return List.generate(top.length, (i) {
      final used = top[i].usedCount;
      return _PartnerData(
        name: top[i].name,
        photo: top[i].photo,
        countLabel: '$used cupom${used == 1 ? '' : 's'} utilizado${used == 1 ? '' : 's'}',
        highlight: highlights[i],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    partners = _buildRanking();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (partners.isEmpty) return;
      if (_currentPage < partners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant BoxParceirosDestaqueWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cupons != widget.cupons || oldWidget.trocas != widget.trocas) {
      setState(() {
        partners = _buildRanking();
        if (_currentPage >= partners.length) {
          _currentPage = 0;
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        height: 198.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 22.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Parceiros em Destaque',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                            ),
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: 16.0,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: partners.length,
                itemBuilder: (context, index) {
                  final partner = partners[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondary
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: partner.photo.isNotEmpty &&
                                      partner.photo != 'null'
                                  ? ClipOval(
                                      child: Image.network(
                                        partner.photo,
                                        width: 48.0,
                                        height: 48.0,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                          Icons.storefront_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 24.0,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.storefront_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 24.0,
                                    ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    partner.name,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.openSans(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2A2A2A),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(
                                      partner.highlight,
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.openSans(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            color: Colors.white,
                                            fontSize: 10.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cupons utilizados:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.openSans(),
                                    color: const Color(0xFFD4D4D4),
                                  ),
                            ),
                            Text(
                              partner.countLabel,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    fontSize: 16.0,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page Indicator dots
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  partners.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == index ? 10.0 : 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? FlutterFlowTheme.of(context).secondary
                          : FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerData {
  final String name;
  final String photo;
  final String countLabel;
  final String highlight;

  _PartnerData({
    required this.name,
    required this.photo,
    required this.countLabel,
    required this.highlight,
  });
}

class _PartnerAggData {
  final String id;
  final String name;
  final String photo;
  int activeCount = 0;
  int usedCount = 0;

  _PartnerAggData({
    required this.id,
    required this.name,
    required this.photo,
  });
}
