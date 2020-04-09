global with sharing class testCustomMerchantSave implements bit2flow.dynWizardsIFExt {
	global bit2flow.DynamicWizardStepWrapper executeMethod(String step, map<String, Object> data, String targetObjectKey, String method, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
         System.debug('dati complessi nel execute method ' + data);
        Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
        Account acc = (Account)(sObjMap.get('merchant'));
        if(String.isBlank(acc.Id)){
        	acc.OB_Services_Choice__c =(String) bit2flow.B2FUtils.getJSONValue(data,'Unbind','ValueService');
	        insert acc;
	        System.debug('Account Id ' + acc.Id);
	        NE__Service_Point__c newPv = (NE__Service_Point__c)(sObjMap.get('pv'));
	        newPv.NE__Account__c = acc.Id;
	        bit2flow.B2FUtils.setJSONValue(data, 'pv', 'NE__Account__c', acc.Id);
	        insert newPv;
	        System.debug('ServicePoint Id ' + newPv.Id);
	        bit2flow.B2FUtils.setJSONValue(data, 'merchant', 'Id', acc.Id);
	        bit2flow.B2FUtils.setJSONValue(data, 'merchant', 'OB_Services_Choice__c', acc.OB_Services_Choice__c);
	        //bit2flow.B2FUtils.setJSONValue(data, 'legale_rappresentante', 'Role__c','Esecutore');
        	//bit2flow.B2FUtils.setJSONValue(data, 'titolare_effettivo', 'Role__c','Titolare Effettivo');
	        System.debug('Ho eseguito l\'execute Method! ');
        }else{
        	acc.OB_Services_Choice__c =(String) bit2flow.B2FUtils.getJSONValue(data,'Unbind','ValueService');
        	update acc;
        	bit2flow.B2FUtils.setJSONValue(data, 'merchant', 'OB_Services_Choice__c', acc.OB_Services_Choice__c);
        	
        }
        
        //response.stepToGo=5;
        
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data=data;
        
        return response;
    }

    global bit2flow.DynamicWizardStepWrapper init(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
    	response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
    	response.data=data;
    	return response;
    }
    
    global bit2flow.DynamicWizardStepWrapper validate(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
    	system.debug('Sono nel Validate Method');
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
     	Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
        Account acc = (Account)(sObjMap.get('merchant'));
        
        insert acc;
        System.debug('Account Id ' + acc.Id);
        NE__Service_Point__c newPv = (NE__Service_Point__c)(sObjMap.get('pv'));
        newPv.NE__Account__c = acc.Id;
        bit2flow.B2FUtils.setJSONValue(data, 'pv', 'NE__Account__c', acc.Id);
        insert newPv;
        bit2flow.B2FUtils.setJSONValue(data, 'merchant', 'id', acc.Id);
        System.debug('Ho eseguito l\'execute Method! ');
        
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        
        response.stepToGo=5;
        return response;
        
        
    }
    
    global bit2flow.DynamicWizardStepWrapper save(String step, map<String, Object> data, String targetObjectKey,List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
        System.debug('Dati totali nel save ' + data);
        
        Account acc = (Account)(sObjMap.get('merchant'));
        NE__Billing_Profile__c  bp = (NE__Billing_Profile__c)(sObjMap.get('merchant'));
        System.debug('il billing profile è: ' + bp);
        
        if(!String.isBlank(acc.Id)){
            upsert acc;
        	system.debug('Aggiornamento di un account già esistente');
        	//system.debug('oggetto billingProfile: ' + bp);
        }
        else{
        insert acc;
        }
       // insert bp;
        
        /*
        System.debug('Account Id ' + acc.Id);
        NE__Service_Point__c newPv = (NE__Service_Point__c)(sObjMap.get('pv'));
        newPv.NE__Account__c = acc.Id;
        bit2flow.B2FUtils.setJSONValue(data, 'pv', 'NE__Account__c', acc.Id);
        insert newPv;
        bit2flow.B2FUtils.setJSONValue(data, 'merchant', 'id', acc.Id);
        */
        System.debug('Ho eseguito il save method');
        
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data=data;
        //response.stepToGo=5;
        return response;
        
    }
    
}