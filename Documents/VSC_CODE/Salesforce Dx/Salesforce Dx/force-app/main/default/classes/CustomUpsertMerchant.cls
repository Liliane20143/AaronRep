global with sharing class CustomUpsertMerchant implements bit2flow.dynWizardsIFExt{
	
	global bit2flow.DynamicWizardStepWrapper executeMethod(String step, map<String, Object> data, String targetObjectKey, String method, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        return response;
    }

    global bit2flow.DynamicWizardStepWrapper init(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
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
        Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
        System.debug('Mappa che mi viene generata da Bit2Flow:' +sObjMap);
        Account acc = (Account)(sObjMap.get('merchant'));
        NE__Service_Point__c pv = (NE__Service_Point__c)(sObjMap.get('pv'));
        System.debug('Questo è l\'account che ho recuperato da Bit2Flow:'+acc); 
        
         
        if(String.isBlank(acc.Id)){
        	System.debug('Si tratta di un nuovo account, lo inserisco');
        	insert acc;
        }
        else{
        	System.debug('Account già esistente, lo aggiorno');
        	update acc;
        }
        pv.NE__Account__c=acc.id;
        System.debug('Procedo all\'inserimento del seguente punto vendita:'+pv);
        insert pv;
        
        response.data = bit2flow.B2FUtils.setJSONValue(data, 'merchant', 'id', acc.id);
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.description = 'save succesfully';
        
        return response;
    }
    
}