*** Settings ***
Documentation    Keywords para o PATH /Users 
Resource    resource.robot
Resource    main_Clis.resource

*** Keywords ***
Criar sessao User
    ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
Realizar Login User
    ${body}    Create Dictionary    
    ...    mail=sysadmin@qacoders.com    
    ...    password=1234@Test
    Criar sessao User
    ${resposta}    POST On Session    alias=develop    url=login    json=${body}    expected_status=200
    RETURN    ${resposta.json()["token"]}

Create User
    ${token}    Realizar Login User
    Gerar Massa de Dados
    Gerar CPF Aleatorio Numerico
    ${body}     Create Dictionary    
    ...    fullName=${completo.nome}
    ...    mail=${dados.email}
    ...    accessProfile=${dados.perfil}
    ...    cpf=${generate.cpf}
    ...    password=${dados.senhauser}
    ...    confirmPassword=${dados.senhauser}
     
    ${resposta}    POST On Session    alias=develop    url=user/?token=${token}   json=${body}
    Status Should Be    201    ${resposta}
    #Log To Console    ${resposta.json()["user"]["_id"]}
    Set Global Variable    ${Id_User}    ${resposta.json()["user"]["_id"]}
    RETURN    ${resposta}

Listagem Users
    Criar sessao User
    ${token}          Realizar Login User
    ${headers}       Create Dictionary    accept=application/json    Content-Type=application/json    Authorization=${token}
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}    GET On Session    alias=develop    url=user/  

Count Users
    Criar sessao User
    ${token}          Realizar Login User
    GET On Session    alias=develop    url=user/count/?token=${token}   
    
Get User         
    ${token}       Realizar Login User
    ${resposta}    Create User
    ${Id_User}     Set Variable    ${resposta.json()["user"]["_id"]}   
    ${resposta}    GET On Session    alias=develop    url=user/${Id_User}/?token=${token}

Put status false 
    Create User
    ${token}       Realizar Login User
    ${body}        Create Dictionary    status=false
    ${resposta}    PUT On Session       alias=develop    url=user/status/${Id_User}/?token=${token}    json=${body}    expected_status=200

Put status true
    Create User
    ${token}       Realizar Login User
    ${body}        Create Dictionary    status=true
    ${resposta}    PUT On Session       alias=develop    url=user/status/${Id_User}/?token=${token}    json=${body}    expected_status=200    

Delete User
    ${token}       Realizar Login User
    ${resposta}    DELETE On Session    alias=develop    url=user/${Id_User}/?token=${token}    expected_status=200
    RETURN         ${resposta}


Validar Mensagem De Sucesso User Criado
    [Arguments]    ${resposta}    ${mensagem}
    Should Be Equal As Strings    ${resposta.status_code}    201
    Should Be Equal As Strings    ${resposta.json()["msg"]}    ${mensagem}        

Validar Mensagem De Sucesso User 
    [Arguments]    ${resposta}    ${mensagem}    
    Should Be Equal As Strings    ${resposta.status_code}    200
    Should Be Equal As Strings    ${resposta.json()["msg"]}    ${mensagem}