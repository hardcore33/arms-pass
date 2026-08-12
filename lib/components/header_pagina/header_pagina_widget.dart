import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderPaginaWidget extends StatelessWidget {
  const HeaderPaginaWidget({
    super.key,
    required this.titulo,
    this.breadcrumb = 'Painel',
    this.descricao,
    this.action,
  });

  final String titulo;
  final String breadcrumb;
  final String? descricao;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$breadcrumb  /  $titulo',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: theme.labelMedium.override(
                    font: GoogleFonts.readexPro(),
                    color: theme.secondary,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  titulo,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: theme.headlineMedium.override(
                    font: GoogleFonts.readexPro(),
                    color: theme.secondaryBackground,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (descricao != null) ...[
                  const SizedBox(height: 6.0),
                  Text(
                    descricao!,
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.readexPro(),
                      color: theme.secondaryText,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 16.0),
            action!,
          ],
        ],
      ),
    );
  }
}
