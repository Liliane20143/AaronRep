declare module "@salesforce/apex/Plc_CreateMockWorkOrderCnt.retrieveTranslationMap" {
  export default function retrieveTranslationMap(): Promise<any>;
}
declare module "@salesforce/apex/Plc_CreateMockWorkOrderCnt.retrievePropertiesMap" {
  export default function retrievePropertiesMap(): Promise<any>;
}
declare module "@salesforce/apex/Plc_CreateMockWorkOrderCnt.retrieveAvailableSerials" {
  export default function retrieveAvailableSerials(param: {warehouseAlias: any, searchKey: any, searchLimit: any, consumedSerials: any, statusList: any, termId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_CreateMockWorkOrderCnt.retrieveEligibleOperations" {
  export default function retrieveEligibleOperations(param: {woTipology: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_CreateMockWorkOrderCnt.createWorkOrder" {
  export default function createWorkOrder(param: {workOrderWrp: any, tipology: any, selectedWarehouse: any, woliAsString: any, serialIdList: any}): Promise<any>;
}
