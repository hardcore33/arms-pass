import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Modelo de dados de um Plano Arms Pró
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
      name: json['name']?.toString() ?? 'Plano Arms Pró',
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

/// Modelo de Assinatura de Membro Arms Pró
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
      planName: json['planName']?.toString() ?? 'Arms Pró',
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

  bool _initialized = false;
  List<PlanModel> _plans = [];
  List<SubscriptionMemberModel> _subscriptions = [];

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
        _plans = decoded.map((e) => PlanModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        _plans = _getDefaultPlans();
      }
    } else {
      _plans = _getDefaultPlans();
      await _savePlansToStorage();
    }

    if (subsJson != null && subsJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(subsJson);
        _subscriptions = decoded.map((e) => SubscriptionMemberModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        _subscriptions = _getDefaultSubscriptions();
      }
    } else {
      _subscriptions = _getDefaultSubscriptions();
      await _saveSubscriptionsToStorage();
    }

    _initialized = true;
    notifyListeners();
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

  /// Adiciona ou atualiza um plano
  Future<void> savePlan(PlanModel plan) async {
    final index = _plans.indexWhere((p) => p.id == plan.id);
    if (index >= 0) {
      _plans[index] = plan;
    } else {
      _plans.insert(0, plan);
    }
    await _savePlansToStorage();
  }

  /// Alterna o status (Ativo / Inativo) de um plano
  Future<void> togglePlanStatus(String planId) async {
    final index = _plans.indexWhere((p) => p.id == planId);
    if (index >= 0) {
      _plans[index].isActive = !_plans[index].isActive;
      await _savePlansToStorage();
    }
  }

  /// Exclui um plano
  Future<void> deletePlan(String planId) async {
    _plans.removeWhere((p) => p.id == planId);
    await _savePlansToStorage();
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

  /// Retorna um resumo detalhado do parceiro em relação ao ecossistema Arms Pró
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

  /// Analisa a string de regras de desconto/cupom e extrai metadados do Arms Pró
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

  /// Verifica se um cupom/desconto é elegível para o usuário com base no seu plano Arms Pró
  static bool isDiscountApplicableForPlan({
    required String? discountRules,
    required String userPlanId,
  }) {
    final parsed = parseArmsProDiscountRules(discountRules);
    final isArmsPro = parsed['isArmsPro'] as bool;
    final allowedPlans = parsed['allowedPlanIds'] as List<String>;

    // Se não tiver restrição Arms Pró, qualquer usuário/plano tem acesso
    if (!isArmsPro) return true;

    // Se for restrito ao Arms Pró mas sem planos específicos, qualquer plano Arms Pró serve
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
        id: 'plan_mensal',
        name: 'Arms Pró Mensal',
        price: 99.90,
        billingCycle: 'Mensal',
        highlightTag: 'Flexível',
        benefits: [
          'Acesso livre a toda a rede de academias',
          'Descontos exclusivos nos parceiros credenciados',
          'Acesso ao aplicativo móvel Arms Pró',
          'Suporte prioritário na recepção',
        ],
        isActive: true,
        eligiblePartnerIds: [1, 2, 3],
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      PlanModel(
        id: 'plan_black_anual',
        name: 'Arms Pró Black Anual',
        price: 899.90,
        billingCycle: 'Anual',
        highlightTag: 'Mais Popular',
        benefits: [
          'Acesso livre VIP e irrestrito a todas as unidades',
          'Até 30% OFF em toda a rede de parceiros credenciados',
          'Concierge VIP para agendamentos',
          '1 consulta nutricional por trimestre',
          'Kit exclusivo Arms Gym de boas-vindas',
          'Convite mensal para um amigo treinar',
        ],
        isActive: true,
        eligiblePartnerIds: [1, 2, 3, 4, 5],
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      PlanModel(
        id: 'plan_trimestral',
        name: 'Arms Pró Trimestral',
        price: 269.70,
        billingCycle: 'Trimestral',
        highlightTag: '10% OFF',
        benefits: [
          'Acesso livre a toda a rede de academias',
          'Descontos especiais na rede parceira credenciada',
          'Avaliação física mensal incluída',
          'Toalha e armário exclusivo na unidade sede',
        ],
        isActive: true,
        eligiblePartnerIds: [1, 2, 4],
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
    ];
  }

  List<SubscriptionMemberModel> _getDefaultSubscriptions() {
    final now = DateTime.now();
    return [
      SubscriptionMemberModel(
        id: 'sub_001',
        customerId: 101,
        userName: 'Carlos Eduardo Mendes',
        userCpf: '12345678901',
        userEmail: 'carlos.mendes@email.com',
        planId: 'plan_black_anual',
        planName: 'Arms Pró Black Anual',
        startDate: now.subtract(const Duration(days: 120)),
        nextBillingDate: now.add(const Duration(days: 245)),
        status: 'Ativa',
        lastPaymentMethod: 'Cartão de Crédito',
        amountPaid: 899.90,
      ),
      SubscriptionMemberModel(
        id: 'sub_002',
        customerId: 102,
        userName: 'Fernanda Lima Ribeiro',
        userCpf: '98765432100',
        userEmail: 'fernanda.ribeiro@email.com',
        planId: 'plan_mensal',
        planName: 'Arms Pró Mensal',
        startDate: now.subtract(const Duration(days: 25)),
        nextBillingDate: now.add(const Duration(days: 5)),
        status: 'Ativa',
        lastPaymentMethod: 'PIX Recorrente',
        amountPaid: 99.90,
      ),
      SubscriptionMemberModel(
        id: 'sub_003',
        customerId: 103,
        userName: 'Roberto Albuquerque',
        userCpf: '45678912344',
        userEmail: 'roberto.alb@email.com',
        planId: 'plan_trimestral',
        planName: 'Arms Pró Trimestral',
        startDate: now.subtract(const Duration(days: 95)),
        nextBillingDate: now.subtract(const Duration(days: 5)),
        status: 'Vencida',
        lastPaymentMethod: 'Boleto Bancário',
        amountPaid: 269.70,
      ),
      SubscriptionMemberModel(
        id: 'sub_004',
        customerId: 104,
        userName: 'Mariana Souza Castro',
        userCpf: '32165498722',
        userEmail: 'mariana.castro@email.com',
        planId: 'plan_mensal',
        planName: 'Arms Pró Mensal',
        startDate: now.subtract(const Duration(days: 2)),
        nextBillingDate: now.add(const Duration(days: 28)),
        status: 'Pendente de Pagamento',
        lastPaymentMethod: 'PIX',
        amountPaid: 99.90,
      ),
      SubscriptionMemberModel(
        id: 'sub_005',
        customerId: 105,
        userName: 'Thiago Martins Fonseca',
        userCpf: '65498732155',
        userEmail: 'thiago.fonseca@email.com',
        planId: 'plan_black_anual',
        planName: 'Arms Pró Black Anual',
        startDate: now.subtract(const Duration(days: 200)),
        nextBillingDate: now.subtract(const Duration(days: 20)),
        status: 'Cancelada',
        lastPaymentMethod: 'Cartão de Crédito',
        amountPaid: 899.90,
        cancellationReason: 'Mudança de cidade',
      ),
    ];
  }
}
