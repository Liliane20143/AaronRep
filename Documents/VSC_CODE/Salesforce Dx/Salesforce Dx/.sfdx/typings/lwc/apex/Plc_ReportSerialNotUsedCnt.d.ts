declare module "@salesforce/apex/Plc_ReportSerialNotUsedCnt.initialize" {
  export default function initialize(): Promise<any>;
}
declare module "@salesforce/apex/Plc_ReportSerialNotUsedCnt.applyFilter" {
  export default function applyFilter(param: {startDate: any, endDate: any, status: any, dealerChildId: any, dealerParentId: any, warehouseId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ReportSerialNotUsedCnt.exportCSV" {
  export default function exportCSV(param: {stockSerialWrapperList: any, separatorCSV: any}): Promise<any>;
}
