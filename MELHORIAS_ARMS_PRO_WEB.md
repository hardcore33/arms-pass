# 📋 Registro de Melhorias — Suporte ao Arms Pró no Painel Web

> **Data:** 2026-09-07  
> **Projeto:** Procard / Arms Gym (`procard_teste_de_melhorias`)  
> **Escopo:** Suporte à exclusividade de ofertas Arms Pró, controle de estoque/limite de cupons e criação autônoma por parceiros e administradores.

---

## 1. 🎯 Objetivo das Alterações

O programa **Arms Pró** é o clube de benefícios por assinatura VIP dos membros da Arms Gym. Para permitir que parceiros criem ofertas exclusivas e agressivas (ex.: *"Compre 1 e leve o outro com 50% de desconto"*, *"Leve 2 e Pague 1"*), foram adicionados no **Painel Web**:
1. **Liberação para Criação Autônoma por Parceiros:** Parceiros podem criar e gerenciar cupons diretamente de seu portal (pelo Dashboard e pela aba "Cupons").
2. **Controle de Exclusividade VIP:** Indicação de cupons restritos a assinantes do Arms Pró.
3. **Limite de Quantidade (Estoque de Cupons Escassos):** Proteção financeira para o parceiro limitar a quantidade total de cupons disponíveis (ex.: máximo de 20 vouchers).
4. **Regras e Condições Detalhadas:** Campo textual para especificar restrições (dias de uso, itens válidos, formatos compre 1 leve 2, etc.).
5. **Gestão de Assinatura pelo Administrador:** Possibilidade de conceder ou pausar o status de `Membro Arms Pró` diretamente na tela de edição de clientes.
6. **Badges Visuais Unificados:** Indicadores de "Arms Pró VIP ⭐" e "Estoque: X un." nas tabelas de cupons do parceiro, no dashboard do parceiro e na tabela administrativa.

---

## 2. 🧩 Componentes e Telas Alterados

### 2.1 Modal de Adicionar Desconto do Parceiro
* **Arquivos:**
  * [modal_adicionar_desconto_parceiro_widget.dart](file:///Users/julianobrustolin/Downloads/procard_teste_de_melhorias/lib/components/modal_adicionar_desconto_parceiro/modal_adicionar_desconto_parceiro_widget.dart)
  * [modal_adicionar_desconto_parceiro_model.dart](file:///Users/julianobrustolin/Downloads/procard_teste_de_melhorias/lib/components/modal_adicionar_desconto_parceiro/modal_adicionar_desconto_parceiro_model.dart)
* **Novos Campos & Controles:**
  * **Card Switch "Exclusivo Membros Arms Pró ⭐ (VIP)":** Toggle que define se o cupom é exclusivo para assinantes.
  * **Campo "Limite de Cupons (Estoque)":** Input numérico para definir a quantidade máxima disponível (vazio = ilimitado).
  * **Campo "Regras / Condições da Oferta":** Input textual para orientações de uso.
  * **Sugestões de Formato no Hint:** Orienta o parceiro sobre ofertas como "Compre 1 e ganhe 50% no 2º", "Leve 2 Pague 1" ou percentuais diretos.
* **Resiliência e UX:**
  * Resolução resiliente de `tenantId` e `segmentId` com fallbacks automáticos para nunca travar a gravação.
  * Adicionado `SingleChildScrollView` e largura responsiva (`clamp(460.0, 640.0)`).

---

### 2.2 Dashboard do Parceiro
* **Arquivo:** [dashboard_parceiro_widget.dart](file:///Users/julianobrustolin/Downloads/procard_teste_de_melhorias/lib/pages/dashboard_parceiro/dashboard_parceiro_widget.dart)
* **Novidades:**
  * **Botão de Ação Rápida "+ Nova Promoção"** no cabeçalho do card "Promoções em Destaque", abrindo o modal de criação diretamente sem necessidade de trocar de tela.
  * **Badges Visuais nos Itens:** Exibição imediata das etiquetas douradas "Arms Pró VIP ⭐" e "Estoque: X un." na listagem de promoções ativas do parceiro.

---

### 2.3 Listagem de Cupons do Parceiro
* **Arquivo:** [listagem_de_cupons_parceiro_widget.dart](file:///Users/julianobrustolin/Downloads/procard_teste_de_melhorias/lib/components/listagem_de_cupons_parceiro/listagem_de_cupons_parceiro_widget.dart)
* **Novidades:**
  * Botão **"Cadastrar Promoção"** em destaque no topo da tabela.
  * Botão **"Editar Promoção"** para cada cupom existente, permitindo ajustar regras, estoque e exclusividade VIP.
  * Badges visuais estilizados para identificar cupons VIP e com controle de estoque.

---

### 2.4 Modal de Alteração de Desconto
* **Arquivos:**
  * [modal_alterar_desconto_widget.dart](file:///Users/julianobrustolin/Downloads/procard_teste_de_melhorias/lib/components/modal_alterar_desconto/modal_alterar_desconto_widget.dart)
  * [modal_alterar_desconto_model.dart](file:///Users/julianobrustolin/Downloads/procard_teste_de_melhorias/lib/components/modal_alterar_desconto/modal_alterar_desconto_model.dart)
* **Comportamento:**
  * Faz o parse automático de `[ARMS_PRO]` e `[LIMITE:X]` existentes nas regras do cupom para pré-ativar o switch e preencher o limite ao abrir a edição.
  * Permite atualizar esses parâmetros mantendo 100% de compatibilidade com os cupons já cadastrados no banco.

---

### 2.5 Listagem Geral de Cupons (Visão Administrador)
* **Arquivo:** [listagem_de_cupom_widget.dart](file:///Users/julianobrustolin/Downloads/procard_teste_de_melhorias/lib/components/listagem_de_cupom/listagem_de_cupom_widget.dart)
* **Novidades:**
  * Parsing automático de `[ARMS_PRO]` e `[LIMITE:X]` na coluna de Benefício/Regras.
  * Exibição dos badges "Arms Pró VIP ⭐" e "Estoque: X un." garantindo que o administrador veja exatamente o mesmo nível de detalhe que o parceiro.

---

### 2.6 Modal de Edição de Clientes / Usuários
* **Arquivos:**
  * [modal_de_alterar_customer_widget.dart](file:///Users/julianobrustolin/Downloads/procard_teste_de_melhorias/lib/components/modal_de_alterar_customer/modal_de_alterar_customer_widget.dart)
  * [modal_de_alterar_customer_model.dart](file:///Users/julianobrustolin/Downloads/procard_teste_de_melhorias/lib/components/modal_de_alterar_customer/modal_de_alterar_customer_model.dart)
* **Novos Controles:**
  * **Card Switch "Membro Arms Pró (VIP)":**
    * Pré-carrega o valor do JSON (`$.armspass == true`).
    * Permite ao Administrador ativar ou revogar a assinatura do cliente com um clique.
    * Ao salvar, envia `armspass: _model.armspassValue` na chamada `EditarCustomerCall`.
    * A coluna **`PASS`** na listagem de usuários (`lib/components/listagem_de_usuarios/`) reflete a alteração imediatamente.

---

## 3. 📡 Estrutura de Dados e Compatibilidade com as APIs

Para garantir total estabilidade sem quebrar o backend existente, os metadados foram estruturados de forma retrocompatível:

| Campo | Payload da API | Descrição |
| :--- | :--- | :--- |
| **Exclusivo Arms Pró** | Tag `[ARMS_PRO]` no campo `rules` | Identifica se a oferta é VIP para assinantes. |
| **Limite de Estoque** | Tag `[LIMITE:X]` no campo `rules` | Quantidade máxima total disponibilizada. |
| **Regras da Oferta** | Texto livre após as tags no campo `rules` | Ex: *"Compre 1 e ganhe 50% no 2º prato"*. |
| **Status do Membro** | `armspass: boolean` em `/api/v1/customer` | `true` para assinante VIP, `false` para padrão. |

### Exemplo de Payload Enviado ao Salvar Cupom:
```json
{
  "description": "Compre 1 e ganhe 50% no segundo Poke",
  "discount": "50",
  "isActive": true,
  "validity": "2026-10-31",
  "partner": { "id": "2" },
  "tenant": { "id": "1" },
  "segment": { "id": "2" },
  "rules": "[ARMS_PRO][LIMITE:20] Válido de segunda a quinta para consumo no local."
}
```

---

## 4. 📱 Como o App Mobile Consome Essas Regras

1. **Filtro de Exclusividade:**
   * Se `rules.contains('[ARMS_PRO]')` e o usuário não for `armspass == true`, o app exibe a tag dourada *"Exclusivo Arms Pró"* com botão convidando para assinar o plano VIP.
2. **Contador de Escassez:**
   * Se houver `[LIMITE:20]`, o app exibe a barra de progresso: *"Oferta limitada: garanta já o seu voucher"*.
3. **Identificação do Membro:**
   * Membros com `armspass == true` visualizam o cartão virtual no modo Black & Gold VIP com selo ativo.
