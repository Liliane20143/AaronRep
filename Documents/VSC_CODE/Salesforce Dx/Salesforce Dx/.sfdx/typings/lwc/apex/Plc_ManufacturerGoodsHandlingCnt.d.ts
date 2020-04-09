declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.initialize" {
  export default function initialize(param: {distributionListId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.getDistributionListName" {
  export default function getDistributionListName(param: {distributionListId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.getDliIdsListByDistributionListId" {
  export default function getDliIdsListByDistributionListId(param: {distributionListId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.getTransferDetailsList" {
  export default function getTransferDetailsList(): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.getOriginDealer" {
  export default function getOriginDealer(param: {dliIdList: any, filter: any, transferDetailCode: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.getOriginWarehouse" {
  export default function getOriginWarehouse(param: {dliIdList: any, originDealerId: any, filter: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.getDestinationDealer" {
  export default function getDestinationDealer(param: {dliIdList: any, originWarehouseId: any, filter: any, transferDetailCode: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.getDestinationWarehouse" {
  export default function getDestinationWarehouse(param: {dliIdList: any, destinationDealerId: any, filter: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.getDliWrapper" {
  export default function getDliWrapper(param: {originDealerId: any, originWarehouseId: any, destinationDealerId: any, destinationWarehouseId: any, distributionListId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.createSerialWrapperFromResults" {
  export default function createSerialWrapperFromResults(param: {resultsList: any, modelList: any, createFromCSV: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.save" {
  export default function save(param: {transferDetailSelected: any, originWarehouseSelected: any, destinationWarehouseSelected: any, originDealerSelected: any, destinationDealerSelected: any, objQuantityList: any, objSerialList: any, note: any, distributionListId: any, stockOrderId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.save_new" {
  export default function save_new(param: {transferDetailSelected: any, originWarehouseSelected: any, destinationWarehouseSelected: any, originDealerSelected: any, destinationDealerSelected: any, objQuantityList: any, objSerialList: any, note: any, distributionListId: any, stockOrderId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.loadDataForEdit" {
  export default function loadDataForEdit(param: {stockOrderId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_ManufacturerGoodsHandlingCnt.feedWrappers" {
  export default function feedWrappers(param: {stockOrderId: any, objQuantityList: any, objSerialList: any}): Promise<any>;
}
