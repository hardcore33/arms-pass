import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'box_graficos_compras_mensais_model.dart';
export 'box_graficos_compras_mensais_model.dart';

class BoxGraficosComprasMensaisWidget extends StatefulWidget {
  const BoxGraficosComprasMensaisWidget({
    super.key,
    required this.titulo,
    required this.json,
  });

  final String? titulo;
  final dynamic json;

  @override
  State<BoxGraficosComprasMensaisWidget> createState() =>
      _BoxGraficosComprasMensaisWidgetState();
}

class _BoxGraficosComprasMensaisWidgetState
    extends State<BoxGraficosComprasMensaisWidget> {
  late BoxGraficosComprasMensaisModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BoxGraficosComprasMensaisModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.37,
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
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Text(
                  valueOrDefault<String>(
                    widget!.titulo,
                    'Título',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                        ),
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  width: 535.0,
                  height: 210.0,
                  child: custom_widgets.BarChartSample(
                    width: 535.0,
                    height: 210.0,
                    jsonData: widget!.json!,
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
