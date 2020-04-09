global with sharing class SaveWizard_TitolareEffettivo  implements bit2flow.dynWizardsIFExt {
	 
	public Contact titolareEffettivo2;
    global bit2flow.DynamicWizardStepWrapper executeMethod(String step, map<String, Object> data, String targetObjectKey, String method, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        return response;
    }

    global bit2flow.DynamicWizardStepWrapper init(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
         if(step == 'Esecutore'){
           Contact legaleRappresentante= (Contact)(sObjMap.get('legale_rappresentante'));
           //legaleRappresentante.Role__c ='Esecutore';
         }
         
         if(step == 'Titolare Effettivo'){
         	Contact titolareEffettivo1 = (Contact)(sObjMap.get('titolare_effettivo1'));
         	//titolareEffettivo1.Role__c = 'Titolare Effettivo';
         	titolareEffettivo2 = (Contact)(sObjMap.get('l'));
            System.debug('titolareEffettivo2: ' + titolareEffettivo2);
         	 if(! String.isBlank(titolareEffettivo2.Name)){
         	 	//titolareEffettivo2.Role__c = 'Titolare Effettivo';
         	 }
         }
        
        return response;
    }
    
    global bit2flow.DynamicWizardStepWrapper validate(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        system.debug('validate step:' + step);
        return response;
    }
    
    global bit2flow.DynamicWizardStepWrapper save(String step, map<String, Object> data, String targetObjectKey,List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        system.debug('data:'+data);
        if(! String.isBlank(titolareEffettivo2.Name)){
         	 	insert titolareEffettivo2;
         	 }
        
        return response;
    }



}