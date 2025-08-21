*** Settings ***
Documentation	Keywords para o PATH / Users
Library    RequestsLibrary
Library    String
Library    Collections
Library    FakerLibrary    locale=pt_BR
Library    BuiltIn

resource	board.robot
resource	resource.robot
resource	users.robot