global with sharing class CustomMerchantSearch implements bit2flow.dynWizardsIFExt {
   
    
    
    
    
    
    global static bit2flow.DynamicWizardStepWrapper executeMethod(String step, 
                                                           map<String, Object> data, String targetObjectKey, String method, 
                                                           List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper)
    {
        System.debug('sono nell execute method' );
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        System.debug('complex data into execute method ' + data); 
        //search account by fiscal code
        String fiscalCode=(String) bit2flow.B2FUtils.getJSONValue(data,'Unbind','FiscalCode'); 
        if(fiscalCode!=null){
            System.debug('SONO NEL PRIMO IF ');
            //fiscal code is into bank
            List<Account> listAccount = [Select ID , NE__Fiscal_code__c
                                         from account];
            //if fiscalCode IN listAccount
            if(fiscalCode.length()>5){
                System.debug('SONO NELL IF DI LUNGHEZZA MAGGIORE DI 5');
                //NE_Merchant_Code_bank__c
                List<Account> accountListByFiscalCode =[select  name 
                                                        from account
                                                        where NE__Fiscal_code__c =:fiscalCode
                                                       ]; 
                
                System.debug('accountListByFiscalCode' + accountListByFiscalCode.size());
            }
            //fiscal code isn't into bank
            else{
                System.debug('SONO NELL IF DI LUNGHEZZA MINORE DI 5');
                List<Account> accountListByFiscalCode2 =[select AccountNumber
                                                         from account];
                
                System.debug('accountListByFiscalCode2' + accountListByFiscalCode2);
                
            }
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));  
        }
        
     return response;
    }
    
    
    global bit2flow.DynamicWizardStepWrapper init(String step, 
                                                  map<String, Object> data, 
                                                  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper)
    {
      bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
      return response;
    }
    
    global bit2flow.DynamicWizardStepWrapper validate(String step, 
                                                      map<String, Object> data, 
                                                      List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper)
    {
       bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        return response; 
    }
    
    global bit2flow.DynamicWizardStepWrapper save(String step, 
                                                  map<String, Object> data, 
                                                  String targetObjectKey,
                                                  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper)
    {
     bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        return response;
    }

}