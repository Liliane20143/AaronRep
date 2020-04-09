@isTest
public class OB_ConfigurePOS_CC_Test {
	
    @isTest
    public static void getOldAssetServer() {
        
        // RETURN METHOD : 
        List<NE__OrderItem__c> returningMethodItems = new List<NE__OrderItem__c>();
        
        // RECORD TYPE ID:
        	// PRODUCT RECORD TYPE:
        	Id recTypeTerminaliProduct = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        	
        	// ITEM RECORD TYPE 
        	Id recTypeTerminaliItem = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        
		
        // PRODUCT
        NE__Product__c product = OB_TestDataFactory.getProduct();
        product.OB_Codice_sfdc__c = OB_UtilityCOnstants.M_POS;
        product.RecordTypeId = recTypeTerminaliProduct;
        insert product;
        
        // ASSET
        Asset asset = OB_TestDataFactory.getAsset();
        asset.NE__ProdId__c = product.Id;
        asset.NE__Status__c = 'Test';
        asset.NE__StartDate__c = System.today();
        asset.NE__Status__c =   'Active'; 
        insert asset;
        List<Asset> assetList = new List<Asset>();
        for(Integer i = 0; i< 10 ; i++) {	
            Asset childAsset = OB_TestDataFactory.getAsset();	
            childAsset.NE__ProdId__c = product.Id;
            childAsset.NE__Status__c = 'Test';
            childAsset.NE__StartDate__c = System.today();
            childAsset.NE__Status__c =   'Active'; 
            childAsset.NE__Bundle_Configuration__c = asset.Id; 
            assetList.add(childAsset);    
        }
        
        insert assetList;

        Test.startTest();
            OB_ConfigurePOS_CC.getOldAssetServer(asset.id); 
        Test.stopTest();

    }
    
    /*
		@Author : 	Morittu Andrea
		@Date	: 	18-Jul
		@Task	:	Covering Catalog Classes (Name of Branch)
	*/
    @isTest
    public static void getShowPosReplacement_Test() {
        // RETURN METHOD : 
        List<String> idList = new  List<String>();
        
        // MAIN ORDER HEADER
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader();
        insert orderHeader;
        
        // CONFIGURATION
		NE__Order__c order = OB_TestDataFactory.getOrder(orderHeader);
        insert order;
		
        // PRODUCT
        NE__Product__c product = OB_TestDataFactory.getProduct();
        product.OB_Codice_sfdc__c = OB_UtilityCOnstants.M_POS;
        insert product;
        
		// CONFIGURATIONITEMS
        List<NE__OrderItem__c> orderItemList = new List<NE__OrderItem__c>();
		for(Integer i = 0; i<10 ; i++) {
            NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem(order.Id);
            orderItem.NE__ProdId__c = product.Id;
            if(Math.mod(2, 2) == 0) {
				orderItem.NE__Action__c = 'Add';
            } else {
                orderItem.NE__Action__c = 'Remove';
            }
            orderItemList.add(orderItem);
        }
        insert orderItemList;
        // ADD EVERY ID INSIDE A LIST (RETURNING METHOD LIST)
        for(NE__OrderItem__c orderItem : orderItemList) {
            idList.add(orderItem.id);
        }
		
        // RUN TEST!
        Test.startTest();
        	OB_ConfigurePOS_CC.getShowPosReplacement(idList);
        Test.stopTest(); 
    }
}