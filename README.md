# **auto_regi**

O "auto_regi" é um programa que automatiza alguns processos usados na Vigilância Epidemiológica da Regional de Saúde (mas também pode ser usado em SMS e na SES). Os processos são referentes aos indicadores 06, 13 e 14 da última atualização do caderno de indicadores do PQAVS
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
1. Fazer o download da versão mais atualizada na área de releases. Atualmente é a versão 2.3;

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

- Os arquivos resultantes do processamento do relatório 1 estarão na subpasta "C:\auto_regi\rel\rel1".

![x](/pictures/rel1_output.jpg)  

**Relatório 2**  
- Copiar o arquivo de exportação DBF de notificações individuais (nindinet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";
- Gerar o arquivo de exportação de Dengue no SINAN Online e colar na subpasta "C:\auto_regi\tmp\dnci\deng";
- Gerar o arquivo de exportação de Febre de Chikungunya e colar na subpasta "C:\auto_regi\tmp\dnci\chik".  

![x](/pictures/relat2_deng.jpg)  

- Os arquivos resultantes do processamento do relatório 2 estarão na subpasta "C:\auto_regi\rel\rel2".

![x](/pictures/rel2_output.jpg)  

**Relatório 3**  

- Copiar o arquivo de exportação DBF de "violência doméstica, sexual e/ou outras violencias" (violenet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";  
- Os arquivos resultantes do processamento do relatório 3 estarão na subpasta "C:\auto_regi\rel\rel3".

**Relatório 4**  

- Gerar o arquivo de exportação de Dengue no SINAN Online e colar na subpasta "C:\auto_regi\tmp\cofi\deng";
- Os arquivos resultantes do processamento do relatório 4 estarão na subpasta "C:\auto_regi\rel\rel4".

**Relatório 5**  

- Copiar o arquivo de exportação DBF de Tuberculose (tubenet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";  
- Os arquivos resultantes do processamento do relatório 5 estarão na subpasta "C:\auto_regi\rel\rel5".

**Relatório 6**  

- Gerar o arquivo de exportação de Dengue no SINAN Online e colar na subpasta "C:\auto_regi\tmp\do_deng\deng";
- Gerar o arquivo de exportação de óbitos no SIM e colar na subpasta "C:\auto_regi\tmp\do_deng\do\";
- Os arquivos resultantes do processamento do relatório 6 estarão na subpasta "C:\auto_regi\rel\rel6".

**Relatório 7**  

- Copiar o arquivo de exportação DBF de "atendimento anti-rábico" (antranet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";  
- Os arquivos resultantes do processamento do relatório 7 estarão na subpasta "C:\auto_regi\rel\rel7".

**Relatório 8**  

- Copiar o arquivo de exportação DBF de Tuberculose (tubenet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";  
- Gerar o arquivo de exportação de óbitos no SIM e colar na subpasta "C:\auto_regi\tmp\tube_do\";
- Os arquivos resultantes do processamento do relatório 8 estarão na subpasta "C:\auto_regi\rel\rel8".

![x](/pictures/tube_do.jpg)  
  
**Relatório 9**  

- Copiar o arquivo de exportação DBF de Hanseníase (hansnet.dbf) gerado no SINAN NET e colar na subpasta "dbf" dentro do diretório do "auto_regi";  
- Os arquivos resultantes do processamento do relatório 9 estarão na subpasta "C:\auto_regi\rel\rel9".
  
**Relatório 10**  

- Gerar no SIVEP Gripe o arquivo de exportação de SRAG hospitalizado. Colar na subpasta "c:\auto_regi\tmp\cofi\srag";  
- Os arquivos resultantes do processamento do relatório 10 estarão na subpasta "C:\auto_regi\rel\rel10".
  
**Relatório 11**  

- Gerar no e-SUS VE Notifica, um arquivo de exportação de casos de Coronavirus. Colar o arquivo gerado na subpasta "c:\auto_regi\tmp\esus";
- Os arquivos resultantes do processamento do relatório 11 estarão na subpasta "C:\auto_regi\rel\rel11".

**Relatório 12**  

- Gerar no SINAN NET, o arquivo de exportação de "Sifilis em gestante" (sifgenet.dbf), copiar o arquivo e colar na subpasta "dbf" dentro do diretório do "auto_regi";
- Os arquivos resultantes do processamento do relatório 12 estarão na subpasta "C:\auto_regi\rel\rel12".

**Relatório 13**  

- Gerar no SINAN NET, o arquivo de exportação de "notificações de surto" (nsurtnet.dbf), copiar o arquivo e colar na subpasta "dbf" dentro do diretório do "auto_regi";
- Os arquivos resultantes do processamento do relatório 13 estarão na subpasta "C:\auto_regi\rel\rel13".

Quando os arquivos para a geração dos relatórios estiverem nas subpastas correspondentes conforme orientado acima, o usuário poderá rodar o "auto_regi" para o processamento dos dados. 

Não sabe como executar um arquivo executável usando o prompt do Windows? Abaixo há alguns sites que ensinam como fazê-lo:  
https://pt.wikihow.com/Executar-Arquivos-Exe-no-Cmd-no-Windows-ou-Mac  
https://giovanidacruz.com.br/como-abrir-um-executavel-pelo-prompt-de-comando/  

Abaixo temos um exemplo do uso do "auto_regi" usando o parâmetro --date.  

![x](/pictures/auto_regi_cmd1.jpg)  

No início do programa será mostrado os arquivos detectados para a geração dos relatórios. Observe que somente será ou serão gerados os relatórios cujos arquivos de exportação estiverem disponíveis nas subpastas correspondentes e que devem ser providenciados pelo usuário anteriormente à execução do programa.  
  
![x](/pictures/auto_regi_cmd2.jpg)  

Abaixo temos um exemplo de processamento dos dados de acidente de trabalho grave usado na geração do "relatório 1".

![x](/pictures/auto_regi_cmd3.jpg)  

No final do programa é apresentado quais relatórios foram gerados tendo como base os arquivos que o usuário disponibilizou nas subpastas para serem processados pelo "auto_regi".

![x](/pictures/auto_regi_cmd4.jpg)  

Usando a opção --list, o processamento ficará restrito somente aos municipios que tiverem o seu código inserido dentro do arquivo "list_muns.txt", o qual deverá ser preenchido pelo usuário. Esse arquivo se encontra na subpasta "set" situada no diretório principal do "auto_regi".

![x](/pictures/auto_regi_listmuns.jpg)  

No arquivo "list_muns.txt" que pode ser editado no bloco de notas do Windows, o usuário deverá inserir o código IBGE com 06 dígitos do município de interesse, delimitado por aspas duplas, conforme mostra a figura seguinte.  
  
  
![x](/pictures/auto_regi_listmuns2.jpg)  

Depois de feita a edição do arquivo "list_muns.txt", o usuário deve salvar o arquivo e rodar o "auto_regi" para que a alteração realizada tenha efeito.  
Lembramos também que a opção --list, só está disponível nos relatórios 2,4,6,8 e 10.  
  
## Créditos  

O "auto_regi" utiliza alguns executáveis de terceiros para que alguns processos internos sejam realizados corretamente:  

- flip.exe: converte um arquivo de texto padrão ASCII Unix para o formato MS-DOS/Windows. É usado no "auto_regi" no arquivo exportado pelo usuario com os dados do e-SUS VE Notifica (relatório 11). Disponível em: https://ccrma.stanford.edu/~craig/utility/flip/  

__run("c:\auto_regi\exe\flip.exe -d c:\auto_regi\tmp\esus\esus_ve_notifica.csv")  

- cecho.exe: possibilita texto com cores em arquivos batch, como o usado no "auto_regi" para auxiliar na compilação do executável (arquivo comp_prg.bat). Disponível em: https://github.com/lordmulder/cecho  

cecho.exe red black "Fim do script. Pressione qualquer tecla para continuar..."

- hexed.exe: é um editor hexadecimal que roda em linha de comando. É utilizado no "auto_regi" (relatório 9) para alterar o tipo de campo em um arquivo dbf específico (hansnet.dbf). Disponível em: https://sourceforge.net/projects/hexed/  

__run( "c:\auto_regi\exe\hexed -e 840 43 4f 4e 54 52 45 47 00 00 00 00 43 - c:\auto_regi\tmp\cofi\hans\hansnet.dbf" )  
__run( "c:\auto_regi\exe\hexed -e ac0 43 4f 4e 54 45 58 41 4d 00 00 00 43 - c:\auto_regi\tmp\cofi\hans\hansnet.dbf" )  
  
## Segurança  

O próprio usuário pode verificar se o executável (auto_regi.exe) é seguro para uso utilizando algum serviço online gratuito para esse fim, como o VirusTotal (https://www.virustotal.com/gui/home/upload) e o Kaspersky Threat Intelligence Portal (https://opentip.kaspersky.com)
Basta fazer o upload do arquivo executável e aguardar o resultado.

![x](/pictures/exe_file.jpg)  

Resultado do escaneamento do executável utilizando o serviço do Kaspersky Threat Intelligence Portal.

![x](/pictures/no_viruses.jpg)  

## Para desenvolvedores  

O "auto_regi" é um programa de código aberto. O código fonte (auto_regi.prg) está disponível ao usuário quando este faz o download do software na área de releases. 
  
![x](/pictures/src_prg.jpg)  

Foi desenvolvido usando a linguagem Harbour (https://harbour.github.io/) que acessa arquivos DBF (usado na maioria dos relatórios) nativamente, sem precisar de drivers, pontes ODBC ou outros recursos para o acesso e processamento desse tipo de arquivo.  
Para compilar o executável, há um arquivo de lote (comp_prg.bat) que facilita o processo. 

![x](/pictures/batch_file.jpg)  








