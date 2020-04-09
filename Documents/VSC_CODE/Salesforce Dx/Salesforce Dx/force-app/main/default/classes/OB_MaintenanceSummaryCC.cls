/*------------------------------------------------------------
Author:         davide.franzini
Company:        Accenture Tecnology
Description:    Maintenance Summary component controller class
Inputs:
TestClass:      OB_MaintenanceSummaryCC_Test
<Date>          <Authors Name>      <Brief Description of Change>
2019-06-27      davide.franzini     Creator
------------------------------------------------------------*/
public without sharing class OB_MaintenanceSummaryCC {
    @AuraEnabled
    public static Boolean isCommunityUser(){
        return OB_UtilityCallingServices.isCommunityUser();        
    }
}