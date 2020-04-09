public without sharing class OB_OrderHeaderTriggerHandler // simone misani R1F2-159 07/06/2019
{
    private static final String FINAL_REFUSAL_STATE = 'Rifiuto definitivo'; // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019

    public void submitValidity( Map<Id, NE__Order_Header__c> oldOrds, Map<Id, NE__Order_Header__c> newOrds )
    {
        if ( oldOrds.size( ) > 0 && newOrds.size( ) > 0 )
        {
            for ( NE__Order_Header__c currentOrderHeader : newOrds.values( ) )
            {
                if ( oldOrds.get( currentOrderHeader.Id ).OB_AcquiringApproval__c == false && currentOrderHeader.OB_AcquiringApproval__c == true )
                {
                    //11-02-2019-S.P-DON'T CALL SUBMIT IF IS A MAINTENANCE'S ORDER
                    // <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2 - if condition modified - START
                    if ( currentOrderHeader.OB_Sub_Process__c != OB_UtilityConstants.HEADER_SUBPROCESS_TERMINAOFFERTA )
                    {
                        String orderHeaderId = String.valueOf( currentOrderHeader.Id );
                        System.enqueueJob( new OB_QueueableClass( orderHeaderId ) );
                        //OB_UtilityCallingServices.callSubmit(orderHeaderId);
                        //System.debug('@Execute callSubmit from trigger');
                    }
                    // <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2 - if condition modified - START
                    //19-02-2019-S.P.-CHANGE LOG REQUEST'S STATUS AFTER APPROVAL ACTION OF ACQUIRING-START
                    if ( currentOrderHeader.OB_Main_Process__c == 'Maintenance' ) // <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2 - else removed
                    {
                        List<OB_LogRequest__c> listOfLogRequest =
                        [
                                SELECT Id,OB_Status__c,OB_OrderId__c,
                                        OB_OrderId__r.NE__Order_Header__c,OB_MaintenanceType__c //Simone Misani 02/10/2019
                                FROM OB_LogRequest__c
                                WHERE OB_OrderId__r.NE__Order_Header__c = :currentOrderHeader.Id
                                AND OB_Status__c = 'Bozza'
                        ];
                        if ( !listOfLogRequest.isEmpty( ) )
                        {
                            for ( OB_LogRequest__c logReq : listOfLogRequest )
                            {
                                //Simone Misani 02/10/2019 START
                                if(logReq.OB_MaintenanceType__c != 'Pricing'){                          
                                
                                    logReq.OB_Status__c = OB_UtilityConstants.INATTESA;
                                }                                
                            }//Simone Misani 02/10/2019 END
                            update listOfLogRequest;
                        }
                    }
                    //19-02-2019-S.P.-CHANGE LOG REQUEST'S STATUS AFTER APPROVAL ACTION OF ACQUIRING-END
                }
                else if ( oldOrds.get( currentOrderHeader.Id ).OB_Rejection_Reason__c != OB_UtilityConstants.REJECTION_REASON_FINAL_REJ && currentOrderHeader.OB_Rejection_Reason__c == OB_UtilityConstants.REJECTION_REASON_FINAL_REJ )
                {
                    String orderHeaderId = String.valueOf( currentOrderHeader.Id );
                    OB_Utility.checkItemsToCancel( orderHeaderId );
                    System.debug( '@Execute OB_Utility.checkItemsToCancel()' );
                    if ( currentOrderHeader.OB_Main_Process__c == 'Maintenance' )
                    {
                        List<OB_LogRequest__c> listOfLogRequest =
                        [
                                SELECT Id,OB_Status__c,OB_OrderId__c,
                                        OB_OrderId__r.NE__Order_Header__c
                                FROM OB_LogRequest__c
                                WHERE OB_OrderId__r.NE__Order_Header__c = :currentOrderHeader.Id
                                AND OB_Status__c = 'Bozza'
                        ];
                        if ( !listOfLogRequest.isEmpty( ) )
                        {
                            for ( OB_LogRequest__c logReq : listOfLogRequest )
                            {
                                logReq.OB_Status__c = OB_UtilityConstants.RIFIUTATO;
                            }
                            update listOfLogRequest;
                        }
                    }
                }
            }
        }
    }

    /*******************************************************************************
    Purpose:  Method set Nexi status and Bank status in order, method is called from OB_OrderHeaderTrigger
    Parameters: Map<Id, NE__Order_Header__c> oldOrderHeaders, Map<Id, NE__Order_Header__c> newOrderHeaders
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       16/05/2019      Created         NEXI-52
    ********************************************************************************/
    static public void setOrderStatus( Map<Id, NE__Order_Header__c> oldOrderHeaders, Map<Id, NE__Order_Header__c> newOrderHeaders )
    {
        Set<Id> orderIds = new Set<Id>( );
        for ( Id orderHeaderId : newOrderHeaders.keySet( ) )
        {
            orderIds.add( newOrderHeaders.get( orderHeaderId ).NE__OrderId__c );
        }

        if ( orderIds == null || orderIds.isEmpty( ) )
        {
            return;
        }

        Map<Id, NE__Order__c> orderMap = new Map<Id, NE__Order__c>(
        [
                SELECT Id,
                        OB_FulfilmentStatus__c,
                        OB_Bank_OrderStatus__c
                FROM NE__Order__c
                WHERE Id in:orderIds AND OB_FulfilmentStatus__c = :OB_UtilityConstants.FULFILMENTSTATUS_PENDING
        ] );

        if ( orderMap == null || orderMap.isEmpty( ) )
        {
            return;
        }

        List<NE__Order__c> ordersToUpdate = new List<NE__Order__c>( );

        for ( NE__Order_Header__c orderHeader : newOrderHeaders.values( ) )
        {
            NE__Order_Header__c oldOldHeader = oldOrderHeaders.get( orderHeader.Id );
            if ( orderHeader.OB_StartApprovalProcess__c != oldOldHeader.OB_StartApprovalProcess__c
                    || orderHeader.OB_Rejection_Reason__c != oldOldHeader.OB_Rejection_Reason__c
                    || orderHeader.OB_AcquiringApproval__c != oldOldHeader.OB_AcquiringApproval__c
                    || orderHeader.OB_In_Approvazione_a__c != oldOldHeader.OB_In_Approvazione_a__c )
            {
                NE__Order__c tempOrder = OB_Order_ChangeStatus.changeOrderStatus( orderHeader, orderMap.get( orderHeader.NE__OrderId__c ) );
                if ( tempOrder != null )
                {
                    ordersToUpdate.add( tempOrder );
                }
            }
        }

        try
        {
            update ordersToUpdate;
        } catch ( DmlException dmlException )
        {
            System.debug( LoggingLevel.ERROR, 'Exception during update Order : ' + dmlException );
        }

    }

    /*
    @Author	:	Simone Misani  <simone.misani@accenture.com>
    @Date	:	2019.05.30
    @Task	:	R1F2-159
                --------------------------------
                            START
    */
    //START-----simone misani R1F2-159 07/06/2019
    public void updateOrderNexiStatus( Map<Id, NE__Order_Header__c> oldOrds, Map<Id, NE__Order_Header__c> newOrds )
    {
        System.debug( 'updateOrdertoAml' );

        // NEXI-368 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/10/2019 START
        Set<String> currentOrderIds = new Set<String>( );
        Set<String> rejectedOrderHeadersIds = new Set<String>( );
        // NEXI-368 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/10/2019 STOP
        String valueNexiStatus ;
        //START elena.preteni 12/06 R1F2-243
        String valueBankStatus ;
        Boolean lastRejection;
        //STOP elena.preteni 12/06 R1F2-243
        if ( oldOrds.size( ) > 0 && newOrds.size( ) > 0 )
        {
            for ( NE__Order_Header__c currentOrderHeader : newOrds.values( ) )
            {
                //START elena.preteni 12/06 R1F2-246
                Boolean changeStatus = currentOrderHeader.OB_Rejection_Reason__c == OB_UtilityConstants.REJECTION_MISSING_DOCUMENTATION
                        || currentOrderHeader.OB_Rejection_Reason__c == OB_UtilityConstants.REJECTION_INCOMPLETE_DOCUMENTATION ;
                lastRejection = currentOrderHeader.OB_Rejection_Reason__c == OB_UtilityConstants.REJECTION_REASON_FINAL_REJ ;
                System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.updateOrderNexiStatus Rejection Reason -> ' + currentOrderHeader.OB_Rejection_Reason__c +
                        ' lastRejection -> ' + lastRejection + ' oldValues ' + oldOrds.get( currentOrderHeader.Id ).OB_Rejection_Reason__c );
                //STOP elena.preteni 12/06 R1F2-246
                if ( OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS.equalsIgnoreCase( currentOrderHeader.OB_In_Approvazione_a__c ) && !lastRejection ) // NEXI-357 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 check if it's final rejection
                {
                    System.debug( 'OPERATIVI' );
                    //START elena.preteni 12/06 R1F2-246
                    valueNexiStatus = changeStatus ? OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION : OB_Order_ChangeStatus.ORDER_STATUS_OPERATION_CONTROLS;
                    valueBankStatus = changeStatus ? OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION : OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_NEXI_PROCESSING;//simone misani 14/06/2019 R1F2-275
                    //STOP elena.preteni 12/06 R1F2-246
                    currentOrderIds.add( currentOrderHeader.id );
                }
                else if ( OB_UtilityConstants.FASECONTROL_CONTROLS_AML.equalsIgnoreCase( currentOrderHeader.OB_In_Approvazione_a__c ) && !lastRejection ) // NEXI-357 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 check if it's final rejection
                {
                    System.debug( 'AML' );
                    //START elena.preteni 12/06 R1F2-246
                    valueNexiStatus = changeStatus ? OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION : Label.OB_OrderStatusAMLControls;
                    valueBankStatus = changeStatus ? OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION : OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_NEXI_PROCESSING;//simone misani 14/06/2019 R1F2-275

                    //STOP elena.preteni 12/06 R1F2-246
                    currentOrderIds.add( currentOrderHeader.id );
                }
                else if ( OB_UtilityConstants.FASECONTROL_SECURITY_CHECKS.equalsIgnoreCase( currentOrderHeader.OB_In_Approvazione_a__c ) && !lastRejection ) // NEXI-357 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 check if it's final rejection
                {
                    System.debug( 'SECURITY' );
                    //START elena.preteni 12/06 R1F2-246
                    valueNexiStatus = changeStatus ? OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION : OB_Order_ChangeStatus.ORDER_STATUS_SECURITY_CHECKS;
                    valueBankStatus = changeStatus ? OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION : OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_NEXI_PROCESSING;//simone misani 14/06/2019 R1F2-275
                    // if(changeStatus){
                    //     valueBankStatus = OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION; 
                    // }
                    //STOP elena.preteni 12/06 R1F2-246
                    currentOrderIds.add( currentOrderHeader.id );
                }
                // NEXI-368 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/10/2019 START
                if ( lastRejection )
                {
                    rejectedOrderHeadersIds.add( currentOrderHeader.Id );
                }
            }

            checkIfAvrSosReply( rejectedOrderHeadersIds );
            if ( !rejectedOrderHeadersIds.isEmpty( ) )
            {
                currentOrderIds.addAll( rejectedOrderHeadersIds );
                valueBankStatus = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED;
                valueNexiStatus = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED;
            }
            // NEXI-368 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 16/10/2019 STOP

            if ( !currentOrderIds.isEmpty( ) )
            {
                String orderId;
                List<String> idConfigList = new List<String>( );
                List<NE__Order__c> ordersToUpdate = new List<NE__Order__c>( );
                ordersToUpdate =
                [
                        SELECT id,
                                OB_Nexi_OrderStatus__c,//elena.preteni 12/06 R1F2-246
                                OB_Bank_OrderStatus__c,//elena.preteni 12/06 R1F2-246
                                OB_Bank_LastStatusChange__c,//elena.preteni 12/06 R1F2-246
                                OB_Nexi_LastStatusChange__c,
                                OB_FulfilmentStatus__c,
                                NE__Order_Header__r.OB_In_Approvazione_a__c,
                                NE__Order_Header__r.OB_StartApprovalProcess__c,
                                NE__Order_Header__r.OB_AcquiringApproval__c
                        FROM NE__Order__c
                        WHERE NE__Order_Header__c IN :currentOrderIds
                ];

                //START elena.preteni 12/06 R1F2-243
                for ( NE__Order__c conf : ordersToUpdate )
                {
                    idConfigList.add( conf.id );
                }
                List<NE__OrderItem__c> oiList = [ SELECT id,NE__ProdId__r.OB_Codice_sfdc__c,NE__Service_Point__r.OB_Typology__c,NE__OrderId__c, NE__OrderId__r.NE__Order_Header__c FROM NE__OrderItem__c WHERE NE__OrderId__c IN :idConfigList ];//Simone misani  call in final reject
                //STOP elena.preteni 12/06 R1F2-243
                Boolean checkLast = false; //Simone Misani 16/10
                String orderHeaderId ;//Simone Misani 16/10
                if ( !ordersToUpdate.isEmpty( ) )
                {
           
                    List<NE__Order__c> finalListToUpdate = new List<NE__Order__c>( );
                    for ( NE__Order__c singleOrdertoUpdate : ordersToUpdate )
                    {
                       
                        singleOrdertoUpdate.OB_Nexi_OrderStatus__c = valueNexiStatus;
                        //START elena.preteni 12/06 R1F2-246
                        if ( valueBankStatus != '' )
                        {
                            singleOrdertoUpdate.OB_Bank_OrderStatus__c = valueBankStatus;
                            singleOrdertoUpdate.OB_Bank_LastStatusChange__c = System.now( );
                        }
                        //STOP elena.preteni 12/06 R1F2-246
                        //START elena.preteni 12/06 R1F2-243
                        for ( NE__OrderItem__c oi : oiList )
                        {   
                            orderHeaderId = oi.NE__OrderId__r.NE__Order_Header__c;//Simone misani  call in final reject//Simone Misani 16/10
                            if ( oi.NE__OrderId__c == singleOrdertoUpdate.id &&
                                    ( oi.NE__Service_Point__r.OB_Typology__c == 'Virtuale' || oi.NE__ProdId__r.OB_Codice_sfdc__c.equalsIgnoreCase( OB_UtilityConstants.START_SFDC ) ) && lastRejection )
                            {
                                singleOrdertoUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED;
                                singleOrdertoUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED;
                                singleOrdertoUpdate.OB_Bank_LastStatusChange__c = System.now( );
                            }
                            else if ( oi.NE__OrderId__c == singleOrdertoUpdate.id && oi.NE__ProdId__r.OB_Codice_sfdc__c.equalsIgnoreCase( OB_UtilityConstants.CUSTOM_SFDC ) && lastRejection )
                            {
                                
                                checkLast = true;//Simone Misani 16/10
                                singleOrdertoUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_WAITING_FOR_PROCESSING ;
                                singleOrdertoUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_NEXI_PROCESSING;
                                singleOrdertoUpdate.OB_Bank_LastStatusChange__c = System.now( );
                                
                            }
                        }
                        //STOP elena.preteni 12/06 R1F2-243
                        singleOrdertoUpdate.OB_Nexi_LastStatusChange__c = System.now( );
                        finalListToUpdate.add( singleOrdertoUpdate );
                        orderId = singleOrdertoUpdate.Id;

                    }////Simone Misani 16/10 START
                    if(checkLast){
                        //System.enqueueJob(new OB_QueueableClass(orderHeaderId));//Simone misani  call in final reject
                    }//Simone Misani 16/10 END
                    if ( !finalListToUpdate.isEmpty( ) )
                    {
                        Approval.UnlockResult[] lrList = Approval.unlock( ordersToUpdate, false );
                        System.debug( 'lrList unlock?: ' + Approval.isLocked( orderId ) );
                        update finalListToUpdate;
                        //GIOVANNI SPINELLI PRODOB-387 start
                        //Approval.LockResult[] lrList1 = Approval.lock(ordersToUpdate, false);
                        //GIOVANNI SPINELLI PRODOB-387 end
                        System.debug( 'lrLis is Lock?: ' + Approval.isLocked( orderId ) );
                    }
                    //END-----simone misani R1F2-159 07/06/2019
                }
            }

        }
    }

    /*******************************************************************************
    Purpose: Method calls AVR/SOS service if needed
    Parameters: Map<Id,NE__Order_Header__c> oldOrdHeaders, Map<Id,NE__Order_Header__c> newOrdHeaders
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       22/07/2019      Created         NEXI-214
    1.1         Joanna Mielczarek       04/10/2019      Modified        NEXI-353 changed condition to call avr sos ( resubmitting approval process )
    ********************************************************************************/
    public static void callAVRSOSIfNeeded( Map<Id, NE__Order_Header__c> oldOrdHeaders, Map<Id, NE__Order_Header__c> newOrdHeaders )
    {
        System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.callAVRSOSIfNeeded START' );
        if ( !oldOrdHeaders.isEmpty( ) && !newOrdHeaders.isEmpty( ) )
        {
            for ( NE__Order_Header__c loopOrderHeader : newOrdHeaders.values( ) )
            {
                NE__Order_Header__c oldOrderHeader = oldOrdHeaders.get( loopOrderHeader.Id );
                System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.callAVRSOSIfNeeded In Approvazione new  : ' +  loopOrderHeader.OB_In_Approvazione_a__c + ' In Approvazione old ' + oldOrderHeader.OB_In_Approvazione_a__c );
                System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.callAVRSOSIfNeeded Rejection Reason new  : ' +  loopOrderHeader.OB_Rejection_Reason__c + ' Rejection Reason old ' + oldOrderHeader.OB_Rejection_Reason__c );
                if ( ( ( loopOrderHeader.OB_In_Approvazione_a__c != oldOrderHeader.OB_In_Approvazione_a__c ) ||
                       ( String.isBlank( loopOrderHeader.OB_Rejection_Reason__c ) && !String.isBlank( oldOrderHeader.OB_Rejection_Reason__c ) && !FINAL_REFUSAL_STATE.equalsIgnoreCase( oldOrderHeader.OB_Rejection_Reason__c ) ) )
                        && OB_UtilityConstants.FASECONTROL_CONTROLS_AML.equalsIgnoreCase( loopOrderHeader.OB_In_Approvazione_a__c ) )
                {
                    OB_Util009_AVRSOS.calloutAVRSOS( loopOrderHeader.NE__AccountId__c, loopOrderHeader.Id, OB_UtilityConstants.SETUP );
                }
            }

        }
    }
    /*******************************************************************************
    Purpose: Restart approval process
	Parameters: Map<Id,NE__Order_Header__c> oldOrds, Map<Id,NE__Order_Header__c> newOrds
	Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0			Zuzanna Urban		 24/07/2019		   Created			 NEXI-217
	2.0         Marta Stempien       13/09/2019        Modified          NEXI-326
    ********************************************************************************/
    public static void restartApproval( Map<Id, NE__Order_Header__c> oldOrds, Map<Id, NE__Order_Header__c> newOrds )
    {
        Map<Id, NE__Order_Header__c> newOrdersMap = new Map<Id, NE__Order_Header__c>( );
        if ( oldOrds == null || newOrds == null || oldOrds.size( ) == 0 || newOrds.size( ) == 0 )
        {
            return;
        }

        for ( NE__Order_Header__c newOrderHeader : newOrds.values( ) )
        {
            //NEXI-343 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 20/09/2019 Start
            String oldRejectReason = '';
            NE__Order_Header__c oldHeader = oldOrds.get( newOrderHeader.id );
            if ( oldHeader != null && !String.isBlank( oldHeader.OB_Rejection_Reason__c ) )
            {
                oldRejectReason = oldHeader.OB_Rejection_Reason__c;
            }
            //NEXI-343 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 20/09/2019 Stop
            //NEXI-326 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Start
            Boolean isStartApprovalOriginalValue = newOrderHeader.OB_StartApprovalProcess__c;
            newOrderHeader.OB_StartApprovalProcess__c = true;
            //NEXI-326 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Stop

            if ( newOrderHeader.OB_In_Approvazione_a__c == OB_UtilityConstants.FASECONTROL_SECURITY_CHECKS
                    && !oldRejectReason.equalsIgnoreCase( newOrderHeader.OB_Rejection_Reason__c ) //NEXI-343 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 20/09/2019 Add two additional checks
                    && String.isNotBlank(newOrderHeader.OB_Rejection_Reason__c) //NEXI-344 Kinga Fornal <kinga.fornal@accenture.com>, 20.09.2019
                    && ( OB_UtilityConstants.REJECTION_ABSENT_DOCUMENTATION.equalsIgnoreCase( newOrderHeader.OB_Rejection_Reason__c )
                    || OB_UtilityConstants.REJECTION_INCOMPLETE_DOCUMENTATION.equalsIgnoreCase( newOrderHeader.OB_Rejection_Reason__c )
                    || newOrderHeader.OB_ApprovalStep__c == '4') //NEXI-344 Kinga Fornal <kinga.fornal@accenture.com>, 20.09.2019
                    && OB_Utility.checkStepsEntryCriteriaOrderHeader( newOrderHeader ) ) //NEXI-287 Marta Stempien <marta.stempien@accenture.com> 29/08/2019 Added check for meeting steps entry criteria
            {
                newOrdersMap.put( newOrderHeader.Id, newOrderHeader );
            }
            //NEXI-326 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Start
            else
            {
                newOrderHeader.OB_StartApprovalProcess__c = isStartApprovalOriginalValue;
            }
            //NEXI-326 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Stop
        }
        if ( newOrdersMap.size( ) > 0 )
        {
            startApproval( JSON.serialize( newOrdersMap ) );
        }
    }

    /*******************************************************************************
     Purpose: New approval process
     Parameters: String OrderJSON
     Returns: -
     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0	    Zuzanna Urban		 26/07/2019		    Created			 NEXI-217
     2.0        Marta Stempien       13/09/2019         Modified         NEXI-326
     ********************************************************************************/
    @future
    private static void startApproval( String OrderJSON )
    {
        Map<Id, NE__Order_Header__c> currentOrdersMap = ( Map<Id, NE__Order_Header__c> ) JSON.deserialize( OrderJSON, Map<Id, NE__Order_Header__c>.class );
        List<Approval.ProcessSubmitRequest> requestsApprovalList = new List<Approval.ProcessSubmitRequest>( );
        List<NE__Order_Header__c> orderHeaderList = new List<NE__Order_Header__c>( );
        for ( Id currentOrderId : currentOrdersMap.keySet( ) )
        {
            Approval.ProcessSubmitRequest requstApproval = new Approval.ProcessSubmitRequest( );
            requstApproval.setComments( 'Submitting request for approval.' );
            requstApproval.setObjectId( currentOrderId );
            requstApproval.setProcessDefinitionNameOrId( Label.OB_ApprovalProcessAcquiring );
            requstApproval.setSubmitterId( UserInfo.getUserId( ) );
            requstApproval.setSkipEntryCriteria( true );
            requestsApprovalList.add( requstApproval );
            orderHeaderList.add( currentOrdersMap.get( currentOrderId ) );
        }
        Approval.ProcessResult[] processResults = Approval.process( requestsApprovalList );
    }

    /*******************************************************************************
    Purpose:       Method checks if current Order Header was approved by AVR SOS Web Service.
                   If yes, add to returned set of Ids
    Parameters:    Set<Id> inRejectedOrderHeadersIds
    Returns:       Set<String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0	        Joanna Mielczarek		16/10/2019		Created			NEXI-368
    ********************************************************************************/
    private static void checkIfAvrSosReply( Set<String> inRejectedOrderHeadersIds )
    {
        System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.checkIfAvrSosReply START data ' + inRejectedOrderHeadersIds );

        if ( inRejectedOrderHeadersIds.isEmpty( ) )
        {
            System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.checkIfAvrSosReply END null set' );
            return;
        }

        Map<Id, List<Plc_Log__c>> plcLogsToCheck = new Map<Id, List<Plc_Log__c>>( );
        for ( Plc_Log__c loopPlcLog :
        [
                SELECT  CreatedDate,
                        OB_OrderId__r.NE__Order_Header__c,
                        Plc_RequestBody__c
                FROM Plc_Log__c
                WHERE OB_OrderId__r.NE__Order_Header__c != NULL
                AND OB_OrderId__r.NE__Order_Header__c IN :inRejectedOrderHeadersIds
                AND Plc_RequestURI__c = '/UpdateDossierSOS/*'
        ])
        {
            Id loopOrderHeaderId = loopPlcLog.OB_OrderId__r.NE__Order_Header__c;
            if ( plcLogsToCheck.containsKey( loopOrderHeaderId ) )
            {
                plcLogsToCheck.get( loopOrderHeaderId ).add( loopPlcLog );
            }
            else
            {
                plcLogsToCheck.put( loopOrderHeaderId, new List<Plc_Log__c> {loopPlcLog} );
            }
        }

        for ( Id orderHeaderId : plcLogsToCheck.keySet( ) )
        {
            String lastRequestBody;
            Datetime pastDate = Datetime.newInstance( 1900, 01, 01 );
            for ( Plc_Log__c loopPlcLog : plcLogsToCheck.get( orderHeaderId ) )
            {
                if ( loopPlcLog.CreatedDate > pastDate )
                {
                    pastDate = loopPlcLog.CreatedDate;
                    lastRequestBody = loopPlcLog.Plc_RequestBody__c;
                }
            }
            if ( itemRejectedByAvrSos( lastRequestBody ) )
            {
                inRejectedOrderHeadersIds.remove( orderHeaderId );
            }
        }

        System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.checkIfAvrSosReply END result : ' + inRejectedOrderHeadersIds );
    }

    /*******************************************************************************
    Purpose:       Method checks if Order Header was rejected by AVR SOS system
    Parameters:    String inRequestBody
    Returns:       Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0	        Joanna Mielczarek		16/10/2019		Created			NEXI-368
    ********************************************************************************/
    private static Boolean itemRejectedByAvrSos( String inRequestBody )
    {
        System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.itemRejectedByAvrSos START : ' + inRequestBody );

        if ( String.isBlank( inRequestBody ) )
        {
            System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.itemRejectedByAvrSos END empty param' );
            return false;
        }
        try
        {
            OB_UpdateDossierSOS.AvrSOS requestAvrSOS = ( OB_UpdateDossierSOS.AvrSOS ) JSON.deserialize( inRequestBody, OB_UpdateDossierSOS.AvrSOS.class );
            if ( OB_UpdateDossierSOS.CODE_KO.equalsIgnoreCase( requestAvrSOS.requestOutcome ) )
            {
                System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.itemRejectedByAvrSos END order header rejected by avr sos' );
                return true;
            }
        } catch ( Exception exc )
        {
            System.debug( LoggingLevel.ERROR, 'OB_OrderHeaderTriggerHandler.itemRejectedByAvrSos Exception: ' + exc.getMessage( ) +
                    ' at line: ' + exc.getLineNumber( ) + ' stack trace : ' + exc.getStackTraceString( ) );
        }

        System.debug( LoggingLevel.FINE, 'OB_OrderHeaderTriggerHandler.itemRejectedByAvrSos END order header approved by avr sos' );
        return false;
    }
}