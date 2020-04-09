declare module "@salesforce/apex/OB_ConfigurazioniTableBankController.getConfigurazioni" {
  export default function getConfigurazioni(param: {pageSize: any, pageNumber: any, offerta: any, abi: any, orderName: any, sortDirection: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableBankController.searchConfigurazioniServer" {
  export default function searchConfigurazioniServer(param: {pageSize: any, pageNumber: any, name: any, fromDate: any, toDate: any, offerta: any, listino: any, schemaPrezzi: any, modello: any, abi: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableBankController.creaConfigurazioneServer" {
  export default function creaConfigurazioneServer(param: {pageSize: any, pageNumber: any, name: any, fromDate: any, toDate: any, offerta: any, listino: any, schemaPrezzi: any, modello: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableBankController.deleteconfigurazioneServer" {
  export default function deleteconfigurazioneServer(param: {pageSize: any, pageNumber: any, configurazioneToDelete: any, offerta: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableBankController.searchForProducts" {
  export default function searchForProducts(param: {searchText: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_ConfigurazioniTableBankController.searchForCatalogs" {
  export default function searchForCatalogs(param: {searchText: any}): Promise<any>;
}
