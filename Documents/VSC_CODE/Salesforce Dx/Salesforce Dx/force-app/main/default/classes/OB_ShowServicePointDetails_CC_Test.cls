/*
*   Author      :   Morittu Andrea
*   Date        :   14-Oct-2019
*   Task        :   EVO_PRODOB_450
*   Description :   Covering OB_ShowServicePointDetails_CC class
*/
@isTest
public class OB_ShowServicePointDetails_CC_Test {

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   14-Oct-2019
    *   Task        :   EVO_PRODOB_450
    *   Description :   make data to test in each method
    */
    @TestSetup
    static void makeData(){
        Account bankAccount =  OB_TestDataFactory.getBankAccount();
        bankAccount.Name = 'FAKE REALE ACCOUNT';
        bankAccount.OB_ABI__c = '03138';
        insert bankAccount;

        Account merchantAccount = OB_TestDataFactory.getAccount();
        merchantAccount.Name = 'TEST SSPC';
        merchantAccount.OB_Bank_owner__c = bankAccount.Id;
        insert merchantAccount;

        NE__Service_Point__c servicePoint = OB_TestDataFactory.getServicePoint();
        servicePoint.NE__Account__c = merchantAccount.Id;
        insert servicePoint;
        
        Id refPVRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.REFERENTE_PUNTO_VENDITA).getRecordTypeId();
        Id refTechRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.REFERENTE_TECNICO).getRecordTypeId();
        Id resAmmRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.RESPONSABILE_AMMINISTRATIVO).getRecordTypeId();

        Contact refPV = OB_TestDataFactory.getContact(merchantAccount);
        refPV.OB_Bank__c = bankAccount.Id;
        refPV.recordTypeId = refPVRecordType;
        refPV.OB_Contact_State__c = 'Active';
        refPV.OB_Service_Point__c = servicePoint.Id;
        insert refPV;
        
        Contact refTech = OB_TestDataFactory.getContact(merchantAccount);
        refTech.OB_Bank__c = bankAccount.Id;
        refTech.recordTypeId = refTechRecordType;
        refTech.OB_Contact_State__c = 'Active';
        refTech.OB_Service_Point__c = servicePoint.Id;
        insert refTech;

        Contact resAmm = OB_TestDataFactory.getContact(merchantAccount);
        resAmm.OB_Bank__c = bankAccount.Id;        
        resAmm.recordTypeId = resAmmRecordType;
        resAmm.OB_Contact_State__c  = 'Active';
        resAmm.OB_Service_Point__c = servicePoint.Id;
        insert resAmm;

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader();
        orderHeader.NE__AccountId__c = merchantAccount.Id;
        orderHeader.OB_ProposerABI__c = bankAccount.Id;
        insert orderHeader;

        NE__Order__c order = OB_TestDataFactory.getOrder(orderHeader);
        order.OB_ABI__c = bankAccount.OB_ABI__c;
        order.NE__Order_Header__c = orderHeader.Id;
        order.OB_Service_Point__c = servicePoint.Id;
        insert order;
    }

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   14-Oct-2019
    *   Task        :   EVO_PRODOB_450
    *   Description :   Test getServicePointInfo_Server method
    */

    @isTest
    public static void getServicePointInfo_Server_SuccessTest() {
        NE__Order_Header__c orderHeaderToTest = [SELECT Id, 
                                                        NE__AccountId__c,
                                                 		OB_ProposerABI__c,
                                                 		OB_ProposerABI__r.OB_ABI__c
                                                 FROM   NE__Order_Header__c 
                                                 WHERE  NE__AccountId__r.Name = 'TEST SSPC'];

        Test.startTest();
            OB_ShowServicePointDetails_CC.servicePointDetailWrapper wrapperToMatch =  OB_ShowServicePointDetails_CC.getServicePointInfo_Server(orderHeaderToTest.Id);
            // START MORITTU ANDREA 16-Oct-2019 - Code_Review_Fix 
        	System.assertEquals(wrapperToMatch.bankABI, orderHeaderToTest.OB_ProposerABI__r.OB_ABI__c);
            // END MORITTU ANDREA 16-Oct-2019 - Code_Review_Fix 
        Test.stopTest();
    }
        
    @isTest
    public static void getServicePointInfo_Server_FailTest() {
        Test.startTest();
        	OB_ShowServicePointDetails_CC.servicePointDetailWrapper wrapperToMatch =  OB_ShowServicePointDetails_CC.getServicePointInfo_Server('IamNotAvalidID');
        Test.stopTest();
    }
    
    @isTest
    public static void contactsRelatedToServicePointAndBank_Test() { 
    	Map<String, Object> tempMap = new Map<String, Object>();
        tempMap.put('mainServicePointReferent', null);
        OB_ShowServicePointDetails_CC.servicePointDetailWrapper tempObj = new OB_ShowServicePointDetails_CC.servicePointDetailWrapper();
        
        NE__Service_Point__c mainSP = OB_TestDataFactory.getServicePoint();
        insert mainSP;
        tempObj.mainServicePoint = mainSP;
        tempObj.mainServicePointReferent = null;
        Test.startTest();
            OB_ShowServicePointDetails_CC.contactsRelatedToServicePointAndBank(tempObj);
            // START MORITTU ANDREA 16-Oct-2019 - Code_Review_Fix 
        	//System.assertEquals(wrapperToMatch.bankABI, orderHeaderToTest.OB_ProposerABI__r.OB_ABI__c);
            // END MORITTU ANDREA 16-Oct-2019 - Code_Review_Fix 
        Test.stopTest();
    }
    
}