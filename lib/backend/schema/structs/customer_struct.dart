// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CustomerStruct extends BaseStruct {
  CustomerStruct({
    int? id,
    String? name,
    String? cardNumber,
    String? cpf,
    bool? isActive,
    TenantStruct? tenant,
    WalletStruct? wallet,
    UserStruct? user,
    PartnerStruct? partner,
  })  : _id = id,
        _name = name,
        _cardNumber = cardNumber,
        _cpf = cpf,
        _isActive = isActive,
        _tenant = tenant,
        _wallet = wallet,
        _user = user,
        _partner = partner;

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

  // "cardNumber" field.
  String? _cardNumber;
  String get cardNumber => _cardNumber ?? '';
  set cardNumber(String? val) => _cardNumber = val;

  bool hasCardNumber() => _cardNumber != null;

  // "cpf" field.
  String? _cpf;
  String get cpf => _cpf ?? '';
  set cpf(String? val) => _cpf = val;

  bool hasCpf() => _cpf != null;

  // "isActive" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  set isActive(bool? val) => _isActive = val;

  bool hasIsActive() => _isActive != null;

  // "tenant" field.
  TenantStruct? _tenant;
  TenantStruct get tenant => _tenant ?? TenantStruct();
  set tenant(TenantStruct? val) => _tenant = val;

  void updateTenant(Function(TenantStruct) updateFn) {
    updateFn(_tenant ??= TenantStruct());
  }

  bool hasTenant() => _tenant != null;

  // "wallet" field.
  WalletStruct? _wallet;
  WalletStruct get wallet => _wallet ?? WalletStruct();
  set wallet(WalletStruct? val) => _wallet = val;

  void updateWallet(Function(WalletStruct) updateFn) {
    updateFn(_wallet ??= WalletStruct());
  }

  bool hasWallet() => _wallet != null;

  // "user" field.
  UserStruct? _user;
  UserStruct get user => _user ?? UserStruct();
  set user(UserStruct? val) => _user = val;

  void updateUser(Function(UserStruct) updateFn) {
    updateFn(_user ??= UserStruct());
  }

  bool hasUser() => _user != null;

  // "partner" field.
  PartnerStruct? _partner;
  PartnerStruct get partner => _partner ?? PartnerStruct();
  set partner(PartnerStruct? val) => _partner = val;

  void updatePartner(Function(PartnerStruct) updateFn) {
    updateFn(_partner ??= PartnerStruct());
  }

  bool hasPartner() => _partner != null;

  static CustomerStruct fromMap(Map<String, dynamic> data) => CustomerStruct(
        id: castToType<int>(data['id']),
        name: data['name'] as String?,
        cardNumber: data['cardNumber'] as String?,
        cpf: data['cpf'] as String?,
        isActive: data['isActive'] as bool?,
        tenant: data['tenant'] is TenantStruct
            ? data['tenant']
            : TenantStruct.maybeFromMap(data['tenant']),
        wallet: data['wallet'] is WalletStruct
            ? data['wallet']
            : WalletStruct.maybeFromMap(data['wallet']),
        user: data['user'] is UserStruct
            ? data['user']
            : UserStruct.maybeFromMap(data['user']),
        partner: data['partner'] is PartnerStruct
            ? data['partner']
            : PartnerStruct.maybeFromMap(data['partner']),
      );

  static CustomerStruct? maybeFromMap(dynamic data) =>
      data is Map ? CustomerStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'cardNumber': _cardNumber,
        'cpf': _cpf,
        'isActive': _isActive,
        'tenant': _tenant?.toMap(),
        'wallet': _wallet?.toMap(),
        'user': _user?.toMap(),
        'partner': _partner?.toMap(),
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
        'cardNumber': serializeParam(
          _cardNumber,
          ParamType.String,
        ),
        'cpf': serializeParam(
          _cpf,
          ParamType.String,
        ),
        'isActive': serializeParam(
          _isActive,
          ParamType.bool,
        ),
        'tenant': serializeParam(
          _tenant,
          ParamType.DataStruct,
        ),
        'wallet': serializeParam(
          _wallet,
          ParamType.DataStruct,
        ),
        'user': serializeParam(
          _user,
          ParamType.DataStruct,
        ),
        'partner': serializeParam(
          _partner,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static CustomerStruct fromSerializableMap(Map<String, dynamic> data) =>
      CustomerStruct(
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
        cardNumber: deserializeParam(
          data['cardNumber'],
          ParamType.String,
          false,
        ),
        cpf: deserializeParam(
          data['cpf'],
          ParamType.String,
          false,
        ),
        isActive: deserializeParam(
          data['isActive'],
          ParamType.bool,
          false,
        ),
        tenant: deserializeStructParam(
          data['tenant'],
          ParamType.DataStruct,
          false,
          structBuilder: TenantStruct.fromSerializableMap,
        ),
        wallet: deserializeStructParam(
          data['wallet'],
          ParamType.DataStruct,
          false,
          structBuilder: WalletStruct.fromSerializableMap,
        ),
        user: deserializeStructParam(
          data['user'],
          ParamType.DataStruct,
          false,
          structBuilder: UserStruct.fromSerializableMap,
        ),
        partner: deserializeStructParam(
          data['partner'],
          ParamType.DataStruct,
          false,
          structBuilder: PartnerStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'CustomerStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CustomerStruct &&
        id == other.id &&
        name == other.name &&
        cardNumber == other.cardNumber &&
        cpf == other.cpf &&
        isActive == other.isActive &&
        tenant == other.tenant &&
        wallet == other.wallet &&
        user == other.user &&
        partner == other.partner;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [id, name, cardNumber, cpf, isActive, tenant, wallet, user, partner]);
}

CustomerStruct createCustomerStruct({
  int? id,
  String? name,
  String? cardNumber,
  String? cpf,
  bool? isActive,
  TenantStruct? tenant,
  WalletStruct? wallet,
  UserStruct? user,
  PartnerStruct? partner,
}) =>
    CustomerStruct(
      id: id,
      name: name,
      cardNumber: cardNumber,
      cpf: cpf,
      isActive: isActive,
      tenant: tenant ?? TenantStruct(),
      wallet: wallet ?? WalletStruct(),
      user: user ?? UserStruct(),
      partner: partner ?? PartnerStruct(),
    );
