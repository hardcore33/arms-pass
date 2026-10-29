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
    const cardBgColor = Color(0xFFFAF7F2);
    final borderColor = widget.destaque
        ? const Color(0xFF8C8268)
        : const Color(0xFFC5BCA8);
    final titleColor = const Color(0xFF64748B);
    const valueColor = Color(0xFF0F172A);
    final circleBgColor = widget.destaque
        ? const Color(0xFFACA48D)
        : const Color(0xFFE8E3D7);

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => safeSetState(() => _isHovered = true),
      onExit: (_) => safeSetState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? (Matrix4.identity()..translate(0.0, -3.0, 0.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: borderColor,
            width: widget.destaque ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0x140F172A)
                  : const Color(0x080F172A),
              blurRadius: _isHovered ? 16.0 : 8.0,
              offset: Offset(0, _isHovered ? 6.0 : 2.0),
            ),
          ],
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            height: 120.0,
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
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                          fontSize: 12.5,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      AutoSizeText(
                        valueOrDefault<String>(widget!.dado, '0'),
                        maxLines: 1,
                        minFontSize: 16.0,
                        style: GoogleFonts.readexPro(
                          fontWeight: FontWeight.bold,
                          color: valueColor,
                          fontSize: 24.0,
                          letterSpacing: -0.5,
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
    );
  }

  Widget _buildTrendBadge(String trend) {
    final isPositive = trend.trimLeft().startsWith('+');
    final isNegative = trend.trimLeft().startsWith('-');
    final textColor = isPositive
        ? const Color(0xFF047857)
        : isNegative
            ? const Color(0xFFDC2626)
            : const Color(0xFF64748B);
    final bgColor = isPositive
        ? const Color(0xFFECFDF5)
        : isNegative
            ? const Color(0xFFFEF2F2)
            : const Color(0xFFE8E3D7);
    final arrow = isPositive
        ? Icons.arrow_upward_rounded
        : isNegative
            ? Icons.arrow_downward_rounded
            : Icons.remove_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(arrow, color: textColor, size: 11.0),
          const SizedBox(width: 2.0),
          Flexible(
            child: Text(
              trend,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
