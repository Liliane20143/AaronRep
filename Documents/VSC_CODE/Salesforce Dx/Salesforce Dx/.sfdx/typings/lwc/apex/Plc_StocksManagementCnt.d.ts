declare module "@salesforce/apex/Plc_StocksManagementCnt.initialize" {
  export default function initialize(param: {warehouseId: any, action: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StocksManagementCnt.getInitialStockSerialByStatus" {
  export default function getInitialStockSerialByStatus(param: {status: any, warehouseId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StocksManagementCnt.getTechnicianListByWarehouseId" {
  export default function getTechnicianListByWarehouseId(param: {warehouseId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StocksManagementCnt.createWrapperListFromResults" {
  export default function createWrapperListFromResults(param: {resultsList: any, warehouseId: any, tabFocused: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StocksManagementCnt.confirm" {
  export default function confirm(param: {availableSelectedSerialized: any, withdrawnSelectedSerialiazed: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StocksManagementCnt.retrieveAvailableWarehouses" {
  export default function retrieveAvailableWarehouses(param: {searchKey: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StocksManagementCnt.retrieveTranslationMap" {
  export default function retrieveTranslationMap(): Promise<any>;
}
