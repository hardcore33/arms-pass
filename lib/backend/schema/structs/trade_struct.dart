// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TradeStruct extends BaseStruct {
  TradeStruct({
    String? status,
  }) : _status = status;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  static TradeStruct fromMap(Map<String, dynamic> data) => TradeStruct(
        status: data['status'] as String?,
      );

  static TradeStruct? maybeFromMap(dynamic data) =>
      data is Map ? TradeStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'status': _status,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
      }.withoutNulls;

  static TradeStruct fromSerializableMap(Map<String, dynamic> data) =>
      TradeStruct(
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TradeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TradeStruct && status == other.status;
  }

  @override
  int get hashCode => const ListEquality().hash([status]);
}

TradeStruct createTradeStruct({
  String? status,
}) =>
    TradeStruct(
      status: status,
    );
