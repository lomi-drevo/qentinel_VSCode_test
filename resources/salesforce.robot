*** Settings ***
Library                  QWeb


*** Variables ***
${BROWSER}               chrome
${username}              pace.delivery1@qentinel.com.demonew
${login_url}             https://qentinel--demonew.my.salesforce.com/            # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}              ${login_url}/lightning/page/home
${applauncher}           //*[contains(@class, "appLauncher")]

*** Keywords ***
Login
    [Documentation]      Login to Salesforce instance
    GoTo                 ${login_url}
    TypeText             Username                    ${username}
    TypeText             Password                    ${password}
    ClickText            Log In

Home
    [Documentation]      Navigate to homepage, login if needed
    GoTo                 ${home_url}
    ${login_status} =    IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If       ${login_status}             Login
    VerifyText           Home

LaunchApp
    [Documentation]      Launch Salesforce module/app using app launcher.Arguments ${app} to open and ${header} for text to verify after app has been opened
    [Arguments]          ${app}                      ${header}=Leads
    ClickElement         ${applauncher}
    ClickText            ${app}
    VerifyText           ${header}

PickList
    [Arguments]          ${locator}                  ${text}
    ClickElement         //lightning-combobox/label[contains(text(), "${locator}")]
    ClickElement         //lightning-base-combobox-item//span[@title\="${text}"]

VerifyStage
    [Documentation]      Verifies that stage given in ${text} is at ${selected} state; either selected (true) or not selected (false)
    [Arguments]          ${text}                     ${selected}=true
    VerifyElement        //a[@title\="${text}" and @aria-checked\="${selected}"]



###################################################
#                                                 #
#  QUOTE                                          #
###################################################
TypeTable
    [Documentation]      Types text to a cell in _sf-standard-table_ cell. Takes column header (text), row (int)
    ...                  and text to be written as arguments.
    ...    == Examples: ==
    ...    | TypeTable   | Quantity | 3 | 5 |
    ...    | TypeTable   | Additional Discount | 5 | 20% |
    ...
    ...    == Related keywords: ==
    ...    `ClickTableCell`, `GetTableCellText`
    [Arguments]          ${column}          ${row}          ${text}
    ${column_id}=        GetAttribute       //sf-standard-table//div[contains(text(), "${column}")]             field
    ClickTableCell       ${column}          ${row}          double=${True} 
    TypeText             //sf-le-table-row[@data-index\="${row-1}"]//div[@field\="${column_id}"]//input         ${text}\n


GetTableCellText
    [Documentation]      Gets text/value from a _sf-standard-table_ cell. Takes column header (text) and row (int) as arguments. 
    ...
    ...    == Examples: ==
    ...    | ${value}=   | GetTableCellText | Quantity | 3 |
    ...    | ${value}=   | GetTableCellText | Additional Discount | 5 |
    ...
    ...    == Related keywords: ==
    ...    `ClickTableCell`, `TypeTable`
    [Arguments]          ${column}              ${row}
    ${column_id}=        GetAttribute           //sf-standard-table//div[contains(text(), "${column}")]         field
    ${row}=              Convert To Integer     ${row}
    ${value}=            GetText                //sf-le-table-row[@data-index\="${row-1}"]//div[@field\="${column_id}"]/div
    [Return]             ${value}


ClickTableCell
    [Documentation]      Clicks a _sf-standard-table_ cell. Takes column header (text) and row (int) as arguments. 
    ...                  Double-click can be performed giving optional argument _double=${True}_
    ...    == Examples: ==
    ...    | ClickTableCell | Quantity | 3 | |
    ...    | ClickTableCell | Additional Discount | 5 | double=${True} |
    ...
    ...    == Related keywords: ==
    ...    `GetTableCellText`, `TypeTable`
    [Arguments]          ${column}              ${row}            ${double}=${False}
    ${column_id}=        GetAttribute           //sf-standard-table//div[contains(text(), "${column}")]         field
    ${row}=              Convert To Integer     ${row}                        
    ClickElement         //sf-le-table-row[@data-index\="${row-1}"]//div[@field\="${column_id}"]
    RunKeywordIf         ${double}              ClickElement         //sf-le-table-row[@data-index\="${row-1}"]//div[@field\="${column_id}"]             delay=0.5  

