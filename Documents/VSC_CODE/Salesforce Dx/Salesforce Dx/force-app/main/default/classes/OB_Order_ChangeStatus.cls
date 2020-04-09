/*****************************************************************
Name: OB_Order_ChangeStatus
Copyright © 2016 ITC
==================================================================
Purpose:  Class handles logic for Order status changes
    (OB_Nexi_OrderStatus__c and OB_Bank_OrderStatus__c)

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Marta Stempien          24/04/2019         Created           NEXI-20
********************************************************************************/
public with sharing class OB_Order_ChangeStatus
{
    public static final String ORDER_STATUS_AML_CONTROLS = 'AML Controls';
    public static final String ORDER_STATUS_APPROVED_PRICING = 'Draft - approved pricing';
    public static final String ORDER_STATUS_BANK_VERIFICATION = 'Bank verification';
    public static final String ORDER_STATUS_CANCELLED = 'Cancelled';
    public static final String ORDER_STATUS_DRAFT = 'Draft';
    public static final String ORDER_STATUS_DRAFT_INCOMPLETE_ORDER = 'Draft - incomplete order';
    public static final String ORDER_STATUS_DRAFT_REJECTED_PRICING = 'Draft - rejected pricing';
    public static final String ORDER_STATUS_ECONONOMIC_CONDITIONS_APPROVAL = 'Economic conditions approval';
    public static final String ORDER_STATUS_INSTALLED = 'Installed';
    public static final String ORDER_STATUS_KO_MONETICA = 'KO Monetica';
    public static final String ORDER_STATUS_MISSING_INFORMATION = 'Missing information';
    public static final String ORDER_STATUS_OK_MONETICA = 'OK Monetica';
    public static final String ORDER_STATUS_OPERATION_CONTROLS = 'Operations Controls';
    public static final String ORDER_STATUS_ORDER_CANCELLED = 'Order cancelled';
    public static final String ORDER_STATUS_ORDER_FULFILLED = 'Order fulfilled';
    public static final String ORDER_STATUS_ORDER_FULFILLED_PARTIALLY = 'Order fulfilled partially';
    public static final String ORDER_STATUS_ORDER_TO_BE_COMPLETED = 'Order to be completed';
    public static final String ORDER_STATUS_PROCEDURE_NEXI_PROCESSING = 'Procedure in Nexi processing';
    public static final String ORDER_STATUS_PROCEDURE_REFUSED = 'Procedure Refused';
    public static final String ORDER_STATUS_SECURITY_CHECKS = 'Security checks';
    public static final String ORDER_STATUS_SENDER_DISCARD = 'Sender discard';
    public static final String ORDER_STATUS_SENT = 'Sent';
    public static final String ORDER_STATUS_UPLOADED = 'Uploaded (eW)';
    public static final String ORDER_STATUS_WAITING_FOR_PROCESSING = 'Waiting for processing';

    /*******************************************************************************
    Purpose:  Method sets values of fields of NE__Order__c if the following conditions are fulfilled
    Parameters: (Map<Id, NE__Order__c> newMap, Map<Id, NE__Order__c> oldMap)
    Returns: -

    History
    --------
    VERSION        AUTHOR              DATE            DETAIL          Description
    1.0        Marta Stempien       13/05/2019        Created           NEXI-46
    1.1        Marta Stempien       20/05/2019        Created           NEXI-46
    ********************************************************************************/
    public static void setOrderStatus( Map<Id, NE__Order__c> newMap, Map<Id, NE__Order__c> oldMap )
    {  
        Map <Id, NE__OrderItem__c> orderItemsToUpdate = new Map <Id, NE__OrderItem__c>( );
        Set<Id> orderHeaderIds = new Set<Id>( );
        Set<Id> completedOrderIds = new Set <Id>( );
        List<Asset> assetsToUpdate = new List<Asset>(); //francesca.ribezzi 20/11/19 - PROD-69_v2 adding list of assets to update

        for ( Id orderId : newMap.keySet( ) )
        {
            orderHeaderIds.add( newMap.get( orderId ).NE__Order_Header__c );
            if ( OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED.equalsIgnoreCase( newMap.get( orderId ).OB_FulfilmentStatus__c ) )
            {               
                completedOrderIds.add( orderId );
            }
        }


        Map<Id, NE__Order_Header__c> orderHeadersByIds = new Map<Id, NE__Order_Header__c>
                ( [
                        SELECT Id,
                                OB_In_Approvazione_a__c,
                                OB_Rejection_Reason__c,
                                OB_AcquiringApproval__c,
                                OB_StartApprovalProcess__c,
                                OB_Main_Process__c,//simone misani R1F2-173 05/06/2019
                                OB_Sub_Process__c//simone misani F2WAVE2-58 11/07/2019
                        FROM NE__Order_Header__c
                        WHERE Id IN:orderHeaderIds
                ] );

        Map <Id, Set < NE__OrderItem__c>> orderItemsByCompletedOrdersIds = new Map <Id, Set < NE__OrderItem__c>> ( );

        for ( NE__OrderItem__c oOrderItem :
        [
                SELECT Id, OB_FulfilmentStatus__c, NE__OrderId__c, RecordType.Name
                FROM NE__OrderItem__c
                WHERE ( OB_FulfilmentStatus__c = :OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED
                OR OB_FulfilmentStatus__c = :OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED)
                // AND NE__Root_Order_Item__c = null simone misani R1F2-173 10-06/2019
                AND NE__Action__c !='None'  //simone misani R1F2-173 10-06/2019   
                AND NE__OrderId__c IN :completedOrderIds
        ] )
        {
            if ( orderItemsByCompletedOrdersIds.get( oOrderItem.NE__OrderId__c ) == null )
            {
                Set < NE__OrderItem__c > orderItems = new Set <NE__OrderItem__c> ( );
                orderItems.add( oOrderItem );
                orderItemsByCompletedOrdersIds.put( oOrderItem.NE__OrderId__c, orderItems );
            }
            else
            {
                orderItemsByCompletedOrdersIds.get( oOrderItem.NE__OrderId__c ).add( oOrderItem );
            }
        }
        for ( NE__Order__c orderNew : newMap.values() )
        {
            NE__Order__c oldOrder = oldMap.get( orderNew.Id );
            if ( ( orderNew.OB_PricingApproval__c != oldOrder.OB_PricingApproval__c )
                    || ( orderNew.OB_BankApprovalStatus__c != oldOrder.OB_BankApprovalStatus__c )
                    || ( orderNew.OB_ApprovalType__c != oldOrder.OB_ApprovalType__c )
                    || ( orderNew.OB_CancelledByBank__c != oldOrder.OB_CancelledByBank__c )
                    || ( orderNew.OB_ApprovalBIO__c != oldOrder.OB_ApprovalBIO__c )
                    || ( orderNew.OB_FulfilmentStatus__c != oldOrder.OB_FulfilmentStatus__c ) )
            {
                if ( orderItemsByCompletedOrdersIds.containsKey( orderNew.Id ) )
                {                   
                    for ( NE__OrderItem__c oOrderItem : setOrderStatusOrderFulfilledOrPartiallyFulfilled( orderNew, orderItemsByCompletedOrdersIds.get( orderNew.Id ) ) )
                    {
                        orderItemsToUpdate.put( oOrderItem.id, oOrderItem );
                    }
                }
                else
                {
                    changeNexiOrderStatusWhenOrderUpdated( orderNew, orderHeadersByIds.get( orderNew.NE__Order_Header__c ) );
                }
            }
            //francesca.ribezzi 19/11/19 - PROD-69 - calling updateMerchantTakeOverOnAsset if the order status is cancelled - subentro process
            if(orderNew.NE__OrderStatus__c  == OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED){
                Asset tempAsset = OB_Utility.updateMerchantTakeOverOnAsset(orderNew.OB_Takeover_OfferAsset__c, oldOrder.NE__OrderStatus__c);  
                if(tempAsset != null){ 
                    assetsToUpdate.add(tempAsset);  //francesca.ribezzi 20/11/19 - PROD-69_v2 adding asset to list if the method does not return null
                }
            }
        }
        if(assetsToUpdate.size() > 0){  //francesca.ribezzi 20/11/19 - PROD-69_v2 - updating asset list 
            update assetsToUpdate; 
        }
        List <NE__OrderItem__c> allOrderItemsToUpdate = new List<NE__OrderItem__c>( );
        allOrderItemsToUpdate.addAll( orderItemsToUpdate.values( ) );

        try
        {
            update allOrderItemsToUpdate;
        }
        catch ( DmlException dmlException )
        {
            System.debug( LoggingLevel.ERROR, 'Exception during update OrderItems : ' + dmlException );
        }

    }

    /*******************************************************************************
	Purpose:  Method sets values of fields of NE__Order__c if user click button 'ridefinisci prezzi' due to a pricing refusal
    Parameters: NE__Order__c orderToUpdate
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-20_order_status_handleLogic
    ********************************************************************************/
    public static void setOrderStatusDraft( NE__Order__c orderToUpdate )
    {
        if ( orderToUpdate == null )
        {
            return;
        }
        orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_DRAFT;        
        orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_DRAFT;
        //START----simone misani RI-90 05/06/2019
        orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );
        orderToUpdate.OB_Bank_LastStatusChange__c= System.now( );
        //END----simone misani RI-90 05/06/2019
    }

    /*******************************************************************************
	Purpose:  Method sets values of fields of NE__Order__c if user clicked button 'riprendi convenzionamento' after pricing approval
	          or fulfilment status is draft and user is in 'Operational Data' step
	          or user re-enter the flow after 'save' order - 'Draft - incomplete order' status
    Parameters: NE__Order__c orderToUpdate, Boolean isResumeAgreement, Boolean isOperationalDataStep, Boolean isReEntered
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-20_order_status_handleLogic
 	2.0         Joanna Mielczarek       05/06/2019      Modified        NEXI-99 removed update from loop
 	********************************************************************************/
    public static NE__Order__c setOrderStatusDraftIncompleteOrder( NE__Order__c orderToUpdate, Boolean isResumeAgreement,
            Boolean isOperationalDataStep, Boolean isReEntered )
    {
        if ( orderToUpdate != null &&
                (
                    ( isResumeAgreement != null && isResumeAgreement ) ||
                    ( isReEntered != null && isReEntered ) ||
                    ( isOperationalDataStep != null && isOperationalDataStep &&
                      OB_UtilityConstants.FULFILMENTSTATUS_DRAFT.equalsIgnoreCase( orderToUpdate.OB_FulfilmentStatus__c ) )
                )
            )
        {
            orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER;
            orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER;
            //START----simone misani RI-90 05/06/2019
            orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );
            orderToUpdate.OB_Bank_LastStatusChange__c= System.now( );
            //END----simone misani RI-90 05/06/2019

            return orderToUpdate;
        }

        return new NE__Order__c( );
    }

    /*******************************************************************************
	Purpose:  Method sets values of fields of NE__Order__c if user save order on 'Company Data' step
	          - 'Order to be completed' - status
    Parameters: NE__Order__c orderToUpdate
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       26/04/2019      Created         NEXI-22_order_status_saveAsDraft
 	********************************************************************************/
    public static void setOrderStatusOrderToBeCompleted( NE__Order__c orderToUpdate )
    {
        if ( orderToUpdate == null )
        {
            return;
        }

        orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_ORDER_TO_BE_COMPLETED;
        orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_ORDER_TO_BE_COMPLETED;
        //START----simone misani RI-90 05/06/2019
        orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );
        orderToUpdate.OB_Bank_LastStatusChange__c= System.now( );
        //END----simone misani RI-90 05/06/2019
        //giovanni spinelli - start - 23/08/2019 - deletion field OB_CheckResumeFlow__c
        orderToUpdate.OB_CheckResumeFlow__c= '';
        //giovanni spinelli - end   - 23/08/2019 - deletion field OB_CheckResumeFlow__c

        try
        {
            update orderToUpdate;
        }
        catch ( DmlException dmlException )
        {
            System.debug( LoggingLevel.ERROR, 'Exception during update Order : ' + dmlException );
        }
    }

    /*******************************************************************************
    Purpose: Methods sets OB_Nexi_OrderStatus and OB_Bank_OrderStatus after change of
    specified fields of NE__Order__c.
    Parameters:  NE__Order__c orderToUpdate, Set < NE__OrderItem__c> orderItems
    Returns: Set <NE__OrderItem__c> orderItemsToUpdate

    History
    --------
    VERSION        AUTHOR              DATE            DETAIL          Description
    1.0        Marta Stempien       25/04/2019        Created             NEXI-46
    1.1        Marta Stempien       20/05/2019        Created             NEXI-46
    ********************************************************************************/
    private static Set <NE__OrderItem__c> setOrderStatusOrderFulfilledOrPartiallyFulfilled( NE__Order__c orderToUpdate, Set < NE__OrderItem__c> orderItems )
    {        
        Boolean isCompleted = true;
        Set < NE__OrderItem__c > orderItemsToUpdate = new Set <NE__OrderItem__c>( );
        

        for ( NE__OrderItem__c orderItemToUpdate : orderItems )
        {
            if ( OB_UtilityConstants.POS_RT.equalsIgnoreCase( orderItemToUpdate.RecordType.Name ) )
            {               
                orderItemToUpdate.OB_Nexi_OrderItemStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED.equalsIgnoreCase( orderItemToUpdate.OB_FulfilmentStatus__c ) ? OB_Order_ChangeStatus.ORDER_STATUS_INSTALLED : OB_Order_ChangeStatus.ORDER_STATUS_CANCELLED;
                orderItemsToUpdate.add( orderItemToUpdate );
            }
            isCompleted = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED.equalsIgnoreCase( orderItemToUpdate.OB_FulfilmentStatus__c ) && isCompleted ? isCompleted : false;
        }
        
        if ( isCompleted )
        {            
            orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_ORDER_FULFILLED;
            orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_ORDER_FULFILLED;
            
        }
        else
        {
            orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_ORDER_FULFILLED_PARTIALLY;
            orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_ORDER_FULFILLED_PARTIALLY;
        }
        //START----simone misani RI-90 05/06/2019
            orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );
            orderToUpdate.OB_Bank_LastStatusChange__c= System.now( );
        //END----simone misani RI-90 05/06/2019
        return orderItemsToUpdate;

    }
    /*******************************************************************************
    Purpose: Methods sets OB_Nexi_OrderStatus and OB_Bank_OrderStatus after change of
    specified fields of NE__Order__c.
    Parameters: NE__Order__c orderToUpdate, NE__Order_Header__c oOrderHeader
    Returns: -

    History
    --------
    VERSION        AUTHOR              DATE            DETAIL          Description
    1.0        Marta Stempien       25/04/2019        Created           NEXI-46
    1.1        Marta Stempien       20/05/2019        Created           NEXI-46
    ********************************************************************************/

    @testVisible
    private static void changeNexiOrderStatusWhenOrderUpdated( NE__Order__c orderToUpdate, NE__Order_Header__c oOrderHeader )
    {
        System.debug( LoggingLevel.FINE, 'OB_Order_ChangeStatus.changeNexiOrderStatusWhenOrderUpdated START order: ' + orderToUpdate + ' orderHeader: ' + oOrderHeader );
        if ( orderToUpdate == null )
        {
            return;
        }
        // NEXI-357 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 08/10/2019 START not proceed if order header was rejected
        if ( oOrderHeader != null && OB_UtilityConstants.REJECTION_REASON_FINAL_REJ.equalsIgnoreCase( oOrderHeader.OB_Rejection_Reason__c ) )
        {
            System.debug( LoggingLevel.DEBUG, 'OB_Order_ChangeStatus.changeNexiOrderStatusWhenOrderUpdated END final rejection on Order Header' );
            return;
        }
        // NEXI-357 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 08/10/2019 STOP
        // R1F2-240 - 12/06/2019 - <daniele.gandini@accenture.com> - logic for setting OB_FulfilmentStatus__c in SENT - START
        if  (   oOrderHeader != null 
                &&
                orderToUpdate.OB_FulfilmentStatus__c != OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED
                &&
                (   
                    oOrderHeader.OB_Main_Process__c == OB_UtilityConstants.MAINTENANCE
                    && 
                    (
                        OB_UtilityConstants.ORDER_APPROVALSTATUS_APPROVATOBIO.equalsIgnoreCase(orderToUpdate.OB_ApprovalStatus__c) 
                        || 
                        (
                            OB_UtilityConstants.ORDER_APPROVALSTATUS_APPROVATOPRICING.equalsIgnoreCase(orderToUpdate.OB_ApprovalStatus__c) 
                            && 
                            orderToUpdate.OB_AgreedChanges__c == false &&  OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA.equalsIgnoreCase(oOrderHeader.OB_Sub_Process__c)//Simone Misani 11/07/2019   WN-58
                        )
                    )
                )
            )
            {
                orderToUpdate.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_SENT; 
            }
            // R1F2-240 - 12/06/2019 - <daniele.gandini@accenture.com> - logic for setting OB_FulfilmentStatus__c in SENT - START                       
              

            System.debug('orderToUpdate.OB_FulfilmentStatus__c: '+orderToUpdate.OB_FulfilmentStatus__c);  
        
        if ( OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED.equalsIgnoreCase( orderToUpdate.OB_FulfilmentStatus__c ) )
        {
            if ( orderToUpdate.OB_CancelledByBank__c )
            {
                orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_ORDER_CANCELLED;
                orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_ORDER_CANCELLED;
            }
            else
            {
                orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED;
                orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_REFUSED;
            }
            //START----simone misani RI-90 05/06/2019
            orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );
            orderToUpdate.OB_Bank_LastStatusChange__c= System.now( );
            //END----simone misani RI-90 05/06/2019
        }

        else if ( OB_UtilityConstants.FULFILMENTSTATUS_DRAFT.equalsIgnoreCase( orderToUpdate.OB_FulfilmentStatus__c )
                && orderToUpdate.OB_PricingApproval__c != null && OB_UtilityConstants.PRICING.equalsIgnoreCase( orderToUpdate.OB_ApprovalType__c ) )
        {
            if ( !orderToUpdate.OB_PricingApproval__c && OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO.equalsIgnoreCase( orderToUpdate.OB_BankApprovalStatus__c ) )
            {
                orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_REJECTED_PRICING;
                orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_REJECTED_PRICING;
            }
            else if ( OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO.equalsIgnoreCase( orderToUpdate.OB_BankApprovalStatus__c ) && orderToUpdate.OB_PricingApproval__c )
            {
                orderToUpdate.OB_Nexi_OrderStatus__c = ORDER_STATUS_APPROVED_PRICING;
                orderToUpdate.OB_Bank_OrderStatus__c = ORDER_STATUS_APPROVED_PRICING;
            }
            //START----simone misani RI-90 05/06/2019
            orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );
            orderToUpdate.OB_Bank_LastStatusChange__c= System.now( );
            //END----simone misani RI-90 05/06/2019
        }

        else if ( OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE.equalsIgnoreCase( orderToUpdate.OB_FulfilmentStatus__c )
                && OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE.equalsIgnoreCase( orderToUpdate.OB_BankApprovalStatus__c ) )
        {
            if ( OB_UtilityConstants.PRICING.equalsIgnoreCase( orderToUpdate.OB_ApprovalType__c ) )
            {
                orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_ECONONOMIC_CONDITIONS_APPROVAL;
                orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_ECONONOMIC_CONDITIONS_APPROVAL;
            }
            else if ( OB_UtilityConstants.BIO.equalsIgnoreCase( orderToUpdate.OB_ApprovalType__c ) )
            {
                orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_BANK_VERIFICATION;
                orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_BANK_VERIFICATION;
            }
            //START----simone misani RI-90 05/06/2019
            orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );
            orderToUpdate.OB_Bank_LastStatusChange__c= System.now( );
            //END----simone misani RI-90 05/06/2019
        }

        else if ( OB_UtilityConstants.FULFILMENTSTATUS_PENDING.equalsIgnoreCase( orderToUpdate.OB_FulfilmentStatus__c )
                && OB_UtilityConstants.BIO.equalsIgnoreCase( orderToUpdate.OB_ApprovalType__c ) )
        {
            if ( OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO.equalsIgnoreCase( orderToUpdate.OB_BankApprovalStatus__c ) )
            {
                orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_NEXI_PROCESSING;
                //START----simone misani RI-90 05/06/2019
                orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );
                orderToUpdate.OB_Bank_LastStatusChange__c= System.now( );
                //END----simone misani RI-90 05/06/2019
            }
            else if ( OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO.equalsIgnoreCase( orderToUpdate.OB_BankApprovalStatus__c ) && orderToUpdate.OB_ApprovalBIO__c != null && orderToUpdate.OB_ApprovalBIO__c == false )
            {
                orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER;
                orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER;
                //START----simone misani RI-90 05/06/2019
                orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );
                orderToUpdate.OB_Bank_LastStatusChange__c= System.now( );
                //END----simone misani RI-90 05/06/2019
            }
            else if ( oOrderHeader == null )
            {
                return;
            }
            else
            {
                changeOrderStatus ( oOrderHeader, orderToUpdate );
            }
        }
        else if (   OB_UtilityConstants.FULFILMENTSTATUS_SENT.equalsIgnoreCase( orderToUpdate.OB_FulfilmentStatus__c)
                ||  OB_UtilityConstants.FULFILMENTSTATUS_FAILED.equalsIgnoreCase( orderToUpdate.OB_FulfilmentStatus__c) 
                )
        { 
            orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_NEXI_PROCESSING;
            orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_WAITING_FOR_PROCESSING;
            //START----simone misani RI-90 05/06/2019
            orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );
            orderToUpdate.OB_Bank_LastStatusChange__c= System.now( );
            //END----simone misani RI-90 05/06/2019
        }
    }

    /*******************************************************************************
    Purpose:    Method sets values of fields OB_In_Approvazione_a__c, OB_Bank_OrderStatus__c, OB_Bank_LastStatusChange__c of NE__Order__c
                if the following conditions are fulfilled from NE__Order_Header__c and NE__Order__c
    Parameters: NE__Order_Header__c, NE__Order__c order
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       16/05/2019      Created         NEXI-52
    ********************************************************************************/
    public static NE__Order__c changeOrderStatus( NE__Order_Header__c oHeader, NE__Order__c orderToUpdate )
    {
        if ( oHeader.OB_StartApprovalProcess__c == false && ( OB_UtilityConstants.REJECTION_MISSING_DOCUMENTATION.equalsIgnoreCase( oHeader.OB_Rejection_Reason__c ) || OB_UtilityConstants.REJECTION_INCOMPLETE_DOCUMENTATION.equalsIgnoreCase( oHeader.OB_Rejection_Reason__c ) ) )
        {
            orderToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION;
            
        }

        if ( oHeader.OB_StartApprovalProcess__c )
        {
            if ( oHeader.OB_AcquiringApproval__c )
            {
                return orderToUpdate;
            }
            if ( OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS.equalsIgnoreCase( oHeader.OB_In_Approvazione_a__c ) )
            {
                orderToUpdate.OB_Nexi_OrderStatus__c = ORDER_STATUS_OPERATION_CONTROLS;
                
            }
            else if ( OB_UtilityConstants.FASECONTROL_CONTROLS_AML.equalsIgnoreCase( oHeader.OB_In_Approvazione_a__c ) )
            {
                orderToUpdate.OB_Nexi_OrderStatus__c =  ORDER_STATUS_AML_CONTROLS;
                 
            }
            else if ( OB_UtilityConstants.FASECONTROL_SECURITY_CHECKS.equalsIgnoreCase( oHeader.OB_In_Approvazione_a__c ) )
            {
                orderToUpdate.OB_Nexi_OrderStatus__c = ORDER_STATUS_SECURITY_CHECKS;
                
            }
        }
        else
        {
            if ( OB_UtilityConstants.REJECTION_ABSENT_DOCUMENTATION.equalsIgnoreCase( oHeader.OB_Rejection_Reason__c )
                    || OB_UtilityConstants.REJECTION_INCOMPLETE_DOCUMENTATION.equalsIgnoreCase( oHeader.OB_Rejection_Reason__c ) )
            {
                orderToUpdate.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION;
                
            }
        }
        orderToUpdate.OB_Nexi_LastStatusChange__c= System.now( );//simone misani RI-90 05/06/2019
        return orderToUpdate;
    }

    /*******************************************************************************
    Purpose:    Method updates Orders from given list
    Parameters: List<NE__Order__c> ordersToUpdate
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       05/06/2019      Created         NEXI-99
    ********************************************************************************/
    public static void updateOrdersStatus( List<NE__Order__c> ordersToUpdate )
    {
        try
        {
            update ordersToUpdate;
        }
        catch ( DmlException dmlException )
        {
            System.debug( LoggingLevel.ERROR, 'Exception during update Orders : ' + dmlException );
        }
    }
}