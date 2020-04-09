declare module "@salesforce/apex/OB_OfferCatalogBankCABController.getUserCABandABIServer" {
  export default function getUserCABandABIServer(param: {userId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_OfferCatalogBankCABController.getOffersByABIandCABServer" {
  export default function getOffersByABIandCABServer(param: {abi: any, cab: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_OfferCatalogBankCABController.getBundleOffers" {
  export default function getBundleOffers(): Promise<any>;
}
declare module "@salesforce/apex/OB_OfferCatalogBankCABController.getBundleOffersOrderBy" {
  export default function getBundleOffersOrderBy(param: {selectedValue: any, bundleOffers: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_OfferCatalogBankCABController.searchForOffer" {
  export default function searchForOffer(param: {searchText: any, selectedABI: any, selectedCAB: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_OfferCatalogBankCABController.cloneParametersAndRows" {
  export default function cloneParametersAndRows(param: {activeOffers: any, selectedABI: any, selectedCAB: any, listToUpdate: any}): Promise<any>;
}
