declare module "@salesforce/apex/Plc_GoodsHandlingCnt.initComponent" {
  export default function initComponent(param: {dealerId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_GoodsHandlingCnt.selectOrigin" {
  export default function selectOrigin(param: {dealerId: any, origin: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_GoodsHandlingCnt.selectDestinationDealer" {
  export default function selectDestinationDealer(param: {filterDestinationDealer: any, tranferDetailId: any, originWarehouseId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_GoodsHandlingCnt.selectDestinationWarehouse" {
  export default function selectDestinationWarehouse(param: {filterDestinationWarehouse: any, dealerId: any, code: any, logisticDivision: any, property: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_GoodsHandlingCnt.save" {
  export default function save(param: {transferDetail: any, originWarehouse: any, destinationWarehouse: any, selectedProductSerial: any, selectedProductQuantity: any, note: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_GoodsHandlingCnt.loadData" {
  export default function loadData(param: {filterSerial: any, originWarehouseId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_GoodsHandlingCnt.retrieveAvailableDealers" {
  export default function retrieveAvailableDealers(param: {searchKey: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_GoodsHandlingCnt.retrieveTranslationMap" {
  export default function retrieveTranslationMap(): Promise<any>;
}
