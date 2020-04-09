declare module "@salesforce/apex/Plc_GoodsReceivingCnt.initData" {
  export default function initData(param: {objectId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_GoodsReceivingCnt.fetchDataForTables" {
  export default function fetchDataForTables(param: {shipmentStockSerials: any, shipmentProductStocks: any, availableGoodsFromWizard: any, acceptedGoodsFromWizard: any, rejectedGoodsFromWizard: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_GoodsReceivingCnt.saveGoods" {
  export default function saveGoods(param: {serializedAvailableGoods: any, serializedAcceptedGoods: any, serializedRejectedGoods: any, sourceRecordId: any}): Promise<any>;
}
