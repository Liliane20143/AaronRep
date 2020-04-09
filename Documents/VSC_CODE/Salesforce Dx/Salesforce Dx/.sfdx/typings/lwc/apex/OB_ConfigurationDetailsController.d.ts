declare module "@salesforce/apex/OB_ConfigurationDetailsController.getRowsByMatrixParameterId" {
  export default function getRowsByMatrixParameterId(param: {offerName: any, matrixParameter: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsController.calculateDate" {
  export default function calculateDate(param: {startDate: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsController.insertCloneRow" {
  export default function insertCloneRow(param: {rowParent: any, rowChildren: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsController.getCatalogItems" {
  export default function getCatalogItems(param: {searchText: any, itemHeader: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsController.updateRows" {
  export default function updateRows(param: {rowList: any, itemHeader: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsController.insertNewRowsServer" {
  export default function insertNewRowsServer(param: {newRows: any, newRow: any, matrixParameterId: any, matrixParameter: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsController.insertNewRowServer" {
  export default function insertNewRowServer(param: {newRow: any, componente: any, matrixParameter: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsController.getFamiliesServer" {
  export default function getFamiliesServer(param: {productId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsController.getFamiliesForChildrenRowsServer" {
  export default function getFamiliesForChildrenRowsServer(param: {products: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsController.retrieveAttributesFromFamilies" {
  export default function retrieveAttributesFromFamilies(param: {families: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsController.deleteSelectedRow" {
  export default function deleteSelectedRow(param: {listToDelete: any}): Promise<any>;
}
