declare module "@salesforce/apex/Plc_StockSerialsImportUploadCnt.retrieveTranslationMap" {
  export default function retrieveTranslationMap(): Promise<any>;
}
declare module "@salesforce/apex/Plc_StockSerialsImportUploadCnt.retrieveUpdateReport" {
  export default function retrieveUpdateReport(): Promise<any>;
}
declare module "@salesforce/apex/Plc_StockSerialsImportUploadCnt.retrievePropertiesMap" {
  export default function retrievePropertiesMap(param: {warehouseId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StockSerialsImportUploadCnt.parseCsvInputfile" {
  export default function parseCsvInputfile(param: {csvAsString: any, warehouseId: any, columnDelimiter: any, isEditMode: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StockSerialsImportUploadCnt.saveCsvData" {
  export default function saveCsvData(param: {csvAsList: any, modelSkuWarehouseToProductStockUntypedMap: any, productStockWrpToInsertString: any, skuToManufacturerAlias: any, warehouseId: any, rowIndexToExistingIdMap: any, warehouseAliasToWarehouseMap: any, columnDelimiter: any, isEditMode: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_StockSerialsImportUploadCnt.retrieveAvailableWarehouses" {
  export default function retrieveAvailableWarehouses(param: {searchKey: any}): Promise<any>;
}
