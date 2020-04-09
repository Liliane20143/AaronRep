declare module "@salesforce/apex/OB_ConfigurationDetailsBankController.getUserABIServer" {
  export default function getUserABIServer(param: {userId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsBankController.getRowsByMatrixParameterId" {
  export default function getRowsByMatrixParameterId(param: {matrixParameter: any, abi: any, offerName: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsBankController.calculateDate" {
  export default function calculateDate(param: {startDate: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsBankController.insertCloneRow" {
  export default function insertCloneRow(param: {rowParent: any, rowChildren: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsBankController.updateRows" {
  export default function updateRows(param: {rowList: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsBankController.insertNewRowServer" {
  export default function insertNewRowServer(param: {newRow: any, componente: any, matrixParameter: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurationDetailsBankController.deleteSelectedRow" {
  export default function deleteSelectedRow(param: {listToDelete: any}): Promise<any>;
}
