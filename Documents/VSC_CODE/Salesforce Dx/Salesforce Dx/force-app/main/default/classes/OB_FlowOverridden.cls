global class OB_FlowOverridden implements bit2flow.dynWizardsIFExt{
  	
  	public static bit2flow.DynamicWizardStepWrapper validate(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
		System.debug('Validate Method in OB_FlowControlClass');
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();

		System.debug('response' + response);
			
		return response;
		
	}
	
	@AuraEnabled
	public static bit2flow.DynamicWizardStepWrapper overwriteNext (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper)
	{         
			bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
			
			
			System.debug('response' + response);
			
			return response;
			//return null;
	  }
	
	  @AuraEnabled
	  public static bit2flow.DynamicWizardStepWrapper overwritePrevious (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper)
	  {  
			bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
	  
			return response;
	  }

	  @AuraEnabled
	  public static bit2flow.DynamicWizardStepWrapper overwriteSave (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper,String targetObjectKey)
	  {		
	  	// Create a HistoricDataRecord and their attachs , one for data and one for the wizardWrapper 	
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		try
		{
			system.debug('saveHistoricData: ' + data);	

			//	START 	micol.ferrari 12/11/2018
			String orderString = JSON.serialize(data.get('OrderHeader'));
			System.debug(' orderString string :' + orderString);
			NE__Order_Header__c orderHeader = (NE__Order_Header__c)JSON.deserialize(orderString, NE__Order_Header__c.class);
			//	END 	micol.ferrari 12/11/2018

			// Retrieve from the wrapper the wizardId (not the attach Id). If the field is not there or it is empty, get the Id by Name
			String wizardIdValue = '';
			System.debug('wizardWrapper.wizardId: ' + wizardWrapper.wizardId);
	
			if(wizardWrapper.wizardId != null && wizardWrapper.wizardId != '')
			{
				wizardIdValue = wizardWrapper.wizardId;
			}
			else
			{
				// we have to retrieve the Id from the IntegrationAdministarion or the Wizard Definition

				if(Type.forName('NE__IntegrationAdministration__c') != null)
				{
					System.debug('Finding administrationList');
					List<sObject> administrationList = Database.query('SELECT Id FROM NE__IntegrationAdministration__c WHERE NE__Name__c =\'' + wizardWrapper.name + '\' ORDER BY CreatedDate DESC LIMIT 1');
					System.debug('administrationList: ' + administrationList);
					if(!administrationList.isEmpty())
					{
						wizardIdValue = (String) administrationList[0].get('Id'); 
					}
				}
				//JGL 20/03/2018 fix saving historic 
				if(wizardIdValue =='')
				{	
					System.debug('Finding wizarddefList');
					List<sObject> wizarddefList = Database.query('SELECT Id FROM bit2flow__Wizard_Definition__c WHERE bit2flow__Name__c =\'' + wizardWrapper.name + '\' ORDER BY CreatedDate DESC LIMIT 1');
					System.debug('wizarddefList: ' + wizarddefList);
					if(!wizarddefList.isEmpty())
					{
						wizardIdValue = (String) wizarddefList[0].get('Id');
					}
				}
			}

		   	sObject historicData = bit2flow.B2FUtils.newSObject('bit2flow__Historic_Wizard_Data__c'); 	

		   	historicData.put('bit2flow__Wizard_Name__c',wizardWrapper.name);
		   	historicData.put('bit2flow__Wizard_Label__c',wizardWrapper.label);
		   	historicData.put('bit2flow__Status__c','Draft');
		   	historicData.put('bit2flow__Wizard_Id__c',wizardIdValue);	

		   	//	START 	micol.ferrari 12/11/2018
		   	historicData.put('OB_OrderHeaderId__c',orderHeader.Id);
		   	//	END 	micol.ferrari 12/11/2018

		   	String historicExistingId = '';
	
		   	if(data.containsKey('historicObject'))
		   	{   
				historicExistingId = (String) bit2flow.B2FUtils.getJSONValue(data,'historicObject','Id');
			 	historicData.put('Id',historicExistingId);

				// remove all the previous attachments
				List<sObject> attachsToDelete = Database.query('SELECT Id FROM Attachment WHERE ParentId = \'' + historicExistingId + '\'');

				delete  attachsToDelete;  
		   }

		   	upsert historicData;

		   	System.debug('upsert done: ' + historicData);	

		   	List<Attachment> atachmentsList = new List<Attachment>();

		   	// data attachment
			Attachment dataAttachment = new Attachment();
			System.debug('DATA: '+JSON.serialize(data));
			dataAttachment.Body = Blob.valueOf(JSON.serialize(data));
			dataAttachment.Name = String.valueOf('dataJSON.json');
			dataAttachment.ParentId = (Id) historicData.get('Id');
		
		   	atachmentsList.add(dataAttachment);

			// wrapper attachment
		   	Attachment wrapperAttachment = new Attachment();
		   	wrapperAttachment.Body = Blob.valueOf(String.valueOf(wizardWrapper));
		   	wrapperAttachment.Name = String.valueOf('wrapperJSON.json');
		   	wrapperAttachment.ParentId = (Id) historicData.get('Id');
		
		   	atachmentsList.add(wrapperAttachment);

		   	insert atachmentsList;
		}
		catch(Exception e)
		{
			System.debug('Exception creating JSON attach: ' + e.getMessage());

		}

		response.result = '000';
        response.description = 'This is a successfully test for overwrite a wizard button';
		//response.stepToGo = 2;
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
	
	//funzione per modificare la visibilità di una sezione/campo
	 @AuraEnabled
	 global static bit2flow.DynamicWizardWrapper updateSection(bit2flow.DynamicWizardWrapper wizardWrapper,String stepName, Integer sectionPos, Boolean hidden){
		 return null;
	 }
	
	  @AuraEnabled
	  global static bit2flow.DynamicWizardStepWrapper executeMethod(String step, map<String, Object> data, String targetObjectKey, String method, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		return response;
	}
  	
  	
  	global bit2flow.DynamicWizardStepWrapper init(String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,bit2flow.DynamicWizardWrapper dynamicWizardWrapper)
  	{
		System.debug('Init Method');
		/* ANDREA MORITTU @START: JUMP TO NEXT STEP -- 22/11/2018*/
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        
        response.result 				= 	'000'; //bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.description 			= 	'OK';
        response.data					=	data;
        response.dynamicWizardWrapper 	= 	dynamicWizardWrapper;
        /*Integer numbStep 				= 	4;
        response.stepToGo 				= 	numbStep;*/
        Boolean objDataContainsOrderHeader = (data != null || data.size() > 0 || data.containsKey('OrderHeader'))?true:false;
       	//if(data != null && data.size() > 0 && data.containsKey('OrderHeader')) {
       	if(objDataContainsOrderHeader){
		
			if(data.containsKey('JumpToStep') ){
				Integer numberStep 				= 	Integer.valueOf(data.get('JumpToStep'));
                System.debug('numberStep is' + numberStep);
				response.stepToGo 				= 	numberStep;
                System.debug('response.steToGo is: ' + response.stepToGo);
				
			}
		}
		System.debug('@@response is: ' + response);
        return response;
  	}

	global bit2flow.DynamicWizardStepWrapper save(String step, map<String, Object> data, String targetObjectKey,List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper){
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
		response.data = data;
		return response;
	}
}