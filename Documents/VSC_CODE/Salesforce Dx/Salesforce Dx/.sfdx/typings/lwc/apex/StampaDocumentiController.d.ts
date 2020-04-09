declare module "@salesforce/apex/StampaDocumentiController.getProductDocumentsServer" {
  export default function getProductDocumentsServer(param: {orderId: any, orderHeaderId: any, mcc: any, ateco: any, legalForm: any, merchantId: any, abi: any, isCompanyDataModified: any}): Promise<any>;
}
declare module "@salesforce/apex/StampaDocumentiController.getProductDocumentsServer" {
  export default function getProductDocumentsServer(param: {orderId: any, orderHeaderId: any, mcc: any, ateco: any, legalForm: any, merchantId: any, abi: any, isCompanyDataModified: any, isSetupFromOp: any}): Promise<any>;
}
declare module "@salesforce/apex/StampaDocumentiController.getCommercialProductsServer" {
  export default function getCommercialProductsServer(): Promise<any>;
}
declare module "@salesforce/apex/StampaDocumentiController.updateDocReqTrue" {
  export default function updateDocReqTrue(param: {orderHeaderId: any, isToTriggered: any}): Promise<any>;
}
declare module "@salesforce/apex/StampaDocumentiController.retrieveSavedDocs" {
  export default function retrieveSavedDocs(param: {merchantId: any, servicePointId: any, orderId: any}): Promise<any>;
}
declare module "@salesforce/apex/StampaDocumentiController.deprecateDocs" {
  export default function deprecateDocs(param: {merchantId: any, servicePointId: any, orderId: any, contractsIdList: any}): Promise<any>;
}
declare module "@salesforce/apex/StampaDocumentiController.getTokenJWE" {
  export default function getTokenJWE(param: {documentName: any}): Promise<any>;
}
declare module "@salesforce/apex/StampaDocumentiController.deprecateContracts" {
  export default function deprecateContracts(param: {merchantId: any, servicePointId: any, orderId: any, contractsIdList: any}): Promise<any>;
}
