declare module "@salesforce/apex/OB_CatalogController.callAssetToOrderItemServer" {
  export default function callAssetToOrderItemServer(param: {orderId: any, offerAssetId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.createAllProductServer" {
  export default function createAllProductServer(param: {complexProductList: any, bundleId: any, configuration: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.getConfigurationItemServer" {
  export default function getConfigurationItemServer(param: {configuration: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.removeItemServer" {
  export default function removeItemServer(param: {itemList: any, confId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.updateAttributesServer" {
  export default function updateAttributesServer(param: {attributesList: any, confId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.updateItemsServer" {
  export default function updateItemsServer(param: {itemList: any, confId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.insertChildProductsServer" {
  export default function insertChildProductsServer(param: {productList: any, configuration: any, bundleId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.createBundleServer" {
  export default function createBundleServer(param: {bundle: any, configuration: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.createComplexProductServer" {
  export default function createComplexProductServer(param: {complexProduct: any, bundleId: any, configuration: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.setConfigurationToApprove" {
  export default function setConfigurationToApprove(param: {idOrder: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.saveAndExitBit2FlowCaller" {
  export default function saveAndExitBit2FlowCaller(param: {dataMap: any, wizardWrapperString: any, isCommunity: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.updateConfigVariation" {
  export default function updateConfigVariation(param: {confId: any, variation: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.launchMaintenanceWizard" {
  export default function launchMaintenanceWizard(param: {wizardName: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.createLogRequestServer" {
  export default function createLogRequestServer(param: {merchantId: any, servicePointId: any, confId: any, abi: any, cab: any, subProcess: any, checkBIO: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.checkForAcquiringChangesServer" {
  export default function checkForAcquiringChangesServer(param: {confId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.retrieveUserLicense" {
  export default function retrieveUserLicense(): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.callCancelOrder" {
  export default function callCancelOrder(param: {orderId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.getShowQuote" {
  export default function getShowQuote(): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.updatePrivacyServicePoint" {
  export default function updatePrivacyServicePoint(param: {servicePointId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.updateAssetInMerchantTakeOver" {
  export default function updateAssetInMerchantTakeOver(param: {orderId: any, offerAssetId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogController.getOrderItemId" {
  export default function getOrderItemId(param: {itemId: any}): Promise<any>;
}
