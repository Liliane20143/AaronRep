/**************************************************************
* Date Created       : 12/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_OrderHeaderTriggerHandler
***************************************************************
*/

@isTest
public class OB_OrderHeaderTriggerHandler_Test
{

    @isTest
    public static void submitValidity_test( )
    {


        Map<Id, NE__Order_Header__c> oldOrds = new Map<Id, NE__Order_Header__c>( );
        Map<Id, NE__Order_Header__c> newOrds = new Map<Id, NE__Order_Header__c>( );

        NE__Order_Header__c currentOrder = new NE__Order_Header__c( );
        currentOrder.OB_AcquiringApproval__c = false;
        currentOrder.OB_Rejection_Reason__c = '';
        currentOrder.OB_Main_Process__c = 'Maintenance';
        insert currentOrder;
        oldOrds.put( currentOrder.id, currentOrder );


        NE__Order_Header__c currentOrder2 = new NE__Order_Header__c( );
        currentOrder2.OB_AcquiringApproval__c = true;
        currentOrder2.OB_Rejection_Reason__c = '';
        currentOrder2.OB_Main_Process__c = 'Maintenance';
        insert currentOrder2;

        currentOrder2.Id = currentOrder.Id;
        //update  currentOrder;

        NE__Order__c ord = new NE__Order__c( );
        ord.NE__Order_Header__c = currentOrder2.id;
        insert ord;

        newOrds.put( currentOrder.id, currentOrder );

        OB_LogRequest__c Log = new OB_LogRequest__c( );
        Log.OB_OrderId__c = ord.id;
        // Log.OB_Status__c  = 'In attesa';
        Log.OB_Status__c = 'Bozza';
        insert Log;

        Test.startTest( );
        OB_OrderHeaderTriggerHandler orderHeaderTrigger = new OB_OrderHeaderTriggerHandler( );
        orderHeaderTrigger.submitValidity( oldOrds, newOrds );
        Test.stopTest( );
    }

    @isTest
    public static void submitValidity_test2( )
    {
        Map<Id, NE__Order_Header__c> oldOrds = new Map<Id, NE__Order_Header__c>( );
        Map<Id, NE__Order_Header__c> newOrds = new Map<Id, NE__Order_Header__c>( );

        NE__Order_Header__c oldOrd = new NE__Order_Header__c( );
        oldOrd.OB_AcquiringApproval__c = false;
        oldOrd.OB_Rejection_Reason__c = '';
        oldOrd.OB_Main_Process__c = 'Maintenance';
        insert oldOrd;

        oldOrds.put( oldOrd.id, oldOrd );

        // NE__Order_Header__c currentOrderChild     = new NE__Order_Header__c ();
        // currentOrderChild.OB_AcquiringApproval__c = false;
        // currentOrderChild.OB_Rejection_Reason__c  = '';
        // currentOrderChild.OB_Main_Process__c		 ='Maintenance';
        // insert currentOrderChild;


        NE__Order__c ord2 = new NE__Order__c( );
        ord2.NE__Order_Header__c = oldOrd.id;
        insert ord2;

        NE__Order_Header__c newOrd = new NE__Order_Header__c( );
        newOrd.OB_AcquiringApproval__c = false;
        newOrd.OB_Rejection_Reason__c = 'Rifiuto definitivo';
        newOrd.OB_Main_Process__c = 'Maintenance';
        insert newOrd;

        newOrd.Id = oldOrd.Id;
        update newOrd;

        newOrds.put( newOrd.id, newOrd );

        NE__Order__c ord = new NE__Order__c( );
        ord.NE__Order_Header__c = newOrd.id;
        insert ord;

        OB_LogRequest__c lr = new OB_LogRequest__c( );
        lr.OB_Status__c = 'Bozza';
        lr.OB_OrderId__c = ord.id;
        insert lr;

        Test.startTest( );
        OB_OrderHeaderTriggerHandler orderHeaderTrigger = new OB_OrderHeaderTriggerHandler( );
        orderHeaderTrigger.submitValidity( oldOrds, newOrds );
        Test.stopTest( );
    }

    @isTest
    public static void submitValidity_test3( )
    {
        List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>( );

        //MAP OLD ORDER HEADER
        Map<Id, NE__Order_Header__c> oldOrderHeader = new Map<Id, NE__Order_Header__c>( );
        //MAP NEW ORDER HEADER
        Map<Id, NE__Order_Header__c> newOrderHeader = new Map<Id, NE__Order_Header__c>( );

        //OLD ORDER HEADER
        NE__Order_Header__c oldObjOrderHeader = new NE__Order_Header__c( );
        oldObjOrderHeader.OB_CAB__c = '23456';
        oldObjOrderHeader.OB_AcquiringApproval__c = false;
        insert oldObjOrderHeader;
        oldOrderHeader.put( oldObjOrderHeader.Id, oldObjOrderHeader );

        //PARENT ORDER HEADER
        NE__Order_Header__c orderHeader = new NE__Order_Header__c( );
        orderHeader.OB_CAB__c = '12342';
        orderHeader.OB_AcquiringApproval__c = true;
        orderHeader.OB_Main_Process__c = 'Maintenance';
        insert orderHeader;
        orderHeader.id = oldObjOrderHeader.id;
        update orderHeader;
        newOrderHeader.put( orderHeader.Id, orderHeader );

        //ORDER
        NE__Order__c ord = new NE__Order__c( );
        ord.NE__Order_Header__c = orderHeader.id;
        insert ord;

        OB_LogRequest__c lr = new OB_LogRequest__c( );
        lr.OB_Status__c = 'Bozza';
        lr.OB_OrderId__c = ord.id;
        insert lr;

        listOfLogRequest.add( lr );
        Test.startTest( );
        OB_OrderHeaderTriggerHandler orderHeaderTrigger = new OB_OrderHeaderTriggerHandler( );
        orderHeaderTrigger.submitValidity( oldOrderHeader, newOrderHeader );
        Test.stopTest( );
    }

    @isTest
    public static void submitValidity_test4( )
    {
        List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>( );

        //MAP OLD ORDER HEADER
        Map<Id, NE__Order_Header__c> oldOrderHeader = new Map<Id, NE__Order_Header__c>( );
        //MAP NEW ORDER HEADER
        Map<Id, NE__Order_Header__c> newOrderHeader = new Map<Id, NE__Order_Header__c>( );

        //OLD ORDER HEADER
        NE__Order_Header__c oldObjOrderHeader = new NE__Order_Header__c( );
        oldObjOrderHeader.OB_CAB__c = '23456';
        oldObjOrderHeader.OB_AcquiringApproval__c = false;
        insert oldObjOrderHeader;
        oldOrderHeader.put( oldObjOrderHeader.Id, oldObjOrderHeader );

        //PARENT ORDER HEADER
        NE__Order_Header__c orderHeader = new NE__Order_Header__c( );
        orderHeader.OB_CAB__c = '12342';
        orderHeader.OB_AcquiringApproval__c = true;
        orderHeader.OB_Main_Process__c = 'Setup';
        insert orderHeader;
        orderHeader.id = oldObjOrderHeader.id;
        update orderHeader;
        newOrderHeader.put( orderHeader.Id, orderHeader );

        //ORDER
        NE__Order__c order = new NE__Order__c( );
        order.OB_CAB__c = '12342';
        order.NE__Order_Header__c = orderHeader.Id;
        insert order;

        //LOG REQUEST Map<Id,NE__Order_Header__c> oldOrds, Map<Id,NE__Order_Header__c> newOrds
        OB_LogRequest__c singleLogRequest = new OB_LogRequest__c( );
        singleLogRequest.OB_OrderId__c = order.Id;
        singleLogRequest.OB_Status__c = 'Bozza';

        listOfLogRequest.add( singleLogRequest );
        Test.startTest( );
        OB_OrderHeaderTriggerHandler orderHeaderTrigger = new OB_OrderHeaderTriggerHandler( );
        orderHeaderTrigger.submitValidity( oldOrderHeader, newOrderHeader );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field OB_Nexi_OrderStatus__c of NE__Order__c - OB_OrderStatusOperationControls - accept scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       20/05/2019      Created         AF-Funnel-v3.0_status_logic_5.1
    ********************************************************************************/
    @isTest
    public static void changeOrderStatusForOrderStatusOperationControlsTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        insert testOrder;

        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( NE__OrderId__c = testOrder.Id );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS;
        testOrderHeader.OB_StartApprovalProcess__c = true;
        testOrderHeader.OB_AcquiringApproval__c = true;
        insert testOrderHeader;

        testOrderHeader.OB_AcquiringApproval__c = false;
        update testOrderHeader;

        List<NE__Order__c> orderResult = new List<NE__Order__c>( );

        orderResult = [ SELECT Id, OB_Nexi_OrderStatus__c FROM NE__Order__c WHERE id = :testOrder.Id ];
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_OPERATION_CONTROLS, orderResult[ 0 ].OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field OB_Nexi_OrderStatus__c of NE__Order__c - OB_OrderStatusAMLControls - accept scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       20/05/2019      Created         AF-Funnel-v3.0_status_logic_5.1
    1.1         Kinga Fornal            25/07/2019      Created         NEXI-214
    ********************************************************************************/
    @isTest
    public static void changeOrderStatusForOrderStatusAMLControlsTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.NE__Fiscal_code__c = 'SMTJHN90A01F205S';
        insert testAccount;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        testOrder.NE__AccountId__c = testAccount.Id;
        insert testOrder;

        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( NE__OrderId__c = testOrder.Id );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS;
        testOrderHeader.OB_StartApprovalProcess__c = true;
        testOrderHeader.OB_AcquiringApproval__c = true;
        testOrderHeader.NE__AccountId__c = testAccount.Id;
        insert testOrderHeader;

        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_CONTROLS_AML;
        testOrderHeader.OB_AcquiringApproval__c = false;
        update testOrderHeader;

        List<NE__Order__c> orderResult = new List<NE__Order__c>( );
        orderResult = [ SELECT Id, OB_Nexi_OrderStatus__c FROM NE__Order__c WHERE id = :testOrder.Id ];
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_AML_CONTROLS, orderResult[ 0 ].OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field OB_Nexi_OrderStatus__c of NE__Order__c - OB_OrderStatusSecurityChecks - accept scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       20/05/2019      Created         AF-Funnel-v3.0_status_logic_5.1
    ********************************************************************************/
    @isTest
    public static void changeOrderStatusForOrderStatusSecurityChecksTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        insert testOrder;

        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( NE__OrderId__c = testOrder.Id );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS;
        testOrderHeader.OB_StartApprovalProcess__c = true;
        testOrderHeader.OB_AcquiringApproval__c = true;
        insert testOrderHeader;

        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_SECURITY_CHECKS;
        testOrderHeader.OB_AcquiringApproval__c = false;
        update testOrderHeader;

        List<NE__Order__c> orderResult = new List<NE__Order__c>( );
        orderResult = [ SELECT Id, OB_Nexi_OrderStatus__c FROM NE__Order__c WHERE id = :testOrder.Id ];
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_SECURITY_CHECKS, orderResult[ 0 ].OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests restarting approval process

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal           25/07/2019      	Created         NEXI-214
    ********************************************************************************/
    @isTest
    public static void startAVRSOSWhenNeededTest( )
    {
        OB_Integration_Configuration__c integrationConfiguration = OB_TestDataFactory.getIntegrationConfiguration( );
        integrationConfiguration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
        integrationConfiguration.OB_Timestamp__c = '1542025783107';
        insert integrationConfiguration;

        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.NE__Fiscal_code__c = 'SMTJHN90A01F205S';
        insert testAccount;

        Contact executor = OB_TestDataFactory.getContact( testAccount );
        executor.OB_Fiscal_Code__c = testAccount.NE__Fiscal_code__c;
        executor.RecordTypeId = OB_Util009_AVRSOS.RECORD_TYPE_ESECUTORE;
        executor.OB_Birth_Date__c = Date.newInstance( 1990, 1, 1 );
        insert executor;

        Contact actualOwner = OB_TestDataFactory.getContact( testAccount );
        actualOwner.OB_Fiscal_Code__c = testAccount.NE__Fiscal_code__c;
        actualOwner.RecordTypeId = OB_Util009_AVRSOS.RECORD_TYPE_TITOLARE_EFFETTIVO;
        insert actualOwner;

        NE__Order_Header__c orderHeader = new NE__Order_Header__c( );
        orderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS;
        orderHeader.NE__AccountId__c = testAccount.Id;
        insert orderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( orderHeader );
        testOrder.NE__AccountId__c = testAccount.Id;
        insert testOrder;

        OB_Util009_AVRSOS.AVRSOSResponse responseAVR = new OB_Util009_AVRSOS.AVRSOSResponse( );
        responseAVR.dossierId = '123456789012345';
        OB_Util009_AVRSOS_Mock.dataResponse = responseAVR;
        OB_Util009_AVRSOS_Mock.statusCode = 200;
        OB_Util009_AVRSOS_Mock.status = OB_UtilityConstants.TECHOUTCOME_OK;
        Test.setMock( HttpCalloutMock.class, new OB_Util009_AVRSOS_Mock( ) );

        Test.startTest( );
        orderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_CONTROLS_AML;
        orderHeader.OB_StartApprovalProcess__c = true;
        update orderHeader;
        Test.stopTest( );
        //Roland Nieznanski <roland.nieznanski@accenture.com> 12/09/2019 START
        List<NE__Order__c> resultOrder = [ SELECT Id, OB_Nexi_LastStatusChange__c FROM NE__Order__c WHERE Id = :testOrder.Id LIMIT 1 ];
        System.assertNotEquals( null, resultOrder.get( 0 ).OB_Nexi_LastStatusChange__c );
        //Roland Nieznanski <roland.nieznanski@accenture.com> 12/09/2019 END
    }
    /*******************************************************************************
    Purpose:  Method tests restarting approval process

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          25/07/2019      	Created         NEXI-217
    1.1			Marta Stempien		    30/08/2019			Modified		NEXI-287
    1.2			Adrian Dlugolecki		20/09/2019			Changed		    NEXI-343
    ********************************************************************************/
    @isTest
    public static void restartApprovalProcessTest( )
    {
        NE__Order_Header__c oldHeader = OB_TestDataFactory.getOrderHeader( );
        oldHeader.OB_ApprovalStep__c = OB_UtilityConstants.APPROVAL_STEP_5;
        insert oldHeader;
        oldHeader.OB_ApprovalStep__c = OB_UtilityConstants.APPROVAL_STEP_3;
        oldHeader.OB_Rejection_Reason__c = OB_UtilityConstants.REJECTION_INCOMPLETE_DOCUMENTATION;
        oldHeader.OB_ProcessInstanceAlredyExist__c = false;
        oldHeader.OB_StartApprovalProcess__c = true;
        oldHeader.OB_ManualPAN__c = true;
        oldHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_SECURITY_CHECKS;
        Test.startTest( );
        update oldHeader;
        Test.stopTest( );
        List<ProcessInstance> processesTest =
        [
                SELECT Id
                FROM ProcessInstance
                WHERE TargetObjectId = :oldHeader.Id
        ];
        ProcessInstance processTest = !processesTest.isEmpty( ) ? processesTest.get( 0 ) : null;
        System.assert( processTest != null );
    }

    /*******************************************************************************
    Purpose:       Method prepares map with old order header
    Parameters:    -
    Returns:       Map<Id, NE__Order_Header__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/10/2019      Created         NEXI-368
    ********************************************************************************/
    private static Map<Id, NE__Order_Header__c> prepareOldOrderHeaders( )
    {
        NE__Order_Header__c oldOrderHeader = OB_TestDataFactory.getOrderHeader( );
        oldOrderHeader.OB_Rejection_Reason__c = '';
        insert oldOrderHeader;

        Map<Id, NE__Order_Header__c> oldOrderHeaders = new Map<Id, NE__Order_Header__c>( );
        oldOrderHeaders.put( oldOrderHeader.Id, oldOrderHeader );

        return oldOrderHeaders;
    }

    /*******************************************************************************
    Purpose:       Method prepares map with new order header
    Parameters:    String inOrderHeaderId, Boolean insertPlcLog, String inRequestBody
    Returns:       Map<Id, NE__Order_Header__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/10/2019      Created         NEXI-368
    ********************************************************************************/
    private static Map<Id, NE__Order_Header__c> prepareNewOrderHeaders( String inOrderHeaderId, Boolean insertPlcLog, String inRequestBody )
    {
        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( Id = inOrderHeaderId );
        testOrderHeader.OB_Rejection_Reason__c = OB_UtilityConstants.REJECTION_REASON_FINAL_REJ;
        update testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;
        NE__Product__c testProduct = OB_TestDataFactory.getProduct( );
        testProduct.OB_Codice_sfdc__c = OB_UtilityConstants.START_SFDC;
        insert testProduct;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__ProdId__c = testProduct.Id;
        insert testOrderItem;

        if ( insertPlcLog )
        {
            Plc_Log__c testPlcLog = new Plc_Log__c( );
            testPlcLog.OB_OrderId__c = testOrder.Id;
            testPlcLog.Plc_RequestBody__c = inRequestBody;
            testPlcLog.Plc_RequestURI__c = '/UpdateDossierSOS/*';
            insert testPlcLog;
        }

        Map<Id, NE__Order_Header__c> newOrderHeaders = new Map<Id, NE__Order_Header__c>( );
        newOrderHeaders.put( testOrderHeader.Id, testOrderHeader );

        return newOrderHeaders;
    }

    /*******************************************************************************
    Purpose:       Method prepares avr sos request
    Parameters:    String inOutcome
    Returns:       String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/10/2019      Created         NEXI-368
    ********************************************************************************/
    private static String prepareAvrSosRequest( String inOutcome )
    {
        OB_UpdateDossierSOS.AvrSOS testAvrSOS = new OB_UpdateDossierSOS.AvrSOS( );
        testAvrSOS.sosId = '123';
        testAvrSOS.requestOutcome = inOutcome;
        testAvrSOS.outcomeDescription = 'TEST';
        testAvrSOS.outcomeCode = 'TEST';
        testAvrSOS.workerComments = 'TEST';

        return JSON.serialize( testAvrSOS );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderNexiStatus - order header processed and approved by Avr Sos, rejected by sicurezza

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/10/2019      Created         NEXI-368
    ********************************************************************************/
    @isTest
    private static void updateOrderNexiStatusOKByAvrSos( )
    {
        String inRequestBody = prepareAvrSosRequest( OB_UpdateDossierSOS.CODE_OK );
        Map<Id, NE__Order_Header__c> oldOrderHeaders = prepareOldOrderHeaders( );
        Map<Id, NE__Order_Header__c> newOrderHeaders = prepareNewOrderHeaders( oldOrderHeaders.values( ).get( 0 ).Id, true, inRequestBody );

        Test.startTest( );
        OB_OrderHeaderTriggerHandler orderHeaderTriggerHandler = new OB_OrderHeaderTriggerHandler( );
        orderHeaderTriggerHandler.updateOrderNexiStatus( oldOrderHeaders, newOrderHeaders );
        Test.stopTest( );

        List<NE__Order__c> result = [ SELECT OB_Nexi_OrderStatus__c FROM NE__Order__c LIMIT 1 ];
        System.assert( OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED.equalsIgnoreCase( result.get( 0 ).OB_Nexi_OrderStatus__c ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderNexiStatus - order header processed and rejected by Avr Sos

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/10/2019      Created         NEXI-368
    ********************************************************************************/
    @isTest
    private static void updateOrderNexiStatusKOByAvrSos( )
    {
        String inRequestBody = prepareAvrSosRequest( OB_UpdateDossierSOS.CODE_KO );
        Map<Id, NE__Order_Header__c> oldOrderHeaders = prepareOldOrderHeaders( );
        Map<Id, NE__Order_Header__c> newOrderHeaders = prepareNewOrderHeaders( oldOrderHeaders.values( ).get( 0 ).Id, true, inRequestBody );

        Test.startTest( );
        OB_OrderHeaderTriggerHandler orderHeaderTriggerHandler = new OB_OrderHeaderTriggerHandler( );
        orderHeaderTriggerHandler.updateOrderNexiStatus( oldOrderHeaders, newOrderHeaders );
        Test.stopTest( );

        List<NE__Order__c> result = [ SELECT OB_Nexi_OrderStatus__c FROM NE__Order__c LIMIT 1 ];
        System.assert( !OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED.equalsIgnoreCase( result.get( 0 ).OB_Nexi_OrderStatus__c ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderNexiStatus - order header processed by avr sos, bad data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/10/2019      Created         NEXI-368
    ********************************************************************************/
    @isTest
    private static void updateOrderNexiStatusBadAvrRequest( )
    {
        String inRequestBody = 'TEST';
        Map<Id, NE__Order_Header__c> oldOrderHeaders = prepareOldOrderHeaders( );
        Map<Id, NE__Order_Header__c> newOrderHeaders = prepareNewOrderHeaders( oldOrderHeaders.values( ).get( 0 ).Id, true, inRequestBody );

        Test.startTest( );
        OB_OrderHeaderTriggerHandler orderHeaderTriggerHandler = new OB_OrderHeaderTriggerHandler( );
        orderHeaderTriggerHandler.updateOrderNexiStatus( oldOrderHeaders, newOrderHeaders );
        Test.stopTest( );

        List<NE__Order__c> result = [ SELECT OB_Nexi_OrderStatus__c FROM NE__Order__c LIMIT 1 ];
        System.assert( OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED.equalsIgnoreCase( result.get( 0 ).OB_Nexi_OrderStatus__c ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderNexiStatus - order header processed by avr sos, null data

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/10/2019      Created         NEXI-368
    ********************************************************************************/
    @isTest
    private static void updateOrderNexiStatusNullAvrRequest( )
    {
        String inRequestBody = '';
        Map<Id, NE__Order_Header__c> oldOrderHeaders = prepareOldOrderHeaders( );
        Map<Id, NE__Order_Header__c> newOrderHeaders = prepareNewOrderHeaders( oldOrderHeaders.values( ).get( 0 ).Id, true, inRequestBody );

        Test.startTest( );
        OB_OrderHeaderTriggerHandler orderHeaderTriggerHandler = new OB_OrderHeaderTriggerHandler( );
        orderHeaderTriggerHandler.updateOrderNexiStatus( oldOrderHeaders, newOrderHeaders );
        Test.stopTest( );

        List<NE__Order__c> result = [ SELECT OB_Nexi_OrderStatus__c FROM NE__Order__c LIMIT 1 ];
        System.assert( OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED.equalsIgnoreCase( result.get( 0 ).OB_Nexi_OrderStatus__c ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderNexiStatus - order header without avr sos callout (ws) - rejected

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/10/2019      Created         NEXI-368
    ********************************************************************************/
    @isTest
    private static void updateOrderNexiStatusWithoutAvrSos( )
    {
        Map<Id, NE__Order_Header__c> oldOrderHeaders = prepareOldOrderHeaders( );
        Map<Id, NE__Order_Header__c> newOrderHeaders = prepareNewOrderHeaders( oldOrderHeaders.values( ).get( 0 ).Id, false, '' );

        Test.startTest( );
        OB_OrderHeaderTriggerHandler orderHeaderTriggerHandler = new OB_OrderHeaderTriggerHandler( );
        orderHeaderTriggerHandler.updateOrderNexiStatus( oldOrderHeaders, newOrderHeaders );
        Test.stopTest( );

        List<NE__Order__c> result = [ SELECT OB_Nexi_OrderStatus__c FROM NE__Order__c LIMIT 1 ];
        System.assert( OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED.equalsIgnoreCase( result.get( 0 ).OB_Nexi_OrderStatus__c ) );
    }
}