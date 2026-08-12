import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoxSegmentosDestaqueWidget extends StatelessWidget {
  const BoxSegmentosDestaqueWidget({
    super.key,
    required this.cupons,
  });

  final List<dynamic> cupons;

  List<_SegmentData> _buildRanking() {
    // Agrupa os cupons ativos por segmento e conta quantos cada um tem.
    final Map<String, _SegmentAggData> bySegment = {};
    for (final cupom in cupons) {
      if (cupom is! Map || cupom['isActive'] != true) continue;
      final segment = cupom['segment'];
      if (segment is! Map) continue;
      final id = segment['id']?.toString();
      if (id == null) continue;
      final name = (segment['name'] ?? '').toString();
      final photo = (segment['photo'] ?? '').toString();
      final agg = bySegment.putIfAbsent(
        id,
        () => _SegmentAggData(name: name, photo: photo),
      );
      agg.count++;
    }
    final ranked = bySegment.values.toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    final top = ranked.take(3).toList();
    final maxCount = top.isNotEmpty ? top.first.count : 1;
    return top
        .map((seg) => _SegmentData(
              name: seg.name,
              photo: seg.photo,
              percentage: seg.count / maxCount,
              count:
                  '${seg.count} cupom${seg.count == 1 ? '' : 's'} ativo${seg.count == 1 ? '' : 's'}',
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final segments = _buildRanking();

    return Material(
      color: Colors.transparent,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      Icons.trending_up_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Segmentos em Destaque',
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: segments.map((seg) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 38.0,
                          height: 38.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondary
                                .withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: seg.photo.isNotEmpty && seg.photo != 'null'
                              ? ClipOval(
                                  child: Image.network(
                                    seg.photo,
                                    width: 38.0,
                                    height: 38.0,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                      Icons.sell_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 20.0,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.sell_rounded,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 20.0,
                                ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    seg.name,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.openSans(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          color: Colors.white,
                                          fontSize: 14.0,
                                        ),
                                  ),
                                  Text(
                                    seg.count,
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.openSans(),
                                          color: const Color(0xFFD4D4D4),
                                          fontSize: 11.0,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6.0),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: LinearProgressIndicator(
                                  value: seg.percentage,
                                  minHeight: 6.0,
                                  backgroundColor: const Color(0xFF2A2A2A),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentData {
  final String name;
  final String photo;
  final double percentage;
  final String count;

  _SegmentData({
    required this.name,
    required this.photo,
    required this.percentage,
    required this.count,
  });
}

class _SegmentAggData {
  final String name;
  final String photo;
  int count = 0;

  _SegmentAggData({required this.name, required this.photo});
}
