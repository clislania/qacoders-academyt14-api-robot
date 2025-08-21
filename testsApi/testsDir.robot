*** Settings ***
Documentation    Pasta de Testes de API - Diretoria      

Resource       ../resources/main_Clis.resource

*** Test Cases **
CT 01: Realizar Login
    ${resposta}    Realizar Login
    Validar Mensagem De Sucesso    ${resposta}    Olá Qa-Coders-SYSADMIN, autenticação autorizada com sucesso!

CT 02: Pegar board Token
    ${resposta}    Pegar Board Token
    
CT 03: Cadastrar nova Diretoria
    Criar Palavra Randomica
    ${resposta}    Cadastrar nova Diretoria 
    Validar Mensagem De Sucesso Criação   ${resposta}    Cadastro realizado com sucesso!
    
CT 04: Listar todas as Diretorias
    ${resposta}    Listar Diretorias
    Should Be Equal As Strings    ${resposta.status_code}    200
       
CT 05: Listar Diretorias sem token   
    ${resposta}    Listagem board sem token
    Should Be Equal As Strings    ${resposta.status_code}    403
    Validar Mensagem De Erro sem token  ${resposta}    No token provided.

CT 06: Contar diretorias com sucesso
    ${resposta}    Contar Diretorias
    Should Be Equal As Strings    ${resposta.status_code}    200

CT 07: Mostrar Diretoria ID
    Criar Palavra Randomica
    Cadastrar nova Diretoria
    Log    ID da diretoria: ${Id_Board}
       
CT 08: Editar dados Diretoria ID
    Criar Palavra Randomica
    Cadastrar nova Diretoria
    Criar Palavra Randomica
    ${resposta}    Editar dados Diretoria ID
    Validar Mensagem De Sucesso   ${resposta}    Cadastro atualizado com sucesso.

CT 09: Editar dados Diretoria com & caracteres permitidos
    Criar Palavra Randomica    
    Cadastrar nova Diretoria
    Criar Palavra Randomica
    ${resposta}    Editar dados Diretoria com & caracteres permitidos
    Validar Mensagem De Sucesso   ${resposta}    Cadastro atualizado com sucesso.

CT 10: Editar diretoria boardName ausente
    Criar Palavra Randomica
    Cadastrar nova Diretoria
    ${resposta}    Editar diretoria boardName ausente  
    Validar Mensagem De Erro   ${resposta}    O campo 'diretoria' é obrigatório.

CT 11: Editar diretoria boardName com números
    Criar Palavra Randomica
    Cadastrar nova Diretoria
    ${resposta}    Editar diretoria boardName com números
    Validar Mensagem De Erro   ${resposta}    O campo 'diretoria' só pode conter letras e o caractere especial '&'.
    

CT 12: Editar diretoria boardName com caracteres especiais
    Criar Palavra Randomica    
    Cadastrar nova Diretoria
    ${resposta}    Editar diretoria boardName com caracteres especiais
    Log    ${resposta}
    Validar Mensagem De Erro   ${resposta}    O campo 'diretoria' só pode conter letras e o caractere especial '&'.