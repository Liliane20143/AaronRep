public class OB_CatalogController
{
    
    /*******************************************************************************
	Purpose:  method to create order items - performance
    Parameters: -
    Returns: Boolean

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         enrico.purificato        23/10/2019      Created        
	2.0         enrico.purificato        23/10/2019      updated        wtapper to AssetSummary to have withoutSharing 
 	********************************************************************************/
    @auraEnabled
	public static Boolean callAssetToOrderItemServer(Id orderId, Id offerAssetId)
	{

		return OB_MaintenanceAssetSummaryController.callAssetToOrderItemServer(orderId,offerAssetId);
	
	}
    /*******************************************************************************
	Purpose:  method to create order items at check out - performance
    Parameters: -
    Returns: Boolean

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         enrico.purificato        22/10/2019      Created        
	
 	********************************************************************************/
    @AuraEnabled
    public static Boolean createAllProductServer( String complexProductList, String bundleId, String configuration )
    {
        try
        {
			List<Object> rootItemList             	= (List<Object>) JSON.deserializeUntyped(complexProductList);
			
			Map<String,Object> configurationMap     =  (Map<String,Object>) JSON.deserializeUntyped(configuration);

			String confId 			                = (String) configurationMap.get('id');
			
			String accountId 			            = (String) configurationMap.get('NE__accountid__c');
			String billingAccountId 	            = (String) configurationMap.get('NE__billaccid__c');
			String serviceAccountId 	            = (String) configurationMap.get('NE__servaccid__c');
			String billingProfId 		            = (String) configurationMap.get('NE__billingprofid__c');
			String OBMainProces                     = (String) configurationMap.get('ob_main_process');

			Set<String>                                catalogItemIdSet            		= new Set<String>();
			Map<String,Map<String,Object>> 		       rootLineItemFiledsMap			= new Map <String,Map<String,Object>>();
			Map<String,List<Object>> 			       rootLineItemAttributesObject	    = new Map<String,List<Object>>();
			Map<String,Map<String,Map<String,Object>>> rootLineItemChildFieldsMap  	    = new Map<String,Map<String,Map<String,Object>>>();
			Map<String,List<Object>> 			       childLineItemAttributesObject	= new Map<String,List<Object>>();
			
			for(Object rootItemObj:rootItemList)
			{
				
				Map<String,Object> rootItem 					= (Map<String,Object>)rootItemObj;
				Map<String,Object> rootItemFields       		= (Map<String,Object>)rootItem.get('fields');
				
                catalogItemIdSet.add((String) rootItemFields.get('catalogitemid'));

                String rootItemCode					            = (String) rootItemFields.get('itemCode');
                String rootItemKey    			                = confId + '_' + rootItemCode;
				
	
				Integer rootItemQty								= Integer.valueOf(rootItemFields.get('qty'));//Simone Misani perf 11/12/2019
				
				rootLineItemFiledsMap.put(rootItemKey,rootItemFields);

                List<Object> rootItemAttributes = (List<Object>) rootItem.get('listOfAttributes');
                
                if(rootItemAttributes != null && !rootItemAttributes.isEmpty())
                {
                    rootLineItemAttributesObject.put(rootItemKey,rootItemAttributes);
                }
							
				List<Object> childItemList              = (List<Object>) rootItem.get('childItems');
				
				if(childItemList != null && !childItemList.isEmpty())
				{
					Map<String,Map<String,Object>> childItemFiledsMap = new Map<String,Map<String,Object>>();
					
					for(Object childItem: childItemList){
                        Map<String,Object> childItemMap     = (Map<String,Object>) childItem;
						Map<String,Object> childItemFields  = (Map<String,Object>) childItemMap.get('fields');
						String childItemKey    			    = confId + '_' + (String) childItemFields.get('itemCode');

						catalogItemIdSet.add((String) childItemFields.get('catalogitemid'));
						childItemFiledsMap.put(childItemKey,childItemFields);
						
						List<Object>  childItemAttributes 	= (List<Object>)  childItemMap.get('listOfAttributes');
						if(childItemAttributes != null && !childItemAttributes.isEmpty())
						{
							//store childs related to current root
							childLineItemAttributesObject.put(childItemKey,childItemAttributes);
						}
						
					}
					//store childs related to current root
					rootLineItemChildFieldsMap.put(rootItemKey,childItemFiledsMap);
				}
				
				// in ca of qty > 1 create a copy of the complex product structure
                // clone everithing except child line item attributes.... cloned later
                if(rootItemQty != null && rootItemQty >1){
                    for(Integer j= rootItemQty-1 ; j > 0 ; j--)
                    {
                        String clonedRootKey   									= j +'#'+rootItemKey;
                        String clonedRootItemCode 								= j +'#'+rootItemCode;
                        
                        Map<String,Object> clonedRootItemFields 				= rootItemFields.clone();
                        clonedRootItemFields.put('itemCode',clonedRootItemCode); // enrico.purificato 03/11/19 change item code for cloned roots					
                        rootLineItemFiledsMap.put(clonedRootKey,clonedRootItemFields);
                       
                        if(rootLineItemAttributesObject.containsKey(rootItemKey))
                        {
                            rootLineItemAttributesObject.put(clonedRootKey,rootLineItemAttributesObject.get(rootItemKey).clone());
                        }
    
                        if(rootLineItemChildFieldsMap.containskey(rootItemKey))
                        {
                            rootLineItemChildFieldsMap.put(clonedRootKey,rootLineItemChildFieldsMap.get(rootItemKey).clone());
                        }
                    }
                }
				
			}
			
			List<String> catalogItemIdList              	= new List<String>(catalogItemIdSet);
			Map<String,NE__Catalog_Item__c> catItem     	= getCatalogItemMap(catalogItemIdList);

            
            Map<String,NE__OrderItem__c> rootOrderItemMap 	= new Map<String,NE__OrderItem__c>();
			
			system.debug('rootLineItemFiledsMap ' + rootLineItemFiledsMap);
			for(String rootKey: rootLineItemFiledsMap.keyset())
			{
                
				Map<String,Object> rootItemFields       = rootLineItemFiledsMap.get(rootKey);
                

				String rootCatalogitemId 	            = (String) rootItemFields.get('catalogitemid');

				NE__OrderItem__c rootLineItem = getItem(catItem.get(rootCatalogitemId), rootItemFields, confId, accountId, billingAccountId, serviceAccountId, billingProfId);
				
                rootLineItem.NE__Configuration_item_update_key__c = rootKey;
                rootLineItem.NE__Bundle_Configuration__c = bundleId;
				
				rootOrderItemMap.put(rootKey,rootLineItem);

			}
            
			upsert rootOrderItemMap.values();  //francesca.ribezzi 02/12/19 - performance - upsert
			
			List<NE__Order_Item_Attribute__c >  attributeLineItems 	            = new List<NE__Order_Item_Attribute__c >();
			Map<String,NE__OrderItem__c>        childLineItemsMap 			    = new Map<String,NE__OrderItem__c>();
            
			for(String rootKey: rootOrderItemMap.keyset())
			{	
				NE__OrderItem__c rootLineItem 		= rootOrderItemMap.get(rootKey);
				List<Object>  rootitemAttributes 	= rootLineItemAttributesObject.get(rootKey);

				if(rootitemAttributes != null && !rootitemAttributes.isEmpty())
				{
					List<NE__Order_Item_Attribute__c > rootattributeLineItems = new List<NE__Order_Item_Attribute__c >();
					for(Object currentItemAttribute: rootitemAttributes){
						Map<String,Object> currentItemAttributeMap 		= (Map<String,Object>) currentItemAttribute;
						Map<String,Object> currentItemAttributeFields 	= (Map<String,Object>) currentItemAttributeMap.get('fields');
						if(String.isBlank((String)currentItemAttributeFields.get('pfpId'))){
							continue;
						} 
					
						NE__Order_Item_Attribute__c  tmpAttr = getItemAttribute(currentItemAttributeFields,rootLineItem.Id);
						rootattributeLineItems.add(tmpAttr);
					}    
					attributeLineItems.addAll(rootattributeLineItems);
				}
				
				String 	keyPrefix 			= '';
				Integer hashPosition  		= rootKey.indexOf('#');
				
				if(hashPosition > 0)
				{
					keyPrefix = rootKey.left(hashPosition+1); // prefix number with hash e.g. 1#
				}
				
				if(rootLineItemChildFieldsMap.containskey(rootKey)){
					
					Map<String,Object> childItemsMap = rootLineItemChildFieldsMap.get(rootKey);
					
					for(String childItemOriginalKey: childItemsMap.keyset()){
						
						String newChildItemKey 					= keyPrefix + childItemOriginalKey;
						Map<String,Object> childItemFields 	= (Map<String,Object>) childItemsMap.get(childItemOriginalKey);
					    childItemFields.put('itemCode',keyPrefix + childItemFields.get('itemCode')); // enrico.purificato 03/11/19 change item code for cloned roots

						String childCatalogitemid 			= (String) childItemFields.get('catalogitemid');
						NE__OrderItem__c tmpLineItem 		= getItem(catItem.get(childCatalogitemid), childItemFields, confId, accountId, billingAccountId, serviceAccountId, billingProfId);
								
						tmpLineItem.NE__Parent_Order_Item__c 				= rootLineItem.Id;
						tmpLineItem.NE__Root_Order_Item__c 					= rootLineItem.Id;
						tmpLineItem.NE__Bundle_Configuration__c 			= bundleId;
						tmpLineItem.NE__Configuration_item_update_key__c 	= newChildItemKey;

						childLineItemsMap.put(newChildItemKey,tmpLineItem);

						//Clone the missing part of attributes only for cloned childs items
						if(childLineItemAttributesObject.containskey(childItemOriginalKey) && childItemOriginalKey != newChildItemKey){
							childLineItemAttributesObject.put(newChildItemKey,childLineItemAttributesObject.get(childItemOriginalKey).clone());
						}
						
					}
				}
				
			}
			
			if(childLineItemsMap.values().size()>0)
			{
				upsert childLineItemsMap.values(); //francesca.ribezzi 02/12/19 - performance - upsert
			}
		
			for(String childItemKey: childLineItemAttributesObject.keyset()){
				   
				   
				   NE__OrderItem__c childItem     					= childLineItemsMap.get(childItemKey);
                   if(childItem == null){ //francesca.ribezzi 02/12/19 - performance - checking if childItem is null
                       continue;
                   }
				   List<Object>  childItemAttributes 	            = (List<Object>)  childLineItemAttributesObject.get(childItemKey); 
				   Id childItemId 									= childItem.Id;
				   
                    List<NE__Order_Item_Attribute__c > childattributeLineItems = new List<NE__Order_Item_Attribute__c >();
                    for(Object currentItemAttribute: childItemAttributes){
                        Map<String,Object> currentItemAttributeMap 		= (Map<String,Object>) currentItemAttribute;
                        Map<String,Object> currentItemAttributeFields 	= (Map<String,Object>) currentItemAttributeMap.get('fields');
                        
                        if(String.isBlank((String)currentItemAttributeFields.get('pfpId'))) {
                            continue;
                        }
                            
                        NE__Order_Item_Attribute__c  tmpAttr = getItemAttribute(currentItemAttributeFields,childItemId);
                        childattributeLineItems.add(tmpAttr);
                    }    
                    attributeLineItems.addAll(childattributeLineItems);

			
			}

			if(attributeLineItems.size()>0){
					upsert attributeLineItems; //francesca.ribezzi 02/12/19 - performance - upsert
			}
		} catch ( Exception e )
        {
            System.debug( 'Exception in createAllProductServer ' + e.getMessage( ) + ' at line ' + e.getLineNumber( ) );
            return false;
        }
		return true;
	}
    
    @AuraEnabled
    public static Map<String, NE__OrderItem__c> getConfigurationItemServer(String configuration){ //davide.franzini - CheckOut Item Update Fix - 25/07/2019
        system.debug('@@@@ configuration' + configuration);

        Map<String,Object> configurationMap    =  (Map<String,Object>) JSON.deserializeUntyped(configuration);
        String confId = (String)configurationMap.get('id');

        NE__Order__c config = new NE__Order__c( Id       = confId);
        
        config.NE__CatalogId__c                = (string)configurationMap.get('NE__CatalogId__c');
        config.NE__CommercialModelId__c        = (string)configurationMap.get('NE__CommercialModelId__c');
        config.NE__Version__c                  = (Integer)configurationMap.get('NE__Version__c');
        config.OB_Predefault__c                = toBoolean(configurationMap.get('OB_Predefault__c'));
        config.OB_Variation__c                 = (string)configurationMap.get('OB_Variation__c');
        config.OB_VariationPOS__c              = (string)configurationMap.get('OB_VariationPOS__c');
        config.OB_JCBUPIAlert__c               = toBoolean(configurationMap.get('OB_JCBUPIAlert__c'));
        config.OB_PredefaultPOS__c             = toBoolean(configurationMap.get('OB_PredefaultPOS__c'));
        config.OB_AgreedChanges__c             = toBoolean(configurationMap.get('OB_AgreedChanges__c'));
        config.OB_EXCH_Commission__c           = toBoolean(configurationMap.get('OB_EXCH_Commission__c'));
        config.OB_ApprovalLevel__c             = (string)configurationMap.get('OB_ApprovalLevel__c');
        config.OB_isSkipToIntBE__c             = toBoolean(configurationMap.get('OB_isSkipToIntBE'));
        config.OB_isNexiAcquirer__c            = toBoolean(configurationMap.get('OB_isNexiAcquirer__c'));
        config.OB_IsActiveOfferOnSp__c         = toBoolean(configurationMap.get('OB_IsActiveOfferOnSp__c'));

        update config;

        //davide.franzini - CheckOut Item Update Fix - 25/07/2019 - START
        Map<String, NE__OrderItem__c> tmp = new Map<String, NE__OrderItem__c> (); 
        for(NE__OrderItem__c it: [SELECT Id, 
                                        OB_Ro__c, 
                                        OB_Sequence__c, 
                                        OB_enablement__c, 
                                        OB_TermId__c, 
                                        OB_Processor__c, 
                                        OB_VariationPOSPB__c, 
                                        OB_Visible__c, 
                                        OB_Description__c,
                                        RecordTypeId ,               //25/07/19 francesca adding recordtypeid
                                        NE__AssetItemEnterpriseId__c, // enrico.purificato 25/10/2019 performance start 
                                        NE__Item_Code__c, 
                                        NE__Configuration_item_update_key__c, 
                                        NE__Parent_Order_Item__r.NE__AssetItemEnterpriseId__c,
                                        NE__Parent_Order_Item__r.NE__Item_Code__c,
                                        (SELECT Id, NE__AttrEnterpriseId__c 
                                            FROM NE__Order_Item_Attributes__r) // enrico.purificato 25/10/2019 performance end
                                    FROM NE__OrderItem__c 
                                    WHERE NE__OrderId__c = : confId]){
            tmp.put(it.Id, it);
        }
        //davide.franzini - CheckOut Item Update Fix - 25/07/2019 - END
        return tmp;
        
    }

    @AuraEnabled
    public static Boolean removeItemServer(List<String> itemList,String confId)
    {
        List<NE__OrderItem__c>   itemsToBeRemoved = new List<NE__OrderItem__c>();
        try
        {
            List<NE__Order_Item_Attribute__c> attributesToBeRemoved = [SELECT id, NE__Order_Item__c 
                                                                FROM NE__Order_Item_Attribute__c 
                                                                WHERE NE__Order_Item__c in :itemList ];
        
            for(String itemId: itemList){
                itemsToBeRemoved.add(new NE__OrderItem__c(Id=itemId,NE__Action__c='Remove', OB_enablement__c='N' )); // antonio.vatrano 05/12/2019 PERF-18 
            }
            
            if(attributesToBeRemoved.size() > 0)
            {
                for(NE__Order_Item_Attribute__c currentAttribute: attributesToBeRemoved){
                    currentAttribute.NE__Action__c = 'Remove';
                } 

                update attributesToBeRemoved;
            } 
            try
            {
                NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                update itemsToBeRemoved;
        
            } catch( QueryException e ) {
            
                try{
                    NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                    update itemsToBeRemoved;
                
                } catch( QueryException x ) {
                    throw x;
                }
            }

        } catch(Exception e ){
            return false;
        }

        return true;
        
    }

    @AuraEnabled
    public static Boolean updateAttributesServer (String attributesList,String confId ){
        Set<String> ItemsSet = new Set<String>();
        try{
            List<Object> attrList = (List<Object>) JSON.deserializeUntyped(attributesList);
            List<NE__Order_Item_Attribute__c> itemAttrList = new List<NE__Order_Item_Attribute__c>();

            for(Object attr:attrList){
                Map<String,Object> attrMap = (Map<String,Object>) attr;
                Map<String,Object> attrFields = (Map<String,Object>) attrMap.get('fields');
                Id attrId = toId(attrFields.get('idLineAttribute'));
                if(attrId == null){continue;} //davide.franzini - CheckOut Item Update Fix - 25/07/2019
                Id itemId = toId(attrFields.get('lineId'));
                String value = (String) attrFields.get('value');
                ItemsSet.Add(itemId);
                itemAttrList.add(new NE__Order_Item_Attribute__c (Id = attrId, NE__Value__c = value, NE__Action__c='Change'));
            }
            update itemAttrList;
            List<NE__OrderItem__c> lineItemList = new List<NE__OrderItem__c> ();

            for(String item:ItemsSet){
                lineItemList.add(new NE__OrderItem__c (Id=item, NE__Action__c='Change'));
            }

            try
            {
                NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                update lineItemList;
        
            } catch( QueryException e ) {
            
                try{
                    NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                    update lineItemList;
                
                } catch( QueryException x ) {
                    throw x;
                }
            }
        } catch(Exception e ){
            return false;
        }
        return true;
        
    }

    //davide.franzini - CheckOut Item Update Fix - 25/07/2019 - START
    @AuraEnabled
    public static Boolean updateItemsServer (String itemList,String confId ){
        Set<String> ItemsSet = new Set<String>();
        try{
            List<Object> itList = (List<Object>) JSON.deserializeUntyped(itemList);
            List<NE__Order_Item_Attribute__c> itemAttrList = new List<NE__Order_Item_Attribute__c>();
            List<NE__OrderItem__c> lineItemList = new List<NE__OrderItem__c> ();

            for(Object it:itList){
                Map<String,Object> itMap = (Map<String,Object>) it;
                Map<String,Object> itFields = (Map<String,Object>) itMap.get('fields');
                NE__OrderItem__c tmp = new NE__OrderItem__c();
                tmp.Id = toId(itFields.get('orderitemid'));
                tmp.OB_Ro__c = (String)(itFields.get('OB_Ro__c'));
                tmp.OB_Sequence__c = toDecimal(itFields.get('OB_Sequence__c'));
                tmp.OB_enablement__c = (String)itFields.get('OB_enablement__c');
                tmp.OB_TermId__c = (String)itFields.get('OB_TermId__c');
                tmp.OB_Processor__c = (String)itFields.get('OB_Processor__c');
                tmp.OB_VariationPOSPB__c = (String)itFields.get('OB_VariationPOSPB__c');
                tmp.OB_Visible__c = (String)itFields.get('OB_Visible__c');
                tmp.OB_Description__c = (String)itFields.get('OB_Description__c');
                tmp.RecordTypeId = toId(itFields.get('RecordTypeId'));      //25/07/19 francesca adding recordtypeid
                lineItemList.add(tmp);
            }

            try
            {
                NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                update lineItemList;
        
            } catch( QueryException e ) {
            
                try{
                    NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                    update lineItemList;
                
                } catch( QueryException x ) {
                    throw x;
                }
            }
        } catch(Exception e ){
            return false;
        }
        return true;
        
    }
    //davide.franzini - CheckOut Item Update Fix - 25/07/2019 - END

    @AuraEnabled
    public static Boolean insertChildProductsServer (String productList,String configuration,String bundleId ){
        
        Datetime now = datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime dateLocal = now.addSeconds(offset/1000);
        
        Map<String,Object> configurationMap    =  (Map<String,Object>) JSON.deserializeUntyped(configuration);

        String confId 			    = (string)configurationMap.get('id');
        String catalogId            = (string)configurationMap.get('NE__CatalogId__c');
        String accountId 			= (string)configurationMap.get('NE__accountid__c');
		String billingAccountId 	= (string)configurationMap.get('NE__billaccid__c');
		String serviceAccountId 	= (string)configurationMap.get('NE__servaccid__c');
		String billingProfId 		= (string)configurationMap.get('NE__billingprofid__c');
        List<NE__OrderItem__c> childLineItems = new List<NE__OrderItem__c>();
        Set<String> catalogItemIdSet = new Set<String>();
        List<Object> plist = (List<Object>) JSON.deserializeUntyped(productList);
        try
        {
            for(Object childItem: plist){
                    Map<String,Object> tmpItemMap       = (Map<String,Object>) childItem;
                    Map<String,Object> childItemFields  = (Map<String,Object>) tmpItemMap.get('fields');
                    String itemExtId    			    = confId + '_' + (String) childItemFields.get('itemCode');

                    catalogItemIdSet.add((String) childItemFields.get('catalogitemid'));
            }
        

            List<String> catalogItemIdList              = new List<String>(catalogItemIdSet);
            Map<String,NE__Catalog_Item__c> catItem     = getCatalogItemMap(catalogItemIdList);

            Map<String,NE__OrderItem__c> childLineItemsMap = new Map<String,NE__OrderItem__c>();

            for(Object childItem : plist){
                Map<String,Object> tmpItemMap = (Map<String,Object>) childItem;
                Map<String,Object> childItemFields = (Map<String,Object>) tmpItemMap.get('fields');
                String childCatalogitemid = (String) childItemFields.get('catalogitemid');
                NE__OrderItem__c tmpLineItem = getItem(catItem.get(childCatalogitemid), childItemFields, confId, accountId, billingAccountId, serviceAccountId, billingProfId);
                Id ParentId = toId(childItemFields.get('parentItemId'));
                tmpLineItem.NE__Action__c = 'Add';
                tmpLineItem.Ne__Status__c = 'Pending'; 
                tmpLineItem.NE__StartDate__c = dateLocal;
                tmpLineItem.NE__Parent_Order_Item__c = ParentId;
                tmpLineItem.NE__Root_Order_Item__c = ParentId;
                tmpLineItem.NE__Bundle_Configuration__c = bundleId;
                childLineItemsMap.put(tmpLineItem.NE__Configuration_item_update_key__c,tmpLineItem);
            }

            try
            {
                NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                insert childLineItemsMap.values();
        
            } catch( QueryException e ) {
            
                try{
                    NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                    insert childLineItemsMap.values();
                
                } catch( QueryException x ) {
                    throw x;
                }
            }
            List<NE__Order_Item_Attribute__c > arrributeLineItems = new List<NE__Order_Item_Attribute__c >();

            for(Object childItem : plist){
                Map<String,Object> tmpItemMap = (Map<String,Object>) childItem;
                Map<String,Object> childItemFields = (Map<String,Object>) tmpItemMap.get('fields');
                String itemExtId    			    = confId + '_' + (String) childItemFields.get('itemCode');
                Id lineItemId                       = childLineItemsMap.get(itemExtId).id;
                List<Object>  childtemAttributes 	= (List<Object>)  tmpItemMap.get('listOfAttributes');
        

                if(childtemAttributes != null && !childtemAttributes.isEmpty())
                {   
                    for(Object currentItemAttribute: childtemAttributes){
                        Map<String,Object> currentItemAttributeMap = (Map<String,Object>) currentItemAttribute;
                        Map<String,Object> currentItemAttributeFields = (Map<String,Object>) currentItemAttributeMap.get('fields');
                        if(String.isBlank((String)currentItemAttributeFields.get('pfpId'))){
                            continue;
                        } 
                        NE__Order_Item_Attribute__c  tmpAttr = getItemAttribute(currentItemAttributeFields,lineItemId);
                        arrributeLineItems.add(tmpAttr);
                    }    
                }
            }
            if(arrributeLineItems.size()>0){
                insert arrributeLineItems;
            }
        
        } catch(Exception e ){
            return false;
        }

        return true;
        
    }

    public static map<String,NE__Catalog_Item__c> getCatalogItemMap(List<String> listOfCatalogItemsId){
        return new map<String,NE__Catalog_Item__c>(
                                                [SELECT NE__Catalog_Category_Name__r.Name, NE__ProductId__r.RecordType.Name, RecordType.Name, NE__Recurring_Cost__c,NE__One_Time_Cost__c, //davide.franzini - 26/07/2019
                                                        NE__Base_Magnitude__c,NE__Base_Magnitude__r.Name,NE__Admitted_Magnitude__c,
                                                        NE__Recurring_Cost_Frequency__c,NE__Matrix_Item_Identifier__c, 
                                                        NE__New_Subtype__c, NE__Change_Subtype__c, NE__Disconnect_Subtype__c,
                                                        NE__ProductId__r.NE__Check_Stock__c, NE__Item_Header__c,
                                                        NE__ConfigurationRequired__c,NE__ProductId__r.NE__Engine_Code__c,
                                                        NE__Parent_Catalog_Item__r.NE__Product_Category_Name__c,
                                                        NE__Parent_Catalog_Item__r.name,NE__type__c,NE__Parent_Catalog_Item__c, 
                                                        NE__Root_Catalog_Item__c,NE__PromotionId__r.Name,NE__ProductId__r.NE__Description__c,
                                                        NE__ProductId__r.NE__Stock__c,NE__ProductId__r.Name,NE__ProductId__r.NE__Part__c,
                                                        NE__ProductId__r.NE__Thumbnail_Image__c, NE__ProductId__r.NE__Brochure_Image__c,
                                                        NE__Base_OneTime_Fee__c, NE__BaseRecurringCharge__c, NE__Catalog_Category_Name__c, 
                                                        NE__Catalog_Id__c, NE__Commitment__c, NE__Commitment_Period__c, NE__Commitment_UOM__c,
                                                        NE__Currency__c, NE__EndDateString__c,NE__Engine_Code__c, NE__Generate_Asset_Item__c, 
                                                        NE__Max_Qty__c, NE__Min_Qty__c, NE__Offline_Cart__c, NE__Offline__c, 
                                                        NE__OneTime_Fee_Code__c, NE__Penalty__c, NE__Penalty_Fee__c, NE__Penalty_Type__c,
                                                        NE__Cart_Description__c,NE__Billing_Description__c, NE__ProductId__c, 
                                                        NE__PromotionId__c, Id, NE__RecurringChargeCode__c, NE__Recurring_Charge_Frequency__c, 
                                                        NE__StartDateString__c, NE__Unit_Credit_Code__c, NE__Unit_Credit_Description__c, NE__Usage_Code__c, 
                                                        NE__usagecode__c, NE__Usage_Description__c,NE__Visible__c,NE__Configuration_Type__c,NE__Default_Qty__c, 
                                                        NE__Verify__c, NE__Tax_Code__c,NE__Program_Name__c,NE__Catalog_Id__r.Name,NE__GetProduct_Name__c
                                                    FROM NE__Catalog_Item__c
                                                    WHERE id IN: listOfCatalogItemsId]
                                            );
    }

    //Start antonio.vatrano fewave2-172 01/08/2019
    public static Decimal toDecimal(Object inputvalue){
        try{
            try{
                return (Decimal) inputvalue;
            }catch(Exception e){System.debug('cast failed');}
            return Decimal.valueOf(String.valueOf((String)inputvalue));
        }catch(Exception e){
            return null;
        }
    }

    public static Boolean toBoolean(Object inputvalue){
        try{
            try{
                return (Boolean) inputvalue;
            }catch(Exception e){System.debug('cast failed');}
            return Boolean.valueOf(String.valueOf((String)inputvalue));
        }catch(Exception e){
            return false;
        }
    }

    public static Id toId(Object inputvalue){
        try{
            try{
                return (Id) inputvalue;
            }catch(Exception e){System.debug('cast failed');}
           return String.valueOf((String) inputvalue);
        }catch(Exception e){
            return null;
        }
    }
    //End antonio.vatrano fewave2-172 01/08/2019

    public static NE__Order_Item_Attribute__c  getItemAttribute(Map<String,Object> attributeFields,String itemId){
        NE__Order_Item_Attribute__c  tmp = new NE__Order_Item_Attribute__c ();
        tmp.NE__Order_Item__c = itemId;
        tmp.NE__Action__c = 'Add';
        tmp.Name = (String) attributeFields.get('name');
        tmp.NE__FamPropExtId__c = (String) attributeFields.get('attributeCode');
        tmp.NE__FamPropId__c = (String) attributeFields.get('pfpId');
        //START GIOVANNI SPINELLI - 07/11/2019 - CONVERSION VALUE EX FROM 1.000 TO 1000 - PRODOB-555
        //START GIOVANNI SPINELLI - 15/11/2019 - PROD-97 - ADD FILTER
        String valueTmp = (String) attributeFields.get('value');
        if( valuetmp!=null && valueTmp.contains( '.' ) ){
            tmp.NE__Value__c = valueTmp.replace( '.' , '' );
        }else{
            tmp.NE__Value__c = valueTmp;
        }
        //END GIOVANNI SPINELLI - 15/11/2019 - PROD-97 - ADD FILTER
        //END GIOVANNI SPINELLI - 07/11/2019 - CONVERSION VALUE EX FROM 1.000 TO 1000 - PRODOB-555    
        tmp.NE__Previous_Attribute_Value__c = (String) attributeFields.get('previousvalue');
        tmp.OB_Attribute_Code__c = (String) attributeFields.get('OB_Attribute_Code__c');

        tmp.OB_Min_Threshold__c = toDecimal(attributeFields.get('OB_Min_Threshold__c'));
        tmp.OB_MIn_Absolute__c = toDecimal( attributeFields.get('OB_MIn_Absolute__c'));
        tmp.OB_Max_Threshold__c = toDecimal( attributeFields.get('OB_Max_Threshold__c'));
        tmp.OB_Max_Absolute__c = toDecimal( attributeFields.get('OB_Max_Absolute__c'));
        tmp.OB_Massimale__c = toDecimal( attributeFields.get('OB_Massimale__c'));

        tmp.OB_PredefaultAttr__c = toBoolean(attributeFields.get('OB_PredefaultAttr__c'));
        tmp.OB_ReadOnly__c = toBoolean(attributeFields.get('OB_ReadOnly__c'));
        tmp.OB_Hidden__c = toBoolean(attributeFields.get('OB_Hidden__c'));
        tmp.NE__AttrEnterpriseId__c = (String) attributeFields.get('NE__AttrEnterpriseId__c');
        
        /*
        * giovanni spinelli - START - 20/11/2019 - PROD-120
        * SAVE VALUE ON ITEM ATTRIBUTE DURING CHECKOUT
        * save idLineAttribute on order item attribute avoid duplicates
        * save min/max l2 and l3 to check value after rejected pricing
        * save old value
        */
        
        try{
            String idLineAttribute = (String) attributeFields.get('idLineAttribute');
            if(String.isNotBlank( idLineAttribute )){
                tmp.Id = idLineAttribute;
            }
            tmp.OB_MaxThresholdL2__c = toDecimal(attributeFields.get('OB_MaxThresholdL2__c'));
            tmp.OB_MinThresholdL2__c = toDecimal(attributeFields.get('OB_MinThresholdL2__c'));
            tmp.OB_MaxThresholdL3__c = toDecimal(attributeFields.get('OB_MaxThresholdL3__c'));
            tmp.OB_MinThresholdL3__c = toDecimal(attributeFields.get('OB_MinThresholdL3__c')); //   antonio.vatrano 13/12/2019 PERF-51 change attribute

        }catch(Exception e ){
            System.debug(logginglevel.ERROR , 'Exception SAVING TMP: ' +e.getMessage());
        }
        //giovanni spinelli - END - 20/11/2019 - PROD-120
        return tmp;
    }

    public static NE__OrderItem__c getItem(NE__Catalog_Item__c catItem,Map<String,Object> lineItemFields,String configurationId,String accountId,String billingAccountId, String serviceAccountId,String billingProfId){
        
        Datetime now = datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime dateLocal = now.addSeconds(offset/1000);
                
        NE__OrderItem__c tmp = new NE__OrderItem__c();
        
        String itemcode 			 	= (string)lineItemFields.get('itemCode');
 
		String itemExtId    			= configurationId + '_' + itemcode;
        //START francesca ribezzi 21/11/19 - PROD-145 
        String currentConfKey           = (string)lineItemFields.get('NE__Configuration_item_update_key__c');
        if(String.isBlank(currentConfKey)){  
           currentConfKey = itemExtId;
        }
		String assetItemEnterpriseId 	= (string)lineItemFields.get('assetitementerpriseid');
        String itemId 			 	    = (String)lineItemFields.get('orderitemid');  
        Id newId = getOrderItemId(itemId);
        if(newId != null){
            tmp.Id  = newId; 
        }
        tmp.NE__Configuration_item_update_key__c = currentConfKey;   
        //END francesca ribezzi 21/11/19 - PROD-145 
        tmp.NE__Item_Code__c                    = itemcode;
        tmp.NE__Service_Account__c              = toId(serviceAccountId);
        tmp.NE__Account__c                      = toId(accountId);
        tmp.NE__Billing_Account__c              = toId(billingAccountId);
        tmp.NE__BillingProfId__c                = toId(billingProfId);
        //START gianluigi.virga 23/10/2019
        System.debug('OB_Sfdc_code_override__c: '+lineItemFields.get('OB_Sfdc_code_override__c'));
        tmp.OB_Sfdc_code_override__c            = String.valueOf(lineItemFields.get('OB_Sfdc_code_override__c'));
        //END gianluigi.virga 23/10/2019
        // davide.franzini - 26/07/2019 - START
        try{
            tmp.RecordTypeId                    = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(catItem.NE__ProductId__r.RecordType.Name).getRecordTypeId();
        }catch(Exception e){
            tmp.RecordTypeId                    = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        }
        // davide.franzini - 26/07/2019 - END
        
        tmp.NE__CatalogItem__c                  = catItem.Id;
        tmp.NE__Generate_Asset_Item__c          = catItem.NE__Generate_Asset_Item__c;
        tmp.NE__OneTimeFeeCode__c               = catItem.NE__OneTime_Fee_Code__c;            
        tmp.NE__ProdId__c                       = catItem.NE__ProductId__c;

        tmp.NE__RecurringChargeCode__c          = catItem.NE__RecurringChargeCode__c;                                                                           
        tmp.NE__UnitCreditCode__c               = catItem.NE__Unit_Credit_Code__c;
        tmp.NE__UnitCreditDescription__c        = catItem.NE__Unit_Credit_Description__c; 

        try{
            if(lineItemFields.get('Usagecode') == null)
                tmp.NE__UsageCode__c = catItem.NE__UsageCode__c;
        }
        catch(Exception e){}
        
        tmp.NE__UsageDescription__c             = catItem.NE__Usage_Description__c;
        tmp.NE__Penalty__c                      = catItem.NE__Penalty__c;
        tmp.NE__Penalty_Fee__c                  = catItem.NE__Penalty_Fee__c;
        tmp.NE__Penalty_Type__c                 = catItem.NE__Penalty_Type__c;
        
        
        if(NE.CartUtilities.isNull((string)lineItemFields.get('commitmentActive')) == '')    
            tmp.NE__Commitment__c               = catItem.NE__Commitment__c;
        if(lineItemFields.containsKey('commitmentPeriod'))   
            tmp.NE__Commitment_Period__c        = catItem.NE__Commitment_Period__c;
        if((string)lineItemFields.get('commitmentUOM') == null)    
            tmp.NE__Commitment_UOM__c           = catItem.NE__Commitment_UOM__c;              

        if((string)lineItemFields.get('cartDescription') == null)    
            tmp.NE__Cart_Description__c = catItem.NE__Cart_Description__c;

        tmp.NE__Billing_Description__c          = catItem.NE__Billing_Description__c;
        tmp.NE__Recurring_Cost__c               = catItem.NE__Recurring_Cost__c;
        tmp.NE__One_Time_Cost__c                = catItem.NE__One_Time_Cost__c;
        tmp.NE__Recurring_Cost_Frequency__c     = catItem.NE__Recurring_Cost_Frequency__c;
        tmp.NE__Catalog__c                       = catItem.NE__Catalog_Id__c;
        tmp.NE__OrderId__c                       = configurationId;
        tmp.NE__Qty__c                           = 1;
        tmp.NE__Bundle__c                        = toId(lineItemFields.get('bundleId'));
        tmp.NE__Bundle_Element__c                = toId(lineItemFields.get('bundleElement'));
        tmp.OB_enablement__c                     = (String) lineItemFields.get('OB_enablement__c');
        tmp.OB_TermId__c                         = (String) lineItemFields.get('OB_TermId__c');
        tmp.OB_Processor__c                      = (String) lineItemFields.get('OB_Processor__c');
        tmp.OB_VariationPOSPB__c                 = (String) lineItemFields.get('OB_VariationPOSPB__c');
        tmp.NE__Action__c = 'Add';
        tmp.Ne__Status__c = 'Pending'; 
        tmp.NE__StartDate__c = dateLocal;
        
        try{
            tmp.OB_Sequence__c                   =  Decimal.valueOf((Integer)lineItemFields.get('OB_Sequence__c'));
        }catch(Exception e){}
            
        
        tmp.OB_Description__c                    = (String) lineItemFields.get('OB_Description__c');
        tmp.OB_Visible__c                        = (String) lineItemFields.get('OB_Visible__c');
        tmp.OB_Ro__c                             = (String) lineItemFields.get('OB_Ro__c');
        return tmp;
    }

   
    
    @AuraEnabled
    public static String createBundleServer( String bundle, String configuration){
        
        
        Map<String,Object> bundleMap         = (Map<String,Object>) JSON.deserializeUntyped(bundle);
        Map<String,Object> bundleFields      = (Map<String,Object>) bundleMap.get('fields');
        
        Datetime now = datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime dateLocal = now.addSeconds(offset/1000);
        
        Map<String,Object> configurationMap    =  (Map<String,Object>) JSON.deserializeUntyped(configuration);

        String confId 			    = (string)configurationMap.get('id');
        String catalogId            = (string)configurationMap.get('NE__CatalogId__c');
        
        String accountId 			= (string)configurationMap.get('NE__accountid__c');
		String billingAccountId 	= (string)configurationMap.get('NE__billaccid__c');
		String serviceAccountId 	= (string)configurationMap.get('NE__servaccid__c');
		String billingProfId 		= (string)configurationMap.get('NE__billingprofid__c');
        String catalogitemid 		= (string)bundleFields.get('catalogitemid');
        String OBMainProces         = (string)configurationMap.get('ob_main_process');

        List<String> listOfCatalogItemsId = new List<String>();
        listOfCatalogItemsId.add(catalogitemid);
        map<String,NE__Catalog_Item__c> catItem = getCatalogItemMap(listOfCatalogItemsId);
        
        //davide.franzini - 26/07/2019 - START
        NE__Catalog_Item__c tmpCatIt =  catItem.get(catalogitemid);
        NE__OrderItem__c bundleItem = getItem(tmpCatIt, bundleFields, confId, accountId, billingAccountId, serviceAccountId, billingProfId);
        bundleItem.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(tmpCatIt.RecordType.Name).getRecordTypeId(); // davide.franzini - 26/07/2019
        //davide.franzini - 26/07/2019 - END
        
        NE__Order__c config = new NE__Order__c( Id       = confId ,NE__type__c='InOrder');
        config.NE__CatalogId__c                = (string)configurationMap.get('NE__CatalogId__c');
        config.NE__CommercialModelId__c        = (string)configurationMap.get('NE__CommercialModelId__c');
        config.NE__Version__c                  = (Integer)configurationMap.get('NE__Version__c');
        config.OB_Predefault__c                = toBoolean(configurationMap.get('OB_Predefault__c'));
        config.OB_Variation__c                 = (string)configurationMap.get('OB_Variation__c');
        config.OB_VariationPOS__c              = (string)configurationMap.get('OB_VariationPOS__c');
        config.OB_JCBUPIAlert__c               = toBoolean(configurationMap.get('OB_JCBUPIAlert__c'));
        config.OB_PredefaultPOS__c             = toBoolean(configurationMap.get('OB_PredefaultPOS__c'));
        config.OB_AgreedChanges__c             = toBoolean(configurationMap.get('OB_AgreedChanges__c'));
        config.OB_EXCH_Commission__c           = toBoolean(configurationMap.get('OB_EXCH_Commission__c'));
        config.OB_ApprovalLevel__c             = (string)configurationMap.get('OB_ApprovalLevel__c');
        config.OB_isSkipToIntBE__c             = toBoolean(configurationMap.get('OB_isSkipToIntBE'));
        config.OB_isNexiAcquirer__c            = toBoolean(configurationMap.get('OB_isNexiAcquirer__c'));
        config.OB_IsActiveOfferOnSp__c         = toBoolean(configurationMap.get('OB_IsActiveOfferOnSp__c'));

        update config;

        NE__Order__c orderUPD  = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
        upsert bundleItem NE__Configuration_item_update_key__c; 
        
        return bundleItem.id;
    }
    

    @AuraEnabled
    public static Boolean createComplexProductServer( String complexProduct, String bundleId, String configuration ){
        
        Map<String,Object> rootItem             = (Map<String,Object>) JSON.deserializeUntyped(complexProduct);
        
        
        Map<String,Object> configurationMap     =  (Map<String,Object>) JSON.deserializeUntyped(configuration);

        String confId 			                = (String) configurationMap.get('id');
        
        String accountId 			            = (String) configurationMap.get('NE__accountid__c');
		String billingAccountId 	            = (String) configurationMap.get('NE__billaccid__c');
		String serviceAccountId 	            = (String) configurationMap.get('NE__servaccid__c');
		String billingProfId 		            = (String) configurationMap.get('NE__billingprofid__c');
        
        Map<String,Object> rootItemFields       = (Map<String,Object>) rootItem.get('fields');
        String rootCatalogitemid 	            = (string) rootItemFields.get('catalogitemid');

        String OBMainProces                     = (String) configurationMap.get('ob_main_process');

        Set<String> catalogItemIdSet            = new Set<String>();

        catalogItemIdSet.add(rootCatalogitemid);


        Map<String,Object> childItemMap         = new Map<String,Object> ();
        List<Object> childItemList              = (List<Object>) rootItem.get('childItems');

        if(childItemList != null && !childItemList.isEmpty())
        {
            for(Object childItem: childItemList){
                Map<String,Object> tmpItemMap       = (Map<String,Object>) childItem;
                Map<String,Object> childItemFields  = (Map<String,Object>) tmpItemMap.get('fields');
                String itemExtId    			    = confId + '_' + (String) childItemFields.get('itemCode');

                catalogItemIdSet.add((String) childItemFields.get('catalogitemid'));
                childItemMap.put(itemExtId,childItem);
            }
        }

        List<String> catalogItemIdList              = new List<String>(catalogItemIdSet);
        Map<String,NE__Catalog_Item__c> catItem     = getCatalogItemMap(catalogItemIdList);
        
        Map <String,NE__OrderItem__c> rootLineItemMap  = new Map <String,NE__OrderItem__c>();
        
        Integer qty = (Integer) rootItemFields.get('qty');
        
        NE__OrderItem__c rootLineItem = getItem(catItem.get(rootCatalogitemid), rootItemFields, confId, accountId, billingAccountId, serviceAccountId, billingProfId);   
        rootLineItem.NE__Bundle_Configuration__c = bundleId;
        rootLineItemMap.put(rootLineItem.NE__Configuration_item_update_key__c,rootLineItem);
        for(Integer j= qty-1 ; j > 0 ; j--){
            String extKey   = j +'#'+rootLineItem.NE__Configuration_item_update_key__c;
            String itemCode = j +'#'+rootLineItem.NE__Item_Code__c;
            NE__OrderItem__c tmpItem = rootLineItem.clone();
            tmpItem.NE__Configuration_item_update_key__c = extKey;
            tmpItem.NE__Item_Code__c                    = itemCode;
            rootLineItemMap.put(extKey,tmpItem);
        }
        

        try{
            NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
            upsert rootLineItemMap.values() NE__Configuration_item_update_key__c;
        
        } catch( QueryException e ) {
            
            try{
                
                NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                upsert rootLineItemMap.values() NE__Configuration_item_update_key__c;
            
            } catch( QueryException x ) {
                throw x;
            }
        }

        
        List<NE__Order_Item_Attribute__c > arrributeLineItems = new List<NE__Order_Item_Attribute__c >();

        List<Object>  rootitemAttributes 	            = (List<Object>)  rootItem.get('listOfAttributes');
        

        if(rootitemAttributes != null && !rootitemAttributes.isEmpty())
        {
            List<NE__Order_Item_Attribute__c > rootArrributeLineItems = new List<NE__Order_Item_Attribute__c >();
            for(Object currentItemAttribute: rootitemAttributes){
                Map<String,Object> currentItemAttributeMap = (Map<String,Object>) currentItemAttribute;
                Map<String,Object> currentItemAttributeFields = (Map<String,Object>) currentItemAttributeMap.get('fields');
                if(String.isBlank((String)currentItemAttributeFields.get('pfpId'))){   
                    continue;
                } 
            
                NE__Order_Item_Attribute__c  tmpAttr = getItemAttribute(currentItemAttributeFields,rootLineItem.Id);
                rootArrributeLineItems.add(tmpAttr);
            }    
            arrributeLineItems.addAll(rootArrributeLineItems);

            
            for(Integer j= qty-1 ; j > 0 ; j--){

                String extKey                                           = j +'#'+rootLineItem.NE__Configuration_item_update_key__c;
                Id rootItemId                                           = rootLineItemMap.get(extKey).Id;
                List<NE__Order_Item_Attribute__c>  tmpAttributesClone   = rootArrributeLineItems.deepClone();
                
                for(NE__Order_Item_Attribute__c attr:tmpAttributesClone){
                    attr.NE__Order_Item__c = rootItemId;
                }
                arrributeLineItems.addAll(tmpAttributesClone);
            }
        }

        Map<String,NE__OrderItem__c> childLineItemsMap = new Map<String,NE__OrderItem__c>();

        if(childItemMap.keyset().size()>0){
            List<NE__OrderItem__c> childLineItems = new List<NE__OrderItem__c>();
            for(Object childItem : childItemMap.values()){
                Map<String,Object> tmpItemMap = (Map<String,Object>) childItem;
                Map<String,Object> childItemFields = (Map<String,Object>) tmpItemMap.get('fields');
                String childCatalogitemid = (String) childItemFields.get('catalogitemid');
                NE__OrderItem__c tmpLineItem = getItem(catItem.get(childCatalogitemid), childItemFields, confId, accountId, billingAccountId, serviceAccountId, billingProfId);           
                tmpLineItem.NE__Parent_Order_Item__c = rootLineItem.Id;
                tmpLineItem.NE__Root_Order_Item__c = rootLineItem.Id;
                tmpLineItem.NE__Bundle_Configuration__c = bundleId;
                childLineItems.add(tmpLineItem);
                childLineItemsMap.put(tmpLineItem.NE__Configuration_item_update_key__c,tmpLineItem);
            }
            for(Integer j= qty-1 ; j > 0 ; j--){
                for(NE__OrderItem__c childItem: childLineItems){
                    String extKey       = j +'#'+childItem.NE__Configuration_item_update_key__c;
                    String extKeyRoot   = j +'#'+rootLineItem.NE__Configuration_item_update_key__c;
                    String itemCode     = j +'#'+childItem.NE__Item_Code__c;
                    NE__OrderItem__c tmpItem = childItem.clone();
                    Id rootItemId  = rootLineItemMap.get(extKeyRoot).Id;
                    tmpItem.NE__Configuration_item_update_key__c = extKey;
                    tmpItem.NE__Parent_Order_Item__c = rootItemId;
                    tmpItem.NE__Root_Order_Item__c = rootItemId;
                    tmpItem.NE__Bundle_Configuration__c = bundleId;
                    tmpItem.NE__Item_Code__c = itemCode;
                    childLineItemsMap.put(extKey,tmpItem);
                }
                
            }
        }

        if(!childLineItemsMap.isEmpty()){
            try{
                NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                upsert childLineItemsMap.values() NE__Configuration_item_update_key__c; 
            
            } catch( QueryException e ) {
                
                try{
                    NE__Order__c orderUPD = [SELECT Id FROM NE__Order__c WHERE Id =:confId LIMIT 1 FOR UPDATE];
                    upsert childLineItemsMap.values() NE__Configuration_item_update_key__c; 
                
                } catch( QueryException x ) {
                    throw x;
                }
            }         
        }

        for(String extKey: childItemMap.keyset()){
               Map<String,Object> childItem     = (Map<String,Object>) childItemMap.get(extKey);
               List<Object>  childItemAttributes 	            = (List<Object>)  childItem.get('listOfAttributes'); 
               //START francesca ribezzi 21/11/19 - PROD-145 - get rootId from chilItem with qty 1 or qty > 1
               Id rootId; 
               if(childLineItemsMap.get(extKey) != null){ 
                   rootId = childLineItemsMap.get(extKey).Id;
               }
               if(childItem.get('fields') != null){  
                    Map<String,Object> childItemFields = (Map<String,Object>) childItem.get('fields'); 
                    Id newId = getOrderItemId((String)childItemFields.get('id'));  
                    if(newId != null){ 
                        rootId = newId;   
                    }
               }
               //END francesca ribezzi 21/11/19 - PROD-145 
               if(childItemAttributes != null && !childItemAttributes.isEmpty())
                {
                    List<NE__Order_Item_Attribute__c > childArrributeLineItems = new List<NE__Order_Item_Attribute__c >();
                    for(Object currentItemAttribute: childItemAttributes){
                        Map<String,Object> currentItemAttributeMap = (Map<String,Object>) currentItemAttribute;
                        Map<String,Object> currentItemAttributeFields = (Map<String,Object>) currentItemAttributeMap.get('fields');
                        if(String.isBlank((String)currentItemAttributeFields.get('pfpId'))) {
                            continue;
                        }
                        NE__Order_Item_Attribute__c  tmpAttr = getItemAttribute(currentItemAttributeFields,rootId);
                        childArrributeLineItems.add(tmpAttr);
                    }    
                    arrributeLineItems.addAll(childArrributeLineItems);

                    
                    for(Integer j= qty-1 ; j > 0 ; j--){

                        String extKeychild                                      = j +'#'+extKey;
                        Id rootItemId                                           = childLineItemsMap.get(extKeychild).Id;
                        List<NE__Order_Item_Attribute__c>  tmpAttributesClone   = childArrributeLineItems.deepClone();
                        
                        for(NE__Order_Item_Attribute__c attr:tmpAttributesClone){
                            attr.NE__Order_Item__c = rootItemId;
                        }
                        arrributeLineItems.addAll(tmpAttributesClone);
                    }
                }
        }
        
        if(arrributeLineItems.size()>0){
            upsert arrributeLineItems Id;
        }

        return true;
    }
    @AuraEnabled
    public static Boolean setConfigurationToApprove( String idOrder )
    {
        //get conf with query and update configuration with that flag set to true;
        System.debug( 'ID order' + idOrder );
        try
        {
            //	micol.ferrari 24/12/2018 - ADDED FIELDS TO THE ORDER QUERY: OB_ApprovalType__c,OB_ApprovalStatus__c
            NE__Order__c ord =
            [
                    SELECT Id,
                            Name,
                            OB_StartPricingApprovalProcess__c,
                            NE__Order_Header__r.OB_ProposerABI__r.Name,
                            ownerId,
                            NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c,
                            OB_ApprovalType__c,
                            OB_ApprovalStatus__c,
                            OB_ApprovalLevel__c,
                            NE__Order_Header__r.OB_Main_Process__c // NEXI-314 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 11/09/2019
                    FROM NE__Order__c //RP_012 Z. Urban <z.urban@accenture.com> 28/03/2019 Add OB_ApprovalLevel__c to query
                    WHERE id = :idOrder
                    LIMIT 1
            ];

            String stringConcat;
            //END
            //START R1F2_RP_012 Z. Urban <z.urban@accenture.com> 29/03/2019 Set stringContact that depends on the level
            if ( ord.OB_ApprovalLevel__c.contains( OB_UtilityConstants.L1 ) )
            {
                stringConcat = ord.NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_PRICING;
            }
            if ( ord.OB_ApprovalLevel__c.contains( OB_UtilityConstants.L2 ) )
            {
                stringConcat = ord.NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_PRICING + ' ' + OB_UtilityConstants.L2;
            }
            if ( ord.OB_ApprovalLevel__c.contains( OB_UtilityConstants.L3 ) )
            {
                stringConcat = ord.NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_PRICING + ' ' + OB_UtilityConstants.L3;
            }
            //STOP R1F2_RP_012  Z. Urban <z.urban@accenture.com> 29/03/2019

            List<Group> groupSelected =
            [
                    SELECT Id,Name
                    FROM Group
                    WHERE Type = 'Queue'
                    AND Name = :stringConcat
                    LIMIT 1
            ];

            Id oldOwner = ord.ownerId;

            if ( groupSelected != null && groupSelected.size( ) > 0 )
            {
                ord.ownerId = groupSelected[ 0 ].Id;
                ord.OB_StartPricingApprovalProcess__c = true;
            }
            else
            {
                ord.ownerId = oldOwner;
                ord.OB_StartPricingApprovalProcess__c = false;
            }

            // NEXI-314 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 11/09/2019 START
            if ( OB_Utility.isOperation( ) && OB_UtilityConstants.SETUP.equalsIgnoreCase( ord.NE__Order_Header__r.OB_Main_Process__c ) )
            {
                OB_Utility.updateOrderToApprove( ord.Id, OB_UtilityConstants.APPROV_TYPE_PRICING );
                return true;
            }
            // NEXI-314 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 11/09/2019 STOP

            if ( oldOwner != ord.ownerId )
            {
                //	START 	micol.ferrari 24/12/2018
                ord.OB_ApprovalType__c = OB_UtilityConstants.APPROV_TYPE_PRICING;
                //	END 	micol.ferrari 24/12/2018

                update ord;
                // Create an approval request for the Order Header
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest( );
                req1.setComments( 'Submitting request for approval.' );
                req1.setObjectId( ord.Id );

                // Submit on behalf of a specific submitter
                req1.setSubmitterId( oldOwner );

                // Submit the record to specific process
                req1.setProcessDefinitionNameOrId( 'Approvazione_Pricing');
                req1.setSkipEntryCriteria( false );
                System.debug( 'Approval Process: ' + req1 );

                //Submit the approval request for the account
                Approval.ProcessResult result = Approval.process( req1 );

                return true;
            }
            else
            {
                //Cannot find a queue of approval for the ABI in the order
                System.debug( 'Cannot find a queue of approval for the ABI in the order' );
                return false;
            }

        } catch ( Exception e )
        {
            System.debug( 'Exception in OB_CatalogController::setConfigurationToApprove ' + e.getMessage( ) + ' at line ' + e.getLineNumber( ) );
            return false;
        }
    }

    @AuraEnabled
    public static String saveAndExitBit2FlowCaller( String dataMap, String wizardWrapperString, Boolean isCommunity )
    {
		String toReturnURL;
		try
		{ 
			//marco.ferri --> fix for Spring '19 cannot have Map<String,Object> in method declaration
			Map<String,Object> data = new Map<String,Object>();
			data = (Map<String,Object>) JSON.deserializeUntyped(dataMap);
			//end
			
			system.debug('bi2flow : ' + wizardWrapperString);	 
			Map<String,Object> wizardWrapperMap = new Map<String,Object>();
			wizardWrapperMap = (Map<String,Object>) JSON.deserializeUntyped(wizardWrapperString);
			String wizardWrapperLabel = JSON.serialize(wizardWrapperMap.get('label'));
			String wizardWrapperName = JSON.serialize(wizardWrapperMap.get('name'));
            // ANDREA MORITTU START START 20-Sept-2019 - solving issue on id case in map!!!!!!
            String wizardWrapperId;
            if(wizardWrapperMap.containsKey('Id')) {
              wizardWrapperId = JSON.serialize(wizardWrapperMap.get('Id'));  
            } else {
                wizardWrapperId = JSON.serialize(wizardWrapperMap.get('id'));
            }
			// ANDREA MORITTU END START 20-Sept-2019 - solving issue on id case in map!!!!!!
			
			
			wizardWrapperLabel = wizardWrapperLabel.replace('"','');
			wizardWrapperName = wizardWrapperName.replace('"','');
			
			system.debug('saveHistoricData: ' + data);	
			//	START 	micol.ferrari 12/11/2018
			String orderString = JSON.serialize(data.get('OrderHeader'));
			System.debug('orderString string :' + orderString);
			NE__Order_Header__c orderHeader = (NE__Order_Header__c)JSON.deserialize(orderString, NE__Order_Header__c.class);
			//	END 	micol.ferrari 12/11/2018
	
			// Retrieve from the wrapper the wizardId (not the attach Id). If the field is not there or it is empty, get the Id by Name
			String wizardIdValue = '';

			if(wizardWrapperId != null && wizardWrapperId != '' && wizardWrapperId != 'null')
			{
				wizardIdValue = wizardWrapperId;
			}
			else
			{
				// we have to retrieve the Id from the IntegrationAdministarion or the Wizard Definition
				if(Type.forName('NE__IntegrationAdministration__c') != null)
				{
					System.debug('Finding administrationList');
					List<sObject> administrationList = Database.query('SELECT Id FROM NE__IntegrationAdministration__c WHERE NE__Name__c =\'' + wizardWrapperName + '\'  ORDER BY CreatedDate DESC LIMIT 1');
					System.debug('administrationList: ' + administrationList);
					if(!administrationList.isEmpty())
					{
						wizardIdValue = (String) administrationList[0].get('Id'); 
					}
				}
				//JGL 20/03/2018 fix saving historic 
				if(wizardIdValue =='' )
				{	
					System.debug('Finding wizarddefList');
					List<sObject> wizarddefList = Database.query('SELECT Id FROM bit2flow__Wizard_Definition__c WHERE bit2flow__Name__c =\'' + wizardWrapperName + '\'  ORDER BY CreatedDate DESC LIMIT 1');
					System.debug('wizarddefList: ' + wizarddefList);
					if(!wizarddefList.isEmpty())
					{
						wizardIdValue = (String) wizarddefList[0].get('Id');
					}
				} 
			}
		    //START Francesca Ribezzi <francesca.ribezzi@accenture.com>
			//@date 16/04/19 @task R1F2-28 
			//@deleting all historicData related to the current orderHeader:
			List<bit2flow__Historic_Wizard_Data__c> historicDataList = [
				SELECT id,CreatedDate, OB_OrderHeaderId__c 
				FROM bit2flow__Historic_Wizard_Data__c where OB_OrderHeaderId__c = :orderHeader.Id 
			];
            if(historicDataList.size() > 0){
                OB_Utility.deleteHosticWizardDataOnCatalogController(historicDataList);
            }
             
			
			//END Francesca Ribezzi 
            bit2flow__Historic_Wizard_Data__c historicData = new bit2flow__Historic_Wizard_Data__c( );
            historicData.bit2flow__Wizard_Name__c = wizardWrapperName;
            historicData.bit2flow__Wizard_Label__c = wizardWrapperLabel;
            historicData.bit2flow__Status__c = 'Draft';
            historicData.bit2flow__Wizard_Id__c = wizardIdValue;

            //	START 	micol.ferrari 12/11/2018 Adapted marco.ferri 17/11/2018
            if ( orderHeader != null )
            {
                historicData.OB_OrderHeaderId__c = orderHeader.Id;
            }
            //	END 	micol.ferrari 12/11/2018 Adapted marco.ferri 17/11/2018

            String historicExiStringId = '';

            upsert historicData;

            System.debug( 'upsert done: ' + historicData );

            List<Attachment> atachmentsList = new List<Attachment>( );

            // data attachment
            Attachment dataAttachment = new Attachment( );
            dataAttachment.Body = Blob.valueOf( JSON.serialize( data ) );
            dataAttachment.Name = String.valueOf( 'dataJSON.json' );
            dataAttachment.ParentId = ( Id ) historicData.get( 'Id' );

            atachmentsList.add( dataAttachment );

            // wrapper attachment
            Attachment wrapperAttachment = new Attachment( );
            wrapperAttachment.Body = Blob.valueOf( String.valueOf( wizardWrapperString ) );
            wrapperAttachment.Name = String.valueOf( 'wrapperJSON.json' );
            wrapperAttachment.ParentId = ( Id ) historicData.get( 'Id' );

            atachmentsList.add( wrapperAttachment );

            insert atachmentsList;
            //START gianluigi.virga 16/09/2019 - Check order status if is 'Preventivo'
			Boolean isPreventivo = false;
			System.debug('GET isPreventivo from dataMap: '+ data.get('isPreventivo'));
			if(data.get('isPreventivo') != null){
				isPreventivo = Boolean.valueOf(data.get('isPreventivo'));
			}
			if(isPreventivo){
				String confId = (String) bit2flow.B2FUtils.getJSONValue(data, 'Configuration', 'id');
				System.debug('ID order'+ confId);
				NE__Order__c ord = [SELECT OB_Bank_OrderStatus__c, 
											OB_Nexi_OrderStatus__c, 
											//OB_FulfilmentStatus__c, //g.v. 01/10/2019
											// NE__Order_Header__r.OB_FulfilmentStatus__c, //g.v. 01/10/2019
											OB_Bank_LastStatusChange__c,
											OB_Nexi_LastStatusChange__c
											FROM NE__Order__c 
											WHERE id = :confId 
											LIMIT 1];
				ord.OB_Bank_OrderStatus__c = System.Label.OB_PrintedQuoteStatus;
				ord.OB_Nexi_OrderStatus__c = System.Label.OB_PrintedQuoteStatus;
				// ord.OB_FulfilmentStatus__c = System.Label.OB_PrintedQuoteStatus; //g.v. 01/10/2019
				// ord.NE__Order_Header__r.OB_FulfilmentStatus__c = System.Label.OB_PrintedQuoteStatus; //g.v. 01/10/2019
				ord.OB_Bank_LastStatusChange__c = System.now();
				ord.OB_Nexi_LastStatusChange__c = System.now();
				update ord;
			}
			//END gianluigi.virga 16/09/2019 

            //need to check if Community send community URL

            toReturnURL = OB_ContinuationController.getVFBaseURL( );//URL.getSalesforceBaseUrl().toExternalForm();

            return toReturnURL;

        } catch ( Exception e )
        {
            toReturnURL = null;
            System.debug( 'Exception creating JSON attach: ' + e.getMessage( ) );
            return toReturnURL;
        }
    }

    @AuraEnabled
    public static Boolean updateConfigVariation( String confId, String variation )
    {
        System.debug( 'into updateConfVariation' );
        Boolean success;

        NE__Order__c ord =
        [
                SELECT id, OB_Variation__c
                FROM NE__Order__c
                WHERE id = :confId
        ];

        ord.OB_Variation__c = variation;

        try
        {
            update ord;
            success = true;
        } catch ( Exception e )
        {
            System.debug( 'Exception updating configuration OB_Variation__c: ' + e.getMessage( ) );
            success = false;
        }
        return success;
    }
    @AuraEnabled
    public static String launchMaintenanceWizard( String wizardName )
    {

        return OB_RunWizard_CC.getWizardIdFromAPIName( wizardName );

    }


    //10/05/19 francesca.ribezzi changing return type to String (logRequest id)
    @AuraEnabled
    public static String createLogRequestServer( String merchantId, String servicePointId, String confId, String abi, String cab, String subProcess, Boolean checkBIO )
    {
        //Boolean isSuccess;
        //10/05/19 francesca.ribezzi adding variable logRequestId
        String logRequestId = null;
        Boolean hasAcquiring = false;
        Boolean hasPOS = false;
        
        //	START 	micol.ferrari 06/02/2019
        List<NE__OrderItem__c> orderItemPOS =
        [
                SELECT id,OB_VariationPOSPB__c
                FROM NE__OrderItem__c
                WHERE
                NE__OrderId__c = :confId
                AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing'
                AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName IN ('Terminali', 'Pagobancomat')
                AND ( NE__Action__c = 'Add' OR NE__Action__c = 'Change' )
        ];
        //	END 	micol.ferrari 06/02/2019

        if ( orderItemPOS.size( ) > 0 )
        {
            hasPOS = true;
        }

        //	START 	micol.ferrari 06/02/2019
        List<NE__OrderItem__c> orderItemAcqVAS =
        [
                SELECT id,OB_VariationPOSPB__c
                FROM NE__OrderItem__c
                WHERE
                NE__OrderId__c = :confId
                AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing'
                AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName IN ('VAS', 'Acquiring')
                AND ( NE__Action__c = 'Add' OR NE__Action__c = 'Change')
        ];
        //	END 	micol.ferrari 06/02/2019

        if ( orderItemAcqVAS.size( ) > 0 )
        {
            hasAcquiring = true;
        }

        //	START	micol.ferrari 14/02/2019 - ADDED TRY CATCH
        try
        {
            System.debug( 'OB_CatalogController : *CHECK BIO*' );
            NE__Order__c conf = new NE__Order__c( );
            String stringConcat;
            //10/05/19 francesca.ribezzi adding NE__Order_Header__c field to query
            List<NE__Order__c>listOfconf =
            [
                    SELECT Id,OB_ApprovalType__c,OB_AdditionalDocumentationRequired__c,OwnerId,OB_ABI__c,OB_CAB__c,NE__Order_Header__c
                    FROM NE__Order__c
                    WHERE Id = :confId
            ];

            //LUBRANO -- 2019/02/15 -- aggiunta checkBIO
            List<OB_Bank_Profile__c> listOfBankProf = [ SELECT Id,OB_NeedBIO__c FROM OB_Bank_Profile__c WHERE OB_Bank__r.OB_ABI__c = :listOfconf[ 0 ].OB_ABI__c LIMIT 1 ];
            if ( !listOfBankProf.isEmpty( ) )
            {
                checkBIO = listOfBankProf.get( 0 ).OB_NeedBIO__c;
            }
            // Start    antonio.vatrano 10/05/2019 - R1F2-112 – Retrieve license of current User

            //  Micol Ferrari <micol.ferrari@accenture.com>, 05/07/2019 - START
            String license;
            if ( !Test.isRunningTest( ) )
            {
                license = retrieveUserLicense();
            }
            else
            {
                license = 'NOTSalesforce';
            }   
            //  Micol Ferrari <micol.ferrari@accenture.com>, 05/07/2019 - STOP

            Boolean isSalesforce = license == 'Salesforce' ? true : false;
            // end    antonio.vatrano 10/05/2019 - R1F2-112 – Retrieve license of current User
            if ( !listOfconf.isEmpty( ) )
            {
                conf = listOfconf.get( 0 );
                Boolean callBIO = checkBIO && conf.OB_AdditionalDocumentationRequired__c ? true : false;
                System.debug( 'OB_CatalogController : *CHECK BIO* : conf : ' + JSON.serialize( conf ) );

                //	START 	micol.ferrari 14/02/2019 - CREATION OF THE LOG REQUEST AFTER WE KNOW THAT THE BIO APPROVAL PRICING MUST START
                OB_LogRequest__c logRequest = new OB_LogRequest__c( );
                Id rtPricing = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_Pricing' ).getRecordTypeId( );
               //Simone Misani 09/07/2019 F2WAVe2-115 remove if conditions becaouse now the log request is Integrated
                logRequest.OB_Status__c = OB_UtilityConstants.BOZZA;
               
                logRequest.OB_AccountId__c = merchantId;
                logRequest.OB_ServicePointId__c = servicePointId;
                logRequest.OB_OrderId__c = confId;
                logRequest.OB_ABI__c = listOfconf.get( 0 ).OB_ABI__c;
                logRequest.OB_CAB__c = listOfconf.get( 0 ).OB_CAB__c;
                logRequest.OB_MaintenanceType__c = OB_UtilityConstants.PRICING; //PRICING
                logRequest.OB_HasAcquiring__c = hasAcquiring;
                logRequest.OB_HasPos__c = hasPOS;
                logRequest.OB_isNotIntegrated__c = false;
                logRequest.RecordTypeId = rtPricing; //OB_Pricing
                // START--Simone Misani  set  required field   23/08/2019
                logRequest.OB_RequestDate__c = Date.today();
                Boolean isPartnerCommunityLogged = OB_Utility.isPartnerCommunity( UserInfo.getUserId( ) );
                if ( isPartnerCommunityLogged )
                {
                    logRequest.OB_Requestor__c = OB_UtilityConstants.Banca;
                }
                String orderHeaderId;        // END--Simone Misani  set  required field  23/08/2019
                try                
                {
                    
                    insert logRequest;
                    //10/05/19 francesca.ribezzi logRequestId
                    logRequestId = logRequest.Id;
                    // michele.lubrano 10/05/2019 implementing MIP API call for maintenance pricing START
                     orderHeaderId = listOfconf[0].NE__Order_Header__c;
                    System.debug('@Setup : callSubmit - Id: ' + orderHeaderId);
                    
                    // michele.lubrano 10/05/2019 END
                } catch ( Exception e )
                {
                    System.debug( 'Exception creating a log request: ' + e.getMessage( ) );
                    System.debug( 'Exception type caught: ' + e.getTypeName( ) );
                    System.debug( 'Message: ' + e.getMessage( ) );
                    System.debug( 'Cause: ' + e.getCause( ) );
                    System.debug( 'Line number: ' + e.getLineNumber( ) );
                    System.debug( 'Stack trace: ' + e.getStackTraceString( ) );
                      //10/05/19 francesca.ribezzi commenting this line below
                  //  isSuccess = false;
                }
                //	END 	micol.ferrari 14/02/2019 - CREATION OF THE LOG REQUEST AFTER WE KNOW THAT THE BIO APPROVAL PRICING MUST START

                if ( callBIO && !isSalesforce )     //antonio.vatrano 10/05/2019 - R1F2-112 – add condition about license of current User
                {
                    conf.OB_ApprovalType__c = OB_UtilityConstants.APPROV_TYPE_BIO;
                    stringConcat = abi + OB_UtilityConstants.APPROVAZIONE_BIO;

                    List<Group> groupSelected =
                    [
                            SELECT Id,Name
                            FROM Group
                            WHERE Type = 'Queue'
                            AND Name = :stringConcat
                            LIMIT 1
                    ];
                    System.debug( 'OB_CatalogController : *CHECK BIO* : groupSelected : ' + groupSelected );
                    if ( groupSelected != null && groupSelected.size( ) > 0 )
                    {
                        conf.OwnerId = groupSelected[ 0 ].Id;
                        System.debug( 'OB_CatalogController : *CHECK BIO* : CONF OWNER ID: ' + conf.OwnerId );
                    }
                    update conf;
                    OB_Utility.submitApprovalProcess( conf.Id, Label.OB_BIO_ApprovalProcess );
                }
                Boolean checkAcquiring = OB_Utility.retrieveSpecialCategoryConfigurations(orderHeaderId);
                //OB_OrderItemCheckerDate.updateStartDatePricing(listOfconf); // Simone Misani 24/07/2019 
                OB_QueueableClassCheckApprovalProcesses.updateStartDatePricing(conf.Id);
                if(!callBIO && !checkAcquiring){//Simone misani WN-347
                     System.enqueueJob(new OB_QueueableClass(orderHeaderId));//Simone misani WN-347
                }
               
            }
        } catch ( Exception e )
        {
            System.debug( 'Exception starting a BIO approval process: ' + e.getMessage( ) );
            System.debug( 'Exception type caught: ' + e.getTypeName( ) );
            System.debug( 'Message: ' + e.getMessage( ) );
            System.debug( 'Cause: ' + e.getCause( ) );
            System.debug( 'Line number: ' + e.getLineNumber( ) );
            System.debug( 'Stack trace: ' + e.getStackTraceString( ) );
            //10/05/19 francesca.ribezzi commenting this line below
            //isSuccess = false;
        }
        //	END		micol.ferrari 14/02/2019 - ADDED TRY CATCH
        //12-02-2018-S.P.-CHECK FOR BIO APPROVAL PROCESS-END
        //10/05/19 francesca.ribezzi changing return type
        return logRequestId;
    }

    @AuraEnabled
    public static Boolean checkForAcquiringChangesServer( Id confId )
    {
        List<Id> confList = new List<Id>( );
        confList.add( confId );
        return OB_Utility.checkForAcquiringChanges( confList );
    }

    //Start antonio.vatrano 08/05/2019 r1f2-106 method to retrieve license of current user
    @AuraEnabled
    public static String retrieveUserLicense(){
        List<User> listUser = [SELECT id, Profile.UserLicense.name FROM User WHERE id =:UserInfo.getUserId() LIMIT 1];
        String licenceName = '';
        if(!listUser.isEmpty()){
            User currentUser = listUser.get(0);
            licenceName = currentUser.Profile.UserLicense.Name;
            return licenceName;
        }
        return licenceName;
    }
    //End antonio.vatrano 08/05/2019 r1f2-106 method to retrieve license of current user

	/*

	*	Author		: 	Morittu Andrea
	*	Date		:	19-Sept-2019
	*	Task		:	EVO_PRODOB_452
	*	Description	:	Set Order to Cancelled and re-Active Asset related
	
	*/
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

	/*******************************************************************************
	Purpose:  method to retrieve field from bankProfile
    Parameters: -
    Returns: Boolean

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         19/09/2019      Created         Retrieve field on bankProfile
	
 	********************************************************************************/
	@AuraEnabled
    public static Boolean getShowQuote(){
		Boolean showQuoteButton = false;
		try {
        	String userId = UserInfo.getUserId();
        	User currentUsr = [SELECT  Id,
                           		 contactId , 
                           		 contact.accountId, 
                           		 Profile.UserLicense.Name,
                           		 Profile.Name,
                           		 OB_CAB__C , 
                          		 OB_ABI__c
                  			 	 FROM User
                   			 	 WHERE Id =: userId
                   			     LIMIT 1];
            System.debug('## current user is: ' + currentUsr );
        
            List<OB_Bank_Profile__c> bankProfile = [SELECT OB_ShowQuoteButton__c 
													FROM OB_Bank_Profile__c 
													WHERE OB_Bank__c=: currentUsr.contact.accountId 
													LIMIT 1];
            if(bankProfile != null ) {
				showQuoteButton = bankProfile[0].OB_ShowQuoteButton__c;
            }
            
        } catch(Exception ecc) {
            System.debug('The following exception has occurred: ' + 'at line: ' + ecc.getLineNumber() + 'message : '  + ecc.getMessage() );
        }
        return showQuoteButton;
    }

	/*******************************************************************************
	Purpose:  method to update privacy fields on Service Point
    Parameters: Id service point
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         19/09/2019      Created         update privacy fields on Service Point
	
 	********************************************************************************/
	@AuraEnabled
    public static void updatePrivacyServicePoint(String servicePointId){
		List<NE__Service_Point__c> currentSp = [SELECT Id, 
													OB_Privacy_C3__c,
													OB_Privacy_C4__c,
													OB_Privacy_C5__c
													FROM NE__Service_Point__c
													WHERE Id =: servicePointId
													LIMIT 1];
		if(!currentSp.isEmpty() && currentSp != null){
			currentSp[0].OB_Privacy_C3__c = true;
			currentSp[0].OB_Privacy_C4__c = true;
			currentSp[0].OB_Privacy_C5__c = true;
			update currentSp;
		}

	}
    /*
        @Author     :   Morittu Andrea
        @Task       :   Id_Stream_6_Subentro
        @Date       :   2019.05.13
    */
    @AuraEnabled
    public static Boolean updateAssetInMerchantTakeOver(String orderId, String offerAssetId) {
        List<NE__Order__c> listToUpdate = new List<NE__Order__c>();
        NE__Order__c singleOrderToUpdate = new NE__Order__c();
        Boolean updateWasSuccesfull;
        
        try {
            singleOrderToUpdate = [SELECT  Id, 
                                    OB_Takeover_OfferAsset__c //francesca.ribezzi 24/09/19 changing field to OB_Takeover_OfferAsset__c (lookup)
                            FROM    NE__Order__c
                            WHERE   Id =: orderId
                            LIMIT   1];
            if(!String.isBlank(offerAssetId)) {
                singleOrderToUpdate.OB_Takeover_OfferAsset__c = offerAssetId;  //francesca.ribezzi 24/09/19 changing field to OB_Takeover_OfferAsset__c (lookup)
                listToUpdate.add(singleOrderToUpdate);
                update listToUpdate;
                updateWasSuccesfull = true;
            } else {
				updateWasSuccesfull = false;
            }
        } catch (Exception exc) {
            System.debug('An error has occured inside updateAssetInMerchantTakeOver : ' + exc.getMessage());
            updateWasSuccesfull = false;
        }
        return updateWasSuccesfull;
    }
    /*
        Morittu Andrea END

    */
    /*******************************************************************************
	Purpose:  method returns an id if the sobject is an orderItem
    Parameters: Sobject Id to string
    Returns: Id 

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         francesca Ribezzi       21/11/2019      Created         PROD-145
	
 	********************************************************************************/
	@AuraEnabled
    public static Id getOrderItemId(String itemId){ 
        Id toReturn = null;
        if(String.isBlank(itemId)){
            return toReturn;
        }    
        Id newId = toId(itemId);
        String sobjectType = newId.getSObjectType().getDescribe().getName();  
        if(sobjectType == 'NE__OrderItem__c'){ 
            toReturn = newId; 
        }
        return toReturn; 
    }

    
}