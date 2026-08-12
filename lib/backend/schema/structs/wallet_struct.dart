// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WalletStruct extends BaseStruct {
  WalletStruct({
    int? pointsBalance,
    int? totalSavings,
    int? id,
  })  : _pointsBalance = pointsBalance,
        _totalSavings = totalSavings,
        _id = id;

  // "pointsBalance" field.
  int? _pointsBalance;
  int get pointsBalance => _pointsBalance ?? 0;
  set pointsBalance(int? val) => _pointsBalance = val;

  void incrementPointsBalance(int amount) =>
      pointsBalance = pointsBalance + amount;

  bool hasPointsBalance() => _pointsBalance != null;

  // "totalSavings" field.
  int? _totalSavings;
  int get totalSavings => _totalSavings ?? 0;
  set totalSavings(int? val) => _totalSavings = val;

  void incrementTotalSavings(int amount) =>
      totalSavings = totalSavings + amount;

  bool hasTotalSavings() => _totalSavings != null;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  static WalletStruct fromMap(Map<String, dynamic> data) => WalletStruct(
        pointsBalance: castToType<int>(data['pointsBalance']),
        totalSavings: castToType<int>(data['totalSavings']),
        id: castToType<int>(data['id']),
      );

  static WalletStruct? maybeFromMap(dynamic data) =>
      data is Map ? WalletStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'pointsBalance': _pointsBalance,
        'totalSavings': _totalSavings,
        'id': _id,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'pointsBalance': serializeParam(
          _pointsBalance,
          ParamType.int,
        ),
        'totalSavings': serializeParam(
          _totalSavings,
          ParamType.int,
        ),
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
      }.withoutNulls;

  static WalletStruct fromSerializableMap(Map<String, dynamic> data) =>
      WalletStruct(
        pointsBalance: deserializeParam(
          data['pointsBalance'],
          ParamType.int,
          false,
        ),
        totalSavings: deserializeParam(
          data['totalSavings'],
          ParamType.int,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'WalletStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WalletStruct &&
        pointsBalance == other.pointsBalance &&
        totalSavings == other.totalSavings &&
        id == other.id;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([pointsBalance, totalSavings, id]);
}

WalletStruct createWalletStruct({
  int? pointsBalance,
  int? totalSavings,
  int? id,
}) =>
    WalletStruct(
      pointsBalance: pointsBalance,
      totalSavings: totalSavings,
      id: id,
    );
