/*
    *@author: Andrea Morittu <andrea.morittu@accenture.com>
    *@date: 25/03/2019
    *@description: Added logic upon result of custom metadata; if stringValue2 is multiCAB, bank must me null (It must enter in the 'else' section)
    @history (1)  --> added query + if condition
*/ 

public without sharing class OB_ABI_CAB_Selection_CC {

    
    public class userInfoWrapper {
        @AuraEnabled Boolean isOperation                         {get;set;}
        @AuraEnabled Boolean isPartner                           {get;set;}
        @AuraEnabled Boolean hasError                            {get;set;}
        @AuraEnabled String  ABI                                 {get;set;}
        @AuraEnabled List<String> CAB                               {get;set;}
        @AuraEnabled OB_Bank_Profile__c bankProfile              {get;set;}
        @AuraEnabled String ownerBankId {get;set;}
        userInfoWrapper(){
            CAB = new List<String>(); 
            OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c();
        }
    }

    @AuraEnabled
    public static userInfoWrapper getUserInformation() {
        String partnerCommunity = System.Label.OB_License_PartnerCommunity;
        String operationProfile = System.Label.OB_Operation;

        userInfoWrapper userInformationWrapper = new userInfoWrapper();
        String userId = UserInfo.getUserId();
        User currentUsr = [SELECT  Id,
                            contactId , 
                            contact.accountId, 
                            Profile.UserLicense.Name ,
                            Profile.Name,
                            OB_CAB__C , 
                            OB_ABI__c
                    FROM User
                    WHERE Id =: userId
                    LIMIT 1];
                    System.debug('## current user is: ' + currentUsr );
    /*
    ----------- LOGIC ON WRAPPER --> IF IT'S NOT PARTNER COMMUNITY IT'S OPERATION!
    */
        try {
            if(currentUsr.Profile.UserLicense.Name == partnerCommunity) {
                userInformationWrapper.isPartner = true;
                userInformationWrapper.isOperation = false;

                if(!String.isBlank(currentUsr.OB_ABI__c)) {
                    userInformationWrapper.ABI = currentUsr.OB_ABI__c;
                } else {
                    userInformationWrapper.hasError = true;
                }

                if(!String.isBlank(currentUsr.OB_CAB__C)){
                    //
                    if( (currentUsr.OB_CAB__C).contains(';') ) {
                        userInformationWrapper.CAB.addAll( (currentUsr.OB_CAB__C).split(';') );
                    } 
                }
                OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c();
                bankProfile=[SELECT id , 
                                                OB_Business_Model_Acquiring__c, 
                                                OB_Bank__c , 
                                                OB_GT__c , 
                                                OB_Business_Model_POS__c ,
                                                OB_Circuit__c,
                                                OB_Other_Acquirer__c , 
                                                OB_Service_Type__c, 
                                                OB_Apm_Circuit__c, 
                                                OB_Vas__c, 
                                                OB_SettlementType__c,
                                                OB_AccountHolder__c, 
                                                OB_Applicant_RAC_Code_SIA__c,
                                                OB_Terminal_Id_Generator__c,
                                                OB_NeedBIO__c ,
                                                OB_NDG__c,
                                                OB_Show_check_in_date__c //g.v. 15/07/2019
                                                FROM OB_Bank_Profile__c 
                                                WHERE OB_Bank__c=: currentUsr.contact.accountId
                                                LIMIT 1];
                if(bankProfile != null ) {
                    userInformationWrapper.bankProfile =(OB_Bank_Profile__c) bankProfile;
                }
            } else if(currentUsr.Profile.UserLicense.Name == operationProfile ) {
                userInformationWrapper.isPartner = false;
                userInformationWrapper.isOperation = true;

                // THIS IS NEXI ACCOUNT
                Account currentAcc = [  select id , name
                                        from account
                                        where OB_ABI__c= '00000' and RecordType.DeveloperName='bank'
                                        limit 1]  ;
            }
        } catch(Exception ecc) {
            System.debug('The following exception has occurred: ' + 'at line: ' + ecc.getLineNumber() + 'message : '  + ecc.getMessage() );
        }

        return userInformationWrapper;
    }
}