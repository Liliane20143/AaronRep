public without sharing class OB_OrderHeaderDetailsPage_CC { // PRODOB-38, Doris Dongmo <doris.tatiana.dongmo@accenture.com>,30/05/2019
															// CHANGED 'with sharing' TO 'without sharing'//*

    @AuraEnabled
    public static Map<String, List<Object>> getInfo_apex( String orderHeaderId_value )
    {
        System.debug( 'I am in OB_OrderHeaderDetailsPage_CC.getInfo_apex' );
        try
        {
            system.debug( ' ## orderHeaderId_value ' + orderHeaderId_value );

            Integer titolariEffettiviCounter = 0;
            Map<String, List<Object>> returnedMap = new Map<String, List<Object>>( );
            List<Contact> esecutore = new List<Contact>( );
            List<Contact> titolariEffettivi = new List<Contact>( );
            // ANDREA START 23/01
            List<NE__Order_Header__c> orderHeaders =
            [
                    SELECT Id, Name, CreatedBy.Profile.Name, //elena.preteni F3 added profile filter 22/07/2019
                    OB_ExitFlow__c  //francesca.ribezzi 24/09/19 - WN-480 - adding OB_ExitFlow to check whether to show or not the ResumeFlow button
                    FROM NE__Order_Header__c
                    WHERE Id = :orderHeaderId_value
            ];
            System.debug( 'orderHeaders are: ' + orderHeaders );
            //	micol.ferrari 28/12/2018 - ADDED NE__Order_Header__r.OB_FulfilmentStatus__c
            // antonio.vatrano 29/05/2019 - r1f2_160 added fields to query
            List<NE__Order__c> configurations =
            [
                    SELECT NE__Order_date__c,
                            OB_Service_Point__r.Name,
                            OB_Service_Point__r.NE__Street__c,
                            OB_Service_Point__r.OB_Street_Number__c,
                            OB_Service_Point__r.NE__City__c,
                            OB_Service_Point__r.NE__Zip_Code__c,
                            NE__Order_Header__r.OB_FulfilmentStatus__c,
                            OB_FulfilmentStatus__c, NE__Order_Header__r.OB_Main_Process__c,
                            NE__Order_Header__r.OB_StartApprovalProcess__c,OB_ApprovalStatus__c,
                            OB_PricingApproval__c,
                            OB_Bank_OrderStatus__c, //g.v. 22/07/2019 - PRODOB-86
                            (select id from ne__order_items__r) //antonio.vatrano perf52 13-12-2019
                    FROM NE__Order__c
                    WHERE NE__Order_Header__c = :orderHeaderId_value
            ];
            System.debug( 'configurations are: ' + configurations );
            List<Account> contextAccount =
            [
                    SELECT Name,
                            NE__Status__c,
                            NE__Fiscal_code__c,
                            Description,
                            NE__VAT__c,
                            OB_New_Name__c,
                            OB_VAT_Not_Present__c,
                            OB_DescriptionVATNotPresent__c,
                            NE__E_mail__c,
                            Phone,
                            OB_Legal_Form__c,
                            OB_Year_constitution_company__c,
                            OB_No_Profit_Class__c,
                            OB_No_Profit_Recipient_Class__c,
                            OB_No_Profit_Recipient_Other__c,
                    (
                            SELECT FirstName,
                                    LastName,
                                    OB_Fiscal_Code__c,
                                    OB_Sex__c,
                                    OB_Country_Birth__c,
                                    OB_Birth_State__c,
                                    OB_Birth_City__c,
                                    OB_Citizenship__c,
                                    OB_Birth_Date__c,
                                    OB_Document_Number__c,
                                    OB_Document_Type__c,
                                    OB_Document_Release_Authority__c,
                                    OB_Document_Release_Date__c,
                                    OB_Document_Expiration_Date__c,
                                    OB_Document_Release_State__c,
                                    OB_Document_Release_City__c,
                                    OB_PEP__c,
                                    OB_Address_Country__c,
                                    OB_Address_State__c,
                                    OB_Address_City__c,
                                    OB_Address_Hamlet__c,
                                    OB_Address_Street__c,
                                    OB_Address_Street_Number__c,
                                    OB_Address_PostalCode__c,
                                    RecordType.DeveloperName
                            FROM Contacts
                            WHERE ( RecordType.DeveloperName = :OB_UtilityConstants.ESECUTORE OR RecordType.DeveloperName = :OB_UtilityConstants.TITOLARE_EFFETTIVO )
                            AND OB_Bank__c IN ( SELECT OB_ProposerABI__c FROM NE__Order_Header__c WHERE Id = :orderHeaderId_value )
                    )
                    FROM Account
                    WHERE Id IN ( SELECT NE__AccountId__c FROM NE__Order_Header__c WHERE Id = :orderHeaderId_value )
            ];
            System.debug( 'contextAccount is : ' + contextAccount );

            //ANDREA START 23/01/2019
            if ( !contextAccount.isEmpty( ) || contextAccount.size( ) >= 1 )
            {
                System.debug( 'INSIDE IF' );
                for ( Contact c : contextAccount[ 0 ].Contacts )
                {
                    System.debug( 'INSIDE FOR' );
                    if ( OB_UtilityConstants.TITOLARE_EFFETTIVO.equalsIgnoreCase( String.valueOf( c.RecordType.DeveloperName ) ) && titolariEffettiviCounter < 6 )
                    {
                        titolariEffettivi.add( c );
                        titolariEffettiviCounter++;
                    }
                    else
                    {
                        esecutore.add( c );
                    }
                }

            }
            //ANDREA END 23/01/2019

            //	START 	micol.ferrari 28/12/2018 - RETRIEVE HISTORIC WIZARD DATA
            returnedMap.put( 'historicWizardData', null );
            if ( !configurations.isEmpty( ) && OB_UtilityConstants.FULFILMENTSTATUS_DRAFT.equalsIgnoreCase( configurations.get( 0 ).NE__Order_Header__r.OB_FulfilmentStatus__c ) )
            {
                List<bit2flow__Historic_Wizard_Data__c> listOfHistoricWD = new List<bit2flow__Historic_Wizard_Data__c>( );
                listOfHistoricWD =
                [
                        SELECT Id,
                                Name,
                                bit2flow__Status__c,
                                bit2flow__Wizard_Id__c,
                                bit2flow__Wizard_Label__c,
                                bit2flow__Wizard_Name__c,
                                OB_OrderHeaderId__c
                        FROM bit2flow__Historic_Wizard_Data__c
                        WHERE OB_OrderHeaderId__c = :orderHeaderId_value
                        ORDER BY CreatedDate DESC
                ];
                if ( !listOfHistoricWD.isEmpty( ) )
                {
                    returnedMap.put( 'historicWizardData', listOfHistoricWD );
                }
            }
            //	START 	andrea.saracini 25/02/2018 - Cancel Order get Asset
            List<Asset> currentAsset = new List<Asset>( );
            List<OB_LogRequest__c> existingLogReq = new List<OB_LogRequest__c>( );
            Boolean canBeCancelled = false; //antonio.vatrano perf52 13-12-2019
            if ( !configurations.isEmpty( ) )
            {
                //antonio.vatrano prodob_293 26/06/2019 add field to query NE__Order_Config__r.OB_ApprovalStatus__c
                currentAsset =
                [
                        SELECT Id, NE__Order_Config__c,NE__Order_Config__r.OB_FulfilmentStatus__c,NE__Order_Config__r.OB_PricingApproval__c,
                                NE__Order_Config__r.NE__Order_Header__r.OB_StartApprovalProcess__c, NE__Order_Config__r.NE__Order_Header__r.OB_Main_Process__c,
                                NE__Order_Config__r.OB_ApprovalStatus__c
                        FROM Asset
                        WHERE NE__Order_Config__c = :configurations.get( 0 ).Id
                        LIMIT 1
                ];
                existingLogReq =
                [
                        SELECT Id
                        FROM OB_LogRequest__c
                        WHERE OB_OrderId__c = :configurations.get( 0 ).Id AND OB_Status__c NOT in ('Bozza')
                ];
                //Start antonio.vatrano perf52 13-12-2019
                if  (   currentAsset.isEmpty( )      && 
                        configurations.get( 0 ).NE__Order_Header__r.OB_Main_Process__c !='Setup' &&
                        configurations.get( 0 ).OB_FulfilmentStatus__c == 'Draft' &&
                        configurations.get( 0 ).ne__order_items__r.isEmpty()
                    )
                {
                    canBeCancelled=true;
                }
                //End antonio.vatrano perf52 13-12-2019
            }
            //simone misani start 21/03/2019 -->  Adding logigs to prevent errors on map nodes
            if ( !currentAsset.isEmpty( ) )
            {
                returnedMap.put( 'currentAsset', currentAsset );
            }
            if ( !existingLogReq.isEmpty( ) )
            {
                returnedMap.put( 'existingLogReq', existingLogReq );
            }
            //simone misani end 21/03/2019
            //	END andrea.saracini 25/02/2018 - Cancel Order get Asset
            //	END 	micol.ferrari 28/12/2018 - RETRIEVE HISTORIC WIZARD DATA
            //simone misani start 21/03/2019 --> Adding logigs to prevent errors on map nodes
            if ( !contextAccount.isEmpty( ) )
            {
                returnedMap.put( 'contextAccount', contextAccount );
            }
            if ( !esecutore.isEmpty( ) )
            {
                returnedMap.put( 'esecutore', esecutore );
            }
            if ( !configurations.isEmpty( ) )
            {
                returnedMap.put( 'configurations', configurations );
            }
            if ( !titolariEffettivi.isEmpty( ) )
            {
                returnedMap.put( 'titolariEffettivi', titolariEffettivi );
            }
            //simone misani end 21/03/2019
            //ANDREA
            returnedMap.put( 'orderHeaders', orderHeaders );
            returnedMap.put( 'canBeCancelled', new List<Boolean>{canBeCancelled} ); //antonio.vatrano perf52 13-12-2019
            System.debug( 'returnedMap: ' + JSON.serialize( returnedMap ) );
            System.debug( 'Success in OB_OrderHeaderDetailsPage_CC:getInfo_apex' );
            return returnedMap;
        }
        catch ( Exception e )
        {
            System.debug( 'Exception in OB_OrderHeaderDetailsPage_CC.getInfo_apex at line ' + e.getLineNumber( ) + '. Error message: ' + e.getMessage( ) );
            return null;
        }
    }

   

	@AuraEnabled 
	public static Map<String, Map<String, List<NE__OrderItem__c>>> getInfoConfigurationItem_apex(String confId)
	{
		System.debug('I am in getInfoConfigurationItem_apex'); 
		try 
		{
			Map<String, Map<String, List<NE__OrderItem__c>>> returnedMap = new Map<String, Map<String, List<NE__OrderItem__c>>>();
			Map<String, List<NE__OrderItem__c>> fatherMap = new Map<String, List<NE__OrderItem__c>>();
			List<NE__OrderItem__c> terminalList = new List<NE__OrderItem__c>();
			List<NE__OrderItem__c> acquiringList = new List<NE__OrderItem__c>();

			// DG 07/02/2019 Added NE__Bundle__c != null condition in OrderItemFathersList Query
			//QUERY a 
			//27/03/19 francesca.ribezzi adding OB_FulfilmentStatus__c and NE__Action__c to this query
			List<NE__OrderItem__c> orderItemFathersList = [SELECT Id, NE__Bundle__c, Ne__Prodid__r.Name,OB_FulfilmentStatus__c, NE__Action__c
								  FROM NE__OrderItem__c 
								  WHERE NE__OrderId__c =: confid AND NE__Parent_Order_Item__c = null AND NE__Bundle_Element__c = null AND NE__Bundle__c != null];
			
			//	START 	micol.ferrari (a.di.domenico) 17/11/2018
			//List<Id> bundleList = new List<Id>();
			//for(NE__OrderItem__c oi : orderItemFathersList) 
			//{
			//	bundleList.add(oi.NE__Bundle__c);
			//}
			
			//List<NE__OrderItem__c> orderItemChildrenList = [SELECT NE__OrderId__c, Ne__Prodid__r.Name, Ne__Prodid__r.RecordType.Developername, NE__Bundle__c, OB_Terminal_Id__c
			//					   FROM NE__OrderItem__c 
			//					   WHERE NE__OrderId__c =: confid AND Ne__Bundle__c IN :bundleList AND (Ne__Prodid__r.RecordType.Developername = 'Terminali' 
			//					   OR Ne__Prodid__r.Recordtype.Developername = 'Acquiring')];
			//27/03/19 francesca.ribezzi adding OB_FulfilmentStatus__c and NE__Action__c to this query
			List<NE__OrderItem__c> orderItemChildrenList = [SELECT 	NE__OrderId__c, 
																	NE__Prodid__r.Name, 
																	NE__Prodid__r.RecordType.Developername, 
																	NE__Bundle__c, 
																	OB_TermId__c, 
																	OB_FulfilmentStatus__c, 
																	NE__Action__c,
                                                                    NE__OrderId__r.OB_Bank_OrderStatus__c, //giovanni spinelli  11/19/2019
                                                                    NE__Qty__c //giovanni spinelli  04/07/2019 PRODOB_45
														   FROM NE__OrderItem__c 
														   WHERE NE__OrderId__c =: confid
														   AND NE__Action__c != 'Remove'    //START AV 04/03/2019 CONS-93
														   AND (NE__Prodid__r.RecordType.Developername = 'Terminali' 
														   OR (NE__Prodid__r.Recordtype.Developername = 'Acquiring' AND NE__Parent_Order_Item__c = null ))]; 
			//	END 	micol.ferrari (a.di.domenico) 17/11/2018														   

			System.debug('numero: ' + orderItemChildrenList.size());
			for(NE__OrderItem__c orderItemFather : orderItemFathersList)
			{
				for(NE__OrderItem__c orderItemChild :  orderItemChildrenList)
				{
					if(orderItemFather.NE__Bundle__c ==  orderItemChild.NE__Bundle__c && orderItemChild.Ne__Prodid__r.RecordType.Developername == 'Terminali')
					{
							terminalList.add(orderItemChild);
					}
					else if(orderItemFather.NE__Bundle__c ==  orderItemChild.NE__Bundle__c && orderItemChild.Ne__Prodid__r.RecordType.Developername == 'Acquiring')
					{
							acquiringList.add(orderItemChild);
					}
				}
				fatherMap.put('Terminali', terminalList.clone());
				fatherMap.put('Acquiring', acquiringList.clone());
				returnedMap.put(orderItemFather.Ne__Prodid__r.Name, fatherMap.clone());
				terminalList.clear();
				acquiringList.clear();
				fatherMap.clear();
			}
            //davide.franzini - F2WAVE2-45 - START
            if(OB_UtilityCallingServices.isCommunityUser()){
                returnedMap.put('isCommunityUser',null);
            }
            //davide.franzini - F2WAVE2-45 - END
			System.debug('returnedMap: ' + returnedMap);
			return returnedMap;
            //	START 	micol.ferrari (a.di.domenico) 17/11/2018
            
        }
        catch ( Exception e )
        {
            System.debug( 'Exception in OB_OrderHeaderDetailsPage_CC.getInfoConfigurationItem_apex at line ' + e.getLineNumber( ) + '. Error message: ' + e.getMessage( ) );
            return null;
        }
    }

    // Start AV 21/02/2019 retrieve field of configuration OB_ShowAttachedDocumentations__c to show or not to show Documents
    @AuraEnabled
    public static string showCmpDocs( string orderHeaderId )
    {
        String toReturn = '';
        List<NE__Order__c> orders = [ SELECT id, OB_ShowAttachedDocs__c FROM NE__Order__c WHERE NE__Order_Header__c = :orderHeaderId LIMIT 1 ];
        if ( !orders.isEmpty( ) )
        {
            toReturn = orders.get( 0 ).OB_ShowAttachedDocs__c;
        }
        else
        {
            system.debug( '@@No ORDER' );
        }
        system.debug( '@@toReturn: ' + toReturn );
        return toReturn;
    }

    // Start AV 21/02/2019 retrieve field of orderHeader OB_Rejection_Reason__c to show or not to show the buttons CARICA/RIMUOVI
    @AuraEnabled
    public static string checkRejectReason( string orderHeaderId )
    {
        String toReturn = '';
        List<NE__Order_Header__c> ohs = [ SELECT id, OB_Rejection_Reason__c FROM NE__Order_Header__c WHERE id = :orderHeaderId LIMIT 1 ];
        if ( !ohs.isEmpty( ) )
        {
            String rejectReason = ohs.get( 0 ).OB_Rejection_Reason__c;
            toReturn = ( rejectReason == 'Documentazione Incompleta' || rejectReason == 'Documentazione Assente' ) ? 'true' : 'false';
        }
        else
        {
            system.debug( '@@No ORDER' );
        }
        system.debug( '@@toReturn: ' + toReturn );
        return toReturn;
    }

    //START andrea.saracini 25/02/2018 - Cancel Order get Asset
    @AuraEnabled
    public static Boolean callCancelOrder( Id orderId )
    {
        if ( orderId == null )
        {
            System.debug( '@@@ OrderId NULL' );
            return false;
        }

        NE.OrderSummaryButtonExtension.cancelButton( orderId );
        NE__Order__c assetOrder = new NE__Order__c(
                Id = orderId,
                OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED,
                OB_CancelledByBank__c = true ); //z.urban@accenture.com 07/05/2019 AF_Funnel-v3.0_CancelledByBank add true value
        System.debug( 'OrderId old and new: ' + orderId + '-' + assetOrder.Id );
        List<NE__OrderItem__c> listOfOI = [ SELECT ID FROM NE__OrderItem__c WHERE NE__OrderId__c = :orderId ];
        for ( NE__OrderItem__c oi : listOfOI )
        {
            oi.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED;
        }
        try
        {
            update listOfOI;
            update assetOrder;
            return true;
        } catch ( Exception e )
        {
            system.debug( '### Error occured message: ' + e.getmessage( ) );
            System.debug( '### Error occured line number: ' + e.getLineNumber( ) );
            return false;
        }

    }
    //	END andrea.saracini 25/02/2018 - Cancel Order get Asset

    /*******************************************************************************
	Purpose:  Method calls method of setting Nexi and Bank Order Status from OB_Order_ChangeStatus
    Parameters: Id orderHeaderId
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       07/05/2019      Created         NEXI-20_order_status_handleLogic
	2.0         Joanna Mielczarek       05/06/2019      Modified        NEXI-99 added update of Order
 	********************************************************************************/
    @AuraEnabled
    public static void setOrderStatusDraftIncompleteOrder( Id orderHeaderId )
    {
        List<NE__Order__c> ordersToUpdate = new List<NE__Order__c>( );
        for ( NE__Order__c loopOrder: [ SELECT Id FROM NE__Order__c WHERE NE__Order_Header__c = :orderHeaderId ] )
        {
            ordersToUpdate.add( OB_Order_ChangeStatus.setOrderStatusDraftIncompleteOrder( loopOrder, true, false, false ) );
        }
       
        OB_Order_ChangeStatus.updateOrdersStatus( ordersToUpdate );
    }

    
    /*******************************************************************************
	Purpose:  method for the change owner for approval
    Parameters: Id orderHeaderId
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Simone Misani       24/06/2019     Created         change owner for approval
	
 	********************************************************************************/

    @AuraEnabled
    public static void changeOwnerForApprovalProcess (Id orderHeaderId){
        try{
            System.debug('orderHeaderId: '+orderHeaderId);
            List<NE__Order__c> listOh = [SELECT id,OwnerId  FROM NE__Order__c WHERE NE__Order_Header__c =: orderHeaderId];
            String userId = UserInfo.getUserId();
            System.debug('changeOwner user id: '+userId);
            System.debug('listOh: '+listOh);
            if(!listOh.isEmpty()){
                NE__Order__c currOrd = listOh.get(0);
                System.debug('listOh.ownerId: '+currOrd.OwnerId);
              
                    currOrd.OwnerId = userId;
                    update currOrd;
                
            }
        }catch  ( Exception e )
        {
			System.debug('Exception in OB_OrderHeaderDetailsPage_CC ::Method --> changeOwner '+e.getMessage()+' at line '+e.getLineNumber());
			
		}	

    }
    /*******************************************************************************
	Purpose:  method to check validity of resuming flow - same user or different user but after 60 minutes
    Parameters: Id order Id
    Returns: Boolean --> true: open flow; false: don't open flow

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Giovanni Spinelli    23/08/2019       Created         check validity resume flow
	
 	********************************************************************************/
    @AuraEnabled
    public static Map<String,String> checkValidityFlow (Id orderId){
        System.debug('INTO CHECKVALIDITYFLOW');
        Map<String,String> toReturn = new Map<String,String>();
        String userName = '';
        String openFlow = 'false';
        List<NE__Order__c> orderList = new List<NE__Order__c>();
        try{
            String currentUserId = UserInfo.getUserId();
            System.debug('CURRENT USER: ' +currentUserId);
            System.debug('current time=' + System.Now().format());
            String currentTime = System.Now().format();
            orderList = [  SELECT id, OB_CheckResumeFlow__c
                        FROM NE__Order__c 
                        WHERE id=: orderId LIMIT 1];
            if(orderList.size() > 0){
                NE__Order__c orderToCheck = orderList.get(0);
                String fieldToCheck = String.valueOf( orderToCheck.OB_CheckResumeFlow__c ); 
                if( String.isNotBlank( fieldToCheck )){
                    /*
                    CHECK IF THE CURRENT USER IS THE SAME OF LAST OPENING FLOW,
                    IN THIS CASE FIRE FLOW,
                    IF USER IS DIFFERENT, CHECK THE TIME
                    IF TIME IS > 60 MINUTES GIVE PERMISSION TO FIRE FLOW
                    ELSE FIRE BANNER MESSAGE
                    */
                    String lastUserId   = fieldToCheck.split('_')[0];
                    String lastTime     = fieldToCheck.split('_')[1];
                    String lastDay      = lastTime.split(' ')[0];
                    String lastHour     = lastTime.split(' ')[1];
                    Double lastHourDouble = Double.valueOf( lastHour );
                    System.debug('lastHour: ' + lastHourDouble);
                    /*
                    FIRST CHECK ON USER
                    IF THE USER IS THE SAME ALWAYS OPEN FLOW
                    ELSE OTHER CHECKS...
                    */
                    if( lastUserId == currentUserId ){
                         openFlow ='true';
                    }else{
                        String currentTimeCheck = System.Now().format();
                        String currentDay  = currentTimeCheck.split(' ')[0];
                        String currentHour = currentTimeCheck.split(' ')[1];
                        Double currentHourDouble = Double.valueOf( currentHour );
                        System.debug('currentHour: ' + currentHourDouble);
                        /*
                        SECOND CHECK ON DATE
                        IF IT IS THE SAME OF TODAY OR LAST DAY IS EMPTY START WITH OTHER CONTROLS
                        ELSE OPEN FLOW AND SAVE THE USER ID AND DATETIME
                        */
                        if(lastDay == currentDay ){
                            /*
                            RETRIEVE HOUR FROM CUSTOM METADATA
                            IT IS A DOUBLE --> 1.00 FOR ONE HOUR, 0.30 FOR 30 MINUTES....
                            */
                            Double extraTime = 0.00;
                            List<OB_ConfigurationInformation__mdt> extraTimeMdt     =[  SELECT Id, OB_String_Value__c
                                                                                        FROM OB_ConfigurationInformation__mdt
                                                                                        WHERE QualifiedApiName ='OB_CheckTimeResumeFlow' 
                                                                                        LIMIT 1];
                            System.debug('extraTimeMdt: ' + extraTimeMdt);
                            if( extraTimeMdt.size() > 0 ){
                                OB_ConfigurationInformation__mdt extTime = extraTimeMdt.get(0);
                                extraTime = Double.valueOf( extTime.OB_String_Value__c );
                            }
                            //CREATE A DOUBLE THAT REPPRESENTS THE VALUE TO MANAGE OPENING OR NOT OPENING FLOW
                            Double checkTime = lastHourDouble + extraTime;
                            System.debug('check time: ' + checkTime);
                            /*
                            IF THE CURRENT TIME IS GREATER THAN ONE HOUR COMPARED TO THE LAST OPENING OF THE FLOW , OPEN FLOW
                            ELSE DONT OPEN FLOW AND RETRIEVE THE USER NAME THAT OPEN FLOW LAST TIME TO 
                            SHOW IN BANNER MESSAGE
                            */
                            if(currentHourDouble >= checkTime ){
                                openFlow = 'true';
                            }else{
                                openFlow = 'false';
                                List<User> userList = [SELECT id,name FROM user WHERE id =: lastUserId limit 1];
                                if(userList.size() > 0 ){
                                    User lastUser = userList.get(0);
                                    userName = lastUser.Name;
                                }
                            }
                        }else{
                            openFlow = 'true';
                        }
                        
                    }

                }else{
                    //STORE IN ORDER HEADER INFORMATION ABOUT USER AND TIME LIKE "00.........wzIZQAY_23/08/2019 11.09"
                    orderToCheck.OB_CheckResumeFlow__c = currentUserId+'_'+currentTime;
                    update orderToCheck;
                    openFlow ='true';
                }
            }
            /*
            PUSH IN RETURN MAP THE BOOLEAN AND USER NAME TO SHOW IN BANNER
            */
            toReturn.put( 'openFlow' , openFlow );
            toReturn.put( 'userName' , userName );
        }
        catch  ( Exception e )
        {
			System.debug( LoggingLevel.ERROR, 'Exception in OB_OrderHeaderDetailsPage_CC ::Method --> checkValidityFlow '+e.getMessage()+' at line '+e.getLineNumber());
			
		}
        return toReturn;
    }
    /*******************************************************************************
	Purpose:    method to create an object (PriceHistory) that contains params to create
                a table in which view the new, old and default values of a POS 
                in order detail page
    Parameters: orderId ,  namePos ,  bundleId ,  idPos (commercial product)
    Returns: String

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Giovanni Spinelli    23/08/2019       Created         check validity resume flow
    2.0         Francesca Ribezzi    28/11/2019         Edit          performance - matrix parameter rows filter
                                                                      offerName changed to bundleId 
	
 	********************************************************************************/
    
     public class PriceHistory
    {
        String id;
        String attributeCode;
        String name;
        Double defaultValue;
        String previousValue;
        String newValue;
        
        
    }
    
    @AuraEnabled
    public static String retrievePriceHistory ( String orderId , String namePos , String bundleId , String idPos){
        Map < String , List< PriceHistory > > tableToReturn = new Map < String , List< PriceHistory > >();
        try{
            System.debug('orderId: ' + orderId);
            System.debug('namePos: ' + namePos);
            System.debug('bundleId: ' + bundleId); 
            System.debug('idPos: ' + idPos);
            NE__Order__c configuration = [SELECT Id, 
                                            OB_CAB__c,
                                            OB_Abi__c,
                                            NE__Order_Header__r.OB_Business_Model_Acquiring__c , //francesca.ribezzi 28/11/19 - performance - adding OH fields
                                            NE__Order_Header__r.OB_Business_Model_POS__c //schema prezzi
                                            FROM NE__Order__c 
                                            WHERE Id =: orderId
                                        ];
            System.debug('configuration: ' + configuration);
            Id rtPricing 			= Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.RTPRICINGPRODUCT ).getRecordTypeId();
            Id rtPriceBankABI		= Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.RTPRICEBANKABI ).getRecordTypeId();
            List<NE__Order_Item_Attribute__c> orderItemAttributeList = [SELECT  id,
                                                                                NE__FamPropExtId__c,
                                                                                NE__Order_Item__r.NE__ProdName__c,
                                                                                NE__Order_Item__r.NE__Root_Order_Item__r.NE__ProdName__c,  
                                                                                NE__Order_Item__r.NE__ProdId__r.RecordType.DeveloperName ,
                                                                                NE__Previous_Attribute_Value__c, 
                                                                                NE__Value__c,
                                                                                NE__Old_Value__c, //giovanni spinelli - 20/11/2019 - PROD-120
                                                                                OB_Attribute_Code__c
                                                                        FROM NE__Order_Item_Attribute__c 
                                                                        WHERE NE__Order_Item__r.NE__OrderId__c=:orderId
                                                                        AND NE__Order_Item__r.NE__Root_Order_Item__r.NE__ProdName__c =: namePos
                                                                        AND NE__Order_Item__r.NE__ProdId__r.RecordTypeId=: rtPricing
                                                                        ];
            System.debug('orderItemAttributeList: ' + orderItemAttributeList);
            Map < String , List< PriceHistory > > table = new Map < String , List< PriceHistory > >();
            List< PriceHistory > pricehistoryList = new List< PriceHistory >();
            for( NE__Order_Item_Attribute__c orderItemAttr : orderItemAttributeList )
            {
                //check only attribute with an attribute code
                if(String.isNotBlank( orderItemAttr.OB_Attribute_Code__c ))
                {

                    System.debug('orderItemAttr.OB_Attribute_Code__c: '+orderItemAttr.OB_Attribute_Code__c);
                    List< PriceHistory > pricehistoryListTmp = new List< PriceHistory >();

                    PriceHistory priceHistory = new PriceHistory();
                    priceHistory.id             =   orderItemAttr.Id;
                    priceHistory.attributeCode  =   orderItemAttr.OB_Attribute_Code__c;
                    String name = orderItemAttr.NE__FamPropExtId__c;
                    //split on name to show in table
                    if(name.contains( ':' )){
                        name = name.split(':')[1];
                        if(name.contains( 'Gratuità' )){
                            name = 'Condizioni particolari/Mesi';
                        }
                    }
                    priceHistory.name           =   name;
                    
                    //set previous and new value as string
                    priceHistory.previousValue  =   orderItemAttr.NE__Previous_Attribute_Value__c;//giovanni spinelli - 20/11/2019 - PROD-120
                    priceHistory.newValue       =   orderItemAttr.NE__Value__c;

                    if( table.containsKey( orderItemAttr.NE__Order_Item__r.NE__ProdName__c ) ){
                        //get current list at each loop if it already contains the key
                        pricehistoryListTmp = table.get(orderItemAttr.NE__Order_Item__r.NE__ProdName__c);
                        
                    }
                    pricehistoryListTmp.add(priceHistory);
                    table.put( orderItemAttr.NE__Order_Item__r.NE__ProdName__c ,  pricehistoryListTmp );
                }
                
            }
            System.debug('orderItemAttributeList: ' + JSON.serialize(table));
            /**
            *check if there are mpr with the abi and cab of context configuration 
            *if yes the next query on mpr will be with cab filter
            *else with cab == null
            */    
            AggregateResult[] groupedResults = [SELECT count(Id)
                                                FROM NE__Matrix_Parameter_row__c
                                                WHERE OB_ABI_BANCA__c = :configuration.OB_Abi__c
                                                AND OB_Cab__c = :configuration.OB_Cab__c
                                                AND  OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Name__c  =: namePos
                                                AND RecordType.Id =: rtPriceBankABI 
                                                AND NE__Matrix_Parameter__r.Name = 'CatalogoNexi'//francesca.ribezzi 28/11/19 - performance - adding filters on query
                                                AND OB_Offerta_2__c  = :bundleId
                                                AND OB_ModelloAcquiring__c = :configuration.NE__Order_Header__r.OB_Business_Model_Acquiring__c
                                                AND OB_Schema_Prezzi__c includes (:configuration.NE__Order_Header__r.OB_Business_Model_POS__c)
                                                AND OB_SelfLookup__c > ''
                                        ];
            Double cabMPNumber = (Double)groupedResults[0].get('expr0');
            System.debug('cabMPNumber: ' + cabMPNumber);
            String cabQuery = cabMPNumber > 0 ? configuration.OB_Cab__c : '';
            System.debug('cabQuery: ' + cabQuery);
            List<NE__Matrix_Parameter_Row__c> mprList = [   SELECT OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Name__c, 
                                                            OB_Default_Banca__c,
                                                            OB_Componente__r.NE__Product_Name__c, 
                                                            OB_Family__r.Name, 
                                                            OB_DynamicPropertyDefinition__r.Name, 
                                                            OB_Codici__c, 
                                                            NE__Matrix_Parameter__c, 
                                                            NE__Active__c, 
                                                            OB_ABI_BANCA__c, 
                                                            OB_Bank_Model__c, 
                                                            OB_Bank_Read_Only__c, 
                                                            OB_CatalogItem__c,
                                                            OB_Componente__c, 
                                                            OB_DynamicPropertyDefinition__c,
                                                            OB_Fam__c, 
                                                            OB_Family__c, 
                                                            OB_Valore_Default__c, 
                                                            OB_Visible__c, 
                                                            OB_Read_Only_CAB__c, 
                                                            NE__Matrix_Parameter__r.Name  
                                                            FROM NE__Matrix_Parameter_Row__c  
                                                            WHERE OB_ABI_BANCA__c =: configuration.OB_Abi__c 
                                                            AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__Product_Name__c =: namePos
                                                            AND RecordTypeId =: rtPriceBankABI 
                                                            AND OB_Componente__r.NE__Parent_Catalog_Item__r.NE__ProductId__c =: idPos//id smart pos da frontend
                                                            AND OB_Offerta_2__c  = :bundleId
                                                            AND OB_Cab__c = :cabQuery
                                                            AND NE__Matrix_Parameter__r.Name = 'CatalogoNexi' // francesca.ribezzi 28/11/19 - performance - adding filters on query
                                                            AND OB_ModelloAcquiring__c = :configuration.NE__Order_Header__r.OB_Business_Model_Acquiring__c
                                                            AND OB_Schema_Prezzi__c includes  (:configuration.NE__Order_Header__r.OB_Business_Model_POS__c)
                                                            AND  OB_SelfLookup__c > ''
                                                            ];
            System.debug('mprList size: ' + mprList.size());
            System.debug('mprList: ' + JSON.serialize( mprList ) );
            System.debug('table.keySet(): ' + table.keySet());
            tableToReturn = table;
            //loop to add default value in table object
            for( String key : table.keySet() ){
                System.debug('@@KEY: ' + key);
                //create a tmp list for each key 
                List< PriceHistory > pricehistoryListTmp        = table.get( key );
                // List< PriceHistory > pricehistoryListTmpRemoved = table.get( key );
                //List<Integer> counterTmp = new List<Integer>();
                /**
                *inverse loop to remove from last element to first
                *for each iteration the i is updated with list withou removed element
                */
                for( Integer i =  (pricehistoryListTmp.size() - 1); i>=0 ; i-- )
                {
                    
                    PriceHistory priceHistory = pricehistoryListTmp.get( i );
                    System.debug('priceHistory['+i+']: ' + priceHistory);
                    for( NE__Matrix_Parameter_Row__c mpr : mprList )
                    {
                    
                        //check each mpr with each element in list to match criteria
                        if( mpr.OB_Componente__r.NE__Product_Name__c == key && mpr.OB_Codici__c == priceHistory.attributeCode )
                        {
                            //set default value
                            priceHistory.defaultValue =  mpr.OB_Valore_Default__c  	;
                            //write the new value string as double format
                            String newValue    = priceHistory.newValue == null ? '0.00' : priceHistory.newValue;
                            newValue = newValue.replace(',' , '.');
                            Double newValueDouble = Double.valueOf( newValue );
                            //check if default value is equal of new value, remove element from list
                            System.debug('priceHistory to remove: '+ priceHistory.previousValue);
                            if( priceHistory.previousValue == null){
                                System.debug('into if previous null');
                                if(priceHistory.defaultValue == newValueDouble   ){
                                    pricehistoryListTmp.remove(i);
                                }
                            }else{
                                //else if the previous value is not null, compare it with default value
                                System.debug('into if previous not null');
                                String previousValue    = priceHistory.previousValue == null ? '0.00' : priceHistory.previousValue;
                                previousValue = previousValue.replace(',' , '.');
                                Double previousValueDouble = Double.valueOf( previousValue );

                                if(priceHistory.defaultValue == newValueDouble &&  priceHistory.defaultValue == previousValueDouble ){
                                    pricehistoryListTmp.remove(i);
                                }
                            }
                           break; 
                        }
                    }
                    
                }
                
                //if the tmp list (with specific key) is null, remove the node
                if( pricehistoryListTmp.size() == 0 ){
                    tableToReturn.remove( key );
                }
            }

            System.debug('table final : ' + JSON.serialize( tableToReturn ));
            
        }catch( Exception e ){
            System.debug( LoggingLevel.ERROR, 'Exception in OB_OrderHeaderDetailsPage_CC ::Method --> retrievePriceHistory '+e.getMessage()+' at line '+e.getLineNumber());

        }
        return JSON.serialize( tableToReturn );
    }
    /*******************************************************************************
	Purpose:  method to update order and order header status after the resume flow of a quote
    Parameters: Id Order, Id OrderHeader
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         17/09/2019      Created         Change order status after 
                                                                        resume the flow of a quote
	
 	********************************************************************************/
    @AuraEnabled
    public static void setOrderStatusDraft(Id orderToUpdate){
        try{
            List<NE__Order__c> order = [SELECT Id, 
                                        OB_Nexi_OrderStatus__c,
                                        OB_Bank_OrderStatus__c,
                                        // OB_FulfilmentStatus__c, //g.v. 01/10/2019
                                        OB_Nexi_LastStatusChange__c,
                                        OB_Bank_LastStatusChange__c
                                        // NE__Order_Header__r.OB_FulfilmentStatus__c //g.v. 01/10/2019
                                        FROM NE__Order__c
                                        WHERE Id =: orderToUpdate
                                        LIMIT 1];
            if(!order.isEmpty() && order != null){
                order[0].OB_Nexi_OrderStatus__c = System.Label.OB_OrderStatusDraft;        
                order[0].OB_Bank_OrderStatus__c = System.Label.OB_OrderStatusDraft;
                // order[0].OB_FulfilmentStatus__c = System.Label.OB_OrderStatusDraft; //g.v. 01/10/2019
                // order[0].NE__Order_Header__r.OB_FulfilmentStatus__c = System.Label.OB_OrderStatusDraft; //g.v. 01/10/2019
                order[0].OB_Nexi_LastStatusChange__c= System.now();
                order[0].OB_Bank_LastStatusChange__c= System.now();
                update order;
            }
        }catch (DmlException dmlException) {
            System.debug( LoggingLevel.ERROR, 'Exception in OB_OrderHeaderDeatailsPage.setOrderStatusDraft : ' + dmlException );
        }
    }
    /*******************************************************************************
	Purpose:  method to set the owner and update order items after the resume flow of a quote
    Parameters: Id Order, Id currentUser
    Returns: Boolean

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         17/09/2019      Created         Assign the owner and change 
                                                                        order items status after 
                                                                        resume the flow of a quote
	
 	********************************************************************************/
    @AuraEnabled                       
    public static Boolean changeOrderStatusServer( Id orderId, String currentUserId ){
        Boolean toReturn = OB_ItemsToApprove_CC.changeOrderStatusServer(orderId, currentUserId);
        return toReturn;
    }
    /*******************************************************************************
	Purpose:  method to set the correct step of the flow
    Parameters: Id historicWizard
    Returns: Id

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         17/09/2019      Created         Assign the correct
                                                                        step of the flow
	
 	********************************************************************************/
    @AuraEnabled
    public static Id changeJumpToStepHistoricAttachment( String historicWizardId ){
        Id wizardId = OB_ItemsToApprove_CC.changeJumpToStepHistoricAttachment(historicWizardId);
        return wizardId;
    }
    /*******************************************************************************
	Purpose:  method to retrieve flow data
    Parameters: List of configurations
    Returns: Map of String, String with order Id and wizard Id

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         17/09/2019      Created         Retrieve flow data
	
 	********************************************************************************/
    @AuraEnabled
    public static Map<String,String> retrieveHistoricWizardData(List<NE__Order__c> configurations){
        Map<String,String> toReturn = new Map<String,String>();
        toReturn = OB_ItemsToApprove_CC.retrieveHistoricWizardData(configurations);
        return toReturn;
    }

}