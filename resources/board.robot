*** Settings ***
Documentation    Keywords para o PATH /Users 
Resource    resource.robot

*** Keywords **
Criar sessao
    ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True


Realizar Login
    ${body}    Create Dictionary    
    ...    mail=sysadmin@qacoders.com    
    ...    password=1234@Test
    Criar sessao
    ${resposta}    POST On Session    alias=develop    url=login    json=${body}    expected_status=200
    RETURN    ${resposta} 
    
Pegar boardToken    
    Criar sessao
    ${body}    Create Dictionary    
    ...    mail=sysadmin@qacoders.com    
    ...    password=1234@Test
    ${resposta}    POST On Session    alias=develop    url=login    json=${body}    expected_status=200
    RETURN    ${resposta.json()["token"]}

Listar Diretorias
    ${boardToken}=    Pegar boardToken
    ${headers}=       Create Dictionary    accept=application/json    Content-Type=application/json    Authorization=${boardToken}
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}=      GET On Session    alias=develop    url=board/?token=${boardToken}
    RETURN          ${resposta}

Listagem Board sem token
    Criar sessao
    ${boardToken}    Pegar boardToken
    ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json    authorization=${boardToken}
    ${resposta}    GET On Session    alias=develop    url=board/    expected_status=403
    ${json}=         Set Variable    ${resposta.json()}
    RETURN    ${resposta}

Contar Diretorias
    ${boardToken}=    Pegar boardToken
    ${headers}=       Create Dictionary    accept=application/json    Content-Type=application/json    Authorization=${boardToken}
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}=      GET On Session    alias=develop    url=board/count/?token=${boardToken}
    RETURN          ${resposta}

    
Criar Palavra Randomica
    Criar sessao
    ${token}                Pegar boardToken
    ${palavra_randomica}    Generate Random String    8    [LETTERS]
    ${palavra_randomica}    Convert To Lower Case    ${palavra_randomica}
    Set Global Variable     ${DIRETORIA}    ${palavra_randomica}
    Log                     ${DIRETORIA}

Cadastrar nova Diretoria 
    ${body}    Create Dictionary    boardName=${DIRETORIA}
    Log    ${body}    
    Criar sessao
    Pegar boardToken
    ${boardToken}    Pegar boardToken   
    ${headers}       Create Dictionary    Authorization=${boardToken} 
    ${resposta}      POST On Session    alias=develop    url=board/    headers=${headers}    json=${body}    expected_status=201   
    ${json}=         Set Variable    ${resposta.json()}
    ${id}=           Get From Dictionary    ${json['newBoard']}    _id
    Set Global Variable    ${Id_Board}    ${id}
    Log                    ${Id_Board}
    RETURN    ${resposta}
    
Mostrar Diretoria ID       
    ${boardToken}    Pegar boardToken
    GET On Session    alias=develop    url=board/${Id_Board}/?token=${boardToken} 
    Log   ID da diretoria: ${Id_Board}
  

Editar dados Diretoria ID
    ${body}    Create Dictionary    boardName=${DIRETORIA} 
    Log    ${body}
    ${boardToken}    Pegar boardToken 
    ${headers}       Create Dictionary    accept=application/json   Content-Type=application/json    Authorization=${boardToken} 
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    Log    ${Id_Board}
    ${resposta}    PUT On Session    alias=develop    url=board/${Id_Board}    json=${body}    expected_status=200 
    RETURN    ${resposta}
    

Editar dados Diretoria com & caracteres permitidos
    ${body}    Create Dictionary    boardName=${DIRETORIA}&${DIRETORIA}
    Log    ${body}
    ${boardToken}    Pegar boardToken 
    ${headers}       Create Dictionary    accept=application/json   Content-Type=application/json    Authorization=${boardToken} 
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    Log    ${Id_Board}
    ${resposta}    PUT On Session    alias=develop    url=board/${Id_Board}    json=${body}    expected_status=200
    RETURN    ${resposta}

Editar diretoria boardName ausente
    ${body}    Create Dictionary    
    Log    ${body}
    ${boardToken}    Pegar boardToken 
    ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json    Authorization=${boardToken} 
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}    PUT On Session    alias=develop    url=board/${Id_Board}    json=${body}    expected_status=400
    RETURN    ${resposta}


Editar diretoria boardName com números
    ${body}    Create Dictionary    boardName=1234  
    Log    ${body}
    ${boardToken}    Pegar boardToken 
    ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json    Authorization=${boardToken} 
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}    PUT On Session    alias=develop    url=board/${Id_Board}    json=${body}    expected_status=400
    RETURN    ${resposta}    
    
Editar diretoria boardName com caracteres especiais
    ${body}    Create Dictionary    boardName=Clis@#$%  
    Log    ${body}
    ${boardToken}    Pegar boardToken 
    ${headers}    Create Dictionary    accept=application/json   Content-Type=application/json    Authorization=${boardToken} 
    Create Session    alias=develop    url=${BaseUrl}    headers=${headers}    verify=True
    ${resposta}    PUT On Session    alias=develop    url=board/${Id_Board}    json=${body}    expected_status=400
    RETURN    ${resposta} 

Validar Mensagem De Sucesso
    [Arguments]    ${resposta}    ${mensagem}
    Should Be Equal As Strings    ${resposta.status_code}    200
    Should Be Equal As Strings    ${resposta.json()["msg"]}    ${mensagem}        

Validar Mensagem De Sucesso Criação
    [Arguments]    ${resposta}    ${mensagem}
    Should Be Equal As Strings    ${resposta.status_code}    201
    Should Be Equal As Strings    ${resposta.json()["msg"]}    ${mensagem}        

Validar Mensagem De Erro
    [Arguments]    ${resposta}    ${mensagem_erro}
    Should Be Equal As Strings    ${resposta.status_code}    400
    Should Be Equal As Strings    ${resposta.json()["error"][0]}    ${mensagem_erro}    

Validar Mensagem De Erro sem token
    [Arguments]    ${resposta}    ${mensagem_erro}
    Should Be Equal As Strings    ${resposta.status_code}    403
    Should Be Equal As Strings    ${resposta.json()["errors"][0]}    ${mensagem_erro}    

Deletar Diretoria Criada
    ${boardToken}    Pegar boardToken
    ${headers}       Create Dictionary    accept=application/json    Content-Type=application/json    Authorization=${boardToken}
    DELETE On Session    alias=develop    url=board/${Id_Board}    headers=${headers}    expected_status=200
