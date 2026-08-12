// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AdressStruct extends BaseStruct {
  AdressStruct({
    int? id,
    String? city,
    String? neighborhood,
    int? number,
    String? state,
    String? rua,
    String? zipcode,
  })  : _id = id,
        _city = city,
        _neighborhood = neighborhood,
        _number = number,
        _state = state,
        _rua = rua,
        _zipcode = zipcode;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "neighborhood" field.
  String? _neighborhood;
  String get neighborhood => _neighborhood ?? '';
  set neighborhood(String? val) => _neighborhood = val;

  bool hasNeighborhood() => _neighborhood != null;

  // "number" field.
  int? _number;
  int get number => _number ?? 0;
  set number(int? val) => _number = val;

  void incrementNumber(int amount) => number = number + amount;

  bool hasNumber() => _number != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "rua" field.
  String? _rua;
  String get rua => _rua ?? '';
  set rua(String? val) => _rua = val;

  bool hasRua() => _rua != null;

  // "zipcode" field.
  String? _zipcode;
  String get zipcode => _zipcode ?? '';
  set zipcode(String? val) => _zipcode = val;

  bool hasZipcode() => _zipcode != null;

  static AdressStruct fromMap(Map<String, dynamic> data) => AdressStruct(
        id: castToType<int>(data['id']),
        city: data['city'] as String?,
        neighborhood: data['neighborhood'] as String?,
        number: castToType<int>(data['number']),
        state: data['state'] as String?,
        rua: data['rua'] as String?,
        zipcode: data['zipcode'] as String?,
      );

  static AdressStruct? maybeFromMap(dynamic data) =>
      data is Map ? AdressStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'city': _city,
        'neighborhood': _neighborhood,
        'number': _number,
        'state': _state,
        'rua': _rua,
        'zipcode': _zipcode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'neighborhood': serializeParam(
          _neighborhood,
          ParamType.String,
        ),
        'number': serializeParam(
          _number,
          ParamType.int,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'rua': serializeParam(
          _rua,
          ParamType.String,
        ),
        'zipcode': serializeParam(
          _zipcode,
          ParamType.String,
        ),
      }.withoutNulls;

  static AdressStruct fromSerializableMap(Map<String, dynamic> data) =>
      AdressStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        neighborhood: deserializeParam(
          data['neighborhood'],
          ParamType.String,
          false,
        ),
        number: deserializeParam(
          data['number'],
          ParamType.int,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        rua: deserializeParam(
          data['rua'],
          ParamType.String,
          false,
        ),
        zipcode: deserializeParam(
          data['zipcode'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AdressStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AdressStruct &&
        id == other.id &&
        city == other.city &&
        neighborhood == other.neighborhood &&
        number == other.number &&
        state == other.state &&
        rua == other.rua &&
        zipcode == other.zipcode;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, city, neighborhood, number, state, rua, zipcode]);
}

AdressStruct createAdressStruct({
  int? id,
  String? city,
  String? neighborhood,
  int? number,
  String? state,
  String? rua,
  String? zipcode,
}) =>
    AdressStruct(
      id: id,
      city: city,
      neighborhood: neighborhood,
      number: number,
      state: state,
      rua: rua,
      zipcode: zipcode,
    );
