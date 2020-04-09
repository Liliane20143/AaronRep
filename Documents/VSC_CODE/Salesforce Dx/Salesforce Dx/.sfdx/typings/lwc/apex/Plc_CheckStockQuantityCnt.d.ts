declare module "@salesforce/apex/Plc_CheckStockQuantityCnt.filterModelLookup" {
  export default function filterModelLookup(param: {warehouseId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_CheckStockQuantityCnt.getRelativeProductStock" {
  export default function getRelativeProductStock(param: {warehouseId: any, extCatId: any, solutionName: any, logistickDivisionId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_CheckStockQuantityCnt.getRelativeWarhouseAndModel" {
  export default function getRelativeWarhouseAndModel(param: {prodstockId: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_CheckStockQuantityCnt.getData1" {
  export default function getData1(param: {warehouseId: any, externalCatalogItemId: any, logistickDivision: any, solutionName: any, inputDate: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_CheckStockQuantityCnt.getPicklistOptions" {
  export default function getPicklistOptions(param: {fieldName: any, sObjectName: any}): Promise<any>;
}
