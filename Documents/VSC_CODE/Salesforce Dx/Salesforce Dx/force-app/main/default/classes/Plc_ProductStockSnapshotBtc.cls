/**
 * @author Emanuele Campese
 * @date Creation 14/03/2019
 * @description Plc_ProductStockSnapshotBtc - Batch 'Plc_ProductStockSnapshotBtc'.
 */
public with sharing class Plc_ProductStockSnapshotBtc extends Plc_MasterBatchable {
 	List<Plc_ProductStockSnapshot__c> productStockSnapshotToInsertList = new List<Plc_ProductStockSnapshot__c>();
	Double totalExecutionTime=0;
	List<String> fieldsToCheck;

	override public String getDynamicQuery() {
		String query='SELECT Id,IsDeleted,Name,RecordTypeId,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,LastViewedDate,LastReferencedDate,Bit2Shop__Warehouse_Id__c,Plc_ExternalReferencePeriod__c'+
		',Bit2Shop__ExternalId__c,Bit2Shop__External_Catalog_Item_Id__c,Bit2Shop__Inventory_ConfirmedQty__c,Bit2Shop__Inventory_LockedConfirmation__c,Bit2Shop__Inventory_PreviousQty__c,Bit2Shop__Inventory_QtyToJustify__c'+
		',Bit2Shop__Inventory_QtyUnjustified__c,Bit2Shop__Inventory_ToBeConfirmed__c,Bit2Shop__Inventory_TransactionExecuted__c,Bit2Shop__Inventory_TransactionFailed__c,Bit2Shop__Inventory_TransactionSubmitted__c'+
		',Bit2Shop__Product_Description__c,Bit2Shop__Product_SKU__c,Bit2Shop__Product_Sku_Den__c,Bit2Shop__Reserved_Qty__c,Bit2Shop__Inventory_Level__c,Bit2Shop__Period_Id__c,Plc_WithdrawnQty__c,Plc_ExternalReferenceExternalCatalogItem__c'+
		',Bit2Shop__Shipped_Qty__c,Bit2Shop__Stock_Media_Value__c,Bit2Shop__Stock_Qty__c,Bit2Shop__Stock_Value__c,Plc_Solution__c,Plc_ExternalCatalogItemName__c,Plc_PTSCode__c,Plc_Note__c,Plc_ExternalWarehouse__c'+
		',Plc_OrderedQty__c,Plc_ProductSku__c,Plc_ReservedQty__c,Plc_AvailableQty__c,Plc_Property__c,Plc_Manufacturer__c,Plc_OtherQty__c,Plc_Required_Serial__c,Plc_Alias__c,Plc_UsableQty__c';

		String queryCondition=' FROM Bit2Shop__Product_Stock__c';

		return query+queryCondition;
	}

	override public String getBatchName() {

		return Plc_ProductStockSnapshotBtc.class.getName();
	}

	public void execute(Database.BatchableContext batchableContext, List<Bit2Shop__Product_Stock__c> productStock)  {
						DateTime chunkTime = DateTime.now();

		for(Bit2Shop__Product_Stock__c productStockFromlist :productStock){
			if( (productStockFromlist.Plc_OrderedQty__c>0 || productStockFromlist.Bit2Shop__Stock_Qty__c>0) || (productStockFromlist.CreatedDate.format('y-MM-dd') != productStockFromlist.LastModifiedDate.format('y-MM-dd') ) ){
				Plc_ProductStockSnapshot__c newProductStockSnapshot = new Plc_ProductStockSnapshot__c();
				
				fieldsToCheck = new List<String>{'Plc_Alias__c','Plc_Warehouse__c','Plc_PtsCode__c', 'Plc_ExternalCatalogItem__c','Plc_Property__c', 'Plc_Solution__c', 'Plc_InventoryLevel__c','Plc_Period__c', 'Plc_AvailableQty__c', 'Plc_WithdrawnQty__c', 'Plc_UsableQty__c', 'Plc_ReservedQty__c', 'Plc_OrderedQty__c', 'Plc_ShippedQty__c', 'Plc_StockQty__c', 'Plc_Note__c', 'Plc_ExternalWarehouse__c', 'Plc_ExternalReferenceCatalogItem__c','Plc_ExternalPeriod__c'};
				
				newProductStockSnapshot.Plc_Alias__c = productStockFromlist.Plc_Alias__c;
				newProductStockSnapshot.Plc_Warehouse__c = productStockFromlist.Bit2Shop__Warehouse_Id__c;
				newProductStockSnapshot.Plc_PtsCode__c = productStockFromlist.Plc_PTSCode__c;
				newProductStockSnapshot.Plc_ExternalCatalogItem__c = productStockFromlist.Bit2Shop__External_Catalog_Item_Id__c;
				newProductStockSnapshot.Plc_Property__c = productStockFromlist.Plc_Property__c;
				newProductStockSnapshot.Plc_Solution__c = productStockFromlist.Plc_Solution__c;
				newProductStockSnapshot.Plc_InventoryLevel__c = productStockFromlist.Bit2Shop__Inventory_Level__c;
				newProductStockSnapshot.Plc_Period__c = productStockFromlist.Bit2Shop__Period_Id__c;
				newProductStockSnapshot.Plc_AvailableQty__c = productStockFromlist.Plc_AvailableQty__c;
				newProductStockSnapshot.Plc_WithdrawnQty__c = productStockFromlist.Plc_WithdrawnQty__c;
				newProductStockSnapshot.Plc_UsableQty__c = productStockFromlist.Plc_UsableQty__c;
				newProductStockSnapshot.Plc_ReservedQty__c = productStockFromlist.Plc_ReservedQty__c;
				newProductStockSnapshot.Plc_OrderedQty__c = productStockFromlist.Plc_OrderedQty__c;
				newProductStockSnapshot.Plc_ShippedQty__c = productStockFromlist.Bit2Shop__Shipped_Qty__c;
				newProductStockSnapshot.Plc_StockQty__c = productStockFromlist.Bit2Shop__Stock_Qty__c;
				newProductStockSnapshot.Plc_Note__c = productStockFromlist.Plc_Note__c;
				newProductStockSnapshot.Plc_ExternalWarehouse__c = productStockFromlist.Plc_ExternalWarehouse__c;
				newProductStockSnapshot.Plc_ExternalReferenceCatalogItem__c = productStockFromlist.Plc_ExternalReferenceExternalCatalogItem__c;
				newProductStockSnapshot.Plc_ExternalPeriod__c = productStockFromlist.Plc_ExternalReferencePeriod__c;
				
				if(Limits.getHeapSize() < (Limits.getLimitHeapSize()*0.9 ) ){
					productStockSnapshotToInsertList.add(newProductStockSnapshot);
				}
				else{
					if(productStockSnapshotToInsertList.size()>0 ){
						
						String resultFound = Plc_Utils.checkCrudFieldPermission('Plc_ProductStockSnapshot__c', fieldsToCheck, 'upsert');
						if(resultFound != null){
							System.debug('Exception checkCrudFieldPermission');
							throw new Plc_Exception(resultFound);
						}

						upsert productStockSnapshotToInsertList;
						productStockSnapshotToInsertList.clear();
						productStockSnapshotToInsertList.add(newProductStockSnapshot);
					}
				}
			}
			
			
		}
				totalExecutionTime = totalExecutionTime + chunkTime.getTime();

	}
	public void finish(Database.BatchableContext batchableContext) {

		try{
			if(productStockSnapshotToInsertList.size()>0 ){
				upsert productStockSnapshotToInsertList;
			}
			Plc_LogHelper.logStructure log = new Plc_LogHelper.logStructure();
			Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_BatchClassName__c = :getBatchName() LIMIT 1];
			log.schedulerName=batchToRetrieve.Plc_SchedulerClassName__c;
			log.responseMessage='';
			log.responseStatus = 'S';
			log.executionTimeStep2 = totalExecutionTime;
			log.requestBody = 'Product Stock Snapshot inserted: ['+productStockSnapshotToInsertList.size()+']';
			log.recordType = 'Plc_Batch';
			Plc_LogHelper.logCall(log);
		}catch(Exception ex){
			Plc_LogHelper.logStructure logEx = new Plc_LogHelper.logStructure();
			Plc_BatchSettings__mdt batchToRetrieve = [SELECT Plc_BatchClassName__c,Plc_SchedulerClassName__c,Label  FROM Plc_BatchSettings__mdt WHERE Plc_BatchClassName__c = :getBatchName() LIMIT 1];
			logEx.schedulerName=batchToRetrieve.Plc_SchedulerClassName__c;
			logEx.responseMessage='';
			logEx.responseStatus = 'E';
			logEx.executionTimeStep2 = totalExecutionTime;logEx.requestBody = ex.getMessage();logEx.recordType = 'Plc_Batch';Plc_LogHelper.logCall(logEx);
		}
		

		

	}
}