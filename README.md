# Desafio de Projeto — Integração e Transformação de Dados com T-SQL e Power BI

## 📌 Objetivo

Este projeto tem como objetivo realizar a modelagem e transformação de um banco de dados relacional utilizando **T-SQL (SQL Server)**, com integração ao **Power BI** para análise de dados. A proposta original usava MySQL na Azure, mas foi adaptada para uso local com T-SQL, mantendo os requisitos de estruturação e visualização.

---

## 📁 Estrutura dos Arquivos

- `01_create_schema.sql`: script para criação do banco de dados e todas as tabelas.
- `02_insert_data_and_queries.sql`: script de inserção dos dados nas tabelas e algumas consultas.
- `Criando um Dashboard corporativo.pbix`: dashboard final desenvolvido no Power BI.

---

## 🧱 Etapas Técnicas

### 🔹 1. Criação do Banco de Dados

Utilizamos o script `01_create_schema.sql` para estruturar o banco `company`, com as tabelas:
- `employee`
- `departament`
- `dept_locations`
- `project`
- `works_on`
- `dependent`

### 🔹 2. Inserção de Dados

O script `02_insert_data_and_queries.sql` insere dados fictícios para simular um ambiente corporativo com funcionários, departamentos, dependentes e projetos.

---

## 🔍 Transformações Realizadas (com base no Power BI e SQL)

### ✅ Verificações Iniciais

- **Verificação de tipos de dados** e **valores monetários** ajustados para `DECIMAL`.
- **Análise de valores nulos**, especialmente na coluna `Super_ssn` (gerentes).
- Preenchimento simulado de departamentos sem gerente.

### 🔄 Transformações com SQL

#### Junção de funcionários e departamentos:
```sql
SELECT 
  e.ssn,
  CONCAT(e.fname, ' ', e.lname) AS nome_colaborador,
  d.dname AS nome_departamento
FROM 
  employee e
JOIN 
  departament d ON e.dno = d.dnumber;
```

#### Junção para trazer nome dos gerentes:
```sql
SELECT 
  e.ssn,
  CONCAT(e.fname, ' ', e.lname) AS nome_colaborador,
  CONCAT(m.fname, ' ', m.lname) AS nome_gerente
FROM 
  employee e
LEFT JOIN 
  employee m ON e.super_ssn = m.ssn;
```

#### Criação de chave composta para `departamento - localização`:
```sql
SELECT 
  d.dname + ' - ' + l.dlocation AS depto_localizacao
FROM 
  departament d
JOIN 
  dept_locations l ON d.dnumber = l.dnumber;
```

> ⚠️ **Justificativa do uso de "Mesclar" e não "Atribuir"**: a concatenação é meramente descritiva para facilitar a leitura e modelagem. Não há nova derivação lógica dos dados, apenas criação de uma nova coluna identificadora.

---

### 📊 Power BI

No Power BI:

- Importação direta via T-SQL (`Import`).
- Remoção de colunas desnecessárias.
- Criação de colunas calculadas (como `nome completo`).
- Agrupamento por gerente:
  ```sql
  SELECT 
    super_ssn,
    COUNT(*) AS num_colaboradores
  FROM 
    employee
  WHERE 
    super_ssn IS NOT NULL
  GROUP BY 
    super_ssn;
  ```

- Modelo criado visando o futuro modelo estrela:
  - Tabela Fato: `works_on`
  - Dimensões: `employee`, `project`, `departament`, `dept_locations`

---

## 🛠️ Tecnologias Utilizadas

- SQL Server (T-SQL)
- Power BI Desktop
- SSMS 

---

## 📌 Considerações Finais

- A lógica do projeto foi mantida mesmo com a migração de MySQL para T-SQL.
- O modelo final cumpre os objetivos de organização, integridade relacional e suporte à análise visual em Power BI.
