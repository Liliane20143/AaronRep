public without sharing class OB_CustomAssetViewCoBaPricing_CC {
    public final String terminali = 'Terminali'; // INSERIRE LABEL
    public final String acquiring = 'Acquiring'; // INSERIRE LABEL
    

    public class orderItemWrapper {
        //start----Simone misani RI-94 11/06/2019
        @AuraEnabled 
        public String     name                                        {get;set;}
        @AuraEnabled 
        public String     pvCode                                      {get;set;}
        @AuraEnabled 
        public Boolean    isTerminal                                  {get;set;}
        @AuraEnabled 
        public Boolean    isAcquiring                                 {get;set;}
        @AuraEnabled 
        public String     terminalId                                  {get;set;}
        @AuraEnabled 
        public String     IBAN                                        {get;set;}
        @AuraEnabled 
        public String     accountHolder                               {get;set;}
        @AuraEnabled 
        public Integer    index                                       {get;set;}
        @AuraEnabled 
        public Boolean    isPartner                                   {get;set;}
        @AuraEnabled 
        public Boolean    isOperation                                 {get;set;}
        @AuraEnabled 
        public String    codeServicepoint                             {get;set;}//  simone.misani@accenture.com R1F2-92 07/05/2019 
        // @AuraEnabled List<NE__OrderItem__c> terminals               {get;set;}   
        //     terminalOfferWrapper() {
        //         terminals = new List<NE__OrderItem__c>();
        //     }
    } //END----Simone misani RI-94 11/06/2019
    
    @AuraEnabled
    public static String getAssetInfoServer(String servicePointId, String  offerId) {//simone.misani@accenture.com R1F2-92 07/05/2019
        List<orderItemWrapper>  orderItemWrapperList = new List<orderItemWrapper>();
        // orderItemWrapper        singleWrapper    =  new orderItemWrapper();
        List<NE__OrderItem__c>  ItemsToDisplay   = new List<NE__OrderItem__c>();
        List<Asset> assetToDisplay = new List<Asset>();//---- simone misani  RI-94 10/06/2019
        final String partnerCommunity = System.Label.OB_License_PartnerCommunity;
        
        String userId = UserInfo.getUserId();
        User currentUsr = [SELECT   Id,
                                    contactId , 
                                    contact.accountId, 
                                    Profile.UserLicense.Name ,
                                    Profile.Name,
                                    OB_CAB__C , 
                                    OB_ABI__c
                            FROM User
                            WHERE Id = :userId
                            LIMIT 1];
        //Start  simone.misani@accenture.com R1F2-92 07/05/2019 
        List<Asset>  orderIdList = [SELECT  NE__Order_Config__r.NE__Order_Header__r.NE__OrderId__c,NE__Service_Point__r.Id FROM Asset where id = : offerId LIMIT 1];//  simone.misani@accenture.com R1F2-92 07/05/2019 
         String  orderId;
          String  odservicePoint ;
          //Start  simone.misani@accenture.com R1F2-92- 07/05/2019   
        if(!orderIdList.isEmpty()){
            Asset currentAsset = orderIdList.get(0);
             orderId = currentAsset.NE__Order_Config__c;
             odservicePoint = currentAsset.NE__Service_Point__r.Id;
        }
        //End  simone.misani@accenture.com R1F2-92 07/05/2019 
        ItemsToDisplay = [SELECT Id,
                                 NE__OrderId__r.OB_Service_Point__c ,
                                 NE__ProdId__r.Name,
                                 OB_TermId__c,
                                 NE__ProdId__r.RecordType.DeveloperName, 
                                 NE__Service_Account__r.Name, 
                                 NE__Account__r.Name,
                                 OB_DebitProfId__r.OB_HeaderInternational__c,
                                 OB_DebitProfId__r.OB_IBAN__c,
                                 OB_ServicePointCode__c,
                                 OB_BankAccount_Debit_Acquiring__r.OB_IBAN__c,
                                 OB_BankAccount_Debit_Acquiring__r.OB_HeaderInternational__c
                    FROM NE__OrderItem__c
                    WHERE  NE__OrderId__c  = : orderId //Start  simone.misani@accenture.com R1F2-92 07/05/2019 
                    AND     NE__OrderId__r.OB_Service_Point__c = :servicePointId
                    AND     NE__Root_Order_Item__c = null  
                     AND     (NE__ProdId__r.RecordType.DeveloperName = 'Terminali'
                             OR NE__ProdId__r.RecordType.DeveloperName = 'Acquiring')];
        
        Integer counter = 0;
        if(!ItemsToDisplay.isEmpty()){//---- simone misani  RI-94 10/06/2019
            for(NE__OrderItem__c singleItem : ItemsToDisplay) {
                //for(orderItemWrapper singleWrapper : orderItemWrapper) {
                orderItemWrapper        singleWrapper    =  new orderItemWrapper(); 
                if(currentUsr.Profile.UserLicense.Name == partnerCommunity) {
                    singleWrapper.isPartner         = true;
                    singleWrapper.isOperation       = false;
                } else {
                    singleWrapper.isOperation       = true;
                    singleWrapper.isPartner         = false;
                }
                //TERMINALI
                if(OB_UtilityConstants.POS_RT.equalsIgnoreCase(singleItem.NE__ProdId__r.RecordType.DeveloperName) ) {
                    singleWrapper.isTerminal    =   true;
                    singleWrapper.isAcquiring   =   false;
                    singleWrapper.terminalId    =   singleItem.OB_TermId__c;
                    singleWrapper.IBAN          =   singleItem.OB_DebitProfId__r.OB_IBAN__c;
                    singleWrapper.accountHolder =   singleItem.OB_DebitProfId__r.OB_HeaderInternational__c;
                    singleWrapper.name          =   singleItem.NE__Account__r.Name;
                    singleWrapper.index         =   counter;
                    singleWrapper.pvCode        =   singleItem.NE__ProdId__r.Name;
                }//ACQUIRING
                else if(OB_UtilityConstants.ACQUIRING_RT.equalsIgnoreCase(singleItem.NE__ProdId__r.RecordType.DeveloperName) ) {
                    singleWrapper.isTerminal    =   false;
                    singleWrapper.isAcquiring   =   true;
                    singleWrapper.codeServicepoint    =   singleItem.OB_ServicePointCode__c;//Start  simone.misani@accenture.com R1F2-92 07/05/2019 
                    singleWrapper.IBAN          =   singleItem.OB_BankAccount_Debit_Acquiring__r.OB_IBAN__c;
                    singleWrapper.accountHolder =   singleItem.OB_BankAccount_Debit_Acquiring__r.OB_HeaderInternational__c;
                    singleWrapper.name          =   singleItem.NE__Account__r.Name;
                    singleWrapper.index         =   counter;
                    singleWrapper.pvCode        =   singleItem.NE__ProdId__r.Name;
                }
                orderItemWrapperList.add(singleWrapper);
                counter++;
            // }
            }
        }
        //Start---- simone misani  RI-95 10/06/2019
        else{
            assetToDisplay = [SELECT    id,
                                    NE__Service_Point__c,
                                    NE__ProdId__r.Name, 
                                    OB_TermId__c, 
                                    NE__ProdId__r.RecordType.DeveloperName, 
                                    NE__Service_Account__r.Name,
                                    Account.Name, 
                                    OB_DebitProfId__r.OB_HeaderInternational__c, OB_DebitProfId__r.OB_IBAN__c,
                                    OB_ServicePointCode__c,
                                    OB_BankAccount_Debit_Acquiring__r.OB_IBAN__c, OB_BankAccount_Debit_Acquiring__r.OB_HeaderInternational__c        
                        FROM asset
                        where NE__Order_Config__c =: orderId 
                        AND NE__Service_Point__c =: servicePointId
                        AND NE__Root_Order_Item__c = null
                        AND     (NE__ProdId__r.RecordType.DeveloperName = 'Terminali'
                        OR NE__ProdId__r.RecordType.DeveloperName = 'Acquiring')];
            if(!assetToDisplay.isEmpty()){
                for(Asset singleAsset : assetToDisplay) {
                    //for(orderItemWrapper singleWrapper : orderItemWrapper) {
                    orderItemWrapper        singleWrapper    =  new orderItemWrapper(); 
                    if(currentUsr.Profile.UserLicense.Name == partnerCommunity) {
                        singleWrapper.isPartner         = true;
                        singleWrapper.isOperation       = false;
                    } else {
                        singleWrapper.isOperation       = true;
                        singleWrapper.isPartner         = false;
                    }
                    //TERMINALI
                    if(OB_UtilityConstants.POS_RT.equalsIgnoreCase(singleAsset.NE__ProdId__r.RecordType.DeveloperName) ) {
                        singleWrapper.isTerminal    =   true;
                        singleWrapper.isAcquiring   =   false;
                        singleWrapper.terminalId    =   singleAsset.OB_TermId__c;
                        singleWrapper.IBAN          =   singleAsset.OB_DebitProfId__r.OB_IBAN__c;
                        singleWrapper.accountHolder =   singleAsset.OB_DebitProfId__r.OB_HeaderInternational__c;
                        singleWrapper.name          =   singleAsset.Account.Name;
                        singleWrapper.index         =   counter;
                        singleWrapper.pvCode        =   singleAsset.NE__ProdId__r.Name;
                    }//ACQUIRING
                    else if( OB_UtilityConstants.ACQUIRING_RT.equalsIgnoreCase(singleAsset.NE__ProdId__r.RecordType.DeveloperName) ) {
                        singleWrapper.isTerminal    =   false;
                        singleWrapper.isAcquiring   =   true;
                        singleWrapper.codeServicepoint    =   singleAsset.OB_ServicePointCode__c;//Start  simone.misani@accenture.com R1F2-92 07/05/2019 
                        singleWrapper.IBAN          =   singleAsset.OB_BankAccount_Debit_Acquiring__r.OB_IBAN__c;
                        singleWrapper.accountHolder =   singleAsset.OB_BankAccount_Debit_Acquiring__r.OB_HeaderInternational__c;
                        singleWrapper.name          =   singleAsset.Account.Name;
                        singleWrapper.index         =   counter;
                        singleWrapper.pvCode        =   singleAsset.NE__ProdId__r.Name;
                    }
                    orderItemWrapperList.add(singleWrapper);
                    counter++;
                // }
                }
            }

        }
        //END---- simone misani  RI-94 10/06/2019
        String toReturn = JSON.serialize(orderItemWrapperList);//Start  simone.misani@accenture.com R1F2-92 07/05/2019 
    return toReturn;
    }    
}