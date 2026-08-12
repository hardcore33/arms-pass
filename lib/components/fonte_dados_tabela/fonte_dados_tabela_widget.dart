import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'fonte_dados_tabela_model.dart';
export 'fonte_dados_tabela_model.dart';

class FonteDadosTabelaWidget extends StatefulWidget {
  const FonteDadosTabelaWidget({
    super.key,
    this.text,
  });

  final String? text;

  @override
  State<FonteDadosTabelaWidget> createState() => _FonteDadosTabelaWidgetState();
}

class _FonteDadosTabelaWidgetState extends State<FonteDadosTabelaWidget> {
  late FonteDadosTabelaModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FonteDadosTabelaModel());

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
      ),
      textAlign: TextAlign.center,
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
