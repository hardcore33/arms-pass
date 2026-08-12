import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'fonte_titulo_modal_model.dart';
export 'fonte_titulo_modal_model.dart';

class FonteTituloModalWidget extends StatefulWidget {
  const FonteTituloModalWidget({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  State<FonteTituloModalWidget> createState() => _FonteTituloModalWidgetState();
}

class _FonteTituloModalWidgetState extends State<FonteTituloModalWidget> {
  late FonteTituloModalModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FonteTituloModalModel());

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
        'text',
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.openSans(
              fontWeight: FontWeight.w500,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            color: FlutterFlowTheme.of(context).secondary,
            fontSize: 24.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
    );
  }
}
