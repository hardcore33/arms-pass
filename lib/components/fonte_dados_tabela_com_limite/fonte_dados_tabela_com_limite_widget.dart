import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'fonte_dados_tabela_com_limite_model.dart';
export 'fonte_dados_tabela_com_limite_model.dart';

class FonteDadosTabelaComLimiteWidget extends StatefulWidget {
  const FonteDadosTabelaComLimiteWidget({
    super.key,
    this.text,
  });

  final String? text;

  @override
  State<FonteDadosTabelaComLimiteWidget> createState() =>
      _FonteDadosTabelaComLimiteWidgetState();
}

class _FonteDadosTabelaComLimiteWidgetState
    extends State<FonteDadosTabelaComLimiteWidget> {
  late FonteDadosTabelaComLimiteModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FonteDadosTabelaComLimiteModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      valueOrDefault<String>(
        widget!.text,
        'texto',
      ).maybeHandleOverflow(
        maxChars: 30,
        replacement: '…',
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.openSans(
              fontWeight: FontWeight.normal,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            fontSize: 15.5,
            letterSpacing: 0.0,
            fontWeight: FontWeight.normal,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
    );
  }
}
