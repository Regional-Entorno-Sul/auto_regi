#include "fileio.ch"
REQUEST HB_CODEPAGE_PTISO
REQUEST HB_CODEPAGE_PT850

Function main()

*************************************************************************************************
* Auto_regi versao 2.3                                                                          *
* 15/01/2025 - https://github.com/Regional-Entorno-Sul/auto_regi                                *
* Diretoria Macrorregional Nordeste                                                             *
* Parametros:                                                                                   *
* auto_regi.exe --help --ver --date [data inicial] [data final] --nokeypress [t] --list --clean *
*************************************************************************************************

HB_SETCODEPAGE( "PT850" )
set century on
set date to british
set color to g+/
clear screen

public nLine, cFilex, cIndex1, cIndex2, cMode, cDt_Ini, cDt_Fin
public nArraySize2, aName2, cSimNao, cDataInicial, cDataFinal, nPeriodo, cFilesDBF, nNokeypress_arg, nTime, cCleanning
cSimNao := space( 1 )
cDataInicial := space ( 10 )
cDataFinal := space ( 10 )

cMode := HB_Argv( 1 )
cDt_Ini := HB_Argv( 2 )
cDt_Fin := HB_Argv( 3 )

if cMode = "--help" .or. cDt_Ini = "--help" .or. cDt_Fin = "--help"
help()
endif

if cMode = "--ver" .or. cDt_Ini = "--ver" .or. cDt_Fin = "--ver"
ver()
endif

if HB_Argv ( 1 ) = "--clean" .or. HB_Argv ( 2 ) = "--clean" .or. HB_Argv ( 3 ) = "--clean" .or. HB_Argv ( 4 ) = "--clean" .or. HB_Argv ( 5 ) = "--clean" .or. ;
HB_Argv ( 6 ) = "--clean" .or. HB_Argv ( 7 ) = "--clean" .or. HB_Argv ( 8 ) = "--clean" .or. HB_Argv ( 9 ) = "--clean"
cCleanning := "true"
screen_zero()
tmp_cleanning()
else
cCleanning := "false"
endif

for n = 1 to HB_ArgC()

if HB_Argv ( n ) = "--nokeypress"
nNokeypress_arg = n
if empty( HB_Argv( nNokeypress_arg + 1 ) ) = .F.
nSize := len( HB_Argv( nNokeypress_arg + 1 ) )

for x = 1 to nSize
cSub :=  substr( HB_Argv( nNokeypress_arg + 1 ), x, 1 )
lDigit := isdigit( cSub )
if lDigit = .F.
set color to r+
? "Valor de tempo do parametro --nokeypress e invalido -> " + alltrim( HB_Argv( nNokeypress_arg + 1 ) ) + "."
set color to g+/
? ""
quit
endif

next

nTime = HB_Argv( nNokeypress_arg + 1 )
if val( nTime ) < 0 .or. val( nTime ) > 100000
set color to r+
? "Valor do tempo do parametro --nokeypress e invalido. Valor valido 0 ate 100000."
set color to g+/
? ""
quit
endif
 
else
nTime = alltrim( str(8) )
endif
endif

next

screen_zero()
tmp_cleanning()
clear screen
screen_zero()
files()

* Codigo da variavel cFilesDBF
******************************
* A - nindinet.dbf // 1
* B - dengDBF.zip // 2
* C - chikDBF.zip // 3
* D - acbionet.dbf // 4
* E - acgranet.dbf // 5
* F - iexognet.dbf // 6
* G - violenet.dbf // 7
* H - municnet.dbf // 8
* I - regionet.dbf // 9
* J - cnaenet.dbf // 10
* K - ocupanet.dbf // 11
* L - dengDBF.zip - cofinanciamento // 12
* M - tubenet.dbf // 13
* N - dengDBF.zip - cruzamento dengue // 14
* O - do.zip // 15
* P - antranet.dbf // 16
* Q - do.zip - cruzamento tuberculose. // 17
* R - hansnet.dbf // 18
* S - srag.zip // 19
* T - *.csv // 20
* U - sifgenet.dbf // 21
* V - nsurtnet.dbf // 22

if cMode <> "--date"

@ 7,0 say "Delimita as notificacoes por periodo (data inicial e data final)? Digite S-->Sim, N--> Nao" get cSimNao picture "!A" color "white+/blue+"
read

switch ( cSimNao )
case "S"
nPeriodo := 1
do while nPeriodo = 1
screen1()
date_format()
data_error()

if cDataInicial = "99/99/9999"
exit
quit
endif

if cDataFinal = "99/99/9999"
exit
quit
endif

enddo

exit
case "N"
no_date()
exit
otherwise
invalid_data()
end

if cDataInicial = "99/99/9999"
@ 13,0 say "Fim do programa..." color "r+"
quit
endif

if cDataFinal = "99/99/9999"
@ 13,0 say "Fim do programa..." color "r+"
quit
endif

endif

if cMode = "--date"

date_on()

endif

@ 10,0 say "Indexando as tabelas basicas..."
if at( "H", cFilesDBF ) = 8
use "c:\auto_regi\dbf\municnet.dbf"
dbCreateIndex( "c:\auto_regi\dbf\mun_index.ntx","id_municip" )
close
endif

if at( "I", cFilesDBF ) = 9
use "c:\auto_regi\dbf\regionet.dbf"
dbCreateIndex( "c:\auto_regi\dbf\regi_index.ntx","id_regiona" )
close
endif

if at( "K", cFilesDBF ) = 11
use "c:\auto_regi\dbf\ocupanet.dbf"
dbCreateIndex( "c:\auto_regi\dbf\ocupa_index.ntx","id_ocupa_n" )
close
endif

if at( "J", cFilesDBF ) = 10
use "c:\auto_regi\dbf\cnaenet.dbf"
dbCreateIndex( "c:\auto_regi\dbf\cnae_index.ntx","class_cnae" )
close
endif

if at( "H", cFilesDBF ) = 8
@ 11,0 say "Criando um array de municipios..."
	  public aArray1 := {}
	  use "c:\auto_regi\dbf\municnet.dbf" index "c:\auto_regi\dbf\mun_index.ntx"
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray1, {alltrim(id_municip),alltrim(nm_municip)} )
	  skip
	  NEXT
	  close
	  aArray1 := asort( aArray1,,,{|x,y| x[1] < y[1]} )
endif	  

if at( "I", cFilesDBF ) = 9
@ 12,0 say "Criando um array de regionais..."
	  public aArray2 := {}
	  use "c:\auto_regi\dbf\regionet.dbf" index "c:\auto_regi\dbf\regi_index.ntx"
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray2, {alltrim(id_regiona),alltrim(nm_regiona)} )
	  skip
	  NEXT
	  close
	  aArray2 := asort( aArray2,,,{|x,y| x[1] < y[1]} )
endif

if at( "K", cFilesDBF ) = 11
@ 13,0 say "Criando um array de ocupacoes..."
	  public aArray2x := {}
	  use "c:\auto_regi\dbf\ocupanet.dbf" index "c:\auto_regi\dbf\ocupa_index.ntx"
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray2x, {alltrim(id_ocupa_n),alltrim(nm_ocupaca)} )
	  skip
	  NEXT
	  close
	  aArray2x := asort( aArray2x,,,{|x,y| x[1] < y[1]} )
endif

if at( "J", cFilesDBF ) = 10
@ 14,0 say "Criando um array de cnae..."
	  public aArray2y := {}
	  use "c:\auto_regi\dbf\cnaenet.dbf" index "c:\auto_regi\dbf\cnae_index.ntx"
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray2y, {alltrim(class_cnae),alltrim(ds_cnae)} )
	  skip
	  NEXT
	  close
	  aArray2y := asort( aArray2y,,,{|x,y| x[1] < y[1]} )
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "K", cFilesDBF ) = 11 .and. at( "J", cFilesDBF ) = 10 .and. at( "D", cFilesDBF ) = 4
acbionet()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "K", cFilesDBF ) = 11 .and. at( "J", cFilesDBF ) = 10 .and. at( "E", cFilesDBF ) = 5
acgranet()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "K", cFilesDBF ) = 11;
.and. at( "J", cFilesDBF ) = 10 .and. at( "F", cFilesDBF ) = 6 .and. at( "A", cFilesDBF ) = 1
iexognet()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "A", cFilesDBF ) = 1 .and. at( "B", cFilesDBF ) = 2 .and. at( "C", cFilesDBF ) = 3
dnci()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "G", cFilesDBF ) = 7 .and. at( "A", cFilesDBF ) = 1
violenet()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "L", cFilesDBF ) = 12
deng_cofi()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "M", cFilesDBF ) = 13
tubenet()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "N", cFilesDBF ) = 14 .and. at( "O", cFilesDBF ) = 15
do_deng()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "P", cFilesDBF ) = 16
atend()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "M", cFilesDBF ) = 13 .and. at( "Q", cFilesDBF ) = 17
tube_do()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "R", cFilesDBF ) = 18
hansnet()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "S", cFilesDBF ) = 19
srag()
clear screen
screen_zero()
endif

if at( "T", cFilesDBF ) = 20
esus()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "U", cFilesDBF ) = 21
sifgenet()
clear screen
screen_zero()
endif

if at( "H", cFilesDBF ) = 8 .and. at( "I", cFilesDBF ) = 9 .and. at( "V", cFilesDBF ) = 22
nsurtnet()
clear screen
screen_zero()
endif

clear screen
screen_zero()
transfer()

return nil

*********************************** funcoes **********************************

function screen_zero

set color to g+/

@ 0,0 say "*************************************************************************************************"
@ 1,0 say "* Auto_regi versao 2.3                                                                          *"
@ 2,0 say "* 15/01/2025 - https://github.com/Regional-Entorno-Sul/auto_regi                                *"
@ 3,0 say "* Diretoria Macrorregional Nordeste                                                             *"
@ 4,0 say "* Parametros:                                                                                   *"
@ 5,0 say "* auto_regi.exe --help --ver --date [data inicial] [data final] --nokeypress [t] --list --clean *"
@ 6,0 say "*************************************************************************************************"
set color to bg+/

return

function help
set color to g+/

? "auto_regi.exe --help --ver --date [data inicial] [data final] --nokeypress [t] --list --clean            "
? ""
? "--help              Exibe um resumo dos parametros disponiveis pelo programa.                            "
? "--ver               Exibe a versao atual do programa.                                                    "
? "--date              Processa os dados dentro de um periodo especifico delimitado pela [data inicial]     "
? "                    e [data final]. As datas devem estar no formato dd/mm/aaaa. Exemplo:                 "
? "                    --date 01/01/2020 15/07/2022                                                         "
? "--nokeypress [t]    Impede que o programa seja interrompido e o processamento seja retomado apenas se    "
? "                    o usuario pressionar uma tecla. Ideal para processamento de dados em lote.           "
? "                    [t] e o tempo de espera em segundos, que pode ser 0 ate 100000. Caso [t] nao         "
? "                    seja especificado, o tempo de espera padrao e de 8 segundos.                         "
? "--list              Delimita o processamento a um ou mais municipios que devem ter os seus codigos       "
? "                    relacionados em uma lista dentro do arquivo 'list_muns.txt' no diretorio 'auto_regi/ "
? "                    set'.                                                                                "
? "--clean             Limpa os diretorios 'tmp' e 'rel' que contem, respectivamente, arquivos temporarios  "
? "                    e relatorios que podem estar desatualizados. Os arquivos excluidos sao apenas aque-  "
? "                    les com extensao dbf e ntx. Esse argumento e util para testes e sessoes de debug.    "
? ""
quit

return

function ver

set color to g+/
? "auto_regi.exe "
? "Versao 2.3 - 15/01/2025"
? ""
quit

return

function screen1

screen_zero()

@ 8,0 say "Data inicial:" get cDataInicial picture "99/99/9999" color "white+/blue+"
@ 9,0 say "Data final:" get cDataFinal picture "99/99/9999" color "white+/blue+"
read

return

function data_error

screen_zero()

nInternalError := 0

if cDataInicial = "99/99/9999"
nInternalError = 1
endif

if cDataFinal = "99/99/9999"
nInternalError = 1
endif

cDiasIni := left( cDataInicial, 2 )
cDiasFin := left( cDataFinal, 2 )
cMesIni := alltrim( substr( cDataInicial, 4, 2 ) )
cMesFin := alltrim( substr( cDataFinal, 4, 2 ) )
cYearIni := year( ctod( cDataInicial ) )
cYearFin := year( ctod( cDataFinal ) )
cYearIni2 := right ( cDataInicial, 4 )
cYearFin2 := right ( cDataFinal, 4 )

if ( cMesIni ) = "02" .and. ( cDiasIni ) = "29" .and. nInternalError = 0 .and. alltrim(str( cYearIni )) = "0"
nInternalError = 1
@ 11,0 say "Data inicial invalida. " + alltrim( cYearIni2 ) + " nao e ano bissexto. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                                         "
@ 12,0 say "                                                                                                                                         "
endif

if ( cMesFin ) = "02" .and. ( cDiasFin ) = "29" .and. nInternalError = 0 .and. alltrim(str( cYearFin )) = "0"
nInternalError = 1
@ 11,0 say "Data final invalida. " + alltrim( cYearFin2 ) + " nao e ano bissexto. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                                         "
@ 12,0 say "                                                                                                                                         "
endif

if empty( cDiasIni ) = .T. .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "O dia da data inicial esta vazio. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if empty( cDiasIni ) = .F. .and. val( cDiasIni ) > 31 .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "O dia da data inicial e invalido. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if empty( cDiasFin ) = .T. .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "O dia da data final esta vazio. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if empty( cDiasFin ) = .F. .and. val( cDiasFin ) > 31 .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "O dia da data final e invalido. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if empty( cMesIni ) = .T. .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "O mes da data inicial esta vazio. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if empty( cMesIni ) = .F. .and. val( cMesIni ) > 12 .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "O mes da data inicial e invalido. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if empty( cMesFin ) = .T. .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "O mes da data final esta vazio. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if empty( cMesFin ) = .F. .and. val( cMesFin ) > 12 .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "O mes da data final e invalido. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesIni ) = "02" .and. ( cDiasIni ) = "30" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data inicial e invalida. Fevereiro nao tem 30 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesIni ) = "02" .and. ( cDiasIni ) = "31" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data inicial e invalida. Fevereiro nao tem 31 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesIni ) = "04" .and. ( cDiasIni ) = "31" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data inicial e invalida. Abril nao tem 31 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesIni ) = "06" .and. ( cDiasIni ) = "31" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data inicial e invalida. Junho nao tem 31 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesIni ) = "09" .and. ( cDiasIni ) = "31" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data inicial e invalida. Setembro nao tem 31 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesIni ) = "11" .and. ( cDiasIni ) = "31" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data inicial e invalida. Novembro nao tem 31 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesFin ) = "02" .and. ( cDiasFin ) = "30" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data final e invalida. Fevereiro nao tem 30 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesFin ) = "02" .and. ( cDiasFin ) = "31" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data final e invalida. Fevereiro nao tem 31 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesFin ) = "04" .and. ( cDiasFin ) = "31" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data final e invalida. Abril nao tem 31 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesFin ) = "06" .and. ( cDiasFin ) = "31" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data final e invalida. Junho nao tem 31 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesFin ) = "09" .and. ( cDiasFin ) = "31" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data final e invalida. Setembro nao tem 31 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if ( cMesFin ) = "11" .and. ( cDiasFin ) = "31" .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "Data final e invalida. Novembro nao tem 31 dias. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if empty( cDataInicial ) = .T. .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "O campo data inicial esta vazio. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                  "
@ 12,0 say "                                                                                                  "
endif

if empty( cDataFinal ) = .T. .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "O campo data final esta vazio. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                  "
@ 12,0 say "                                                                                                  "
endif

nDias := ctod( cDataFinal ) - ctod ( cDataInicial )

if sign( nDias ) == -1 .and. nInternalError = 0
nInternalError = 1
@ 11,0 say "A data inicial nao pode ser maior que a data final. Digite uma data valida ou digite a data 99/99/9999 para cancelar." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 11,0 say "                                                                                                                     "
@ 12,0 say "                                                                                                                     "
endif

if nInternalError = 0
nPeriodo = 0
endif

return

function no_date

screen_zero()

@ 11,0 say "Data inicial: nao informada."
@ 12,0 say "Data final: nao informada."

return

function invalid_data

screen_zero()

@ 8,0 say "A escolha informada e invalida." color "red+"
wait "Pressione qualquer tecla para continuar..."
@ 10,0 say ""
quit

return

function delimita_data1 ( nLine, cFilex, cIndex, cDataInicial, cDataFinal, cTipo )
@ nLine,0 say "Delimita o processamento dos registros em um periodo especifico. Parte 1..."
use ( cFilex ) index ( cIndex )

goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if cTipo = "srag"
if dt_notifi2 >= ctod( cDataInicial ) .and. dt_notifi2 <= ctod( cDataFinal )
replace co_pais with "D"
endif
else
if dt_notific >= ctod( cDataInicial ) .and. dt_notific <= ctod( cDataFinal )
replace tp_not with "D"
endif
endif

skip
nCounter++
@ nLine,74 say alltrim(str(int( nPercent ))) + "%"  color "g+"

enddo

@ nLine,74 say "100%" color "g+"

close

return

function delimita_data2 ( nLine, cFilex, cIndex, cTipo )
@ nLine,0 say "Delimita o processamento dos registros em um periodo especifico. Parte 2..."
use ( cFilex ) index ( cIndex )

goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if cTipo = "srag"
if co_pais <> "D"
dbDelete()
endif
else
if tp_not <> "D"
dbDelete()
endif
endif

skip
nCounter++
@ nLine,74 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ nLine,74 say "100%" color "g+"

pack
close

return

function munic_not( nLine, cFilex )
@ nLine,0 say "Preenchendo o campo 'munic_not'..."
 
use ( cFilex )

nVezes := 0
do while .not. eof()
erro = 0
cValor = alltrim(id_municip)

if empty(cValor) = .F.
nPlace := ascan( aArray1, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeMunicip := aArray1[nPlace,2]
recover
erro = 1
end sequence

if erro = 0 
replace munic_not with cCodeMunicip
endif
endif

skip
enddo

close

return

function regi_not( nLine, cFilex )
@ nLine,0 say "Preenchendo o campo 'regi_not'..."
	  
use ( cFilex )

nVezes := 0
do while .not. eof()
erro = 0
cValor = alltrim(id_regiona)

if empty(cValor) = .F.
nPlace := ascan( aArray2, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeRegiNot := aArray2[nPlace,2]
recover
erro = 1
end sequence

if erro = 0 
replace regi_not with cCodeRegiNot
endif
endif

skip
enddo

close
return

function munic_res( nLine, cFilex, cAgravo )
@ nLine,0 say "Preenchendo o campo 'munic_res'..."
	
use ( cFilex )

nVezes := 0
do while .not. eof()
erro = 0

if cAgravo != "surto"
cValor = alltrim(id_mn_resi)
else
cValor = alltrim( id_muni_re )
endif

if empty(cValor) = .F.
nPlace := ascan( aArray1, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeMunRes := aArray1[nPlace,2]
recover
erro = 1
end sequence

if erro = 0 
replace munic_res with cCodeMunRes
endif
endif

skip
enddo

close
return

function regi_res( nLine, cFilex )
@ nLine,0 say "Preenchendo o campo 'regi_res'..."

use ( cFilex )

nVezes := 0
do while .not. eof()
erro = 0
cValor = alltrim(id_rg_resi)

if empty(cValor) = .F.
nPlace := ascan( aArray2, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeRegiRes := aArray2[nPlace,2]
recover
erro = 1
end sequence

if erro = 0 
replace regi_res with cCodeRegiRes
endif
endif

skip
enddo

close

return

function ocupacao( nLine, cFilex )
@ nLine,0 say "Preenchendo o campo 'ocupacao'..."

use ( cFilex )

nVezes := 0
do while .not. eof()
erro = 0
cValor = alltrim(id_ocupa_n)

if empty(cValor) = .F.
nPlace := ascan( aArray2x, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeOcupa := aArray2x[nPlace,2]
recover
erro = 1
end sequence

if erro = 0 
replace ocupacao with cCodeOcupa
endif
endif

skip
enddo

close

return

function cnae( nLine, cFilex )
@ nLine,0 say "Preenchendo o campo '_cnae'..."

use ( cFilex )

nVezes := 0
do while .not. eof()
erro = 0
cValor = alltrim( cnae )

if empty( cValor ) = .F.
nPlace := ascan( aArray2y, {|x| x[1] == ( cValor ) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeCnae := aArray2y[nPlace,2]
recover
erro = 1
end sequence

if erro = 0
replace _cnae with cCodeCnae
endif
endif

skip
enddo

close

return

function inconsistencia( nLine, cFilex, cIndex1, cIndex2 )

@ nLine,0 say "Procurando inconsistencia no arquivo acbionet.dbf..."

use ( cFilex ) index ( cIndex1 ), ( cIndex2 )
goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( id_ocupa_n ) = .F. ) .and. ( empty( cnae ) = .T. )
nMarked := 0
endif

if ( empty( id_ocupa_n ) = .T. ) .and. ( empty( cnae ) = .F. )
nMarked := 0
endif

if ( empty( id_ocupa_n ) = .T. ) .and. ( empty( cnae ) = .T. )
nMarked := 0
endif

if nMarked = 1
dbDelete()
endif

skip
nCounter++
nMarked := 1
@ nLine,52 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ nLine,52 say "100%" color "g+"

pack
close

return

function cria_campos( nLine, cMessage, cFile_1, cFile_2 )

 @ nLine,0 say ( cMessage )
 
 if cFile_1 <> "c:\auto_regi\tmp\cofi\srag\str_srag"
 use ( cFile_1 ) new
 aStruct := dbStruct( cFile_1 )
 aAdd( aStruct, { "munic_not", "C", 80, 0 } )
 aAdd( aStruct, { "regi_not", "C", 80, 0 } )
 aAdd( aStruct, { "munic_res", "C", 80, 0 } )
 aAdd( aStruct, { "regi_res", "C", 80, 0 } )
 endif
 
 if cFile_1 = "c:\auto_regi\tmp\cerest\str_iexognet" .or. cFile_1 = "c:\auto_regi\tmp\cerest\str_acgranet" ;
 .or. cFile_1 = "c:\auto_regi\tmp\cerest\str_acbionet" 
 aAdd( aStruct, { "ocupacao", "C", 80, 0 } )
 aAdd( aStruct, { "_cnae", "C", 80, 0 } )
 endif 
 
 if cFile_1 = "c:\auto_regi\tmp\cerest\str_iexognet" .or. cFile_1 = "c:\auto_regi\tmp\vio\str_violenet"
 aAdd( aStruct, { "fluxo", "C", 3, 0 } )
 endif
 
 if cFile_1 = "c:\auto_regi\tmp\dnci\str_nindinet"
 aAdd( aStruct, { "dias", "N", 4, 0 } )
 aAdd( aStruct, { "fluxo", "C", 3, 0 } )
 endif 

if cFile_1 = "c:\auto_regi\tmp\cofi\tub\str_tubenet_hiv"
aAdd( aStruct, { "decod", "C", 25, 0 } )
endif

if cFile_1 = "c:\auto_regi\tmp\cofi\tub\str_tubenet_cult"
aAdd( aStruct, { "decod", "C", 25, 0 } )
endif

if cFile_1 = "c:\auto_regi\tmp\cofi\tub\str_tubenet_test"
aAdd( aStruct, { "decod", "C", 25, 0 } )
endif

if cFile_1 = "c:\auto_regi\tmp\cofi\tub\str_tubenet_ident_exam"
aAdd( aStruct, { "inconsistencia", "C", 70, 0 } )
endif

if cFile_1 = "c:\auto_regi\tmp\cofi\hans\str_hansnet_regi_exam"
aAdd( aStruct, { "inconsistencia", "C", 70, 0 } )
endif

if cFile_1 = "c:\auto_regi\tmp\cofi\srag\str_srag"
use ( cFile_1 ) new
aStruct := dbStruct( cFile_1 )
aAdd( aStruct, { "dt_notifi2", "D", 10, 0 } )
endif

dbCreate( cFile_2 , aStruct )

return

function unzip( nLine, cMessage, cZipDir, cUnzipDir )

@ nLine,0 say ( cMessage )

nArraySize := ADir( cZipDir )
aName := Array( nArraySize )
ADir( ( cZipDir ),aName )
for f = 1 to nArraySize
hb_UnzipFile( ( cUnzipDir ) + aName[f] )
next

return

function fusao( nLine, cMessage, cFusaoDir )

@ nLine,0 say ( cMessage )

nArraySize2 := ADir( ( cFusaoDir ) )
aName2 := Array( nArraySize2 )
ADir( ( cFusaoDir ), aName2 )

return

function date_format()

cDiasIni := left( cDataInicial, 2 )
cDiasFin := left( cDataFinal, 2 )
cMesIni := alltrim( substr( cDataInicial, 4, 2 ) )
cMesFin := alltrim( substr( cDataFinal, 4, 2 ) )
cYearIni := year( ctod( cDataInicial ) )
cYearFin := year( ctod( cDataFinal ) )
cYearIni2 := right ( cDataInicial, 4 )
cYearFin2 := right ( cDataFinal, 4 )

switch ( alltrim ( cDiasIni ) )
case "1"
cDiasIni = "01"
exit
case "2"
cDiasIni = "02"
exit
case "3"
cDiasIni = "03"
exit
case "4"
cDiasIni = "04"
exit
case "5"
cDiasIni = "05"
exit
case "6"
cDiasIni = "06"
exit
case "7"
cDiasIni = "07"
exit
case "8"
cDiasIni = "08"
exit
case "9"
cDiasIni = "09"
exit
end

switch ( alltrim ( cDiasFin ) )
case "1"
cDiasFin = "01"
exit
case "2"
cDiasFin = "02"
exit
case "3"
cDiasFin = "03"
exit
case "4"
cDiasFin = "04"
exit
case "5"
cDiasFin = "05"
exit
case "6"
cDiasFin = "06"
exit
case "7"
cDiasFin = "07"
exit
case "8"
cDiasFin = "08"
exit
case "9"
cDiasFin = "09"
exit
end

switch ( cMesIni )
case "1"
cMesIni = "01"
exit
case "2"
cMesIni = "02"
exit
case "3"
cMesIni = "03"
exit
case "4"
cMesIni = "04"
exit
case "5"
cMesIni = "05"
exit
case "6"
cMesIni = "06"
exit
case "7"
cMesIni = "07"
exit
case "8"
cMesIni = "08"
exit
case "9"
cMesIni = "09"
exit
end

switch ( cMesFin )
case "1"
cMesFin = "01"
exit
case "2"
cMesFin = "02"
exit
case "3"
cMesFin = "03"
exit
case "4"
cMesFin = "04"
exit
case "5"
cMesFin = "05"
exit
case "6"
cMesFin = "06"
exit
case "7"
cMesFin = "07"
exit
case "8"
cMesFin = "08"
exit
case "9"
cMesFin = "09"
exit
end

cDataInicial = cDiasIni + "/" + cMesIni + "/" + cYearIni2
cDataFinal = cDiasFin + "/" + cMesFin + "/" + cYearFin2

return

function date_on()

? "Data inicial:" + cDt_Ini
? "Data final:" + cDt_Fin

set color to r+/

if empty( cDt_Ini ) = .T.
? "Erro! Argumento sem data inicial."
? ""
quit
endif

if empty( cDt_Fin ) = .T.
? "Erro! Argumento sem data final."
? ""
quit
endif

cDayIniX := substr( cDt_Ini, 1, 1)
cDayIniY := substr( cDt_Ini, 2, 1 )

if ( isdigit( cDayIniX ) = .F. ) .or. ( isdigit( cDayIniY ) = .F. )
? "Erro! Data inicial invalida. O formato valido e dd/mm/aaaa."
? ""
quit
endif

cDayFinX := substr( cDt_Fin, 1, 1)
cDayFinY := substr( cDt_Fin, 2, 1 )

if ( isdigit( cDayFinX ) = .F. ) .or. ( isdigit( cDayFinY ) = .F. )
? "Erro! Data final invalida. O formato valido e dd/mm/aaaa."
? ""
quit
endif

cMesIniX := substr( cDt_Ini, 4, 1)
cMesIniY := substr( cDt_Ini, 5, 1 )

if ( isdigit( cMesIniX ) = .F. ) .or. ( isdigit( cMesIniY ) = .F. )
? "Erro! Data inicial invalida. O formato valido e dd/mm/aaaa."
? ""
quit
endif

cMesFinX := substr( cDt_Fin, 4, 1)
cMesFinY := substr( cDt_Fin, 5, 1 )

if ( isdigit( cMesFinX ) = .F. ) .or. ( isdigit( cMesFinY ) = .F. )
? "Erro! Data final invalida. O formato valido e dd/mm/aaaa."
? ""
quit
endif

nDt_Ini_Len := len( cDt_Ini )

if nDt_Ini_Len <> 10
? "Erro! Data inicial invalida. O formato valido e dd/mm/aaaa."
? ""
quit
endif

nDt_Fin_Len := len( cDt_Fin )

if nDt_Fin_Len <> 10
? "Erro! Data final invalida. O formato valido e dd/mm/aaaa."
? ""
quit
endif

cBarraIniPos1 := substr( cDt_Ini, 3, 1 )
cBarraIniPos2 := substr( cDt_Ini, 6, 1 )

if cBarraIniPos1 <> "/" .or. cBarraIniPos2 <> "/"
? "Erro! Data inicial invalida. O formato valido e dd/mm/aaaa."
? ""
quit
endif

cBarraFinPos1 := substr( cDt_Fin, 3, 1 )
cBarraFinPos2 := substr( cDt_Fin, 6, 1 )

if cBarraFinPos1 <> "/" .or. cBarraFinPos2 <> "/"
? "Erro! Data final invalida. O formato valido e dd/mm/aaaa."
? ""
quit
endif

cDiasIni := left( cDt_Ini, 2 )
cDiasFin := left( cDt_Fin, 2 )
cMesIni := alltrim( substr( cDt_Ini, 4, 2 ) )
cMesFin := alltrim( substr( cDt_Fin, 4, 2 ) )
cYearIni := year( ctod( cDt_Ini ) )
cYearFin := year( ctod( cDt_Fin ) )
cYearIni2 := right ( cDt_Ini, 4 )
cYearFin2 := right ( cDt_Fin, 4 )

if ( cMesIni ) = "02" .and. ( cDiasIni ) = "29" .and. alltrim(str( cYearIni )) = "0"
? "Erro! Data inicial invalida. " + alltrim( cYearIni2 ) + " nao e ano bissexto. Digite uma data valida."
? ""
quit
endif

if ( cMesFin ) = "02" .and. ( cDiasFin ) = "29" .and. alltrim(str( cYearFin )) = "0"
? "Erro! Data final invalida. " + alltrim( cYearFin2 ) + " nao e ano bissexto. Digite uma data valida."
? ""   
quit                                                                                            
endif

if empty( cDiasIni ) = .F. .and. val( cDiasIni ) > 31
? "Erro! O dia da data inicial e invalido. Digite uma data valida."
? ""   
quit   
endif

if empty( cDiasFin ) = .F. .and. val( cDiasFin ) > 31
? "Erro! O dia da data final e invalido. Digite uma data valida."
? ""   
quit   
endif

if empty( cMesIni ) = .F. .and. val( cMesIni ) > 12 
? "Erro! O mes da data inicial e invalido. Digite uma data valida."
? ""   
quit
endif

if empty( cMesFin ) = .F. .and. val( cMesFin ) > 12 
? "Erro! O mes da data final e invalido. Digite uma data valida."
? ""   
quit
endif

if ( cMesIni ) = "02" .and. ( cDiasIni ) = "30"
? "Data inicial e invalida. Fevereiro nao tem 30 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesIni ) = "02" .and. ( cDiasIni ) = "31"
? "Data inicial e invalida. Fevereiro nao tem 31 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesIni ) = "04" .and. ( cDiasIni ) = "31"
? "Data inicial e invalida. Abril nao tem 31 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesIni ) = "06" .and. ( cDiasIni ) = "31"
? "Data inicial e invalida. Junho nao tem 31 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesIni ) = "09" .and. ( cDiasIni ) = "31"
? "Data inicial e invalida. Setembro nao tem 31 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesIni ) = "11" .and. ( cDiasIni ) = "31"
? "Data inicial e invalida. Novembro nao tem 31 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesFin ) = "02" .and. ( cDiasFin ) = "30"
? "Data final e invalida. Fevereiro nao tem 30 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesFin ) = "02" .and. ( cDiasFin ) = "31"
? "Data final e invalida. Fevereiro nao tem 31 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesFin ) = "04" .and. ( cDiasFin ) = "31"
? "Data final e invalida. Abril nao tem 31 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesFin ) = "06" .and. ( cDiasFin ) = "31"
? "Data final e invalida. Junho nao tem 31 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesFin ) = "09" .and. ( cDiasFin ) = "31"
? "Data final e invalida. Setembro nao tem 31 dias. Digite uma data valida."
? ""   
quit
endif

if ( cMesFin ) = "11" .and. ( cDiasFin ) = "31"
? "Data final e invalida. Novembro nao tem 31 dias. Digite uma data valida."
? ""   
quit
endif

nDias := ctod( cDt_Fin ) - ctod ( cDt_Ini )

if sign( nDias ) == -1
? "A data inicial nao pode ser maior que a data final. Digite uma data valida."
? ""   
quit
endif

set color to bg+/

return

function fluxo( nLine, cMessage, cMessage2, cFile1, cFile2 )

@ nLine,0 say ( cMessage )
      public aArray35 := {}
	  //use "c:\auto_regi\tmp\cerest\iexognet.dbf"
	  use ( cFile1 )
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray35, {alltrim(nu_notific),alltrim(id_agravo),dtoc(dt_notific),alltrim(nm_pacient),id_municip} )
	  //? aArray35[x,1] + "," + aArray35[x,2] + "," + aArray35[x,3] + "," + aArray35[x,4] + "," + aArray35[x,5]
	  skip
	  NEXT
	  close

use "c:\auto_regi\dbf\nindinet.dbf"
nCounter := 1
nTotalRecs := 1

public aArray36 := {}

for x := 1 to nRecs

nPercent := ( ( nCounter * 100 ) / nRecs )

@ nLine,68 say alltrim(str(int( nPercent ))) + "%" color "g+"

locate for alltrim(nu_notific) = aArray35[x,1] .and. alltrim(id_agravo) = aArray35[x,2] .and. dtoc(dt_notific) = aArray35[x,3] .and. alltrim(nm_pacient) = aArray35[x,4] .and. id_municip = aArray35[x,5]

if found() = .T.
//? recno(), nu_notific, id_agravo, dtoc(dt_notific), nm_pacient, id_municip, cs_flxret
AAdd( aArray36, {alltrim(nu_notific),alltrim(id_agravo),dtoc(dt_notific),alltrim(nm_pacient),id_municip,cs_flxret} )
endif

nCounter++
next
close

@ (nLine + 1),0 say ( cMessage2 )

use ( cFile2 )

for y := 1 to len( aArray36 )

locate for alltrim(nu_notific) = aArray36[y,1] .and. alltrim(id_agravo) = aArray36[y,2] .and. dtoc(dt_notific) = aArray36[y,3] .and. alltrim(nm_pacient) = aArray36[y,4] .and. id_municip = aArray36[y,5]

if found() = .T. .and. aArray36[y,6] = "0"
replace fluxo with "NAO"
endif

if found() = .T. .and. ( aArray36[y,6] = "1" .or. aArray36[y,6] = "2" )
replace fluxo with "SIM"
endif

next
close

return

function files()

cFilesDBF := "----------------------"

@ 7,0 say "Verificando arquivos dbf..."
@ 8,0 say "Arquivo nindinet.dbf..." // A
if file("c:\auto_regi\dbf\nindinet.dbf") = .T.
A := "A"
@ 8,23 say "OK!" color "g+"
else
A := "-"
@ 8,23 say "nao existe." color "r+"
endif

@ 9,0 say "Arquivo de exportacao de Dengue..." // B
if file("c:\auto_regi\tmp\dnci\deng\*DBF.zip") = .T.
B := "B"
@ 9,34 say "OK!" color "g+"
else
B := "-"
@ 9,34 say "nao existe." color "r+"
endif

@ 10,0 say "Arquivo de exportacao de Chikungunya..." // C
if file("c:\auto_regi\tmp\dnci\chik\*DBF.zip") = .T.
C := "C"
@ 10,39 say "OK!" color "g+"
else
C := "-"
@ 10,39 say "nao existe." color "r+"
endif

@ 11,0 say "Arquivo acbionet.dbf..." // D
if file("c:\auto_regi\dbf\acbionet.dbf") = .T.
D := "D"
@ 11,23 say "OK!" color "g+"
else
D := "-"
@ 11,23 say "nao existe." color "r+"
endif

@ 12,0 say "Arquivo acgranet.dbf..." // E
if file("c:\auto_regi\dbf\acgranet.dbf") = .T.
E := "E"
@ 12,23 say "OK!" color "g+"
else
E := "-"
@ 12,23 say "nao existe." color "r+"
endif

@ 13,0 say "Arquivo iexognet.dbf..." // F
if file("c:\auto_regi\dbf\iexognet.dbf") = .T.
F := "F"
@ 13,23 say "OK!" color "g+"
else
F := "-"
@ 13,23 say "nao existe." color "r+"
endif

@ 14,0 say "Arquivo violenet.dbf..." // G
if file("c:\auto_regi\dbf\violenet.dbf") = .T.
G := "G"
@ 14,23 say "OK!" color "g+"
else
G := "-"
@ 14,23 say "nao existe." color "r+"
endif

@ 15,0 say "Arquivo municnet.dbf..." // H
if file("c:\auto_regi\dbf\municnet.dbf") = .T.
H := "H"
@ 15,23 say "OK!" color "g+"
else
H := "-"
@ 15,23 say "nao existe." color "r+"
endif

@ 16,0 say "Arquivo regionet.dbf..." // I
if file("c:\auto_regi\dbf\regionet.dbf") = .T.
I := "I"
@ 16,23 say "OK!" color "g+"
else
I := "-"
@ 16,23 say "nao existe." color "r+"
endif

@ 17,0 say "Arquivo cnaenet.dbf..." // J
if file("c:\auto_regi\dbf\cnaenet.dbf") = .T.
J := "J"
@ 17,22 say "OK!" color "g+"
else
J := "-"
@ 17,22 say "nao existe." color "r+"
endif

@ 18,0 say "Arquivo ocupanet.dbf..." // K
if file("c:\auto_regi\dbf\ocupanet.dbf") = .T.
K := "K"
@ 18,23 say "OK!" color "g+"
else
K := "-"
@ 18,23 say "nao existe." color "r+"
endif

@ 19,0 say "Arquivo de exportacao de Dengue - cofinanciamento..." // L
if file("c:\auto_regi\tmp\cofi\deng\*DBF.zip") = .T.
L := "L"
@ 19,52 say "OK!" color "g+"
else
L := "-"
@ 19,52 say "nao existe." color "r+"
endif

@ 20,0 say "Arquivo tubenet.dbf..." // M
if file("c:\auto_regi\dbf\tubenet.dbf") = .T.
M := "M"
@ 20,22 say "OK!" color "g+"
else
M := "-"
@ 20,22 say "nao existe." color "r+"
endif

@ 21,0 say "Arquivo de exportacao de Dengue - cruzamento..." // N
if file("c:\auto_regi\tmp\do_deng\deng\*DBF.zip") = .T.
N := "N"
@ 21,47 say "OK!" color "g+"
else
N := "-"
@ 21,47 say "nao existe." color "r+"
endif

@ 22,0 say "Arquivo de D.O..." // O
if file("c:\auto_regi\tmp\do_deng\do\*.zip") = .T.
O := "O"
@ 22,17 say "OK!" color "g+"
else
O := "-"
@ 22,17 say "nao existe." color "r+"
endif

@ 23,0 say "Arquivo antranet.dbf..." // P
if file("c:\auto_regi\dbf\antranet.dbf") = .T.
P := "P"
@ 23,17 say "OK!" color "g+"
else
P := "-"
@ 23,17 say "nao existe." color "r+"
endif

@ 24,0 say "Arquivo de D.O. - cruzamento tuberculose..." // Q
if file("c:\auto_regi\tmp\tube_do\*.zip") = .T.
Q := "Q"
@ 24,43 say "OK!" color "g+"
else
Q := "-"
@ 24,43 say "nao existe." color "r+"
endif

@ 25,0 say "Arquivo hansnet.dbf..." // R
if file("c:\auto_regi\dbf\hansnet.dbf") = .T.
R := "R"
@ 25,22 say "OK!" color "g+"
else
R := "-"
@ 25,22 say "nao existe." color "r+"
endif

@ 26,0 say "Arquivo de exportacao SRAG..." // S
if file("c:\auto_regi\tmp\cofi\srag\*.zip") = .T.
S := "S"
@ 26,29 say "OK!" color "g+"
else
S := "-"
@ 26,29 say "nao existe." color "r+"
endif

@ 27,0 say "Arquivo de exportacao e-SUS VE Notifica..." // T
if file("c:\auto_regi\tmp\esus\*.csv") = .T.
T := "T"
@ 27,42 say "OK!" color "g+"
else
T := "-"
@ 27,42 say "nao existe." color "r+"
endif

@ 28,0 say "Arquivo sifgenet.dbf..." // U
if file("c:\auto_regi\dbf\sifgenet.dbf") = .T.
U := "U"
@ 28,23 say "OK!" color "g+"
else
U := "-"
@ 28,23 say "nao existe." color "r+"
endif

@ 29,0 say "Arquivo nsurtnet.dbf..." // V
if file("c:\auto_regi\dbf\nsurtnet.dbf") = .T.
V := "V"
@ 29,23 say "OK!" color "g+"
else
V := "-"
@ 29,23 say "nao existe." color "r+"
endif

cFilesDBF := A + B + C + D + E + F + G + H + I + J + K + L + M + N + O + P + Q + R + S + T + U + V

no_keypress()
clear screen
screen_zero()

return ( cFilesDBF )

function acbionet()

set color to w+/b+
@ 15,0 say "Relatorio 1 - indicador 13 PQAVS - subpasta 'cerest' - arquivo 'acbionet.dbf'."
set color to bg+/
@ 16,0 say "Copiando arquivo acbionet original..."

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
copy file "c:\auto_regi\dbf\acbionet.dbf" to "c:\auto_regi\tmp\cerest\acbionet.dbf"
recover
erro = 1
end sequence

if file("c:\auto_regi\tmp\cerest\acbionet.dbf") = .T.
@ 17,0 say "Arquivo transferido..."
else
@ 17,0 say "Erro na transferencia do arquivo..."
wait "Fim do programa. Pressione qualquer tecla para continuar."
quit
endif

if cMode = "--date" // function delimita_data1 ( nLine, cFilex, cIndex, cDataInicial, cDataFinal )

use "c:\auto_regi\tmp\cerest\acbionet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\bio_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cerest\acbionet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\bio_tpnot.ntx","tp_not" )
close

delimita_data1 ( 18, "c:\auto_regi\tmp\cerest\acbionet.dbf", "c:\auto_regi\tmp\cerest\bio_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 19, "c:\auto_regi\tmp\cerest\acbionet.dbf", "c:\auto_regi\tmp\cerest\bio_tpnot.ntx" )

else

@ 18,0 say "Modo --date nao usado..."
@ 19,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\cerest\acbionet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\bio_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cerest\acbionet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\bio_tpnot.ntx","tp_not" )
close

delimita_data1 ( 20, "c:\auto_regi\tmp\cerest\acbionet.dbf", "c:\auto_regi\tmp\cerest\bio_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 21, "c:\auto_regi\tmp\cerest\acbionet.dbf", "c:\auto_regi\tmp\cerest\bio_tpnot.ntx" )

endif

@ 22,0 say "Indexando o arquivo acbionet.dbf..."

use "c:\auto_regi\tmp\cerest\acbionet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\bio_ocupa.ntx","id_ocupa_n" )
close

use "c:\auto_regi\tmp\cerest\acbionet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\bio_cnae.ntx","cnae" )
close

@ 23,0 say "Copiando a estrutura do arquivo acbionet..."
use "c:\auto_regi\tmp\cerest\acbionet.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","id_ocupa_n","cnae" }
__dbCopyStruct("c:\auto_regi\tmp\cerest\str_acbionet.dbf", aFields)
close

cria_campos( 24, "Criando mais campos dentro do arquivo str_acbionet.dbf...", "c:\auto_regi\tmp\cerest\str_acbionet", "c:\auto_regi\tmp\cerest\light_acbionet.dbf" )

inconsistencia( 25, "c:\auto_regi\tmp\cerest\acbionet.dbf", "c:\auto_regi\tmp\cerest\bio_ocupa.ntx", "c:\auto_regi\tmp\cerest\bio_cnae.ntx" )

@ 26,0 say "Enviando registros inconsistentes para o arquivo 'light_acbionet'..."
use "c:\auto_regi\tmp\cerest\light_acbionet.dbf"
append from "c:\auto_regi\tmp\cerest\acbionet.dbf"
close

@ 27,0 say "Preenchendo os campos criados pelo programa..."
munic_not(28,"c:\auto_regi\tmp\cerest\light_acbionet.dbf")
regi_not(29,"c:\auto_regi\tmp\cerest\light_acbionet.dbf")
munic_res(30,"c:\auto_regi\tmp\cerest\light_acbionet.dbf")
regi_res(31,"c:\auto_regi\tmp\cerest\light_acbionet.dbf")
ocupacao(32,"c:\auto_regi\tmp\cerest\light_acbionet.dbf")
cnae(33,"c:\auto_regi\tmp\cerest\light_acbionet.dbf")

no_keypress()

return

function acgranet()

set color to w+/b+
@ 7,0 say "Relatorio 1 - indicador 13 PQAVS - subpasta 'cerest' - arquivo 'acgranet.dbf'."
set color to bg+/
@ 8,0 say "Copiando arquivo acgranet original..."

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
copy file "c:\auto_regi\dbf\acgranet.dbf" to "c:\auto_regi\tmp\cerest\acgranet.dbf"
recover
erro = 1
end sequence

if file("c:\auto_regi\tmp\cerest\acgranet.dbf") = .T.
@ 9,0 say "Arquivo transferido..."
else
@ 9,0 say "Erro na transferencia do arquivo..."
wait "Fim do programa. Pressione qualquer tecla para continuar."
quit
endif

if cMode = "--date"

use "c:\auto_regi\tmp\cerest\acgranet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\acid_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cerest\acgranet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\acid_tpnot.ntx","tp_not" )
close

delimita_data1 ( 10, "c:\auto_regi\tmp\cerest\acgranet.dbf", "c:\auto_regi\tmp\cerest\acid_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 11, "c:\auto_regi\tmp\cerest\acgranet.dbf", "c:\auto_regi\tmp\cerest\acid_tpnot.ntx" )

else

@ 10,0 say "Modo --date nao usado..."
@ 11,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\cerest\acgranet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\acid_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cerest\acgranet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\acid_tpnot.ntx","tp_not" )
close

delimita_data1 ( 12, "c:\auto_regi\tmp\cerest\acgranet.dbf", "c:\auto_regi\tmp\cerest\acid_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 13, "c:\auto_regi\tmp\cerest\acgranet.dbf", "c:\auto_regi\tmp\cerest\acid_tpnot.ntx" )

endif

@ 14,0 say "Indexando o arquivo acgranet.dbf..."
use "c:\auto_regi\tmp\cerest\acgranet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\acid_ocupa.ntx","id_ocupa_n" )
close

use "c:\auto_regi\tmp\cerest\acgranet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\acid_cnae.ntx","cnae" )
close

@ 15,0 say "Copiando a estrutura do arquivo acgranet..."
use "c:\auto_regi\tmp\cerest\acgranet.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","id_ocupa_n","cnae" }
__dbCopyStruct("c:\auto_regi\tmp\cerest\str_acgranet.dbf", aFields)
close

cria_campos( 16, "Criando mais campos dentro do arquivo str_acgranet.dbf...", "c:\auto_regi\tmp\cerest\str_acgranet", "c:\auto_regi\tmp\cerest\light_acgranet.dbf" )

inconsistencia( 17, "c:\auto_regi\tmp\cerest\acgranet.dbf", "c:\auto_regi\tmp\cerest\acid_ocupa.ntx", "c:\auto_regi\tmp\cerest\acid_cnae.ntx" )

@ 18,0 say "Enviando registros inconsistentes para o arquivo 'light_acgranet'..."
use "c:\auto_regi\tmp\cerest\light_acgranet.dbf"
append from "c:\auto_regi\tmp\cerest\acgranet.dbf"
close

@ 19,0 say "Preenchendo os campos criados pelo programa..."
munic_not(20,"c:\auto_regi\tmp\cerest\light_acgranet.dbf")
regi_not(21,"c:\auto_regi\tmp\cerest\light_acgranet.dbf")
munic_res(22,"c:\auto_regi\tmp\cerest\light_acgranet.dbf")
regi_res(23,"c:\auto_regi\tmp\cerest\light_acgranet.dbf")
ocupacao(24,"c:\auto_regi\tmp\cerest\light_acgranet.dbf")
cnae(25,"c:\auto_regi\tmp\cerest\light_acgranet.dbf")

no_keypress()

return

function iexognet()

set color to w+/b+
@ 7,0 say "Relatorio 1 - indicador 13 PQAVS - subpasta 'cerest' - arquivo 'iexognet.dbf'."
set color to bg+/
@ 8,0 say "Copiando arquivo iexognet original..."

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
copy file "c:\auto_regi\dbf\iexognet.dbf" to "c:\auto_regi\tmp\cerest\iexognet.dbf"
recover
erro = 1
end sequence

if file("c:\auto_regi\tmp\cerest\iexognet.dbf") = .T.
@ 9,0 say "Arquivo transferido..."
else
@ 9,0 say "Erro na transferencia do arquivo..."
wait "Fim do programa. Pressione qualquer tecla para continuar."
quit
endif

if cMode = "--date"

use "c:\auto_regi\tmp\cerest\iexognet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\iexo_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cerest\iexognet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\iexo_tpnot.ntx","tp_not" )
close

delimita_data1 ( 10, "c:\auto_regi\tmp\cerest\iexognet.dbf", "c:\auto_regi\tmp\cerest\iexo_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 11, "c:\auto_regi\tmp\cerest\iexognet.dbf", "c:\auto_regi\tmp\cerest\iexo_tpnot.ntx" )

else

@ 10,0 say "Modo --date nao usado..."
@ 11,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\cerest\iexognet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\iexo_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cerest\iexognet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\iexo_tpnot.ntx","tp_not" )
close

delimita_data1 ( 12, "c:\auto_regi\tmp\cerest\iexognet.dbf", "c:\auto_regi\tmp\cerest\iexo_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 13, "c:\auto_regi\tmp\cerest\iexognet.dbf", "c:\auto_regi\tmp\cerest\iexo_tpnot.ntx" )

endif

@ 14,0 say "Indexando o campo 'doenca_tra' em 'iexognet.dbf'..."
use "c:\auto_regi\tmp\cerest\iexognet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\iexo_trab.ntx","doenca_tra" )
close

@ 15,0 say "Excluindo registros sem relacao a trabalho/ocupacao..."

use "c:\auto_regi\tmp\cerest\iexognet.dbf" index "c:\auto_regi\tmp\cerest\iexo_trab.ntx"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( doenca_tra <> "1" )
dbDelete()
endif

skip
nCounter++
nMarked := 1
@ 15,54 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 15,54 say "100%" color "g+"

pack
close

@ 16,0 say "Indexando outros campos do arquivo iexognet.dbf..."

use "c:\auto_regi\tmp\cerest\iexognet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\iexo_ocupa.ntx","id_ocupa_n" )
close

use "c:\auto_regi\tmp\cerest\iexognet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cerest\iexo_cnae.ntx","cnae" )
close

@ 17,0 say "Copiando a estrutura do arquivo iexognet..."
use "c:\auto_regi\tmp\cerest\iexognet.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","id_ocupa_n","cnae" }
__dbCopyStruct("c:\auto_regi\tmp\cerest\str_iexognet.dbf", aFields)
close

cria_campos( 18, "Criando mais campos dentro do arquivo str_iexognet.dbf...", "c:\auto_regi\tmp\cerest\str_iexognet", "c:\auto_regi\tmp\cerest\light_iexognet.dbf" )

inconsistencia( 19, "c:\auto_regi\tmp\cerest\iexognet.dbf", "c:\auto_regi\tmp\cerest\iexo_ocupa.ntx", "c:\auto_regi\tmp\cerest\iexo_cnae.ntx" )

@ 20,0 say "Enviando registros inconsistentes para o arquivo 'light_iexognet'..."
use "c:\auto_regi\tmp\cerest\light_iexognet.dbf"
append from "c:\auto_regi\tmp\cerest\iexognet.dbf"
close

@ 21,0 say "Preenchendo os campos criados pelo programa..."
munic_not(22,"c:\auto_regi\tmp\cerest\light_iexognet.dbf")
regi_not(23,"c:\auto_regi\tmp\cerest\light_iexognet.dbf")
munic_res(24,"c:\auto_regi\tmp\cerest\light_iexognet.dbf")
regi_res(25,"c:\auto_regi\tmp\cerest\light_iexognet.dbf")
ocupacao(26,"c:\auto_regi\tmp\cerest\light_iexognet.dbf")
cnae(27,"c:\auto_regi\tmp\cerest\light_iexognet.dbf")

fluxo( 28, "Identificando quais registros em iexognet.dbf sao fluxo de retorno...", "Transferindo os dados de fluxo para iexognet.dbf.", "c:\auto_regi\tmp\cerest\iexognet.dbf", "c:\auto_regi\tmp\cerest\light_iexognet.dbf" )

no_keypress()

return

function violenet()

set color to w+/b+
@ 7,0 say "Relatorio 3 - indicador 14 PQAVS - subpasta 'vio' - arquivo 'violenet.dbf'."
set color to bg+/
@ 8,0 say "Copiando arquivo violenet original..."

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
copy file "c:\auto_regi\dbf\violenet.dbf" to "c:\auto_regi\tmp\vio\violenet.dbf"
recover
erro = 1
end sequence

if file("c:\auto_regi\tmp\vio\violenet.dbf") = .T.
@ 9,0 say "Arquivo transferido..."
else
@ 9,0 say "Erro na transferencia do arquivo..."
wait "Fim do programa. Pressione qualquer tecla para continuar."
quit
endif

if cMode = "--date"

use "c:\auto_regi\tmp\vio\violenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\vio\vio_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\vio\violenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\vio\vio_tpnot.ntx","tp_not" )
close

delimita_data1 ( 10, "c:\auto_regi\tmp\vio\violenet.dbf", "c:\auto_regi\tmp\vio\vio_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 11, "c:\auto_regi\tmp\vio\violenet.dbf", "c:\auto_regi\tmp\vio\vio_tpnot.ntx" )

else

@ 10,0 say "Modo --date nao usado..."
@ 11,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\vio\violenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\vio\vio_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\vio\violenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\vio\vio_tpnot.ntx","tp_not" )
close

delimita_data1 ( 12, "c:\auto_regi\tmp\vio\violenet.dbf", "c:\auto_regi\tmp\vio\vio_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 13, "c:\auto_regi\tmp\vio\violenet.dbf", "c:\auto_regi\tmp\vio\vio_tpnot.ntx" )

endif

@ 14,0 say "Indexando o arquivo violenet.dbf..."

use "c:\auto_regi\tmp\vio\violenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\vio\vio_raca.ntx","cs_raca" )
close

@ 15,0 say "Copiando a estrutura do arquivo violenet..."
use "c:\auto_regi\tmp\vio\violenet.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi" }
__dbCopyStruct("c:\auto_regi\tmp\vio\str_violenet.dbf", aFields)
close

cria_campos( 16, "Criando mais campos dentro do arquivo str_violenet.dbf...", "c:\auto_regi\tmp\vio\str_violenet", "c:\auto_regi\tmp\vio\light_violenet.dbf" )

@ 17,0 say "Excluindo registros com o campo 'cs_raca' validos..."

use "c:\auto_regi\tmp\vio\violenet.dbf" index "c:\auto_regi\tmp\vio\vio_raca.ntx"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( cs_raca <> "9" ) .and. ( empty( cs_raca ) = .F. )
dbDelete()
endif

skip
nCounter++
nMarked := 1
@ 17,54 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 17,54 say "100%" color "g+"

pack
close

@ 18,0 say "Enviando registros inconsistentes para o arquivo 'light_violenet'..."
use "c:\auto_regi\tmp\vio\light_violenet.dbf"
append from "c:\auto_regi\tmp\vio\violenet.dbf"
close

@ 19,0 say "Preenchendo os campos criados pelo programa..."
munic_not(20,"c:\auto_regi\tmp\vio\light_violenet.dbf")
regi_not(21,"c:\auto_regi\tmp\vio\light_violenet.dbf")
munic_res(22,"c:\auto_regi\tmp\vio\light_violenet.dbf")
regi_res(23,"c:\auto_regi\tmp\vio\light_violenet.dbf")

fluxo( 24, "Identificando quais registros em violenet.dbf sao fluxo de retorno...", "Transferindo os dados de fluxo para violenet.dbf.", "c:\auto_regi\tmp\vio\violenet.dbf", "c:\auto_regi\tmp\vio\light_violenet.dbf" )

no_keypress()

return

function dnci()

set color to w+/b+
@ 7,0 say "Relatorio 2 - indicador 06 PQAVS - subpasta 'dnci'."
set color to bg+/
@ 8,0 say "Copiando arquivo nindinet original..."

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
copy file "c:\auto_regi\dbf\nindinet.dbf" to "c:\auto_regi\tmp\dnci\nindinet.dbf"
recover
erro = 1
end sequence

if file("c:\auto_regi\tmp\dnci\nindinet.dbf") = .T.
@ 9,0 say "Arquivo transferido..."
else
@ 9,0 say "Erro na transferencia do arquivo..."
wait "Fim do programa. Pressione qualquer tecla para continuar."
quit
endif

if cMode = "--date"

use "c:\auto_regi\tmp\dnci\nindinet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\nindi_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\dnci\nindinet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\nindi_tpnot.ntx","tp_not" )
close

delimita_data1 ( 10, "c:\auto_regi\tmp\dnci\nindinet.dbf", "c:\auto_regi\tmp\dnci\nindi_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 11, "c:\auto_regi\tmp\dnci\nindinet.dbf", "c:\auto_regi\tmp\dnci\nindi_tpnot.ntx" )

else

@ 10,0 say "Modo --date nao usado..."
@ 11,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\dnci\nindinet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\nindi_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\dnci\nindinet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\nindi_tpnot.ntx","tp_not" )
close

delimita_data1 ( 12, "c:\auto_regi\tmp\dnci\nindinet.dbf", "c:\auto_regi\tmp\dnci\nindi_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 13, "c:\auto_regi\tmp\dnci\nindinet.dbf", "c:\auto_regi\tmp\dnci\nindi_tpnot.ntx" )

endif

@ 14,0 say "Indexando o arquivo nindinet.dbf..."

use "c:\auto_regi\tmp\dnci\nindinet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\nindi_agravo.ntx","id_agravo" )
close

@ 15,0 say "Excluindo registros irrelevantes para o indicador (parte 1) ..."
use "c:\auto_regi\tmp\dnci\nindinet.dbf" index "c:\auto_regi\tmp\dnci\nindi_agravo.ntx"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

*********************************************************************************
*        CID         *                     Agravo                               *
*********************************************************************************
* A009               * Colera                                                   *
* A928               * Doenca aguda pelo virus Zika                             *
* A959               * Febre Amarela                                            *
* A923               * Febre do Nilo                                            *
* J11                * Influenza Humana por novo subtipo (Pandemico)            *
* A969               * Febre hemorrágica por arenavirus, nao especificada       *
* B54                * Malaria                                                  *
* A209               * Peste                                                    *
* A809               * Paralisia flacida aguda (Poliomielite)                   *
* B09                * Doencas exantematicas                                    *
* A829               * Raiva Humana                                             *
*********************************************************************************

if ( id_agravo = "A009" ) .or. ( id_agravo = "A928" ) .or. ( id_agravo = "A959" ) .or. ( id_agravo = "A923" ) .or. ( id_agravo = "J11" );
 .or. ( id_agravo = "A969" ) .or. ( id_agravo = "B54" ) .or. ( id_agravo = "A209" ) .or. ( id_agravo = "A809" ) .or. ( id_agravo = "B09" );
 .or. ( id_agravo = "A829" )
replace tp_not with "X"
endif

skip
nCounter++
nMarked := 1
@ 15,62 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 15,62 say "100%" color "g+"

close

@ 16,0 say "Reindexando o arquivo nindinet.dbf..."

use "c:\auto_regi\tmp\dnci\nindinet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\nindi_tpnot.ntx","tp_not" )
close

@ 17,0 say "Excluindo registros irrelevantes para o indicador (parte 2) ..."

use "c:\auto_regi\tmp\dnci\nindinet.dbf" index "c:\auto_regi\tmp\dnci\nindi_tpnot.ntx"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "X"
dbDelete()
endif

skip
nCounter++
nMarked := 1
@ 17,62 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 17,62 say "100%" color "g+"

pack
close

@ 18,0 say "Copiando a estrutura do arquivo nindinet..."
use "c:\auto_regi\tmp\dnci\nindinet.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","dt_encerra","cs_flxret" }
__dbCopyStruct("c:\auto_regi\tmp\dnci\str_nindinet.dbf", aFields)
close

cria_campos( 19, "Criando mais campos dentro do arquivo str_nindinet.dbf...", "c:\auto_regi\tmp\dnci\str_nindinet", "c:\auto_regi\tmp\dnci\light_nindinet.dbf" )

@ 20,0 say "Enviando registros os registros para o arquivo 'light_nindinet'..."
use "c:\auto_regi\tmp\dnci\light_nindinet.dbf"
append from "c:\auto_regi\tmp\dnci\nindinet.dbf"
close

@ 21,0 say "Calculando dias de encerramento dos casos..."

use "c:\auto_regi\tmp\dnci\light_nindinet.dbf"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

nDias := ( dt_encerra - dt_notific )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
replace dias with nDias
recover
end sequence

skip
nCounter++
nMarked := 1
@ 21,43 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 21,43 say "100%" color "g+"

pack
close

@ 22,0 say "Deixando no arquivo apenas os registros inconsistentes..."

use "c:\auto_regi\tmp\dnci\light_nindinet.dbf"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( dt_encerra ) = .F. )
dbDelete()
endif

skip
nCounter++
@ 22,57 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 22,57 say "100%" color "g+"

pack
close

@ 23,0 say "Preenchendo os campos criados pelo programa..."
munic_not(24,"c:\auto_regi\tmp\dnci\light_nindinet.dbf")
regi_not(25,"c:\auto_regi\tmp\dnci\light_nindinet.dbf")
munic_res(26,"c:\auto_regi\tmp\dnci\light_nindinet.dbf")
regi_res(27,"c:\auto_regi\tmp\dnci\light_nindinet.dbf")

@ 28,0 say "Identifica no campo 'fluxo' se a notificacao esta marcada para o fluxo de retorno."

use "c:\auto_regi\tmp\dnci\light_nindinet.dbf"
do while .not. eof()

if cs_flxret = "0"
replace fluxo with "NAO"
endif

if cs_flxret = "1" .or. cs_flxret = "2"
replace fluxo with "SIM"
endif

skip
enddo
close

unzip( 29, "Descompacta os arquivos zip originais de Chikungunya...", "c:\auto_regi\tmp\dnci\chik\*.zip", "c:\auto_regi\tmp\dnci\chik\" )

fusao( 30, "Fusao dos arquivos de Chikungunya (se hover mais de um)...", "c:\auto_regi\tmp\dnci\chik\*.dbf" )

copy file "c:\auto_regi\mod\chikon_model.dbf" to "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf"

use "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf"

for f = 1 to nArraySize2
append from ( "c:\auto_regi\tmp\dnci\chik\" + aName2[f] )
next

close

if HB_Argv( 1 ) = "--list" .or. HB_Argv( 2 ) = "--list" .or. HB_Argv( 3 ) = "--list" .or. HB_Argv( 4 ) = "--list" .or. HB_Argv( 5 ) = "--list" .or. ;
HB_Argv( 6 ) = "--list" .or. HB_Argv( 7 ) = "--list" .or. HB_Argv( 8 ) = "--list"

list_mun( 31, "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf", "chik" )

endif

if cMode = "--date"

use "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\chik\chik_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\chik\chik_tpnot.ntx","tp_not" )
close

delimita_data1 ( 35, "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf", "c:\auto_regi\tmp\dnci\chik\chik_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 36, "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf", "c:\auto_regi\tmp\dnci\chik\chik_tpnot.ntx" )

else

@ 35,0 say "Modo --date nao usado..."
@ 36,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\chik\chik_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\chik\chik_tpnot.ntx","tp_not" )
close

delimita_data1 ( 37, "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf", "c:\auto_regi\tmp\dnci\chik\chik_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 38, "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf", "c:\auto_regi\tmp\dnci\chik\chik_tpnot.ntx" )

endif

@ 39,0 say "Indexando o campo evolucao..."

use "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\chik\chik_evolucao.ntx","evolucao" )
close

@ 40,0 say "Procurando as notificacaoes com obitos suspeitos..."

use "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf" index "c:\auto_regi\tmp\dnci\chik\chik_evolucao.ntx"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( evolucao <> "4" )
dbDelete()
endif

skip
nCounter++
@ 40,52 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 40,52 say "100%" color "g+"

pack
close

@ 41,0 say "Indexando o campo data de encerramento..."

use "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\chik\chik_encerra.ntx","dt_encerra" )
close

@ 42,0 say "Procurado registros com data de encerramento em branco..."

use "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf" index "c:\auto_regi\tmp\dnci\chik\chik_encerra.ntx"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( dt_encerra ) = .F. )
dbDelete()
endif

skip
nCounter++
@ 42,57 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 42,57 say "100%" color "g+"

pack
close

@ 47,0 say "Copiando a estrutura do arquivo chikon_model..."
use "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","dt_encerra" }
__dbCopyStruct("c:\auto_regi\tmp\dnci\chik\str_chikon.dbf", aFields)
close

cria_campos( 48, "Criando mais campos dentro do arquivo str_chikon.dbf...", "c:\auto_regi\tmp\dnci\chik\str_chikon.dbf", "c:\auto_regi\tmp\dnci\chik\light_chikon.dbf" )

@ 49,0 say "Enviando os registros para o arquivo 'light_chikon'..."
use "c:\auto_regi\tmp\dnci\chik\light_chikon.dbf"
append from "c:\auto_regi\tmp\dnci\chik\chikon_model.dbf"
close

@ 50,0 say "Preenchendo os campos criados pelo programa..."
munic_not(51,"c:\auto_regi\tmp\dnci\chik\light_chikon.dbf")
regi_not(52,"c:\auto_regi\tmp\dnci\chik\light_chikon.dbf")
munic_res(53,"c:\auto_regi\tmp\dnci\chik\light_chikon.dbf")
regi_res(54,"c:\auto_regi\tmp\dnci\chik\light_chikon.dbf")

unzip( 55, "Descompacta os arquivos zip originais de Dengue...", "c:\auto_regi\tmp\dnci\deng\*.zip", "c:\auto_regi\tmp\dnci\deng\" )

fusao( 56, "Fusao dos arquivos de Dengue (se hover mais de um)...", "c:\auto_regi\tmp\dnci\deng\*.dbf" )

copy file "c:\auto_regi\mod\dengon_model.dbf" to "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf"

use "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf"

for f = 1 to nArraySize2
append from ( "c:\auto_regi\tmp\dnci\deng\" + aName2[f] )
next

close

if HB_Argv( 1 ) = "--list" .or. HB_Argv( 2 ) = "--list" .or. HB_Argv( 3 ) = "--list" .or. HB_Argv( 4 ) = "--list" .or. HB_Argv( 5 ) = "--list" .or. ;
HB_Argv( 6 ) = "--list" .or. HB_Argv( 7 ) = "--list" .or. HB_Argv( 8 ) = "--list"

list_mun( 57, "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf", "deng" )

endif

if cMode = "--date"

use "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\deng\deng_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\deng\deng_tpnot.ntx","tp_not" )
close

delimita_data1 ( 61, "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf", "c:\auto_regi\tmp\dnci\deng\deng_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 62, "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf", "c:\auto_regi\tmp\dnci\deng\deng_tpnot.ntx" )

else

@ 61,0 say "Modo --date nao usado..."
@ 62,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\deng\deng_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\deng\deng_tpnot.ntx","tp_not" )
close

delimita_data1 ( 63, "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf", "c:\auto_regi\tmp\dnci\deng\deng_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 64, "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf", "c:\auto_regi\tmp\dnci\deng\deng_tpnot.ntx" )

endif

@ 65,0 say "Indexando o campo evolucao..."

use "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\deng\deng_evolucao.ntx","evolucao" )
close

@ 66,0 say "Procurando as notificacoes com confirmacao de obitos..."

use "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf" index "c:\auto_regi\tmp\dnci\deng\deng_evolucao.ntx"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( evolucao <> "2" )
dbDelete()
endif

skip
nCounter++
@ 66,55 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 66,55 say "100%" color "g+"

pack
close

@ 67,0 say "Indexando o campo data de encerramento..."

use "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\dnci\deng\deng_encerra.ntx","dt_encerra" )
close

@ 68,0 say "Procurado registros com data de encerramento em branco..."

use "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf" index "c:\auto_regi\tmp\dnci\deng\deng_encerra.ntx"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( dt_encerra ) = .F. )
dbDelete()
endif

skip
nCounter++
@ 68,57 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 68,57 say "100%" color "g+"

pack
close

@ 69,0 say "Copiando a estrutura do arquivo dengon_model..."
use "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","dt_encerra" }
__dbCopyStruct("c:\auto_regi\tmp\dnci\deng\str_dengon.dbf", aFields)
close

cria_campos( 70, "Criando mais campos dentro do arquivo str_dengon.dbf...", "c:\auto_regi\tmp\dnci\deng\str_dengon.dbf", "c:\auto_regi\tmp\dnci\deng\light_dengon.dbf" )

@ 71,0 say "Enviando os registros para o arquivo 'light_dengon'..."
use "c:\auto_regi\tmp\dnci\deng\light_dengon.dbf"
append from "c:\auto_regi\tmp\dnci\deng\dengon_model.dbf"
close

@ 72,0 say "Preenchendo os campos criados pelo programa..."
munic_not(73,"c:\auto_regi\tmp\dnci\deng\light_dengon.dbf")
regi_not(74,"c:\auto_regi\tmp\dnci\deng\light_dengon.dbf")
munic_res(75,"c:\auto_regi\tmp\dnci\deng\light_dengon.dbf")
regi_res(76,"c:\auto_regi\tmp\dnci\deng\light_dengon.dbf")

no_keypress()

return

function transfer()

@ 7,0 say "Transferindo arquivos para os diretorios de relatorios..."

nScore_rel1 := 0
nScore_rel2 := 0
nScore_rel3 := 0
nScore_rel4 := 0
nScore_rel5 := 0
nScore_rel6 := 0
nScore_rel7 := 0
nScore_rel8 := 0
nScore_rel9 := 0
nScore_rel10 := 0
nScore_rel11 := 0
nScore_rel12 := 0
nScore_rel13 := 0

if file("c:\auto_regi\tmp\cerest\light_iexognet.dbf") = .T.
nScore_rel1++
copy file "c:\auto_regi\tmp\cerest\light_iexognet.dbf" to "c:\auto_regi\rel\rel1\rel1_intox_exog.dbf"
endif

if file("c:\auto_regi\tmp\cerest\light_acgranet.dbf") = .T.
nScore_rel1++
copy file "c:\auto_regi\tmp\cerest\light_acgranet.dbf" to "c:\auto_regi\rel\rel1\rel1_acid_grave.dbf"
endif

if file("c:\auto_regi\tmp\cerest\light_acbionet.dbf") = .T.
nScore_rel1++
copy file "c:\auto_regi\tmp\cerest\light_acbionet.dbf" to "c:\auto_regi\rel\rel1\rel1_acid_bio.dbf"
endif

switch ( nScore_rel1 )
case 1
@ 8,0 say "Relatorio 1:"
@ 8,13 say "01 planilha gerada." color "g+"
exit
case 2
@ 8,0 say "Relatorio 1:"
@ 8,13 say "02 planilhas geradas." color "g+"
exit
case 3
@ 8,0 say "Relatorio 1:"
@ 8,13 say "03 planilhas geradas." color "g+"
exit
otherwise
@ 8,0 say "Relatorio 1:"
@ 8,13 say "0 planilhas geradas." color "r+"
end

if file("c:\auto_regi\tmp\dnci\light_nindinet.dbf") = .T.
nScore_rel2++
copy file "c:\auto_regi\tmp\dnci\light_nindinet.dbf" to "c:\auto_regi\rel\rel2\rel2_not_indiv.dbf"
endif

if file("c:\auto_regi\tmp\dnci\chik\light_chikon.dbf") = .T.
nScore_rel2++
copy file "c:\auto_regi\tmp\dnci\chik\light_chikon.dbf" to "c:\auto_regi\rel\rel2\rel2_chikungunya.dbf"
endif

if file("c:\auto_regi\tmp\dnci\deng\light_dengon.dbf") = .T.
nScore_rel2++
copy file "c:\auto_regi\tmp\dnci\deng\light_dengon.dbf" to "c:\auto_regi\rel\rel2\rel2_dengue.dbf"
endif

switch ( nScore_rel2 )
case 1
@ 9,0 say "Relatorio 2:"
@ 9,13 say "01 planilha gerada." color "g+"
exit
case 2
@ 9,0 say "Relatorio 2:"
@ 9,13 say "02 planilhas geradas." color "g+"
exit
case 3
@ 9,0 say "Relatorio 2:"
@ 9,13 say "03 planilhas geradas." color "g+"
exit
otherwise
@ 9,0 say "Relatorio 2:"
@ 9,13 say "0 planilhas geradas." color "r+"
end

if file("c:\auto_regi\tmp\vio\light_violenet.dbf") = .T.
nScore_rel3++
copy file "c:\auto_regi\tmp\vio\light_violenet.dbf" to "c:\auto_regi\rel\rel3\rel3_violencias.dbf"
endif

switch ( nScore_rel3 )
case 1
@ 10,0 say "Relatorio 3:"
@ 10,13 say "01 planilha gerada." color "g+"
exit
otherwise
@ 10,0 say "Relatorio 3:"
@ 10,13 say "0 planilhas geradas." color "r+"
exit
end

if file("c:\auto_regi\tmp\cofi\deng\light_dengon_encerra.dbf") = .T.
nScore_rel4++
copy file "c:\auto_regi\tmp\cofi\deng\light_dengon_encerra.dbf" to "c:\auto_regi\rel\rel4\rel4_deng_encerra.dbf"
endif

if file("c:\auto_regi\tmp\cofi\deng\light_dengon_evolucao.dbf") = .T.
nScore_rel4++
copy file "c:\auto_regi\tmp\cofi\deng\light_dengon_evolucao.dbf" to "c:\auto_regi\rel\rel4\rel4_deng_evolucao.dbf"
endif

switch ( nScore_rel4 )
case 1
@ 11,0 say "Relatorio 4:"
@ 11,13 say "01 planilha gerada." color "g+"
exit
case 2
@ 11,0 say "Relatorio 4:"
@ 11,13 say "02 planilhas geradas." color "g+"
exit
otherwise
@ 11,0 say "Relatorio 4:"
@ 11,13 say "0 planilhas geradas." color "r+"
end

if file("c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf") = .T.
nScore_rel5++
copy file "c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf" to "c:\auto_regi\rel\rel5\rel5_tub_cultura.dbf"
endif

if file("c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf") = .T.
nScore_rel5++
copy file "c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf" to "c:\auto_regi\rel\rel5\rel5_tub_hiv.dbf"
endif

if file("c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf") = .T.
nScore_rel5++
copy file "c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf" to "c:\auto_regi\rel\rel5\rel5_tub_ident_exam.dbf"
endif

if file("c:\auto_regi\tmp\cofi\tub\light_tubenet_situacao.dbf") = .T.
nScore_rel5++
copy file "c:\auto_regi\tmp\cofi\tub\light_tubenet_situacao.dbf" to "c:\auto_regi\rel\rel5\rel5_tub_situacao.dbf"
endif

if file("c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf") = .T.
nScore_rel5++
copy file "c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf" to "c:\auto_regi\rel\rel5\rel5_tub_test.dbf"
endif

switch ( nScore_rel5 )
case 1
@ 12,0 say "Relatorio 5:"
@ 12,13 say "01 planilha gerada." color "g+"
exit
case 2
@ 12,0 say "Relatorio 5:"
@ 12,13 say "02 planilhas geradas." color "g+"
exit
case 3
@ 12,0 say "Relatorio 5:"
@ 12,13 say "03 planilhas geradas." color "g+"
exit
case 4
@ 12,0 say "Relatorio 5:"
@ 12,13 say "04 planilhas geradas." color "g+"
exit
case 5
@ 12,0 say "Relatorio 5:"
@ 12,13 say "05 planilhas geradas." color "g+"
exit
otherwise
@ 12,0 say "Relatorio 5:"
@ 12,13 say "0 planilhas geradas." color "r+"
end

if file("c:\auto_regi\tmp\do_deng\do\light_do.dbf") = .T.
nScore_rel6++
copy file "c:\auto_regi\tmp\do_deng\do\light_do.dbf" to "c:\auto_regi\rel\rel6\rel6_deng_do.dbf"
endif

switch ( nScore_rel6 )
case 1
@ 13,0 say "Relatorio 6:"
@ 13,13 say "01 planilha gerada." color "g+"
exit
otherwise
@ 13,0 say "Relatorio 6:"
@ 13,13 say "0 planilhas geradas." color "r+"
exit
end

if file("c:\auto_regi\tmp\atend\light_antranet.dbf") = .T.
nScore_rel7++
copy file "c:\auto_regi\tmp\atend\light_antranet.dbf" to "c:\auto_regi\rel\rel7\rel7_atend_antirrab.dbf"
endif

switch ( nScore_rel7 )
case 1
@ 14,0 say "Relatorio 7:"
@ 14,13 say "01 planilha gerada." color "g+"
exit
otherwise
@ 14,0 say "Relatorio 7:"
@ 14,13 say "0 planilhas geradas." color "r+"
exit
end

if file("c:\auto_regi\tmp\tube_do\light_do.dbf") = .T.
nScore_rel8++
copy file "c:\auto_regi\tmp\tube_do\light_do.dbf" to "c:\auto_regi\rel\rel8\rel8_tube_do.dbf"
endif

switch ( nScore_rel8 )
case 1
@ 15,0 say "Relatorio 8:"
@ 15,13 say "01 planilha gerada." color "g+"
exit
otherwise
@ 15,0 say "Relatorio 8:"
@ 15,13 say "0 planilhas geradas." color "r+"
exit
end

if file("c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf") = .T.
nScore_rel9++
copy file "c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf" to "c:\auto_regi\rel\rel9\rel9_hans_reg_exam.dbf"
endif

if file("c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf") = .T.
nScore_rel9++
copy file "c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf" to "c:\auto_regi\rel\rel9\rel9_hans_saida.dbf"
endif

switch ( nScore_rel9 )
case 1
@ 16,0 say "Relatorio 9:"
@ 16,13 say "01 planilha gerada." color "g+"
exit

case 2
@ 16,0 say "Relatorio 9:"
@ 16,13 say "02 planilha geradas." color "g+"
exit

otherwise
@ 16,0 say "Relatorio 9:"
@ 16,13 say "0 planilhas geradas." color "r+"
exit
end

if file("c:\auto_regi\tmp\cofi\srag\light_class_srag.dbf") = .T.
nScore_rel10++
copy file "c:\auto_regi\tmp\cofi\srag\light_class_srag.dbf" to "c:\auto_regi\rel\rel10\rel10_srag_class.dbf"
endif

if file("c:\auto_regi\tmp\cofi\srag\light_evolucao_srag.dbf") = .T.
nScore_rel10++
copy file "c:\auto_regi\tmp\cofi\srag\light_evolucao_srag.dbf" to "c:\auto_regi\rel\rel10\rel10_srag_evolucao.dbf"
endif

if file("c:\auto_regi\tmp\cofi\srag\light_resultado_srag.dbf") = .T.
nScore_rel10++
copy file "c:\auto_regi\tmp\cofi\srag\light_resultado_srag.dbf" to "c:\auto_regi\rel\rel10\rel10_srag_resultado.dbf"
endif

switch ( nScore_rel10 )
case 1
@ 17,0 say "Relatorio 10:"
@ 17,14 say "01 planilha gerada." color "g+"
exit

case 2
@ 17,0 say "Relatorio 10:"
@ 17,14 say "02 planilha geradas." color "g+"
exit

case 3
@ 17,0 say "Relatorio 10:"
@ 17,14 say "03 planilha geradas." color "g+"
exit

otherwise
@ 17,0 say "Relatorio 10:"
@ 17,13 say "0 planilhas geradas." color "r+"
exit
end

if file("c:\auto_regi\tmp\esus\light_esus_evolucao.dbf") = .T.
nScore_rel11++
copy file "c:\auto_regi\tmp\esus\light_esus_evolucao.dbf" to "c:\auto_regi\rel\rel11\rel11_esus.dbf"
endif

switch ( nScore_rel11 )
case 1
@ 18,0 say "Relatorio 11:"
@ 18,14 say "01 planilha gerada." color "g+"
exit
otherwise
@ 18,0 say "Relatorio 11:"
@ 18,14 say "0 planilhas geradas." color "r+"
exit
end

if file("c:\auto_regi\tmp\cofi\sif\light_sif_class.dbf") = .T.
nScore_rel12++
copy file "c:\auto_regi\tmp\cofi\sif\light_sif_class.dbf" to "c:\auto_regi\rel\rel12\rel12_sif_class.dbf"
endif

if file("c:\auto_regi\tmp\cofi\sif\light_sif_esquema.dbf") = .T.
nScore_rel12++
copy file "c:\auto_regi\tmp\cofi\sif\light_sif_esquema.dbf" to "c:\auto_regi\rel\rel12\rel12_sif_esquema.dbf"
endif

if file("c:\auto_regi\tmp\cofi\sif\light_sif_gestante.dbf") = .T.
nScore_rel12++
copy file "c:\auto_regi\tmp\cofi\sif\light_sif_gestante.dbf" to "c:\auto_regi\rel\rel12\rel12_sif_gestante.dbf"
endif

switch ( nScore_rel12 )
case 1
@ 19,0 say "Relatorio 12:"
@ 19,14 say "01 planilha gerada." color "g+"
exit

case 2
@ 19,0 say "Relatorio 12:"
@ 19,14 say "02 planilhas geradas." color "g+"
exit

case 3
@ 19,0 say "Relatorio 12:"
@ 19,14 say "03 planilhas geradas." color "g+"
exit

otherwise
@ 19,0 say "Relatorio 12:"
@ 19,13 say "0 planilhas geradas." color "r+"
exit
end

if file("c:\auto_regi\tmp\cofi\surto\light_surto_local.dbf") = .T.
nScore_rel13++
copy file "c:\auto_regi\tmp\cofi\surto\light_surto_local.dbf" to "c:\auto_regi\rel\rel13\rel13_surto_local.dbf"
endif

if file("c:\auto_regi\tmp\cofi\surto\light_surto_casos.dbf") = .T.
nScore_rel13++
copy file "c:\auto_regi\tmp\cofi\surto\light_surto_casos.dbf" to "c:\auto_regi\rel\rel13\rel13_surto_casos.dbf"
endif

if file("c:\auto_regi\tmp\cofi\surto\light_surto_encerra.dbf") = .T.
nScore_rel13++
copy file "c:\auto_regi\tmp\cofi\surto\light_surto_encerra.dbf" to "c:\auto_regi\rel\rel13\rel13_surto_encerra.dbf"
endif

switch ( nScore_rel13 )
case 1
@ 20,0 say "Relatorio 13:"
@ 20,14 say "01 planilha gerada." color "g+"
exit

case 2
@ 20,0 say "Relatorio 13:"
@ 20,14 say "02 planilha geradas." color "g+"
exit

case 3
@ 20,0 say "Relatorio 13:"
@ 20,14 say "03 planilha geradas." color "g+"
exit

otherwise
@ 20,0 say "Relatorio 13:"
@ 20,13 say "0 planilhas geradas." color "r+"
exit
end

return

function deng_cofi()

set color to w+/b+
@ 7,0 say "Relatorio 4 - projeto de cofinanciamento - subpasta 'cofi/deng'."
set color to bg+/

unzip( 8, "Descompacta os arquivos zip originais de Dengue...", "c:\auto_regi\tmp\cofi\deng\*.zip", "c:\auto_regi\tmp\cofi\deng\" )

fusao( 9, "Fusao dos arquivos de Dengue (se hover mais de um)...", "c:\auto_regi\tmp\cofi\deng\*.dbf" )

copy file "c:\auto_regi\mod\dengon_model.dbf" to "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf"

use "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf"

for f = 1 to nArraySize2
append from ( "c:\auto_regi\tmp\cofi\deng\" + aName2[f] )
next

close

if HB_Argv( 1 ) = "--list" .or. HB_Argv( 2 ) = "--list" .or. HB_Argv( 3 ) = "--list" .or. HB_Argv( 4 ) = "--list" .or. HB_Argv( 5 ) = "--list" .or. ;
HB_Argv( 6 ) = "--list" .or. HB_Argv( 7 ) = "--list" .or. HB_Argv( 8 ) = "--list"

list_mun( 10, "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf", "deng" )

endif

if cMode = "--date"

use "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\deng\deng_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\deng\deng_tpnot.ntx","tp_not" )
close

delimita_data1 ( 14, "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf", "c:\auto_regi\tmp\cofi\deng\deng_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 15, "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf", "c:\auto_regi\tmp\cofi\deng\deng_tpnot.ntx" )

else

@ 14,0 say "Modo --date nao usado..."
@ 15,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\deng\deng_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\deng\deng_tpnot.ntx","tp_not" )
close

delimita_data1 ( 16, "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf", "c:\auto_regi\tmp\cofi\deng\deng_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 17, "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf", "c:\auto_regi\tmp\cofi\deng\deng_tpnot.ntx" )

endif

rename "c:\auto_regi\tmp\cofi\deng\dengon_model.dbf" to "c:\auto_regi\tmp\cofi\deng\dengon_model_encerra.dbf"
copy file "c:\auto_regi\tmp\cofi\deng\dengon_model_encerra.dbf" to "c:\auto_regi\tmp\cofi\deng\dengon_model_evolucao.dbf"

@ 18,0 say "Indexando o campo data de encerramento..."

use "c:\auto_regi\tmp\cofi\deng\dengon_model_encerra.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\deng\deng_encerra.ntx","dt_encerra" )
close

@ 19,0 say "Procurando as notificacoes com data de encerramento em branco..."

use "c:\auto_regi\tmp\cofi\deng\dengon_model_encerra.dbf" index "c:\auto_regi\tmp\cofi\deng\deng_encerra.ntx"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( dt_encerra ) = .F. )
dbDelete()
endif

skip
nCounter++
@ 19,64 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 19,64 say "100%" color "g+"

pack
close

@ 20,0 say "Copiando a estrutura do arquivo dengon_model_encerra.dbf..."
use "c:\auto_regi\tmp\cofi\deng\dengon_model_encerra.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","dt_encerra" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\deng\str_dengon.dbf", aFields)
close

cria_campos( 21, "Criando mais campos dentro do arquivo str_dengon.dbf...", "c:\auto_regi\tmp\cofi\deng\str_dengon", "c:\auto_regi\tmp\cofi\deng\light_dengon_encerra.dbf" )

@ 22,0 say "Enviando registros inconsistentes para o arquivo 'light_dengon_encerra'..."
use "c:\auto_regi\tmp\cofi\deng\light_dengon_encerra.dbf"
append from "c:\auto_regi\tmp\cofi\deng\dengon_model_encerra.dbf"
close

munic_not(23,"c:\auto_regi\tmp\cofi\deng\light_dengon_encerra.dbf")
regi_not(24,"c:\auto_regi\tmp\cofi\deng\light_dengon_encerra.dbf")
munic_res(25,"c:\auto_regi\tmp\cofi\deng\light_dengon_encerra.dbf")
regi_res(26,"c:\auto_regi\tmp\cofi\deng\light_dengon_encerra.dbf")

@ 27,0 say "Indexando o campo evolucao..."

use "c:\auto_regi\tmp\cofi\deng\dengon_model_evolucao.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\deng\deng_evolucao.ntx","evolucao" )
close

@ 28,0 say "Procurando as notificacoes com campo evolucao em branco ou ignorado. Parte 1..."

use "c:\auto_regi\tmp\cofi\deng\dengon_model_evolucao.dbf" index "c:\auto_regi\tmp\cofi\deng\deng_evolucao.ntx"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( evolucao ) = .T. )
replace tp_not with "E"
endif

if evolucao = "9"
replace tp_not with "E"
endif

skip
nCounter++
@ 28,79 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 28,79 say "100%" color "g+"

pack
close

@ 29,0 say "Procurando as notificacoes com campo evolucao em branco ou ignorado. Parte 2..."

use "c:\auto_regi\tmp\cofi\deng\dengon_model_evolucao.dbf"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "E"
dbDelete()
endif

skip
nCounter++
@ 29,79 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 29,79 say "100%" color "g+"

pack
close

@ 30,0 say "Copiando a estrutura do arquivo dengon_model_evolucao.dbf..."
use "c:\auto_regi\tmp\cofi\deng\dengon_model_evolucao.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","evolucao" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\deng\str_dengon2.dbf", aFields)
close

cria_campos( 31, "Criando mais campos dentro do arquivo str_dengon2.dbf...", "c:\auto_regi\tmp\cofi\deng\str_dengon2", "c:\auto_regi\tmp\cofi\deng\light_dengon_evolucao.dbf" )

@ 32,0 say "Enviando registros inconsistentes para o arquivo 'light_dengon_evolucao'..."
use "c:\auto_regi\tmp\cofi\deng\light_dengon_evolucao.dbf"
append from "c:\auto_regi\tmp\cofi\deng\dengon_model_evolucao.dbf"
close

munic_not(33,"c:\auto_regi\tmp\cofi\deng\light_dengon_evolucao.dbf")
regi_not(34,"c:\auto_regi\tmp\cofi\deng\light_dengon_evolucao.dbf")
munic_res(35,"c:\auto_regi\tmp\cofi\deng\light_dengon_evolucao.dbf")
regi_res(36,"c:\auto_regi\tmp\cofi\deng\light_dengon_evolucao.dbf")

no_keypress()

return

function tubenet()

set color to w+/b+
@ 7,0 say "Relatorio 5 - projeto de cofinanciamento - subpasta 'cofi/tub'."
set color to bg+/
@ 8,0 say "Copiando arquivo tubenet.dbf original..."

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
copy file "c:\auto_regi\dbf\tubenet.dbf" to "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
recover
erro = 1
end sequence

if file("c:\auto_regi\tmp\cofi\tub\tubenet.dbf") = .T.
@ 9,0 say "Arquivo transferido..."
else
@ 9,0 say "Erro na transferencia do arquivo..."
wait "Fim do programa. Pressione qualquer tecla para continuar."
quit
endif

if cMode = "--date" // function delimita_data1 ( nLine, cFilex, cIndex, cDataInicial, cDataFinal )

use "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\tub\tub_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\tub\tub_tpnot.ntx","tp_not" )
close

delimita_data1 ( 10, "c:\auto_regi\tmp\cofi\tub\tubenet.dbf", "c:\auto_regi\tmp\cofi\tub\tub_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 11, "c:\auto_regi\tmp\cofi\tub\tubenet.dbf", "c:\auto_regi\tmp\cofi\tub\tub_tpnot.ntx" )

else

@ 10,0 say "Modo --date nao usado..."
@ 11,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\tub\tub_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\tub\tub_tpnot.ntx","tp_not" )
close

delimita_data1 ( 12, "c:\auto_regi\tmp\cofi\tub\tubenet.dbf", "c:\auto_regi\tmp\cofi\tub\tub_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 13, "c:\auto_regi\tmp\cofi\tub\tubenet.dbf", "c:\auto_regi\tmp\cofi\tub\tub_tpnot.ntx" )

endif

@ 14,0 say "Copiando a estrutura do arquivo tubenet.dbf, campo hiv..."
use "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
aFields := { "nu_notific","tp_not","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","hiv" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\tub\str_tubenet_hiv.dbf", aFields)
close

cria_campos( 15, "Criando mais campos dentro do arquivo str_tubenet_hiv.dbf...", "c:\auto_regi\tmp\cofi\tub\str_tubenet_hiv", "c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf" )

@ 16,0 say "Copiando a estrutura do arquivo tubenet.dbf, campo cultura_es..."
use "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
aFields := { "nu_notific","tp_not","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","cultura_es" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\tub\str_tubenet_cult.dbf", aFields)
close

cria_campos( 17, "Criando mais campos dentro do arquivo str_tubenet_cult.dbf...", "c:\auto_regi\tmp\cofi\tub\str_tubenet_cult", "c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf" )

@ 18,0 say "Copiando a estrutura do arquivo tubenet.dbf, campo teste sensibilidade..."
use "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
aFields := { "nu_notific","tp_not","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","test_sensi" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\tub\str_tubenet_test.dbf", aFields)
close

cria_campos( 19, "Criando mais campos dentro do arquivo str_tubenet_test.dbf...", "c:\auto_regi\tmp\cofi\tub\str_tubenet_test", "c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf" )

@ 20,0 say "Copiando a estrutura do arquivo tubenet.dbf, campos cont.ident/cont. exam..."
use "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
aFields := { "nu_notific","tp_not","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","nu_contato","nu_comu_ex" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\tub\str_tubenet_ident_exam.dbf", aFields)
close

cria_campos( 21, "Criando mais campos dentro do arquivo str_tubenet_ident_exam.dbf...", "c:\auto_regi\tmp\cofi\tub\str_tubenet_ident_exam", "c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf" )

//@ 22,0 say "Copiando a estrutura do arquivo tubenet.dbf, campo contatos examinados..."
//use "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
//aFields := { "nu_notific","tp_not","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","nu_comu_ex" }
//__dbCopyStruct("c:\auto_regi\tmp\cofi\tub\str_tubenet_exam.dbf", aFields)
//close

//cria_campos( 23, "Criando mais campos dentro do arquivo str_tubenet_exam.dbf...", "c:\auto_regi\tmp\cofi\tub\str_tubenet_exam", "c:\auto_regi\tmp\cofi\tub\light_tubenet_exam.dbf" )

@ 22,0 say "Copiando a estrutura do arquivo tubenet.dbf, campo situacao encerra..."
use "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
aFields := { "nu_notific","tp_not","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","situa_ence" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\tub\str_tubenet_situacao.dbf", aFields)
close

cria_campos( 23, "Criando mais campos dentro do arquivo str_tubenet_situacao.dbf...", "c:\auto_regi\tmp\cofi\tub\str_tubenet_situacao", "c:\auto_regi\tmp\cofi\tub\light_tubenet_situacao.dbf" )

@ 24,0 say "Enviando os registros para os arquivos da serie light..."

use "c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf"
append from "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
@ 25,0 say "Light_tubenet_hiv..."
@ 25,20 say "ok" color "g+"
close

use "c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf"
append from "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
@ 26,0 say "Light_tubenet_cult..."
@ 26,21 say "ok" color "g+"
close

use "c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf"
append from "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
@ 27,0 say "Light_tubenet_test..."
@ 27,21 say "ok" color "g+"
close

use "c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf"
append from "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
@ 28,0 say "Light_tubenet_id_exam..."
@ 28,24 say "ok" color "g+"
close

//use "c:\auto_regi\tmp\cofi\tub\light_tubenet_exam.dbf"
//append from "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
//@ 31,0 say "Light_tubenet_exam..."
//@ 31,21 say "ok" color "g+"
//close

use "c:\auto_regi\tmp\cofi\tub\light_tubenet_situacao.dbf"
append from "c:\auto_regi\tmp\cofi\tub\tubenet.dbf"
@ 29,0 say "Light_tubenet_situacao..."
@ 29,25 say "ok" color "g+"
close

@ 30,0 say "Procurando inconsistencia no arquivo light_tubenet_hiv.dbf, parte 1..."
use "c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( hiv ) = .T. )
replace tp_not with "H"
endif

if hiv = "4"
replace tp_not with "H"
endif

if hiv = "3"
replace tp_not with "H"
endif

skip
nCounter++
@ 30,70 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 30,70 say "100%" color "g+"

pack
close

@ 31,0 say "Procurando inconsistencia no arquivo light_tubenet_hiv.dbf, parte 2..."
use "c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "H"
dbDelete()
endif

skip
nCounter++
@ 31,70 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 31,70 say "100%" color "g+"

pack
close

@ 32,0 say "Preenchendo os campos criados pelo programa..."
munic_not(33,"c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf")
regi_not(34,"c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf")
munic_res(35,"c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf")
regi_res(36,"c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf")

use "c:\auto_regi\tmp\cofi\tub\light_tubenet_hiv.dbf"

do while .not. eof()

if hiv = "4"
replace decod with "nao realizado"
endif

if hiv = "3"
replace decod with "em andamento"
endif

skip

enddo
close

@ 37,0 say "Procurando inconsistencia no arquivo light_tubenet_cult.dbf, parte 1..."
use "c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( cultura_es ) = .T. )
replace tp_not with "C"
endif

if cultura_es = "4"
replace tp_not with "C"
endif

if cultura_es = "3"
replace tp_not with "C"
endif

skip
nCounter++
@ 37,70 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 37,70 say "100%" color "g+"

pack
close

@ 38,0 say "Procurando inconsistencia no arquivo light_tubenet_cult.dbf, parte 2..."
use "c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "C"
dbDelete()
endif

skip
nCounter++
@ 38,71 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 38,71 say "100%" color "g+"

pack
close

@ 39,0 say "Preenchendo os campos criados pelo programa..."
munic_not(40,"c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf")
regi_not(41,"c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf")
munic_res(42,"c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf")
regi_res(43,"c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf")

use "c:\auto_regi\tmp\cofi\tub\light_tubenet_cult.dbf"

do while .not. eof()

if cultura_es = "4"
replace decod with "nao realizado"
endif

if cultura_es = "3"
replace decod with "em andamento"
endif

skip

enddo
close

@ 44,0 say "Procurando inconsistencia no arquivo light_tubenet_test.dbf, parte 1..."
use "c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( test_sensi ) = .T. )
replace tp_not with "T"
endif

if test_sensi = "6"
replace tp_not with "T"
endif

if test_sensi = "7"
replace tp_not with "T"
endif

skip
nCounter++
@ 44,71 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 44,71 say "100%" color "g+"

pack
close

@ 45,0 say "Procurando inconsistencia no arquivo light_tubenet_test.dbf, parte 2..."
use "c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "T"
dbDelete()
endif

skip
nCounter++
@ 45,71 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 45,71 say "100%" color "g+"

pack
close

@ 46,0 say "Preenchendo os campos criados pelo programa..."
munic_not(47,"c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf")
regi_not(48,"c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf")
munic_res(49,"c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf")
regi_res(50,"c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf")

use "c:\auto_regi\tmp\cofi\tub\light_tubenet_test.dbf"

do while .not. eof()

if test_sensi = "7"
replace decod with "nao realizado"
endif

if test_sensi = "6"
replace decod with "em andamento"
endif

skip

enddo
close

@ 51,0 say "Procurando inconsistencia no arquivo light_tubenet_situacao.dbf, parte 1..."
use "c:\auto_regi\tmp\cofi\tub\light_tubenet_situacao.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( situa_ence ) = .T. )
replace tp_not with "S"
endif

skip
nCounter++
@ 51,75 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 51,75 say "100%" color "g+"

pack
close

@ 52,0 say "Procurando inconsistencia no arquivo light_tubenet_situacao.dbf, parte 2..."
use "c:\auto_regi\tmp\cofi\tub\light_tubenet_situacao.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "S"
dbDelete()
endif

skip
nCounter++
@ 52,75 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 52,75 say "100%" color "g+"

pack
close

@ 53,0 say "Preenchendo os campos criados pelo programa..."
munic_not(54,"c:\auto_regi\tmp\cofi\tub\light_tubenet_situacao.dbf")
regi_not(55,"c:\auto_regi\tmp\cofi\tub\light_tubenet_situacao.dbf")
munic_res(56,"c:\auto_regi\tmp\cofi\tub\light_tubenet_situacao.dbf")
regi_res(57,"c:\auto_regi\tmp\cofi\tub\light_tubenet_situacao.dbf")

@ 58,0 say "Limpando o campo 'tp_not' para novo processamento..."

use "c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf"

do while .not. eof()

replace tp_not with '' 

skip
enddo

close

@ 59,0 say "Procurando inconsistencia no arquivo light_tubenet_id_exam.dbf, parte 1..."
use "c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if nu_contato = 0 .and. nu_comu_ex = 0
replace tp_not with "Z"
endif

if nu_contato = 0 .and. nu_comu_ex > 0
replace tp_not with "X"
endif

if nu_contato > 0 .and. nu_comu_ex = 0
replace tp_not with "Y"
endif

skip
nCounter++
@ 59,74 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 59,74 say "100%" color "g+"

pack
close

@ 60,0 say "Procurando inconsistencia no arquivo light_tubenet_id_exam.dbf, parte 2..."
use "c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( tp_not ) ) = .T.
dbDelete()
endif

if tp_not = "Z"
dbDelete()
endif

skip
nCounter++
@ 60,74 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 60,74 say "100%" color "g+"

pack
close

@ 61,0 say "Preenchendo os campos criados pelo programa..."
munic_not(62,"c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf")
regi_not(63,"c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf")
munic_res(64,"c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf")
regi_res(65,"c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf")

use "c:\auto_regi\tmp\cofi\tub\light_tubenet_id_exam.dbf"

do while .not. eof()

if tp_not = "X"
replace inconsiste with "Numero de examinados maior que o numero de contatos."
endif

if tp_not = "Y"
replace inconsiste with "Nenhum contato examinado apesar de conter identificados."
endif

skip
enddo
close

no_keypress()

return

function do_deng()

set color to w+/b+
@ 7,0 say "Relatorio 6 - subpasta 'tmp/do_deng'."
set color to bg+/

unzip( 8, "Descompacta os arquivos de Dengue para cruzamento de dados...", "c:\auto_regi\tmp\do_deng\deng\*.zip", "c:\auto_regi\tmp\do_deng\deng\" )

fusao( 9, "Fusao dos arquivos de Dengue (se hover mais de um)...", "c:\auto_regi\tmp\do_deng\deng\*.dbf" )

copy file "c:\auto_regi\mod\dengon_model.dbf" to "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf"

use "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf"

for f = 1 to nArraySize2
append from ( "c:\auto_regi\tmp\do_deng\deng\" + aName2[f] )
next

close

if HB_Argv( 1 ) = "--list" .or. HB_Argv( 2 ) = "--list" .or. HB_Argv( 3 ) = "--list" .or. HB_Argv( 4 ) = "--list" .or. HB_Argv( 5 ) = "--list" .or. ;
HB_Argv( 6 ) = "--list" .or. HB_Argv( 7 ) = "--list" .or. HB_Argv( 8 ) = "--list"

list_mun( 10, "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf", "deng" )

endif

if cMode = "--date"

use "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\do_deng\deng\deng_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\do_deng\deng\deng_tpnot.ntx","tp_not" )
close

delimita_data1 ( 14, "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf", "c:\auto_regi\tmp\do_deng\deng\deng_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 15, "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf", "c:\auto_regi\tmp\do_deng\deng\deng_tpnot.ntx" )

else

@ 14,0 say "Modo --date nao usado..."
@ 15,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\do_deng\deng\deng_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\do_deng\deng\deng_tpnot.ntx","tp_not" )
close

delimita_data1 ( 16, "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf", "c:\auto_regi\tmp\do_deng\deng\deng_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 17, "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf", "c:\auto_regi\tmp\do_deng\deng\deng_tpnot.ntx" )

endif

unzip( 18, "Descompacta os arquivos de D.O. para cruzamento de dados...", "c:\auto_regi\tmp\do_deng\do\*.zip", "c:\auto_regi\tmp\do_deng\do\" )

fusao( 19, "Fusao dos arquivos de D.O. (se hover mais de um)...", "c:\auto_regi\tmp\do_deng\do\*.dbf" )

copy file "c:\auto_regi\mod\do_model.dbf" to "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

for f = 1 to nArraySize2
append from ( "c:\auto_regi\tmp\do_deng\do\" + aName2[f] )
next

close

if HB_Argv( 1 ) = "--list" .or. HB_Argv( 2 ) = "--list" .or. HB_Argv( 3 ) = "--list" .or. HB_Argv( 4 ) = "--list" .or. HB_Argv( 5 ) = "--list" .or. ;
HB_Argv( 6 ) = "--list" .or. HB_Argv( 7 ) = "--list" .or. HB_Argv( 8 ) = "--list"

list_mun( 20, "c:\auto_regi\tmp\do_deng\do\do_model.dbf", "do" )

endif

@ 24,0 say "Preenchendo a data do obito com 10 digitos no campo 'numsus'..."

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( dtobito ) = .F.

cDtObito := alltrim( dtobito )
cDay := left( cDtObito, 2 )
cMes := substr( cDtObito, 3, 2 )
cAno := substr( cDtObito, 5, 4 )
cNewDtObito := cDay + "/" + cMes + "/" + cAno

replace numsus with alltrim( cNewDtObito )

endif

skip

nCounter++
@ 24,63 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 24,63 say "100%" color "g+"

close

if cMode = "--date"

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\do_deng\do\do_data.ntx","numsus" ) // O campo numsus contem a data do obito com 10 digitos.
close

@ 25,0 say "Delimita o processamento dos registros em um periodo especifico. Parte 1..."
use "c:\auto_regi\tmp\do_deng\do\do_model.dbf" index "c:\auto_regi\tmp\do_deng\do\do_data.ntx"

goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ctod( numsus ) >= ctod( cDt_Ini ) .and. ctod( numsus ) <= ctod( cDt_Fin )
replace codcart with "D" // O campo codcart sera usado para marcar o periodo de tempo especificado.
endif

skip
nCounter++
@ 25,74 say alltrim(str(int( nPercent ))) + "%"  color "g+"

enddo

@ 25,74 say "100%" color "g+"

close

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\do_deng\do\do_codcart.ntx","codcart" )
close

@ 26,0 say "Delimita o processamento dos registros em um periodo especifico. Parte 2..."
use "c:\auto_regi\tmp\do_deng\do\do_model.dbf" index "c:\auto_regi\tmp\do_deng\do\do_codcart.ntx"

goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if codcart <> "D"
dbDelete()
endif

skip
nCounter++
@ 26,74 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 26,74 say "100%" color "g+"

pack
close

else

@ 27,0 say "Modo --date nao usado..."
@ 28,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\do_deng\do\do_data.ntx","numsus" ) // O campo numsus contem a data do obito com 10 digitos.
close

@ 29,0 say "Delimita o processamento dos registros em um periodo especifico. Parte 1..."
use "c:\auto_regi\tmp\do_deng\do\do_model.dbf" index "c:\auto_regi\tmp\do_deng\do\do_data.ntx"

goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ctod( numsus ) >= ctod( cDataInicial ) .and. ctod( numsus ) <= ctod( cDataFinal )
replace codcart with "D" // O campo codcart sera usado para marcar o periodo de tempo especificado.
endif

skip
nCounter++
@ 29,74 say alltrim(str(int( nPercent ))) + "%"  color "g+"

enddo

@ 29,74 say "100%" color "g+"

close

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\do_deng\do\do_codcart.ntx","codcart" )
close

@ 30,0 say "Delimita o processamento dos registros em um periodo especifico. Parte 2..."
use "c:\auto_regi\tmp\do_deng\do\do_model.dbf" index "c:\auto_regi\tmp\do_deng\do\do_codcart.ntx"

goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if codcart <> "D"
dbDelete()
endif

skip
nCounter++
@ 30,74 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 30,74 say "100%" color "g+"

pack
close

endif

@ 31,0 say "Limpa o campo 'codcart' para receber novos dados..."
use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

do while .not. eof()
replace codcart with ""
skip
enddo

close

@ 32,0 say "Procurando por obitos por Dengue..."

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if causabas = "A90"
replace codcart with "A90"
endif

skip
nCounter++
@ 32,36 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 32,36 say "100%" color "g+"

pack
close

@ 33,0 say "Excluindo do arquivo, obitos que nao sao Dengue..."

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if codcart <> "A90"
dbDelete()
endif

skip
nCounter++
@ 33,50 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 33,50 say "100%" color "g+"

pack
close

@ 34,0 say "Criando o codigo fonetico no campo nomepai..."

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

do while .not. eof()

nStringSize := len( nome )
nFirstSpace := at( " ", alltrim( nome ) )
cFirstName := substr( alltrim( nome ), 1, nFirstSpace - 1 )
nLastSpace := (rat( " ", alltrim( nome ) ) )
cLastName := substr( alltrim ( nome ), nLastSpace + 1, nStringSize )
cFonetica := alltrim( cFirstName ) + alltrim( cLastName )

replace nomepai with upper ( cFonetica ) // campo nomepai foi substituido por cFonetica.

skip
enddo
close

@ 35,0 say "Limpa o campo 'numsus' para receber novos dados..." // O campo 'numsus' agora contém a data de nascimento com 10 digitos.
use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

do while .not. eof()
replace numsus with ""
skip
enddo

close

@ 36,0 say "Criando o data nasc. com 10 digitos no campo 'numsus'..."

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

do while .not. eof()

if empty( dtnasc ) = .F.

cDtNasc := alltrim( dtnasc )
cDay := left( cDtNasc, 2 )
cMes := substr( cDtNasc, 3, 2 )
cAno := substr( cDtNasc, 5, 4 )
cNewDtNasc := cDay + "/" + cMes + "/" + cAno

replace numsus with alltrim( cNewDtNasc )

endif

skip
enddo
close

@ 37,0 say "Criando arrays para fazer a comparacao..."

      public aArray10 := {}
	  use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray10, { alltrim( numsus ), alltrim( nomepai )} ) // numsus -> dt_nasc / nomepai -> fonetica
	  //? aArray10[x,1] + "-----" + aArray10[x,2]
	  skip
	  NEXT
	  close

//use "c:\temp\dengon2023.dbf"
use "c:\auto_regi\tmp\do_deng\deng\dengon_model.dbf"
public aArray11 := {}
public nCounter := 0

do while .not. eof()

cValor1 := alltrim( dtoc( dt_nasc ) )
cValor2 := alltrim( fonetica_n )

nPlace := ascan( aArray10, {|x| x[1] == (cValor1) } )
nPlace2 := ascan( aArray10, {|x| x[2] == (cValor2) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }

if nPlace <> 0 .and. nPlace2 <> 0 .and. nPlace = nPlace2
nCounter++
AAdd ( aArray11, {cValor1, cValor2} )
endif

recover
erro = 1
end sequence

skip
enddo

close

@ 38,0 say "Procurando registros em comum na base de D.O. e na base de Dengue..."

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

do while .not. eof()

for y := 1 to nCounter

if ( alltrim( numsus ) = aArray11[y,1] ) .and. ( alltrim( nomepai )  = ( aArray11[y,2] ) )
replace codestcart with "X" // usando o campo codestcart para marcar as notificações com registros em comum.
endif

next

skip
enddo
close

@ 39,0 say "Finalizando arquivo de D.O. com registros que nao existem na base de Dengue."

use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"

do while .not. eof()

if codestcart = "X"
dbDelete()
endif

skip
enddo

pack

close

@ 40,0 say "Copiando a estrutura do arquivo 'do_model.dbf'..."
use "c:\auto_regi\tmp\do_deng\do\do_model.dbf"
aFields := { "numerodo","dtobito","nome","nomemae","dtnasc","codmunres" }
__dbCopyStruct("c:\auto_regi\tmp\do_deng\do\str_do.dbf", aFields)
close

@ 41,0 say "Criando campo dentro do arquivo str_do.dbf..."
use ( "c:\auto_regi\tmp\do_deng\do\str_do" ) new
aStruct := dbStruct( "c:\auto_regi\tmp\do_deng\do\str_do" )
aAdd( aStruct, { "munic_res", "C", 80, 0 } ) 
dbCreate( "c:\auto_regi\tmp\do_deng\do\light_do.dbf" , aStruct )
close

@ 42,0 say "Enviando registros para o arquivo 'light_do'..."
use "c:\auto_regi\tmp\do_deng\do\light_do.dbf"
append from "c:\auto_regi\tmp\do_deng\do\do_model.dbf"
close

@ 43,0 say "Preenchendo o campo 'munic_res'..."
	
use "c:\auto_regi\tmp\do_deng\do\light_do.dbf"

nVezes := 0
do while .not. eof()
erro = 0
cValor = alltrim( codmunres )

if empty(cValor) = .F.
nPlace := ascan( aArray1, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeMunRes := aArray1[nPlace,2]
recover
erro = 1
end sequence

if erro = 0 
replace munic_res with cCodeMunRes
endif
endif

skip
enddo

close

no_keypress()

return

function atend()

set color to w+/b+
@ 7,0 say "Relatorio 7 - subpasta 'tmp/atend' - arquivo 'antranet.dbf'."
set color to bg+/

@ 8,0 say "Copiando arquivo 'antranet.dbf' original..."

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
copy file "c:\auto_regi\dbf\antranet.dbf" to "c:\auto_regi\tmp\atend\antranet.dbf"
recover
erro = 1
end sequence

if file("c:\auto_regi\tmp\atend\antranet.dbf") = .T.
@ 9,0 say "Arquivo transferido..."
else
@ 9,0 say "Erro na transferencia do arquivo..."
wait "Fim do programa. Pressione qualquer tecla para continuar."
quit
endif

if cMode = "--date" // function delimita_data1 ( nLine, cFilex, cIndex, cDataInicial, cDataFinal )

use "c:\auto_regi\tmp\atend\antranet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\atend\antra_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\atend\antranet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\atend\antra_tpnot.ntx","tp_not" )
close

delimita_data1 ( 10, "c:\auto_regi\tmp\atend\antranet.dbf", "c:\auto_regi\tmp\atend\antra_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 11, "c:\auto_regi\tmp\atend\antranet.dbf", "c:\auto_regi\tmp\atend\antra_tpnot.ntx" )

else

@ 10,0 say "Modo --date nao usado..."
@ 11,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\atend\antranet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\atend\antra_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\atend\antranet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\atend\antra_tpnot.ntx","tp_not" )
close

delimita_data1 ( 12, "c:\auto_regi\tmp\atend\antranet.dbf", "c:\auto_regi\tmp\atend\antra_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 13, "c:\auto_regi\tmp\atend\antranet.dbf", "c:\auto_regi\tmp\atend\antra_tpnot.ntx" )

endif

@ 14,0 say "Procurando as notificacoes com data de encerramento em branco..."

use "c:\auto_regi\tmp\atend\antranet.dbf"
goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( dt_encerra ) = .F.
dbDelete()
endif

skip
nCounter++
@ 14,64 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 14,64 say "100%" color "g+"

pack
close

@ 15,0 say "Copiando a estrutura do arquivo 'antranet.dbf'..."
use "c:\auto_regi\tmp\atend\antranet.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","dt_encerra" }
__dbCopyStruct("c:\auto_regi\tmp\atend\str_antranet.dbf", aFields)
close

cria_campos( 16, "Criando mais campos dentro do arquivo str_antranet.dbf...", "c:\auto_regi\tmp\atend\str_antranet", "c:\auto_regi\tmp\atend\light_antranet.dbf" )

@ 17,0 say "Enviando registros inconsistentes para o arquivo 'light_antranet'..."
use "c:\auto_regi\tmp\atend\light_antranet.dbf"
append from "c:\auto_regi\tmp\atend\antranet.dbf"
close

@ 18,0 say "Preenchendo os campos criados pelo programa..."
munic_not(19,"c:\auto_regi\tmp\atend\light_antranet.dbf")
regi_not(20,"c:\auto_regi\tmp\atend\light_antranet.dbf")
munic_res(21,"c:\auto_regi\tmp\atend\light_antranet.dbf")
regi_res(22,"c:\auto_regi\tmp\atend\light_antranet.dbf")

no_keypress()

return

function no_keypress()

if HB_Argv( 1 ) = "--nokeypress" .or. HB_Argv( 2 ) = "--nokeypress" .or. HB_Argv( 3 ) = "--nokeypress" .or. HB_Argv( 4 ) = "--nokeypress"
? ""
? "Opcao --nokeypress ativa..."
cCommand := "timeout /T " + alltrim( nTime ) + " /nobreak"
__run( cCommand )
else
Wait "Pressione qualquer tecla para continuar..."
endif

return

function tube_do()

set color to w+/b+
@ 7,0 say "Relatorio 8 - subpasta 'tmp/tube_do'."
set color to bg+/

copy file "c:\auto_regi\dbf\tubenet.dbf" to "c:\auto_regi\tmp\tube_do\tubenet.dbf"

if cMode = "--date"

use "c:\auto_regi\tmp\tube_do\tubenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\tube_do\tube_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\tube_do\tubenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\tube_do\tube_tpnot.ntx","tp_not" )
close

delimita_data1 ( 8, "c:\auto_regi\tmp\tube_do\tubenet.dbf", "c:\auto_regi\tmp\tube_do\tube_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 9, "c:\auto_regi\tmp\tube_do\tubenet.dbf", "c:\auto_regi\tmp\tube_do\tube_tpnot.ntx" )

else

@ 8,0 say "Modo --date nao usado..."
@ 9,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\tube_do\tubenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\tube_do\tube_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\tube_do\tubenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\tube_do\tube_tpnot.ntx","tp_not" )
close

delimita_data1 ( 10, "c:\auto_regi\tmp\tube_do\tubenet.dbf", "c:\auto_regi\tmp\tube_do\tube_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 11, "c:\auto_regi\tmp\tube_do\tubenet.dbf", "c:\auto_regi\tmp\tube_do\tube_tpnot.ntx" )

endif

unzip( 12, "Descompacta os arquivos de D.O. para cruzamento de dados...", "c:\auto_regi\tmp\tube_do\*.zip", "c:\auto_regi\tmp\tube_do\" )

fusao( 13, "Fusao dos arquivos de D.O. (se hover mais de um)...", "c:\auto_regi\tmp\tube_do\*.dbf" )

copy file "c:\auto_regi\mod\do_model.dbf" to "c:\auto_regi\tmp\tube_do\do_model.dbf"

use "c:\auto_regi\tmp\tube_do\do_model.dbf"

for f = 1 to nArraySize2
//append from ( "c:\auto_regi\tmp\do_deng\do\" + aName2[f] )
append from ( "c:\auto_regi\tmp\tube_do\" + aName2[f] )
next

close

if HB_Argv( 1 ) = "--list" .or. HB_Argv( 2 ) = "--list" .or. HB_Argv( 3 ) = "--list" .or. HB_Argv( 4 ) = "--list" .or. HB_Argv( 5 ) = "--list" .or. ;
HB_Argv( 6 ) = "--list" .or. HB_Argv( 7 ) = "--list" .or. HB_Argv( 8 ) = "--list"

list_mun( 14, "c:\auto_regi\tmp\tube_do\do_model.dbf", "do" )

endif

@ 18,0 say "Preenchendo a data do obito com 10 digitos no campo 'numsus'..."

use "c:\auto_regi\tmp\tube_do\do_model.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( dtobito ) = .F.

cDtObito := alltrim( dtobito )
cDay := left( cDtObito, 2 )
cMes := substr( cDtObito, 3, 2 )
cAno := substr( cDtObito, 5, 4 )
cNewDtObito := cDay + "/" + cMes + "/" + cAno

replace numsus with alltrim( cNewDtObito )

endif

skip

nCounter++
@ 18,63 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 18,63 say "100%" color "g+"

close

if cMode = "--date"

use "c:\auto_regi\tmp\tube_do\do_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\tube_do\do_data.ntx","numsus" ) // O campo numsus contem a data do obito com 10 digitos.
close

@ 19,0 say "Delimita o processamento dos registros em um periodo especifico. Parte 1..."
use "c:\auto_regi\tmp\tube_do\do_model.dbf" index "c:\auto_regi\tmp\tube_do\do_data.ntx"

goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ctod( numsus ) >= ctod( cDt_Ini ) .and. ctod( numsus ) <= ctod( cDt_Fin )
replace codcart with "D" // O campo codcart sera usado para marcar o periodo de tempo especificado.
endif

skip
nCounter++
@ 19,74 say alltrim(str(int( nPercent ))) + "%"  color "g+"

enddo

@ 19,74 say "100%" color "g+"

close

use "c:\auto_regi\tmp\tube_do\do_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\tube_do\do_codcart.ntx","codcart" )
close

@ 20,0 say "Delimita o processamento dos registros em um periodo especifico. Parte 2..."
use "c:\auto_regi\tmp\tube_do\do_model.dbf" index "c:\auto_regi\tmp\tube_do\do_codcart.ntx"

goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if codcart <> "D"
dbDelete()
endif

skip
nCounter++
@ 20,74 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 20,74 say "100%" color "g+"

pack
close

else

@ 21,0 say "Modo --date nao usado..."
@ 22,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\tube_do\do_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\tube_do\do_data.ntx","numsus" ) // O campo numsus contem a data do obito com 10 digitos.
close

@ 23,0 say "Delimita o processamento dos registros em um periodo especifico. Parte 1..."
use "c:\auto_regi\tmp\tube_do\do_model.dbf" index "c:\auto_regi\tmp\tube_do\do_data.ntx"

goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ctod( numsus ) >= ctod( cDataInicial ) .and. ctod( numsus ) <= ctod( cDataFinal )
replace codcart with "D" // O campo codcart sera usado para marcar o periodo de tempo especificado.
endif

skip
nCounter++
@ 23,74 say alltrim(str(int( nPercent ))) + "%"  color "g+"

enddo

@ 23,74 say "100%" color "g+"

close

use "c:\auto_regi\tmp\tube_do\do_model.dbf"
dbCreateIndex( "c:\auto_regi\tmp\tube_do\do_codcart.ntx","codcart" )
close

@ 24,0 say "Delimita o processamento dos registros em um periodo especifico. Parte 2..."
use "c:\auto_regi\tmp\tube_do\do_model.dbf" index "c:\auto_regi\tmp\tube_do\do_codcart.ntx"

goto top
nCounter := 1
nMarked := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if codcart <> "D"
dbDelete()
endif

skip
nCounter++
@ 24,74 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 24,74 say "100%" color "g+"

pack
close

endif

@ 25,0 say "Limpa o campo 'codcart' para receber novos dados..."
use "c:\auto_regi\tmp\tube_do\do_model.dbf"

do while .not. eof()
replace codcart with ""
skip
enddo

close

@ 26,0 say "Procurando por obitos por Tuberculose..."

use "c:\auto_regi\tmp\tube_do\do_model.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if causabas = "A169"
replace codcart with "A169"
endif

skip
nCounter++
@ 26,40 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 26,40 say "100%" color "g+"

pack
close

@ 27,0 say "Excluindo do arquivo, obitos que nao sao Tuberculose..."

use "c:\auto_regi\tmp\tube_do\do_model.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if codcart <> "A169"
dbDelete()
endif

skip
nCounter++
@ 27,55 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 27,55 say "100%" color "g+"

pack
close

@ 28,0 say "Criando o codigo fonetico no campo 'nomepai'..."

use "c:\auto_regi\tmp\tube_do\do_model.dbf"

do while .not. eof()

nStringSize := len( nome )
nFirstSpace := at( " ", alltrim( nome ) )
cFirstName := substr( alltrim( nome ), 1, nFirstSpace - 1 )
nLastSpace := (rat( " ", alltrim( nome ) ) )
cLastName := substr( alltrim ( nome ), nLastSpace + 1, nStringSize )
cFonetica := alltrim( cFirstName ) + alltrim( cLastName )

replace nomepai with upper ( cFonetica ) // campo nomepai foi substituido por cFonetica.

skip
enddo
close

@ 29,0 say "Limpa o campo 'numsus' para receber novos dados..." // O campo 'numsus' agora contém a data de nascimento com 10 digitos.
use "c:\auto_regi\tmp\tube_do\do_model.dbf"

do while .not. eof()
replace numsus with ""
skip
enddo

close

@ 30,0 say "Criando o data nasc. com 10 digitos no campo 'numsus'..."

use "c:\auto_regi\tmp\tube_do\do_model.dbf"

do while .not. eof()

if empty( dtnasc ) = .F.

cDtNasc := alltrim( dtnasc )
cDay := left( cDtNasc, 2 )
cMes := substr( cDtNasc, 3, 2 )
cAno := substr( cDtNasc, 5, 4 )
cNewDtNasc := cDay + "/" + cMes + "/" + cAno

replace numsus with alltrim( cNewDtNasc )

endif

skip
enddo
close

@ 31,0 say "Criando arrays para fazer a comparacao..."

      public aArray10 := {}
	  use "c:\auto_regi\tmp\tube_do\do_model.dbf"
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray10, { alltrim( numsus ), alltrim( nomepai )} ) // numsus -> dt_nasc / nomepai -> fonetica
	  //? aArray10[x,1] + "-----" + aArray10[x,2]
	  skip
	  NEXT
	  close

//use "c:\temp\dengon2023.dbf"
use "c:\auto_regi\tmp\tube_do\tubenet.dbf"
public aArray11 := {}
public nCounter := 0

do while .not. eof()

cValor1 := alltrim( dtoc( dt_nasc ) )
cValor2 := alltrim( fonetica_n )

nPlace := ascan( aArray10, {|x| x[1] == (cValor1) } )
nPlace2 := ascan( aArray10, {|x| x[2] == (cValor2) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }

if nPlace <> 0 .and. nPlace2 <> 0 .and. nPlace = nPlace2
nCounter++
AAdd ( aArray11, {cValor1, cValor2} )
endif

recover
erro = 1
end sequence

skip
enddo

close

@ 32,0 say "Procurando registros em comum na base de D.O. e na base de Tuberculose..."

use "c:\auto_regi\tmp\tube_do\do_model.dbf"

do while .not. eof()

for y := 1 to nCounter

if ( alltrim( numsus ) = aArray11[y,1] ) .and. ( alltrim( nomepai )  = ( aArray11[y,2] ) )
replace codestcart with "X" // usando o campo codestcart para marcar as notificações com registros em comum.
endif

next

skip
enddo
close

@ 33,0 say "Finalizando arquivo de D.O. com registros que nao existem na base de Tuberculose."

use "c:\auto_regi\tmp\tube_do\do_model.dbf"

do while .not. eof()

if codestcart = "X"
dbDelete()
endif

skip
enddo

pack

close

@ 34,0 say "Copiando a estrutura do arquivo 'do_model.dbf'..."
use "c:\auto_regi\tmp\tube_do\do_model.dbf"
aFields := { "numerodo","dtobito","nome","nomemae","dtnasc","codmunres" }
__dbCopyStruct("c:\auto_regi\tmp\tube_do\str_do.dbf", aFields)
close

@ 35,0 say "Criando campo dentro do arquivo str_do.dbf..."
use ( "c:\auto_regi\tmp\tube_do\str_do" ) new
aStruct := dbStruct( "c:\auto_regi\tmp\tube_do\str_do" )
aAdd( aStruct, { "munic_res", "C", 80, 0 } ) 
dbCreate( "c:\auto_regi\tmp\tube_do\light_do.dbf" , aStruct )
close

@ 36,0 say "Enviando registros para o arquivo 'light_do'..."
use "c:\auto_regi\tmp\tube_do\light_do.dbf"
append from "c:\auto_regi\tmp\tube_do\do_model.dbf"
close

@ 37,0 say "Preenchendo o campo 'munic_res'..."
	
use "c:\auto_regi\tmp\tube_do\light_do.dbf"

nVezes := 0
do while .not. eof()
erro = 0
cValor = alltrim( codmunres )

if empty(cValor) = .F.
nPlace := ascan( aArray1, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeMunRes := aArray1[nPlace,2]
recover
erro = 1
end sequence

if erro = 0 
replace munic_res with cCodeMunRes
endif
endif

skip
enddo

close

no_keypress()

return

function hansnet()

set color to w+/b+
@ 7,0 say "Relatorio 9 - projeto de cofinanciamento - subpasta 'cofi/hans'."
set color to bg+/
@ 8,0 say "Copiando arquivo hansnet.dbf original..."

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
copy file "c:\auto_regi\dbf\hansnet.dbf" to "c:\auto_regi\tmp\cofi\hans\hansnet.dbf"
recover
erro = 1
end sequence

if file("c:\auto_regi\tmp\cofi\hans\hansnet.dbf") = .T.
@ 9,0 say "Arquivo transferido..."
else
@ 9,0 say "Erro na transferencia do arquivo..."
wait "Fim do programa. Pressione qualquer tecla para continuar."
quit
endif

@ 10,0 say "Trocando o tipo de alguns campos antes do processamento..."
__run( "c:\auto_regi\exe\hexed -e 840 43 4f 4e 54 52 45 47 00 00 00 00 43 - c:\auto_regi\tmp\cofi\hans\hansnet.dbf" )
__run( "c:\auto_regi\exe\hexed -e ac0 43 4f 4e 54 45 58 41 4d 00 00 00 43 - c:\auto_regi\tmp\cofi\hans\hansnet.dbf" )

if cMode = "--date" // function delimita_data1 ( nLine, cFilex, cIndex, cDataInicial, cDataFinal )

use "c:\auto_regi\tmp\cofi\hans\hansnet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\hans\hans_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cofi\hans\hansnet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\hans\hans_tpnot.ntx","tp_not" )
close

delimita_data1 ( 11, "c:\auto_regi\tmp\cofi\hans\hansnet.dbf", "c:\auto_regi\tmp\cofi\hans\hans_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 12, "c:\auto_regi\tmp\cofi\hans\hansnet.dbf", "c:\auto_regi\tmp\cofi\hans\hans_tpnot.ntx" )

else

@ 11,0 say "Modo --date nao usado..."
@ 12,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\cofi\hans\hansnet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\hans\hans_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cofi\hans\hansnet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\hans\hans_tpnot.ntx","tp_not" )
close

delimita_data1 ( 13, "c:\auto_regi\tmp\cofi\hans\hansnet.dbf", "c:\auto_regi\tmp\cofi\hans\hans_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 14, "c:\auto_regi\tmp\cofi\hans\hansnet.dbf", "c:\auto_regi\tmp\cofi\hans\hans_tpnot.ntx" )

endif

@ 15,0 say "Copiando a estrutura do arquivo hansnet.dbf, campos cont.regs./cont.exam..."
use "c:\auto_regi\tmp\cofi\hans\hansnet.dbf"
aFields := { "nu_notific","tp_not","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","contreg","contexam" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\hans\str_hansnet_regi_exam.dbf", aFields)
close

cria_campos( 16, "Criando mais campos dentro do arquivo str_hansnet_ident_exam.dbf...", "c:\auto_regi\tmp\cofi\hans\str_hansnet_regi_exam", "c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf" )

@ 17,0 say "Enviando os registros para o arquivo 'light_hansnet_reg_exam'..."

use "c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf"
append from "c:\auto_regi\tmp\cofi\hans\hansnet.dbf"
@ 18,0 say "Light_hansnet_reg_exam.dbf..."
@ 18,29 say "ok" color "g+"
close

@ 19,0 say "Copiando a estrutura do arquivo hansnet.dbf, campo tpalta_n..."
use "c:\auto_regi\tmp\cofi\hans\hansnet.dbf"
aFields := { "nu_notific","tp_not","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","tpalta_n" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\hans\str_hansnet_saida.dbf", aFields)
close

cria_campos( 20, "Criando mais campos dentro do arquivo str_hansnet_saida.dbf...", "c:\auto_regi\tmp\cofi\hans\str_hansnet_saida", "c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf" )

@ 21,0 say "Enviando os registros para o arquivo 'light_hansnet_saida'..."

use "c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf"
append from "c:\auto_regi\tmp\cofi\hans\hansnet.dbf"
@ 22,0 say "Light_hansnet_saida.dbf..."
@ 22,26 say "ok" color "g+"
close

@ 23,0 say "Limpando o campo 'tp_not' para novo processamento..."

use "c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf"

do while .not. eof()

replace tp_not with ''

skip
enddo

close

@ 24,0 say "Procurando inconsistencia no arquivo light_hansnet_reg_exam.dbf, parte 1..."
use "c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( contreg ) = .T.
replace tp_not with "E"
endif

if empty( contexam ) = .T.
replace tp_not with "E"
endif

if val( contreg ) = 0 .and. val( contexam ) = 0
replace tp_not with "Z"
endif

if val( contreg ) = 0 .and. val( contexam ) > 0
replace tp_not with "X"
endif

if val( contreg ) > 0 .and. val( contexam ) = 0
replace tp_not with "Y"
endif

skip
nCounter++
@ 24,75 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 24,75 say "100%" color "g+"

pack
close

@ 25,0 say "Procurando inconsistencia no arquivo light_hansnet_reg_exam.dbf, parte 2..."
use "c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if ( empty( tp_not ) ) = .T.
dbDelete()
endif

skip
nCounter++
@ 25,74 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 25,74 say "100%" color "g+"

pack
close

@ 26,0 say "Preenchendo os campos criados pelo programa..."
munic_not(27,"c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf")
regi_not(28,"c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf")
munic_res(29,"c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf")
regi_res(30,"c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf")

use "c:\auto_regi\tmp\cofi\hans\light_hansnet_reg_exam.dbf"

do while .not. eof()

if tp_not = "X"
replace inconsiste with "Numero de examinados maior que o numero de registrados."
endif

if tp_not = "Y"
replace inconsiste with "Nenhum contato examinado apesar de conter registrados."
endif

skip
enddo
close

@ 31,0 say "Limpando o campo 'tp_not' para novo processamento..."

use "c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf"

do while .not. eof()

replace tp_not with ''

skip
enddo

close

@ 32,0 say "Procurando inconsistencia no arquivo light_hansnet_saida.dbf, parte 1..."
use "c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( tpalta_n ) = .T.
replace tp_not with "E"
endif

skip
nCounter++
@ 32,75 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 32,75 say "100%" color "g+"

pack
close

@ 33,0 say "Procurando inconsistencia no arquivo light_hansnet_saida.dbf, parte 2..."
use "c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "E"
dbDelete()
endif

skip
nCounter++
@ 33,74 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 33,74 say "100%" color "g+"

pack
close

@ 34,0 say "Preenchendo os campos criados pelo programa..."
munic_not(35,"c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf")
regi_not(36,"c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf")
munic_res(37,"c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf")
regi_res(38,"c:\auto_regi\tmp\cofi\hans\light_hansnet_saida.dbf")

no_keypress()

return

function list_mun( nLine, cFilex, cTipo )

@ nLine,0 say "Carregando os municipios da opcao '--list' para o array..."

copy file "c:\auto_regi\mod\list_muns.dbf" to "c:\auto_regi\set\list_muns.dbf"

use "c:\auto_regi\set\list_muns.dbf"
zap
append from "c:\auto_regi\set\list_muns.txt" delimited with '"'
close

	  public aArray_mun_list := {}
	  use "c:\auto_regi\set\list_muns.dbf"
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray_mun_list, {alltrim(cod_munres)} )
	  skip
	  NEXT
	  close

nArraySize := len( aArray_mun_list )
for n := 1 to nArraySize 	
use "c:\auto_regi\dbf\municnet.dbf"	  
locate for id_municip = aArray_mun_list[n,1]
if found() = .T.
cId := id_municip
cNm := nm_municip
use "c:\auto_regi\set\list_muns.dbf"
replace munic_name with cNm for cod_munres = cId
endif

next

close

if cTipo = "deng" .or. cTipo = "chik"

nLine++
@ nLine,0 say "Limpando o campo 'tp_not' para processamento..."
use ( cFilex )
do while .not. eof()
replace tp_not with ""
skip
enddo
close

nLine++
@ nLine,0 say "Procurando os municipios que estao na lista dentro do arquivo..."
use ( cFilex )

nVezes := 0

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )
erro = 0
cValor = alltrim(id_mn_resi)

if empty(cValor) = .F.
nPlace := ascan( aArray_mun_list, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeMunRes := aArray_mun_list[nPlace,1]
recover
erro = 1
end sequence

if erro = 0 
replace tp_not with "X"
endif
endif

skip
nCounter++
@ nLine,64 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ nLine,64 say "100%" color "g+"

close

nLine++
@ nLine,0 say "Excluindo do arquivo os municipios que nao estao na lista..."

use ( cFilex )

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "X"
dbDelete()
endif

skip
nCounter++
@ nLine,60 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ nLine,60 say "100%" color "g+"

pack
close

endif

if cTipo = "srag"

nLine++
@ nLine,0 say "Limpando o campo 'co_pais' para processamento..."
use ( cFilex )
do while .not. eof()
replace co_pais with ""
skip
enddo
close

nLine++
@ nLine,0 say "Procurando os municipios que estao na lista dentro do arquivo..."
use ( cFilex )

nVezes := 0

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )
erro = 0
cValor = alltrim( co_mun_res )

if empty(cValor) = .F.
nPlace := ascan( aArray_mun_list, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeMunRes := aArray_mun_list[nPlace,1]
recover
erro = 1
end sequence

if erro = 0 
replace co_pais with "X"
endif
endif

skip
nCounter++
@ nLine,64 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ nLine,64 say "100%" color "g+"

close

nLine++
@ nLine,0 say "Excluindo do arquivo os municipios que nao estao na lista..."

use ( cFilex )

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if co_pais <> "X"
dbDelete()
endif

skip
nCounter++
@ nLine,60 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ nLine,60 say "100%" color "g+"

pack
close

endif

if cTipo = "esus"

	  public aArray_mun_list2 := {}
	  use "c:\auto_regi\set\list_muns.dbf"
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray_mun_list2, {alltrim( munic_name )} )
	  skip
	  NEXT
	  close

nLine++
@ nLine,0 say "Limpando o campo 'idade' para processamento..."
use ( cFilex )
do while .not. eof()
replace idade with ""
skip
enddo
close

nLine++
@ nLine,0 say "Procurando os municipios que estao na lista dentro do arquivo..."
use ( cFilex )

nVezes := 0

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )
erro = 0
cValor = alltrim( munic_res )

if empty(cValor) = .F.
nPlace := ascan( aArray_mun_list2, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeMunRes := aArray_mun_list2[nPlace,1]
recover
erro = 1
end sequence

if erro = 0 
replace idade with "X"
endif
endif

skip
nCounter++
@ nLine,64 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ nLine,64 say "100%" color "g+"

close

nLine++
@ nLine,0 say "Excluindo do arquivo os municipios que nao estao na lista..."

use ( cFilex )

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if idade <> "X"
dbDelete()
endif

skip
nCounter++
@ nLine,60 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ nLine,60 say "100%" color "g+"

pack
close

endif

if cTipo = "do"

nLine++
@ nLine,0 say "Limpando o campo 'codcart' para processamento..."
use ( cFilex )
do while .not. eof()
replace codcart with ""
skip
enddo
close

nLine++
@ nLine,0 say "Procurando os municipios que estao na lista dentro do arquivo..."
use ( cFilex )

nVezes := 0

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )
erro = 0
cValor = alltrim( codmunres )

if empty(cValor) = .F.
nPlace := ascan( aArray_mun_list, {|x| x[1] == (cValor) } )

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
cCodeMunRes := aArray_mun_list[nPlace,1]
recover
erro = 1
end sequence

if erro = 0 
replace codcart with "X"
endif
endif

skip
nCounter++
@ nLine,64 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ nLine,64 say "100%" color "g+"

close

nLine++
@ nLine,0 say "Excluindo do arquivo os municipios que nao estao na lista..."

use ( cFilex )

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if codcart <> "X"
dbDelete()
endif

skip
nCounter++
@ nLine,60 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ nLine,60 say "100%" color "g+"

pack
close

endif

return

function srag()

set color to w+/b+
@ 7,0 say "Relatorio 10 - projeto de cofinanciamento - subpasta 'cofi/srag'."
set color to bg+/

unzip( 8, "Descompacta os arquivos zip originais de SRAG...", "c:\auto_regi\tmp\cofi\srag\*.zip", "c:\auto_regi\tmp\cofi\srag\" )

fusao( 9, "Fusao dos arquivos de SRAG (se hover mais de um)...", "c:\auto_regi\tmp\cofi\srag\*.dbf" )

copy file "c:\auto_regi\mod\srag_model.dbf" to "c:\auto_regi\tmp\cofi\srag\srag_model.dbf"

use "c:\auto_regi\tmp\cofi\srag\srag_model.dbf"

for f = 1 to nArraySize2
append from ( "c:\auto_regi\tmp\cofi\srag\" + aName2[f] )
next

close

if HB_Argv( 1 ) = "--list" .or. HB_Argv( 2 ) = "--list" .or. HB_Argv( 3 ) = "--list" .or. HB_Argv( 4 ) = "--list" .or. HB_Argv( 5 ) = "--list" .or. ;
HB_Argv( 6 ) = "--list" .or. HB_Argv( 7 ) = "--list" .or. HB_Argv( 8 ) = "--list"

list_mun( 10, "c:\auto_regi\tmp\cofi\srag\srag_model.dbf", "srag" )

endif

@ 14,0 say "Limpando o campo 'co_pais' para processamento..."
use "c:\auto_regi\tmp\cofi\srag\srag_model.dbf"
do while .not. eof()
replace co_pais with ""
skip
enddo
close

@ 15,0 say "Copiando a estrutura do arquivo 'srag_model.dbf'..."
use "c:\auto_regi\tmp\cofi\srag\srag_model.dbf"
aFields := { "nu_notific","dt_notific","nm_pacient","id_regiona","id_municip","id_rg_resi","id_mn_resi","co_pais","classi_fin","evolucao","pcr_resul" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\srag\str_srag.dbf", aFields)
close

cria_campos( 16, "Criando mais campos dentro do arquivo str_srag.dbf...", "c:\auto_regi\tmp\cofi\srag\str_srag", "c:\auto_regi\tmp\cofi\srag\light_srag.dbf" )

@ 17,0 say "Enviando os registros para o arquivo 'light_srag.dbf'..."
use "c:\auto_regi\tmp\cofi\srag\light_srag.dbf"
append from "c:\auto_regi\tmp\cofi\srag\srag_model.dbf"
@ 18,0 say "Arquivo 'light_srag.dbf'..."
@ 18,27 say "ok" color "g+"
close

@ 19,0 say "Convertendo o campo 'dt_notific' para o campo 'dt_notifi2'..."
use "c:\auto_regi\tmp\cofi\srag\light_srag.dbf"

nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

replace dt_notifi2 with ctod( dt_notific )

skip
nCounter++
@ 19,61 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 19,61 say "100%" color "g+"

if cMode = "--date" // function delimita_data1 ( nLine, cFilex, cIndex, cDataInicial, cDataFinal )

use "c:\auto_regi\tmp\cofi\srag\light_srag.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\srag\srag_data.ntx","dt_notifi2" )
close

use "c:\auto_regi\tmp\cofi\srag\light_srag.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\srag\srag_co_pais.ntx","co_pais" )
close

delimita_data1 ( 20, "c:\auto_regi\tmp\cofi\srag\light_srag.dbf", "c:\auto_regi\tmp\cofi\srag\srag_data.ntx", ( cDt_Ini ), ( cDt_Fin ), "srag" )
delimita_data2 ( 21, "c:\auto_regi\tmp\cofi\srag\light_srag.dbf", "c:\auto_regi\tmp\cofi\srag\srag_co_pais.ntx", "srag" )

else

@ 20,0 say "Modo --date nao usado..."
@ 21,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\cofi\srag\light_srag.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\srag\srag_data.ntx","dt_notifi2" )
close

use "c:\auto_regi\tmp\cofi\srag\light_srag.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\srag\srag_co_pais.ntx","co_pais" )
close

delimita_data1 ( 22, "c:\auto_regi\tmp\cofi\srag\light_srag.dbf", "c:\auto_regi\tmp\cofi\srag\srag_data.ntx", ( cDataInicial ), ( cDataFinal ), "srag" )
delimita_data2 ( 23, "c:\auto_regi\tmp\cofi\srag\light_srag.dbf", "c:\auto_regi\tmp\cofi\srag\srag_co_pais.ntx", "srag" )

endif

@ 24,0 say "Limpando o campo 'co_pais' para processamento..."
use "c:\auto_regi\tmp\cofi\srag\light_srag.dbf"
do while .not. eof()
replace co_pais with ""
skip
enddo
close

@ 25,0 say "Fazendo multiplas copias do arquivo apos o filtro..."
copy file "c:\auto_regi\tmp\cofi\srag\light_srag.dbf" to "c:\auto_regi\tmp\cofi\srag\light_class_srag.dbf"
copy file "c:\auto_regi\tmp\cofi\srag\light_srag.dbf" to "c:\auto_regi\tmp\cofi\srag\light_evolucao_srag.dbf"
copy file "c:\auto_regi\tmp\cofi\srag\light_srag.dbf" to "c:\auto_regi\tmp\cofi\srag\light_resultado_srag.dbf"

@ 26,0 say "Procurando por inconsistencia no arquivo 'light_class_srag.dbf'..."
use "c:\auto_regi\tmp\cofi\srag\light_class_srag.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty ( classi_fin ) = .T.
replace co_pais with "E"
endif

skip
nCounter++
@ 26,66 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 26,66 say "100%" color "g+"

close

@ 27,0 say "Deixando no arquivo 'light_class_srag.dbf' apenas registros inconsistentes..."
use "c:\auto_regi\tmp\cofi\srag\light_class_srag.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if co_pais <> "E"
dbDelete()
endif

skip
nCounter++
@ 27,77 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 27,77 say "100%" color "g+"

pack
close

@ 28,0 say "Procurando por inconsistencia no arquivo 'light_evolucao_srag.dbf'..."
use "c:\auto_regi\tmp\cofi\srag\light_evolucao_srag.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty ( evolucao ) = .T.
replace co_pais with "E"
endif

if evolucao = "9"
replace co_pais with "E"
endif

skip
nCounter++
@ 28,69 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 28,69 say "100%" color "g+"

close

@ 29,0 say "Deixando no arquivo 'light_evolucao_srag.dbf' apenas registros inconsistentes..."
use "c:\auto_regi\tmp\cofi\srag\light_evolucao_srag.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if co_pais <> "E"
dbDelete()
endif

skip
nCounter++
@ 29,80 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 29,80 say "100%" color "g+"

pack
close

@ 30,0 say "Procurando por inconsistencia no arquivo 'light_resultado_srag.dbf'..."
use "c:\auto_regi\tmp\cofi\srag\light_resultado_srag.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty ( pcr_resul ) = .T.
replace co_pais with "E"
endif

if pcr_resul = "9"
replace co_pais with "E"
endif

if pcr_resul = "5" // Aguardando resultado.
replace co_pais with "E"
endif

skip
nCounter++
@ 30,70 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 30,70 say "100%" color "g+"

close

@ 31,0 say "Deixando no arquivo 'light_resultado_srag.dbf' apenas registros inconsistentes..."
use "c:\auto_regi\tmp\cofi\srag\light_resultado_srag.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()
nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if co_pais <> "E"
dbDelete()
endif

skip
nCounter++
@ 31,81 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 31,81 say "100%" color "g+"

pack
close

no_keypress()

return

function esus()

set color to w+/b+
@ 7,0 say "Relatorio 11 - subpasta 'esus' "
set color to bg+/
nError_rel11 := 0

nTotal := ADir ( "c:\auto_regi\tmp\esus\*.csv" )

if nTotal <> 1
nError_rel11 := 1
@ 8,0 say "Erro!" color "r+"
@ 9,0 say "Somente podera haver um arquivo CSV nesse diretorio."
@ 10,0 say "Nao sera possivel continuar o processamento desse relatorio."
else
@ 8,0 say "Quantidade de arquivos...ok"
endif

@ 9,0 say "Renomeando arquivo csv..."
if nError_rel11 = 0
aFile_Name := Array( 1 )
ADir( "c:\auto_regi\tmp\esus\*.csv", aFile_Name )
cOrigem := "c:\auto_regi\tmp\esus\" + aFile_Name[1]
@ 10,0 say "Arquivo csv: "
@ 10,13 say alltrim( cOrigem ) color "w+"
rename ( cOrigem ) to "c:\auto_regi\tmp\esus\esus_ve_notifica.csv"

@ 11,0 say "Aguarde!" color "r+"
@ 11,9 say "Formatando o arquivo csv de UNIX para DOS..."
__run("c:\auto_regi\exe\flip.exe -d c:\auto_regi\tmp\esus\esus_ve_notifica.csv")

@ 12,0 say "Cria o arquivo dbf para receber os dados do arquivo csv."
cMolde1 := ( "c:\auto_regi\tmp\esus\molde1.dbf" )
cMolde2 := ( "c:\auto_regi\tmp\esus\molde2.dbf" )
cMolde3 := ( "c:\auto_regi\tmp\esus\molde3.dbf" )
cMolde4 := ( "c:\auto_regi\tmp\esus\molde4.dbf" )
	
aStruct := { { "nu_notific","C",22,0 }, ; //1
			 { "uf_notific","C",27,0 }, ; //2
			 { "munic_not","C",35,0 }, ; //3
			 { "telefone1", "C", 25, 0 }, ; //4
			 { "uf_res", "C", 27, 0 }, ; //5
			 { "sexo", "C", 15, 0 }, ; //6
			 { "tem_cpf", "C", 10, 0 }, ; //7
			 { "estrang", "C", 10, 0 }, ; //8
			 { "cpf", "C", 20, 0 }, ; //9
			 { "munic_res", "C", 35, 0 }} //10
			 dbcreate (( cMolde1 ),aStruct )

use ( cMolde1 )
copy to ( cMolde2 )

* Acrescenta campos novos.
				use ( cMolde2 ) new
				aStruct2 := dbStruct( cMolde2 )
				AADD(aStruct2, { "cns", "C", 20, 0 }) //11
				AADD(aStruct2, { "dt_nasc", "D", 10, 0 }) //12
				AADD(aStruct2, { "passaporte", "C", 20, 0 }) //13
				AADD(aStruct2, { "nome_mae", "C", 70, 0 }) //14
				AADD(aStruct2, { "pais", "C", 15, 0 }) //15
				AADD(aStruct2, { "telefone2", "C", 15, 0 }) //16
				AADD(aStruct2, { "nm_pacient", "C", 70, 0 }) //17
				AADD(aStruct2, { "profsaude", "C", 5, 0 })	//18
				AADD(aStruct2, { "cbo", "C", 50, 0 }) //19
				AADD(aStruct2, { "cep", "C", 10, 0 }) //20
				
				AADD(aStruct2, { "logradouro", "C", 50, 0 }) //21
				AADD(aStruct2, { "numero", "C", 10, 0 }) //22
				AADD(aStruct2, { "complement", "C", 40, 0 }) //23
				AADD(aStruct2, { "bairro", "C", 30, 0 }) //24
				AADD(aStruct2, { "raca_cor", "C", 8, 0 }) //25
				AADD(aStruct2, { "prof_seg", "C", 5, 0 }) //26
				AADD(aStruct2, { "etnia", "C", 20, 0 })	//27				
				AADD(aStruct2, { "email", "C", 40, 0 }) //28
				AADD(aStruct2, { "comunidade", "C", 5, 0 }) //29
				AADD(aStruct2, { "id_comunid", "C", 37, 0 }) //30
				
				AADD(aStruct2, { "escolarid", "C", 40, 0 }) //31
				AADD(aStruct2, { "nome_soci", "C", 70, 0 }) //32
				AADD(aStruct2, { "pais_res", "C", 35, 0 }) //33
				AADD(aStruct2, { "idade", "C", 5, 0 }) //34
				AADD(aStruct2, { "zona", "C", 10, 0 }) //35
				AADD(aStruct2, { "estrateg", "C", 45, 0 }) //36
				AADD(aStruct2, { "triagem", "C", 50, 0 }) //37
				AADD(aStruct2, { "desc_assin", "C", 50, 0 }) //38
				AADD(aStruct2, { "desc_triag", "C", 50, 0 }) //39				
				AADD(aStruct2, { "busca_ativ", "C", 50, 0 }) //40
				
				AADD(aStruct2, { "local_test", "C", 50, 0 }) //41
				AADD(aStruct2, { "desc_local", "C", 50, 0 }) //42								
				AADD(aStruct2, { "sintomas", "C", 120, 0 })	//43
				AADD(aStruct2, { "dt_notific", "D", 10, 0 }) //44
				AADD(aStruct2, { "desc_sint", "C", 50, 0 }) //45
				AADD(aStruct2, { "dt_sintom", "D", 10, 0 }) //46
				AADD(aStruct2, { "descricao", "C", 50, 0 }) //47
				AADD(aStruct2, { "condicoes", "C", 65, 0 }) //48
				AADD(aStruct2, { "vacina", "C", 5, 0 }) //49			
				AADD(aStruct2, { "doses", "C", 50, 0 })	//50
								
				AADD(aStruct2, { "dt_dose1", "D", 10, 0 }) //51
				AADD(aStruct2, { "dt_dose2", "D", 10, 0 }) //52				
				AADD(aStruct2, { "dt_refor", "D", 10, 0 }) //53
				AADD(aStruct2, { "dt_refor2", "D", 10, 0 }) //54
				AADD(aStruct2, { "lab_prod1", "C", 30, 0 }) //55
				AADD(aStruct2, { "lab_prod2", "C", 30, 0 }) //56
				AADD(aStruct2, { "lab_refor1", "C", 30, 0 }) //57
				AADD(aStruct2, { "lab_refor2", "C", 30, 0 }) //58
				AADD(aStruct2, { "lote_ds1", "C", 20, 0 }) //59			
				AADD(aStruct2, { "lote_ds2", "C", 20, 0 }) //60
				
				AADD(aStruct2, { "lote_refor", "C", 20, 0 }) //61
				AADD(aStruct2, { "lote_refo2", "C", 20, 0 }) //62				
				AADD(aStruct2, { "trat_covid", "C", 5, 0 }) //63
				AADD(aStruct2, { "antiviral", "C", 30, 0 }) //64
				AADD(aStruct2, { "out_antiv", "C", 30, 0 }) //65
				AADD(aStruct2, { "dt_trat", "D", 10, 0 }) //66
				AADD(aStruct2, { "est_rtpcr", "C", 20, 0 }) //67
				AADD(aStruct2, { "dt_rtpcr", "D", 10, 0 }) //68
				AADD(aStruct2, { "res_rtpcr", "C", 20, 0 }) //69
				AADD(aStruct2, { "est_lamp", "C", 20, 0 }) //70
				
				AADD(aStruct2, { "dt_lamp", "D", 10, 0 }) //71
				AADD(aStruct2, { "res_lamp", "C", 20, 0 }) //72				
				AADD(aStruct2, { "est_iga", "C", 20, 0 }) //73
				AADD(aStruct2, { "dt_iga", "D", 10, 0 }) //74
				AADD(aStruct2, { "res_iga", "C", 20, 0 }) //75
				AADD(aStruct2, { "est_igm", "C", 20, 0 }) //76
				AADD(aStruct2, { "dt_igm", "D", 10, 0 }) //77
				AADD(aStruct2, { "res_igm", "C", 20, 0 }) //78
				AADD(aStruct2, { "est_igg", "C", 20, 0 }) //79				
				AADD(aStruct2, { "dt_igg", "D", 10, 0 }) //80
				
				AADD(aStruct2, { "res_igg", "C", 20, 0 }) //81
				AADD(aStruct2, { "est_antic", "C", 20, 0 }) //82
				AADD(aStruct2, { "dt_antic", "D", 10, 0 }) //83
				AADD(aStruct2, { "res_antic", "C", 20, 0 }) //84
				AADD(aStruct2, { "est_a_igm", "C", 20, 0 }) //85
				AADD(aStruct2, { "dt_a_igm", "D", 10, 0 }) //86
				AADD(aStruct2, { "res_a_igm", "C", 20, 0 }) //87
				AADD(aStruct2, { "est_a_igg", "C", 20, 0 }) //88
				AADD(aStruct2, { "dt_a_igg", "D", 10, 0 }) //89			
				AADD(aStruct2, { "res_a_igg", "C", 20, 0 }) //90
				
				AADD(aStruct2, { "est_rap_an", "C", 20, 0 }) //91
				AADD(aStruct2, { "dt_rap_ant", "D", 10, 0 }) //92				
				AADD(aStruct2, { "res_rap_an", "C", 20, 0 }) //93
				AADD(aStruct2, { "lote_antig", "C", 20, 0 }) //94
				AADD(aStruct2, { "fab_antige", "C", 45, 0 }) //95
				AADD(aStruct2, { "est_tes_o1", "C", 30, 0 }) //96
				AADD(aStruct2, { "tip_tes_o1", "C", 40, 0 }) //97
				AADD(aStruct2, { "dt_outro1", "D", 10, 0 }) //98
				AADD(aStruct2, { "res_outro1", "C", 35, 0 }) //99
				AADD(aStruct2, { "lote_out1", "C", 20, 0 }) //100
				
				AADD(aStruct2, { "fab_outro1", "C", 45, 0 }) //101
				AADD(aStruct2, { "tip_tes_o2", "C", 40, 0 }) //102
				AADD(aStruct2, { "est_tes_o2", "C", 30, 0 }) //103
				AADD(aStruct2, { "dt_outro2", "D", 10, 0 }) //104
				AADD(aStruct2, { "res_outro2", "C", 35, 0 }) //105
				AADD(aStruct2, { "lote_out2", "C", 20, 0 }) //106
				AADD(aStruct2, { "fab_outro2", "C", 45, 0 }) //107
				AADD(aStruct2, { "tip_tes_o3", "C", 40, 0 }) //108
				AADD(aStruct2, { "est_tes_o3", "C", 30, 0 }) //109				
				AADD(aStruct2, { "dt_outro3", "D", 10, 0 }) //110
				
				AADD(aStruct2, { "res_outro3", "C", 35, 0 }) //111
				AADD(aStruct2, { "lote_out3", "C", 20, 0 }) //112				
				AADD(aStruct2, { "fab_outro3", "C", 45, 0 }) //113
				AADD(aStruct2, { "evolucao", "C", 35, 0 }) //114
				AADD(aStruct2, { "class_fin", "C", 35, 0 }) //115
				AADD(aStruct2, { "dt_encerra", "D", 10, 0 }) //116
				AADD(aStruct2, { "cnes_lab", "C", 25, 0 }) //117
				AADD(aStruct2, { "cnes_not", "C", 25, 0 }) //118
				AADD(aStruct2, { "notif_cpf", "C", 30, 0 }) //119
				AADD(aStruct2, { "not_email", "C", 40, 0 }) //120
				
				AADD(aStruct2, { "notif_nome", "C", 70, 0 }) //121
				AADD(aStruct2, { "notif_cnpj", "C", 35, 0 }) //122
				
				dbCreate( (cMolde3 ) , aStruct2 )
close ( cMolde1 )

rename (cMolde3) to (cMolde4)

@ 13,0 say "Transferindo os dados do arquivo CSV para o DBF..."

cMolde5 := ( "c:\auto_regi\tmp\esus\molde4.dbf" )
cFuse := ( "c:\auto_regi\tmp\esus\esus_ve_notifica.csv" )

hElements := { => } // Constroi uma hash table vazia.

hb_fuse (cFuse)
use ( cMolde5 )
nTotalLines := ( HB_FLastRec() - 1 ) // Total de linhas no arquivo menos a linha do cabeçalho.
HB_FGoTop()
HB_FGoTo(2)
nVezes := 0

nCounter := 1
nTotalRecs := nTotalLines

for loopX = 1 to nTotalLines+1

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

cString := alltrim(hb_freadln())
nTotalStringSize := len(cString)

* Fraciona a variavel cString em diversas substrings e as armazena em uma hash table.
* Primeira string antes do primeiro caracter ";".
nPos1 := hb_at ( ";", (cString) )
cSubString1 := substr ( (cString),1 ,(nPos1-1) )
hElements[ 1 ] := ( cSubString1 )

nPosX := nPos1
for n = 1 to 123
nPosY :=  hb_at ( ";", (cString), (nPosX+1) )
cSubStringY :=  substr ( (cString),(nPosX+1),(nPosY)-(nPosX+1) )
hElements[ n+1 ] := ( cSubStringY )

nPosX := nPosY
endfor

* Ultima string depois do caracter ";".
nLastPos := hb_RAt ( ";", (cString) )
cLastSubString := substr ( (cString), (nLastPos+1),(nTotalStringSize)-(nLastPos) )
hElements[ 123 ] := ( cLastSubString )

* Transfere os valores armazenados na hash table para o arquivo dbf.
append blank
replace nu_notific with upper ( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 1 ) ) ) )
replace uf_notific with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 2 ) ) ) )
replace munic_not with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 3 ) ) ) )
replace telefone1 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 4 ) ) ) )
replace uf_res with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 5 ) ) ) )
replace sexo with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 6 ) ) ) )
replace tem_cpf with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 7 ) ) ) )
replace estrang with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 8 ) ) ) )
replace cpf with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 9 ) ) ) )
replace munic_res with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 10 ) ) ) )

replace cns with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 11 ) ) ) )
replace dt_nasc with ctod( ( HB_HGET( hElements, 12 ) ) )
replace passaporte with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 13 ) ) ) )
replace nome_mae with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 14 ) ) ) )
replace pais with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 15 ) ) ) )
replace telefone2 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 16 ) ) ) )
replace nm_pacient with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 17 ) ) ) )
replace profsaude with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 18 ) ) ) )
replace cbo with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 19 ) ) ) )
replace cep with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 20 ) ) ) )

replace logradouro with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 21 ) ) ) )
replace numero with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 22 ) ) ) )
replace complement with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 23 ) ) ) )
replace bairro with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 24 ) ) ) )
replace raca_cor with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 25 ) ) ) )
replace prof_seg with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 26 ) ) ) )
replace etnia with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 27 ) ) ) )
replace email with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 28 ) ) ) )
replace comunidade with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 29 ) ) ) )
replace id_comunid with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 30 ) ) ) )

replace escolarid with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 31 ) ) ) )
replace nome_soci with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 32 ) ) ) )
replace pais_res with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 33 ) ) ) )
replace idade with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 34 ) ) ) )
replace zona with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 35 ) ) ) )
replace estrateg with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 36 ) ) ) )
replace triagem with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 37 ) ) ) )
replace desc_assin with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 38 ) ) ) )
replace desc_triag with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 39 ) ) ) )
replace busca_ativ with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 40 ) ) ) )

replace local_test with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 41 ) ) ) )
replace desc_local with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 42 ) ) ) )
replace sintomas with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 43 ) ) ) )
replace dt_notific with ctod( ( HB_HGET( hElements, 44 ) ) )
replace desc_sint with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 45 ) ) ) )
replace dt_sintom with ctod( ( HB_HGET( hElements, 46 ) ) )
replace descricao with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 47 ) ) ) )
replace condicoes with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 48 ) ) ) )
replace vacina with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 49 ) ) ) )
replace doses with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 50 ) ) ) )

replace dt_dose1 with ctod( ( HB_HGET( hElements, 51 ) ) )
replace dt_dose2 with ctod( ( HB_HGET( hElements, 52 ) ) )
replace dt_refor with ctod( ( HB_HGET( hElements, 53 ) ) )
replace dt_refor2 with ctod( ( HB_HGET( hElements, 54 ) ) )
replace lab_prod1 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 55 ) ) ) )
replace lab_prod2 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 56 ) ) ) )
replace lab_refor1 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 57 ) ) ) )
replace lab_refor2 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 58 ) ) ) )
replace lote_ds1 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 59 ) ) ) )
replace lote_ds2 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 60 ) ) ) )

replace lote_refor with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 61 ) ) ) )
replace lote_refo2 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 62 ) ) ) )
replace trat_covid with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 63 ) ) ) )
replace antiviral with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 64 ) ) ) )
replace out_antiv with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 65 ) ) ) )
replace dt_trat with ctod( ( HB_HGET( hElements, 66 ) ) )
replace est_rtpcr with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 67 ) ) ) )
replace dt_rtpcr with ctod( ( HB_HGET( hElements, 68 ) ) )
replace res_rtpcr with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 69 ) ) ) )
replace est_lamp with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 70 ) ) ) )

replace dt_lamp with ctod( ( HB_HGET( hElements, 71 ) ) )
replace res_lamp with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 72 ) ) ) )
replace est_iga with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 73 ) ) ) )
replace dt_iga with ctod( ( HB_HGET( hElements, 74 ) ) )
replace res_iga with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 75 ) ) ) )
replace est_igm with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 76 ) ) ) )
replace dt_igm with ctod( ( HB_HGET( hElements, 77 ) ) )
replace res_igm with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 78 ) ) ) )
replace est_igg with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 79 ) ) ) )
replace dt_igg with ctod( ( HB_HGET( hElements, 80 ) ) )

replace res_igg with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 81 ) ) ) )
replace est_antic with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 82 ) ) ) )
replace dt_antic with ctod( ( HB_HGET( hElements, 83 ) ) )
replace res_antic with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 84 ) ) ) )
replace est_a_igm with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 85 ) ) ) )
replace dt_a_igm with ctod( ( HB_HGET( hElements, 86 ) ) )
replace res_a_igm with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 87 ) ) ) )
replace est_a_igg with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 88 ) ) ) )
replace dt_a_igg with ctod( ( HB_HGET( hElements, 89 ) ) )
replace res_a_igg with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 90 ) ) ) )

replace est_rap_an with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 91 ) ) ) )
replace dt_rap_ant with ctod( ( HB_HGET( hElements, 92 ) ) )
replace res_rap_an with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 93 ) ) ) )
replace lote_antig with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 94 ) ) ) )
replace fab_antige with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 95 ) ) ) )
replace est_tes_o1 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 96 ) ) ) )
replace tip_tes_o1 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 97 ) ) ) )
replace dt_outro1 with ctod( ( HB_HGET( hElements, 98 ) ) )
replace res_outro1 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 99 ) ) ) )
replace lote_out1 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 100 ) ) ) )

replace fab_outro1 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 101 ) ) ) )
replace tip_tes_o2 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 102 ) ) ) )
replace est_tes_o2 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 103 ) ) ) )
replace dt_outro2 with ctod( ( HB_HGET( hElements, 104 ) ) )
replace res_outro2 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 105 ) ) ) )
replace lote_out2 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 106 ) ) ) )
replace fab_outro2 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 107 ) ) ) )
replace tip_tes_o3 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 108 ) ) ) )
replace est_tes_o3 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 109 ) ) ) )
replace dt_outro3 with ctod( ( HB_HGET( hElements, 110 ) ) )

replace res_outro3 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 111 ) ) ) )
replace lote_out3 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 112 ) ) ) )
replace fab_outro3 with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 113 ) ) ) )
replace evolucao with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 114 ) ) ) )
replace class_fin with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 115 ) ) ) )
replace dt_encerra with ctod( ( HB_HGET( hElements, 116 ) ) )
replace cnes_lab with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 117 ) ) ) )
replace cnes_not with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 118 ) ) ) )
replace notif_cpf with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 119 ) ) ) )
replace not_email with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 120 ) ) ) )

replace notif_nome with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 121 ) ) ) )
replace notif_cnpj with upper( remacent("",hb_UTF8ToStr( HB_HGET( hElements, 123 ) ) ) )

HB_FSkip()

nCounter++
@ 13,50 say alltrim(str(int( nPercent ))) + "%" color "g+"

endfor

@ 13,50 say "100%" color "g+"

hb_fuse()

close

list_mun( 14, "c:\auto_regi\tmp\esus\molde4.dbf", "esus" )

@ 18,0 say "Copiando a estrutura do arquivo 'molde4.dbf'..."
use "c:\auto_regi\tmp\esus\molde4.dbf"
aFields := { "nu_notific","nm_pacient","dt_nasc","munic_not","munic_res","evolucao" }
__dbCopyStruct("c:\auto_regi\tmp\esus\str_esus.dbf", aFields)
close

@ 19,0 say "Criando novo arquivo dbf com os campos selecionados..."
use ( "c:\auto_regi\tmp\esus\str_esus" ) new
aStruct := dbStruct( "c:\auto_regi\tmp\esus\str_esus" )
aAdd( aStruct, { "controle", "C", 1, 0 } ) 
dbCreate( "c:\auto_regi\tmp\esus\light_esus_evolucao.dbf" , aStruct )
close

@ 20,0 say "Enviando registros para o arquivo 'light_esus_evolucao'..."
use "c:\auto_regi\tmp\esus\light_esus_evolucao.dbf"
append from "c:\auto_regi\tmp\esus\molde4.dbf"
close

@ 21,0 say "Procurando por inconsistencia nos campo evolucao..."
use "c:\auto_regi\tmp\esus\light_esus_evolucao.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty ( evolucao ) = .T.
replace controle with "X"
endif

if evolucao = alltrim("INTERNADO")
replace controle with "X"
endif

if evolucao = alltrim("INTERNADO EM UTI")
replace controle with "X"
endif

if evolucao = alltrim("OBITO")
replace controle with "X"
endif

skip
nCounter++
@ 21,52 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 21,52 say "100%" color "g+"

close

@ 22,0 say "Deixando no arquivo dbf apenas os registros inconsistentes..."

use "c:\auto_regi\tmp\esus\light_esus_evolucao.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if controle <> "X"
dbDelete()
endif

skip
nCounter++
@ 22,61 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 22,61 say "100%" color "g+"

pack

close

endif

no_keypress()

return

function sifgenet()

set color to w+/b+
@ 7,0 say "Relatorio 12 - projeto de cofinanciamento - subpasta 'cofi/sif'."
set color to bg+/
@ 8,0 say "Copiando arquivo sifgenet.dbf original..."

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
copy file "c:\auto_regi\dbf\sifgenet.dbf" to "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
recover
erro = 1
end sequence

if file("c:\auto_regi\tmp\cofi\sif\sifgenet.dbf") = .T.
@ 9,0 say "Arquivo transferido..."
else
@ 9,0 say "Erro na transferencia do arquivo..."
wait "Fim do programa. Pressione qualquer tecla para continuar."
quit
endif

if cMode = "--date" // function delimita_data1 ( nLine, cFilex, cIndex, cDataInicial, cDataFinal )

use "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\sif\sif_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\sif\sif_tpnot.ntx","tp_not" )
close

delimita_data1 ( 10, "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf", "c:\auto_regi\tmp\cofi\sif\sif_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 11, "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf", "c:\auto_regi\tmp\cofi\sif\sif_tpnot.ntx" )

else

@ 10,0 say "Modo --date nao usado..."
@ 11,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\sif\sif_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\sif\sif_tpnot.ntx","tp_not" )
close

delimita_data1 ( 12, "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf", "c:\auto_regi\tmp\cofi\sif\sif_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 13, "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf", "c:\auto_regi\tmp\cofi\sif\sif_tpnot.ntx" )

endif

@ 14,0 say "Limpando o campo 'tp_not' para novo processamento..."
use "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
do while .not. eof()
replace tp_not with ""
skip
enddo
close

@ 15,0 say "Copiando a estrutura do arquivo 'sifgenet.dbf'..."
use "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","tpesquema","tp_not" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\sif\str_sif.dbf", aFields)
close

@ 16,0 say "Criando novo arquivo dbf com os campos selecionados..."
use ( "c:\auto_regi\tmp\cofi\sif\str_sif" ) new
aStruct := dbStruct( "c:\auto_regi\tmp\cofi\sif\str_sif" )
dbCreate( "c:\auto_regi\tmp\cofi\sif\light_sif_esquema.dbf" , aStruct )
close

@ 17,0 say "Enviando registros para o arquivo 'light_sif_esquema.dbf'..."
use "c:\auto_regi\tmp\cofi\sif\light_sif_esquema.dbf"
append from "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
close

@ 18,0 say "Copiando a estrutura do arquivo 'sifgenet.dbf'..."
use "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","cs_gestant","tp_not" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\sif\str_sif.dbf", aFields)
close

@ 19,0 say "Criando novo arquivo dbf com os campos selecionados..."
use ( "c:\auto_regi\tmp\cofi\sif\str_sif" ) new
aStruct := dbStruct( "c:\auto_regi\tmp\cofi\sif\str_sif" )
dbCreate( "c:\auto_regi\tmp\cofi\sif\light_sif_gestante.dbf" , aStruct )
close

@ 20,0 say "Enviando registros para o arquivo 'light_sif_gestante.dbf'..."
use "c:\auto_regi\tmp\cofi\sif\light_sif_gestante.dbf"
append from "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
close

@ 21,0 say "Copiando a estrutura do arquivo 'sifgenet.dbf'..."
use "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
aFields := { "nu_notific","id_agravo","dt_notific","nm_pacient","id_municip","id_regiona","id_mn_resi","id_rg_resi","tpevidenci","tp_not" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\sif\str_sif.dbf", aFields)
close

@ 22,0 say "Criando novo arquivo dbf com os campos selecionados..."
use ( "c:\auto_regi\tmp\cofi\sif\str_sif" ) new
aStruct := dbStruct( "c:\auto_regi\tmp\cofi\sif\str_sif" )
dbCreate( "c:\auto_regi\tmp\cofi\sif\light_sif_class.dbf" , aStruct )
close

@ 23,0 say "Enviando registros para o arquivo 'light_sif_class.dbf'..."
use "c:\auto_regi\tmp\cofi\sif\light_sif_class.dbf"
append from "c:\auto_regi\tmp\cofi\sif\sifgenet.dbf"
close

@ 24,0 say "Procurando por inconsistencia nos campo 'cs_gestant'..."
use "c:\auto_regi\tmp\cofi\sif\light_sif_gestante.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( cs_gestant ) = .T.
replace tp_not with "X"
endif

if cs_gestant = "9"
replace tp_not with "X"
endif

skip
nCounter++
@ 24,55 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 24,55 say "100%" color "g+"

close

@ 25,0 say "Deixando no arquivo dbf apenas os registros inconsistentes..."

use "c:\auto_regi\tmp\cofi\sif\light_sif_gestante.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "X"
dbDelete()
endif

skip
nCounter++
@ 25,61 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 25,61 say "100%" color "g+"

pack

close

@ 26,0 say "Procurando por inconsistencia nos campo 'tpesquema'..."
use "c:\auto_regi\tmp\cofi\sif\light_sif_esquema.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( tpesquema ) = .T.
replace tp_not with "X"
endif

if tpesquema = "9"
replace tp_not with "X"
endif

skip
nCounter++
@ 26,55 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 26,55 say "100%" color "g+"

close

@ 27,0 say "Deixando no arquivo dbf apenas os registros inconsistentes..."

use "c:\auto_regi\tmp\cofi\sif\light_sif_esquema.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "X"
dbDelete()
endif

skip
nCounter++
@ 27,61 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 27,61 say "100%" color "g+"

pack

close

@ 28,0 say "Procurando por inconsistencia nos campo 'tpevidenci'..."
use "c:\auto_regi\tmp\cofi\sif\light_sif_class.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( tpevidenci ) = .T.
replace tp_not with "X"
endif

if tpevidenci = "9"
replace tp_not with "X"
endif

skip
nCounter++
@ 28,55 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 28,55 say "100%" color "g+"

close

@ 29,0 say "Deixando no arquivo dbf apenas os registros inconsistentes..."

use "c:\auto_regi\tmp\cofi\sif\light_sif_class.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not <> "X"
dbDelete()
endif

skip
nCounter++
@ 29,61 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 29,61 say "100%" color "g+"

pack

close

no_keypress()

return

function tmp_cleanning()

set color to bg+/
? "Limpando o conteudo das subpastas do diretorio 'tmp'." // Exclui apenas arquivos dbf e ntx.
? ""

__run( "echo off & del /F /Q c:\auto_regi\tmp\atend\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\atend\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\cerest\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\cerest\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\deng\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\deng\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\hans\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\hans\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\sif\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\sif\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\srag\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\srag\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\tub\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\tub\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\surto\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\cofi\surto\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\dnci\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\dnci\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\dnci\chik\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\dnci\chik\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\dnci\deng\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\dnci\deng\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\do_deng\deng\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\do_deng\deng\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\do_deng\do\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\do_deng\do\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\esus\*.dbf" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\tube_do\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\tube_do\*.ntx" )

__run( "echo off & del /F /Q c:\auto_regi\tmp\vio\*.dbf" )
__run( "echo off & del /F /Q c:\auto_regi\tmp\vio\*.ntx" )

? "Limpando o conteudo das subpastas do diretorio 'rel'."
? ""

__run( "del /F /Q c:\auto_regi\rel\rel1\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel2\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel3\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel4\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel5\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel6\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel7\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel8\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel9\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel10\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel11\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel12\*.dbf" )
__run( "del /F /Q c:\auto_regi\rel\rel13\*.dbf" )

if ( cCleanning = "true" )
quit
endif

no_keypress()

return

function nsurtnet()

set color to w+/b+
@ 7,0 say "Relatorio 13 - projeto de cofinanciamento - subpasta 'cofi/surto'."
set color to bg+/
@ 8,0 say "Copiando arquivo nsurtnet.dbf original..."

begin sequence WITH {| oError | oError:cargo := { ProcName( 1 ), ProcLine( 1 ) }, Break( oError ) }
copy file "c:\auto_regi\dbf\nsurtnet.dbf" to "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
recover
erro = 1
end sequence

if file("c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf") = .T.
@ 9,0 say "Arquivo transferido..."
else
@ 9,0 say "Erro na transferencia do arquivo..."
wait "Fim do programa. Pressione qualquer tecla para continuar."
quit
endif

@ 10,0 say "Limpando o campo 'tp_not' para processamento..."
use "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
do while .not. eof()
replace tp_not with ""
skip
enddo
close

if cMode = "--date" // function delimita_data1 ( nLine, cFilex, cIndex, cDataInicial, cDataFinal )

use "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\surto\surto_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\surto\surto_tpnot.ntx","tp_not" )
close

delimita_data1 ( 11, "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf", "c:\auto_regi\tmp\cofi\surto\surto_data.ntx", ( cDt_Ini ), ( cDt_Fin ) )
delimita_data2 ( 12, "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf", "c:\auto_regi\tmp\cofi\surto\surto_tpnot.ntx" )

else

@ 11,0 say "Modo --date nao usado..."
@ 12,0 say "Modo --date nao usado..."

endif

if cMode <> "--date" .and. cSimNao = "S" // cDataInicial, cDataFinal

use "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\surto\surto_data.ntx","dt_notific" )
close

use "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
dbCreateIndex( "c:\auto_regi\tmp\cofi\surto\surto_tpnot.ntx","tp_not" )
close

delimita_data1 ( 13, "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf", "c:\auto_regi\tmp\cofi\surto\surto_data.ntx", ( cDataInicial ), ( cDataFinal ) )
delimita_data2 ( 14, "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf", "c:\auto_regi\tmp\cofi\surto\surto_tpnot.ntx" )

endif

@ 15,0 say "Limpando o campo 'tp_not' para processamento..."
use "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
do while .not. eof()
replace tp_not with ""
skip
enddo
close

@ 16,0 say "Copiando a estrutura do arquivo nsurtnet.dbf, campo 'cs_local'..."
use "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
aFields := { "nu_notific","tp_not","dt_notific","id_municip","id_regiona","id_muni_re","id_rg_resi","cs_local" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\surto\str_surto_local.dbf", aFields)
close

cria_campos( 17, "Criando mais campos dentro do arquivo str_surto_local.dbf...", "c:\auto_regi\tmp\cofi\surto\str_surto_local", "c:\auto_regi\tmp\cofi\surto\light_surto_local.dbf" )

@ 18,0 say "Enviando os registros para o arquivo 'light_surto_local'..."

use "c:\auto_regi\tmp\cofi\surto\light_surto_local.dbf"
append from "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
@ 19,0 say "Light_surto_local.dbf..."
@ 19,24 say "ok" color "g+"
close

@ 20,0 say "Copiando a estrutura do arquivo nsurtnet.dbf, campo 'qt_total_c'..."
use "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
aFields := { "nu_notific","tp_not","dt_notific","id_municip","id_regiona","id_muni_re","id_rg_resi","qt_total_c" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\surto\str_surto_casos.dbf", aFields)
close

cria_campos( 21, "Criando mais campos dentro do arquivo str_surto_casos.dbf...", "c:\auto_regi\tmp\cofi\surto\str_surto_casos", "c:\auto_regi\tmp\cofi\surto\light_surto_casos.dbf" )

@ 22,0 say "Enviando os registros para o arquivo 'light_surto_casos'..."

use "c:\auto_regi\tmp\cofi\surto\light_surto_casos.dbf"
append from "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
@ 23,0 say "Light_surto_casos.dbf..."
@ 23,24 say "ok" color "g+"
close

@ 24,0 say "Copiando a estrutura do arquivo nsurtnet.dbf, campo 'dt_encerra'..."
use "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
aFields := { "nu_notific","tp_not","dt_notific","id_municip","id_regiona","id_muni_re","id_rg_resi","dt_encerra" }
__dbCopyStruct("c:\auto_regi\tmp\cofi\surto\str_surto_encerra.dbf", aFields)
close

cria_campos( 25, "Criando mais campos dentro do arquivo str_surto_encerra.dbf...", "c:\auto_regi\tmp\cofi\surto\str_surto_encerra", "c:\auto_regi\tmp\cofi\surto\light_surto_encerra.dbf" )

@ 26,0 say "Enviando os registros para o arquivo 'light_surto_encerra'..."

use "c:\auto_regi\tmp\cofi\surto\light_surto_encerra.dbf"
append from "c:\auto_regi\tmp\cofi\surto\nsurtnet.dbf"
@ 27,0 say "Light_surto_encerra.dbf..."
@ 27,26 say "ok" color "g+"
close

@ 28,0 say "Procurando por inconsistencia nos campo 'cs_local'..."
use "c:\auto_regi\tmp\cofi\surto\light_surto_local.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( cs_local ) = .T.
replace tp_not with "X"
endif

skip
nCounter++
@ 28,53 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 28,53 say "100%" color "g+"

close

@ 29,0 say "Deixando no arquivo dbf apenas os registros inconsistentes..."

use "c:\auto_regi\tmp\cofi\surto\light_surto_local.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not != "X"
dbDelete()
endif

skip
nCounter++
@ 29,61 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 29,61 say "100%" color "g+"

pack

close

@ 30,0 say "Procurando por inconsistencia nos campo 'qt_total_c'..."
use "c:\auto_regi\tmp\cofi\surto\light_surto_casos.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( qt_total_c ) = .T.
replace tp_not with "X"
endif

skip
nCounter++
@ 30,55 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 30,55 say "100%" color "g+"

close

@ 31,0 say "Deixando no arquivo dbf apenas os registros inconsistentes..."

use "c:\auto_regi\tmp\cofi\surto\light_surto_casos.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not != "X"
dbDelete()
endif

skip
nCounter++
@ 31,61 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 31,61 say "100%" color "g+"

pack

close

@ 32,0 say "Procurando por inconsistencia nos campo 'dt_encerra'..."
use "c:\auto_regi\tmp\cofi\surto\light_surto_encerra.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if empty( dt_encerra ) = .T.
replace tp_not with "X"
endif

skip
nCounter++
@ 32,55 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 32,55 say "100%" color "g+"

close

@ 33,0 say "Deixando no arquivo dbf apenas os registros inconsistentes..."

use "c:\auto_regi\tmp\cofi\surto\light_surto_encerra.dbf"

goto top
nCounter := 1
nTotalRecs := reccount()

do while .not. eof()

nPercent := ( ( nCounter * 100 ) / nTotalRecs )

if tp_not != "X"
dbDelete()
endif

skip
nCounter++
@ 33,61 say alltrim(str(int( nPercent ))) + "%" color "g+"

enddo

@ 33,61 say "100%" color "g+"

pack

close

@ 34,0 say "Preenchendo os campos criados pelo programa. Parte 1..."
munic_not(35,"c:\auto_regi\tmp\cofi\surto\light_surto_local.dbf","surto")
regi_not(36,"c:\auto_regi\tmp\cofi\surto\light_surto_local.dbf","surto")
munic_res(37,"c:\auto_regi\tmp\cofi\surto\light_surto_local.dbf","surto")
regi_res(38,"c:\auto_regi\tmp\cofi\surto\light_surto_local.dbf","surto")

@ 39,0 say "Preenchendo os campos criados pelo programa. Parte 2..."
munic_not(40,"c:\auto_regi\tmp\cofi\surto\light_surto_casos.dbf","surto")
regi_not(41,"c:\auto_regi\tmp\cofi\surto\light_surto_casos.dbf","surto")
munic_res(42,"c:\auto_regi\tmp\cofi\surto\light_surto_casos.dbf","surto")
regi_res(43,"c:\auto_regi\tmp\cofi\surto\light_surto_casos.dbf","surto")

@ 44,0 say "Preenchendo os campos criados pelo programa. Parte 3..."
munic_not(45,"c:\auto_regi\tmp\cofi\surto\light_surto_encerra.dbf","surto")
regi_not(46,"c:\auto_regi\tmp\cofi\surto\light_surto_encerra.dbf","surto")
munic_res(47,"c:\auto_regi\tmp\cofi\surto\light_surto_encerra.dbf","surto")
regi_res(48,"c:\auto_regi\tmp\cofi\surto\light_surto_encerra.dbf","surto")

no_keypress()

return