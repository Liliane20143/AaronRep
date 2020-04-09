public class OB_TitolareEffCmpController {
	@AuraEnabled
    public static Object insertDataTitolari (String step,   
                                   Map<String, Object> data,
                                   String targetObjectKey,
                                   String method,
                                   List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,
                                   bit2flow.DynamicWizardWrapper dynamicWizardWrapper ){
          
            OB_CustomSaveData_CC customSaveData = new OB_CustomSaveData_CC();
            bit2flow.DynamicWizardStepWrapper DynamicWizardStepWrapper = customSaveData.executeMethod(step , data , targetObjectKey , method , stepsDefinition , dynamicWizardWrapper);
            return DynamicWizardStepWrapper.data;
                 
}

}