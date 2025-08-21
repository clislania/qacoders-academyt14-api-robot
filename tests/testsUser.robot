*** Settings ***
Documentation         Pasta de Testes de API - Usuários

Resource       ../resources/main_Clis.resource

*** Test Cases ***
CT 01: Teste Login
    Criar sessao User
    Realizar Login User 
    
CT 02: Criar usuário
    ${resposta}    Create User
    Validar Mensagem De Sucesso User Criado   ${resposta}    Olá ${completo.nome}, cadastro realizado com sucesso.
    Delete User

CT 03: Listar Usuarios
    Listagem Users

CT 04: Contar Usuarios 
    Count Users

CT 05: Pegar Usuario
    Get User
   
CT 06: Editar status de usuario para false
    Put status false

CT 07: Editar status de usuario para true
    Put status true

CT 08: Deletar Usuario
    Gerar CPF Aleatorio Numerico
    Gerar Massa de Dados
    Create User  
    ${resposta}    Delete User
    Validar Mensagem De Sucesso User    ${resposta}    Usuário deletado com sucesso!.
    