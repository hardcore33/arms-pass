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

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  int _indexPage = 1;
  int get indexPage => _indexPage;
  set indexPage(int value) {
    _indexPage = value;
  }

  dynamic _parceiro;
  dynamic get parceiro => _parceiro;
  set parceiro(dynamic value) {
    _parceiro = value;
  }

  bool _sidebarCollapsed = false;
  bool get sidebarCollapsed => _sidebarCollapsed;
  set sidebarCollapsed(bool value) {
    _sidebarCollapsed = value;
    notifyListeners();
  }
}
