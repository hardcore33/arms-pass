import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/plans_and_subscriptions_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

enum TipoAcaoAssinatura {
  cancelar,
  renovar,
  estornar,
}

class ModalAcaoAssinaturaWidget extends StatefulWidget {
  const ModalAcaoAssinaturaWidget({
    super.key,
    required this.subscription,
    required this.tipoAcao,
  });

  final SubscriptionMemberModel subscription;
  final TipoAcaoAssinatura tipoAcao;

  @override
  State<ModalAcaoAssinaturaWidget> createState() => _ModalAcaoAssinaturaWidgetState();
}

class _ModalAcaoAssinaturaWidgetState extends State<ModalAcaoAssinaturaWidget> {
  final TextEditingController _motivoController = TextEditingController();
  DateTime _dataRenovacao = DateTime.now().add(const Duration(days: 30));
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    if (widget.tipoAcao == TipoAcaoAssinatura.renovar) {
      final sub = widget.subscription;
      _dataRenovacao = sub.nextBillingDate.isBefore(DateTime.now())
          ? DateTime.now().add(const Duration(days: 30))
          : sub.nextBillingDate.add(const Duration(days: 30));
    }
  }

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _executarAcao() async {
    setState(() => _isProcessing = true);
    final service = PlansAndSubscriptionsService();
    final sub = widget.subscription;

    try {
      switch (widget.tipoAcao) {
        case TipoAcaoAssinatura.cancelar:
          final motivo = _motivoController.text.trim();
          await service.cancelSubscription(
            sub.id,
            reason: motivo.isNotEmpty ? motivo : 'Cancelado pelo Administrador',
          );
          if (mounted) {
            Navigator.pop(context, true);
            showSuccessToast(
              context,
              'Assinatura de ${sub.userName} cancelada com sucesso.',
              title: 'Plano Cancelado',
            );
          }
          break;

        case TipoAcaoAssinatura.renovar:
          await service.renewSubscription(
            sub.id,
            newNextBillingDate: _dataRenovacao,
          );
          if (mounted) {
            Navigator.pop(context, true);
            showSuccessToast(
              context,
              'Assinatura renovada até ${dateTimeFormat('d/M/y', _dataRenovacao)}.',
              title: 'Renovação Efetuada',
            );
          }
          break;

        case TipoAcaoAssinatura.estornar:
          final motivo = _motivoController.text.trim();
          await service.refundSubscription(
            sub.id,
            reason: motivo.isNotEmpty ? motivo : 'Estorno administrativo efetuado',
          );
          if (mounted) {
            Navigator.pop(context, true);
            showSuccessToast(
              context,
              'Estorno e cancelamento de ${sub.userName} processados.',
              title: 'Estorno Realizado',
            );
          }
          break;
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(context, 'Falha ao processar ação: $e');
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final sub = widget.subscription;

    String titulo;
    String descricao;
    IconData icone;
    Color corAcao;
    String textoBotao;

    switch (widget.tipoAcao) {
      case TipoAcaoAssinatura.cancelar:
        titulo = 'Cancelar Assinatura';
        descricao = 'Você está prestes a cancelar a assinatura de ${sub.userName}. O plano deixará de ser renovado.';
        icone = Icons.cancel_outlined;
        corAcao = const Color(0xFFE57373);
        textoBotao = 'Confirmar Cancelamento';
        break;
      case TipoAcaoAssinatura.renovar:
        titulo = 'Renovar Assinatura Manualmente';
        descricao = 'Defina a nova data de vencimento e reative a assinatura do membro ${sub.userName}.';
        icone = Icons.autorenew_rounded;
        corAcao = theme.secondary;
        textoBotao = 'Confirmar Renovação';
        break;
      case TipoAcaoAssinatura.estornar:
        titulo = 'Estornar Pagamento';
        descricao = 'Atenção: o estorno devolverá os valores pagos de R\$ ${sub.amountPaid.toStringAsFixed(2)} e cancelará o plano imediatamente.';
        icone = Icons.currency_exchange_rounded;
        corAcao = const Color(0xFFEF5350);
        textoBotao = 'Confirmar Estorno';
        break;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.alternate, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: corAcao.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icone, color: corAcao, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryText,
                          ),
                        ),
                        Text(
                          sub.planName,
                          style: GoogleFonts.readexPro(
                            fontSize: 12,
                            color: theme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.secondaryText, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(color: theme.alternate, height: 1),

            // Conteúdo
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    descricao,
                    style: GoogleFonts.readexPro(
                      fontSize: 13,
                      color: theme.secondaryText,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dados do Membro
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.alternate),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Membro:',
                              style: GoogleFonts.readexPro(fontSize: 12, color: theme.secondaryText),
                            ),
                            Text(
                              sub.userName,
                              style: GoogleFonts.readexPro(fontSize: 12, color: theme.primaryText, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status Atual:',
                              style: GoogleFonts.readexPro(fontSize: 12, color: theme.secondaryText),
                            ),
                            Text(
                              sub.status,
                              style: GoogleFonts.readexPro(fontSize: 12, color: theme.primary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  if (widget.tipoAcao == TipoAcaoAssinatura.renovar) ...[
                    Text(
                      'Nova Data de Renovação:',
                      style: GoogleFonts.readexPro(fontSize: 12.5, fontWeight: FontWeight.w600, color: theme.primaryText),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: theme.primaryBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: theme.alternate),
                            ),
                            child: Text(
                              dateTimeFormat('d/M/y', _dataRenovacao),
                              style: GoogleFonts.readexPro(fontSize: 13, color: theme.primaryText, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _dataRenovacao,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: theme.primary,
                                      onPrimary: Colors.white,
                                      surface: theme.secondaryBackground,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() => _dataRenovacao = picked);
                            }
                          },
                          icon: const Icon(Icons.calendar_month, size: 16),
                          label: Text('Alterar Data', style: GoogleFonts.readexPro(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryBackground,
                            foregroundColor: theme.primaryText,
                            side: BorderSide(color: theme.alternate),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      'Motivo / Justificativa:',
                      style: GoogleFonts.readexPro(fontSize: 12.5, fontWeight: FontWeight.w600, color: theme.primaryText),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _motivoController,
                      style: GoogleFonts.readexPro(fontSize: 13, color: theme.primaryText),
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: widget.tipoAcao == TipoAcaoAssinatura.cancelar
                            ? 'Ex.: Solicitação do cliente, mudança de cidade...'
                            : 'Ex.: Cobrança indevida, estorno aprovado...',
                        hintStyle: GoogleFonts.readexPro(fontSize: 12, color: theme.secondaryText.withValues(alpha: 0.7)),
                        filled: true,
                        fillColor: theme.primaryBackground,
                        contentPadding: const EdgeInsets.all(12),
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
                          borderSide: BorderSide(color: corAcao, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme.alternate, width: 1.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isProcessing ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.secondaryText,
                      side: BorderSide(color: theme.alternate),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Voltar',
                      style: GoogleFonts.readexPro(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _executarAcao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corAcao,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 2,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            textoBotao,
                            style: GoogleFonts.readexPro(fontSize: 13, fontWeight: FontWeight.bold),
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
