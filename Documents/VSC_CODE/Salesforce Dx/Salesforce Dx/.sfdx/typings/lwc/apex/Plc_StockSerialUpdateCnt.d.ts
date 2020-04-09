declare module "@salesforce/apex/Plc_StockSerialUpdateCnt.retrieveTranslationMap" {
  export default function retrieveTranslationMap(): Promise<any>;
}
declare module "@salesforce/apex/Plc_StockSerialUpdateCnt.retrievePropertiesMap" {
  export default function retrievePropertiesMap(param: {stockSerialId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StockSerialUpdateCnt.updateStockSerial" {
  export default function updateStockSerial(param: {stockSerial: any, newWarehouseId: any, newModelId: any, newModelName: any, newStatus: any, newStatus2: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StockSerialUpdateCnt.retrieveAvailableProductStock" {
  export default function retrieveAvailableProductStock(param: {warehouseId: any, modelId: any}): Promise<any>;
}
