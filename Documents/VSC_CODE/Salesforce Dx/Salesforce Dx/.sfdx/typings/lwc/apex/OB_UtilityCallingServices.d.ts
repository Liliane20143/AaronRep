declare module "@salesforce/apex/OB_UtilityCallingServices.getToken" {
  export default function getToken(): Promise<any>;
}
declare module "@salesforce/apex/OB_UtilityCallingServices.checkToken" {
  export default function checkToken(): Promise<any>;
}
declare module "@salesforce/apex/OB_UtilityCallingServices.saveToken" {
  export default function saveToken(param: {currentToken: any, currentTime: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_UtilityCallingServices.callServiceUtilAura" {
  export default function callServiceUtilAura(param: {url: any, method: any}): Promise<any>;
}
