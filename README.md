📊 Comparativo de Vendas – Sankhya Gadget

Dashboard desenvolvido para análise comparativa de vendas mensais dentro do ERP Sankhya, permitindo visualizar rapidamente a performance dos últimos meses e o crescimento por produto.

🚀 Objetivo

Criar um gadget visual e analítico para:

  Comparar vendas dos últimos 3 meses

  Identificar crescimento ou queda

  Destacar produtos que impactaram o resultado

  Melhorar a tomada de decisão comercial

  Preview:
  <img width="1915" height="971" alt="image" src="https://github.com/user-attachments/assets/a428846d-52b1-4408-ac44-850fb39c42e7" />
  <img width="1226" height="312" alt="image" src="https://github.com/user-attachments/assets/ad64618a-e351-4050-a408-b9617ab20e36" />
  <img width="1853" height="468" alt="image" src="https://github.com/user-attachments/assets/dfb2005b-3cd8-46d2-91e2-28b72fe1b176" />



🧠 Funcionalidades
📅 Comparativo mensal

Exibe total vendido dos últimos 3 meses

Card de crescimento automático vs mês anterior

Cores dinâmicas:

🟢 positivo

🔴 negativo

📦 Comparativo por produto

Tabela com:

Quantidade vendida por mês

% crescimento por item

Destaque visual:

Verde → crescimento

Vermelho → queda

Neutro → estabilidade

📊 Insights rápidos

Permite identificar rapidamente:

Produto que mais cresceu

Produto que mais impactou a queda

Tendência geral de vendas

🛠️ Tecnologias utilizadas

HTML5

CSS3

JavaScript

SQL (Sankhya)

Gadget Builder Sankhya

🗄️ Integração com banco

Consulta SQL integrada ao banco Sankhya para buscar:

Notas de venda

Itens vendidos

Quantidade por produto

Período por mês

A query calcula automaticamente:

Totais mensais

Crescimento percentual

Comparativo por item

🎯 Regras de negócio

Considera apenas notas confirmadas

Filtra por TOP de venda

📈 Fórmula de crescimento
((MES_ATUAL - MES_ANTERIOR) / MES_ANTERIOR) * 100

Tratamento para divisão por zero incluído.

Ignora devoluções (ou trata separadamente)

Crescimento calculado sempre em relação ao mês anterior

🏢 Ambiente

Desenvolvido para uso interno em empresa que utiliza:

ERP Sankhya

Pode ser adaptado para:

Power BI

Dashboards web

Sistemas internos

📌 Melhorias futuras

 Filtro por vendedor

 Filtro por empresa

 Gráfico de tendência

 Ranking de produtos

 Insight automático

 Exportação Excel

 Comparativo anual

👨‍💻 Autor

Desenvolvido por Jesiel Kalebe
Analista de Sistemas em formação
Focado em:

SQL

Dashboards

ERP Sankhya

Desenvolvimento de sistemas

💡 Sobre o projeto

Este projeto faz parte da evolução prática em desenvolvimento e análise de dados dentro do ambiente corporativo, com foco em criação de dashboards úteis para gestão comercial.

⭐ Versão

v1.0 – Comparativo mensal funcional

🤝 Contribuição

Sugestões e melhorias são bem-vindas.

🔥 Observação

Projeto real usado em ambiente empresarial para análise de vendas.
