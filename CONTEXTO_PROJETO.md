# 📋 Contexto do Projeto — Procard Teste de Melhorias
> Última atualização: 2026-08-12

---

## 🏗️ Estrutura do Projeto

- **Origem:** FlutterFlow (exportado para Flutter manual)
- **Pasta ativa:** `/Users/julianobrustolin/Downloads/procard_teste_de_melhorias`
- **Pasta de backup (Desktop):** `/Users/julianobrustolin/Desktop/procard_teste_de_melhorias`
- **Flutter:** 3.44.9 (Dart 3.12.2) — atualizado em 2026-08-12
- **Sem Git configurado** — recomendado configurar urgente

---

## 🔧 Correções de Dependências Aplicadas (pubspec.yaml)

```yaml
dependency_overrides:
  http: 1.4.0
  uuid: ^4.0.0
  font_awesome_flutter: 11.0.0   # quebrava com Flutter 3.44 (IconData final class)
  page_transition: 2.2.2          # CupertinoPageTransitionsBuilder removido no Flutter 3.44
```

**Arquivo alterado manualmente:**
- `lib/flutter_flow/flutter_flow_widgets.dart` linha 67:
  - ANTES: `final IconData? iconData;`
  - DEPOIS: `final FaIconData? iconData;`

---

## ✅ Item 2 — Bug de Overflow — CONCLUÍDO

### Auditoria completa (2026-08-12) — modal_adicionar_parceiro e modal_editar_parceiro

| Verificação | modal_adicionar_parceiro | modal_editar_parceiro |
|---|---|---|
| Linhas totais | 3.538 | 3.661 |
| ZIP (18:27) = Desktop? | ✅ Idênticos (diff vazio) | ✅ Idênticos (diff vazio) |
| Erros de compilação | **0** ✅ | **0** ✅ |
| Balanço `( )` | 1429 / 1429 ✅ | 1496 / 1496 ✅ |
| Balanço `{ }` | 55 / 55 ✅ | 61 / 61 ✅ |
| `width: 380` fixo | **0 ocorrências** ✅ | **0 ocorrências** ✅ |
| Senha hardcoded | ✅ Seguro | ✅ Seguro |
| Campo Filial | ❌ Nunca existiu em nenhuma versão | ❌ Nunca existiu em nenhuma versão |
| CNPJ | ✅ Autofill presente | ✅ Pré-carregado da API (JSONPath) |
| Representante | ✅ Campos presentes (Nome, RG, CPF, Tel, Email, Senha) | ✅ Idem |

### Conclusões definitivas:
- Os arquivos do ZIP FlutterFlow (18:27) e do Desktop são **byte a byte idênticos** nos dois modais.
- **Nenhuma corrupção** de parênteses ou chaves — versão restaurada do Desktop está íntegra.
- O `width: 380` foi **eliminado** — campos usam `MediaQuery` (responsivo).
- A informação anterior de "campo Filial perdido no zip novo" estava **incorreta** — o campo nunca existiu em nenhuma das versões auditadas.
- **Sem senha pré-preenchida** em nenhum dos dois modais — seguro.

---

## ✅ Item 6 — Funcionalidades Customizadas

### Arquivos presentes APENAS na versão corrigida (Desktop/Downloads atual)
Estes arquivos **não existem** no zip original do FlutterFlow:

| Arquivo/Pasta | Função |
|---|---|
| `components/box_grafico_cupons/` | Gráfico de cupons |
| `components/box_parceiros_destaque/` | Box parceiros em destaque |
| `components/box_segmentos_destaque/` | Box segmentos em destaque |
| `components/header_pagina/` | Header customizado |
| `components/modal_adicionar_desconto_parceiro/` | Modal de desconto para parceiro |
| `components/modal_alterar_desconto/` | Modal de alteração de desconto |
| `components/modal_solicitar_banner/` | Modal para solicitar banner |
| `custom_code/actions/get_company_by_cnpj.dart` | Action de autofill do CNPJ |
| `flutter_flow/cpf_cnpj_formatter.dart` | Formatador CPF/CNPJ |

### Lote 2 do Item 6 — PENDENTE
- Detalhar quais funcionalidades do Lote 2 ainda precisam ser implementadas/verificadas.

---

## 📌 Pendências abertas

- [ ] **Configurar Git** (URGENTE — evitar perda de trabalho novamente)
- [ ] **Detalhar Lote 2 do Item 6** — retomar com o usuário
- [ ] **Testar visualmente** os modais de Adicionar/Editar Parceiro no Chrome

---

## 🛠️ Comandos Úteis

```bash
# Rodar o app
flutter run -d chrome

# Verificar erros
dart analyze lib/

# Build web
flutter build web

# Inicializar Git (URGENTE)
git init
git add .
git commit -m "chore: estado inicial com correções aplicadas"
```
