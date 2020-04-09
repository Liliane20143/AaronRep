/*****************************************************************
Name:  OB_HomePage_CC

============================================================
Purpose:     return information to show in community home page                                                                                                                 
============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                             DATE           DETAIL          Description
1.0         Giovanni Spinelli              11/07/2019      Created          CSR: 
*****************************************************************/
public with sharing class OB_HomePage_CC {
    /*
    * Author : Giovanni Spinelli
    * Date : 11/07/2019
    * Description : get information about order status
    */
    @AuraEnabled
    public static Map<String, Map<String,Integer>> getTableInformation(){
        Map<String, Map<String,Integer>> returnMap  = new Map<String, Map<String,Integer>>();
        try{
            /*
            GET INFOMATION ABOUT NEXI PARTER USER FROM CUSTOM METADATA
            1) get only nexi partner user
            2) get L1 and L2 
            3) get L1 L2 and L3
            */
            String nexiPartnerUser = System.Label.OB_CheckProfileUploadItemsToApprove;
            String profileNexiPartnerUser = OB_HomePage_CC.queryConfigurationInformation(nexiPartnerUser);
            
            String l1_l2 = System.Label.OB_Approver_L1_L2;
            String nexiApprover_l1_l2 = OB_HomePage_CC.queryConfigurationInformation(l1_l2);
            
            String l1_l2_l3 = System.Label.OB_ApproveRejectConfigurationApproval;
            String nexiApprover_l1_l2_l3 = OB_HomePage_CC.queryConfigurationInformation(l1_l2_l3);
            System.debug('available profiles: ' + profileNexiPartnerUser +' ** '+nexiApprover_l1_l2 +' ** '+nexiApprover_l1_l2_l3);
            /*
            build user information
            */
        
            User currentUser = new User();
            String ABI                      = getUserInformation( ).OB_ABI__c;
            String CAB                      = getUserInformation( ).OB_CAB__c;
            String splittedCABs             = OB_MainUtil.explodeString( CAB, ';' );
            String currentUserProfileName   = getUserInformation( ).Profile.Name;
            Id currentUserId                = getUserInformation( ).Id;
            
            System.debug('splittedCABs: ' + splittedCABs);
            System.debug('ABI USER ' + ABI);
            System.debug('currentUserProfileName: ' + currentUserProfileName);
            //get info from costants
            String draft                    = OB_UtilityConstants.BANKORDERSTATUS_DRAFT;
            String orderFulfilledPartially  = OB_UtilityConstants.BANKORDERSTATUS_ORDERFULFILLEDPARTIALY;
            String procedureRefused         = OB_UtilityConstants.BANKORDERSTATUS_PROCEDUREREFUSED;
            String nexiProcessing           = OB_UtilityConstants.BANKORDERSTATUS_NEXIPROCESSING;
            String orderfulfilled           = OB_UtilityConstants.BANKORDERSTATUS_ORDERFULFILLED;
            String orderCancelled           = OB_UtilityConstants.BANKORDERSTATUS_ORDERCANCELLED;
            String daftIncompleteOrder      = OB_UtilityConstants.BANKORDERSTATUS_DRAFTINCOMPLETEORDER;
            String bio                      = OB_UtilityConstants.BIO;
            String economicCondApproval     = OB_UtilityConstants.BANKORDERSTATUS_ECONOMICCONDITIONAPPROVAL;
            String bankVerification         = OB_UtilityConstants.BANKORDERSTATUS_BANKVERIFICATION;
            List<String> statusUseless = new List<String>{draft , procedureRefused , nexiProcessing ,  orderfulfilled , orderCancelled , orderFulfilledPartially};
            System.debug('statusUseless: ' + statusUseless);
            // Pratica in lavorazione Nexi
            // Pratica evasa
            /* 
            QUERY ON ORDERS TO VISUALIZE
            remove order with OB_Bank_OrderStatus__c=='Draft - incomplete order' and OB_ApprovalType__c!=BIO and OB_ApprovalBIO__c!=true
            */
            String queryNEorder = '';
            queryNEorder ='SELECT  NE__type__c, OB_Bank_OrderStatus__c,OB_ApprovalType__c ,OB_ApprovalBIO__c,OwnerId' +
                            ' FROM    NE__order__c' +
                            ' WHERE    OB_ABI__c=:ABI AND OB_Bank_OrderStatus__c !=NULL ' ;
            if(profileNexiPartnerUser.contains(currentUserProfileName)){
                queryNEorder+=' AND OB_Bank_OrderStatus__c!=:economicCondApproval AND OB_Bank_OrderStatus__c!=:bankVerification';
            }else if(nexiApprover_l1_l2.contains(currentUserProfileName)){
                queryNEorder+=' AND OB_Bank_OrderStatus__c!=:bankVerification';
            }
            if ( !String.isBlank( CAB ) )
            {
                queryNEOrder += ' AND OB_CAB__c != NULL'; 
                if ( OB_UtilityConstants.NEXI_PARTNER_APPROVER_L1_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName ) || profileNexiPartnerUser.contains(currentUserProfileName) )//giovanni spinelli 01/08/2019 add filter to manage different user with same ABI
                {
                    queryNEOrder += ' AND OB_CAB__c = \'' + CAB + '\'';
                }
                else if ( OB_UtilityConstants.NEXI_PARTNER_APPROVER_L2_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName ) )
                {
                    queryNEOrder += ' AND OB_CAB__c IN ' + splittedCABs;
                }
            }
            Set<Id> setOfGroupIds = new Set<Id>( );
            System.debug('group member: ' + [ SELECT GroupId FROM GroupMember WHERE UserOrGroupId = :currentUserId ]);
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
            System.debug('groupIds: ' + groupIds);
            if (nexiApprover_l1_l2_l3.contains(currentUserProfileName) )
            {
                
                queryNEOrder += ' AND  (OB_Bank_OrderStatus__c !=:economicCondApproval OR (OwnerId IN ' + groupIds + ' AND OB_Bank_OrderStatus__c =:economicCondApproval))';
            }
    
            
            queryNEorder += ' AND      OB_Bank_OrderStatus__c NOT IN: statusUseless'+
                            
                            ' AND     (NE__type__c=\'InOrder\' OR NE__type__c=\'ChangeOrder\')'+
                            ' AND     (OB_Bank_OrderStatus__c!=:daftIncompleteOrder OR (OB_Bank_OrderStatus__c=:daftIncompleteOrder  AND OB_ApprovalType__c=:bio))';
            
            System.debug('query: '+JSON.serialize(queryNEorder));
            List<NE__Order__c> listOrder = Database.query( queryNEorder );
            System.debug('listOrder: '+listOrder);
            //GET PICKLIST VALUE TO SHOW IN TABLE
            List<String> pickListValuesList= new List<String>();
            Schema.DescribeFieldResult fieldResult = NE__order__c.OB_Bank_OrderStatus__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            map<String , String> picklistTranslationMap = new map<String , String>();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
                System.debug('VALUE PICKLIST: ' +pickListVal.getValue());
                System.debug('translation PICKLIST: ' +pickListVal.getLabel());
                picklistTranslationMap.put(pickListVal.getValue() , pickListVal.getLabel());
            }
            System.debug('picklistTranslationMap: '+ JSON.SERIALIZE(picklistTranslationMap));
            /* 
            QUERY ON LOG REQUEST TO VISUALIZE
            get only record with OB_StatusFormula__c = 'Rifiutato - Da risottomettere'
            */
            String queryOBlogRequest = '';
            queryOBlogRequest='SELECT  id,name, OB_Status__c, OB_RejectReason__c,  OB_StatusFormula__c , OB_CAB__c '+
                            'FROM OB_LogRequest__c '+
                            ' WHERE OB_ABI__c=:ABI AND OB_StatusFormula__c=\'Rifiutato - Da risottomettere\' '; 
            if ( !String.isBlank( CAB ) )
            {
                queryOBlogRequest += ' AND OB_CAB__c != NULL'; 
                if ( OB_UtilityConstants.NEXI_PARTNER_APPROVER_L1_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName ) || profileNexiPartnerUser.contains(currentUserProfileName) )//giovanni spinelli 01/08/2019 add filter to manage different user with same ABI
                {
                    queryOBlogRequest += ' AND OB_CAB__c = \'' + CAB + '\'';
                }
                else if ( OB_UtilityConstants.NEXI_PARTNER_APPROVER_L2_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName ) )
                {
                    queryOBlogRequest += ' AND OB_CAB__c IN ' + splittedCABs;
                }
            }
            List<OB_LogRequest__c> listLogReq = Database.query( queryOBlogRequest );
            System.debug('listLogReq: ' + listLogReq);
            Map<String,Integer> elCount_Setup           = new Map<String,Integer>();
            Map<String,Integer> elCount_Maintenance     = new Map<String,Integer>();
            
            /*
            count configuration and split in different nodes
            */
            for(NE__order__C  order : listOrder)
            {
                String tmp = String.valueOf(picklistTranslationMap.get(order.OB_Bank_OrderStatus__c)+'||'+order.OB_Bank_OrderStatus__c);
                if(order.NE__type__c=='InOrder' )
                {
                    if(!elCount_Setup.containsKey(tmp ))
                    {
                        elCount_Setup.put(String.valueOf(picklistTranslationMap.get(order.OB_Bank_OrderStatus__c)+'||'+order.OB_Bank_OrderStatus__c   ) ,0);
                    }
                    Integer currentInt= elCount_Setup.get(tmp)+1;
                    elCount_Setup.put(String.valueOf(picklistTranslationMap.get(order.OB_Bank_OrderStatus__c)+'||'+order.OB_Bank_OrderStatus__c ) ,currentInt);
                }
                if(order.NE__type__c=='ChangeOrder' )
                {
                    if(!elCount_Maintenance.containsKey(tmp ))
                    {
                        elCount_Maintenance.put(String.valueOf(picklistTranslationMap.get(order.OB_Bank_OrderStatus__c)+'||'+order.OB_Bank_OrderStatus__c ) ,0);
                    }
                    Integer currentInt= elCount_Maintenance.get(tmp)+1;
                    elCount_Maintenance.put(String.valueOf(picklistTranslationMap.get(order.OB_Bank_OrderStatus__c)+'||'+order.OB_Bank_OrderStatus__c ) ,currentInt);
                }
            }
            /*
            add log request count in map
            */
            OB_LogRequest__c logRequestSymbolic = new OB_LogRequest__c();
            if(listLogReq.size()>0){
                logRequestSymbolic = listLogReq.get(0);
                elCount_Maintenance.put(logRequestSymbolic.OB_StatusFormula__c+'||'+logRequestSymbolic.OB_StatusFormula__c , listLogReq.size());
            }
            
            
            /*
            elCount Map contains as Key 'translation||value' as Value 'number of element'
            in javascript I split on || to have translation on screen and value to pass to other method (ex. query)
            create table only if there are record to manage
            */
            System.debug('elCount_Maintenance.size: ' + elCount_Maintenance.size());
            if(elCount_Setup.size() > 0){
                returnMap.put(Label.OB_Setup_ManagedPractices       , elCount_Setup); 
            }
            if(elCount_Maintenance.size() > 0){
                returnMap.put(Label.OB_Maintenance_ManagedPractices , elCount_Maintenance); 
            }
        System.debug('returnMap: ' + JSON.serialize(returnMap));
            
        }catch(Exception ecc){
            System.debug(Logginglevel.ERROR, 'Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
        return returnMap;
    }
    /*
    * Author : Giovanni Spinelli
    * Date : 15/07/2019
    * Description : get information of context user
    */
    private static User getUserInformation()
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
                                            OB_ABI__c,
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
            System.debug('contextUser: ' + contextUser);
        }

        return contextUser;
    }
    /*
    * Author : Giovanni Spinelli
    * Date : 15/07/2019
    * Description : get current url
    */
    @AuraEnabled
	public static string getBaseURl(){
		String StringaUrl = OB_ContinuationController.getVFBaseURL();
		return StringaUrl;
    }
    /*
    * Author : Giovanni Spinelli
    * Date : 22/07/2019
    * Description : set a boolean to hide home page to 'nexi partner admin'
    */
    @AuraEnabled
	public static Boolean hideToAdmin_Apex(){
        Boolean hide = false;
        String QualifiedApiName = System.Label.OB_NexiAdmin;
        String currentProfile = OB_HomePage_CC.queryConfigurationInformation(QualifiedApiName);
        String currentUserProfileName   = getUserInformation( ).Profile.Name;
        if(currentProfile.contains(currentUserProfileName)){
            hide = true;
        }
        return hide;
    }
    /*
    * Author : Giovanni Spinelli
    * Date : 22/07/2019
    * Description : generic method to query on custo metadata'
    */
    private static String queryConfigurationInformation (String QualifiedApiName){
        List<OB_ConfigurationInformation__mdt> listOfConfigurationInformation = [SELECT Id,QualifiedApiName,OB_String_Value__c
                                                                                    FROM OB_ConfigurationInformation__mdt 
                                                                                    WHERE QualifiedApiName =: QualifiedApiName
                                                                                    LIMIT 1];
        String currentProfiles = '';
        if (!listOfConfigurationInformation.isEmpty())
        {
            currentProfiles = listOfConfigurationInformation.get(0).OB_String_Value__c;
        }
        return currentProfiles;
    }
}