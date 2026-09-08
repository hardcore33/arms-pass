Future<List<dynamic>?> filtrarPorNome(
    List<dynamic>? jsonList, String? nome, int searchType, bool? filter) async {
  if (jsonList == null || jsonList.isEmpty) return [];
  if (nome == null || nome.trim().isEmpty) return jsonList;
  final termoLower = nome.trim().toLowerCase();
  final termoDigits = termoLower.replaceAll(RegExp(r'[^0-9]'), '');

  if (searchType == 1) {
    // Busca em Usuários / Clientes
    return jsonList.where((element) {
      if (element is! Map) return false;

      final name = (element['name'] ?? '').toString().toLowerCase();
      final cpf = (element['cpf'] ?? '').toString().toLowerCase();
      final cpfDigits = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      final cardNumber = (element['cardNumber'] ?? '').toString().toLowerCase();
      final cardDigits = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');
      final email = (element['user'] is Map ? (element['user']['login'] ?? '') : '').toString().toLowerCase();
      final id = (element['id'] ?? '').toString().toLowerCase();

      // Parceiro vinculado
      final partnerCnpj = (element['partner'] is Map ? (element['partner']['cnpj'] ?? '') : '').toString().toLowerCase();
      final partnerCnpjDigits = partnerCnpj.replaceAll(RegExp(r'[^0-9]'), '');
      final partnerFantasia = (element['partner'] is Map ? (element['partner']['fantasia'] ?? '') : '').toString().toLowerCase();

      final matchName = name.contains(termoLower);
      final matchCpf = cpf.contains(termoLower) || (termoDigits.isNotEmpty && cpfDigits.contains(termoDigits));
      final matchCard = cardNumber.contains(termoLower) || (termoDigits.isNotEmpty && cardDigits.contains(termoDigits));
      final matchEmail = email.contains(termoLower);
      final matchId = id.contains(termoLower);
      final matchPartner = partnerFantasia.contains(termoLower) || partnerCnpj.contains(termoLower) || (termoDigits.isNotEmpty && partnerCnpjDigits.contains(termoDigits));

      return matchName || matchCpf || matchCard || matchEmail || matchId || matchPartner;
    }).toList();
  } else if (searchType == 2) {
    return jsonList
        .where((element) =>
            element is Map &&
            (element['razao'] ?? '').toString().toLowerCase().contains(termoLower))
        .toList();
  } else if (searchType == 3) {
    return jsonList
        .where((element) =>
            element is Map &&
            element['customer'] is Map &&
            (element['customer']['name'] ?? '').toString().toLowerCase().contains(termoLower))
        .toList();
  } else if (searchType == 4) {
    return jsonList
        .where((element) =>
            element is Map &&
            element['partner'] is Map &&
            (element['partner']['fantasia'] ?? element['partner']['nome'] ?? '').toString().toLowerCase().contains(termoLower))
        .toList();
  } else if (searchType == 5) {
    return jsonList
        .where((element) =>
            element is Map &&
            (element['imagem'] ?? '').toString().toLowerCase().contains(termoLower))
        .toList();
  } else if (searchType == 6) {
    return jsonList
        .where((element) =>
            element is Map &&
            (element['description'] ?? '').toString().toLowerCase().contains(termoLower))
        .toList();
  }
  return jsonList;
}
