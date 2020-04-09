declare module "@salesforce/apex/Plc_WorkOrderHandlingCnt.retrieveTranslationMap" {
  export default function retrieveTranslationMap(): Promise<any>;
}
declare module "@salesforce/apex/Plc_WorkOrderHandlingCnt.retrievePropertiesMap" {
  export default function retrievePropertiesMap(param: {workOrderId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_WorkOrderHandlingCnt.retrieveAvailableModels" {
  export default function retrieveAvailableModels(param: {warehouseAlias: any, searchKey: any, category: any, consumedSerials: any, productId: any, consumedExternalCatalogItems: any, subItemSolutionId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_WorkOrderHandlingCnt.saveItems" {
  export default function saveItems(param: {wo: any, woliAsString: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_WorkOrderHandlingCnt.saveAccessories" {
  export default function saveAccessories(param: {wo: any, woliAccessoryToInsertList: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_WorkOrderHandlingCnt.retrieveAvailableAssets" {
  export default function retrieveAvailableAssets(param: {servicePointLegacyId: any, searchKey: any, consumedAssets: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_WorkOrderHandlingCnt.retrieveChildStoreProductAssets" {
  export default function retrieveChildStoreProductAssets(param: {assetId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_WorkOrderHandlingCnt.manageSLI" {
  export default function manageSLI(param: {shipmentLineItemId: any, operation: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_WorkOrderHandlingCnt.changeSerialToWithdrawn" {
  export default function changeSerialToWithdrawn(param: {stockSerialId: any, contactId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_WorkOrderHandlingCnt.retrieveWithdrawingTechnician" {
  export default function retrieveWithdrawingTechnician(param: {stockSerialId: any}): Promise<any>;
}
