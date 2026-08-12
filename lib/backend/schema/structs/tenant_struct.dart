// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TenantStruct extends BaseStruct {
  TenantStruct({
    int? id,
    String? name,
    AdressStruct? adress,
  })  : _id = id,
        _name = name,
        _adress = adress;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "adress" field.
  AdressStruct? _adress;
  AdressStruct get adress => _adress ?? AdressStruct();
  set adress(AdressStruct? val) => _adress = val;

  void updateAdress(Function(AdressStruct) updateFn) {
    updateFn(_adress ??= AdressStruct());
  }

  bool hasAdress() => _adress != null;

  static TenantStruct fromMap(Map<String, dynamic> data) => TenantStruct(
        id: castToType<int>(data['id']),
        name: data['name'] as String?,
        adress: data['adress'] is AdressStruct
            ? data['adress']
            : AdressStruct.maybeFromMap(data['adress']),
      );

  static TenantStruct? maybeFromMap(dynamic data) =>
      data is Map ? TenantStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'adress': _adress?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'adress': serializeParam(
          _adress,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static TenantStruct fromSerializableMap(Map<String, dynamic> data) =>
      TenantStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        adress: deserializeStructParam(
          data['adress'],
          ParamType.DataStruct,
          false,
          structBuilder: AdressStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'TenantStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TenantStruct &&
        id == other.id &&
        name == other.name &&
        adress == other.adress;
  }

  @override
  int get hashCode => const ListEquality().hash([id, name, adress]);
}

TenantStruct createTenantStruct({
  int? id,
  String? name,
  AdressStruct? adress,
}) =>
    TenantStruct(
      id: id,
      name: name,
      adress: adress ?? AdressStruct(),
    );
