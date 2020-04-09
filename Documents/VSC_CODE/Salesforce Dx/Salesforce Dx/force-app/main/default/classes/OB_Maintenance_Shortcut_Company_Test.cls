/*  
    antonio.vatrano antonio.vatrano@accenture.com
    18/04/2019
    class test for OB_Maintenance_Shortcut_Company_CC
*/
@isTest
public class OB_Maintenance_Shortcut_Company_Test {
    @isTest
    public static void retrieveInfosTest(){
        Account acc = new Account();
		acc.Name = 'Test';
		acc.NE__Fiscal_code__c = 'vtrntn90e18c352q';
		Id recordTypeIdMerch  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT).getRecordTypeId();
		acc.RecordTypeId = recordTypeIdMerch;
		acc.OB_Employees_Number__c = 'Minore di 10';
		acc.OB_VAT_Not_Present__c = true;
		acc.OB_DescriptionVATNotPresent__c = 'description';
		insert acc;
        String accountId = acc.id;

        Test.startTest();
		OB_Maintenance_Shortcut_Company_CC.retrieveInfos(accountId);
		Test.stopTest();
    }
    @isTest
    public static void rsearchAccTest(){
        String jsonWrap = '{"AccountName":"STFVLR80A01F205Z","VatNumber":"12345673441","ServicePoint":"","SIACode":"","SiaEstablishment":"","TerminalId":""}';
		OB_Maintenance_Shortcut_Company_CC.SearchResultWrapper wrap1 = new OB_Maintenance_Shortcut_Company_CC.SearchResultWrapper();
        wrap1.acc=null;
        wrap1.errorMessage='test';
        wrap1.listOfServicePoint= null;
        wrap1.executor= null;
        wrap1.selectedServicePoint = '';
        wrap1.selectedServicePointExt = '';
        wrap1.executorModifiedAllowed = true;
        wrap1.lovList = null;
        wrap1.outcome = '';
        wrap1.legalOffice = null;
        wrap1.selectedMerchantExt = '';
		wrap1.selectedMerchantAsset = '';
		wrap1.selectedServicePointAsset = '';
		wrap1.selectedAsset = null;
		wrap1.selectServicePointListId = null;

        OB_Maintenance_Shortcut_Company_CC.searchWrapper wrap2 = new OB_Maintenance_Shortcut_Company_CC.searchWrapper();

        Test.startTest();
		OB_Maintenance_Shortcut_Company_CC.searchAcc(jsonWrap);
		Test.stopTest();
    }

}