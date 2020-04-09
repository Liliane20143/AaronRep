@isTest
public class OB_EsecutoreCmp_Test {

	@isTest
	public static void insertDataEsecutoreTest(){

		String step = '';
		Map<String, Object> data = new Map<String, Object>();
		String targetObjectKey = '';
        String method = '';
		List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
		bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();
		Test.startTest();
		OB_EsecutoreCmpController.insertDataEsecutore(step, data, targetObjectKey, method, stepsDefinition, dynamicWizardWrapper);
		Test.stopTest();
	}
}