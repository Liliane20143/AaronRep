@isTest
public class OB_AccountingDataApex_Test {

    @isTest
    static void getAllBillingProfile_Test(){
        Account acc = new Account(Name = 'aaa',OB_Employees_Number__c = 'Minore di 10');
        //insert acc;
         List<NE__Billing_Profile__c> billingProfiles = new  List<NE__Billing_Profile__c> ();
        NE__Billing_Profile__c bf = new NE__Billing_Profile__c( OB_Bank_Account_Number__c = '123456789012', NE__Account__c = acc.Id);
        billingProfiles.add(bf);
        Test.startTest();
        AccountingDataApex.getAllBillingProfile();
        Test.stopTest();
    }
    
    @isTest
    static void insertFieldsMethod_Test(){
        
        Account acc = new Account(Name = 'acc', OB_ABI__c = '12345',OB_Employees_Number__c = 'Minore di 10');
        //insert acc;
        List<NE__Billing_Profile__c> lista = new List<NE__Billing_Profile__c>();
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
		bp.OB_Bank_Account_Number__c = '123456789012';
        bp.NE__Account__c = acc.Id ;   
        lista.add(bp);
     
        List<String> inputList = new List<String>();
        String str = '{"attributes":{"type":"NE__Billing_Profile__c"},"OB_ABI__c":"12345","OB_Bank_Account_Number__c":"121212121212","OB_Bank_Account_Owner__c":"' + acc.Id + '","NE__Account__c":"' + acc.Id + '"}';
        System.debug('str: ' + str);
        inputList.add(str);
        
        Test.startTest();
        AccountingDataApex.insertFieldsMethod(inputList);
        Test.stopTest();
    }
}