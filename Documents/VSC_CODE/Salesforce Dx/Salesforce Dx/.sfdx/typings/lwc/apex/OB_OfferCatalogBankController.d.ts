declare module "@salesforce/apex/OB_OfferCatalogBankController.getUserCABandABIServer" {
  export default function getUserCABandABIServer(param: {userId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_OfferCatalogBankController.getOffersByABIServer" {
  export default function getOffersByABIServer(param: {abi: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_OfferCatalogBankController.getBundleOffers" {
  export default function getBundleOffers(): Promise<any>;
}
declare module "@salesforce/apex/OB_OfferCatalogBankController.getBundleOffersOrderBy" {
  export default function getBundleOffersOrderBy(param: {selectedValue: any, bundleOffers: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_OfferCatalogBankController.searchForOffer" {
  export default function searchForOffer(param: {searchText: any, selectedABI: any, selectedCAB: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_OfferCatalogBankController.cloneParametersAndRows" {
  export default function cloneParametersAndRows(param: {activeOffers: any, selectedABI: any, selectedCAB: any, listToUpdate: any}): Promise<any>;
}
