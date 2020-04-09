@isTest
public with sharing class OB_operationActionsForSetup_CC_Test {

    @isTest
    public static void checkButtonsVisible_Test(){
        NE__Order_Header__c orh =  OB_TestDataFactory.getOrderHeader();
        insert orh; //francesca.ribezzi 13/09/19 inserting oh;
        NE__Order__c order = OB_TestDataFactory.getOrder( orh );
        insert order; //francesca.ribezzi 13/09/19 inserting order;
        OB_operationActionsForSetup_CC.checkButtonsVisible(orh.Id);
    }

    @isTest
    public static void getHistoricWizards_Test(){
        NE__Order_Header__c orh =  OB_TestDataFactory.getOrderHeader();
        insert orh; //francesca.ribezzi 13/09/19 inserting oh; 
        OB_operationActionsForSetup_CC.getHistoricWizards(orh.Id);
    }

    @isTest
    public static void changeOwnerForApprovalProcess_Test(){
        NE__Order_Header__c orh =  OB_TestDataFactory.getOrderHeader();
        insert orh; //francesca.ribezzi 13/09/19 inserting oh;
        OB_operationActionsForSetup_CC.changeOwnerForApprovalProcess(orh.Id);
    }

    @isTest
    public static void setOrderStatusDraftIncompleteOrder_Test(){
        NE__Order_Header__c orh =  OB_TestDataFactory.getOrderHeader();
        insert orh; //francesca.ribezzi 13/09/19 inserting oh;
        OB_operationActionsForSetup_CC.setOrderStatusDraftIncompleteOrder(orh.Id);
    }

    @isTest
    public static void submitApprovalProcess_Test(){
        NE__Order_Header__c orh =  OB_TestDataFactory.getOrderHeader();
        insert orh; //francesca.ribezzi 13/09/19 inserting oh;
        OB_operationActionsForSetup_CC.submitApprovalProcess(orh.Id);
    }

    /*******************************************************************************
    Purpose:  Method tests submitApprovalProcess

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       1/10/2019      Created         NEXI-353 just increase cc
    ********************************************************************************/
    @isTest
    private static void submitApprovalProcessResubmit( )
    {
        OB_Integration_Configuration__c integrationConfiguration = OB_TestDataFactory.getIntegrationConfiguration( );
        integrationConfiguration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
        integrationConfiguration.OB_Timestamp__c = '1542025783107';
        insert integrationConfiguration;
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        insert testServicePoint;
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.NE__AccountId__c = testAccount.Id;
        testOrderHeader.OB_Gambling__c = true;
        testOrderHeader.OB_Main_Process__c = OB_UtilityConstants.SETUP;
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.NE__AccountId__c = testAccount.Id;
        testOrder.OB_Service_Point__c = testServicePoint.Id;
        testOrder.OB_AdditionalDocumentationRequired__c = true;
        insert testOrder;

        Test.startTest( );
        OB_operationActionsForSetup_CC.submitApprovalProcess( testOrderHeader.Id );
        Test.stopTest( );

        List<NE__Order_Header__c> orderHeaders = [ SELECT OB_StartApprovalProcess__c FROM NE__Order_Header__c ];
        System.assert( orderHeaders.get( 0 ).OB_StartApprovalProcess__c );
    }
    
}