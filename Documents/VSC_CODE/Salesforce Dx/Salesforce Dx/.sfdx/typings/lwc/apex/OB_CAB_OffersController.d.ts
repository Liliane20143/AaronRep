declare module "@salesforce/apex/OB_CAB_OffersController.getABIbyUserIdServer" {
  export default function getABIbyUserIdServer(param: {userId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CAB_OffersController.getCABListFromInput" {
  export default function getCABListFromInput(param: {abi: any, cab: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CAB_OffersController.getOffersByABIServer" {
  export default function getOffersByABIServer(param: {abi: any, cab: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CAB_OffersController.getAllOffersToEnableServer" {
  export default function getAllOffersToEnableServer(param: {cabOffers: any, cab: any, abi: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CAB_OffersController.searchForOffersToEnable" {
  export default function searchForOffersToEnable(param: {bankOffers: any, searchText: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CAB_OffersController.getBundleOffers" {
  export default function getBundleOffers(param: {abi: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CAB_OffersController.getBundleOffersOrderBy" {
  export default function getBundleOffersOrderBy(param: {selectedValue: any, bundleOffers: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_CAB_OffersController.cloneParametersAndRows" {
  export default function cloneParametersAndRows(param: {activeOffers: any, abi: any, cab: any}): Promise<any>;
}
