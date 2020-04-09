/*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@class test for OB_Maintenance_Shortcut_SP_CC
    */
@isTest
public class OB_Maintenance_Shortcut_SP_Test {
     @isTest
    public static void retrieveSPTest(){
        String jsonWrap = '{"AccountName":"STFVLR80A01F205Z","VatNumber":"12345673441","ServicePoint":"","SIACode":"","SiaEstablishment":"","TerminalId":""}';
		OB_Maintenance_Shortcut_SP_CC.SearchResultWrapper wrap1 = new OB_Maintenance_Shortcut_SP_CC.SearchResultWrapper();
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
        NE__Service_Point__c sp = new NE__Service_Point__c();
        insert sp;

        Test.startTest();
		OB_Maintenance_Shortcut_SP_CC.retrieveSP(sp.id);
		Test.stopTest();
    }

}