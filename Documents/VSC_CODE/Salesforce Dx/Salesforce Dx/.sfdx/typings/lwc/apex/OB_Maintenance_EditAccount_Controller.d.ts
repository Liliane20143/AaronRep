declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.getRequests" {
  export default function getRequests(param: {oldData: any, newData: any, objectDataMap: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.saveRequest" {
  export default function saveRequest(param: {oldData: any, newData: any, objectDataMap: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.saveRequestExecutor" {
  export default function saveRequestExecutor(param: {oldData: any, newData: any, isNewContact: any, objectDataMapInput: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.getCompanyLinkTypes" {
  export default function getCompanyLinkTypes(): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.getGenders" {
  export default function getGenders(): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.retriveSchemaInformation" {
  export default function retriveSchemaInformation(param: {SObjectToRetrive: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.mandatoryFieldsCheck" {
  export default function mandatoryFieldsCheck(param: {objectDataMapInput: any, data: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.checkExistLogRequest" {
  export default function checkExistLogRequest(param: {AccountId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.saveDraft" {
  export default function saveDraft(param: {inLogRequestId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.cancelLogRequest" {
  export default function cancelLogRequest(param: {inNewLogRequests: any, inChangedLogRequests: any, inDeletedLogRequests: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.startApprovalProcess" {
  export default function startApprovalProcess(param: {inLogRequestId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.startApprovalProcess" {
  export default function startApprovalProcess(param: {inLogRequestId: any, inIsInsert: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.createLogRequest" {
  export default function createLogRequest(param: {inOldContacts: any, inNewContacts: any, inAccountId: any, inIsEditOrUpdate: any, inIsPep: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.getInitDataWrapper" {
  export default function getInitDataWrapper(param: {inAccountId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.callSerializeAnagrafica" {
  export default function callSerializeAnagrafica(param: {logRequestId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.confirmDocs" {
  export default function confirmDocs(param: {logId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.retrieveExternalSourceMapping" {
  export default function retrieveExternalSourceMapping(param: {merchantId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.getNewESMList" {
  export default function getNewESMList(param: {newReportTypeValue: any, oldESMList: any, changedESMlist: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.getEmployeesNumber" {
  export default function getEmployeesNumber(): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.startApprovalProcessForSaeAteco" {
  export default function startApprovalProcessForSaeAteco(param: {inLogRequestId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.updateChangedSaeAtecoLogRequestStatusToInAttesa" {
  export default function updateChangedSaeAtecoLogRequestStatusToInAttesa(param: {inLogRequestId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_EditAccount_Controller.checkExistance" {
  export default function checkExistance(param: {oldData: any, newData: any}): Promise<any>;
}
