declare module "@salesforce/apex/OB_IdentifyCompany_CC.filterForUrlAndApp" {
  export default function filterForUrlAndApp(param: {url: any, app: any, merchantId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.listServicePoint" {
  export default function listServicePoint(param: {insegna: any, zipCode: any, city: any, street: any, url: any, app: any, merchantId: any, oldWrapperInformation: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.listAcc" {
  export default function listAcc(param: {fiscalCode: any, vatId: any, bankId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getBankIdByUser" {
  export default function getBankIdByUser(): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getUserIdByUser" {
  export default function getUserIdByUser(): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getEmployeesNumber" {
  export default function getEmployeesNumber(): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.checkNewServicePoint" {
  export default function checkNewServicePoint(param: {objectDataMapServicePoint: any, servicelist: any, merchantId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.insertData" {
  export default function insertData(param: {step: any, data: any, targetObjectKey: any, method: any, stepsDefinition: any, dynamicWizardWrapper: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.searchABIbyInputValue" {
  export default function searchABIbyInputValue(param: {value: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.searchCABbyInputValue" {
  export default function searchCABbyInputValue(param: {value: any, abi: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getBankProfileByABI" {
  export default function getBankProfileByABI(param: {abi: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getAccountById" {
  export default function getAccountById(param: {idAcc: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getMccDescription" {
  export default function getMccDescription(param: {mccCode: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getServicePointTypologyValues_SP" {
  export default function getServicePointTypologyValues_SP(): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getOrderHeaderByAccountId" {
  export default function getOrderHeaderByAccountId(param: {merchantId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getSourceSystem" {
  export default function getSourceSystem(param: {merchantId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getExternalCode" {
  export default function getExternalCode(param: {merchantId: any, otherCodes: any, merchantCategoryCode: any, postalCode: any, isEcommerce: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getOrderHeaderFromCod" {
  export default function getOrderHeaderFromCod(param: {merchantId: any, code: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getPendingOrderFromCode" {
  export default function getPendingOrderFromCode(param: {merchantId: any, operator: any, codeObject: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.checkOtherMerchantByCod" {
  export default function checkOtherMerchantByCod(param: {code: any, merchantId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.updateMerchantCodes" {
  export default function updateMerchantCodes(param: {merchantId: any, MIPAndSfdcArray: any, sfdcOnlyArray: any, MIPOnlyArray: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getLegalFromValue" {
  export default function getLegalFromValue(): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getCountryValue" {
  export default function getCountryValue(): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getShopSign" {
  export default function getShopSign(param: {servicePointId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getMccLov" {
  export default function getMccLov(param: {MCCCodePv: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getTimeOut" {
  export default function getTimeOut(): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getretrieveMerchant" {
  export default function getretrieveMerchant(param: {fiscalCode: any, vatCode: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getUserInformation" {
  export default function getUserInformation(): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getMccLovL2" {
  export default function getMccLovL2(param: {lookupID: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.retrieveAutomaticSp" {
  export default function retrieveAutomaticSp(param: {servicePointId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.getBaseURl" {
  export default function getBaseURl(): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.formalCheckOnSameMerchant" {
  export default function formalCheckOnSameMerchant(param: {orderAssetId: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.formalCheckOnOldData" {
  export default function formalCheckOnOldData(param: {fiscalCode: any, VAT: any, oldObjectsInfoStringified: any, servicePointType: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_IdentifyCompany_CC.updateAssetMerchantTakeOver" {
  export default function updateAssetMerchantTakeOver(param: {assetToUpdate: any}): Promise<any>;
}
