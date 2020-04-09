public class OB_Maintenance_Shortcut_Referents_CC {
 
    /*
     *   antonio.vatrano, antonio.vatrano@accenture.com
     *   15/04/2019
     *   class wrapper for OB_Maintenance_EditServicePoint
     */
     public class SearchResultWrapper {
        @AuraEnabled
        public string outcome {get;set;}
        @AuraEnabled
        public string errorMessage {get;set;}
        @AuraEnabled
        public Account acc {get;set;}
        @AuraEnabled
        public Contact executor {get;set;}
        @AuraEnabled
        public Contact legalOffice {get;set;}
        @AuraEnabled
        public list<NE__Service_Point__c> listOfServicePoint {get;set;}
        @AuraEnabled
        public string selectedServicePoint{get;set;}
        @AuraEnabled
        public string selectedServicePointExt{get;set;}
        @AuraEnabled
        public boolean executorModifiedAllowed{get;set;}
        @AuraEnabled
        public string selectedMerchantExt{get;set;}
        @AuraEnabled
        public string selectedMerchantAsset{get;set;}
        @AuraEnabled
        public string selectedServicePointAsset{get;set;}
        @AuraEnabled
        public Asset selectedAsset {get;set;}
        @AuraEnabled
        public List<String> selectServicePointListId {get;set;}
        @AuraEnabled
        public List<NE__Lov__c> lovList {get;set;}
     }
    
    /*
     *   antonio.vatrano, antonio.vatrano@accenture.com
     *   15/04/2019
     *   method to retrieve data of servicePoint from the context referent, and current user
     */
    @AuraEnabled
    public static Map<String,String> retrieveData(String contactId){
        SearchResultWrapper result = new SearchResultWrapper();
        Map<String,String> toReturn = new Map<String,String> ();
        
        //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019 START, select for new logic
        List <Contact> contactsList = [SELECT id, OB_Service_Point__c
                                       FROM Contact
                                       WHERE id=:contactId
                                       LIMIT 1];
        Id servicePointId = contactsList.get(0).OB_Service_Point__c;
        
        List<NE__Service_Point__c> listSP =    [SELECT  id 
                                                FROM    NE__Service_Point__c 
                                                WHERE   id =:servicePointId];     
        System.debug(LoggingLevel.INFO, '@@ListSP: '+listSP);
        //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019 STOP, select for new logic
        contact con = [SELECT id,RecordType.Developername FROM Contact WHERE id=:contactId limit 1];

        String SPquery =    'select Id,Name,NE__City__c,NE__Province__c,NE__Street__c,NE__Zip_Code__c,OB_MCC__c,OB_MCC_Description__c,OB_Typology__c,OB_CIG__c,OB_AddressFormula__c,'+
        '(select Id,OB_MCCL2__c from ExternalSourceMapping__r)'+
        ' from NE__Service_Point__c'+
        ' where  id = \''+listSP.get(0).id +'\' ';
        result.listOfServicePoint = Database.query(SPquery);
        String returnJSON = JSON.serialize(result);
        String nameProfile='';
        List<User> listUsers = [SELECT Id,Profile.Name FROM User WHERE Id = : userinfo.getuserid() LIMIT 1];
        if(!listUsers.isEmpty()){
            User us = listUsers.get(0);
            nameProfile = us.Profile.Name;
        }
        toReturn.put('result',returnJSON );
        toReturn.put('profile',nameProfile );
        toReturn.put('servicePointId',listSP.get(0).id );
        toReturn.put('recordType',con.RecordType.Developername);

        return toReturn;

    }
}