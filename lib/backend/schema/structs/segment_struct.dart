// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SegmentStruct extends BaseStruct {
  SegmentStruct({
    int? id,
    String? name,
    String? photo,
  })  : _id = id,
        _name = name,
        _photo = photo;

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

  // "photo" field.
  String? _photo;
  String get photo => _photo ?? '';
  set photo(String? val) => _photo = val;

  bool hasPhoto() => _photo != null;

  static SegmentStruct fromMap(Map<String, dynamic> data) => SegmentStruct(
        id: castToType<int>(data['id']),
        name: data['name'] as String?,
        photo: data['photo'] as String?,
      );

  static SegmentStruct? maybeFromMap(dynamic data) =>
      data is Map ? SegmentStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'photo': _photo,
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
        'photo': serializeParam(
          _photo,
          ParamType.String,
        ),
      }.withoutNulls;

  static SegmentStruct fromSerializableMap(Map<String, dynamic> data) =>
      SegmentStruct(
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
        photo: deserializeParam(
          data['photo'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SegmentStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SegmentStruct &&
        id == other.id &&
        name == other.name &&
        photo == other.photo;
  }

  @override
  int get hashCode => const ListEquality().hash([id, name, photo]);
}

SegmentStruct createSegmentStruct({
  int? id,
  String? name,
  String? photo,
}) =>
    SegmentStruct(
      id: id,
      name: name,
      photo: photo,
    );
