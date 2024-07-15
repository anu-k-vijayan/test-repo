*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BACKEND_PATH}    http://backend-service:3000             

*** Test Cases ***
To Verify Frontend and Backend Integration
    [Documentation]    Verify that the frontend and backend communication service is finr
    [Tags]    integration
    
    ${response}    GET On Session   ${BACKEND_PATH}     /greet 
    Should Be Equal As Strings    ${response.status_code}    200
    ${json_response}    Set Variable    ${response.json()}
    Should Contain    ${json_response}    Hello, World!
    Log     Frontend and backend communication is successfull
