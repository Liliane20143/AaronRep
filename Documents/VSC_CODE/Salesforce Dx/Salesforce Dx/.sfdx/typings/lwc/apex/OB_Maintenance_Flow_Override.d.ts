declare module "@salesforce/apex/OB_Maintenance_Flow_Override.overwriteNext" {
  export default function overwriteNext(param: {step: any, data: any, stepsDefinition: any, wizardWrapper: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_Flow_Override.overwritePrevious" {
  export default function overwritePrevious(param: {step: any, data: any, stepsDefinition: any, wizardWrapper: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_Flow_Override.overwriteSave" {
  export default function overwriteSave(param: {step: any, data: any, stepsDefinition: any, wizardWrapper: any, targetObjectKey: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_Flow_Override.overwriteExit" {
  export default function overwriteExit(param: {step: any, data: any, stepsDefinition: any, wizardWrapper: any, targetObjectKey: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_Flow_Override.updateSection" {
  export default function updateSection(param: {wizardWrapper: any, stepName: any, sectionPos: any, hidden: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_Maintenance_Flow_Override.executeMethod" {
  export default function executeMethod(param: {step: any, data: any, targetObjectKey: any, method: any, stepsDefinition: any, dynamicWizardWrapper: any}): Promise<any>;
}
