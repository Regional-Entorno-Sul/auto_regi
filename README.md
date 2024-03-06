# **auto_regi**

O auto_regi é um programa que automatiza alguns processos usados na Vigilância Epidemiológica da Regional de Saúde (mas também pode ser usado em SMS e na SES). Os processos são referentes aos indicadores 06, 13 e 14 da última atualização do caderno de indicadores do PQAVS
[PQA-VS 2023](https://www.gov.br/saude/pt-br/acesso-a-informacao/acoes-e-programas/pqa-vs/publicacoes-tecnicas/caderno-de-indicadores-programa-de-qualificacao-das-acoes-de-vigilancia-em-saude-2023), [projeto de cofinanciamento](https://github.com/Regional-Entorno-Sul/auto_regi/blob/main/Propostas%20de%20Cofinanciamento%20SUVISA%20final%20-%2004-12-2023.pdf) e outros processos de rotina da Vigilância.

Relatórios gerados pelo auto_regi:

Relatório 1: Identifica nos agravos de acidente de trabalho, acidente de trabalho com exposição a material biológico e de intoxicação exógena (desde que relacionada ao trabalho), quais são as notificações cujos campos “Ocupação” e “Atividade Econômica (CNAE)” não foram preenchidos, de forma que se adequem ao indicador 13 do PQAVS;

Relatório 2: identifica as notificações que estão com o campo data de encerramento em branco, dando oportunidade ao município de encerrar oportunamente a notificação, conforme preconiza o indicador 06 do PQAVS;

Relatório 3: Possibilita a identificação de notificações de violência interpessoal e autoprovocada (Y09), demonstrando quais as notificações com o campo raça/cor não estão preenchidas ou se estão preenchidas com informação inválida, conforme avaliado pelo indicador 14 do PQAVS;

Relatório 4: Procura nos arquivos de exportação de Dengue, inconsistências nos campos "evolução" e "data de encerramento". Tais inconsistências podem comprometer o indicador desse agravo em municípios que pactuaram com o projeto de cofinanciamento das ações de vigilância em saúde (2023);

Relatório 5: Busca na base de dados de tuberculose, os campos inconsistentes a serem avaliados, conforme o que foi estipulado no projeto de cofinanciamento das ações de vigilância em saúde (2023) para esse agravo;

Relatório 6: Faz o cruzamento do arquivo padrão de exportação de Dengue com o arquivo de exportação de dados de D.O., com o objetivo de identificar casos de óbitos que não foram notificados no SINAN Online, sistema onde são registradas as notificações de Dengue;

Relatório 7: Identifica data de encerramento em branco nas notificações de atendimento antirrábico humano;

Relatório 8: Cruza os dados do arquivo padrão de exportação de dados de D.O. com o arquivo de dados de Tuberculose do SINAN NET, procurando identificar casos de óbitos por Tuberculose nos registros do SIM que não estão registrados no SINAN NET;

Relatório 9: Procura por inconsistências na base de dados de Hanseniase, identificando os campos com registros em desacordo com os indicadores preconizados pelo projeto de cofinanciamento das ações de vigilância em saúde.

Relatório 10: Identifica, usando o arquivo de exportação do SIVEP Gripe, notificações de SRAG com os campos "classificação final", "evolução", "resultado RT-PCR" em desacordo com o que está preconizado pelo projeto de cofinanciamento das ações de vigilância em saúde (2023).

Relatório 11: Possibilita por meio do arquivo de exportação gerado no e-SUS VE Notifica, identificar registros inconsistentes nessa base de dados;

Relatório 12: Identifica inconsistências no agravo "Sifílis em Gestantes", possibilitando a correção de certos campos que influem nos indicadores usados para pontuação no projeto de cofinanciamento das ações de vigilância em saúde (2023).

Relatório 13: Busca na base de dados de surto do SINAN NET, os campos que estão em desacordo com os critérios estabelecidos para pontuação, segundo o projeto de cofinanciamento das ações de vigilância em saúde (2023).

Sintaxe do executável:

~~~
auto_regi.exe --help --ver --date [data inicial] [data final] --nokeypress [t] --list --clean
~~~
