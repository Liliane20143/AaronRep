/*******************************************************************************
Purpose:  class to generate update asset from order item - performance
Parameters: -
Returns: Boolean

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         enrico.purificato        23/10/2019      Created        moved from utility

********************************************************************************/
public without sharing class OB_UpdateAssetStatus implements Queueable
{
    String orderId;
    String mainProcessStatus;
    String bundleId;

    public OB_UpdateAssetStatus(String orderId, String mainProcessStatus,String bundleId)
    {
        this.orderId = orderId;
        this.mainProcessStatus = mainProcessStatus;
        this.bundleId = bundleId;

    }
    //Simone Misani 13/12/2019 START
    public static void updateItems( Set<Id> enterpriseIdList, String orderId, id BundleConfigurationId){
        
        System.debug(enterpriseIdList);
        System.debug(orderId);
        System.debug(BundleConfigurationId);
           List<NE__OrderItem__c> alllineItemsToUpdate = [SELECT 
                                                                Id,
                                                                NE__Action__c,
                                                                NE__Status__c,
                                                                NE__AssetItemEnterpriseId__c  
                                                                FROM NE__OrderItem__c 
                                                                WHERE NE__OrderId__c = :orderId 
                                                                AND OB_FulfilmentStatus__c  != 'Cancelled'
                                                                AND NE__AssetItemEnterpriseId__c IN :enterpriseIdList
                                                                AND NE__Bundle_Configuration__c =: BundleConfigurationId];
            
            list<Asset> assetList = new list<Asset>();
            for(NE__OrderItem__c confItem : alllineItemsToUpdate){
                Id assetId = (Id) confItem.NE__AssetItemEnterpriseId__c;
                if(confItem.NE__AssetItemEnterpriseId__c != null &&  assetId.getSObjectType().getDescribe().getName() == 'Asset'){
                    Asset singleAsset = new Asset(Id = confItem.NE__AssetItemEnterpriseId__c, OB_MerchantTakeover__c = false, OB_B2W_Session__c = ''); //Simone Misani 14/12/2019 Performance
                    if(confItem.NE__Action__c == 'Add' || confItem.NE__Action__c == 'Change' || confItem.NE__Action__c == 'None'){
                        singleAsset.NE__Action__c = 'None';
                        singleAsset.NE__Status__c = 'Active';
                        assetList.add(singleAsset);
                    }else if(confItem.NE__Action__c == 'Remove'){
                        singleAsset.NE__Action__c = 'None';
                        singleAsset.NE__Status__c = 'Disconnected';
                        assetList.add(singleAsset);
                    }
                }
            }
            if(!assetList.isEmpty()){
                        update assetList;
            }
    }
    //Simone Misani 13/12/2019 END
    public void execute(QueueableContext context)
    {
        id bundleConfItem;
        List<NE__OrderItem__c> oiList = [SELECT Id,
																						NE__AssetItemEnterpriseId__c,
																						NE__Startdate__c,
                                                                                       NE__Bundle_Configuration__c,//Simone Misani 13/12/2019
                                                                                        NE__OrderId__r.NE__Type__c	// Simone Misani  09/12/2019 Perf-30	
																						FROM NE__OrderItem__c 
																						WHERE NE__OrderId__c =: orderId 
																						AND NE__Bundle_Configuration__c != null LIMIT 1];
                                                                
        if(!oiList.isEmpty()){
              bundleConfItem = oiList.get(0).NE__Bundle_Configuration__c;//Simone Misani 13/12/2019
        }
         //Simone Misani 18/12/2019 START perf -83
        system.debug('bundleConfItem'+bundleConfItem);
        Map<Id,NE__OrderItem__c> lineItemsToUpdateMaps 	= new Map<Id,NE__OrderItem__c>([SELECT Id,
																						NE__AssetItemEnterpriseId__c,
																						NE__Startdate__c,
                                                                                        NE__ProdId__r.RecordType.Name,
                                                                                        NE__Action__c,
                                                                                        NE__OrderItem__c.NE__Bundle_Configuration__c,//Simone Misani 13/12/2019
                                                                                        NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c	// Simone Misani  09/12/2019 Perf-30	
																						FROM NE__OrderItem__c 
																						WHERE NE__OrderId__c =: orderId 
																						AND NE__Action__c ='Add' ]);
        Map<id,Date> installDateMap 			= new map<Id,Date>();
        Map<id,Datetime> startDateMap 			= new map<Id,Datetime>();
        try{
            // Simone Misani  09/12/2019 Perf-30 START 
            String isMaintenance;
            String isAction;
            //Simone Misani 13/12/2019
            // Simone Misani  09/12/2019 Perf-30 END 
            for(NE__OrderItem__c item : lineItemsToUpdateMaps.values())
            {
                
                bundleConfItem = item.NE__Bundle_Configuration__c;
                isMaintenance = item.NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c;
              
                Datetime dt =item.NE__Startdate__c;
                Date     d = date.newinstance(dt.year(), dt.month(), dt.day());
                if(isMaintenance == 'variazione operativa' && item.NE__ProdId__r.RecordType.Name == 'Terminali' && (item.NE__Action__c =='Remove' || item.NE__Action__c == 'Add')){
                     dt = null;//item.NE__Startdate__c;
                         d = null;//date.newinstance(dt.year(), dt.month(), dt.day());                    
                }
                startDateMap.put(item.id, dt);
                installDateMap.put(item.id, d);
            }
            //Simone Misani 18/12/2019 END perf -83
            List<Asset> assetToUpdate 								= new List<Asset>();
            List<NE__AssetItemAttribute__c> assetAttrToUpdate 		= new List<NE__AssetItemAttribute__c>();
            List<NE__OrderItem__c> lineItemsToUpdate 				= new List<NE__OrderItem__c>();
            List<NE__Order_Item_Attribute__c> attributeToUpdate 	= new List<NE__Order_Item_Attribute__c>();
        			
            Map<Id,Asset> assets = new Map<Id,Asset>([SELECT 
                                                        Id,
                                                        NE__AssetItemEnterpriseId__c,
                                                        NE__Parent_Order_Item__c, 
                                                        (SELECT id,NE__AttrEnterpriseId__c FROM NE__AssetItemAttributes__r ) 
                                                        FROM Asset 
                                                        WHERE NE__Order_Config__c =: orderId 
                                                        AND NE__Status__c = 'Pending' LIMIT 500]);// Simone Misani  09/12/2019 Perf-30 
                                
            for(Asset tmpAsset : assets.values()){
                if(lineItemsToUpdateMaps.containsKey(tmpAsset.NE__AssetItemEnterpriseId__c)){
                    Asset tmp = new Asset(Id=tmpAsset.Id, NE__AssetItemEnterpriseId__c = tmpAsset.Id, installdate = installDateMap.get(tmpAsset.NE__AssetItemEnterpriseId__c), ParentId=tmpAsset.NE__Parent_Order_Item__c , NE__StartDate__c = startDateMap.get(tmpAsset.NE__AssetItemEnterpriseId__c)); // Simone Misani 18/12/2019 perf-83
                    if( tmp.Id != bundleId){
                        tmp.NE__Bundle_Configuration__c = bundleId;
                    }
                    assetToUpdate.add(tmp);

                    NE__OrderItem__c tmpItem = new NE__OrderItem__c(Id=tmpAsset.NE__AssetItemEnterpriseId__c,NE__AssetItemEnterpriseId__c=tmpAsset.Id);
                    lineItemsToUpdate.add(tmpItem);

                    if(tmpAsset.NE__AssetItemAttributes__r != null && tmpAsset.NE__AssetItemAttributes__r.size()>0){
                        for(NE__AssetItemAttribute__c attr : tmpAsset.NE__AssetItemAttributes__r){
                                    assetAttrToUpdate.add(new NE__AssetItemAttribute__c(Id=attr.Id, NE__AttrEnterpriseId__c = attr.Id));
                                    NE__Order_Item_Attribute__c itemAttr = new NE__Order_Item_Attribute__c(Id=attr.NE__AttrEnterpriseId__c,NE__AttrEnterpriseId__c = attr.Id);
                                    attributeToUpdate.add(itemAttr);
                        }
                    }
                }
            }
            if(lineItemsToUpdate.size()>0){
                        update lineItemsToUpdate;
            }
            if(attributeToUpdate.size()>0){
                        update attributeToUpdate;
            }
            if(assetToUpdate.size()>0){
                        update assetToUpdate;
            }
            if(assetAttrToUpdate.size()>0){
                        update assetAttrToUpdate;
            }
            updateItems(assets.keyset(), this.orderid, bundleConfItem );//Simone Misani per1- 13/12/2019
            // List<NE__OrderItem__c> alllineItemsToUpdate = [SELECT 
            //                                                     Id,
            //                                                     NE__Action__c,
            //                                                     NE__Status__c,
            //                                                     NE__AssetItemEnterpriseId__c  
            //                                                     FROM NE__OrderItem__c 
            //                                                     WHERE NE__OrderId__c = :orderId 
            //                                                     AND OB_FulfilmentStatus__c  != 'Cancelled'
            //                                                     AND NE__AssetItemEnterpriseId__c IN :assets.keyset()
            //                                                     AND NE__Bundle_Configuration__c != null];
            // system.debug('assets.keyset() '+ assets.keyset().size());
            // list<Asset> assetList = new list<Asset>();
            // for(NE__OrderItem__c confItem : alllineItemsToUpdate){
            //     Id assetId = (Id) confItem.NE__AssetItemEnterpriseId__c;
            //     if(confItem.NE__AssetItemEnterpriseId__c != null &&  assetId.getSObjectType().getDescribe().getName() == 'Asset'){
            //         Asset singleAsset = new Asset(Id = confItem.NE__AssetItemEnterpriseId__c, OB_MerchantTakeover__c = false);
            //         if(confItem.NE__Action__c == 'Add' || confItem.NE__Action__c == 'Change' || confItem.NE__Action__c == 'None'){
            //             singleAsset.NE__Action__c = 'None';
            //             singleAsset.NE__Status__c = 'Active';
            //             assetList.add(singleAsset);
            //         }else if(confItem.NE__Action__c == 'Remove'){
            //             singleAsset.NE__Action__c = 'None';
            //             singleAsset.NE__Status__c = 'Disconnected';
            //             assetList.add(singleAsset);
            //         }
            //     }
            // }

            // system.debug('assetList. ' + assetList.size());

            // if(!assetList.isEmpty()){
            //             update assetList;
            // }
            List<Asset> remainingAssets = [SELECT 
                                                Id,
                                                NE__AssetItemEnterpriseId__c,
                                                NE__Parent_Order_Item__c
                                                FROM Asset 
                                                WHERE NE__Order_Config__c =: orderId 
                                                AND NE__Status__c ='Pending' LIMIT 10];
            if(remainingAssets.size()>1){//Simone Misani 13/12/2019 
                System.enqueueJob(new OB_UpdateAssetStatus(this.orderId,this.mainProcessStatus,this.bundleId));
                return;
            }

            updateItems(assets.keyset(), this.orderid, null );//Simone Misani 13/12/2019 


            String IN_ATTESA     			= OB_UtilityConstants.INATTESA;
            String CONFERMATO     			= OB_UtilityConstants.CONFERMATO;
            List<OB_LogRequest__c>     listLogRequests     	 = [SELECT Id
                                                                FROM OB_LogRequest__c
                                                                WHERE OB_OrderId__c = :orderId
                                                                AND OB_Status__c  = :IN_ATTESA];

            OB_LogRequest__c         contextLogRequest     		= new OB_LogRequest__c();

            if(!listLogRequests.isEmpty()) {
                contextLogRequest                 = listLogRequests.get(0);
                contextLogRequest.OB_Status__c     = CONFERMATO;
                update contextLogRequest;
            }
            //  start ntonio.vatrano perf-34 10/12/2019
            NE__Order__c ord = new NE__Order__c(id = orderId, NE__OrderStatus__c = 'Completed',NE__ConfigurationStatus__c = 'Valid');
			update ord;
            //  end antonio.vatrano perf-34 10/12/2019

        }
        catch(Exception e){
            System.debug('Exception in OB_UtilityCallingServices.createAsset. Error message: ' + e.getMessage() + ' at line ' + e.getLineNumber());
            Plc_LogHelper.LogStructure ls = new Plc_LogHelper.LogStructure();
            ls.httpMethod = OB_UtilityConstants.METHOD_POST; //francesca.ribezzi 24/10/19 - setting a method because Plc_RequestType__c is a restricted picklist
            ls.requestUri = '';
            ls.requestHeader ='';
            ls.requestHeader = '';
            ls.requestBody='';
            ls.responseBody  = 'Exception in OB_UtilityCallingServices.createAsset. Error message: ' + e.getMessage() + ' at line '+ e.getLineNumber()+ '      Configuration Id: '+ orderId;
            ls.responseStatus  = 'E';
            ls.responseMessage  = '';
            ls.responseStackTrace  = '';
            Id plcId = Plc_LogHelper.logCall(ls); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
            //francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog:
            OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, orderId);   
        }
        //END antonio.vatrano 26/08/19
    }
}