// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PartnerStruct extends BaseStruct {
  PartnerStruct({
    int? id,
    bool? isActive,
    String? razao,
    String? fantasia,
    String? cnpj,
    String? filial,
    SegmentStruct? segment,
    String? number,
    String? email,
    String? street,
    String? numberAdress,
    String? cep,
    String? neighborhood,
    String? city,
    String? contract,
    String? photo,
    String? state,
    String? representativeCpf,
    String? representativeRg,
    String? representativeNumber,
    String? representativeName,
    String? proposal,
    TenantStruct? tenant,
  })  : _id = id,
        _isActive = isActive,
        _razao = razao,
        _fantasia = fantasia,
        _cnpj = cnpj,
        _filial = filial,
        _segment = segment,
        _number = number,
        _email = email,
        _street = street,
        _numberAdress = numberAdress,
        _cep = cep,
        _neighborhood = neighborhood,
        _city = city,
        _contract = contract,
        _photo = photo,
        _state = state,
        _representativeCpf = representativeCpf,
        _representativeRg = representativeRg,
        _representativeNumber = representativeNumber,
        _representativeName = representativeName,
        _proposal = proposal,
        _tenant = tenant;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "isActive" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  set isActive(bool? val) => _isActive = val;

  bool hasIsActive() => _isActive != null;

  // "razao" field.
  String? _razao;
  String get razao => _razao ?? '';
  set razao(String? val) => _razao = val;

  bool hasRazao() => _razao != null;

  // "fantasia" field.
  String? _fantasia;
  String get fantasia => _fantasia ?? '';
  set fantasia(String? val) => _fantasia = val;

  bool hasFantasia() => _fantasia != null;

  // "cnpj" field.
  String? _cnpj;
  String get cnpj => _cnpj ?? '';
  set cnpj(String? val) => _cnpj = val;

  bool hasCnpj() => _cnpj != null;

  // "filial" field.
  String? _filial;
  String get filial => _filial ?? '';
  set filial(String? val) => _filial = val;

  bool hasFilial() => _filial != null;

  // "segment" field.
  SegmentStruct? _segment;
  SegmentStruct get segment => _segment ?? SegmentStruct();
  set segment(SegmentStruct? val) => _segment = val;

  void updateSegment(Function(SegmentStruct) updateFn) {
    updateFn(_segment ??= SegmentStruct());
  }

  bool hasSegment() => _segment != null;

  // "number" field.
  String? _number;
  String get number => _number ?? '';
  set number(String? val) => _number = val;

  bool hasNumber() => _number != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "street" field.
  String? _street;
  String get street => _street ?? '';
  set street(String? val) => _street = val;

  bool hasStreet() => _street != null;

  // "number_adress" field.
  String? _numberAdress;
  String get numberAdress => _numberAdress ?? '';
  set numberAdress(String? val) => _numberAdress = val;

  bool hasNumberAdress() => _numberAdress != null;

  // "cep" field.
  String? _cep;
  String get cep => _cep ?? '';
  set cep(String? val) => _cep = val;

  bool hasCep() => _cep != null;

  // "neighborhood" field.
  String? _neighborhood;
  String get neighborhood => _neighborhood ?? '';
  set neighborhood(String? val) => _neighborhood = val;

  bool hasNeighborhood() => _neighborhood != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "contract" field.
  String? _contract;
  String get contract => _contract ?? '';
  set contract(String? val) => _contract = val;

  bool hasContract() => _contract != null;

  // "photo" field.
  String? _photo;
  String get photo => _photo ?? '';
  set photo(String? val) => _photo = val;

  bool hasPhoto() => _photo != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "representative_cpf" field.
  String? _representativeCpf;
  String get representativeCpf => _representativeCpf ?? '';
  set representativeCpf(String? val) => _representativeCpf = val;

  bool hasRepresentativeCpf() => _representativeCpf != null;

  // "representative_rg" field.
  String? _representativeRg;
  String get representativeRg => _representativeRg ?? '';
  set representativeRg(String? val) => _representativeRg = val;

  bool hasRepresentativeRg() => _representativeRg != null;

  // "representative_number" field.
  String? _representativeNumber;
  String get representativeNumber => _representativeNumber ?? '';
  set representativeNumber(String? val) => _representativeNumber = val;

  bool hasRepresentativeNumber() => _representativeNumber != null;

  // "representative_name" field.
  String? _representativeName;
  String get representativeName => _representativeName ?? '';
  set representativeName(String? val) => _representativeName = val;

  bool hasRepresentativeName() => _representativeName != null;

  // "proposal" field.
  String? _proposal;
  String get proposal => _proposal ?? '';
  set proposal(String? val) => _proposal = val;

  bool hasProposal() => _proposal != null;

  // "tenant" field.
  TenantStruct? _tenant;
  TenantStruct get tenant => _tenant ?? TenantStruct();
  set tenant(TenantStruct? val) => _tenant = val;

  void updateTenant(Function(TenantStruct) updateFn) {
    updateFn(_tenant ??= TenantStruct());
  }

  bool hasTenant() => _tenant != null;

  static PartnerStruct fromMap(Map<String, dynamic> data) => PartnerStruct(
        id: castToType<int>(data['id']),
        isActive: data['isActive'] as bool?,
        razao: data['razao'] as String?,
        fantasia: data['fantasia'] as String?,
        cnpj: data['cnpj'] as String?,
        filial: data['filial'] as String?,
        segment: data['segment'] is SegmentStruct
            ? data['segment']
            : SegmentStruct.maybeFromMap(data['segment']),
        number: data['number'] as String?,
        email: data['email'] as String?,
        street: data['street'] as String?,
        numberAdress: data['number_adress'] as String?,
        cep: data['cep'] as String?,
        neighborhood: data['neighborhood'] as String?,
        city: data['city'] as String?,
        contract: data['contract'] as String?,
        photo: data['photo'] as String?,
        state: data['state'] as String?,
        representativeCpf: data['representative_cpf'] as String?,
        representativeRg: data['representative_rg'] as String?,
        representativeNumber: data['representative_number'] as String?,
        representativeName: data['representative_name'] as String?,
        proposal: data['proposal'] as String?,
        tenant: data['tenant'] is TenantStruct
            ? data['tenant']
            : TenantStruct.maybeFromMap(data['tenant']),
      );

  static PartnerStruct? maybeFromMap(dynamic data) =>
      data is Map ? PartnerStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'isActive': _isActive,
        'razao': _razao,
        'fantasia': _fantasia,
        'cnpj': _cnpj,
        'filial': _filial,
        'segment': _segment?.toMap(),
        'number': _number,
        'email': _email,
        'street': _street,
        'number_adress': _numberAdress,
        'cep': _cep,
        'neighborhood': _neighborhood,
        'city': _city,
        'contract': _contract,
        'photo': _photo,
        'state': _state,
        'representative_cpf': _representativeCpf,
        'representative_rg': _representativeRg,
        'representative_number': _representativeNumber,
        'representative_name': _representativeName,
        'proposal': _proposal,
        'tenant': _tenant?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'isActive': serializeParam(
          _isActive,
          ParamType.bool,
        ),
        'razao': serializeParam(
          _razao,
          ParamType.String,
        ),
        'fantasia': serializeParam(
          _fantasia,
          ParamType.String,
        ),
        'cnpj': serializeParam(
          _cnpj,
          ParamType.String,
        ),
        'filial': serializeParam(
          _filial,
          ParamType.String,
        ),
        'segment': serializeParam(
          _segment,
          ParamType.DataStruct,
        ),
        'number': serializeParam(
          _number,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'street': serializeParam(
          _street,
          ParamType.String,
        ),
        'number_adress': serializeParam(
          _numberAdress,
          ParamType.String,
        ),
        'cep': serializeParam(
          _cep,
          ParamType.String,
        ),
        'neighborhood': serializeParam(
          _neighborhood,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'contract': serializeParam(
          _contract,
          ParamType.String,
        ),
        'photo': serializeParam(
          _photo,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'representative_cpf': serializeParam(
          _representativeCpf,
          ParamType.String,
        ),
        'representative_rg': serializeParam(
          _representativeRg,
          ParamType.String,
        ),
        'representative_number': serializeParam(
          _representativeNumber,
          ParamType.String,
        ),
        'representative_name': serializeParam(
          _representativeName,
          ParamType.String,
        ),
        'proposal': serializeParam(
          _proposal,
          ParamType.String,
        ),
        'tenant': serializeParam(
          _tenant,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static PartnerStruct fromSerializableMap(Map<String, dynamic> data) =>
      PartnerStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        isActive: deserializeParam(
          data['isActive'],
          ParamType.bool,
          false,
        ),
        razao: deserializeParam(
          data['razao'],
          ParamType.String,
          false,
        ),
        fantasia: deserializeParam(
          data['fantasia'],
          ParamType.String,
          false,
        ),
        cnpj: deserializeParam(
          data['cnpj'],
          ParamType.String,
          false,
        ),
        filial: deserializeParam(
          data['filial'],
          ParamType.String,
          false,
        ),
        segment: deserializeStructParam(
          data['segment'],
          ParamType.DataStruct,
          false,
          structBuilder: SegmentStruct.fromSerializableMap,
        ),
        number: deserializeParam(
          data['number'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        street: deserializeParam(
          data['street'],
          ParamType.String,
          false,
        ),
        numberAdress: deserializeParam(
          data['number_adress'],
          ParamType.String,
          false,
        ),
        cep: deserializeParam(
          data['cep'],
          ParamType.String,
          false,
        ),
        neighborhood: deserializeParam(
          data['neighborhood'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        contract: deserializeParam(
          data['contract'],
          ParamType.String,
          false,
        ),
        photo: deserializeParam(
          data['photo'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        representativeCpf: deserializeParam(
          data['representative_cpf'],
          ParamType.String,
          false,
        ),
        representativeRg: deserializeParam(
          data['representative_rg'],
          ParamType.String,
          false,
        ),
        representativeNumber: deserializeParam(
          data['representative_number'],
          ParamType.String,
          false,
        ),
        representativeName: deserializeParam(
          data['representative_name'],
          ParamType.String,
          false,
        ),
        proposal: deserializeParam(
          data['proposal'],
          ParamType.String,
          false,
        ),
        tenant: deserializeStructParam(
          data['tenant'],
          ParamType.DataStruct,
          false,
          structBuilder: TenantStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'PartnerStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PartnerStruct &&
        id == other.id &&
        isActive == other.isActive &&
        razao == other.razao &&
        fantasia == other.fantasia &&
        cnpj == other.cnpj &&
        filial == other.filial &&
        segment == other.segment &&
        number == other.number &&
        email == other.email &&
        street == other.street &&
        numberAdress == other.numberAdress &&
        cep == other.cep &&
        neighborhood == other.neighborhood &&
        city == other.city &&
        contract == other.contract &&
        photo == other.photo &&
        state == other.state &&
        representativeCpf == other.representativeCpf &&
        representativeRg == other.representativeRg &&
        representativeNumber == other.representativeNumber &&
        representativeName == other.representativeName &&
        proposal == other.proposal &&
        tenant == other.tenant;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        isActive,
        razao,
        fantasia,
        cnpj,
        filial,
        segment,
        number,
        email,
        street,
        numberAdress,
        cep,
        neighborhood,
        city,
        contract,
        photo,
        state,
        representativeCpf,
        representativeRg,
        representativeNumber,
        representativeName,
        proposal,
        tenant
      ]);
}

PartnerStruct createPartnerStruct({
  int? id,
  bool? isActive,
  String? razao,
  String? fantasia,
  String? cnpj,
  String? filial,
  SegmentStruct? segment,
  String? number,
  String? email,
  String? street,
  String? numberAdress,
  String? cep,
  String? neighborhood,
  String? city,
  String? contract,
  String? photo,
  String? state,
  String? representativeCpf,
  String? representativeRg,
  String? representativeNumber,
  String? representativeName,
  String? proposal,
  TenantStruct? tenant,
}) =>
    PartnerStruct(
      id: id,
      isActive: isActive,
      razao: razao,
      fantasia: fantasia,
      cnpj: cnpj,
      filial: filial,
      segment: segment ?? SegmentStruct(),
      number: number,
      email: email,
      street: street,
      numberAdress: numberAdress,
      cep: cep,
      neighborhood: neighborhood,
      city: city,
      contract: contract,
      photo: photo,
      state: state,
      representativeCpf: representativeCpf,
      representativeRg: representativeRg,
      representativeNumber: representativeNumber,
      representativeName: representativeName,
      proposal: proposal,
      tenant: tenant ?? TenantStruct(),
    );
