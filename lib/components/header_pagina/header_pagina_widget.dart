import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
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

    // Identifica o nome da empresa parceira logada
    final parceiroJson = FFAppState().parceiro;
    final String partnerFantasy = getJsonField(parceiroJson, r'$.partner.fantasy')?.toString() ?? '';
    final String partnerRazao = getJsonField(parceiroJson, r'$.partner.razaoSocial')?.toString() ?? '';
    final String customerName = getJsonField(parceiroJson, r'$.name')?.toString() ?? '';
    final String partnerName = partnerFantasy.isNotEmpty
        ? partnerFantasy
        : (partnerRazao.isNotEmpty ? partnerRazao : customerName);

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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
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
                    ),
                    if (partnerName.isNotEmpty) ...[
                      const SizedBox(width: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA49C88).withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(
                            color: const Color(0xFFA49C88).withValues(alpha: 0.4),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.storefront_rounded, size: 12.0, color: Color(0xFFA49C88)),
                            const SizedBox(width: 4.0),
                            Text(
                              partnerName.toUpperCase(),
                              style: GoogleFonts.openSans(
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFA49C88),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
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
          if (partnerName.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(right: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: const Color(0xFFA49C88).withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E7D32),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        partnerName,
                        style: GoogleFonts.openSans(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Unidade Parceira Conectada',
                        style: GoogleFonts.openSans(
                          fontSize: 10.5,
                          color: const Color(0xFFA49C88),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (action != null) ...[
            const SizedBox(width: 16.0),
            action!,
          ],
        ],
      ),
    );
  }
}

