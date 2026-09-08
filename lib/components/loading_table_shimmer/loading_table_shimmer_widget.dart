import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class LoadingTableShimmerWidget extends StatelessWidget {
  final String? titulo;
  final int rowCount;

  const LoadingTableShimmerWidget({
    super.key,
    this.titulo,
    this.rowCount = 5,
  });

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double borderRadius = 6.0,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(
          duration: 1200.ms,
          color: const Color(0xFF3E3E42),
        );
  }

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Color(0xFF1E1E1E);
    const borderColor = Color(0xFF2C2C2C);

    return Material(
      color: Colors.transparent,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.74,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerBox(width: 180.0, height: 24.0, borderRadius: 8.0),
                Row(
                  children: [
                    _buildShimmerBox(width: 220.0, height: 40.0, borderRadius: 8.0),
                    const SizedBox(width: 16.0),
                    _buildShimmerBox(width: 140.0, height: 40.0, borderRadius: 8.0),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Linha de carregamento sutil
            ClipRRect(
              borderRadius: BorderRadius.circular(2.0),
              child: LinearProgressIndicator(
                minHeight: 2.0,
                backgroundColor: const Color(0xFF2C2C2C),
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).secondary,
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Table Header Shimmer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: _buildShimmerBox(width: 80.0, height: 14.0)),
                  const SizedBox(width: 16.0),
                  Expanded(flex: 2, child: _buildShimmerBox(width: 60.0, height: 14.0)),
                  const SizedBox(width: 16.0),
                  Expanded(flex: 2, child: _buildShimmerBox(width: 70.0, height: 14.0)),
                  const SizedBox(width: 16.0),
                  Expanded(flex: 2, child: _buildShimmerBox(width: 60.0, height: 14.0)),
                  const SizedBox(width: 16.0),
                  Expanded(flex: 1, child: _buildShimmerBox(width: 40.0, height: 14.0)),
                ],
              ),
            ),
            const SizedBox(height: 12.0),

            // Table Rows Shimmer
            Column(
              children: List.generate(
                rowCount,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: const Color(0xFF252525),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              _buildShimmerBox(width: 32.0, height: 32.0, borderRadius: 8.0),
                              const SizedBox(width: 12.0),
                              Expanded(child: _buildShimmerBox(width: 120.0, height: 14.0)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(flex: 2, child: _buildShimmerBox(width: 80.0, height: 14.0)),
                        const SizedBox(width: 16.0),
                        Expanded(flex: 2, child: _buildShimmerBox(width: 70.0, height: 14.0)),
                        const SizedBox(width: 16.0),
                        Expanded(flex: 2, child: _buildShimmerBox(width: 60.0, height: 14.0)),
                        const SizedBox(width: 16.0),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildShimmerBox(width: 28.0, height: 28.0, borderRadius: 6.0),
                              const SizedBox(width: 8.0),
                              _buildShimmerBox(width: 28.0, height: 28.0, borderRadius: 6.0),
                            ],
                          ),
                        ),
                      ],
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
