declare module "@salesforce/apex/OB_ItemsToApprove_CC.getUserInformation" {
  export default function getUserInformation(): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.retrieveItemsToApprove" {
  export default function retrieveItemsToApprove(param: {contextABI: any, contextCAB: any, filterValue: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.retrieveConfigurationApproval" {
  export default function retrieveConfigurationApproval(param: {contextABI: any, contextCAB: any, filterValue: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.retrieveHistoricWizardData" {
  export default function retrieveHistoricWizardData(param: {configurations: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.changeOrderStatusServer" {
  export default function changeOrderStatusServer(param: {orderId: any, currentUserId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.changeJumpToStepHistoricAttachment" {
  export default function changeJumpToStepHistoricAttachment(param: {historicWizardId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.cancelPricingOperation" {
  export default function cancelPricingOperation(param: {orderId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.cancelOrderAndChildren" {
  export default function cancelOrderAndChildren(param: {orderId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.launchMaintenanceWizard" {
  export default function launchMaintenanceWizard(param: {wizardName: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.callResubmitBIO" {
  export default function callResubmitBIO(param: {confId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.setOrderStatusDraft" {
  export default function setOrderStatusDraft(param: {orderToUpdate: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.setOrderStatusDraftIncompleteOrder" {
  export default function setOrderStatusDraftIncompleteOrder(param: {orderToUpdate: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.getAccountInfo" {
  export default function getAccountInfo(param: {merchantId: any, contextABI: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ItemsToApprove_CC.retrieveComments" {
  export default function retrieveComments(param: {idOrderList: any}): Promise<any>;
}
