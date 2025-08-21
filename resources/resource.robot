*** Settings ***
Documentation         Arquivos das bibliotecas de teste

Library             RequestsLibrary
Library             String
Library             Collections 

Resource       ../resources/users.robot
Resource       ../resources/board.robot

Library    FakerLibrary    locale=pt_BR
Library    String
Library    BuiltIn
 

*** Keywords ***
Gerar CPF Aleatorio Numerico
    ${cpf}=    Generate Random String    11    [NUMBERS]
    #RETURN    ${cpf}
    Set Suite Variable    ${generate.cpf}    ${cpf}
    
Gerar Massa de Dados
    [Documentation]    Gera dados aleatórios usando a biblioteca Faker e armazena nas variáveis do tipo dados.
    ${nome_completo}    FakerLibrary.Name
    ${email_gerado}     FakerLibrary.Email
    ${primeiro}=            FakerLibrary.First Name
    ${ultimo}=              FakerLibrary.Last Name
    ${nome_completoC}    Set Variable    ${primeiro} ${ultimo}  
    ${diretoria}        FakerLibrary.Company           
    # ${senha_gerada}     Get Email # Ou outra palavra-chave para senha, como password()
   
    # Armazena os valores gerados nas variáveis que você quer usar
    # O comando Set Suite Variable armazena a variável para ser usada em todos os testes do suite
    Set Suite Variable    ${dados.nome}        ${nome_completo}
    Set Suite Variable    ${dados.email}       ${email_gerado}
    Set Suite Variable    ${dados.perfil}      ADMIN
    #Set Suite Variable    ${dados.cpf}         ${cpf}
    Set Suite Variable    ${dados.senhauser}   1234@Test
    Set Suite Variable    ${dados.snhconf}     1234@Test
    Set Suite Variable    ${dados.first}       ${primeiro}
    Set Suite Variable    ${dados.last}        ${ultimo}
    Set Suite Variable    ${diretoria.nome}    ${diretoria}
    Set Suite Variable    ${completo.nome}    ${nomeCompletoC}   
    

*** Variables ***
${BaseUrl}       https://api-15-the-originals.qacoders.dev.br/api
${Urlchips}      https://api-chips.qacoders.dev.br/api/


      