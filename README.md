# **auto_regi**

O auto_regi é um programa que automatiza alguns processos usados na Vigilância Epidemiológica da Regional de Saúde (mas também pode ser usado em SMS e na SES). Os processos são referentes aos indicadores 06, 13 e 14 da última atualização do caderno de indicadores do PQAVS
[PQA-VS 2023](https://www.gov.br/saude/pt-br/acesso-a-informacao/acoes-e-programas/pqa-vs/publicacoes-tecnicas/caderno-de-indicadores-programa-de-qualificacao-das-acoes-de-vigilancia-em-saude-2023) e outros processos de rotina da Vigilância.

Relatórios gerados pelo auto_regi:

Relatório 1: Identifica nos agravos de acidente de trabalho, acidente de trabalho com exposição a material biológico e de intoxicação exógena (desde que relacionada ao trabalho), quais são as notificações cujos campos “Ocupação” e “Atividade Econômica (CNAE)” não foram preenchidos, de forma que se adequem ao indicador 13 do PQAVS.

Relatório 2: identifica as notificações que estão com o campo data de encerramento em branco, dando oportunidade ao município de encerrar oportunamente a notificação, conforme preconiza o indicador 06 do PQAVS;

Relatório 3: Possibilita a identificação de notificações de violência interpessoal e autoprovocada (Y09), demonstrando quais as notificações com o campo raça/cor não estão preenchidas ou se estão preenchidas com informação inválida, conforme avaliado pelo indicador 14 do PQAVS;

Relatório 4: Procura nos arquivos de exportação de Dengue, inconsistências nos campos "evolução" e "data de encerramento". Tais inconsistências podem comprometer o indicador desse agravo em municípios que pactuaram com o projeto de cofinanciamento das ações de vigilância em saúde (2023);

Sintaxe do executável:

~~~
auto_regi.exe --help --ver --date [data inicial] [data final] --nokeypress [t]
~~~
