global with sharing class CustomRetrieveServicePoint implements bit2flow.dynWizardsIFExt {
	global bit2flow.DynamicWizardStepWrapper executeMethod(String step, map<String, Object> data, String targetObjectKey, String method, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        return response;
    }

    global bit2flow.DynamicWizardStepWrapper init(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
        System.debug('Mappa che mi viene generata da Bit2Flow:' +sObjMap);
        Account acc = (Account)(sObjMap.get('merchant'));
        System.debug('Account caricato:'+acc);
        response.data = bit2flow.B2FUtils.setJSONValue(data, 'merchant', 'NE__Fiscal_code__c', acc.NE__Fiscal_code__c);
        
        NE__Service_Point__c newPv = [SELECT ID,OB_MCC__c,Name,NE__Street__c,NE__City__c,NE__Province__c,NE__Zip_Code__c,NE__Country__c FROM NE__Service_Point__c WHERE NE__Account__c =: acc.Id Order By CreatedDate Desc LIMIT 1];
        System.debug('Pv caricato:'+newPv);
       
        bit2flow.B2FUtils.setJSONValue(data, 'puntoVendita', 'Id', newPv.ID);
        bit2flow.B2FUtils.setJSONValue(data, 'puntoVendita', 'OB_MCC__c', newPv.OB_MCC__c);
        bit2flow.B2FUtils.setJSONValue(data, 'puntoVendita', 'Name', newPv.Name);
        bit2flow.B2FUtils.setJSONValue(data, 'puntoVendita', 'NE__Street__c', newPv.NE__Street__c);
        bit2flow.B2FUtils.setJSONValue(data, 'puntoVendita', 'NE__City__c', newPv.NE__City__c);
        bit2flow.B2FUtils.setJSONValue(data, 'puntoVendita', 'NE__Zip_Code__c', newPv.NE__Zip_Code__c);
        bit2flow.B2FUtils.setJSONValue(data, 'puntoVendita', 'NE__Province__c', newPv.NE__Province__c);
        bit2flow.B2FUtils.setJSONValue(data, 'puntoVendita', 'NE__Account__c', acc.Id);
        bit2flow.B2FUtils.setJSONValue(data, 'puntoVendita', 'NE__Country__c', newPv.NE__Country__c);
        
        bit2flow.B2FUtils.setJSONValue(data, 'legale_rappresentante', 'Role__c','Esecutore');
        bit2flow.B2FUtils.setJSONValue(data, 'titolare_effettivo', 'Role__c','Titolare Effettivo');
        
        
 
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
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
         Account acc = (Account)(sObjMap.get('merchant'));
        
        /*
        Account acc = (Account)(sObjMap.get('merchant'));
        System.debug('Questo è l\'account che ho recuperato da Bit2Flow:'+acc);
        */
        /*
        NE__Service_Point__c pv = (NE__Service_Point__c)(sObjMap.get('puntoVendita'));
        System.debug('service point che mi viene generata da Bit2Flow nel save method:' +pv);
         
        
         
        if( ! String.isBlank(pv.Name)){
        	System.debug('Si tratta di un service point già esistente');
        	update pv;
        }
        else{
        	
        }
        /*pv.NE__Account__c=acc.id;
        //System.debug('Procedo all\'inserimento del seguente punto vendita:'+pv);
        //insert pv;
        
        response.data = bit2flow.B2FUtils.setJSONValue(data, 'merchant', 'id', acc.id);
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.description = 'save succesfully';
        */
        response.data = bit2flow.B2FUtils.setJSONValue(data, 'merchant', 'id', acc.id);
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.description = 'save succesfully';
        return response;
        
    }
    
}