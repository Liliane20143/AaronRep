declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.getRequests" {
  export default function getRequests(param: {oldData: any, newData: any, objectDataMap: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.saveRequest" {
  export default function saveRequest(param: {oldData: any, newData: any, flowData: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.retrieveServicePointData" {
  export default function retrieveServicePointData(param: {servicePointId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.retriveSchemaInformation" {
  export default function retriveSchemaInformation(param: {SObjectToRetrive: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.retrieveValueTypology" {
  export default function retrieveValueTypology(): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.retrievePuntiVenditaData" {
  export default function retrievePuntiVenditaData(param: {servicePointId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.retrieveLovMccL2" {
  export default function retrieveLovMccL2(): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.retrieveLovMccL3" {
  export default function retrieveLovMccL3(): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.checkCoherencyDate" {
  export default function checkCoherencyDate(param: {openingTime: any, endingTime: any, breakStartTime: any, breakEndTime: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.merchantAndAssetCheck" {
  export default function merchantAndAssetCheck(param: {accountId: any, mappingListJson: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.deleteLogRequest" {
  export default function deleteLogRequest(param: {logRequestId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.startApprovalProcess" {
  export default function startApprovalProcess(param: {logRequestId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.confirmUploadedDocumentsSetInAttesaStatus" {
  export default function confirmUploadedDocumentsSetInAttesaStatus(param: {inLogRequestId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditServicePoint_Ctr.saveDraft" {
  export default function saveDraft(param: {logId: any}): Promise<any>;
}
