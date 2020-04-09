@isTest
public class OB_NewBitWinCartNextConfigure_Test {

	@isTest
	public static void overwriteNextTest(){
		String step = '1'; 
		Map<String, Object> data = new Map<String, Object>();  
		List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
		bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper();
		Test.startTest();
		NewBitWinCartNextConfigure.overwriteNext(step, data, stepsDefinition, wizardWrapper);
		Test.stopTest();
	}

	@isTest
	public static void overwritePreviousTest(){
		String step = ''; 
		Map<String, Object> data = new Map<String, Object>();  
		List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
		bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper();	
		Test.startTest();
		NewBitWinCartNextConfigure.overwritePrevious(step, data, stepsDefinition, wizardWrapper);
		Test.stopTest();
	}

	@isTest
	public static void overwriteSaveTest(){
		String step = ''; 
		Map<String, Object> data = new Map<String, Object>();  
		List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
		bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper();
		String targetObjectKey = '';
		Test.startTest();
		NewBitWinCartNextConfigure.overwriteSave(step, data, stepsDefinition, wizardWrapper, targetObjectKey);
		Test.stopTest();
	}

	@isTest
	public static void overwriteExitTest(){
		String step = ''; 
		Map<String, Object> data = new Map<String, Object>();  
		List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
		bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper();
		String targetObjectKey = '';
		Test.startTest();
		NewBitWinCartNextConfigure.overwriteExit(step, data, stepsDefinition, wizardWrapper, targetObjectKey);
		Test.stopTest();
	}
}