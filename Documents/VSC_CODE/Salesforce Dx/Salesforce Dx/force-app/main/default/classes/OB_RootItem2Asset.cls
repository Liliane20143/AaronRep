/*******************************************************************************
Purpose:  class to generate asset from root order item - performance
Parameters: - orderId, mainProcessStatus
Returns: 

History
--------
VERSION     AUTHOR                  DATE            DETAIL         Description
1.0         enrico.purificato       19/11/2019      Created        to make order2Assetscale

********************************************************************************/
global class OB_RootItem2Asset implements Database.Batchable<sobject>
{

    private Id rootId;
	private String orderId;
    private String bundleId;
    private String mainProcessStatus;
    private Set<Id> rootItemsSet = new Set<Id>() ;

    public OB_RootItem2Asset (String orderId, String mainProcessStatus,Set<Id> rootItemsSet,String bundleId)
    {
        this.rootId = (new list<Id>(rootItemsSet)[0]);
        this.bundleId = bundleId;
		if(rootItemsSet.remove(this.rootId))
		{
			this.rootItemsSet = rootItemsSet;
		}
		this.orderId = orderId;
        this.mainProcessStatus = mainProcessStatus;
    }
	
	global Database.Querylocator start (Database.BatchableContext BC) 
    {
      return Database.getQueryLocator('SELECT id,NE__Root_Order_Item__c, NE__Bundle_Configuration__c FROM NE__OrderItem__c WHERE Id = :rootId');
    }

    global void execute (Database.BatchableContext BC, List<sobject> scope) 
    {

        map<String,String>  mapOfQuery      =   new map<String,String>();
        mapOfQuery.put('OrderItem2AssetItem','Id =: {!0} OR NE__Root_Order_Item__c =: {!1}');

        List<String> placeHolderList    = new List<String>();
        placeHolderList.add(rootId);
		placeHolderList.add(rootId);
        
        NE.DataMap mp                       = new NE.DataMap();
        Map <String,String> result          = new map<String,String>();
        
        NE.DataMap.DataMapRequest  dReq     = new NE.DataMap.DataMapRequest();
        
        dReq.mapName                        = 'Order2StdAsset';
   
        dReq.listOfPlaceHolders                 = placeHolderList;
        dReq.mapOfCustomQueries                 = mapOfQuery;
        dReq.sourceId                           = this.orderId;
        dReq.updateActive                       = true;
    
        NE.DataMap.DataMapResponse dResp        = mp.callDataMap(dReq);

    }

    global void finish(Database.BatchableContext BC) 
    {
    if(rootItemsSet.size()>0)
    {
        Database.executeBatch(new OB_RootItem2Asset(this.orderId,this.mainProcessStatus,this.rootItemsSet,this.bundleId));
    }else{
        System.enqueueJob(new OB_UpdateAssetStatus(this.orderId,this.mainProcessStatus,this.bundleId));
    }
    }
    
}