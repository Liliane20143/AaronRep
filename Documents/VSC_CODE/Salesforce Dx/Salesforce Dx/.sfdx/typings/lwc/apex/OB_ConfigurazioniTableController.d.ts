declare module "@salesforce/apex/OB_ConfigurazioniTableController.getConfigurazioni" {
  export default function getConfigurazioni(param: {pageSize: any, pageNumber: any, offerta: any, orderName: any, sortDirection: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableController.listProducts" {
  export default function listProducts(): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableController.searchConfigurazioniServer" {
  export default function searchConfigurazioniServer(param: {pageSize: any, pageNumber: any, nameProduct: any, fromDate: any, toDate: any, offerta: any, listino: any, schemaPrezzi: any, modello: any, orderName: any, sortDirection: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableController.creaConfigurazioneServer" {
  export default function creaConfigurazioneServer(param: {pageSize: any, pageNumber: any, name: any, fromDate: any, toDate: any, offerta: any, listino: any, schemaPrezzi: any, modello: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableController.deleteconfigurazioneServer" {
  export default function deleteconfigurazioneServer(param: {pageSize: any, pageNumber: any, configurazioneToDelete: any, offerta: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableController.searchForProducts" {
  export default function searchForProducts(param: {searchText: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableController.searchForCatalogs" {
  export default function searchForCatalogs(param: {searchText: any}): Promise<any>;
}
