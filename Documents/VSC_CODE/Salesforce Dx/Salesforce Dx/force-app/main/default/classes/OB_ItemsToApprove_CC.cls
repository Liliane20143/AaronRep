//  micol.ferrari 24/12/2018 - THIS CLASS IS THE CONTROLLER OF OB_ItemsToApprove, OB_ItemsApprovalStatus, OB_OrdersToApprove
global without sharing class OB_ItemsToApprove_CC 
{

    @AuraEnabled
    global static User getUserInformation()
    {
        User contextUser = null;
        String userId = UserInfo.getUserId();
        List<User> listOfUsers =
        [
                SELECT Id,
                                            Name,
                                            ContactId,
                                            ProfileId,
                                            OB_CAB__c,
                                            Profile.Name,
                                            Profile.UserLicense.Name,
                                            Contact.Account.OB_ABI__c 
                                    FROM User 
                                    WHERE Id=: userId 
                LIMIT 1
        ];
        if (!listOfUsers.isEmpty())
        {
            contextUser = listOfUsers.get(0);
        }

        return contextUser;
    }

    /*******************************************************************************
    Purpose:  THIS METHOD IS USED IN BOTH OB_ItemsToApprove AND OB_OrderToApprove
    Parameters: String contextABI, String contextCAB
    Returns: List<Map<String, String>>

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Micol Ferrari       24/12/2018    Created    -
    2.0       Joanna Mielczarek   03/04/2019    Updated    added new filter - pricing approval, splitted method to shorter private methods
    3.0       Joanna Mielczarek   10/04/2019    Updated    changed way of orders visible to users - based on order owner
    4.0       Joanna Mielczarek   11/04/2019    Updated    fixed visibility of orders to users with different profiles due to its belonging to queue
    5.0       Joanna Mielczarek   08/05/2019    Updated    added field 'OB_Bank_OrderStatus__c' to query
    ********************************************************************************/
    @AuraEnabled
    global static List<Map<String, String>> retrieveItemsToApprove( String contextABI, String contextCAB , String filterValue )
    {
        System.debug('INSIDE OB_ItemsToApprove_CC.retrieveItemsToApprove');

        List<Map<String,String>> toReturn                           = new List<Map<String,String>>();
        Map<String,NE__Order__c> mapOfConfigurations                = new Map<String,NE__Order__c>();
        List<ProcessInstanceWorkitem> listOfProcessInstanceWorkitem = OB_ItemsToApprove_CC.getInstanceWorkitems( );

        contextABI = ( contextABI == null ) ? contextABI : String.escapeSingleQuotes( contextABI );
        contextCAB = ( contextCAB == null ) ? contextCAB : String.escapeSingleQuotes( contextCAB );
        String splittedCABs = OB_MainUtil.explodeString( contextCAB, ';' );//NEXI-006 grzegorz.banach@accenture.com 19/03/2019

        if ( !listOfProcessInstanceWorkitem.isEmpty( ) )
        {
            List<Id> listOfConfigurationId = OB_ItemsToApprove_CC.getConfigurationIds( listOfProcessInstanceWorkitem );
            String ordersIds = String.join( listOfConfigurationId, ';' );
            ordersIds = OB_MainUtil.explodeString( ordersIds, ';' );
            //  micol.ferrari 24/12/2018 - ADDED FIELDS TO THE ORDER QUERY: OB_ApprovalType__c,OB_ApprovalStatus__c
            String queryNEOrder = 'SELECT Id, Name, OB_ABI__c, OB_CAB__c, NE__AccountId__c, NE__OrderStatus__c, CreatedBy.LastName, ' +
                    'CreatedBy.FirstName, NE__Order_Header__c, NE__Order_Header__r.Name, OB_ApprovalType__c, OB_ApprovalStatus__c, ' +
                    'OB_FulfilmentStatus__c, NE__Order_Header__r.OB_Main_Process__c, NE__Order_Header__r.OB_Sub_Process__c, ' +
                    // R1F2_RP_008 <joanna.mielczarek@accenture.com> 11/04/2019 START
                    'NE__AccountId__r.NE__VAT__c, NE__AccountId__r.NE__Fiscal_code__c, NE__AccountId__r.Name ' +
                    // R1F2_RP_008 <joanna.mielczarek@accenture.com> 11/04/2019 STOP
                    // NEXI-43 <joanna.mielczarek@accenture.com> 08/05/2019 START
                    ', toLabel(OB_Bank_OrderStatus__c) ' +
                    // NEXI-43 <joanna.mielczarek@accenture.com> 08/05/2019 STOP
                    'FROM NE__Order__c WHERE Id IN ' + ordersIds + ' AND OB_ABI__c = \'' + contextABI + '\'';
            //giovanni spinelli - start - 16/07/2019 add a where condition if tab is opened from home page
            if(!String.isBlank(filterValue)){
                queryNEOrder          += ' AND OB_Bank_OrderStatus__c = \''+filterValue.split('_')[0]+'\' ';
                queryNEOrder          += ' AND NE__Type__c = \''+filterValue.split('_')[1]+'\' ';
            }
            //Giovanni spinelli - end - 16/07/2019 add a where condition if tab is opened from home page            
            Id currentUserId = getUserInformation( ).Id;
            String currentUserProfileName = getUserInformation( ).Profile.Name;

            if ( !String.isBlank( contextCAB ) )
            {
                queryNEOrder += ' AND OB_CAB__c != NULL';
                if ( OB_UtilityConstants.NEXI_PARTNER_APPROVER_L1_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName ) )
                {
                    queryNEOrder += ' AND OB_CAB__c = \'' + contextCAB + '\'';
                }
                else if ( OB_UtilityConstants.NEXI_PARTNER_APPROVER_L2_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName ) )
                {
                    queryNEOrder += ' AND OB_CAB__c IN ' + splittedCABs;
                }
            }

            List<OB_ConfigurationInformation__mdt> listOfConfigurationInformation_BIOApproval =
                    OB_ItemsToApprove_CC.getConfigurationInformationBIOApproval( );
            if ( !listOfConfigurationInformation_BIOApproval.isEmpty( ) )
            {
                if ( !OB_UtilityConstants.NEXI_PARTNER_APPROVER_L3_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName ) )
                {
                    queryNEOrder += ' AND OB_ApprovalType__c != \'' + OB_UtilityConstants.APPROV_TYPE_BIO + '\'';
                }
            }

            Set<Id> setOfGroupIds = new Set<Id>( );
            for ( List<GroupMember> loopGroupMembers : [ SELECT GroupId FROM GroupMember WHERE UserOrGroupId = :currentUserId ] )
            {
                for ( GroupMember loopMember : loopGroupMembers )
                {
                    setOfGroupIds.add( loopMember.GroupId );
                }
            }
            List<Id> listOfGroupIdsToQuery = new List<Id>( );
            listOfGroupIdsToQuery.addAll( setOfGroupIds );

            String groupIds = String.join( listOfGroupIdsToQuery, ';' );
            groupIds = OB_MainUtil.explodeString( groupIds, ';' );
            if ( currentUserProfileName.equalsIgnoreCase( OB_UtilityConstants.NEXI_PARTNER_APPROVER_L3_PROFILE_NAME ) )
            {
                queryNEOrder += ' AND (OwnerId IN ' + groupIds + ' OR OB_ApprovalType__c = \'' + OB_UtilityConstants.APPROV_TYPE_BIO + '\')';
            }
            else
            {
                queryNEOrder += ' AND OwnerId IN ' + groupIds + ' ';
            }
            System.debug('queryNEOrder: ' + queryNEOrder);
            List<NE__Order__c> ordersToReturn = Database.query( queryNEOrder );
            mapOfConfigurations = new Map<String, NE__Order__c>( ordersToReturn );

            if ( !mapOfConfigurations.isEmpty( ) )
            {
                toReturn = OB_ItemsToApprove_CC.getMapsOfSingleWorkItem( mapOfConfigurations, listOfProcessInstanceWorkitem );
            }
        }

        System.debug( 'OB_ItemsToApprove_CC.retrieveItemsToApprove - toReturn: ' + toReturn );
        return toReturn;
    }

    /*******************************************************************************
    Purpose:  Method returns list of ProcessInstanceWorkItem where target object type is NE__Order__c
    Parameters: -
    Returns: List<ProcessInstanceWorkitem>

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   03/04/2019    Created    -
    ********************************************************************************/
    private static List<ProcessInstanceWorkitem> getInstanceWorkitems( )
    {
        List<ProcessInstanceWorkitem> listOfProcessInstanceWorkitem =
        [
                SELECT Id,
                                                CreatedDate,
                                                ProcessInstance.TargetObjectId,
                                                ProcessInstance.TargetObject.Name
                                         FROM ProcessInstanceWorkitem
                                         WHERE ProcessInstance.TargetObject.Type = 'NE__Order__c'
                ORDER BY CreatedDate DESC
        ];

        return listOfProcessInstanceWorkitem;
    }

    /*******************************************************************************
    Purpose: Method returns list of NE__Order__c Ids
    Parameters: List<ProcessInstanceWorkitem> listOfProcessInstanceWorkitem
    Returns: List<Id>

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   03/04/2019    Created    -
    ********************************************************************************/
    private static List<Id> getConfigurationIds( List<ProcessInstanceWorkitem> listOfProcessInstanceWorkitem )
        {
            Set<Id> setOfConfigurationId    = new Set<Id>();
            List<Id> listOfConfigurationId  = new List<Id>();
            for (ProcessInstanceWorkitem workitem : listOfProcessInstanceWorkitem)
            {
            if ( workitem != null && workitem.ProcessInstance.TargetObjectId != null )
            {
                setOfConfigurationId.add(workitem.ProcessInstance.TargetObjectId);
            }
        }
            listOfConfigurationId.addAll(setOfConfigurationId);
 
        if ( !listOfConfigurationId.isEmpty( ) )
        {
            return listOfConfigurationId;
        }
        return new List<Id>( );
    }

    /*******************************************************************************
    Purpose: Method returns list of Configuration Information for OB_ItemsToApprove_CC, Nexi Partner Approver L3
    Parameters: -
    Returns: List<OB_ConfigurationInformation__mdt>

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   03/04/2019    Created    -
    ********************************************************************************/
    private static List<OB_ConfigurationInformation__mdt> getConfigurationInformationBIOApproval( )
            {               
        List<OB_ConfigurationInformation__mdt> listOfConfigurationInformation = new List<OB_ConfigurationInformation__mdt>( );
        for ( OB_ConfigurationInformation__mdt loopInformation :
        [
                SELECT Id, OB_String_Value_2__c
                FROM OB_ConfigurationInformation__mdt
                WHERE QualifiedApiName = :OB_ItemsToApprove_CC.class.getName( )
                AND OB_String_Value__c = :OB_UtilityConstants.NEXI_PARTNER_APPROVER_L3_PROFILE_NAME
                LIMIT 1
        ] )
        {
            if ( loopInformation.OB_String_Value_2__c.equalsIgnoreCase( 'true' ) )
            {
                listOfConfigurationInformation.add( loopInformation );
            }
        }

        return listOfConfigurationInformation;
    }

    /*******************************************************************************
    Purpose: Method returns list of maps of Single WorkItem
    Parameters: Map<String, NE__Order__c> mapOfConfigurations, List<ProcessInstanceWorkitem> listOfProcessInstanceWorkitem
    Returns: List<Map<String, String>>

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Joanna Mielczarek   03/04/2019    Created    -
    2.0       Joanna Mielczarek   11/04/2019    Updated    added elements to map
    3.0       Joanna Mielczarek   08/05/2019    Updated    added element to map - bankOrderStatus
    ********************************************************************************/
    @TestVisible
    private static List<Map<String, String>> getMapsOfSingleWorkItem( Map<String, NE__Order__c> mapOfConfigurations,
            List<ProcessInstanceWorkitem> listOfProcessInstanceWorkitem )
    {
        List<Map<String, String>> toReturn = new List<Map<String, String>>();
        for (ProcessInstanceWorkitem workitem : listOfProcessInstanceWorkitem)
        {
            NE__Order__c loopOrder = mapOfConfigurations.get(workitem.ProcessInstance.TargetObjectId);
            if (loopOrder == null) {
                continue;
            }

            Map<String, String> mapOfSingleWorkItem = new Map<String, String>();
            mapOfSingleWorkItem.put('workItemId', workitem.Id);
            mapOfSingleWorkItem.put('configurationId', loopOrder.Id);
            mapOfSingleWorkItem.put('configurationName', loopOrder.Name);
            mapOfSingleWorkItem.put('creationDate', workitem.CreatedDate.format());

            // PRODOB-80,  Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 23/04/2019 - START
            String firstName = mapOfConfigurations.get(workitem.ProcessInstance.TargetObjectId).CreatedBy.FirstName;
            if (firstName == null || firstName == '') {
                mapOfSingleWorkItem.put('configurationCreator', mapOfConfigurations.get(workitem.ProcessInstance.TargetObjectId).CreatedBy.LastName);
            } else {
                // PRODOB-80,  Doris Dongmo <doris.tatiana.dongmo@accenture.com>,  23/04/2019 - END
                mapOfSingleWorkItem.put('configurationCreator', mapOfConfigurations.get(workitem.ProcessInstance.TargetObjectId).CreatedBy.FirstName + ' ' + mapOfConfigurations.get(workitem.ProcessInstance.TargetObjectId).CreatedBy.LastName);
			}
		   mapOfSingleWorkItem.put('contextCAB', mapOfConfigurations.get(workitem.ProcessInstance.TargetObjectId).OB_CAB__c);
			mapOfSingleWorkItem.put('orderHeaderId', mapOfConfigurations.get(workitem.ProcessInstance.TargetObjectId).NE__Order_Header__c);
			// Salvatore Pianura <salvatore.pianura@accenture.com> 16/04/2019 R1F2-34 - Start
			String creatorNameConcatenated = String.isEmpty(loopOrder.CreatedBy.FirstName) ? loopOrder.CreatedBy.LastName : loopOrder.CreatedBy.FirstName + ' ' + loopOrder.CreatedBy.LastName;
			mapOfSingleWorkItem.put('configurationCreator', creatorNameConcatenated);
			// Salvatore Pianura <salvatore.pianura@accenture.com> 16/04/2019 R1F2-34 - End

			mapOfSingleWorkItem.put('contextCAB', loopOrder.OB_CAB__c);
			mapOfSingleWorkItem.put('orderHeaderId', loopOrder.NE__Order_Header__c);
			//  START   micol.ferrari 14/02/2019 - #1386
			mapOfSingleWorkItem.put('accountId', loopOrder.NE__AccountId__c);
			//  END     micol.ferrari 14/02/2019 - #1386
			mapOfSingleWorkItem.put('orderApprovalType', loopOrder.OB_ApprovalType__c);
			mapOfSingleWorkItem.put('orderHeaderName', loopOrder.NE__Order_Header__r.Name);
			// R1F2_RP_008 <joanna.mielczarek@accenture.com> 11/04/2019 START
			mapOfSingleWorkItem.put('contextABI', loopOrder.OB_ABI__c);
			mapOfSingleWorkItem.put('merchantName', loopOrder.NE__AccountId__r.Name);
			mapOfSingleWorkItem.put('merchantVAT', loopOrder.NE__AccountId__r.NE__VAT__c);
			mapOfSingleWorkItem.put('merchantFiscalCode', loopOrder.NE__AccountId__r.NE__Fiscal_code__c);
			// R1F2_RP_008 <joanna.mielczarek@accenture.com> 11/04/2019 STOP
			// NEXI-43 <joanna.mielczarek@accenture.com> 08/05/2019 START
			mapOfSingleWorkItem.put('bankOrderStatus', loopOrder.OB_Bank_OrderStatus__c);
			// NEXI-43 <joanna.mielczarek@accenture.com> 08/05/2019 STOP
			toReturn.add(mapOfSingleWorkItem);
        }

        if (!toReturn.isEmpty()) {
            return toReturn;
        }
        return new List<Map<String, String>>();
    }

    /*******************************************************************************
    Purpose: Method returns list of orders which fulfill given conditions
    Parameters: String contextABI, String contextCAB
    Returns: List<NE__Order__c>

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    2.0       Micol Ferrari       24/12/2018    Updated    ADDED FIELDS TO THE ORDER QUERY: OB_ApprovalType__c,OB_ApprovalStatus__c
                                                           ADDED TO WHERE CONDITION OB_ApprovalStatus__c !=: OB_UtilityConstants.ORDER_APPROVALSTATUS_APPROVATOBIO
    3.0       Micol Ferrari       15/01/2019    Updated    ADDED FIELDS TO THE ORDER QUERY: NE__Order_Header__r.OB_Main_Process__c
                                                           ADDED WHERE CONDITION ON MAIN PROCESS IF PARAM IS NOT EMPTY AND CAB
    4.0       Joanna Mielczarek   27/03/2019    Updated    refactored code, added new conditions to query
    5.0       Joanna Mielczarek   08/05/2019    Updated    added missing fields to query
    ********************************************************************************/

    // micol.ferrari 15/01/2019 - ADDED MAIN PROCESS AS PARAM
    @AuraEnabled
    global static List<NE__Order__c> retrieveConfigurationApproval(String contextABI, String contextCAB , String filterValue)
    {
        System.debug('INSIDE OB_ItemsToApprove_CC.retrieveConfigurationApproval');
        
        // NEX-006 joanna.mielczarek@accenture.com 27/03/2019 START
        contextABI = ( contextABI == null ) ? contextABI : String.escapeSingleQuotes( contextABI );
        contextCAB = ( contextCAB == null ) ? contextCAB : String.escapeSingleQuotes( contextCAB );
        // NEX-006 joanna.mielczarek@accenture.com 27/03/2019 STOP
        List<NE__Order__c> toReturn = null;
        String splittedCABs = OB_MainUtil.explodeString( contextCAB, ';' ); // NEX-006 joanna.mielczarek@accenture.com 27/03/2019

        //  START   micol.ferrari 15/01/2019 - QUERY STRING AND EDIT TO THE WHERE CONDITION
        String queryOnNEOrder = 'SELECT Id,Name,OB_CAB__c,OB_AgreedChanges__c,NE__Order_Header__c,NE__Order_Header__r.Name,' +
                'NE__Order_Header__r.OB_Main_Process__c, NE__Order_Header__r.OB_Sub_Process__c,NE__AccountId__c,' +
                'NE__AccountId__r.Name,OB_BankApprovalStatus__c,OB_ApprovalType__c,OB_ApprovalStatus__c,OB_FulfilmentStatus__c';
        // NEXI-43 <joanna.mielczarek@accenture.com> 08/05/2019 START
        queryOnNEOrder += ', toLabel(OB_Bank_OrderStatus__c), OB_ABI__c, NE__AccountId__r.NE__VAT__c, ' +
                'NE__AccountId__r.NE__Fiscal_code__c, CreatedDate, CreatedBy.FirstName, CreatedBy.LastName ';
        // NEXI-43 <joanna.mielczarek@accenture.com> 08/05/2019 STOP
        queryOnNEOrder          += ' FROM NE__Order__c ';
        queryOnNEOrder          += ' WHERE OB_ABI__c = \''+contextABI+'\' ';
        //START gianluigi.virga 22/07/2019 - PRODOB-86
        queryOnNEOrder          += ' AND OB_Bank_OrderStatus__c != \''+ System.Label.OB_OrderStatusOrderToBeCompleted + '\'';
        String draftIncomplete  = OB_utilityConstants.BANKORDERSTATUS_DRAFTINCOMPLETEORDER;
        String approvatoPricing = OB_utilityConstants.ORDER_APPROVALSTATUS_APPROVATOPRICING;
        String rifiutatoPricing = OB_utilityConstants.ORDER_APPROVALSTATUS_RIGETTATOPRICING;
        queryOnNEOrder          += ' AND ( ( OB_Bank_OrderStatus__c !=: draftIncomplete  or OB_ApprovalStatus__c!=: approvatoPricing  ) AND (  OB_Bank_OrderStatus__c !=: draftIncomplete  or OB_ApprovalStatus__c!=: rifiutatoPricing  ) )  ';//giovanni spinelli 01/08/2019 add filter in query
        //END gianluigi.virga 22/07/2019 - PRODOB-86
        //giovanni spinelli - start - 16/07/2019 add a where condition if tab is opened from home page
        if(!String.isBlank(filterValue)){
            System.debug('into if filter');
            queryOnNEOrder          += ' AND OB_Bank_OrderStatus__c = \''+filterValue.split('_')[0]+'\' ';
            queryOnNEOrder          += ' AND NE__Type__c = \''+filterValue.split('_')[1]+'\' ';
            //GIOVANNI SPINELLI ADD BIO control fi order status = draft - incomplete order
            if(filterValue.split('_')[0] == OB_UtilityConstants.BANKORDERSTATUS_DRAFTINCOMPLETEORDER){
                String bio                  = OB_UtilityConstants.BIO;
                queryOnNEOrder          += ' AND  OB_ApprovalType__c=:bio'; 
            }
        }
        //Giovanni spinelli - end - 16/07/2019 add a where condition if tab is opened from home page
        // NEX-006 joanna.mielczarek@accenture.com 27/03/2019 START
        if ( !String.isBlank( contextCAB ) )
        {
            String currentUserProfileName = getUserInformation( ).Profile.Name;
            queryOnNEOrder += ' AND OB_CAB__C != NULL ' ;//simone misani RI-85 23/05/2019

            if ( OB_UtilityConstants.NEXI_PARTNER_USER_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName )
                    || OB_UtilityConstants.NEXI_PARTNER_APPROVER_L1_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName ) )
        {
            queryOnNEOrder      += 'AND OB_CAB__c = \''+contextCAB+'\' ';
        }
            else if ( OB_UtilityConstants.NEXI_PARTNER_APPROVER_L2_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName ) )
            {
                queryOnNEOrder += ' AND OB_CAB__c IN ' + splittedCABs; // NEX-006 grzegorz.banach@accenture.com 19/03/2019
            }
        }
        queryOnNEOrder += ' AND (NOT(OB_ApprovalStatus__c=\'Approvato Pricing\' AND NE__Order_Header__r.OB_Main_Process__c=\'Maintenance\' ' +
                'AND NE__Order_Header__r.OB_Sub_Process__c=\'variazione economica\' AND OB_AgreedChanges__c=false))';
        queryOnNEOrder += ' AND OB_ApprovalStatus__c != \'' + OB_UtilityConstants.ORDER_APPROVALSTATUS_APPROVATOBIO + '\' ' +
                'AND OB_FulfilmentStatus__c != \'' + OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED + '\' ';
        queryOnNEOrder += ' AND ((OB_ApprovalType__c =\'' + OB_UtilityConstants.APPROV_TYPE_BIO + '\' ' + //francesca.ribezzi 15/11/19 - PROD-83 - adding draft fulfilment status in or condition with pending for BIO rigettato 
                'AND (((OB_FulfilmentStatus__c =\'' + OB_UtilityConstants.FULFILMENTSTATUS_PENDING + '\' OR OB_FulfilmentStatus__c=\''+ OB_UtilityConstants.FULFILMENTSTATUS_DRAFT+ '\') ' +
                'AND OB_BankApprovalStatus__c =\'' + OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO + '\') ' +
                'OR (OB_FulfilmentStatus__c =\'' + OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE + '\' ' +
                'AND OB_BankApprovalStatus__c =\'' + OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE + '\' ))) ';
        queryOnNEOrder += ' OR (OB_ApprovalType__c =\'' + OB_UtilityConstants.APPROV_TYPE_PRICING + '\' ' +
                'AND ((OB_FulfilmentStatus__c =\'' + OB_UtilityConstants.FULFILMENTSTATUS_DRAFT + '\' ' +
                'AND (OB_BankApprovalStatus__c =\'' + OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO + '\' ' +
                'OR OB_BankApprovalStatus__c =\'' + OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO + '\') ) ' +
                'OR ( OB_FulfilmentStatus__c =\'' + OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE + '\' ' +
                'AND OB_BankApprovalStatus__c =\'' + OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE + '\') ) ) ) ';
        queryOnNEOrder += ' ORDER BY CreatedDate DESC';
        System.debug('QUERY FIRED: ' + queryOnNEOrder);
        toReturn = Database.query(queryOnNEOrder);
        //  END     micol.ferrari 15/01/2019 - QUERY STRING AND EDIT TO THE WHERE CONDITION

        System.debug('OB_ItemsToApprove_CC.retrieveConfigurationApproval - toReturn: '+toReturn);

        if ( !toReturn.isEmpty( ) )
        {
        return toReturn;
    }
        return new List<NE__Order__c>( );
        // NEX-006 joanna.mielczarek@accenture.com 27/03/2019 STOP
    }

    @AuraEnabled
    global static Map<String,String> retrieveHistoricWizardData(List<NE__Order__c> configurations)
    {
        System.debug('INSIDE OB_ItemsToApprove_CC.retrieveHistoricWizardData');

        Map<String,String> toReturn = new Map<String,String>();
        Map<NE__Order__c, String> mapOfOrderHeader = new Map<NE__Order__c, String>( );

        if (configurations!=null && !configurations.isEmpty())
        {
            for (NE__Order__c conf : configurations)
            {
                if ( conf.OB_BankApprovalStatus__c == OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO
                        || conf.OB_BankApprovalStatus__c == OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO 
                        || conf.OB_Bank_OrderStatus__c == Label.OB_PrintedQuoteStatus) //gianluigi.virga 18/09/2019 - Add condition about printed quote
                {
                    mapOfOrderHeader.put(conf,conf.NE__Order_Header__c);
                }
            }
            //  Daniele Gandini <daniele.gandini@accenture.com> 16/04/2019 - R1F2-15 - Start
            if (mapOfOrderHeader.size()>0)
            {
                List<bit2flow__Historic_Wizard_Data__c> listOfHistoricWD =
                [
                        SELECT Id,
                                                                                    Name,
                                                                                    bit2flow__Status__c,
                                                                                    bit2flow__Wizard_Id__c,
                                                                                    bit2flow__Wizard_Label__c,
                                                                                    bit2flow__Wizard_Name__c,
                                OB_OrderHeaderId__c,
                                CreatedDate
                                                                            FROM bit2flow__Historic_Wizard_Data__c
                                                                            WHERE OB_OrderHeaderId__c IN: mapOfOrderHeader.values()
                        ORDER BY CreatedDate DESC
                ];
        
                Map<Id, bit2flow__Historic_Wizard_Data__c> hwdMap = new Map<Id, bit2flow__Historic_Wizard_Data__c>( listOfHistoricWD );
                //  IF STATUS IS APPROVED OR REJECTED, THEN PUT THE HISTORIC WIZARD ID IN THE MAP TO RETURN
                if (listOfHistoricWD.size()>0)
                {
                    for (NE__Order__c conf : mapOfOrderHeader.keySet())
                    {
                        for (bit2flow__Historic_Wizard_Data__c hwd : listOfHistoricWD)
                        {
                            //Start-----simone misani 15/05/2019 R1F2-134
                           if ( conf.NE__Order_Header__c == hwd.OB_OrderHeaderId__c
                                &&
                                ((
                                toReturn.containsKey( String.valueOf( conf.Id ) ) 
                                && 
                                hwd.CreatedDate > hwdMap.get( toReturn.get( conf.Id ) ).CreatedDate  
                                )
                                ||
                                !toReturn.containsKey( String.valueOf( conf.Id ) ) 
                                )
                            )
                            {
                                toReturn.put(conf.Id,hwd.Id);
                            }
                            //End-----simone misani 15/05/2019 R1F2-134

                        }
                    }
                }
                //  Daniele Gandini <daniele.gandini@accenture.com> 16/04/2019 - R1F2-15 - STOP
            }
            System.debug('INSIDE OB_ItemsToApprove_CC.retrieveHistoricWizardData - toReturn: '+toReturn);
        }
        return toReturn;
    }
    
    @AuraEnabled                               //francesca.ribezzi 16/04/19 adding currentUserId parameter
    global static Boolean changeOrderStatusServer( Id orderId, String currentUserId )
    {
        try
        {
            //  R1F2-279 Micol Ferrari <micol.ferrari@accenture.com>, 14/06/2019 - Added fields to query
            List<NE__Order__c> Conf =
            [
                    SELECT id,OB_FulfilmentStatus__c,NE__FulfilmentStatus__c,OwnerId,NE__OrderStatus__c, NE__Order_Header__r.OB_Main_Process__c //francesca.ribezzi 16/04/19 adding OwnerId field
                FROM NE__Order__c 
                WHERE id = :orderId
                LIMIT 1
                ];
            
            if(Conf.size() > 0)
            {
                //START francesca.ribezzi 16/04/19 assign owner id to the current userId:
                if ( !string.isBlank( currentUserId ) )
                {
                    Conf[ 0 ].OwnerId = currentUserId;
                }
                //END francesca.ribezzi
                Conf[0].OB_FulfilmentStatus__c = 'Draft';

                //  R1F2-279 Micol Ferrari <micol.ferrari@accenture.com>, 14/06/2019 - START
                if (Conf[0].NE__Order_Header__r.OB_Main_Process__c=='Setup')
                {
                    Conf[0].NE__OrderStatus__c = 'Pending';
                }
                //  R1F2-279 Micol Ferrari <micol.ferrari@accenture.com>, 14/06/2019 - STOP
                
                //  R1F2-279 Micol Ferrari <micol.ferrari@accenture.com>, 14/06/2019 - Added fields to query                
                List<NE__OrderItem__c> orderItems =
                [
                    SELECT id,OB_FulfilmentStatus__c,NE__FulfilmentStatus__c, NE__Status__c, NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c
                    FROM NE__OrderItem__c
                    WHERE NE__OrderId__c = :orderId 
                    ];

                if(orderItems.size() > 0)
                {
                    for(NE__OrderItem__c ordIt: orderItems)
                    {
                        ordIt.OB_FulfilmentStatus__c = 'Draft';

                        //  R1F2-279 Micol Ferrari <micol.ferrari@accenture.com>, 14/06/2019 - START
                        if (ordIt.NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c=='Setup')
                        {
                            ordIt.NE__Status__c = 'Pending';
                        }
                        //  R1F2-279 Micol Ferrari <micol.ferrari@accenture.com>, 14/06/2019 - STOP
                    }
                    update orderItems;
                }
                update Conf;
                return true;    
            }
            else
            {
                System.debug('Configuration Id WRONG or NULL: '+orderId);
                return false;
                
            }
        } catch ( Exception e )
        {
            System.debug( 'Exception in OB_ItemsToApprove_CC::changeOrderStatusServer ' +
                    e.getMessage( ) + ' at line ' + e.getLineNumber( ) );
            return false;
        }
    }
    
    
    @AuraEnabled
    global static Id changeJumpToStepHistoricAttachment( String historicWizardId )
    {
        //TEST!
        Integer stepToGo = 3;
        //END TEST!!
        
        //get all attachments from historicWizardID
        List<Attachment> attachsToEdit = [SELECT Id,Body FROM Attachment WHERE ParentId = :historicWizardId AND Name = :Label.OB_dataJSON ]; //antonio.vatrano 11/06/2019 r1f2-241
        if(attachsToEdit.size() == 0)
        {   
            System.debug('@@@No Attachments found with id '+historicWizardId );
            return null;    
        }
        Blob attachBody = attachsToEdit[0].Body;

        try
        {
        Map<String,Object> attachToEditMap = (Map<String,Object>) JSON.deserializeUntyped(attachBody.toString());
        
        if(attachToEditMap.get('JumpToStep') != null)
        {
            attachToEditMap.put('JumpToStep',stepToGo);
        }
        else
        {
            System.debug('@@@No JumpToStep node in JSON found!');
            return null;    
        }
        attachsToEdit[0].Body = Blob.valueOf(JSON.serialize(attachToEditMap)); 

            update attachsToEdit;
            return historicWizardId;
        } catch ( Exception e )
        {
            System.debug( 'Exception in OB_ItemsToApprove_CC::changeJumpToStepHistoricAttachment ' +
                    e.getMessage( ) + ' at line ' + e.getLineNumber( ) );
            return null;
        }
    }

    // DG 05/02/2019
    @AuraEnabled
    global static Boolean cancelPricingOperation( String orderId )
    {
        Boolean toReturn = true;
        try
        {
            if ( !String.isBlank( orderId ) )
            {
                NE.OrderSummaryButtonExtension.cancelButton(orderId);
            }
        } catch ( Exception e )
        {
            System.debug( 'Exception in OB_ItemsToApprove_CC: cancelPricingOperation ' +
                    e.getMessage( ) + ' at line ' + e.getLineNumber( ) );
             toReturn = false;
        }
        return toReturn;
    }

    @AuraEnabled
    global static Boolean cancelOrderAndChildren(String orderId)
    {
        Boolean toReturn = true;
        try 
        {
            List<NE__Order__c> listOfOrders =
            [
                    SELECT Id,OB_FulfilmentStatus__c,
                    (
                            SELECT Id, OB_FulfilmentStatus__c
                            FROM NE__Order_Items__r
                    )
                                                    FROM NE__Order__c 
                                                    WHERE Id=:orderId
                    LIMIT 1
            ];
            if (!listOfOrders.isEmpty())
            {
                NE__Order__c contextOrder = new NE__Order__c();
                contextOrder = listOfOrders.get(0);
                contextOrder.OB_FulfilmentStatus__c = 'Cancelled';
                update contextOrder;
                List<NE__OrderItem__c> listOfOI = new List<NE__OrderItem__c>();
                if (!contextOrder.NE__Order_Items__r.isEmpty())
                {
                    for (NE__OrderItem__c oi : contextOrder.NE__Order_Items__r)
                    {
                        oi.OB_FulfilmentStatus__c = 'Cancelled';
                        listOfOI.add(oi);
                    }
                    update listOfOI;
                }
            }
        } catch ( Exception e )
        {
            System.debug( 'Exception in OB_ItemsToApprove_CC::cancelPricingOperation ' +
                    e.getMessage( ) + ' at line ' + e.getLineNumber( ) );
            toReturn = false;
        }
        return toReturn;
    }

    @AuraEnabled
    public static String launchMaintenanceWizard( String wizardName )
    {
        return OB_RunWizard_CC.getWizardIdFromAPIName(wizardName);
    }

    //  START   micol.ferrari 19/02/2019 - #1388 - RESUBMIT BIO
    @AuraEnabled
    public static Boolean callResubmitBIO(String confId)
    {
        Boolean toReturn = false;
        System.debug('INTO IF APROVAL PROCESS BIO');
        List<NE__Order__c> listOfConf =
        [
                SELECT Id,Name,NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c,OwnerId
                                        FROM NE__Order__c
                                        WHERE Id=:confId
                LIMIT 1
        ];
        if (!listOfConf.isEmpty())
        {
            NE__Order__c conf           = new NE__Order__c();
            conf                        = listOfConf.get(0);
            conf.OB_ApprovalType__c     = OB_UtilityConstants.APPROV_TYPE_BIO;
            String stringConcat         = conf.NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_BIO;

            List<Group> groupSelected =
            [
                    SELECT Id,Name
                                            FROM    Group
                                            WHERE   Type = 'Queue'
                                            AND     Name = :stringConcat
                    LIMIT 1
            ];

            if( groupSelected != null && groupSelected.size() > 0 )
            {
                conf.OwnerId = groupSelected[0].Id;
                System.debug('CONF OWNER ID: ' +conf.OwnerId);
            }

            update conf;
            OB_Utility.submitApprovalProcess(conf.Id,Label.OB_BIO_ApprovalProcess);
            toReturn = true;
        }
        return toReturn;
    }
    //  END     micol.ferrari 19/02/2019 - #1388 - RESUBMIT BIO

    /*******************************************************************************
    Purpose:  Method sets fields OB_Nexi_OrderStatus__c, OB_Bank_OrderStatus__c, OB_Nexi_LastStatusChange__c,
              OB_Bank_LastStatusChange__c timestamps in NE__Order__c - 'Draft' status
    Parameters: Id orderToUpdate
    Returns: -
    
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-20_order_status_handleLogic
    2.0         Joanna Mielczarek       05/06/2019      Modified        NEXI-99 added update of Order
    ********************************************************************************/
    @AuraEnabled
    public static void setOrderStatusDraft( Id orderToUpdate )
    {
        List<NE__Order__c> ordersToUpdate = new List<NE__Order__c>( );

        for ( NE__Order__c loopOrder: [ SELECT Id FROM NE__Order__c WHERE Id = :orderToUpdate ] )
        {
            OB_Order_ChangeStatus.setOrderStatusDraft( loopOrder );
            ordersToUpdate.add( loopOrder );
        }

        OB_Order_ChangeStatus.updateOrdersStatus( ordersToUpdate );
    }

    /*******************************************************************************
    Purpose:  Method sets fields OB_Nexi_OrderStatus__c, OB_Bank_OrderStatus__c, OB_Nexi_LastStatusChange__c,
              OB_Bank_LastStatusChange__c timestamps in NE__Order__c - 'Draft - incomplete order' status
    Parameters: Id orderToUpdate
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-20_order_status_handleLogic
    2.0         Joanna Mielczarek       05/06/2019      Modified        NEXI-99 added update of Order
    ********************************************************************************/
    @AuraEnabled
    public static void setOrderStatusDraftIncompleteOrder( Id orderToUpdate )
    {
        List<NE__Order__c> ordersToUpdate = new List<NE__Order__c>( );
        for ( NE__Order__c loopOrder: [ SELECT Id FROM NE__Order__c WHERE Id = :orderToUpdate ] )
        {
            ordersToUpdate.add( OB_Order_ChangeStatus.setOrderStatusDraftIncompleteOrder( loopOrder, true, false, false ) );
        }

        OB_Order_ChangeStatus.updateOrdersStatus( ordersToUpdate );
    }
    /*******************************************************************************
    Purpose:  get account info when click on merchant name
    Parameters: Id merchantId , contextABI
    Returns: -Map<String ,Object>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Giovanni spinelli      29/04/2019      Created        
    ********************************************************************************/
    @AuraEnabled
    public static Map<String ,Object> getAccountInfo(String merchantId , String contextABI){
        Map<String ,Object> resultData = new Map<String ,Object>();
         Id rtDatiSocietaLegale             = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.DATI_SOCIETA_LEGALE ).getRecordTypeId();
        System.debug('CONTEXT ABI: '+ contextABI);
        try{
            List<Account> accList= [SELECT id, Name , NE__VAT__c, NE__Fiscal_code__c,OB_Legal_Form__c,
                                OB_Administrative_Office_ZIP__c,OB_Administrative_Office_Street_number__c,
                                OB_Administrative_Office_Street__c,OB_Administrative_Office_State__c,
                                OB_Administrative_Office_City__c,OB_Administrative_Office_Address_Details__c, OB_Legal_Address_Hamlet__c,OB_Administrative_Office_Hamlet__c,
                                OB_Legal_Address_City__c,OB_Legal_Address_Detail__c,OB_Legal_Address_State__c,OB_Legal_Address_Street__c,
                                OB_Legal_Address_Street_Number__c,OB_Legal_Address_ZIP__c,OB_CCIAA__c,OB_CCIAA_Province__c,OB_ATECO__c,OB_SAE_Code__c
                                FROM Account WHERE Id=:merchantId ];
            List<Contact> cntList =[SELECT Email, Phone 
            FROM contact 
            WHERE AccountId=: merchantId and OB_Bank__r.OB_ABI__c=:contextABI and recordtypeid=:rtDatiSocietaLegale];
            System.debug('cntList: '+ cntList);
            resultData.put('merchant' , accList.get(0));
            resultData.put('contact'  , cntList.get(0));
        }catch(Exception e){
            System.debug('generic error: '+e.getMessage()+' at line '+e.getLineNumber());
            
        }
        return resultData;
    }
    /*******************************************************************************
    Purpose:  get information about Approver Comments
    Parameters: List of order id 
    Returns: -Map<String ,String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Giovanni spinelli      30/07/2019      Created        
    ********************************************************************************/
    @AuraEnabled
    public static Map<String ,String> retrieveComments(List<Id> idOrderList){
        Map<String ,String> returnMap = new Map<String ,String>();
        try{
            System.debug('idOrderList: ' + idOrderList);
            List<ProcessInstanceStep> stepList = new list<ProcessInstanceStep>();
            if( idOrderList.size() > 0 ){
                /*
                retrieve all comment about step approver
                */
                stepList = [
                    SELECT Id , processinstance.targetobjectId ,StepStatus , comments , CreatedDate
                    FROM ProcessInstanceStep 
                    WHERE processinstance.targetobjectId IN: idOrderList AND (StepStatus ='Approved' or StepStatus ='Rejected')
                    ORDER BY CreatedDate
                ];
                for(ProcessInstanceStep step : stepList){
                    if( String.isNotBlank( step.comments ) ){
                        System.debug( 'processinstance.targetobjectId:  ' + step.processinstance.targetobjectId);
                        /*
                        create a map with order id and its comment
                        if an id has more than one comment, because of the query in order byu creation date,
                        in the map the key will overwrite with last comment
                        */
                        returnMap.put( String.valueOf( step.processinstance.targetobjectId ) , step.comments );
                    }
                }
            }
            System.debug('stepList: '+ stepList);
            System.debug('returnMap: '+ returnMap);
        }catch(Exception ecc){
            System.debug(Logginglevel.ERROR, 'Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
          
        return returnMap;

      }

}