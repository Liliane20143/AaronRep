@isTest
public class OB_TestStartWizardController_Test {
    
    @isTest
    public static void testStartWizardControllerTest(){
        Account acc = new Account();
            acc.Name = 'Test';
            //acc.Description  = 'Test';
            acc.NE__E_mail__c  = 'test@null.it';
            acc.OB_Employees_Number__c = 'Minore di 10';
            acc.NE__VAT__c  = '12345678901';
            acc.NE__Fiscal_code__c= '12345678901';
            acc.OB_VAT_Not_Present__c = false;
		insert acc; 
 
        NE__Order__c ord = new NE__Order__c();
        insert ord;
        Apexpages.currentpage().getparameters().put('accId', acc.Id);
        Apexpages.currentpage().getparameters().put('ordID', ord.Id );
        Test.startTest();
        testStartWizardController tswc = new testStartWizardController();
        Test.stopTest();
    }
}