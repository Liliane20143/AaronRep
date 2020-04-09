public with sharing class SearchMerchantByFiscalCode {
    @AuraEnabled
    
    public static List<Account> listAcc(String fiscalCode, String vatId){
        List<Account> acc=new LIST<Account>();
        String query = ''; 
        if (! String.isEmpty(fiscalCode)){
            //monika.kocot 19/06/2019 @start --> change NE__Fiscal_code__c='+fiscalCode+' for NE__Fiscal_code__c=: fiscalCode
            query = 'select ID , name, NE__Fiscal_code__c, NE__VAT__c from Account where NE__Fiscal_code__c=:fiscalCode limit 10';
            //monika.kocot 19/06/2019 @end--> change NE__Fiscal_code__c='+fiscalCode+' for NE__Fiscal_code__c=: fiscalCode
        }
        else {
            //monika.kocot 19/06/2019 @start --> change NE__VAT__c='+vatId+' for NE__VAT__c=:vatId
            query = 'select ID , name, NE__Fiscal_code__c, NE__VAT__c from Account where NE__VAT__c=:vatId limit 10';
            //monika.kocot 19/06/2019 @end --> change NE__VAT__c='+vatId+' for NE__VAT__c=:vatId
        }
        System.debug('Query DB: '+query);
        try{ 
            return Database.query(query);
        }catch(Exception ex){
            throw new AuraHandledException('Error query Fiscal Code');
        }
    }
}