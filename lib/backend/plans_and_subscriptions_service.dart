import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Modelo de dados de um Plano Arms Pro
class PlanModel {
  PlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    this.highlightTag,
    required this.benefits,
    this.isActive = true,
    required this.eligiblePartnerIds,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  String name;
  double price;
  String billingCycle; // 'Mensal', 'Trimestral', 'Semestral', 'Anual'
  String? highlightTag; // ex: 'Mais Popular', '20% OFF'
  List<String> benefits;
  bool isActive;
  List<int> eligiblePartnerIds; // IDs dos parceiros credenciados vinculados
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'billingCycle': billingCycle,
        'highlightTag': highlightTag,
        'benefits': benefits,
        'isActive': isActive,
        'eligiblePartnerIds': eligiblePartnerIds,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name']?.toString() ?? 'Plano Arms Pro',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      billingCycle: json['billingCycle']?.toString() ?? 'Mensal',
      highlightTag: json['highlightTag']?.toString(),
      benefits: (json['benefits'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isActive: json['isActive'] == true || json['isActive'] == null,
      eligiblePartnerIds: (json['eligiblePartnerIds'] as List<dynamic>?)
              ?.map((e) => int.tryParse(e.toString()) ?? 0)
              .where((id) => id > 0)
              .toList() ??
          [],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }

  PlanModel copyWith({
    String? id,
    String? name,
    double? price,
    String? billingCycle,
    String? highlightTag,
    List<String>? benefits,
    bool? isActive,
    List<int>? eligiblePartnerIds,
  }) {
    return PlanModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      highlightTag: highlightTag ?? this.highlightTag,
      benefits: benefits ?? List.from(this.benefits),
      isActive: isActive ?? this.isActive,
      eligiblePartnerIds: eligiblePartnerIds ?? List.from(this.eligiblePartnerIds),
      createdAt: createdAt,
    );
  }
}

/// Modelo de Assinatura de Membro Arms Pro
class SubscriptionMemberModel {
  SubscriptionMemberModel({
    required this.id,
    required this.customerId,
    required this.userName,
    required this.userCpf,
    required this.userEmail,
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.nextBillingDate,
    required this.status, // 'Ativa', 'Pendente de Pagamento', 'Cancelada', 'Vencida'
    this.lastPaymentMethod = 'Cartão de Crédito',
    this.amountPaid = 0.0,
    this.cancellationReason,
  });

  final String id;
  final int customerId;
  String userName;
  String userCpf;
  String userEmail;
  String planId;
  String planName;
  DateTime startDate;
  DateTime nextBillingDate;
  String status; // 'Ativa', 'Pendente de Pagamento', 'Cancelada', 'Vencida'
  String lastPaymentMethod;
  double amountPaid;
  String? cancellationReason;

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'userName': userName,
        'userCpf': userCpf,
        'userEmail': userEmail,
        'planId': planId,
        'planName': planName,
        'startDate': startDate.toIso8601String(),
        'nextBillingDate': nextBillingDate.toIso8601String(),
        'status': status,
        'lastPaymentMethod': lastPaymentMethod,
        'amountPaid': amountPaid,
        'cancellationReason': cancellationReason,
      };

  factory SubscriptionMemberModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionMemberModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      customerId: int.tryParse(json['customerId']?.toString() ?? '0') ?? 0,
      userName: json['userName']?.toString() ?? 'Membro',
      userCpf: json['userCpf']?.toString() ?? '',
      userEmail: json['userEmail']?.toString() ?? '',
      planId: json['planId']?.toString() ?? '',
      planName: json['planName']?.toString() ?? 'Arms Pro',
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ?? DateTime.now(),
      nextBillingDate: DateTime.tryParse(json['nextBillingDate']?.toString() ?? '') ??
          DateTime.now().add(const Duration(days: 30)),
      status: json['status']?.toString() ?? 'Ativa',
      lastPaymentMethod: json['lastPaymentMethod']?.toString() ?? 'Cartão de Crédito',
      amountPaid: (json['amountPaid'] is num)
          ? (json['amountPaid'] as num).toDouble()
          : double.tryParse(json['amountPaid']?.toString() ?? '0') ?? 0.0,
      cancellationReason: json['cancellationReason']?.toString(),
    );
  }
}

/// Serviço Singleton para gerenciar Planos e Assinaturas no Frontend Admin
class PlansAndSubscriptionsService extends ChangeNotifier {
  static final PlansAndSubscriptionsService _instance = PlansAndSubscriptionsService._internal();
  factory PlansAndSubscriptionsService() => _instance;
  PlansAndSubscriptionsService._internal();

  static const String _storageKeyPlans = 'armspro_plans_v1';
  static const String _storageKeySubscriptions = 'armspro_subscriptions_v1';
  static const String _storageKeyDeletedPlans = 'armspro_deleted_plans_v1';

  bool _initialized = false;
  List<PlanModel> _plans = [];
  List<SubscriptionMemberModel> _subscriptions = [];
  // IDs de planos explicitamente deletados pelo usuário — persiste entre restarts
  Set<String> _deletedPlanIds = {};

  List<PlanModel> get plans => List.unmodifiable(_plans);
  List<SubscriptionMemberModel> get subscriptions => List.unmodifiable(_subscriptions);

  /// Inicializa o serviço e carrega dados salvos (ou os padrões da Arms Gym)
  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final plansJson = prefs.getString(_storageKeyPlans);
    final subsJson = prefs.getString(_storageKeySubscriptions);

    if (plansJson != null && plansJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(plansJson);
        final loaded = decoded
            .map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
            .where((p) => p.id != 'plan_black_anual' && p.id != 'plan_trimestral')
            .toList();
        _plans = loaded.isNotEmpty ? loaded : _getDefaultPlans();
      } catch (_) {
        _plans = _getDefaultPlans();
      }
    } else {
      _plans = _getDefaultPlans();
      await _savePlansToStorage();
    }

    // Carrega IDs de planos deletados
    try {
      final deletedJson = prefs.getString(_storageKeyDeletedPlans);
      if (deletedJson != null && deletedJson.isNotEmpty) {
        final List<dynamic> deletedList = jsonDecode(deletedJson);
        _deletedPlanIds = deletedList.map((e) => e.toString()).toSet();
        // Remove da lista carregada qualquer plano marcado como deletado
        _plans.removeWhere((p) => _deletedPlanIds.contains(p.id));
      }
    } catch (_) {}

    if (subsJson != null && subsJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(subsJson);
        final loaded = decoded
            .map((e) => SubscriptionMemberModel.fromJson(e as Map<String, dynamic>))
            .where((s) => !s.id.startsWith('sub_00'))
            .toList();
        _subscriptions = loaded;
      } catch (_) {
        _subscriptions = [];
      }
    } else {
      _subscriptions = [];
      await _saveSubscriptionsToStorage();
    }

    _initialized = true;
    notifyListeners();

    // Sincronização em segundo plano com os dados reais
    syncWithBackend();
  }

  /// Sincroniza dados com os endpoints REST mantendo dados 100% reais
  Future<void> syncWithBackend() async {
    // 1. Planos: tenta o endpoint da nuvem; se não implantado (404), tenta o backend local
    try {
      final response = await ObterPlanosCall.call();
      if (response.succeeded && response.jsonBody is List) {
        final List<dynamic> list = response.jsonBody as List<dynamic>;
        if (list.isNotEmpty) {
          // Filtra planos explicitamente deletados pelo usuário
          _plans = list
              .map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
              .where((p) => !_deletedPlanIds.contains(p.id))
              .toList();
          await _savePlansToStorage();
        }
      } else {
        // Fallback local caso a VPS ainda não tenha recebido o deploy do novo JAR
        try {
          final resLocal = await http.get(Uri.parse('https://codeflowbr.online:8080/api/v1/plans'));
          if (resLocal.statusCode == 200) {
            final decoded = jsonDecode(utf8.decode(resLocal.bodyBytes));
            if (decoded is List && decoded.isNotEmpty) {
              _plans = decoded
                  .map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
                  .where((p) => !_deletedPlanIds.contains(p.id))
                  .toList();
              await _savePlansToStorage();
            }
          }
        } catch (_) {}
      }
    } catch (_) {}

    // 2. Assinaturas: tenta obter assinaturas reais
    try {
      final subResponse = await ObterAssinaturasCall.call();
      if (subResponse.succeeded && subResponse.jsonBody is List) {
        final List<dynamic> list = subResponse.jsonBody as List<dynamic>;
        _subscriptions = list
            .map((e) => SubscriptionMemberModel.fromJson(e as Map<String, dynamic>))
            .where((s) => !s.id.startsWith('sub_00'))
            .toList();
        await _saveSubscriptionsToStorage();
      } else {
        try {
          final resLocal = await http.get(Uri.parse('https://codeflowbr.online:8080/api/v1/subscriptions'));
          if (resLocal.statusCode == 200) {
            final decoded = jsonDecode(utf8.decode(resLocal.bodyBytes));
            if (decoded is List) {
              _subscriptions = decoded
                  .map((e) => SubscriptionMemberModel.fromJson(e as Map<String, dynamic>))
                  .where((s) => !s.id.startsWith('sub_00'))
                  .toList();
              await _saveSubscriptionsToStorage();
            }
          }
        } catch (_) {}
      }
    } catch (_) {}
  }

  Future<void> _savePlansToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_plans.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKeyPlans, jsonStr);
    notifyListeners();
  }

  Future<void> _saveSubscriptionsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_subscriptions.map((s) => s.toJson()).toList());
    await prefs.setString(_storageKeySubscriptions, jsonStr);
    notifyListeners();
  }

  // -------------------------------------------------------------
  // MÓDULO A: GESTÃO DE PLANOS ARMS PRÓ
  // -------------------------------------------------------------

  /// Adiciona ou atualiza um plano com sincronização em nuvem e persistência local
  Future<void> savePlan(PlanModel plan) async {
    final isExisting = _plans.any((p) => p.id == plan.id);
    final index = _plans.indexWhere((p) => p.id == plan.id);
    if (index >= 0) {
      _plans[index] = plan;
    } else {
      _plans.insert(0, plan);
    }
    await _savePlansToStorage();

    // Sincroniza em nuvem com o backend
    try {
      if (isExisting) {
        await AtualizarPlanoCall.call(
          id: plan.id,
          name: plan.name,
          price: plan.price,
          billingCycle: plan.billingCycle,
          highlightTag: plan.highlightTag,
          benefits: plan.benefits,
          eligiblePartnerIds: plan.eligiblePartnerIds,
          isActive: plan.isActive,
        );
      } else {
        final res = await CriarPlanoCall.call(
          name: plan.name,
          price: plan.price,
          billingCycle: plan.billingCycle,
          highlightTag: plan.highlightTag,
          benefits: plan.benefits,
          eligiblePartnerIds: plan.eligiblePartnerIds,
          isActive: plan.isActive,
        );
        // Se a API retornar o ID criado pelo banco, atualiza no modelo local
        if (res.succeeded && res.jsonBody is Map && res.jsonBody['id'] != null) {
          final cloudId = res.jsonBody['id'].toString();
          final idx = _plans.indexWhere((p) => p.id == plan.id);
          if (idx >= 0) {
            _plans[idx] = plan.copyWith(id: cloudId);
            await _savePlansToStorage();
          }
        }
      }
    } catch (_) {
      // Falha de envio em nuvem não impede uso local (fallback offline)
    }
  }

  /// Alterna o status (Ativo / Inativo) de um plano
  Future<void> togglePlanStatus(String planId) async {
    final index = _plans.indexWhere((p) => p.id == planId);
    if (index >= 0) {
      _plans[index].isActive = !_plans[index].isActive;
      await _savePlansToStorage();

      final plan = _plans[index];
      try {
        await AtualizarPlanoCall.call(
          id: plan.id,
          name: plan.name,
          price: plan.price,
          billingCycle: plan.billingCycle,
          highlightTag: plan.highlightTag,
          benefits: plan.benefits,
          eligiblePartnerIds: plan.eligiblePartnerIds,
          isActive: plan.isActive,
        );
      } catch (_) {}
    }
  }

  /// Exclui um plano com sincronização em nuvem
  Future<void> deletePlan(String planId) async {
    // Registra o ID como deletado ANTES de tudo para persistir entre restarts
    _deletedPlanIds.add(planId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKeyDeletedPlans,
      jsonEncode(_deletedPlanIds.toList()),
    );

    _plans.removeWhere((p) => p.id == planId);
    await _savePlansToStorage();

    try {
      await ExcluirPlanoCall.call(id: planId);
    } catch (_) {}
  }

  /// Retorna um plano pelo ID
  PlanModel? getPlanById(String planId) {
    try {
      return _plans.firstWhere((p) => p.id == planId);
    } catch (_) {
      return null;
    }
  }

  // -------------------------------------------------------------
  // FUNÇÕES PREPARADAS PARA INTEGRAÇÃO COM PARCEIROS & DESCONTOS
  // -------------------------------------------------------------

  /// Retorna a lista de planos nos quais um determinado parceiro está vinculado
  List<PlanModel> getPlansForPartner(int partnerId) {
    return _plans.where((p) => p.eligiblePartnerIds.contains(partnerId)).toList();
  }

  /// Verifica se um parceiro específico está elegível dentro de um plano
  bool isPartnerEligibleInPlan(int partnerId, String planId) {
    final plan = getPlanById(planId);
    if (plan == null) return false;
    return plan.eligiblePartnerIds.contains(partnerId);
  }

  /// Adiciona um parceiro à lista de credenciados de um plano
  Future<void> addPartnerToPlan(String planId, int partnerId) async {
    final plan = getPlanById(planId);
    if (plan != null && !plan.eligiblePartnerIds.contains(partnerId)) {
      plan.eligiblePartnerIds.add(partnerId);
      await _savePlansToStorage();
    }
  }

  /// Remove um parceiro da lista de credenciados de um plano
  Future<void> removePartnerFromPlan(String planId, int partnerId) async {
    final plan = getPlanById(planId);
    if (plan != null && plan.eligiblePartnerIds.contains(partnerId)) {
      plan.eligiblePartnerIds.remove(partnerId);
      await _savePlansToStorage();
    }
  }

  /// Vincula ou desvincula um parceiro de uma lista de planos
  Future<void> updatePartnerEligibility(int partnerId, List<String> targetPlanIds) async {
    for (var plan in _plans) {
      if (targetPlanIds.contains(plan.id)) {
        if (!plan.eligiblePartnerIds.contains(partnerId)) {
          plan.eligiblePartnerIds.add(partnerId);
        }
      } else {
        plan.eligiblePartnerIds.remove(partnerId);
      }
    }
    await _savePlansToStorage();
  }

  /// Retorna a contagem de assinantes ativos que possuem acesso aos benefícios do parceiro
  int getPartnerSubscribersCount(int partnerId) {
    final planIdsWithPartner = getPlansForPartner(partnerId).map((p) => p.id).toSet();
    return _subscriptions.where((sub) => sub.status == 'Ativa' && planIdsWithPartner.contains(sub.planId)).length;
  }

  /// Retorna um resumo detalhado do parceiro em relação ao ecossistema Arms Pro
  Map<String, dynamic> getPartnerSummary(int partnerId) {
    final linkedPlans = getPlansForPartner(partnerId);
    final subscribersCount = getPartnerSubscribersCount(partnerId);
    return {
      'partnerId': partnerId,
      'isLinkedToArmsPro': linkedPlans.isNotEmpty,
      'plansCount': linkedPlans.length,
      'planNames': linkedPlans.map((p) => p.name).toList(),
      'planIds': linkedPlans.map((p) => p.id).toList(),
      'activeSubscribers': subscribersCount,
    };
  }

  /// Filtra uma lista de parceiros do backend retornando apenas os vinculados a um plano
  List<dynamic> filterPartnersByPlan(String planId, List<dynamic> allPartners) {
    final plan = getPlanById(planId);
    if (plan == null) return [];
    return allPartners.where((partner) {
      final id = getJsonField(partner, r'''$.id''') ?? getJsonField(partner, r'''$.partner.id''');
      final pId = id is int ? id : int.tryParse(id?.toString() ?? '');
      return pId != null && plan.eligiblePartnerIds.contains(pId);
    }).toList();
  }

  /// Analisa a string de regras de desconto/cupom e extrai metadados do Arms Pro
  static Map<String, dynamic> parseArmsProDiscountRules(String? rules) {
    if (rules == null || rules.trim().isEmpty) {
      return {
        'isArmsPro': false,
        'limitQuantity': null,
        'allowedPlanIds': <String>[],
        'cleanRules': '',
      };
    }

    bool isArmsPro = rules.contains('[ARMS_PRO]');
    int? limitQuantity;
    List<String> allowedPlanIds = [];
    String clean = rules;

    // Extrair [LIMITE:N]
    final limitMatch = RegExp(r'\[LIMITE:(\d+)\]').firstMatch(clean);
    if (limitMatch != null) {
      limitQuantity = int.tryParse(limitMatch.group(1) ?? '');
      clean = clean.replaceAll(limitMatch.group(0)!, '');
    }

    // Extrair [PLANS:id1,id2]
    final plansMatch = RegExp(r'\[PLANS:([^\]]+)\]').firstMatch(clean);
    if (plansMatch != null) {
      final idsStr = plansMatch.group(1) ?? '';
      allowedPlanIds = idsStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      clean = clean.replaceAll(plansMatch.group(0)!, '');
    }

    clean = clean.replaceAll('[ARMS_PRO]', '').trim();

    return {
      'isArmsPro': isArmsPro,
      'limitQuantity': limitQuantity,
      'allowedPlanIds': allowedPlanIds,
      'cleanRules': clean,
    };
  }

  /// Formata a string de regras de desconto incluindo tags de plano e limites
  static String formatArmsProDiscountRules({
    required String baseRules,
    bool isArmsPro = false,
    int? limitQuantity,
    List<String>? specificPlanIds,
  }) {
    final tags = <String>[];
    if (isArmsPro) tags.add('[ARMS_PRO]');
    if (limitQuantity != null && limitQuantity > 0) tags.add('[LIMITE:$limitQuantity]');
    if (specificPlanIds != null && specificPlanIds.isNotEmpty) {
      tags.add('[PLANS:${specificPlanIds.join(',')}]');
    }

    final prefix = tags.join('');
    final cleanBase = baseRules.trim();
    if (prefix.isEmpty) return cleanBase;
    if (cleanBase.isEmpty) return prefix;
    return '$prefix $cleanBase';
  }

  /// Verifica se um cupom/desconto é elegível para o usuário com base no seu plano Arms Pro
  static bool isDiscountApplicableForPlan({
    required String? discountRules,
    required String userPlanId,
  }) {
    final parsed = parseArmsProDiscountRules(discountRules);
    final isArmsPro = parsed['isArmsPro'] as bool;
    final allowedPlans = parsed['allowedPlanIds'] as List<String>;

    // Se não tiver restrição Arms Pro, qualquer usuário/plano tem acesso
    if (!isArmsPro) return true;

    // Se for restrito ao Arms Pro mas sem planos específicos, qualquer plano Arms Pro serve
    if (allowedPlans.isEmpty) return true;

    // Se houver planos específicos, verifica se o plano do usuário está na lista
    return allowedPlans.contains(userPlanId);
  }

  // -------------------------------------------------------------
  // MÓDULO B: GESTÃO DE ASSINATURAS E MEMBROS
  // -------------------------------------------------------------

  /// Cancela uma assinatura ativa
  Future<void> cancelSubscription(String subscriptionId, {String? reason}) async {
    final index = _subscriptions.indexWhere((s) => s.id == subscriptionId);
    if (index >= 0) {
      _subscriptions[index].status = 'Cancelada';
      _subscriptions[index].cancellationReason = reason ?? 'Cancelado pelo Administrador';
      await _saveSubscriptionsToStorage();
    }
  }

  /// Renova manualmente uma assinatura, prorrogando a data de vencimento
  Future<void> renewSubscription(String subscriptionId, {DateTime? newNextBillingDate}) async {
    final index = _subscriptions.indexWhere((s) => s.id == subscriptionId);
    if (index >= 0) {
      final sub = _subscriptions[index];
      final plan = getPlanById(sub.planId);
      final daysToAdd = plan?.billingCycle == 'Anual'
          ? 365
          : plan?.billingCycle == 'Trimestral'
              ? 90
              : 30;

      final updatedDate = newNextBillingDate ?? (sub.nextBillingDate.isBefore(DateTime.now())
          ? DateTime.now().add(Duration(days: daysToAdd))
          : sub.nextBillingDate.add(Duration(days: daysToAdd)));

      sub.nextBillingDate = updatedDate;
      sub.status = 'Ativa';
      await _saveSubscriptionsToStorage();
    }
  }

  /// Estorna o pagamento da assinatura e a cancela
  Future<void> refundSubscription(String subscriptionId, {String? reason}) async {
    final index = _subscriptions.indexWhere((s) => s.id == subscriptionId);
    if (index >= 0) {
      _subscriptions[index].status = 'Cancelada';
      _subscriptions[index].cancellationReason = 'Estornado: ${reason ?? 'Solicitação de reembolso'}';
      _subscriptions[index].amountPaid = 0.0;
      await _saveSubscriptionsToStorage();
    }
  }

  /// Atualiza o status diretamente (ex: de Pendente para Ativa ao aprovar pagamento)
  Future<void> updateSubscriptionStatus(String subscriptionId, String newStatus) async {
    final index = _subscriptions.indexWhere((s) => s.id == subscriptionId);
    if (index >= 0) {
      _subscriptions[index].status = newStatus;
      await _saveSubscriptionsToStorage();
    }
  }

  // -------------------------------------------------------------
  // DADOS PADRÕES INICIAIS (ARMS GYM BRAND)
  // -------------------------------------------------------------

  List<PlanModel> _getDefaultPlans() {
    return [
      PlanModel(
        id: '1',
        name: 'Arms Pro Mensal',
        price: 89.90,
        billingCycle: 'Mensal',
        highlightTag: 'Mais Popular',
        benefits: [
          'Acesso ao aplicativo móvel Arms Pro',
          'Descontos exclusivos nos parceiros credenciados',
          'Check-in facilitado nas unidades',
        ],
        isActive: true,
        eligiblePartnerIds: [170],
        createdAt: DateTime(2026, 9, 9),
      ),
    ];
  }

  List<SubscriptionMemberModel> _getDefaultSubscriptions() {
    // 100% dados reais: sem assinaturas fabricadas
    return [];
  }
}
