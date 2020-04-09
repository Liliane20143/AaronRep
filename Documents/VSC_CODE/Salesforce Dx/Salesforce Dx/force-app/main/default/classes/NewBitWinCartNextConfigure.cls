global class NewBitWinCartNextConfigure implements bit2flow.OverwriteButtonsIF{
    
     /* @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwriteNext (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper)
    {         
      bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		//temp version of overwrite next, to override with standard one when working properly
		
		String s = String.valueOf(data.get('overwriteNext'));
		//francesca.ribezzi changed IF s value from 1 to 0 -> to get the correct bundle step.
		if(String.isBlank(s)){
			s = '0';
		}
		else{
			
			s = String.valueOf(Integer.valueOf(s)+1);
		} 
		
        data.put('overwriteNext', s);
        response.result = '000';
        response.description = 'This is a successfully test for overwrite a wizard button';
        //Change only when you need to go to the Economic summary 
        response.stepToGo = Integer.valueOf(step);
        
        response.data = data;
        response.dynamicWizardWrapper = wizardWrapper;
     
        System.debug('response' + response);
        return response;
        //return null;
         bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		//temp version of overwrite next, to override with standard one when working properly
		
		String s = String.valueOf(data.get('overwriteNext'));
		//francesca.ribezzi changed IF s value from 1 to 0 -> to get the correct bundle step.
		if(String.isBlank(s)){
			s = '0';
		}
		else{
			
			s = String.valueOf(Integer.valueOf(s)+1);
		} 
		
        data.put('overwriteNext', s);
        response.result = '000';
        response.description = 'This is a successfully test for overwrite a wizard button';
        //Change only when you need to go to the Economic summary 
        response.stepToGo = Integer.valueOf(step);
        
        response.data = data;
        response.dynamicWizardWrapper = wizardWrapper;
     
        System.debug('response' + response);
        return response;
        //return null;
    }*/
     @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwriteNext(String step, Map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper)
    {         
     bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		//temp version of overwrite next, to override with standard one when working properly
		 System.debug('stepsDefinition' + stepsDefinition);
		  System.debug('wizardWrapper' + wizardWrapper);
        response.result = '000';
        response.description = 'This is a successfully test for overwrite a wizard button';
        //Change only when you need to go to the Economic summary 
        response.stepToGo = Integer.valueOf(step)+1;
      
        //data.put('unbind.step',  response.stepToGo);
       Object unbindMap= data.get('unbind');
        System.debug('unbindMap' + unbindMap);
        response.data = data;
        //response.dynamicWizardWrapper = wizardWrapper;
     
        System.debug('response' + response);
        return response;

    }
    @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwritePrevious (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper)
    {      
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        
        response.result = '000';
        response.description = 'This is a successfully test for overwrite a wizard button';
        response.stepToGo = 1;
        response.data = data;
        response.dynamicWizardWrapper = wizardWrapper;
        
        System.debug('response' + response);
        
        return response;
    }
    
    @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwriteSave (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper,String targetObjectKey)
    {
        
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        
        response.result = '000';
        response.description = 'This is a successfully test for overwrite a wizard button';
        
        response.data = data;
        response.dynamicWizardWrapper = wizardWrapper;
        
        System.debug('response' + response);
        
        return response;
    }
    @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwriteExit (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper,String targetObjectKey){
        
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        
        response.result = '000';
        response.description = 'This is a successfully test for overwrite a wizard button';
        //response.stepToGo = 2;
        response.data = data;
        response.dynamicWizardWrapper = wizardWrapper;
        
        System.debug('response' + response);
        
        return response;
    }

    
}