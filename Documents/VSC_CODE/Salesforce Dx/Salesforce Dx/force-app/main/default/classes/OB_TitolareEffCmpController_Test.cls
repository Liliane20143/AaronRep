@isTest
public class OB_TitolareEffCmpController_Test {
    	
    @isTest
    public static void insertDataTitolariTest(){
    	
        String step = '';
        Map<String, Object> data = new map<String, Object>();
        String targetObjectKey = '';
        String method = '';
        List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
        bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();
        Test.startTest();
        OB_TitolareEffCmpController.insertDataTitolari(step, data, targetObjectKey, method, stepsDefinition, dynamicWizardWrapper);
        Test.stopTest();      
    }
}