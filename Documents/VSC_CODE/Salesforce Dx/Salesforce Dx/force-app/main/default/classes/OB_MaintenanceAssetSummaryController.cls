public without sharing class OB_MaintenanceAssetSummaryController {

	/*******************************************************************************
	Purpose:  method to create order items - performance
    Parameters: -
    Returns: Boolean

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         enrico.purificato        17/12/2019      Created        moved from catalog controller
	
 	********************************************************************************/
    @auraEnabled
	public static Boolean callAssetToOrderItemServer(Id orderId, Id offerAssetId)
	{

		String typeAs = 'Change';
		
		try{
            List<asset> assetsToUpdate 		= new List<asset>();
			List<asset> assetToShare 		= new List<asset>();

			OB_Asset2Order asset2OrderUtils = new OB_Asset2Order();

			String selectBody = asset2OrderUtils.getAssetBody();
			system.debug('@@ ib: ' + selectBody);
			
			String 	assetQuery  = 'SELECT ' + selectBody;
					assetQuery += ' FROM asset where RootAssetId = :offerAssetId AND NE__Status__c =\'Active\' LIMIT 1';
			
			System.debug('@@@ assetQuery' + assetQuery);
			Asset rootAsset = Database.query(assetQuery);
			 	
				 	assetQuery  = 'SELECT ' + selectBody;
					assetQuery += ' FROM asset where NE__Bundle_Configuration__c = :offerAssetId AND NE__Status__c =\'Active\'';
			
			System.debug('@@@ assetQuery' + assetQuery);
			List<Asset> childsAsset = Database.query(assetQuery);

			Id bundleId = rootAsset.NE__Bundle__c;
			
			NE__Order__c newOrder 	= [ SELECT OB_AdditionalDocumentationRequired__c, OB_CTI_Code__c, 
									NE__Order_Header__r.OB_Sub_Process__c, NE__BillingProfId__c,
									OB_AgreedChanges__c ,OB_GT__c,OB_MCCL2__c,
									NE__AccountId__c,NE__BillAccId__c, NE__ServAccId__c, 
									OB_CAB__c,OB_ABI__c,Id,OB_MCC__c,NE__Order_Header__r.OB_Main_Process__c,
									NE__Order_Header__r.OB_Business_Model_Acquiring__c, 
									NE__Order_Header__r.OB_Business_Model_POS__c,OB_Service_Point__r.NE__City__c, 
									OB_Service_Point__c,OB_Service_Point__r.OB_MCC__c, OB_ReceiptCity__c,NE__Order_Header__c, 
									NE__Order_Header__r.OB_ABI__c, OB_ShopSign__c, Name, NE__Order_date__c, 
									NE__OrderStatus__c, OB_Variation__c, OB_ReceiptHeader__c,OB_SettlementType__c,
									OB_InternationalSettlementMethod__c,OB_PBSettlementMethod__c,
									OB_isSkipToIntBE__c,OB_Active_Terminals__c
									FROM NE__Order__c 
									where id = :orderId ];

			

			Id newOrderId = newOrder.Id;
			Map<String,Id> extIdMap = asset2OrderUtils.generateOrderItems(childsAsset, newOrder.Id,rootAsset,typeAs);
			
			selectBody = asset2OrderUtils.getAttributeBody();
			// selectBody += ', NE__AttrEnterpriseId__c'; // davide.franzini - WN-187 - 26/07/2019
			String 	assetAttributeQuery  = 'SELECT ' + selectBody;
							assetAttributeQuery  +=' FROM NE__assetitemattribute__c';
							assetAttributeQuery  +=' WHERE (NE__Asset__r.NE__Bundle_Configuration__c =:offerAssetId OR NE__Asset__c= :offerAssetId) AND NE__Asset__r.NE__Status__c =\'Active\'';


			List<NE__assetitemattribute__c> asseAttributeList = Database.query(assetAttributeQuery);
			List<NE__assetitemattribute__c> asseAttributeUpdateList = new List<NE__assetitemattribute__c>(); // enrico.purificato WN-187

			List<NE__order_item_attribute__c> newAttributesList = asset2OrderUtils.generateItemAttribute(asseAttributeList,extIdMap,newOrder.Id);
			insert newAttributesList;			

			rootAsset.NE__Status__c= 'In Progress';
			rootAsset.NE__Order_Config__c = newOrderId;
			assetsToUpdate.Add(rootAsset); 

			for(Asset a : childsAsset)
			{
				a.NE__Status__c= 'In Progress';
				a.NE__Order_Config__c = newOrderId;
				assetsToUpdate.Add(a); 

			}

			update assetsToUpdate;
			
		}
		catch(Exception e){	
			System.debug('error in updating callAssetToOrderItemServer: ' + e.getLineNumber()+ ' ' + e.getMessage());
			return false;
		}	
		return true; 
	
	}

   	@auraEnabled
	public static objWrapper callAssetToOrderServer(Boolean isReplacement,Id offerAssetId,Boolean isEditCommissionModel, Boolean isPricing, String userABI, String userCAB, String accId, Boolean isTerminate,Boolean isSkipToIntBE)
	{
		System.debug('@@@ CODE START');
		objWrapper obj = new objWrapper();

		String typeAs = 'Change';
		if(isTerminate){
			typeAs = 'Disconnect';
		}
		Integer activeTerminals = 0; 
		Boolean assetChanged = false; //enrico.purificato 23/10/20191 performance

		try{
            List<asset> assetsToUpdate 		= new List<asset>();
			List<asset> assetToShare 		= new List<asset>();

			OB_Asset2Order asset2OrderUtils = new OB_Asset2Order();

			String selectBody = asset2OrderUtils.getAssetBody();
			system.debug('@@ ib: ' + selectBody);

			String 	assetQuery  = 'SELECT ' + selectBody;
					assetQuery += ' FROM asset where RootAssetId = :offerAssetId AND NE__Status__c =\'Active\' LIMIT 1';
			
			System.debug('@@@ assetQuery' + assetQuery);
			Asset rootAsset = Database.query(assetQuery);
			 	
				 	assetQuery  = 'SELECT ' + selectBody;
					assetQuery += ' FROM asset where NE__Bundle_Configuration__c = :offerAssetId AND NE__Status__c =\'Active\'';
			
			System.debug('@@@ assetQuery' + assetQuery);
			List<Asset> childsAsset = Database.query(assetQuery);

			obj.bundleId = rootAsset.NE__Bundle__c;

            System.debug('rootAsset: ' + rootAsset);
            System.debug('rootAsset.NE__Order_Config__r.NE__BillingProfId__c: ' + rootAsset.NE__Order_Config__r.NE__BillingProfId__c);
			//if NE__Item_Code__c is null, setting itemCode with the assetId

			assetToShare.add(rootAsset);
			//enrico.purificato WN-187 START
			Boolean notValidCode 	= String.isBlank(rootAsset.NE__Item_Code__c);
			Boolean notValidEntId 	= String.valueOf(rootAsset.Id) != String.valueOf(rootAsset.NE__AssetItemEnterpriseId__c);
			Boolean notValidAsset	= notValidEntId || notValidCode;

			if(notValidAsset){
				//rootAsset
				if(notValidCode){
					rootAsset.NE__Item_Code__c = rootAsset.Id;
					assetChanged = true; //enrico.purificato 23/10/20191 performance
				}
				if(notValidEntId){
					rootAsset.NE__AssetItemEnterpriseId__c = rootAsset.Id;
					assetChanged = true;
				}
				assetsToUpdate.add(rootAsset);
			}
			//enrico.purificato WN-187 END

			// DG - 19/03/2019 - CONS-47 - START
			// Save settlement fields on items in variables for settings them back in the new order
			String SettlementType 					 = '';
			String PBSettlementMethod 				 = '';
			// childAssets loop
			
			for(Asset a : childsAsset)
			{
				//enrico.purificato WN-187 START
				notValidCode 	= String.isBlank(a.NE__Item_Code__c);
				notValidEntId 	= String.valueOf(a.Id) != String.valueOf(a.NE__AssetItemEnterpriseId__c);
				notValidAsset	= notValidEntId || notValidCode;

				if(notValidAsset){

					if(notValidCode){
						a.NE__Item_Code__c = a.Id;
					}
					if(notValidEntId){
						a.NE__AssetItemEnterpriseId__c = a.Id;
					}
					assetsToUpdate.add(a);
				}
				//enrico.purificato WN-187 END

				assetToShare.add(a); //elena.preteni WN-145
				if(a.NE__ProdId__r.RecordType.DeveloperName == 'Acquiring')
				{
					if(String.isBlank(SettlementType) && !(String.isBlank(a.OB_SettlementType__c)))
					{
						SettlementType = a.OB_SettlementType__c;
					}
				
				}
				else if(a.NE__ProdId__r.RecordType.DeveloperName == 'Terminali')
				{
					activeTerminals ++;
					
					if(String.isBlank(SettlementType) && !(String.isBlank(a.OB_SettlementType__c)))
					{
						SettlementType = a.OB_SettlementType__c;
					}
					
					if(String.isBlank(PBSettlementMethod) && !(String.isBlank(a.OB_PBSettlementMethod__c)))
					{
						PBSettlementMethod = a.OB_PBSettlementMethod__c;
					}
				}
			}

			//enrico.purificato WN-187 START
			if(assetsToUpdate.size()>0)
			{
				update assetsToUpdate;
			}
			//enrico.purificato WN-187 END
			//davide.franzini - 26/08/2019 - F2WAVE2-178 - added terminal_id and applicant rac code sia fields
			OB_UtilityCallingServices.shareAssetWrapper(JSON.serialize(assetToShare));//elena.preteni WN-145 19/07/2019
			OB_Bank_Profile__c bankProfile = [SELECT OB_Bank__c,
													OB_Apm_Circuit__c,
													OB_Circuit__c,
													OB_VAS__c,
													OB_Other_Acquirer__c,
													OB_Business_Model_Acquiring__c,
													OB_Business_Model_POS__c,
													OB_NDG__c,
													OB_Applicant_RAC_Code_SIA__c,
													OB_Terminal_Id_Generator__c,
													OB_Terminal_Id_Gateway__c,
													OB_NeedBIO__c
													FROM OB_Bank_Profile__c 
													WHERE OB_Bank__r.OB_ABI__c = :userABI LIMIT 1];
			
			obj.needBIO = bankProfile.OB_NeedBIO__c;
			
			NE__Order_Header__c orderHeader = asset2OrderUtils.generateOrderHeader(rootAsset,typeAs,bankProfile,isPricing,isReplacement,isTerminate);
			orderHeader.OB_CAB__c 	= userCAB;
			insert orderHeader;

			obj.variationType 		= orderHeader.OB_Sub_Process__c;
			obj.newOrder 			= asset2OrderUtils.generateOrder(rootAsset,typeAs,orderHeader,isEditCommissionModel);

			obj.newOrder.OB_SettlementType__c 					= SettlementType;
			obj.newOrder.OB_InternationalSettlementMethod__c 	= rootAsset.NE__Order_Config__r.OB_InternationalSettlementMethod__c;  //francesca.ribezzi 06/09/19 - WN-368- setting OB_InternationalSettlementMethod__c
			obj.newOrder.OB_PBSettlementMethod__c 				= PBSettlementMethod;
			obj.newOrder.OB_isSkipToIntBE__c					= isSkipToIntBE;
			obj.newOrder.OB_Active_Terminals__c 				= activeTerminals;
			
			insert obj.newOrder;
			//enrico.purificato 23/10/2019 performance START
			List<NE__AssetItemAttribute__c> attributeToUpdate = new List<NE__AssetItemAttribute__c>();
			for(NE__AssetItemAttribute__c currentAttribute : [SELECT Id,NE__AttrEnterpriseId__c 
																FROM NE__AssetItemAttribute__c 
																WHERE NE__Asset__c = :offerAssetId
																OR NE__Asset__r.NE__Bundle_Configuration__c = :offerAssetId])
			{
				if(currentAttribute.NE__AttrEnterpriseId__c != currentAttribute.Id)
				{
					currentAttribute.NE__AttrEnterpriseId__c = currentAttribute.Id;
					attributeToUpdate.add(currentAttribute);
				}
			}
			if(attributeToUpdate.size()>0)
			{
				assetChanged = true;
				update attributeToUpdate;
			}
			//davide.franzini - 11/12/2019 - added OB_EXCH_Commission__c
			obj.newOrder  = [ SELECT OB_AdditionalDocumentationRequired__c, OB_CTI_Code__c, 
						NE__Order_Header__r.OB_Sub_Process__c, NE__BillingProfId__c,
						OB_AgreedChanges__c ,OB_GT__c,OB_MCCL2__c,
						NE__AccountId__c,NE__BillAccId__c, NE__ServAccId__c, 
						OB_CAB__c,OB_ABI__c,id,OB_MCC__c,NE__Order_Header__r.OB_Main_Process__c,
						NE__Order_Header__r.OB_Business_Model_Acquiring__c, 
						NE__Order_Header__r.OB_Business_Model_POS__c,OB_Service_Point__r.NE__City__c, 
						OB_Service_Point__c,OB_Service_Point__r.OB_MCC__c, OB_ReceiptCity__c,NE__Order_Header__c, 
						NE__Order_Header__r.OB_ABI__c, OB_ShopSign__c, Name, NE__Order_date__c, 
						NE__OrderStatus__c, OB_Variation__c, OB_ReceiptHeader__c, OB_EXCH_Commission__c
						FROM NE__Order__c 
						where id = :obj.newOrder.Id ];
			
			String session = rootAsset.OB_B2W_Session__c;
			//Simone Misani 14/12/2019 Performance START
			try{
				if(typeAs=='Change' && !String.isBlank(session) && session.contains('#') && !assetChanged )
				{
				
				// if(String.isBlank(session) || !session.contains('#') || assetChanged)
				// {
				// 	Set<Id> tmpSet = new Set<Id>();
				// 	tmpSet.add(rootAsset.Id);
				// 	Database.executeBatch(new OB_CreateSessionFromAsset(tmpSet));
				// 	throw new OB_Utility.applicationException('Messaggio di errore');
				// }
        		
					List<String> sessionList = session.split('#');
					String attachmanetIdId = sessionList[0];
					Attachment configurationAttachments = [SELECT Id, ParentId from Attachment 
																WHERE Id =:attachmanetIdId ];
					
					String sessionId = configurationAttachments.ParentId;
					List<NE__Order__c> configurationControllerList = new List<NE__Order__c>();
					configurationControllerList.add(obj.newOrder);

					configurationAttachments.Body = Blob.valueof(JSON.serialize(configurationControllerList));
					
					update configurationAttachments;
					obj.sessionId = sessionList[1];
					return obj; 
				}

			}catch(Exception e){	
				System.debug('Exception Session line : '+ e.getLineNumber()+ ' message ' + e.getMessage());
			}
			//Simone Misani 14/12/2019 Performance END

			obj.sessionId = null;

			//enrico.purificato 23/10/2019 performance END

			Id newOrderId = obj.newOrder.Id;
			Map<String,Id> extIdMap = asset2OrderUtils.generateOrderItems(childsAsset, obj.newOrder.Id,rootAsset,typeAs);
			
			selectBody = asset2OrderUtils.getAttributeBody();
			// selectBody += ', NE__AttrEnterpriseId__c'; // davide.franzini - WN-187 - 26/07/2019
			String 	assetAttributeQuery  = 'SELECT ' + selectBody;
							assetAttributeQuery  +=' FROM NE__assetitemattribute__c';
							assetAttributeQuery  +=' WHERE (NE__Asset__r.NE__Bundle_Configuration__c =:offerAssetId OR NE__Asset__c= :offerAssetId) AND NE__Asset__r.NE__Status__c =\'Active\'';
			
			System.debug('@@@ assetAttributeQuery' + assetAttributeQuery);

			List<NE__assetitemattribute__c> asseAttributeList = Database.query(assetAttributeQuery);
			List<NE__assetitemattribute__c> asseAttributeUpdateList = new List<NE__assetitemattribute__c>(); // enrico.purificato WN-187

			//davide.franzini - WN-187 - 26/07/2019 - fix item duplication - START
			for(NE__AssetItemAttribute__c astItAttr : asseAttributeList){
				if(String.valueOf(astItAttr.Id) != String.valueOf(astItAttr.NE__AttrEnterpriseId__c)){
					astItAttr.NE__AttrEnterpriseId__c = astItAttr.Id;
					asseAttributeUpdateList.add(astItAttr); // enrico.purificato WN-187
				}
			}
			//davide.franzini - WN-187 - 26/07/2019 - fix item duplication - END
			// enrico.purificato WN-187 START
			if(asseAttributeUpdateList.size()>0){
				update asseAttributeUpdateList;
			}
			// enrico.purificato WN-187 START
			system.debug('@@@ START ATTRIBUTE');
			List<NE__order_item_attribute__c> newAttributesList = asset2OrderUtils.generateItemAttribute(asseAttributeList,extIdMap,obj.newOrder.Id);
			system.debug('@@@ END ATTRIBUTE');
			insert newAttributesList;
			system.debug('@@@ END ATTRIBUTE DB');
			
			assetsToUpdate.clear(); // enrico.purificato WN-187 WN-189

			rootAsset.NE__Status__c= 'In Progress';
			rootAsset.NE__Order_Config__c = newOrderId;
			assetsToUpdate.Add(rootAsset); // enrico.purificato WN-187

			for(Asset a : childsAsset)
			{
				a.NE__Status__c= 'In Progress';
				a.NE__Order_Config__c = newOrderId;
				assetsToUpdate.Add(a); // enrico.purificato WN-187

			}

			update assetsToUpdate;

			system.debug('@@@ END CODE');
			
			
		}
		catch(Exception e){	
			System.debug('error in updating callAssetToOrderServer: ' + e.getLineNumber()+ ' ' + e.getMessage());
			return null;
		}	
		return obj; 
	
	}
    
	@auraEnabled
	public static Boolean getCommissionServer(string offerAssetId, string offerName){ //list<string> fieldsToRetrive, 
		System.debug('@@@ into getCommissionServer');
		
		Boolean isAcqCommission = false;
        string  soql = 'Select id FROM ASSET ';
       /* for (string field : fieldsToRetrive){
            soql+= field+' , ';
        }
        soql = soql.removeEnd(' , ');
        soql+=' FROM ASSET';*/
		//getting acquiring assets with recordType Commissione:
        Id rtCommission = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Commissione').getRecordTypeId(); // TO DO - Remove terminal , sobstitute with constants
        System.debug('@@@ rtCommissiont: ' + rtCommission);
        soql+=  ' where NE__Bundle_Configuration__c =\''+offerAssetId+'\' and NE__ProdId__r.RecordTypeid = \''+rtCommission+'\' and NE__Root_Order_Item__c = \'\'';
        System.debug('@@@ soql: ' + soql);
        List<Asset> assets =  Database.query(soql);
        System.debug('@@@ commission asset list: ' + assets.size());
        
        if(assets.size() > 0 && offerName != 'Offerta Start'){
			isAcqCommission = true;
        }
        
        return isAcqCommission;
	}
	
	  public class objWrapper{
	        @auraEnabled 
	        public NE__Order__c newOrder;
	        @auraEnabled 
	        public string bundleId;
	        @auraEnabled 
	        public string variationType;
			@auraEnabled 
	        public Boolean needBIO;
			@auraEnabled 
	        public String sessionId; //enrico.purificato 23/102019 performance
	  }
	
	@AuraEnabled
	public static void share(Map<String,Object> bankAccountMap, NE__Order_Header__c orh, NE__Service_Point__c sp, Account acc,Boolean isCommunity){
		system.debug('Maintenance Share');
	  	OB_UtilityCallingServices.createShare(bankAccountMap,orh,sp,acc,isCommunity);
	}
	@auraEnabled
	public static String createLogRequest(String merchantId, String servicePointId, String confId, String abi, String cab, String subProcess, Boolean checkBIO){ 
		
		OB_LogRequest__c  logRequest = new OB_LogRequest__c();
		Boolean logSuccess = false;
		
		try{ 		
			// <daniele.gandini@accenture.com> - 05/07/2019 - TerminaOfferta_LogRequStatus - start
			String orderHeaderId;
			if(subProcess == OB_UtilityConstants.HEADER_SUBPROCESS_TERMINAOFFERTA){
				List<NE__Order__c> orderList = [SELECT Id, NE__Order_Header__c FROM NE__Order__c WHERE Id = :confId];
				if(orderList.size() == 1){
					 orderHeaderId = orderList[0].NE__Order_Header__c;
					OB_Utility.changeStatus(orderHeaderId);
				}
				//START----Simone Misani 107 13/07/2019
				List<NE__OrderItem__c> newOrderItemList = new List<NE__OrderItem__c>();
				List<NE__OrderItem__c> orderItemList =[SELECT id,NE__Status__c,OB_isNotIntegrated__c, NE__Action__c,NE__OrderId__r.NE__Order_Header__c ,NE__ProdId__r.RecordType.DeveloperName,NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName, Name FROM NE__OrderItem__c where NE__OrderId__c =: confId]; // antonio.vatrano 05/09/2019 wn-347 add field to query
				for(NE__OrderItem__c oi : orderItemList){
						//oi.NE__Status__c = OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED;
						 orderHeaderId = oi.NE__OrderId__r.NE__Order_Header__c;
						oi.NE__Action__c = OB_UtilityConstants.ORDERITEM_ACTION_REMOVE;
						//Simone Misani WN-573 START
						if(oi.NE__ProdId__r.RecordType.DeveloperName == 'Terminali' || oi.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Terminali'){
							oi.OB_isNotIntegrated__c = false;
						}else{
							oi.OB_isNotIntegrated__c = true;
						} //antonio.vatrano 05/09/2019 wn-347 if TERMINA OFFERTA, OB_isNotIntegrated__c = true
						//Simone Misani WN-573  STOP
						newOrderItemList.add(oi);					
				}
				update newOrderItemList;
				//END----Simone Misani 107 13/07/2019
			}
			// <daniele.gandini@accenture.com> - 05/07/2019 - TerminaOfferta_LogRequStatus - stop
				// START elena.preteni descoping consistenza
			List<NE__Service_Point__c> sp = [SELECT id,OB_Typology__c FROM NE__Service_Point__c WHERE id = :servicePointID ];
			// END elena.preteni descoping consistenza
			String rtConsistenza 				= 	  [select id,DeveloperName  from RecordType where SobjectType ='OB_LogRequest__c' and DeveloperName ='OB_Consistenza' LIMIT 1].Id;
			logRequest.OB_Status__c       		=     OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
			logRequest.OB_AccountId__c         	=     merchantId;
			logRequest.OB_ServicePointId__c 	=     servicePointId;
			logRequest.OB_OrderId__c        	=     confId;
			logRequest.OB_ABI__c            	=     abi;
			logRequest.OB_CAB__c            	=     cab;
			logRequest.OB_MaintenanceType__c	=     (sp!= null && sp.get(0).OB_Typology__c == 'Virtuale') ? OB_UtilityConstants.CONSISTENZA_ECOMMERCE  : OB_UtilityConstants.CONSISTENZA;
			logRequest.OB_HasAcquiring__c   	=     true; 
			logRequest.OB_HasPos__c            	=     (sp.get(0).OB_Typology__c == 'Virtuale') ? true: false;// Simone Misani 07/10/2019
			logRequest.RecordTypeId            	=     rtConsistenza;     
			logRequest.OB_RequestDate__c	    =     Date.today(); 
			// <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - start
			// START--Simone Misani  set  required field  23/08/2019
			Boolean isPartnerCommunityLogged = OB_Utility.isPartnerCommunity( UserInfo.getUserId( ) );
			if ( isPartnerCommunityLogged )
			{
				logRequest.OB_Requestor__c = OB_UtilityConstants.Banca;
			}        // END--Simone Misani  set  required field  23/08/2019
			// <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - stop
		
			insert logRequest;
			logSuccess = true;
			//Simone Misani WN-573 START
			if(logRequest.OB_MaintenanceType__c == OB_UtilityConstants.CONSISTENZA && subProcess == OB_UtilityConstants.HEADER_SUBPROCESS_TERMINAOFFERTA){
					System.enqueueJob(new OB_QueueableClass(orderHeaderId));
			}
			//Simone Misani WN-573 STOP
		}catch(Exception e){	
			System.debug('Exception creating a log request: ' + e.getMessage());
			System.debug('Exception type caught: ' + e.getTypeName());    
			System.debug('Message: ' + e.getMessage());    
			System.debug('Cause: ' + e.getCause());
			System.debug('Line number: ' + e.getLineNumber());    
			System.debug('Stack trace: ' + e.getStackTraceString()); 
			logSuccess = false;
		}
		
		//Boolean logSuccess = OB_CatalogController.createLogRequestServer(merchantId, servicePointId, confId, abi, cab, subProcess, checkBIO);
		if(!logSuccess){
			return '';
		}
		String baseUrl = OB_ContinuationCOntroller.getVFBaseURL(); 
		baseUrl += '/' + logRequest.Id;
		System.debug('@@@ baseUrl ' + baseUrl); 
		return baseUrl;
	}
	/* andrea.morittu START 20.04.2019 - ID_Stream_6_Subentro*/
	@AuraEnabled
    public static String launchMaintenanceWizard( String wizardName ){
        return OB_RunWizard_CC.getWizardIdFromAPIName( wizardName );
    }

	@AuraEnabled
	public static Boolean getMerchantTakeoverFromAsset(String offerAssetId){
		Boolean toReturn;
		if(String.isNotBlank(offerAssetId)) {
			Asset currentAsset = [	SELECT Id, Name, OB_MerchantTakeover__c
										FROM Asset
										WHERE Id =: offerAssetId];
			if(currentAsset.OB_MerchantTakeover__c) {
				toReturn = true;
			} else {
				toReturn = false;
			}
		}
		System.debug('## OB_MerchantTakeover__c is : ' + toReturn);
		return toReturn;
	}
	/* andrea.morittu END 20.04.2019 - ID_Stream_6_Subentro*/

	/*
		@Author	: 	ANDREA MORITTU
		@Date 	:	2019.05.08
		@Task	: 	ID_Stream_6_Subentro
	*/
	@AuraEnabled
	public static void updateABIandCABInsideAssetObj (String offerAssetId , String selectedCAB) {		
		List<Asset> currentAsset = new  List<Asset>();
		if(!String.isBlank(offerAssetId)) {
			currentAsset = [SELECT 	Id,
									OB_Takeover_CAB__c
							FROM 	Asset
							WHERE 	Id =: offerAssetId
							LIMIT 	1];
			if(!currentAsset.isEmpty()) {
				OB_UtilityCallingServices.shareAsset(currentAsset);// Simone Misani WN-596 10/10/2019
				Asset assetToUpdate = new Asset();
				assetToUpdate = currentAsset.get(0);
				if(!String.isBlank(selectedCAB)) {
					assetToUpdate.OB_Takeover_CAB__c = selectedCAB;
					update assetToUpdate;
				}

			}
		}

	}
	/*
	END
	--------------
	*/
	/*
    *   Author      :   Morittu Andrea
    *   Date        :   23-Sept-2019
    *   Task        :   PRODOB_469
    *   Description :   Method used to retrieve the description (name) of related MCC lov
    */
    @AuraEnabled
    public static List<NE__LOV__c> getMCCdescriptionByLOV(){
        List<NE__LOV__c> toReturn =  new List<NE__LOV__c>();
        List<NE__LOV__c> listOfValues =[   SELECT  Id, 
                                                        Name, 
                                                        NE__Active__c, 
                                                        NE__Type__c,                                                        NE__Value2__c, 
                                                        NE__Value3__c,
                                                        NE__Sub_Type__c
                                                FROM    NE__LOV__c  
                                                WHERE   NE__Active__c = true 
                                                AND     NE__Type__c = 'MCC'
                                                AND     NE__Value3__c = 'L3' 
                                                AND     NE__Sub_Type__c = 'TIPOLOGICHE'];
            if(!listOfValues.isEmpty()) {
                toReturn.addAll(listOfValues);
            }
        return toReturn;
    }

	/*
	*	Author		:	Francesca Ribezzi	
	*	Date		:	11-11-2019
	*	Task		:	PROD-42
	*	Description	:	setting abi and cab on currentUser when Operation
	*/
	@AuraEnabled
    public static OB_MaintenanceSearch_Controller.UserWrapper getCABandABIfromOrder(String orderId){
		// francesca.ribezzi 02/12/2019 - PROD-237 - START
		List<NE__Order__c> configuration = [SELECT OB_ABI__c, OB_CAB__c FROM NE__Order__c WHERE Id=:orderId];
		// francesca.ribezzi 02/12/2019 - PROD-237 - STOP
		if(configuration.size() == 0){
			return null;
		}
		OB_MaintenanceSearch_Controller.UserWrapper userWrapper = new OB_MaintenanceSearch_Controller.UserWrapper();
		userWrapper.userABI = configuration[0].OB_ABI__c;
		userWrapper.userCAB = configuration[0].OB_CAB__c;
		return userWrapper;
    }

	/*
	*	Author		:	Gianluigi Virga	
	*	Date		:	25-11-2019
	*	Task		:	Performance
	*	Description	:	retrieve line items and Line items attributes
	*/
	@AuraEnabled
    public static void retrieveLineItemsAndItemAttributes (String offerAssetId, String orderId){
		try{
			List<NE__AssetItemAttribute__c> listOfLineItemAttributes = [SELECT Id, 
																				NE__FamPropId__c,
																				NE__FamPropId__r.NE__FamilyId__c,
																				NE__FamPropId__r.NE__PropId__c,
																				OB_Attribute_Code__c,
																				OB_ReadOnly__c,
																				OB_Min_Absolute__c,
																				OB_Min_Threshold__c,
																				OB_Massimale__c,
																				OB_Max_Absolute__c,
																				OB_Max_Threshold__c,
																				OB_MinThresholdL2__c,
																				OB_MinThresholdL3__c,
																				OB_MaxThresholdL2__c,
																				OB_MaxThresholdL3__c,
																				NE__Asset__c,
																				NE__AttrEnterpriseId__c, //enrico.purificato 20/12
																				NE__Asset__r.NE__CatalogItem__c,
																				NE__Asset__r.NE__Item_Code__c, //enrico.purificato 20/12
																				NE__Asset__r.NE__AssetItemEnterpriseId__c, //enrico.purificato 20/12
																				NE__Asset__r.OB_Sequence__c,																				
																				NE__Asset__r.OB_ABI__c,
																				NE__Asset__r.NE__Bundle_Configuration__r.NE__Bundle__c,
																				NE__Asset__r.NE__Order_Config__r.OB_Business_Model_Acquiring__c,
																				NE__Asset__r.NE__Order_Config__r.NE__Order_date__c,
																				NE__Asset__r.Name,
																				NE__Asset__r.OB_CatalogItemRecordType__c
																		FROM NE__AssetItemAttribute__c
																		WHERE ( NE__Asset__r.NE__Bundle_Configuration__c =: offerAssetId 
																				OR NE__Asset__c =: offerAssetId) //enrico.purificato 20/12
																			//AND NE__Asset__r.NE__Order_Config__c =: orderId //enrico.purificato 20/12
																			AND NE__Asset__r.NE__Status__c = 'Active']; //enrico.purificato 20/12
																			//AND NE__Asset__r.OB_CatalogItemRecordType__c = 'Pricing']; //enrico.purificato 20/12

			if(!listOfLineItemAttributes.isEmpty()){
				Map<Id, List<Asset>> mapOfLineItems = new Map<Id, List<Asset>>();
				List<Id> listOfCatalogItem = new List<Id>();
				List<Id> listOfAttributeFamilies = new List<Id>();
				List<Id> listOfAttributeDynamicPropertyDefinitions = new List<Id>();

				for(NE__AssetItemAttribute__c attributes : listOfLineItemAttributes){
					if(attributes.NE__Asset__r.OB_CatalogItemRecordType__c == 'Pricing')
					{
						if(attributes.NE__Asset__r.OB_Sequence__c == null) 
						{
							List<Asset> tmpListOfAsset = new List<Asset>();
							if(mapOfLineItems.containsKey(attributes.NE__Asset__r.NE__CatalogItem__c))
						{
								tmpListOfAsset = mapOfLineItems.get(attributes.NE__Asset__r.NE__CatalogItem__c);
							}
							tmpListOfAsset.add(attributes.NE__Asset__r);
							mapOfLineItems.put(attributes.NE__Asset__r.NE__CatalogItem__c, tmpListOfAsset);
						}
						listOfCatalogItem.add(attributes.NE__Asset__r.NE__CatalogItem__c);
						listOfAttributeFamilies.add(attributes.NE__FamPropId__r.NE__FamilyId__c);
						listOfAttributeDynamicPropertyDefinitions.add(attributes.NE__FamPropId__r.NE__PropId__c);
					}
				}

				DateTime dT = listOfLineItemAttributes.get(0).NE__Asset__r.NE__Order_Config__r.NE__Order_date__c;
				Date orderDate = date.newinstance(dT.year(), dT.month(), dT.day());
				//davide.franzini - MPR-BB-Fix - 18/12/2019 - Added price threshold fields and dates, ActiveBank filter removed
				List<NE__Matrix_Parameter_row__c> oldListOfMprRows = [SELECT Id, 
																OB_CatalogItem__c,
																OB_Sequence__c,
																OB_Codici__c,
																OB_ReadOnly__c,
																OB_Componente__c,
																OB_Family__c,
																OB_DynamicPropertyDefinition__c,
																OB_Minimo__c,
																OB_Massimale__c,
																OB_Massimo__c,
																OB_Soglia_Max_Approvazione__c,
																OB_Soglia_Min_Approvazione__c,
																OB_MinThresholdL2__c,
																OB_MinThresholdL3__c,
																OB_MaxThresholdL2__c,
																OB_MaxThresholdL3__c,
																NE__Start_Date__c,
																NE__End_Date__c
															FROM NE__Matrix_Parameter_row__c 
															WHERE NE__Matrix_Parameter__r.Name = 'CatalogoNexi' 
																AND OB_SelfLookup__c > '' 
																AND OB_ABI_BANCA__c =: listOfLineItemAttributes.get(0).NE__Asset__r.OB_ABI__c 
																AND OB_Offerta_2__c =: listOfLineItemAttributes.get(0).NE__Asset__r.NE__Bundle_Configuration__r.NE__Bundle__c
																AND OB_ModelloAcquiring__c =: listOfLineItemAttributes.get(0).NE__Asset__r.NE__Order_Config__r.OB_Business_Model_Acquiring__c
																AND NE__Start_Date__c <= :orderDate
																AND (NE__End_Date__c >:orderDate OR NE__End_Date__c = null)
																AND OB_Componente__r.RecordType.DeveloperName = 'Pricing'
																AND (OB_Componente__c IN: listOfCatalogItem 
																	OR OB_Family__c IN: listOfAttributeFamilies
																	OR OB_DynamicPropertyDefinition__c IN: listOfAttributeDynamicPropertyDefinitions)];
																	
																
				//davide.franzini - MPR_BB_Fix - 18/12/2019 - START
				Map<String, NE__Matrix_Parameter_Row__c> bbMPRMap = new Map<String, NE__Matrix_Parameter_Row__c>();
				
				for(NE__Matrix_Parameter_Row__c mprRow : oldListOfMprRows){
					String key = mprRow.OB_Componente__c+'_'+mprRow.OB_Family__c+'_'+mprRow.OB_DynamicPropertyDefinition__c;
					bbMPRMap.put(key,mprRow);
				}
				
				List<NE__Matrix_Parameter_row__c> newListOfMprRows = [SELECT Id, 
																OB_CatalogItem__c,
																OB_Sequence__c,
																OB_Codici__c,
																OB_ReadOnly__c,
																OB_Componente__c,
																OB_Family__c,
																OB_DynamicPropertyDefinition__c,
																OB_Minimo__c,
																OB_Massimale__c,
																OB_Massimo__c,
																OB_Soglia_Max_Approvazione__c,
																OB_Soglia_Min_Approvazione__c,
																OB_MinThresholdL2__c,
																OB_MinThresholdL3__c,
																OB_MaxThresholdL2__c,
																OB_MaxThresholdL3__c,
																NE__Start_Date__c,
																NE__End_Date__c
															FROM NE__Matrix_Parameter_row__c 
															WHERE NE__Matrix_Parameter__r.Name = 'CatalogoNexi' 
																AND OB_SelfLookup__c > '' 
																AND OB_ABI_BANCA__c =: listOfLineItemAttributes.get(0).NE__Asset__r.OB_ABI__c 
																AND OB_Offerta_2__c =: listOfLineItemAttributes.get(0).NE__Asset__r.NE__Bundle_Configuration__r.NE__Bundle__c
																AND OB_ModelloAcquiring__c =: listOfLineItemAttributes.get(0).NE__Asset__r.NE__Order_Config__r.OB_Business_Model_Acquiring__c
																AND NE__Start_Date__c <= TODAY
																AND NE__End_Date__c = null
																AND OB_Componente__r.RecordType.DeveloperName = 'Pricing'
																AND (OB_Componente__c IN: listOfCatalogItem 
																	OR OB_Family__c IN: listOfAttributeFamilies
																	OR OB_DynamicPropertyDefinition__c IN: listOfAttributeDynamicPropertyDefinitions)];

				
				for(NE__Matrix_Parameter_Row__c mprRow : newListOfMprRows){
					String key = mprRow.OB_Componente__c+'_'+mprRow.OB_Family__c+'_'+mprRow.OB_DynamicPropertyDefinition__c;
					bbMPRMap.put(key,mprRow);
				}
				
				List<NE__Matrix_Parameter_Row__c> listOfMprRows = bbMPRMap.values();

				//davide.franzini - MPR_BB_Fix - 18/12/2019 - END
				
				if(!listOfMprRows.isEmpty()){
					Set<Asset> listOfLineItems = new Set<Asset>();
					Map<String, NE__Matrix_Parameter_row__c> mapOfMprRowsFamilyKeyAndDynamicPropertyDefinitionKey = new Map<String, NE__Matrix_Parameter_row__c>();
					for(NE__Matrix_Parameter_row__c mprRow : listOfMprRows){
						if(mapOfLineItems.containsKey(mprRow.OB_Componente__c)){
							for(Asset ass : mapOfLineItems.get(mprRow.OB_Componente__c)){
								//enrico.purificato - 19/12/2019 START
								Boolean updated = false;
								if(ass.OB_Sequence__c != mprRow.OB_Sequence__c)
								{
									ass.OB_Sequence__c = mprRow.OB_Sequence__c;
									updated = true;
								}

								if(ass.NE__Item_Code__c != ass.Id)
								{
									ass.NE__Item_Code__c = ass.Id;
									updated = true;
								}
								
								if(ass.NE__AssetItemEnterpriseId__c != ass.Id)
								{
									ass.NE__AssetItemEnterpriseId__c = ass.id;
									updated = true;
								}

								if(updated){
									listOfLineItems.add(ass);
								}
								//enrico.purificato - 19/12/2019 END
							}
							mapOfLineItems.remove(mprRow.OB_Componente__c);
						}
						mapOfMprRowsFamilyKeyAndDynamicPropertyDefinitionKey.put(mprRow.OB_Componente__c+'_'+mprRow.OB_Family__c+'_'+mprRow.OB_DynamicPropertyDefinition__c, mprRow);
					}
					

					List<NE__AssetItemAttribute__c> updatedListOfLineItemAttributes = new List<NE__AssetItemAttribute__c>();

					for(NE__AssetItemAttribute__c lineAttributes : listOfLineItemAttributes){
						String key = lineAttributes.NE__Asset__r.NE__CatalogItem__c+'_'+lineAttributes.NE__FamPropId__r.NE__FamilyId__c+'_'+lineAttributes.NE__FamPropId__r.NE__PropId__c;
						//davide.franzini - MPR_BB_Fix - 18/12/2019 - added threshold fields
						// enrico.purificato 19/12/2019 START
						Boolean updated = false;
													
						if(String.valueOf(lineAttributes.NE__AttrEnterpriseId__c) != String.valueOf(lineAttributes.Id))
						{
							lineAttributes.NE__AttrEnterpriseId__c		=	lineAttributes.Id;
							updated = true;
						}

						if(mapOfMprRowsFamilyKeyAndDynamicPropertyDefinitionKey.containsKey(key)){	
							NE__Matrix_Parameter_row__c mpr = mapOfMprRowsFamilyKeyAndDynamicPropertyDefinitionKey.get(key);
							
							if(String.valueOf(lineAttributes.OB_Attribute_Code__c) != String.valueOf(mpr.OB_Codici__c))
							{
								lineAttributes.OB_Attribute_Code__c 	= 	mpr.OB_Codici__c;
								updated = true;
							}
							if(String.valueOf(lineAttributes.OB_ReadOnly__c) != String.valueOf(mpr.OB_ReadOnly__c))
							{
								lineAttributes.OB_ReadOnly__c 			=	mpr.OB_ReadOnly__c;
								updated = true;
							}
							if(String.valueOf(lineAttributes.OB_Min_Absolute__c) != String.valueOf(mpr.OB_Minimo__c))
							{
								lineAttributes.OB_Min_Absolute__c 		= 	mpr.OB_Minimo__c;
								updated = true;
							}
							if(String.valueOf(lineAttributes.OB_Massimale__c 	) != String.valueOf(mpr.OB_Massimale__c))
							{
								lineAttributes.OB_Massimale__c 			= 	mpr.OB_Massimale__c;
								updated = true;
							}
							if(String.valueOf(lineAttributes.OB_Max_Absolute__c ) != String.valueOf(mpr.OB_Massimo__c))
							{
								lineAttributes.OB_Max_Absolute__c 		= 	mpr.OB_Massimo__c;
								updated = true;
							}
							if(String.valueOf(lineAttributes.OB_Max_Threshold__c ) != String.valueOf(mpr.OB_Soglia_Max_Approvazione__c))
							{
								lineAttributes.OB_Max_Threshold__c 		= 	mpr.OB_Soglia_Max_Approvazione__c;
								updated = true;
							}
							if(String.valueOf(lineAttributes.OB_Min_Threshold__c) != String.valueOf(mpr.OB_Soglia_Min_Approvazione__c))
							{
								lineAttributes.OB_Min_Threshold__c		=	mpr.OB_Soglia_Min_Approvazione__c;
								updated = true;
							}
							if(String.valueOf(lineAttributes.OB_MinThresholdL2__c) != String.valueOf(mpr.OB_MinThresholdL2__c))
							{
								lineAttributes.OB_MinThresholdL2__c		=	mpr.OB_MinThresholdL2__c;
								updated = true;
							}
							if(String.valueOf(lineAttributes.OB_MinThresholdL3__c) != String.valueOf(mpr.OB_MinThresholdL3__c))
							{
								lineAttributes.OB_MinThresholdL3__c		=	mpr.OB_MinThresholdL3__c;
								updated = true;
							}
							if(String.valueOf(lineAttributes.OB_MaxThresholdL2__c) != String.valueOf(mpr.OB_MaxThresholdL2__c))
							{
								lineAttributes.OB_MaxThresholdL2__c		=	mpr.OB_MaxThresholdL2__c;
								updated = true;
							}
							if(String.valueOf(lineAttributes.OB_MaxThresholdL3__c) != String.valueOf(mpr.OB_MaxThresholdL3__c))
							{
								lineAttributes.OB_MaxThresholdL3__c		=	mpr.OB_MaxThresholdL3__c;
								updated = true;
							}
		
						}
						
						if(updated){
								updatedListOfLineItemAttributes.add(lineAttributes);
						}
					}
					// enrico.purificato 19/12/2019 START

					for(NE__AssetItemAttribute__c lineAttributes : listOfLineItemAttributes)
					{
						if(lineAttributes.NE__Asset__r.OB_CatalogItemRecordType__c != 'Pricing')
						{
							if(String.valueOf(lineAttributes.NE__AttrEnterpriseId__c) != String.valueOf(lineAttributes.Id))
							{
								lineAttributes.NE__AttrEnterpriseId__c		=	lineAttributes.Id;
								updatedListOfLineItemAttributes.add(lineAttributes);
							}
							
							Boolean updated = (String.valueof(lineAttributes.NE__Asset__r.NE__AssetItemEnterpriseId__c) != String.valueof(lineAttributes.NE__Asset__c) )
								||(String.valueof(lineAttributes.NE__Asset__r.NE__Item_Code__c) != String.valueof(lineAttributes.NE__Asset__c));

							if(updated){
								listOfLineItems.add(new Asset(
									Id = lineAttributes.NE__Asset__c,
									NE__Item_Code__c = lineAttributes.NE__Asset__c,
									NE__AssetItemEnterpriseId__c = lineAttributes.NE__Asset__c));
							}
						}
					}

					if(updatedListOfLineItemAttributes.size()>0){
						update updatedListOfLineItemAttributes;
					}
					

					if(listOfLineItems.size()>0){
						List<Asset> listAsset = new List<Asset>();
						listAsset.addAll(listOfLineItems);
						update listAsset;
					}
					
					if(updatedListOfLineItemAttributes.size()>0 || listOfLineItems.size()>0)
					{
						Asset upAst = new Asset(
							Id = offerAssetId,
							OB_B2W_Session__c = ''
							);
						update upAst;
						
						Set<Id> tmpSet = new Set<Id>();
			 				tmpSet.add(offerAssetId);
			 				Database.executeBatch(new OB_CreateSessionFromAsset(tmpSet));
					}
					// enrico.purificato 19/12/2019 END	
				}
			} 
		}catch(Exception exc){	
			System.debug('Exception in OB_MaintenanceAssetSummaryController.retrieveLineItemsAndItemAttributes: ' + exc.getLineNumber()+ ' ' + exc.getMessage());
		}
	}	
}