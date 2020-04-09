global with sharing class CustomCodeFlowCharContract implements bit2flow.dynWizardsIFExt {
	 
	
    global bit2flow.DynamicWizardStepWrapper executeMethod(String step, map<String, Object> data, String targetObjectKey, String method, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        system.debug('dati passati nel execute: ' + data);
        Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
        
        Boolean acquiring= (Boolean) bit2flow.B2FUtils.getJSONValue(data,'Unbind','ACQUIRING');
        system.debug ('boolean value ' + acquiring);
        if(acquiring == true){
        	bit2flow.B2FUtils.setJSONValue(data, 'Unbind', 'POS','false');
		 
        }
        //bit2flow.B2FUtils.setJSONValue(data, 'Unbind', 'ACQUIRING', acquiring);
         response.data=data;
        
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.description = 'save succesfully';
        return response;
    }

    global bit2flow.DynamicWizardStepWrapper init(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
        
         
        return response;
    }
    
    global bit2flow.DynamicWizardStepWrapper validate(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        
        return response;
    }
    
    global bit2flow.DynamicWizardStepWrapper save(String step, map<String, Object> data, String targetObjectKey,List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        system.debug('data:'+data);
        return response;
    }
}