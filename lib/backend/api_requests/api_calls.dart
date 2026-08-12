import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class ObterDashboardCompletoCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterDashboardCompleto',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/dashboard',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static double? totalVendas(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.totalVendas''',
      ));
  static double? descontosAplicados(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.descontosAplicados''',
      ));
  static double? cuponsUtilizados(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.cuponsUtilizados''',
      ));
  static double? cuponsAtivos(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.cuponsAtivos''',
      ));
  static double? trocaSolicitada(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.trocaSolicitada''',
      ));
  static double? qtdDeUsuariosComprasPeriodo(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.qtdUsuariosComprasPeriodo''',
      ));
  static double? parceirosAtivos(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.parceirosAtivos''',
      ));
  static double? usuariosAtivos(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.usuariosAtivos''',
      ));
}

class ObterCuponsCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterCupons',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/discount',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<int>? id(dynamic response) => (getJsonField(
        response,
        r'''$[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? validity(dynamic response) => (getJsonField(
        response,
        r'''$[:].validity''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? discount(dynamic response) => (getJsonField(
        response,
        r'''$[:].discount.discount''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? partner(dynamic response) => (getJsonField(
        response,
        r'''$[:].discount.partner.fantasia''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class DeletarCuponsCall {
  static Future<ApiCallResponse> call({
    String? idDiscount = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'deletarCupons',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/discount/${idDiscount}',
      callType: ApiCallType.DELETE,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeletarBannersCall {
  static Future<ApiCallResponse> call({
    String? idBanner = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'deletarBanners',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/banner/${idBanner}',
      callType: ApiCallType.DELETE,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ObterUsuariosCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterUsuarios',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/customer',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<int>? id(dynamic response) => (getJsonField(
        response,
        r'''$[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? nome(dynamic response) => (getJsonField(
        response,
        r'''$[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? identificacao(dynamic response) => (getJsonField(
        response,
        r'''$[:].cardNumber''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? tipo(dynamic response) => (getJsonField(
        response,
        r'''$[:].user.role''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? user(dynamic response) => (getJsonField(
        response,
        r'''$[:].user.login''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? senha(dynamic response) => (getJsonField(
        response,
        r'''$[:].user.password''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ObterProdutosCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterProdutos',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/product',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AtualizarDadosCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? email = '',
    String? password = '',
    String? inviteCode = '',
    int? role,
  }) async {
    final ffApiRequestBody = '''
{
  "id": "${id}",
  "isActive": true,
  "inviteCode": "${inviteCode}",
  "login": "${email}",
  "password": "${password}",
  "role": ${role}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'atualizarDados',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/user',
      callType: ApiCallType.PUT,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeletarProdutoCall {
  static Future<ApiCallResponse> call({
    String? idProduto = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'deletarProduto',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/product/${idProduto}',
      callType: ApiCallType.DELETE,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class EnviarNotificacaoCall {
  static Future<ApiCallResponse> call({
    String? title = '',
    String? message = '',
    String? data = '',
    String? tenantId = '',
    String? url = '',
    String? mensageiro = '',
  }) async {
    final ffApiRequestBody = '''
{
  "data": "${data}",
  "description": "${message}",
  "title": "${title}",
  "url": "${url}",
  "sendby": "${mensageiro}",
  "tenant": {
    "id": "${tenantId}"
  },
  "active": true
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'enviarNotificacao',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/notify',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AdicionarBannerCall {
  static Future<ApiCallResponse> call({
    String? url = '',
    String? imagem = '',
  }) async {
    final ffApiRequestBody = '''
 {
    "url": "${url}",
    "imagem": "${imagem}",
    "active": true
 }''';
    return ApiManager.instance.makeApiCall(
      callName: 'adicionarBanner',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/banner',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ValidarCupomCall {
  static Future<ApiCallResponse> call({
    String? code = '',
    String? value = '',
    String? paidValue = '',
  }) async {
    final ffApiRequestBody = '''
{
  "validateCode": "${code}",
  "valorProduto": "${value}",
  "valorPagar": "${paidValue}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'validarCupom',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/cupom/validar',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ObterBannersCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterBanners',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/banner',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ObterPropostasCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterPropostas',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/proposta/status',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeletarPropostaCall {
  static Future<ApiCallResponse> call({
    String? idProposta = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'deletarProposta',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/proposta/${idProposta}',
      callType: ApiCallType.DELETE,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ObterTrocasCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterTrocas',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/trade',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class EnviarImagemCall {
  static Future<ApiCallResponse> call({
    FFUploadedFile? image,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'enviarImagem',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/photo',
      callType: ApiCallType.POST,
      headers: {},
      params: {
        'image': image,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class EnviarArquivoCall {
  static Future<ApiCallResponse> call({
    FFUploadedFile? file,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'enviarArquivo',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/arquivo',
      callType: ApiCallType.POST,
      headers: {},
      params: {
        'file': file,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AdicionarProdutoCall {
  static Future<ApiCallResponse> call({
    String? imagem = '',
    String? name = '',
    String? tenantId = '',
    String? cost = '',
    String? inventory = '',
    String? valorDinheiro = '',
  }) async {
    final ffApiRequestBody = '''
{
  "photo": "${imagem}",
  "name": "${name}",
  "tenant": {
    "id": "${tenantId}"
  },
  "inventory": "${inventory}",
  "cost": "${cost}",
  "valorDinheiro": "${valorDinheiro}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'adicionarProduto',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/product',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ObterParceirosCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterParceiros',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/partner',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AdicionarDescontoCall {
  static Future<ApiCallResponse> call({
    String? descricao = '',
    String? porcentagem = '',
    String? idParceiro = '',
    String? data = '',
    String? idTenant = '',
    String? idSegmento = '',
  }) async {
    final ffApiRequestBody = '''
{
 "description": "${descricao}",
 "discount": "${porcentagem}",
 "isActive": true,
 "canDelete": true,
 "partner": {
   "id": "${idParceiro}"
 },
 "validity": "${data}",
 "tenant": {
   "id": "${idTenant}"
 },
 "segment": {
  "id": "${idSegmento}"
 }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'adicionarDesconto',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/discount',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

// NOTA: o backend ainda não expõe PUT/PATCH em /api/v1/discount/{id}
// (confirmado via OPTIONS em 2026-07-24: só permite DELETE, GET, HEAD).
// Esta chamada segue o mesmo padrão de EditarSegmentoCall/AtualizarProdutoCall
// e fica pronta para uso assim que essa rota for adicionada no backend.
class EditarDescontoCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? descricao = '',
    String? porcentagem = '',
    String? idParceiro = '',
    String? data = '',
    String? idTenant = '',
    String? idSegmento = '',
  }) async {
    final ffApiRequestBody = '''
{
 "id": "${id}",
 "description": "${descricao}",
 "discount": "${porcentagem}",
 "isActive": true,
 "canDelete": true,
 "partner": {
   "id": "${idParceiro}"
 },
 "validity": "${data}",
 "tenant": {
   "id": "${idTenant}"
 },
 "segment": {
  "id": "${idSegmento}"
 }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'editarDesconto',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/discount/${id}',
      callType: ApiCallType.PUT,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ObterSegmentosCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterSegmentos',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/segments',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AdicionarSegmentoCall {
  static Future<ApiCallResponse> call({
    String? nome = '',
    String? url = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${nome}",
  "photo": "${url}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'adicionarSegmento',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/segments',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class EditarSegmentoCall {
  static Future<ApiCallResponse> call({
    String? nome = '',
    String? url = '',
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
 "id": "${id}",
  "name": "${nome}",
  "photo": "${url}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'editarSegmento',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/segments/${id}',
      callType: ApiCallType.PUT,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AtualizarStatusDaTrocaCall {
  static Future<ApiCallResponse> call({
    String? idTroca = '',
    String? idProduto = '',
    String? idCustomer = '',
    String? idTenant = '',
    String? takeout = '',
  }) async {
    final ffApiRequestBody = '''
{
  "id": "${idTroca}",
  "product": {
    "id": "${idProduto}"
  },
  "customer": {
    "id": "${idCustomer}"
  },
  "tenant": {
    "id": "${idTenant}"
  },
  "status": "1",
  "takeout": "${takeout}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'atualizarStatusDaTroca',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/trade',
      callType: ApiCallType.PUT,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CriarParceiroCall {
  static Future<ApiCallResponse> call({
    int? idTenant,
    String? email = '',
    String? senha = '',
    String? razao = '',
    String? cnpj = '',
    String? cep = '',
    String? rua = '',
    String? bairro = '',
    String? numero = '',
    String? cidade = '',
    String? telefoneRepresentante = '',
    String? representanteNome = '',
    bool? selecionado,
    String? contract = '',
    String? photo = '',
    String? state = '',
    String? cpf = '',
    String? rg = '',
    String? emailRepresentante = '',
    String? fantasia = '',
    String? idSegmento = '',
    String? instagram = '',
    String? filial = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${razao}",
  "cardNumber": "${cpf}",
  "cpf": "${cpf}",
  "isActive": true,
  "tenant": {
    "id": ${idTenant}
  },
  "wallet": {
    "pointsBalance": 0,
    "totalSavings": 0
  },
  "user": {
    "isActive": true,
    "inviteCode": "",
    "login": "${email}",
    "password": "${senha}",
    "role": 1
  },
  "partner": {
    "instagram": "${instagram}",
    "segment": {
      "id": "${idSegmento}"
    },
    "isActive": true,
    "isSelected": ${selecionado},
    "razao": "${razao}",
    "fantasia": "${fantasia}",
    "cnpj": "${cnpj}",
    "filial": "${filial}",
    "number": "${telefoneRepresentante}",
    "email": "${emailRepresentante}",
    "street": "${rua}",
    "number_adress": "${numero}",
    "cep": "${cep}",
    "neighborhood": "${bairro}",
    "city": "${cidade}",
    "contract": "${contract}",
    "photo": "${photo}",
    "state": "${state}",
    "representative_cpf": "${cpf}",
    "representative_rg": "${rg}",
    "representative_number": "${telefoneRepresentante}",
    "representative_name": "${representanteNome}",
    "proposal": ""
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'criarParceiro',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/customer',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AtualizarParceiroCall {
  static Future<ApiCallResponse> call({
    int? idTenant,
    String? email = '',
    // Nulo/vazio = manter a senha atual (não sobrescreve no backend).
    String? senha,
    String? razao = '',
    String? cnpj = '',
    String? cep = '',
    String? rua = '',
    String? bairro = '',
    String? numero = '',
    String? cidade = '',
    String? telefoneRepresentante = '',
    String? representanteNome = '',
    bool? selecionado,
    String? contract = '',
    String? photo = '',
    String? state = '',
    String? cpf = '',
    String? rg = '',
    String? emailRepresentante = '',
    String? fantasia = '',
    String? idSegmento = '',
    String? proposal = '',
    String? idCustomer = '',
    String? phone = '',
    String? idPartner = '',
    String? idWallet = '',
    String? idUser = '',
    String? instagram = '',
    String? filial = '',
  }) async {
    // Só inclui a senha no payload se o admin realmente digitou uma nova —
    // campo vazio/nulo nunca deve sobrescrever a senha existente do parceiro.
    final senhaField = (senha != null && senha.trim().isNotEmpty)
        ? '"password": "${senha}",'
        : '';
    final ffApiRequestBody = '''
{
  "id": "${idCustomer}",
  "name": "${razao}",
  "cardNumber": "${cpf}",
  "cpf": "${cpf}",
  "isActive": true,
  "tenant": {
    "id": ${idTenant}
  },
  "wallet": {
    "id": ${idWallet}
  },
  "user": {
    "id": "${idUser}",
    "isActive": true,
    "inviteCode": "",
    "login": "${email}",
    ${senhaField}
    "role": 1
  },
  "partner": {
    "instagram": "${instagram}",
    "id": "${idPartner}",
    "segment": {
      "id": "${idSegmento}"
    },
    "isActive": true,
    "isSelected": ${selecionado},
    "razao": "${razao}",
    "fantasia": "${fantasia}",
    "cnpj": "${cnpj}",
    "filial": "${filial}",
    "number":"${phone}",
    "email": "${emailRepresentante}",
    "street": "${rua}",
    "number_adress": "${numero}",
    "cep": "${cep}",
    "neighborhood": "${bairro}",
    "city": "${cidade}",
    "contract": "${contract}",
    "photo": "${photo}",
    "state": "${state}",
    "representative_cpf": "${cpf}",
    "representative_rg": "${rg}",
    "representative_number": "${telefoneRepresentante}",
    "representative_name": "${representanteNome}",
    "proposal": "${proposal}"
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'atualizarParceiro',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/customer',
      callType: ApiCallType.PUT,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.TEXT,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CriarUsuarioCall {
  static Future<ApiCallResponse> call({
    String? idTenant = '',
    String? email = '',
    String? senha = '',
    String? razao = '',
    String? cnpj = '',
    String? cep = '',
    String? rua = '',
    String? bairro = '',
    String? numero = '',
    String? cidade = '',
    String? telefoneRepresentante = '',
    String? representanteNome = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${razao}",
  "cardNumber": "",
  "cpf": "",
  "isActive": true,
  "tenant": {
    "id": "${idTenant}"
  },
  "wallet": {
    "pointsBalance": 0,
    "totalSavings": 0
  },
  "user": {
    "isActive": true,
    "inviteCode": "",
    "login": "${email}",
    "password": "${senha}",
    "role": 1
  },
  "partner": {
    "isActive": true,
    "isSelected": false,
    "razao": "${razao}",
    "fantasia": "${razao}",
    "cnpj": "${cnpj}",
    "number": "${telefoneRepresentante}",
    "email": "${email}",
    "street": "${rua}",
    "number_adress": "${numero}",
    "cep": "${cep}",
    "neighborhood": "${bairro}",
    "city": "${cidade}",
    "contract": "",
    "photo": "",
    "state": "",
    "representative_cpf": "",
    "representative_rg": "",
    "representative_number": "${telefoneRepresentante}",
    "representative_name": "${representanteNome}",
    "proposal": ""
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'criarUsuario',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/customer',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class LoginCall {
  static Future<ApiCallResponse> call({
    String? login = '',
    String? senha = '',
  }) async {
    final ffApiRequestBody = '''
{
  "login": "${login}",
  "password": "${senha}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'login',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/login',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? role(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.user.role''',
      ));
}

class EsqueceuASenhaCall {
  static Future<ApiCallResponse> call({
    String? login = '',
  }) async {
    final ffApiRequestBody = '''
{
  "login": "${login}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'esqueceuASenha',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/user/forgot',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AdicionarPropostaCall {
  static Future<ApiCallResponse> call({
    String? senha = '',
    String? nomeRepresentante = '',
    String? telefoneRepresentante = '',
    String? email = '',
    String? cnpj = '',
    String? razao = '',
    String? cep = '',
    String? numero = '',
    String? proposta = '',
    String? uf = '',
    String? cidade = '',
    String? rua = '',
    String? bairro = '',
  }) async {
    final ffApiRequestBody = '''
{
  "senha": "${senha}",
  "responsavel": "${nomeRepresentante}",
  "phone": "${telefoneRepresentante}",
  "email": "${email}",
  "cnpj": "${cnpj}",
  "razaoSocial": "${razao}",
  "aprovado": false
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'adicionarProposta',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/proposta',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ObterDashboardParceiroCall {
  static Future<ApiCallResponse> call({
    String? partnerId = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterDashboardParceiro',
      apiUrl:
          'https://codeflowbr.online:8080/api/v1/dashboard/partner/${partnerId}',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: true,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ObterCuponsDoParceiroCall {
  static Future<ApiCallResponse> call({
    String? partnerId = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'obterCuponsDoParceiro',
      apiUrl:
          'https://codeflowbr.online:8080/api/v1/discount/partner/user/${partnerId}',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: true,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AtualizarProdutoCall {
  static Future<ApiCallResponse> call({
    String? photo = '',
    String? idTenant = '',
    String? id = '',
    String? name = '',
    int? cost,
    int? inventory,
    String? valorDinheiro = '',
  }) async {
    final ffApiRequestBody = '''
{
  "photo": "${photo}",
  "id": ${id},
  "name": "${name}",
  "tenant": {
    "id": ${idTenant}
  },
  "inventory": ${inventory},
  "cost": ${cost},
  "valorDinheiro": "${valorDinheiro}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'atualizarProduto',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/product',
      callType: ApiCallType.PUT,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.TEXT,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeletarParceiroCall {
  static Future<ApiCallResponse> call({
    String? customerId = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'deletarParceiro',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/customer/${customerId}',
      callType: ApiCallType.DELETE,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class EditarCustomerCall {
  static Future<ApiCallResponse> call({
    int? id,
    String? name = '',
    bool? armspass = true,
    String? cardNumber = '',
    String? cpf = '',
    bool? isActive = true,
    dynamic? tenantJson,
    dynamic? walletJson,
    dynamic? partnerJson,
    int? userId,
    bool? userIsActive = true,
    String? userInviteCode = '',
    String? userLogin = '',
    // Nulo/vazio = manter a senha atual (não sobrescreve no backend). Este
    // modal nunca tem acesso à senha real do usuário, então nunca deve
    // reenviar um valor "reaproveitado" da consulta anterior.
    String? userPassword,
    int? userRole,
  }) async {
    final tenant = _serializeJson(tenantJson);
    final wallet = _serializeJson(walletJson);
    final partner = _serializeJson(partnerJson);
    final senhaField = (userPassword != null && userPassword.trim().isNotEmpty)
        ? '"password": "${escapeStringForJson(userPassword)}",'
        : '';
    final ffApiRequestBody = '''
{
  "id": ${id},
  "name": "${escapeStringForJson(name)}",
  "armspass": ${armspass},
  "cardNumber": "${escapeStringForJson(cardNumber)}",
  "cpf": "${escapeStringForJson(cpf)}",
  "isActive": ${isActive},
  "tenant": ${tenant},
  "wallet": ${wallet},
  "user": {
    "id": ${userId},
    "isActive": ${userIsActive},
    "inviteCode": "${escapeStringForJson(userInviteCode)}",
    "login": "${escapeStringForJson(userLogin)}",
    ${senhaField}
    "role": ${userRole}
  },
  "partner": ${partner}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'editarCustomer',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/customer',
      callType: ApiCallType.PUT,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetHistoricoRecenteCall {
  static Future<ApiCallResponse> call({
    int? partnerId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'GetHistoricoRecente',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/history/recentes',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'partnerId': partnerId,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
