declare module "@salesforce/apex/OB_FlowOverridden.overwriteNext" {
  export default function overwriteNext(param: {step: any, data: any, stepsDefinition: any, wizardWrapper: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_FlowOverridden.overwritePrevious" {
  export default function overwritePrevious(param: {step: any, data: any, stepsDefinition: any, wizardWrapper: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_FlowOverridden.overwriteSave" {
  export default function overwriteSave(param: {step: any, data: any, stepsDefinition: any, wizardWrapper: any, targetObjectKey: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_FlowOverridden.overwriteExit" {
  export default function overwriteExit(param: {step: any, data: any, stepsDefinition: any, wizardWrapper: any, targetObjectKey: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_FlowOverridden.updateSection" {
  export default function updateSection(param: {wizardWrapper: any, stepName: any, sectionPos: any, hidden: any}): Promise<any>;
}
declare module "@salesforce/apex/OB_FlowOverridden.executeMethod" {
  export default function executeMethod(param: {step: any, data: any, targetObjectKey: any, method: any, stepsDefinition: any, dynamicWizardWrapper: any}): Promise<any>;
}
