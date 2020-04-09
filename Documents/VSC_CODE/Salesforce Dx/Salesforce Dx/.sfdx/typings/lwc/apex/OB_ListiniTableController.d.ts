declare module "@salesforce/apex/OB_ListiniTableController.getListini" {
  export default function getListini(param: {pageSize: any, pageNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ListiniTableController.searchListiniServer" {
  export default function searchListiniServer(param: {pageSize: any, pageNumber: any, name: any, fromDate: any, toDate: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ListiniTableController.creaListinoServer" {
  export default function creaListinoServer(param: {pageSize: any, pageNumber: any, name: any, fromDate: any, toDate: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ListiniTableController.deleteListinoServer" {
  export default function deleteListinoServer(param: {pageSize: any, pageNumber: any, listinoToDelete: any}): Promise<any>;
}
