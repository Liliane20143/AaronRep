declare module "@salesforce/apex/OB_CatalogDetailsController.getRowsByMatrixParameterId" {
  export default function getRowsByMatrixParameterId(param: {matrixParameter: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.calculateDate" {
  export default function calculateDate(param: {startDate: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.insertCloneRow" {
  export default function insertCloneRow(param: {rowParent: any, rowChildren: any, catalogItemsToClone: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.updateRows" {
  export default function updateRows(param: {rowList: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.getCatalogItemsByProductIdServer" {
  export default function getCatalogItemsByProductIdServer(param: {productName: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.fetchCatalogItemsByProductIdServer" {
  export default function fetchCatalogItemsByProductIdServer(param: {productName: any, prodIdList: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.getCommercialProducts" {
  export default function getCommercialProducts(param: {rows: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.insertNewRowsServer" {
  export default function insertNewRowsServer(param: {newRows: any, newRow: any, matrixParameterId: any, matrixParameter: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.getFamiliesForChildrenRowsServer" {
  export default function getFamiliesForChildrenRowsServer(param: {products: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.getFamiliesServer" {
  export default function getFamiliesServer(param: {productId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.retrieveAttributesFromFamilies" {
  export default function retrieveAttributesFromFamilies(param: {families: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.searchForProducts" {
  export default function searchForProducts(param: {searchText: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CatalogDetailsController.deleteSelectedRow" {
  export default function deleteSelectedRow(param: {listToDelete: any}): Promise<any>;
}
