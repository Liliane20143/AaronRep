/*********************************************************************
Name:  OB_FinalSummary_CC
======================================================================                                                                                                       
History                                                            
                                                        
  AUTHOR            DATE CREATED        DESCRIPTION
  Giovanni       	12/04/2019			methods used at last step of flow 
  Spinelli								

**********************************************************************/
public with sharing class OB_FinalSummary_CC {
    /**********************************************
    *METHOD TO CHECK IF THERE ARE IMPORTANT MISSING FIELDS 
    **********************************************/
    // START antonio.vatrano 23/05/2019 add parameter configurationId and check if is maintenance or setup 
    @AuraEnabled
    public static Boolean checkMissingField(String merchantId , String servicePointId, String configurationId){
        System.debug('MERCHANT ID: ' + merchantId + ' SERVICE POINT ID: '+ servicePointId);
        Boolean isMissing = false;
        List<NE__Order__c> configurationList = [ SELECT id, NE__Type__c FROM NE__Order__c WHERE id =:configurationId ];
        NE__Order__c configuration = new NE__Order__c();
        if(!configurationList.isEmpty()){
            configuration = configurationList.get(0);
            if(configuration.NE__Type__c == 'ChangeOrder'){
                return isMissing;
            }
        }
        //antonio.vatrano 23/05/2019 add parameter configurationId and check if is maintenance or setup 
        List<Account> accListToverify               = new List<Account>();
        List<NE__Service_Point__c> spListToverify   = new List<NE__Service_Point__c>();
        try{ 
            //get merchant and service point
            System.debug('FIRST IF CONDITION: '+String.isNotBlank(merchantId));
            if(String.isNotBlank(merchantId)){
                accListToverify=[SELECT Id,
                                OB_Legal_Form_Code__c,
                                OB_Legal_Form__c,
                                OB_Administrative_Office_ZIP__c,
                                OB_Legal_Address_ZIP__c,
                                OB_Administrative_Office_Country__c,
                                OB_Administrative_Office_Country_Code__c,
                                OB_Administrative_Office_State__c,
                                OB_Administrative_Office_State_Code__c,
                                OB_ATECO__c,
                                OB_SAE_Code__c
                                FROM Account 
                                WHERE Id=:merchantId];
            }
            System.debug('SECOND IF CONDITION: '+String.isNotBlank(servicePointId));
            if(String.isNotBlank(servicePointId)){
                spListToverify=[SELECT Id,NE__Zip_Code__c  FROM NE__Service_Point__c WHERE Id =: servicePointId];
            }
            System.debug('MERCHANT: ' + accListToverify);
            System.debug('PV: ' + spListToverify);
            //check if there are empty field on merchant
            if(accListToverify.size()>0){
                Account merchant = accListToverify.get(0);
                if( String.isBlank(merchant.OB_Legal_Form_Code__c)              || String.isBlank(merchant.OB_Legal_Form__c)                        || String.isBlank(merchant.OB_Administrative_Office_ZIP__c)||
                    String.isBlank(merchant.OB_Legal_Address_ZIP__c)            || String.isBlank(merchant.OB_Administrative_Office_Country__c)     || String.isBlank(merchant.OB_Administrative_Office_Country_Code__c) ||
                    String.isBlank(merchant.OB_Administrative_Office_State__c)  || String.isBlank(merchant.OB_Administrative_Office_State_Code__c)  || String.isBlank(merchant.OB_SAE_Code__c))
                {
                  isMissing = true;
                }
            }
            //check if there are empty field on service point
            if(spListToverify.size()>0){
                NE__Service_Point__c servicePoint = spListToverify.get(0);
                if(String.isBlank(servicePoint.NE__Zip_Code__c)){
                    isMissing = true;
                }
            }
            System.debug('is missing field? ' + isMissing);
            
        }catch(Exception e){
            System.debug('OB_FinalSummary_CC.checkMissingField Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
        }
        return isMissing;
    }
}