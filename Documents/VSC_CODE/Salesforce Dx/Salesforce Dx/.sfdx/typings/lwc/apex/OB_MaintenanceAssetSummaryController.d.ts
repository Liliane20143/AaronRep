declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.callAssetToOrderItemServer" {
  export default function callAssetToOrderItemServer(param: {orderId: any, offerAssetId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.callAssetToOrderServer" {
  export default function callAssetToOrderServer(param: {isReplacement: any, offerAssetId: any, isEditCommissionModel: any, isPricing: any, userABI: any, userCAB: any, accId: any, isTerminate: any, isSkipToIntBE: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.getCommissionServer" {
  export default function getCommissionServer(param: {offerAssetId: any, offerName: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.share" {
  export default function share(param: {bankAccountMap: any, orh: any, sp: any, acc: any, isCommunity: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.createLogRequest" {
  export default function createLogRequest(param: {merchantId: any, servicePointId: any, confId: any, abi: any, cab: any, subProcess: any, checkBIO: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.launchMaintenanceWizard" {
  export default function launchMaintenanceWizard(param: {wizardName: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.getMerchantTakeoverFromAsset" {
  export default function getMerchantTakeoverFromAsset(param: {offerAssetId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.updateABIandCABInsideAssetObj" {
  export default function updateABIandCABInsideAssetObj(param: {offerAssetId: any, selectedCAB: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.getMCCdescriptionByLOV" {
  export default function getMCCdescriptionByLOV(): Promise<any>;
}
declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.getCABandABIfromOrder" {
  export default function getCABandABIfromOrder(param: {orderId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_MaintenanceAssetSummaryController.retrieveLineItemsAndItemAttributes" {
  export default function retrieveLineItemsAndItemAttributes(param: {offerAssetId: any, orderId: any}): Promise<any>;
}
