declare module "@salesforce/apex/OB_ConfigurazioniTableNexiController.getConfigurazioni" {
  export default function getConfigurazioni(param: {pageSize: any, pageNumber: any, offerta: any, abi: any, orderName: any, sortDirection: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableNexiController.searchConfigurazioniServer" {
  export default function searchConfigurazioniServer(param: {pageSize: any, pageNumber: any, nameProduct: any, fromDate: any, toDate: any, offerta: any, listino: any, schemaPrezzi: any, modello: any, abi: any, orderName: any, sortDirection: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableNexiController.creaConfigurazioneServer" {
  export default function creaConfigurazioneServer(param: {pageSize: any, pageNumber: any, name: any, fromDate: any, toDate: any, offerta: any, listino: any, schemaPrezzi: any, modello: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableNexiController.deleteconfigurazioneServer" {
  export default function deleteconfigurazioneServer(param: {pageSize: any, pageNumber: any, configurazioneToDelete: any, offerta: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableNexiController.searchForProducts" {
  export default function searchForProducts(param: {searchText: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableNexiController.listProducts" {
  export default function listProducts(): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableNexiController.searchForCatalogs" {
  export default function searchForCatalogs(param: {searchText: any}): Promise<any>;
}
