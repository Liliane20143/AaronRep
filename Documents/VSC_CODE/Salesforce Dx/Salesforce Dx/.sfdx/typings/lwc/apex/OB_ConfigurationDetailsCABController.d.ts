declare module "@salesforce/apex/OB_ConfigurationDetailsCABController.getUserABIServer" {
  export default function getUserABIServer(param: {userId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsCABController.getRowsByMatrixParameterId" {
  export default function getRowsByMatrixParameterId(param: {matrixParameter: any, abi: any, offerName: any, cab: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsCABController.calculateDate" {
  export default function calculateDate(param: {startDate: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsCABController.insertCloneRow" {
  export default function insertCloneRow(param: {rowParent: any, rowChildren: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsCABController.updateRows" {
  export default function updateRows(param: {rowList: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsCABController.insertNewRowServer" {
  export default function insertNewRowServer(param: {newRow: any, componente: any, matrixParameter: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsCABController.deleteSelectedRow" {
  export default function deleteSelectedRow(param: {listToDelete: any}): Promise<any>;
}
