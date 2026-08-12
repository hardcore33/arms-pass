import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'box_indicadores_model.dart';
export 'box_indicadores_model.dart';

class BoxIndicadoresWidget extends StatefulWidget {
  const BoxIndicadoresWidget({
    super.key,
    required this.titulo,
    required this.dado,
    required this.icon,
    this.destaque = false,
    this.onTap,
    this.trend,
  });

  final String? titulo;
  final String? dado;
  final Widget? icon;
  final bool destaque;
  final VoidCallback? onTap;
  // Texto opcional de variação percentual vs período anterior, ex: "+12,5%".
  // Prefixo "+" pinta em verde, "-" em vermelho vermelho, o resto em cinza.
  final String? trend;

  @override
  State<BoxIndicadoresWidget> createState() => _BoxIndicadoresWidgetState();
}

class _BoxIndicadoresWidgetState extends State<BoxIndicadoresWidget> {
  late BoxIndicadoresModel _model;
  bool _isHovered = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BoxIndicadoresModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = true;
    final cardBgColor = FlutterFlowTheme.of(context).primary;
    final borderColor = widget.destaque
        ? FlutterFlowTheme.of(context).secondary
        : FlutterFlowTheme.of(context).alternate;
    final titleColor = widget.destaque
        ? FlutterFlowTheme.of(context).secondary
        : FlutterFlowTheme.of(context).secondaryText;
    final valueColor = Colors.white;
    final circleBgColor = widget.destaque
        ? FlutterFlowTheme.of(context).secondary.withOpacity(0.25)
        : FlutterFlowTheme.of(context).secondary.withOpacity(0.15);

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => safeSetState(() => _isHovered = true),
      onExit: (_) => safeSetState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? (Matrix4.identity()..translate(0.0, -4.0, 0.0))
            : Matrix4.identity(),
        child: Material(
          color: Colors.transparent,
          elevation: _isHovered ? 8.0 : 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              height: 120.0,
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: borderColor,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            valueOrDefault<String>(widget!.titulo, 'Título'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: titleColor,
                                  fontSize: 13.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          const SizedBox(height: 8.0),
                          AutoSizeText(
                            valueOrDefault<String>(widget!.dado, '0'),
                            maxLines: 1,
                            minFontSize: 16.0,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  color: valueColor,
                                  fontSize: 24.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          if (widget.trend != null) ...[
                            const SizedBox(height: 4.0),
                            _buildTrendBadge(widget.trend!),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: circleBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget!.icon!,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendBadge(String trend) {
    final isPositive = trend.trimLeft().startsWith('+');
    final isNegative = trend.trimLeft().startsWith('-');
    final color = isPositive
        ? const Color(0xFF00C853)
        : isNegative
            ? const Color(0xFFFF5963)
            : Colors.grey;
    final arrow = isPositive
        ? Icons.arrow_upward_rounded
        : isNegative
            ? Icons.arrow_downward_rounded
            : Icons.remove_rounded;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(arrow, color: color, size: 12.0),
        const SizedBox(width: 2.0),
        Flexible(
          child: Text(
            trend,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
