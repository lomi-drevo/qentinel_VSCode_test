*** Settings ***
Library                   QWeb
Library                   String


*** Variables ***
${BROWSER}                chrome

*** Keywords ***
Setup Browser
    Open Browser          about:blank                 ${BROWSER}
    SetConfig             XHRTimeout                  2
    SetConfig             LineBreak                   ${EMPTY}               #\ue000
    SetConfig             DefaultTimeout              30s                    #sometimes salesforce is slow
    SetConfig             SearchMode                  Draw
    SetConfig             MatchingInputElement        //*[(self::input or self::textarea or self::lightning-input or self::lightning-textarea) and (normalize-space(@placeholder)="{0}" or normalize-space(@value)="{0}" or contains(.,"{0}"))]

End suite
    Close All Browsers

NoData
    VerifyNoText          ${data}                     timeout=3

DeleteData
    [Documentation]       RunBlock to remove all data until it doesn't exist anymore
    ClickText             ${data}
    ClickText             Delete
    VerifyText            Are you sure you want to delete this account?
    ClickText             Delete                      2
    VerifyText            Undo
    VerifyNoText          Undo
    ClickText             Accounts                    partial_match=False


