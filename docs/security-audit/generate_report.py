#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script de Geração do Relatório de Auditoria de Segurança
Projeto: Procard / Arms Web (FlutterFlow / Flutter Web)
Gera o relatório visual em PDF utilizando HTML5, SVG e Headless Chrome.
"""

import os
import sys
import subprocess
from datetime import datetime

CHROME_PATH = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
OUTPUT_DIR = os.path.dirname(os.path.abspath(__file__))
HTML_PATH = os.path.join(OUTPUT_DIR, "relatorio-auditoria-seguranca.html")
PDF_PATH = os.path.join(OUTPUT_DIR, "relatorio-auditoria-seguranca.pdf")

HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Relatório de Auditoria de Segurança — Procard / Arms Web</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap');

  @page {
    size: A4;
    margin: 18mm 16mm 18mm 16mm;
    @top-center {
      content: "Relatório de Auditoria de Segurança — Procard / Arms Web";
      font-family: 'Inter', sans-serif;
      font-size: 8pt;
      color: #94A3B8;
      border-bottom: 1px solid #E2E8F0;
      padding-bottom: 4px;
      width: 100%;
    }
    @bottom-left {
      content: "Confidencial • Uso Interno";
      font-family: 'Inter', sans-serif;
      font-size: 8pt;
      color: #94A3B8;
    }
    @bottom-right {
      content: "Página " counter(page);
      font-family: 'Inter', sans-serif;
      font-size: 8pt;
      font-weight: 600;
      color: #64748B;
    }
  }

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    color: #1E293B;
    background: #FFFFFF;
    font-size: 9pt;
    line-height: 1.45;
  }

  .page-break {
    page-break-before: always;
  }

  .avoid-break {
    page-break-inside: avoid;
  }

  /* Capa */
  .cover {
    min-height: 92vh;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 24px 16px;
    page-break-after: always;
  }

  .cover-header {
    border-bottom: 4px solid #B91C1C;
    padding-bottom: 20px;
  }

  .cover-badge {
    display: inline-block;
    background: #FEF2F2;
    color: #B91C1C;
    font-weight: 700;
    font-size: 9.5pt;
    padding: 5px 12px;
    border-radius: 9999px;
    border: 1px solid #FCA5A5;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    margin-bottom: 14px;
  }

  .cover-title {
    font-size: 26pt;
    font-weight: 800;
    line-height: 1.15;
    color: #0F172A;
    margin-bottom: 8px;
  }

  .cover-subtitle {
    font-size: 12pt;
    font-weight: 400;
    color: #475569;
  }

  .cover-meta {
    background: #F8FAFC;
    border: 1px solid #E2E8F0;
    border-radius: 10px;
    padding: 16px;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
    margin: 20px 0;
  }

  .meta-item {
    font-size: 8.5pt;
  }

  .meta-item strong {
    display: block;
    color: #64748B;
    font-size: 7.5pt;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin-bottom: 3px;
  }

  .meta-item span {
    color: #0F172A;
    font-weight: 600;
  }

  .cover-methodology {
    background: #EFF6FF;
    border-left: 4px solid #2563EB;
    padding: 14px;
    border-radius: 0 8px 8px 0;
    font-size: 8.2pt;
    color: #1E3A8A;
    line-height: 1.45;
  }

  .cover-footer {
    border-top: 1px solid #E2E8F0;
    padding-top: 12px;
    font-size: 7.5pt;
    color: #94A3B8;
    display: flex;
    justify-content: space-between;
  }

  /* Seções */
  h2 {
    font-size: 15pt;
    font-weight: 700;
    color: #0F172A;
    margin-top: 20px;
    margin-bottom: 10px;
    border-bottom: 2px solid #F1F5F9;
    padding-bottom: 5px;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  h3 {
    font-size: 11pt;
    font-weight: 600;
    color: #1E293B;
    margin-top: 14px;
    margin-bottom: 6px;
  }

  p {
    margin-bottom: 8px;
    color: #334155;
  }

  ul, ol {
    margin-left: 18px;
    margin-bottom: 10px;
  }

  li {
    margin-bottom: 3px;
    color: #334155;
  }

  /* Chips de Severidade */
  .chip {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 2px 7px;
    border-radius: 5px;
    font-size: 7.2pt;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    white-space: nowrap;
  }

  .chip-critica { background: #FEE2E2; color: #B91C1C; border: 1px solid #FCA5A5; }
  .chip-alta    { background: #FFEDD5; color: #EA580C; border: 1px solid #FDBA74; }
  .chip-media   { background: #FEF3C7; color: #D97706; border: 1px solid #FCD34D; }
  .chip-baixa   { background: #DBEAFE; color: #2563EB; border: 1px solid #93C5FD; }
  .chip-forte   { background: #D1FAE5; color: #059669; border: 1px solid #6EE7B7; }

  /* Cards Resumo */
  .kpi-grid {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 8px;
    margin: 14px 0;
  }

  .kpi-card {
    border-radius: 8px;
    padding: 10px 8px;
    text-align: center;
    border: 1px solid #E2E8F0;
  }

  .kpi-card.critica { background: #FEF2F2; border-color: #FCA5A5; }
  .kpi-card.alta    { background: #FFF7ED; border-color: #FDBA74; }
  .kpi-card.media   { background: #FFFBEB; border-color: #FCD34D; }
  .kpi-card.baixa   { background: #EFF6FF; border-color: #93C5FD; }
  .kpi-card.forte   { background: #ECFDF5; border-color: #6EE7B7; }

  .kpi-num {
    font-size: 18pt;
    font-weight: 800;
    line-height: 1;
    margin-bottom: 3px;
  }

  .kpi-card.critica .kpi-num { color: #B91C1C; }
  .kpi-card.alta .kpi-num    { color: #EA580C; }
  .kpi-card.media .kpi-num   { color: #D97706; }
  .kpi-card.baixa .kpi-num   { color: #2563EB; }
  .kpi-card.forte .kpi-num   { color: #059669; }

  .kpi-label {
    font-size: 7pt;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #475569;
  }

  /* Charts Container */
  .charts-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
    margin: 14px 0;
  }

  .chart-box {
    background: #F8FAFC;
    border: 1px solid #E2E8F0;
    border-radius: 8px;
    padding: 12px;
    text-align: center;
  }

  .chart-box h4 {
    font-size: 8.5pt;
    font-weight: 600;
    color: #334155;
    margin-bottom: 6px;
    text-transform: uppercase;
    letter-spacing: 0.04em;
  }

  /* Tabelas */
  table {
    width: 100%;
    border-collapse: collapse;
    margin: 10px 0 14px 0;
    font-size: 8pt;
  }

  th, td {
    padding: 7px 8px;
    text-align: left;
    vertical-align: top;
    border-bottom: 1px solid #E2E8F0;
  }

  th {
    background: #F1F5F9;
    color: #334155;
    font-weight: 700;
    font-size: 7.5pt;
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  tr:nth-child(even) td {
    background: #FAFAFA;
  }

  .file-loc {
    font-family: 'JetBrains Mono', monospace;
    font-size: 7.2pt;
    color: #0369A1;
    word-break: break-all;
    font-weight: 500;
  }

  /* Blocos de Código */
  pre {
    background: #0F172A;
    color: #F8FAFC;
    padding: 6px 10px;
    border-radius: 5px;
    font-family: 'JetBrains Mono', monospace;
    font-size: 7pt;
    overflow-x: hidden;
    white-space: pre-wrap;
    word-break: break-all;
    margin: 4px 0;
    border: 1px solid #1E293B;
  }

  /* Callouts */
  .callout {
    padding: 10px 12px;
    border-radius: 6px;
    margin: 10px 0;
    font-size: 8.2pt;
    line-height: 1.4;
  }

  .callout-danger {
    background: #FEF2F2;
    border-left: 4px solid #B91C1C;
    color: #991B1B;
  }

  .callout-success {
    background: #ECFDF5;
    border-left: 4px solid #059669;
    color: #065F46;
  }

  .callout-warning {
    background: #FFFBEB;
    border-left: 4px solid #D97706;
    color: #92400E;
  }

  /* GitHub Issues Box */
  .issue-container {
    background: #F8FAFC;
    border: 1px solid #CBD5E1;
    border-radius: 6px;
    padding: 12px;
    margin-bottom: 14px;
  }

  .issue-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #E2E8F0;
    padding-bottom: 6px;
    margin-bottom: 8px;
  }

  .issue-title {
    font-size: 9.5pt;
    font-weight: 700;
    color: #0F172A;
  }

  .issue-md-content {
    background: #FFFFFF;
    border: 1px solid #E2E8F0;
    border-radius: 5px;
    padding: 8px 10px;
    font-family: 'JetBrains Mono', monospace;
    font-size: 6.8pt;
    line-height: 1.35;
    color: #1E293B;
    white-space: pre-wrap;
    word-break: break-word;
  }
</style>
</head>
<body>

<!-- CAPA -->
<div class="cover">
  <div class="cover-header">
    <div class="cover-badge">Auditoria Técnica de Código-Fonte</div>
    <h1 class="cover-title">Relatório de Auditoria de Segurança</h1>
    <div class="cover-subtitle">Avaliação Sistemática de Vulnerabilidades e Arquitetura Multi-Tenant</div>
  </div>

  <div class="cover-meta">
    <div class="meta-item">
      <strong>Aplicação / Alvo</strong>
      <span>Procard / Arms Web (Sistema de Fidelidade, Cupons & Assinaturas)</span>
    </div>
    <div class="meta-item">
      <strong>Data da Avaliação</strong>
      <span>10 de Setembro de 2026</span>
    </div>
    <div class="meta-item">
      <strong>Stack Identificada</strong>
      <span>Flutter / Dart (FlutterFlow), GoRouter, HTTP REST Gateway</span>
    </div>
    <div class="meta-item">
      <strong>Serviço Backend Integrado</strong>
      <span>REST API em codeflowbr.online:8080 (Spring Boot / JPA / PostgreSQL)</span>
    </div>
    <div class="meta-item">
      <strong>Escopo Auditado</strong>
      <span>lib/ (Frontend, Auth, Routing, Endpoints, Custom Actions, Assets) & Configs</span>
    </div>
    <div class="meta-item">
      <strong>Status Geral</strong>
      <span style="color: #B91C1C;">4 Críticas, 6 Altas, 3 Médias, 1 Baixa | 4 Pontos Fortes</span>
    </div>
  </div>

  <div class="cover-methodology">
    <strong>Nota Metodológica — Mapeamento para a Stack Detectada:</strong><br>
    A aplicação consiste em um cliente Flutter Web (gerado e estendido sobre FlutterFlow) que se comunica com uma API REST proprietária em <code>https://codeflowbr.online:8080/api/v1/</code> através de classes customizadas em <code>api_calls.dart</code> e <code>api_manager.dart</code>. As cinco categorias exigidas foram mapeadas rigorosamente para este ecossistema:
    <br>• <strong>1. Banco Sem Tranca:</strong> Como a stack não utiliza RLS nativo (como Supabase/Firebase) nem middleware de tenant na API, auditamos todas as chamadas de listagem, busca e agregação (<code>/customer</code>, <code>/dashboard</code>, <code>/discount</code>, <code>/trade</code>) quanto à ausência de filtragem server-side por inquilino autenticado e à injeção estática de <code>tenantId = '1'</code> controlada pelo cliente.
    <br>• <strong>2. Permissão no Navegador:</strong> Mapeamento dos gates condicionais de interface baseados em papéis (<code>LoginCall.role(...) == 2</code> em <code>login_widget.dart</code>) cruzados com a total ausência de verificação de privilégios nas rotas do GoRouter (<code>requireAuth = false</code>) e nos endpoints administrativos da API.
    <br>• <strong>3. IDOR:</strong> Varredura exaustiva nos métodos de exclusão, edição e leitura que aceitam identificadores diretos por rota ou corpo JSON (<code>PUT /user</code>, <code>DELETE /discount/{id}</code>, <code>DELETE /product/{id}</code>, <code>GET /dashboard/partner/{id}</code>, <code>GET /history/user/{id}</code>) sem validação de posse.
    <br>• <strong>4. Chaves Expostas:</strong> Investigação de strings de conexão, credenciais embutidas, persistência de credenciais em <code>localStorage</code> (SharedPreferences) e mecanismos inseguros de recuperação de senha em texto claro.
    <br>• <strong>5. Inputs Sem Tratamento:</strong> Inspeção de injeção de JSON por interpolação de strings em payloads REST (<code>'''{ "campo": "${valor}" }'''</code>), validação de esquemas de protocolo em <code>launchURL</code> e rotas de upload desprotegidas.
  </div>

  <div class="cover-footer">
    <span>Documento Técnico de Segurança da Informação</span>
    <span>Procard Tecnologia Ltda. • Confidencial</span>
  </div>
</div>

<!-- RESUMO EXECUTIVO -->
<h2>1. Resumo Executivo</h2>
<p>
A auditoria identificou um cenário de <strong>alta criticidade arquitetural na camada de autorização e isolamento de dados</strong>. A aplicação delega ao cliente Flutter Web toda a responsabilidade de restringir acessos e controlar regras de privilégio, enquanto o backend REST subjacente aceita comandos sem exigir cabeçalhos de autorização (<code>headers: {}</code> em praticamente todas as rotas) e sem validar a posse dos registros manipulados.
</p>

<div class="kpi-grid">
  <div class="kpi-card critica">
    <div class="kpi-num">4</div>
    <div class="kpi-label">Crítica</div>
  </div>
  <div class="kpi-card alta">
    <div class="kpi-num">6</div>
    <div class="kpi-label">Alta</div>
  </div>
  <div class="kpi-card media">
    <div class="kpi-num">3</div>
    <div class="kpi-label">Média</div>
  </div>
  <div class="kpi-card baixa">
    <div class="kpi-num">1</div>
    <div class="kpi-label">Baixa</div>
  </div>
  <div class="kpi-card forte">
    <div class="kpi-num">4</div>
    <div class="kpi-label">Pontos Fortes</div>
  </div>
</div>

<div class="charts-row avoid-break">
  <div class="chart-box">
    <h4>Distribuição de Vulnerabilidades por Severidade</h4>
    <!-- SVG Donut Chart (Circumference: 314.16) Total: 14 (Crítica: 4, Alta: 6, Média: 3, Baixa: 1) -->
    <svg width="240" height="150" viewBox="0 0 240 150">
      <circle cx="80" cy="75" r="50" fill="none" stroke="#E2E8F0" stroke-width="22"/>
      <!-- Critica: 4/14 = 28.57% -> 89.8 -->
      <circle cx="80" cy="75" r="50" fill="none" stroke="#B91C1C" stroke-width="22" stroke-dasharray="89.8 224.4" stroke-dashoffset="0"/>
      <!-- Alta: 6/14 = 42.86% -> 134.6 -->
      <circle cx="80" cy="75" r="50" fill="none" stroke="#EA580C" stroke-width="22" stroke-dasharray="134.6 179.6" stroke-dashoffset="-89.8"/>
      <!-- Media: 3/14 = 21.43% -> 67.3 -->
      <circle cx="80" cy="75" r="50" fill="none" stroke="#D97706" stroke-width="22" stroke-dasharray="67.3 246.9" stroke-dashoffset="-224.4"/>
      <!-- Baixa: 1/14 = 7.14% -> 22.4 -->
      <circle cx="80" cy="75" r="50" fill="none" stroke="#2563EB" stroke-width="22" stroke-dasharray="22.4 291.8" stroke-dashoffset="-291.7"/>
      <!-- Centro -->
      <text x="80" y="71" text-anchor="middle" font-family="Inter" font-size="16" font-weight="800" fill="#0F172A">14</text>
      <text x="80" y="85" text-anchor="middle" font-family="Inter" font-size="7.5" font-weight="600" fill="#64748B">FALHAS</text>
      <!-- Legenda -->
      <g transform="translate(145, 25)" font-family="Inter" font-size="8" font-weight="600">
        <circle cx="6" cy="6" r="5" fill="#B91C1C"/>
        <text x="18" y="9" fill="#334155">Crítica (4)</text>
        <circle cx="6" cy="24" r="5" fill="#EA580C"/>
        <text x="18" y="27" fill="#334155">Alta (6)</text>
        <circle cx="6" cy="42" r="5" fill="#D97706"/>
        <text x="18" y="45" fill="#334155">Média (3)</text>
        <circle cx="6" cy="60" r="5" fill="#2563EB"/>
        <text x="18" y="63" fill="#334155">Baixa (1)</text>
        <circle cx="6" cy="78" r="5" fill="#059669"/>
        <text x="18" y="81" fill="#334155">P. Forte (4)</text>
      </g>
    </svg>
  </div>

  <div class="chart-box">
    <h4>Achados por Categoria Auditada</h4>
    <!-- SVG Bar Chart -->
    <svg width="240" height="150" viewBox="0 0 240 150">
      <g font-family="Inter" font-size="7.5" font-weight="600" fill="#475569">
        <!-- 1. Banco Sem Tranca -->
        <text x="10" y="20">1. Banco Sem Tranca</text>
        <rect x="105" y="11" width="95" height="11" rx="3" fill="#B91C1C"/>
        <text x="206" y="20" fill="#B91C1C" font-weight="700">4</text>

        <!-- 2. Permissão Navegador -->
        <text x="10" y="44">2. Permissão Nav.</text>
        <rect x="105" y="35" width="75" height="11" rx="3" fill="#EA580C"/>
        <text x="186" y="44" fill="#EA580C" font-weight="700">3</text>

        <!-- 3. IDOR -->
        <text x="10" y="68">3. IDOR</text>
        <rect x="105" y="59" width="95" height="11" rx="3" fill="#B91C1C"/>
        <text x="206" y="68" fill="#B91C1C" font-weight="700">4</text>

        <!-- 4. Chaves Expostas -->
        <text x="10" y="92">4. Chaves / Hardcode</text>
        <rect x="105" y="83" width="75" height="11" rx="3" fill="#D97706"/>
        <text x="186" y="92" fill="#D97706" font-weight="700">3</text>

        <!-- 5. Inputs / XSS -->
        <text x="10" y="116">5. Injeção / XSS</text>
        <rect x="105" y="107" width="75" height="11" rx="3" fill="#EA580C"/>
        <text x="186" y="116" fill="#EA580C" font-weight="700">3</text>

        <!-- Pontos Fortes -->
        <text x="10" y="140">Pontos Fortes</text>
        <rect x="105" y="131" width="95" height="11" rx="3" fill="#059669"/>
        <text x="206" y="140" fill="#059669" font-weight="700">4</text>
      </g>
    </svg>
  </div>
</div>

<div class="callout callout-danger avoid-break">
  <strong>Vetor de Ataque Mais Crítico Comprovado:</strong>
  O endpoint <code>GET https://codeflowbr.online:8080/api/v1/customer</code> foi verificado e não exige nenhuma autenticação ou filtro de inquilino. Ele expõe a lista completa de clientes cadastrados, incluindo <strong>nomes, CPFs, números de cartão de fidelidade, e-mails de login, saldos de pontos e endereços completos</strong> de todos os parceiros e inquilinos. Em conjunto, o método <code>PUT /api/v1/user</code> permite submeter qualquer <code>id</code> com novo <code>password</code> e <code>role: 2</code>, viabilizando <strong>Account Takeover global e elevação imediata a Administrador</strong>.
</div>

<!-- PONTOS FORTES E FRACOS -->
<h2 class="page-break">2. Pontos Fortes e Riscos Centrais</h2>

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;" class="avoid-break">
  <div style="background: #ECFDF5; border: 1px solid #A7F3D0; border-radius: 8px; padding: 12px;">
    <h3 style="color: #065F46; margin-top: 0; display: flex; align-items: center; gap: 6px;">
      <span class="chip chip-forte">PROTEGIDO</span> Pontos Fortes Verificados
    </h3>
    <ul style="font-size: 8.2pt; margin-left: 16px; margin-bottom: 0;">
      <li><strong>Sanitização em EditarCustomerCall:</strong> O método <code>escapeStringForJson</code> em <code>api_calls.dart:1547</code> protege aspas (<code>"</code>), barras (<code>\</code>) e quebras de linha no payload de alteração de clientes.</li>
      <li><strong>Higienização estrita de CNPJ:</strong> Em <code>get_company_by_cnpj.dart:15-18</code>, dígitos são filtrados por regex estrita (<code>[^0-9]</code>) e tamanho exato (14 dígitos) antes de chamar a BrasilAPI.</li>
      <li><strong>Formatação e máscara segura de CPF/CNPJ:</strong> Em <code>cpf_cnpj_formatter.dart:15-45</code>, inputs de formulário são higienizados impedindo caracteres não-numéricos no front.</li>
      <li><strong>Resiliência de UI com errorBuilder:</strong> Em <code>listagem_de_parceiros_widget.dart:495</code> e <code>listagem_de_cupom_widget.dart:670</code>, o uso de fallback visual em <code>Image.network</code> evita falhas em cascata com URLs quebradas.</li>
    </ul>
  </div>

  <div style="background: #FEF2F2; border: 1px solid #FECACA; border-radius: 8px; padding: 12px;">
    <h3 style="color: #991B1B; margin-top: 0; display: flex; align-items: center; gap: 6px;">
      <span class="chip chip-critica">RISCO</span> Riscos Centrais Identificados
    </h3>
    <ul style="font-size: 8.2pt; margin-left: 16px; margin-bottom: 0;">
      <li><strong>Ausência de RLS / Tenant Middleware:</strong> Queries de listagem e agregação retornam dados globais sem isolamento entre inquilinos.</li>
      <li><strong>Autorização 100% no Cliente:</strong> Rotas de administração (<code>/usuarios</code>, <code>/parceiros</code>) possuem <code>requireAuth: false</code> e a API não valida privilégios.</li>
      <li><strong>IDOR em Leitura, Edição e Exclusão:</strong> Operações de exclusão (<code>DELETE /discount/{id}</code>, <code>/product/{id}</code>) e leitura aceitam IDs sem checar titularidade.</li>
      <li><strong>Injeção de JSON por Interpolação:</strong> Métodos em <code>api_calls.dart</code> montam JSON via interpolação de strings sem serializador estruturado (<code>jsonEncode</code>).</li>
    </ul>
  </div>
</div>

<div class="page-break"></div>

<!-- TABELA DE ACHADOS -->
<h2>3. Tabela Detalhada de Achados por Categoria</h2>

<table>
  <thead>
    <tr>
      <th style="width: 10%;">Severidade</th>
      <th style="width: 25%;">Arquivo & Linha</th>
      <th style="width: 18%;">Categoria</th>
      <th style="width: 47%;">Descrição, Código e Explorabilidade</th>
    </tr>
  </thead>
  <tbody>
    <!-- BANCO SEM TRANCA -->
    <tr>
      <td><span class="chip chip-critica">Crítica</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:181-197</td>
      <td>1. Banco Sem Tranca</td>
      <td><strong>Vazamento irrestrito de clientes (LGPD):</strong> <code>ObterUsuariosCall</code> (<code>GET /api/v1/customer</code>) sem filtro de tenant ou usuário. Retorna CPF, nomes, cartões e dados de todos os clientes sem autenticação (<code>headers: {}</code>).</td>
    </tr>
    <tr>
      <td><span class="chip chip-alta">Alta</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:18-35</td>
      <td>1. Banco Sem Tranca</td>
      <td><strong>Vazamento de métricas globais no Dashboard:</strong> <code>ObterDashboardCompletoCall</code> (<code>GET /api/v1/dashboard</code>) expõe faturamento e indicadores agregados de todos os inquilinos sem isolamento.</td>
    </tr>
    <tr>
      <td><span class="chip chip-alta">Alta</span></td>
      <td class="file-loc">lib/app_constants.dart:5<br>api_calls.dart:687, 914, 1021, 1433</td>
      <td>1. Banco Sem Tranca</td>
      <td><strong>Tenant Hopping / Tenant controlado pelo cliente:</strong> <code>tenantId = '1'</code> hardcoded e injetado pelo frontend no payload JSON. O servidor aceita qualquer <code>idTenant</code> informado no corpo da requisição.</td>
    </tr>
    <tr>
      <td><span class="chip chip-alta">Alta</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:77-92<br>api_calls.dart:451-468</td>
      <td>1. Banco Sem Tranca</td>
      <td><strong>Listagem irrestrita de cupons e trocas:</strong> <code>ObterDescontosCall</code> (<code>GET /discount</code>) e <code>TrocasCall</code> (<code>GET /trade</code>) listam todos os cupons e histórico de validações de todos os parceiros sem escopo de tenant.</td>
    </tr>

    <!-- PERMISSÃO NO NAVEGADOR -->
    <tr>
      <td><span class="chip chip-critica">Crítica</span></td>
      <td class="file-loc">lib/pages/login/login_widget.dart:377-387<br>lib/flutter_flow/nav/nav.dart:100-140, 336</td>
      <td>2. Permissão Nav.</td>
      <td><strong>Gate cosmético de papel e rotas abertas:</strong> Rotas de admin no GoRouter têm <code>requireAuth = false</code> como padrão. O desvio entre Parceiro e Admin ocorre apenas via <code>if (LoginCall.role(...) == 2)</code> local.</td>
    </tr>
    <tr>
      <td><span class="chip chip-critica">Crítica</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:283, 925, 1032, 1441</td>
      <td>2. Permissão Nav.</td>
      <td><strong>Elevação de privilégio arbitrária via payload:</strong> <code>role</code> é enviado livremente pelo cliente na criação/edição de usuários (<code>AtualizarDadosCall</code>, <code>CriarUsuarioCall</code>). Qualquer usuário pode se promover a Admin (role 2).</td>
    </tr>
    <tr>
      <td><span class="chip chip-alta">Alta</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:1568-1585</td>
      <td>2. Permissão Nav.</td>
      <td><strong>Disparo em massa de notificações push desprotegido:</strong> <code>NotificacaoPushCall</code> (<code>POST /api/v1/notify</code>) envia push broadcast para todos os usuários sem exigir verificação server-side de privilégio de superadmin.</td>
    </tr>

    <!-- IDOR -->
    <tr>
      <td><span class="chip chip-critica">Crítica</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:268-301</td>
      <td>3. IDOR</td>
      <td><strong>Account Takeover irrestrito de qualquer usuário:</strong> <code>AtualizarDadosCall</code> (<code>PUT /api/v1/user</code>) altera senha, e-mail e papel de qualquer usuário passando o <code>id</code> no corpo da requisição.</td>
    </tr>
    <tr>
      <td><span class="chip chip-alta">Alta</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:143-158</td>
      <td>3. IDOR</td>
      <td><strong>Exclusão concorrente de cupons:</strong> <code>ExcluirDescontoCall</code> (<code>DELETE /api/v1/discount/{idDiscount}</code>) permite que qualquer parceiro delete cupons pertencentes a outros estabelecimentos.</td>
    </tr>
    <tr>
      <td><span class="chip chip-alta">Alta</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:313-328<br>api_calls.dart:580-595</td>
      <td>3. IDOR</td>
      <td><strong>Exclusão arbitrária de produtos e parceiros:</strong> <code>DeletarProdutoCall</code> (<code>DELETE /product/{id}</code>) e <code>DeletarParceiroCall</code> (<code>DELETE /partner/{id}</code>) excluem registros de qualquer inquilino sem checagem de propriedade.</td>
    </tr>
    <tr>
      <td><span class="chip chip-alta">Alta</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:1256-1272<br>api_calls.dart:1360-1375</td>
      <td>3. IDOR</td>
      <td><strong>Espionagem comercial e histórico de clientes:</strong> <code>ObterDashboardParceiroCall</code> (<code>GET /dashboard/partner/{id}</code>) e <code>HistoricoUsuarioCall</code> (<code>GET /history/user/{id}</code>) expõem faturamento e compras por ID arbitrário.</td>
    </tr>

    <!-- CHAVES EXPOSTAS -->
    <tr>
      <td><span class="chip chip-media">Média</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:20, 80...<br>lib/app_constants.dart:8</td>
      <td>4. Chaves / Hardcode</td>
      <td><strong>Hardcode de URL de produção e porta exposta:</strong> <code>https://codeflowbr.online:8080/api/v1/</code> repetida em dezenas de classes. Exposição direta da porta 8080 sem gateway WAF/Cloudflare.</td>
    </tr>
    <tr>
      <td><span class="chip chip-media">Média</span></td>
      <td class="file-loc">lib/auth/custom_auth/custom_auth_manager.dart:119-132</td>
      <td>4. Chaves / Hardcode</td>
      <td><strong>Persistência de credenciais em LocalStorage:</strong> <code>SharedPreferences</code> no Flutter Web armazena tokens e dados de sessão em texto claro no <code>window.localStorage</code>, sem flag <code>HttpOnly</code>.</td>
    </tr>
    <tr>
      <td><span class="chip chip-alta">Alta</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:1203-1215</td>
      <td>4. Chaves / Hardcode</td>
      <td><strong>Senhas armazenadas em texto claro (ausência de hash):</strong> <code>EsqueceuASenhaCall</code> (<code>POST /api/v1/forgot-password</code>) envia a senha em claro por e-mail, comprovando que senhas não utilizam hash criptográfico (bcrypt/Argon2).</td>
    </tr>

    <!-- INPUTS / XSS -->
    <tr>
      <td><span class="chip chip-alta">Alta</span></td>
      <td class="file-loc">lib/backend/api_requests/api_calls.dart:676-693, 907-954, 1098-1147</td>
      <td>5. Injeção / XSS</td>
      <td><strong>Injeção de JSON por interpolação de strings:</strong> Mais de 15 chamadas montam JSON via interpolação direta <code>'''{ "rules": "${rules}" }'''</code> sem escape, permitindo quebra sintática e injeção de parâmetros adicionais.</td>
    </tr>
    <tr>
      <td><span class="chip chip-media">Média</span></td>
      <td class="file-loc">lib/custom_code/actions/upload_photo.dart:14-45</td>
      <td>5. Injeção / XSS</td>
      <td><strong>Upload anônimo e irrestrito de arquivos:</strong> <code>POST /api/v1/photo</code> sem autenticação e sem lista estrita de extensões permitidas no cliente (.html, .svg com XSS, scripts).</td>
    </tr>
    <tr>
      <td><span class="chip chip-baixa">Baixa</span></td>
      <td class="file-loc">lib/flutter_flow/flutter_flow_util.dart:198-206<br>contrato_parceiro_widget.dart:133</td>
      <td>5. Injeção / XSS</td>
      <td><strong>Injeção de esquema de URL em launchURL:</strong> <code>launchUrl(Uri.parse(url))</code> não valida esquemas seguros (<code>http/https</code>), permitindo ativação de pseudoprotocolos (ex: <code>javascript:</code>) no Flutter Web.</td>
    </tr>
  </tbody>
</table>

<div class="page-break"></div>

<!-- RECOMENDAÇÕES PRIORIZADAS -->
<h2>4. Recomendações Priorizadas (Plano de Remediação)</h2>

<div class="avoid-break" style="margin-bottom: 10px;">
  <h3 style="color: #B91C1C;">Prioridade P1 (Imediata — Próximas 24 a 48 horas)</h3>
  <div style="background: #FEF2F2; border-left: 4px solid #B91C1C; padding: 10px 12px; border-radius: 0 6px 6px 0; font-size: 8.2pt;">
    <strong>1. Fechamento Imediato de Endpoints Abertos:</strong>
    Exigir autenticação obrigatória via Bearer JWT em <strong>todas</strong> as rotas da API (<code>/customer</code>, <code>/dashboard</code>, <code>/discount</code>, <code>/user</code>, <code>/partner</code>, <code>/photo</code>). Bloquear imediatamente requisições anônimas.
    <br><strong>2. Bloqueio de Parâmetros Privilegiados:</strong>
    Remover os campos <code>role</code> e <code>tenant.id</code> das requisições de criação e edição enviadas pelo cliente. O backend deve associar o usuário ao tenant e atribuir a role com base exclusiva na identidade autenticada no token JWT.
    <br><strong>3. Correção de IDOR em AtualizarDadosCall:</strong>
    Garantir que a rota <code>PUT /api/v1/user</code> altere exclusivamente os dados do usuário autenticado no token (extraindo o ID do contexto da sessão no servidor, e não do body).
  </div>
</div>

<div class="avoid-break" style="margin-bottom: 10px;">
  <h3 style="color: #EA580C;">Prioridade P2 (Curto Prazo — Próximos 7 dias)</h3>
  <div style="background: #FFF7ED; border-left: 4px solid #EA580C; padding: 10px 12px; border-radius: 0 6px 6px 0; font-size: 8.2pt;">
    <strong>4. Implementação de Middleware de Tenant e Checagem de Posse:</strong>
    Criar validação server-side em todas as queries e rotas de exclusão/edição: <code>WHERE tenant_id = :authenticated_tenant_id AND partner_id = :authenticated_partner_id</code>.
    <br><strong>5. Substituição de Interpolação JSON por jsonEncode():</strong>
    Refatorar as chamadas em <code>api_calls.dart</code> para utilizar <code>Map&lt;String, dynamic&gt;</code> serializados via <code>json.encode(bodyMap)</code>, eliminando 100% dos riscos de JSON Injection e quebra de payload.
    <br><strong>6. Proteção de Rotas Administrativas no Frontend:</strong>
    Atualizar o <code>nav.dart</code> para definir <code>requireAuth: true</code> em rotas privadas e implementar redirect guards baseados em token válido.
  </div>
</div>

<div class="avoid-break" style="margin-bottom: 10px;">
  <h3 style="color: #2563EB;">Prioridade P3 (Médio Prazo — Próximas 2 semanas)</h3>
  <div style="background: #EFF6FF; border-left: 4px solid #2563EB; padding: 10px 12px; border-radius: 0 6px 6px 0; font-size: 8.2pt;">
    <strong>7. Hashing Criptográfico de Senhas (bcrypt / Argon2):</strong>
    Criptografar todas as senhas armazenadas no banco e substituir o envio da senha original em <code>/forgot-password</code> por tokens temporários de redefinição com validade curta.
    <br><strong>8. Variáveis de Ambiente e Gateway Reverso:</strong>
    Extrair a URL da API para <code>String.fromEnvironment('API_BASE_URL')</code> e posicionar o backend atrás de um Reverse Proxy / WAF (Cloudflare/Nginx) com HTTPS na porta padrão 443.
    <br><strong>9. Validação Estrita de Uploads e Esquemas URI:</strong>
    Implementar validação de MIME type e magic bytes no upload de arquivos e validar esquemas <code>https/http</code> em <code>launchURL</code>.
  </div>
</div>

<div class="page-break"></div>

<!-- SEÇÃO DE ISSUES PARA GITHUB -->
<h2>5. Issues para o GitHub (Markdown Pronto para Cópia)</h2>
<p style="font-size: 8.2pt; color: #64748B; margin-bottom: 12px;">
As issues abaixo foram formatadas em Markdown completo, prontas para inclusão no repositório.
</p>

<!-- ISSUE 1 -->
<div class="issue-container avoid-break">
  <div class="issue-header">
    <span class="issue-title">Issue #1: [Segurança] Vazamento de dados pessoais e ausência de filtro de inquilino em /customer</span>
    <span class="chip chip-critica">CRÍTICA</span>
  </div>
  <div class="issue-md-content">--- ISSUE 1 ---
**Título:** [Segurança] Vazamento de dados pessoais de clientes e ausência de filtro de inquilino em /customer
**Labels:** `security`, `severity:critical`, `lgpd`, `tenant-isolation`

### Descrição do Problema
O endpoint de listagem de clientes responde a requisições sem exigir autenticação ou validação de inquilino, retornando registros de múltiplos clientes cadastrados na base com dados extremamente sensíveis (CPF, nome, cartão, saldos e endereço).

### Evidência de Código
- **Arquivo:** `lib/backend/api_requests/api_calls.dart` (Linhas 180-197)
```dart
class ObterUsuariosCall {
  static Future<ApiCallResponse> call() async {
    final token = currentAuthenticationToken;
    return ApiManager.instance.makeApiCall(
      callName: 'obterUsuarios',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/customer',
      callType: ApiCallType.GET,
      headers: {
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      },
      params: {},
```

### Prova de Conceito (Explorabilidade)
Uma simples requisição HTTP não autenticada realizada contra o servidor retorna o payload com clientes de múltiplos inquilinos:
```bash
curl -i "https://codeflowbr.online:8080/api/v1/customer"
```
**Campos expostos:** `cpf`, `cardNumber`, `name`, `login` (e-mail), `adress` (rua, número, bairro, cidade, CEP), `wallet` (saldo de pontos), `tenant` (ID do inquilino).

### Impacto
Violação gravíssima da Lei Geral de Proteção de Dados (LGPD) e vazamento de base de clientes de todos os inquilinos da plataforma para qualquer usuário externo não autenticado.

### Sugestão de Correção
1. Adicionar middleware de autenticação obrigatória JWT na rota `/api/v1/customer`.
2. No backend, obter o `tenant_id` exclusivamente das claims do JWT validado.
3. Filtrar as consultas com `WHERE tenant_id = :tenant_id`. Se o solicitante for parceiro, restringir a clientes vinculados ou proibir a listagem global.

### Critérios de Aceite
- [ ] Requisições não autenticadas em `GET /api/v1/customer` retornam status `401 Unauthorized`.
- [ ] Usuários autenticados só conseguem visualizar clientes pertencentes ao seu próprio inquilino (`tenant_id`).
- [ ] O cabeçalho `Authorization: Bearer <token>` é anexado de forma consistente em `ObterUsuariosCall`.
--- FIM ISSUE 1 ---</div>
</div>

<!-- ISSUE 2 -->
<div class="issue-container avoid-break">
  <div class="issue-header">
    <span class="issue-title">Issue #2: [Segurança] IDOR e Elevação de Privilégio Arbitrária via PUT /api/v1/user</span>
    <span class="chip chip-critica">CRÍTICA</span>
  </div>
  <div class="issue-md-content">--- ISSUE 2 ---
**Título:** [Segurança] IDOR e Account Takeover com elevação de papel em PUT /api/v1/user
**Labels:** `security`, `severity:critical`, `idor`, `broken-access-control`

### Descrição do Problema
O método `AtualizarDadosCall` permite o envio de um corpo JSON contendo o `id` do usuário a ser alterado, bem como sua nova senha (`password`) e papel administrativo (`role`). O backend atualiza o usuário sem verificar se o solicitante possui permissão para editar aquele ID específico ou se possui papel de administrador para alterar a role.

### Evidência de Código
- **Arquivo:** `lib/backend/api_requests/api_calls.dart` (Linhas 268-300)
```dart
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
```

### Impacto
- **Account Takeover Total:** Um atacante pode alterar a senha de qualquer usuário ou administrador conhecendo apenas seu ID numérico sequencial.
- **Elevação de Privilégios Imediata:** Ao submeter `"role": 2`, qualquer conta é promovida a Administrador global.

### Sugestão de Correção
1. Desabilitar a passagem de `id` e `role` pelo corpo da requisição em rotas de autoatendimento.
2. Identificar o usuário pelo token de sessão JWT (`sub` claim) no backend.
3. Proibir que o próprio usuário edite o campo `role` da conta. Alterações de papel devem exigir endpoint específico e privilégio de superadmin.

### Critérios de Aceite
- [ ] O usuário não pode alterar dados de contas de terceiros passando IDs arbitrários no body.
- [ ] O atributo `role` não é alterável via endpoint de atualização de perfil.
- [ ] Qualquer tentativa de alteração sem token válido resulta em `401 Unauthorized`.
--- FIM ISSUE 2 ---</div>
</div>

<div class="page-break"></div>

<!-- ISSUE 3 -->
<div class="issue-container avoid-break">
  <div class="issue-header">
    <span class="issue-title">Issue #3: [Segurança] IDOR na Exclusão e Consulta de Recursos (Cupons, Produtos, Dashboards)</span>
    <span class="chip chip-alta">ALTA</span>
  </div>
  <div class="issue-md-content">--- ISSUE 3 ---
**Título:** [Segurança] IDOR na exclusão e visualização de cupons, produtos e dashboards
**Labels:** `security`, `severity:high`, `idor`, `authorization`

### Descrição do Problema
Várias operações críticas recebem identificadores numéricos diretamente na URL e realizam mutações ou exibição de dados sem validar se o recurso pertence ao usuário ou parceiro autenticado.

### Evidência de Código
- **Arquivo:** `lib/backend/api_requests/api_calls.dart`
  - Linha 143: `ExcluirDescontoCall`: `DELETE /api/v1/discount/${idDiscount}`
  - Linha 313: `DeletarProdutoCall`: `DELETE /api/v1/product/${idProduto}`
  - Linha 580: `DeletarParceiroCall`: `DELETE /api/v1/partner/${idPartner}`
  - Linha 1256: `ObterDashboardParceiroCall`: `GET /api/v1/dashboard/partner/${partnerId}`
  - Linha 1360: `HistoricoUsuarioCall`: `GET /api/v1/history/user/${idCustomer}`

```dart
class ExcluirDescontoCall {
  static Future<ApiCallResponse> call({String? idDiscount = ''}) async {
    return ApiManager.instance.makeApiCall(
      callName: 'excluirDesconto',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/discount/${idDiscount}',
      callType: ApiCallType.DELETE,
      headers: {},
```

### Impacto
- Parceiros comerciais podem excluir cupons e produtos de estabelecimentos concorrentes.
- Espionagem comercial de receitas e métricas ao consultar o dashboard de outros parceiros alterando o `partnerId`.
- Acesso a histórico detalhado de compras e resgates de clientes arbitrários.

### Sugestão de Correção
No backend, validar a propriedade de cada recurso antes de efetuar exclusão ou retorno:
```sql
DELETE FROM discount WHERE id = :idDiscount AND partner_id = :authenticated_partner_id;
```
Se nenhuma linha for afetada ou se o parceiro for diferente, responder com `403 Forbidden`.

### Critérios de Aceite
- [ ] Tentar deletar um cupom de outro parceiro retorna `403 Forbidden`.
- [ ] Tentar acessar o dashboard com um `partnerId` divergente do token autenticado retorna `403 Forbidden`.
--- FIM ISSUE 3 ---</div>
</div>

<!-- ISSUE 4 -->
<div class="issue-container avoid-break">
  <div class="issue-header">
    <span class="issue-title">Issue #4: [Segurança] Injeção de JSON por Interpolação de Strings em Requisições de API</span>
    <span class="chip chip-alta">ALTA</span>
  </div>
  <div class="issue-md-content">--- ISSUE 4 ---
**Título:** [Segurança] Injeção de JSON por interpolação direta de strings em api_calls.dart
**Labels:** `security`, `severity:high`, `injection`, `api-client`

### Descrição do Problema
Diversas funções construtoras de requisições HTTP em `api_calls.dart` criam strings JSON usando interpolação direta (`'''{ "nome": "${nome}" }'''`) em vez de serializar mapas via `jsonEncode()`. Caracteres como aspas (`"`) e quebras de linha inseridos pelo usuário em campos de texto corrompem o payload ou permitem a injeção de parâmetros adicionais.

### Evidência de Código
- **Arquivo:** `lib/backend/api_requests/api_calls.dart` (Linhas 676-693, 907-954, 1098-1147, etc.)
```dart
final ffApiRequestBody = '''
{
  "description": "${descricao}",
  "discount": "${porcentagem}",
  "isActive": true,
  "rules": "${rules}"
}''';
```
*(Apenas em `EditarCustomerCall` na linha 1547 houve adição pontual de `escapeStringForJson`).*

### Impacto
- Falha e quebra da aplicação quando usuários inserem caracteres especiais ou descrições multilinha.
- Injeção de atributos não autorizados no JSON (ex.: injetar `", "role": 2, "dummy": "` em campos de texto).

### Sugestão de Correção
Refatorar todas as chamadas para utilizar mapas do Dart serializados com `json.encode`:
```dart
final Map<String, dynamic> payload = {
  'description': descricao,
  'discount': porcentagem,
  'isActive': true,
  'rules': rules,
};
final body = json.encode(payload);
```

### Critérios de Aceite
- [ ] Nenhuma chamada em `api_calls.dart` utiliza interpolação de strings em bloco (`'''{ ... }'''`) para montar JSON.
- [ ] Textos com aspas e caracteres de controle são enviados e persistidos corretamente sem erro 400 ou injeção.
--- FIM ISSUE 4 ---</div>
</div>

<!-- ISSUE 5 -->
<div class="issue-container avoid-break">
  <div class="issue-header">
    <span class="issue-title">Issue #5: [Segurança] Armazenamento de Senhas em Texto Claro e Recuperação Insegura</span>
    <span class="chip chip-alta">ALTA</span>
  </div>
  <div class="issue-md-content">--- ISSUE 5 ---
**Título:** [Segurança] Ausência de hash criptográfico de senhas e recuperação insegura em /forgot-password
**Labels:** `security`, `severity:high`, `cryptography`, `authentication`

### Descrição do Problema
O fluxo de recuperação de senhas acionado por `EsqueceuASenhaCall` (`POST /api/v1/forgot-password`) envia a senha original em texto claro por e-mail, comprovando que as credenciais são armazenadas sem hash ou salting no banco de dados.

### Evidência de Código
- **Arquivo:** `lib/backend/api_requests/api_calls.dart` (Linhas 1203-1215)
```dart
class EsqueceuASenhaCall {
  static Future<ApiCallResponse> call({String? login = ''}) async {
    final ffApiRequestBody = '''{ "login": "${login}" }''';
    return ApiManager.instance.makeApiCall(
      callName: 'esqueceuASenha',
      apiUrl: 'https://codeflowbr.online:8080/api/v1/forgot-password',
      callType: ApiCallType.POST,
```

### Impacto
Em caso de vazamento do banco de dados ou interceptação de e-mails, 100% das senhas de parceiros, administradores e clientes estarão expostas imediatamente sem necessidade de quebra por força bruta.

### Sugestão de Correção
1. Aplicar hashing irreversível com BCrypt ou Argon2 em todas as senhas armazenadas.
2. Substituir a recuperação com reenvio da senha por envio de link com token temporário e de uso único (expiração em 15 minutos).

### Critérios de Aceite
- [ ] Senhas no banco de dados nunca são armazenadas em texto claro.
- [ ] O e-mail de recuperação não contém a senha do usuário, mas sim um link seguro de redefinição.
--- FIM ISSUE 5 ---</div>
</div>

<div style="margin-top: 20px; border-top: 1px solid #E2E8F0; padding-top: 10px; font-size: 7.5pt; color: #94A3B8; text-align: center;">
  Fim do Relatório de Auditoria de Segurança — Procard / Arms Web • Gerado em 10/09/2026
</div>

</body>
</html>
"""

def generate_html():
    print(f"[*] Escrevendo HTML em: {HTML_PATH}")
    with open(HTML_PATH, "w", encoding="utf-8") as f:
        f.write(HTML_TEMPLATE)
    print("[+] HTML gerado com sucesso.")

def compile_pdf():
    print(f"[*] Compilando PDF via Headless Chrome: {PDF_PATH}")
    cmd = [
        CHROME_PATH,
        "--headless",
        "--disable-gpu",
        "--no-pdf-header-footer",
        f"--print-to-pdf={PDF_PATH}",
        HTML_PATH
    ]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if os.path.exists(PDF_PATH):
        size_kb = os.path.getsize(PDF_PATH) / 1024
        print(f"[+] PDF gerado com sucesso! Tamanho: {size_kb:.1f} KB")
    else:
        print(f"[-] Erro ao gerar PDF: {res.stderr}")
        sys.exit(1)

def verify_pdf():
    print("[*] Verificando integridade e metadados do PDF gerado...")
    try:
        res = subprocess.run(["mdls", "-name", "kMDItemNumberOfPages", PDF_PATH], capture_output=True, text=True)
        print(f"[+] Informações de Páginas (macOS mdls):\n    {res.stdout.strip()}")
    except Exception as e:
        print(f"[-] Aviso ao verificar páginas: {e}")

if __name__ == "__main__":
    generate_html()
    compile_pdf()
    verify_pdf()
