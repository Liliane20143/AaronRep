public with sharing class AccountingDataApex {
    @auraEnabled
    public static List<NE__Billing_Profile__c> getAllBillingProfile(){
        List<NE__Billing_Profile__c> billingProfiles =[select id  , OB_Bank_Account_Number__c , OB_Bank_Account_Owner__c
                                                       from NE__Billing_Profile__c ];
        System.debug('billingProfiles sono: ' + billingProfiles);
        return billingProfiles;
    }
    
    @auraEnabled
    public static List<NE__Billing_Profile__c> insertFieldsMethod(List<String> billingProfiles){
        
        List<NE__Billing_Profile__c> lista = new List<NE__Billing_Profile__c>();
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        
        for(String billingProfile : billingProfiles){
            bp = (NE__Billing_Profile__c)JSON.deserialize(billingProfile, NE__Billing_Profile__c.class);
            //riga successiva modificata da Marco Lago il 04/09/2018
            if(bp.OB_Bank_Account_Number__c != '' && String.isNotEmpty(bp.OB_Bank_Account_Owner__c))
            {
                lista.add(bp);
            }
        }
        try {
            upsert lista;
        } catch (DmlException e) {
            e.getStackTraceString();
        }
            return lista;
    }
    
    

}