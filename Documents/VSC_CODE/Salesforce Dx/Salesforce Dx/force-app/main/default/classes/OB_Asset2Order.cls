public without sharing class OB_Asset2Order extends OB_Asset2Order_Mapping {

	public String getAssetBody(){
		
		String selectBody = '';
		for(String fieldName : super.getAssetFields()){
			selectBody += fieldName +',';
		}
		selectBody = selectBody.left(selectBody.length()-1);
		
		return selectBody;
	}
	
	public NE__Order_Header__c generateOrderHeader(Asset offer, String typeAs, OB_Bank_Profile__c bankProfile,Boolean isPricing,Boolean isReplacement,Boolean isTerminate)
	{
			
			NE__Order_Header__c tmpOrderHeader = super.mapAsset2OrderHeader(offer);

			if(isReplacement)
			{
				tmpOrderHeader.OB_Sub_Process__c = 'sostituzione terminali';
			}
			else if(isPricing)
			{
				tmpOrderHeader.OB_Sub_Process__c = 'variazione economica';
			}
			else if(isTerminate)
			{
				tmpOrderHeader.OB_Sub_Process__c = 'termina offerta';
			} 
			else
			{
				tmpOrderHeader.OB_Sub_Process__c = 'variazione operativa';//Simone Misani 16/07/2019 MIp's defects
			}
			
			tmpOrderHeader.OB_ProposerABI__c				= bankProfile.OB_Bank__c;
			tmpOrderHeader.OB_Apm_Circuit__c				= bankProfile.OB_Apm_Circuit__c;
			tmpOrderHeader.OB_Circuit__c					= bankProfile.OB_Circuit__c;
			tmpOrderHeader.OB_VAS__c						= bankProfile.OB_VAS__c;
			tmpOrderHeader.OB_Other_Acquirer__c				= bankProfile.OB_Other_Acquirer__c;
			tmpOrderHeader.OB_Business_Model_Acquiring__c	= bankProfile.OB_Business_Model_Acquiring__c;
			tmpOrderHeader.OB_Business_Model_POS__c			= bankProfile.OB_Business_Model_POS__c;
			//davide.franzini - F2WAVE2-178 - 26/08/2019 - START
			tmpOrderHeader.OB_Applicant_RAC_Code_SIA__c		= bankProfile.OB_Applicant_RAC_Code_SIA__c;
			tmpOrderHeader.OB_Terminal_Id_Generator__c		= bankProfile.OB_Terminal_Id_Generator__c;
			tmpOrderHeader.OB_Terminal_Id_Gateway__c		= bankProfile.OB_Terminal_Id_Gateway__c;
			//davide.franzini - F2WAVE2-178 - 26/08/2019 - START 

			
			tmpOrderHeader.NE__Type__c ='ChangeOrder';
			if(typeAs.equalsIgnoreCase('Disconnect'))
			{
				tmpOrderHeader.NE__Type__c ='Disconnection';
			}
			return tmpOrderHeader;
	}

	public NE__order__c generateOrder(Asset offer,String typeAs,NE__Order_Header__c orderHeader,Boolean isEditCommissionModel)
	{

			NE__order__c tmpOrder = super.mapAsset2Order(offer);
			
			//davide.franzini - 14/10/2019 - START
			tmpOrder.NE__Configuration_Type__c ='Change';
			tmpOrder.NE__Type__c ='ChangeOrder';
			//davide.franzini - 14/10/2019 - END
			
			if(typeAs.equalsIgnoreCase('Disconnect')){
				tmpOrder.NE__Configuration_Type__c ='Disconnect';
				tmpOrder.NE__Type__c ='Disconnection';
			}

			tmpOrder.NE__Order_Header__c 			= orderHeader.Id;
			tmpOrder.OB_ABI__c 						= orderHeader.OB_ABI__c;
			tmpOrder.OB_CAB__c 						= orderHeader.OB_CAB__c; 
			tmpOrder.OB_EXCH_Commission__c 			= isEditCommissionModel;
			//davide.franzini - 14/10/2019 - START
			tmpOrder.OB_Business_Model_Acquiring__c	= orderHeader.OB_Business_Model_Acquiring__c;
			tmpOrder.OB_Business_Model_POS__c		= orderHeader.OB_Business_Model_POS__c;
			//davide.franzini - 14/10/2019 - END
		

			if(isEditCommissionModel){
				tmpOrder.OB_AgreedChanges__c 			= true;
				tmpOrder.OB_Model_Changed__c 			= true;//Simone Misani WN-189;
			}
				

			Boolean emptyShopSign							= String.isEmpty(offer.OB_ShopSign__c);

			if(emptyShopSign)
			{
				tmpOrder.OB_ShopSign__c = offer.NE__Order_Config__r.OB_Service_Point__r.Name;
			}
			
			tmpOrder.OB_ReceiptHeader__c 			= offer.NE__Order_Config__r.OB_ReceiptHeader__c;
			
			if(String.isEmpty(offer.NE__Order_Config__r.OB_ReceiptHeader__c) && !emptyShopSign)
			{
				tmpOrder.OB_ReceiptHeader__c = tmpOrder.OB_ShopSign__c.substring(0,math.min(24,tmpOrder.OB_ShopSign__c.length()));
			}

			tmpOrder.OB_ReceiptCity__c  = offer.NE__Order_Config__r.NE__City__c;
			if(String.isEmpty(offer.NE__Order_Config__r.NE__City__c) && String.isNotEmpty(tmpOrder.OB_Service_Point__r.NE__City__c))
			{	
				tmpOrder.OB_ReceiptCity__c  = tmpOrder.OB_Service_Point__r.NE__City__c.substring(0,math.min(24,tmpOrder.OB_Service_Point__r.NE__City__c.length()));
			}

			return tmpOrder;
	 }

	 public NE__orderitem__c getLineItem(Id orderId, Asset currentAsset,String typeAs)
	 {
		 	NE__orderitem__c tmpOrderItem = super.mapAsset2OrderItem(currentAsset);

			if(typeAs.equalsIgnoreCase('Disconnect')){
				tmpOrderItem.NE__Action__c = 'Remove';
			}

			tmpOrderItem.NE__OrderId__c                           =   orderId ;
			tmpOrderItem.NE__Configuration_item_update_key__c     =   orderId + '_' + currentAsset.id;

			return tmpOrderItem;
	 }	

	 public Map<String,Id> generateOrderItems(List<Asset> assetLines, Id orderId,Asset rootAsset,String typeAs)
		{
				Map<String,Id> externalIdMap 	= new Map<String,Id>();
				//Map<String,String>  fieldMap 	= mapping.get('asset').get('NE__orderitem__c');
				NE__orderitem__c rootOrderItem = getLineItem(orderId, rootAsset,typeAs);
				rootOrderItem.NE__Bundle_Configuration__c = null;

				system.debug('@@@ START ITEM DB');
				insert rootOrderItem;
				system.debug('@@@ END ITEM DB');

				Id bundleConfigurationId;
				bundleConfigurationId = rootOrderItem.Id;
				externalIdMap.put(rootOrderItem.NE__Configuration_item_update_key__c,rootOrderItem.Id);

				try{
			
					
					List<NE__orderitem__c> tmpItems 						= new List<NE__orderitem__c> ();
					Map<String,List<NE__orderitem__c>> 	childItemMaps	= new Map<String,List<NE__orderitem__c>>();

					if(assetLines.size() >0 ){
						system.debug('assetLines.size(): ' + assetLines);
						for(Asset currentAsset :assetLines)
						{
							NE__orderitem__c tmpOrderItem 						= getLineItem(orderId, currentAsset,typeAs);
							tmpOrderItem.NE__Bundle_Configuration__c 	= bundleConfigurationId;
							if(tmpOrderItem.NE__parent_order_item__c == null){
										tmpItems.add(tmpOrderItem);
										continue;
							}
							String parentKey = orderId + '_' + tmpOrderItem.NE__parent_order_item__c;
							List<NE__orderitem__c> childList = new List<NE__orderitem__c>();
							if(childItemMaps.containskey(parentKey))
							{
								childList = childItemMaps.get(parentKey);
							}

							childList.add(tmpOrderItem);
							childItemMaps.put(parentKey,childList);
						}
									
						system.debug('@@@ START ITEM DB');
						insert tmpItems;
						system.debug('@@@ END ITEM DB');

						
						for(NE__orderitem__c currentItem :tmpItems)
						{
							externalIdMap.put(currentItem.NE__Configuration_item_update_key__c,currentItem.Id);
						}

						externalIdMap.putAll(insertItemList(externalIdMap,childItemMaps));

						return externalIdMap;
					}
				}	catch(Exception e)
				{	
					System.debug('error in generate Line Item: ' + e.getLineNumber()+ ' ' + e.getMessage());
				}	
				return new Map<String,Id>();
	 	}
		
		public Map<String,Id> insertItemList(Map<String,Id> extIdMap, Map<String,List<NE__orderitem__c>> childs)
	 	{	
		 
			
			List<NE__orderitem__c> newList = new List<NE__orderitem__c>();
			for(String extId: childs.keyset())
			{
				if(extIdMap.containskey(extId))
				{
					Id itemId = extIdMap.get(extId);
					for(NE__orderitem__c childItem : childs.remove(extId))
					{
						childItem.NE__parent_order_item__c = itemId ;
						childItem.NE__Root_Order_Item__c = itemId ;
						newList.add(childItem);
					}
				}
			}
		 
			if(newList.size()>0)
			{
				system.debug('@@@ START ITEM DB');
				insert newList;
				system.debug('@@@ END ITEM DB');

				for(NE__orderitem__c currentItem :newList)
				{
					extIdMap.put(currentItem.NE__Configuration_item_update_key__c,currentItem.Id);
				}
				extIdMap.putAll(insertItemList(extIdMap,childs));
				return extIdMap;
			}	
			return new Map<String,Id>();
	 	}

		public List<NE__order_item_attribute__c> generateItemAttribute(List<NE__assetitemattribute__c> assetAttributes,Map<String,Id> extIdMap,Id orderId)
		{
			//Map<String,String>  fieldMap 	= mapping.get('NE__assetitemattribute__c').get('NE__order_item_attribute__c');

			List<NE__order_item_attribute__c> tmpAttr = new List<NE__order_item_attribute__c>();
			for(NE__assetitemattribute__c currentAttr :assetAttributes)
			{
				NE__order_item_attribute__c newItemAttr = super.mapAssetAttribute2OrderItemAttribute(currentAttr);

				newItemAttr.NE__Order_Item__c 	= extIdMap.get(orderId + '_' +currentAttr.NE__asset__c) ;
				tmpAttr.add(newItemAttr);
			}
			return tmpAttr;
		}

		public String getAttributeBody()
		{


			String selectBody = '';
			for(String fieldName : super.getAssetAttributeFields())
			{
				selectBody += fieldName +',';
			}
			selectBody = selectBody.left(selectBody.length()-1);
			
			return selectBody;
		}
}