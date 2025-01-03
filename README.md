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

--help              Exibe um resumo dos parametros disponiveis pelo programa.                            
--ver               Exibe a versao atual do programa.                                                    
--date              Processa os dados dentro de um periodo especifico delimitado pela [data inicial]     
                    e [data final]. As datas devem estar no formato dd/mm/aaaa. Exemplo:                 
                    --date 01/01/2020 15/07/2022                                                         
--nokeypress [t]    Impede que o programa seja interrompido e o processamento seja retomado apenas se    
                    o usuario pressionar uma tecla. Ideal para processamento de dados em lote.           
                    [t] e o tempo de espera em segundos, que pode ser 0 ate 100000. Caso [t] nao         
                    seja especificado, o tempo de espera padrao e de 8 segundos.                         
--list              Delimita o processamento a um ou mais municipios que devem ter os seus codigos       
                    relacionados em uma lista dentro do arquivo 'list_muns.txt' no diretorio 'auto_regi/ 
                    set'.
                                                                               
--clean             Limpa os diretorios 'tmp' e 'rel' que contem, respectivamente, arquivos temporarios  
                    e relatorios que podem estar desatualizados. Os arquivos excluidos sao apenas aque-  
                    les com extensao dbf e ntx. Esse argumento e util para testes e sessoes de debug.    
~~~
## Como usar?
1. Fazer o download da versão mais atualizada na área de releases. Atualmente é a versão 2.2;

![x](/pictures/release.jpg)
2. Usando um descompactador da sua preferência (WinZip, WinRAR, 7Zip, etc), decompacte o arquivo que você fez o download (auto_regi.rar);  

![x](/pictures/7zip_2.jpg)

3. A pasta resultante do processo de descompactação (auto_regi) deve ser movida para o disco local C ou unidade local C do seu PC;  

![x](/pictures/folder_a.jpg)

4. O programa "auto_regi" precisa de uma série de arquivos chamados de tabelas basicas para funcionar. Também precisa do arquivo "nindinet.dbf". Esses arquivos são gerados pelo programa SINAN NET usando o módulo de exportação de arquivos DBF. Os arquivos a serem gerados no módulo são os seguintes:  
**Notificação individual;**  
**Município;**  
**Regional;**  
**Ocupação;**  
**CNAE;**  

![x](/pictures/sinan_net.jpg)

5. Uma vez gerados esses arquivos pelo SINAN NET, estes devem ser copiados da subpasta "BaseDBF" do SinanNet. Segue abaixo o nome dos arquivos no formato DBF gerados pelo módulo de exportação:  
**NINDINET.DBF;**  
**CNAENET.DBF;**  
**OCUPANET.DBF;**  
**MUNICNET.DBF;**  
**REGIONET.DBF;**  

![x](/pictures/sinan_files_1.jpg)
6. Em seguida os arquivos devem ser colados na subpasta "dbf" dentro do diretório "auto_regi";  

![x](/pictures/sinan_files2.jpg)  

Além dos arquivos mostrados acima, para o processamento dos relatórios é necessário os seguintes arquivos:  

**Relatório 1**  
Copiar os arquivos abaixo e colar na subpasta "dbf" dentro do diretório do "auto_regi".
- Arquivo de exportação DBF de acidentes de trabalho (acgranet.dbf) gerado no SINAN NET;
- Arquivo de exportação de acidente de trabalho com exposição a material biológico (acbionet.dbf) gerado no SINAN NET;
- Arquivo de exportação de intoxicaçao exógena (iexognet.dbf) gerado no SINAN NET.  

![x](/pictures/relat1.jpg)  

- Os arquivos resultantes do processamento do relatório 1 estão na subpasta "C:\auto_regi\rel\rel1".

![x](/pictures/rel1_output.jpg)  

**Relatório 2**  
- Copiar o arquivo de exportação DBF de notificações individuais (nindinet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";
- Gerar o arquivo de exportação de Dengue no SINAN Online e colar na subpasta "C:\auto_regi\tmp\dnci\deng";
- Gerar o arquivo de exportação de Febre de Chikungunya e colar na subpasta "C:\auto_regi\tmp\dnci\chik".  

![x](/pictures/relat2_deng.jpg)  

- Os arquivos resultantes do processamento do relatório 2 estão na subpasta "C:\auto_regi\rel\rel2".

![x](/pictures/rel2_output.jpg)  

**Relatório 3**  

- Copiar o arquivo de exportação DBF de "violência doméstica, sexual e/ou outras violencias" (violenet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";  
- Os arquivos resultantes do processamento do relatório 3 estão na subpasta "C:\auto_regi\rel\rel3".

**Relatório 4**  

- Gerar o arquivo de exportação de Dengue no SINAN Online e colar na subpasta "C:\auto_regi\tmp\cofi\deng";
- Os arquivos resultantes do processamento do relatório 4 estão na subpasta "C:\auto_regi\rel\rel4".

**Relatório 5**  

- Copiar o arquivo de exportação DBF de Tuberculose (tubenet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";  
- Os arquivos resultantes do processamento do relatório 5 estão na subpasta "C:\auto_regi\rel\rel5".

**Relatório 6**  

- Gerar o arquivo de exportação de Dengue no SINAN Online e colar na subpasta "C:\auto_regi\tmp\do_deng\deng";
- Gerar o arquivo de exportação de óbitos no SIM e colar na subpasta "C:\auto_regi\tmp\do_deng\do\";
- Os arquivos resultantes do processamento do relatório 6 estão na subpasta "C:\auto_regi\rel\rel6".

**Relatório 7**  

- Copiar o arquivo de exportação DBF de "atendimento anti-rábico" (antranet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";  
- Os arquivos resultantes do processamento do relatório 7 estão na subpasta "C:\auto_regi\rel\rel7".

**Relatório 8**  

- Copiar o arquivo de exportação DBF de Tuberculose (tubenet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";  
- Gerar o arquivo de exportação de óbitos no SIM e colar na subpasta "C:\auto_regi\tmp\tube_do\";
- Os arquivos resultantes do processamento do relatório 8 estão na subpasta "C:\auto_regi\rel\rel8".

![x](/pictures/tube_do.jpg)  
  
**Relatório 9**  

- Copiar o arquivo de exportação DBF de Hanseníase (hansnet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";  
  
  


