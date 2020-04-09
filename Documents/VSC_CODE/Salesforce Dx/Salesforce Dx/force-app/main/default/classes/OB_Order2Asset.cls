/*******************************************************************************
Purpose:  class to generate asset from order item - performance
Parameters: - orderId, mainProcessStatus
Returns: 

History
--------
VERSION     AUTHOR                  DATE            DETAIL         Description
1.0         enrico.purificato       19/11/2019      Created        to make order2Assetscale

********************************************************************************/
global class OB_Order2Asset implements Database.Batchable<sobject>
{

    private String orderId;
    private String mainProcessStatus;
    private Set<Id> rootItemsSet = new Set<Id>() ;

    public OB_Order2Asset (String orderId, String mainProcessStatus)
    {
        this.orderId = orderId;
        this.mainProcessStatus = mainProcessStatus;
        for(NE__OrderItem__c oi:[SELECT id,
								 NE__Root_Order_Item__c, 
								 NE__Bundle_Configuration__c  
								 FROM NE__OrderItem__c where NE__OrderId__c = :orderId
								 AND NE__Root_Order_Item__c = null
								 AND NE__Bundle_Configuration__c != null])
        {
            rootItemsSet.add(oi.Id);
        }
    }
	
	global Database.Querylocator start (Database.BatchableContext BC) 
    {
      return Database.getQueryLocator('SELECT id,NE__Root_Order_Item__c, NE__Bundle_Configuration__c FROM NE__OrderItem__c WHERE NE__OrderId__c = :orderId AND NE__Root_Order_Item__c = null AND NE__Bundle_Configuration__c = null LIMIT 1');
    }

    global void execute (Database.BatchableContext BC, List<sobject> scope) 
    {
        NE__OrderItem__c bundle = (NE__OrderItem__c)scope[0];

        map<String,String>  mapOfQuery      =   new map<String,String>();
        mapOfQuery.put('OrderItem2AssetItem','Id =: {!0}');

        List<String> placeHolderList    = new List<String>();
        placeHolderList.add(bundle.Id);
        
        NE.DataMap mp                       = new NE.DataMap();
        Map <String,String> result          = new map<String,String>();
        
        NE.DataMap.DataMapRequest  dReq     = new NE.DataMap.DataMapRequest();
        
        dReq.mapName                        = 'Order2StdAsset';
   
        dReq.listOfPlaceHolders                 = placeHolderList;
        dReq.mapOfCustomQueries                 = mapOfQuery;
        dReq.sourceId                           = this.orderId;
        dReq.updateActive                       = true;
    
        NE.DataMap.DataMapResponse dResp        = mp.callDataMap(dReq);

        if(dResp.ErrorCode == '0'){
            Asset offerAsset = [SELECT Id,NE__AssetItemEnterpriseId__c FROM Asset WHERE NE__Order_Config__c = :this.orderId LIMIT 1];
            NE__OrderItem__c bundleItem = new NE__OrderItem__c( Id = offerAsset.NE__AssetItemEnterpriseId__c , NE__AssetItemEnterpriseId__c = offerAsset.id);
            update bundleItem;
           
        }

    }

    global void finish(Database.BatchableContext BC) 
    {
        Asset offerAsset = [SELECT Id,NE__AssetItemEnterpriseId__c FROM Asset WHERE NE__Order_Config__c = :this.orderId LIMIT 1];
        if(offerAsset.NE__AssetItemEnterpriseId__c != offerAsset.Id )
        {
            offerAsset.NE__AssetItemEnterpriseId__c = offerAsset.Id;
            update offerAsset;
        }
        
        Database.executeBatch(new OB_RootItem2Asset(this.orderId,this.mainProcessStatus,rootItemsSet,offerAsset.Id));
    }
    
}