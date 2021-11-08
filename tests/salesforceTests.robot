*** Settings ***
Resource                      ../resources/common.robot
Resource                      ../resources/salesforce.robot
Suite Setup                   Setup Browser
Suite Teardown                End suite


*** Test Cases ***
Entering A Lead
    [tags]                    Lead
    Appstate                  salesforce.Login
    VerifyText                Home
    salesforce.LaunchApp      Sales

    ClickUntil                Recently Viewed             Leads
    ClickUntil                Lead Information            New

    salesforce.Picklist       Salutation                  Ms.
    TypeText                  First Name                  Tina
    TypeText                  Last Name                   Smith
    salesforce.Picklist       Lead Status                 Open
    TypeText                  Phone                       +12234567858449             First Name
    TypeText                  Company                     Growmore                    Last Name
    TypeText                  Title                       Manager                     Address Information
    TypeText                  Email                       tina.smith@gmail.com        Rating
    TypeText                  Website                     https://www.growmore.com/

    salesforce.Picklist       Lead Source                 Partner
    ClickText                 Save                        partial_match=False
    Sleep                     1
    ClickText                 Leads
    VerifyText                Tina Smith
    VerifyText                Manager
    VerifyText                Growmore

Converting A Lead To Opportunity-Account-Contact
    [tags]                    Lead
    Appstate                  salesforce.Home
    salesforce.LaunchApp      Sales

    ClickUntil                Recently Viewed             Leads
    ClickText                 Tina Smith

    ClickUntil                Convert Lead                Convert
    ClickText                 Opportunity                 2
    TypeText                  Opportunity Name            Growmore Pace
    ClickText                 Convert                     2
    VerifyText                Your lead has been converted                            timeout=30

    ClickText                 Go to Leads
    ClickText                 Opportunities
    VerifyText                Growmore Pace
    ClickText                 Accounts
    VerifyText                Growmore
    ClickText                 Contacts
    VerifyText                Tina Smith

Creating An Account
    [tags]                    Account
    Appstate                  salesforce.Home
    salesforce.LaunchApp      Sales

    ClickUntil                Recently Viewed             Accounts
    ClickUntil                Account Information         New

    TypeText                  Account Name                Salesforce                  anchor=Parent Account
    TypeText                  Phone                       +12258443456789             anchor=Fax
    TypeText                  Fax                         +12258443456766
    TypeText                  Website                     https://www.salesforce.com
    salesforce.Picklist       Type                        Partner
    salesforce.Picklist       Industry                    Finance

    TypeText                  Employees                   35000
    TypeText                  Annual Revenue              12 billion
    ClickText                 Save                        partial_match=False

    ClickText                 Details
    VerifyText                Salesforce
    VerifyText                35,000

Creating An Opportunity For The Account
    [tags]                    Account
    Appstate                  salesforce.Home
    salesforce.LaunchApp      Sales
    ClickUntil                Recently Viewed             Accounts
    VerifyText                Salesforce
    VerifyText                Opportunities

    ClickUntil                Stage                       Opportunities
    ClickUntil                Opportunity Information     New
    TypeText                  Opportunity Name            Safesforce Pace             anchor=Cancel
    TypeText                  Search Accounts...          Salesforce                  check=False
    ClickText                 +12258443456789
    salesforce.Picklist       Type                        New Business
    ClickText                 Close Date                  Opportunity Information
    ClickText                 Next Month
    ClickText                 Today

    salesforce.Picklist       Stage                       Prospecting
    TypeText                  Amount                      5000000
    salesforce.Picklist       Lead Source                 Partner
    TypeText                  Next Step                   Qualification
    TypeText                  Description                 This is first step
    ClickText                 Save                        partial_match=False         # Do not accept partial match, i.e. "Save All"

    Sleep                     1
    ClickText                 Opportunities
    VerifyText                Safesforce Pace

Change status of opportunity
    [tags]                    status_change
    Appstate                  salesforce.Home
    ClickText                 Opportunities
    ClickText                 Safesforce Pace             delay=2                     # intentionally delay action - 2 seconds
    VerifyText                Contact Roles

    ClickText                 Show actions for this object
    ClickText                 Add Contact Roles
    TypeText                  Search Contact              Tina    delay=2
    ClickText                 Tina Smith
    ClickText                 Next                        delay=3
    ClickText                 Edit Role: Item 1
    ClickText                 --None--
    ClickText                 Decision Maker
    ClickText                 Save                        partial_match=False
    VerifyText                Tina Smith

    ClickText                 Mark Stage as Complete
    ClickText                 Opportunities
    ClickText                 Safesforce Pace             delay=2
    salesforce.VerifyStage    Qualification               true
    salesforce.VerifyStage    Prospecting                 false

Create A Contact For The Account
    [tags]                    salesforce.Account
    Appstate                  Home
    salesforce.LaunchApp      Sales
    ClickUntil                Recently Viewed             Accounts
    VerifyText                Salesforce
    VerifyText                Contacts

    ClickUntil                Email                       Contacts
    ClickUntil                Contact Information         New
    salesforce.Picklist       Salutation                  Mr.
    TypeText                  First Name                  Richard
    TypeText                  Last Name                   Brown
    TypeText                  Phone                       +00150345678134             anchor=Mobile
    TypeText                  Mobile                      +00150345678178
    TypeText                  Search Accounts...          Salesforce                  check=False
    ClickText                 +12258443456789

    TypeText                  Email                       richard.brown@gmail.com     anchor=Reports To
    TypeText                  Title                       Manager
    ClickText                 Save                        partial_match=False
    Sleep                     1
    ClickText                 Contacts
    VerifyText                Richard Brown

Delete Test Data
    [tags]                    Test data
    Appstate                  salesforce.Home
    salesforce.LaunchApp      Sales
    ClickUntil                Recently Viewed             Accounts

    Set Suite Variable        ${data}                     Salesforce
    RunBlock                  NoData                      timeout=180s                exp_handler=DeleteData
    Set Suite Variable        ${data}                     Growmore
    RunBlock                  NoData                      timeout=180s                exp_handler=DeleteData

    ClickText                 Opportunities
    VerifyText                0 items
    VerifyNoText              Safesforce Pace
    VerifyNoText              Growmore Pace
    VerifyNoText              Richard Brown
    VerifyNoText              Tina Smith
