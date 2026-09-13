import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  late SharedPreferences prefs;

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      final rawParceiro = prefs.getString('ff_parceiro');
      if (rawParceiro != null && rawParceiro.isNotEmpty) {
        try {
          _parceiro = jsonDecode(rawParceiro);
        } catch (_) {
          _parceiro = rawParceiro;
        }
      }
    });
    _safeInit(() {
      _sidebarCollapsed =
          prefs.getBool('ff_sidebarCollapsed') ?? _sidebarCollapsed;
    });
  }

  void _safeInit(Function() initializeField) {
    try {
      initializeField();
    } catch (_) {}
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  int _indexPage = 1;
  int get indexPage => _indexPage;
  set indexPage(int value) {
    _indexPage = value;
    notifyListeners();
  }

  dynamic _parceiro;
  dynamic get parceiro => _parceiro;
  set parceiro(dynamic value) {
    _parceiro = value;
    try {
      if (value != null) {
        if (value is String) {
          prefs.setString('ff_parceiro', value);
        } else {
          prefs.setString('ff_parceiro', jsonEncode(value));
        }
      } else {
        prefs.remove('ff_parceiro');
      }
    } catch (_) {}
  }

  bool _sidebarCollapsed = false;
  bool get sidebarCollapsed => _sidebarCollapsed;
  set sidebarCollapsed(bool value) {
    _sidebarCollapsed = value;
    prefs.setBool('ff_sidebarCollapsed', value);
    notifyListeners();
  }
}
