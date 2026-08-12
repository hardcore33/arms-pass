import '/components/menu_parceiro_mobile/menu_parceiro_mobile_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'menu_mobile_model.dart';
export 'menu_mobile_model.dart';

class MenuMobileWidget extends StatefulWidget {
  const MenuMobileWidget({super.key});

  @override
  State<MenuMobileWidget> createState() => _MenuMobileWidgetState();
}

class _MenuMobileWidgetState extends State<MenuMobileWidget> {
  late MenuMobileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuMobileModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondary,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) => InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return Dialog(
                        elevation: 0,
                        insetPadding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        alignment: AlignmentDirectional(-1.0, 0.0)
                            .resolve(Directionality.of(context)),
                        child: MenuParceiroMobileWidget(),
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.menu,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: 150.0,
                height: 60.0,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(),
            ),
          ],
        ),
      ),
    );
  }
}
