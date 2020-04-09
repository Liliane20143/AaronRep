/*****************************************************************
Name:  OB_FlowControlClass

============================================================
Purpose:    overwrite logic of wizard button                                                                                                                   
============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                             DATE           DETAIL          Description
2.0  Lea Emalieu, Marco Ferri, Alessandro Tajana  20/08/2018       Created          CSR: 
*****************************************************************/


global without sharing class OB_FlowControlClass implements bit2flow.OverwriteButtonsIF, bit2flow.dynWizardsIFExt
{
	global  static string orderHeaderId {get;set;}

	/****************lea.emalieu START 17/09/2018 **********************************************/
	/*********Method for validation of field standard ******************************************/
    public static bit2flow.DynamicWizardStepWrapper validate( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper )
    {
		System.debug('Validate Method in OB_FlowControlClass');
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();

        switch on step
        {
			// Step == Dati Societa
            when 'step5'
            {
				response = executeMethod(step, data, 'targetObjectKey','companyData', stepsDefinition, dynamicWizardWrapper);
			}
			// Step == Titolari Effettivi
            when 'step6'
            {
				response = executeMethod(step, data, 'targetObjectKey','actualOwner', stepsDefinition, dynamicWizardWrapper);
			}
			// Step == Punto Vendita
            when 'step7'
            {
			 response = executeMethod(step, data, 'targetObjectKey','servicePoint', stepsDefinition, dynamicWizardWrapper);
			}
			// Step == Carica Documenti
            when 'step8'
            {
			  response = executeMethod(step, data, 'targetObjectKey','downloadDocument', stepsDefinition, dynamicWizardWrapper);
			}
		}
		System.debug('response' + response);
		return response;
	}
	
	@AuraEnabled
	public static bit2flow.DynamicWizardStepWrapper overwriteNext (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper)
	{         
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
			
        switch on step
        {
			// Step == Identifica Societa
            when '1'
            {
				  response = executeMethod(step, data, 'targetObjectKey','identifyCompany', stepsDefinition, WizardWrapper);
			} 
			// Step == Gestione Terminale
            when '2'
            {
				response = executeMethod(step, data, 'targetObjectKey','GTselection', stepsDefinition, WizardWrapper);
			}
			// Step == Dati Operativi
            when '4'
            {
				response = executeMethod(step, data, 'targetObjectKey','operationalData', stepsDefinition, WizardWrapper);
			}
			// Step == Punto Vendita
            when '7'
            {
			 	response = executeMethod(step, data, 'targetObjectKey','servicePoint', stepsDefinition, WizardWrapper);
			}
			// Step == Carica Documenti
            when '8'
            {
			  response = executeMethod(step, data, 'targetObjectKey','downloadDocument', stepsDefinition, WizardWrapper);
			}
			}
			return response;
	  }
	
	  @AuraEnabled
	  public static bit2flow.DynamicWizardStepWrapper overwritePrevious (String step, Map<String, Object> data,  List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper)
	  {  
			bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
	  System.debug('overwritePrevious data dati ' + data);
	  String stepName =String.valueOf(step);
	  System.debug('overwritePrevious step name ' + stepName);

        try
        {
            switch on stepName
            {
		  // Step == Gestione Terminale
                when '2'
                {
			response = executeMethod(step, data, 'targetObjectKey','GTselectionPrevious', stepsDefinition, WizardWrapper);
		  }
		  // Step == Offerta
                when '3'
                {
			response = executeMethod(step, data, 'targetObjectKey','offertaSelectionPrevious', stepsDefinition, WizardWrapper);
		  }
		  // Step == dati Operativi
                when '4'
                {
			response = executeMethod(step, data, 'targetObjectKey','operationalDataPrevious', stepsDefinition, WizardWrapper);
		  }
		  // Step == dati Societa
                when '5'
                {
			response = executeMethod(step, data, 'targetObjectKey','companyDataPrevious', stepsDefinition, WizardWrapper);
		  }
		  //Step == Service Point
                when '7'
                {
			response = executeMethod(step, data, 'targetObjectKey','servicePointPrevious', stepsDefinition, WizardWrapper);
		  }	
		  //Step == Riepilogo
                when '9'
                {
			response = executeMethod(step, data, 'targetObjectKey','riepilogoPrevious', stepsDefinition, WizardWrapper);
		  }
		  }
	  }
        catch ( Exception ecc )
        {
			System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
	  }
	  
			System.debug('response nel previous method' + response);
			return response;
	  }

    /*******************************************************************************
	Purpose:  Method overwrite save action from bit2flow
    Parameters: String step, Map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,
                bit2flow.DynamicWizardWrapper wizardWrapper, String targetObjectKey
    Returns: bit2flow.DynamicWizardStepWrapper

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         ?                       ?               ?               ?
	2.0         Joanna Mielczarek       09/05/2019      Modified        update fields of NE__Order__c on 'save' action from 'Dati Societa' step
	3.0         Joanna Mielczarek       16/05/2019      Modified        added method to change order status from 5 to 8 step
 	********************************************************************************/
	  @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwriteSave( String step, Map<String, Object> data,
            List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper,
            String targetObjectKey )
	  {		
			bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
			System.debug('overwriteSave data dati ' + data);
			String stepName =String.valueOf(step);
			System.debug('overwriteSave step name ' + stepName);
        try
        {
            switch on stepName
            {
					  //Step == Riepilogo
                when '1'
                {
						response = executeMethod(step, data, 'targetObjectKey','riepilogoSave', stepsDefinition, WizardWrapper);
                }
                when '2'
                {
						response = executeMethod(step, data, 'targetObjectKey','riepilogoSave', stepsDefinition, WizardWrapper);
                }
                when '3'
                {
						response = executeMethod(step, data, 'targetObjectKey','riepilogoSave', stepsDefinition, WizardWrapper);
                }
                when '4'
                {
						response = executeMethod(step, data, 'targetObjectKey','riepilogoSave', stepsDefinition, WizardWrapper);
					  //	START 	marco.armato 24/12/2018 - SAVE AS DRAFT
                }
                // NEXI-50 joanna.mielczarek@accenture.com 16/05/2019 START
                when '5'
                {
                    setOrderStatusOnSave( data );
						response = executeMethod(step, data, 'targetObjectKey','saveDraft', stepsDefinition, WizardWrapper);
                }
                when '6'
                {
                    setOrderStatusOnSave( data );
						response = executeMethod(step, data, 'targetObjectKey','saveDraft', stepsDefinition, WizardWrapper);
                }
                when '7'
                {
                    setOrderStatusOnSave( data );
						response = executeMethod(step, data, 'targetObjectKey','saveDraft', stepsDefinition, WizardWrapper);
                }
                when '8'
                {
                    setOrderStatusOnSave( data );
						response = executeMethod(step, data, 'targetObjectKey','saveDraft', stepsDefinition, WizardWrapper);
					  }
                // NEXI-50 joanna.mielczarek@accenture.com 16/05/2019 STOP
					  //	END 	marco.armato 24/12/2018 - SAVE AS DRAFT
					  }
				  }
        catch ( Exception ecc )
        {
					System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
			}

			System.debug('response' + response);
			return response;
	  }

	  @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwriteExit( String step, Map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper, String targetObjectKey )
    {
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		response.result = '000';
		response.description = 'This is a successfully test for overwrite a wizard button';
		response.data = data;
		response.dynamicWizardWrapper = wizardWrapper;

		System.debug('response' + response);
		return response;
	  }
	
	//funzione per modificare la visibilità di una sezione/campo
	 @AuraEnabled
    global static bit2flow.DynamicWizardWrapper updateSection( bit2flow.DynamicWizardWrapper wizardWrapper, String stepName, Integer sectionPos, Boolean hidden )
    {
		 return null;
	 }
	
	  //FROM OB_CustomSaveData_CC 
	  //@author Lea
	  @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper executeMethod( String step, map<String, Object> data, String targetObjectKey, String method, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper )
    {
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
        switch on method
        {
            when 'identifyCompany'
            {
			 response = OB_FlowControlUtility.identifyCompany(step, data, stepsDefinition, targetObjectKey, method,
										   dynamicWizardWrapper);
		   }  
            when 'GTselection'
            {
				response = OB_FlowControlUtility.GTselection(step, data, stepsDefinition, targetObjectKey, method,
										   dynamicWizardWrapper);
		   }
		   /**************************lea.emalieu START 25/09/2018 ***********************************************/
		   //ONLY CONTROL AF MANDATORY FILE WITHOUT SAVING DATA
            when 'operationalData'
            {
			  response = OB_FlowControlUtility.operationalData(step, data, stepsDefinition, targetObjectKey, method,
										   dynamicWizardWrapper);
		   }
		   /**************************lea.emalieu END 25/09/2018 ***********************************************/
            when 'companyData'
            {
			  response = OB_FlowControlUtility.companyData(step, data, stepsDefinition, targetObjectKey, method,
										   dynamicWizardWrapper);
		   }
            when 'actualOwner'
            {
			  response = OB_FlowControlUtility.actualOwner(step, data, stepsDefinition, targetObjectKey, method,
										   dynamicWizardWrapper);
		   }
            when 'servicePoint'
            {
			  response = OB_FlowControlUtility.servicePoint(step, data, stepsDefinition, targetObjectKey, method,
										   dynamicWizardWrapper);
		   }

            when 'downloadDocument'
            {
				response = OB_FlowControlUtility.downloadDocument(step, data, stepsDefinition, targetObjectKey, method,
										   dynamicWizardWrapper);
		   }

            when 'GTselectionPrevious'
            {
			 response = OB_FlowControlUtility.GTselectionPrevious(step, data, stepsDefinition, targetObjectKey, method,
					   dynamicWizardWrapper);
			}
	   
            when 'offertaSelectionPrevious'
            {
				response = OB_FlowControlUtility.offertaSelectionPrevious(step, data, stepsDefinition, targetObjectKey, method,
					   dynamicWizardWrapper);
			}

            when 'operationalDataPrevious'
            {
				response = OB_FlowControlUtility.operationalDataPrevious(step, data, stepsDefinition, targetObjectKey, method,
					   dynamicWizardWrapper);
			}

            when 'companyDataPrevious'
            {
				response = OB_FlowControlUtility.companyDataPrevious(step, data, stepsDefinition, targetObjectKey, method,
					   dynamicWizardWrapper);
			}

            when 'servicePointPrevious'
            {
				response = OB_FlowControlUtility.servicePointPrevious(step, data, stepsDefinition, targetObjectKey, method,
					   dynamicWizardWrapper);
			}

            when 'riepilogoPrevious'
            {
				response = OB_FlowControlUtility.riepilogoPrevious(step, data, stepsDefinition, targetObjectKey, method,
					   dynamicWizardWrapper);
			}

			//	START 	marco.armato 24/12/2018 - SAVE AS DRAFT
            when 'saveDraft'
            {
				String stringWizard = bit2flow.B2FUtils.serializeWrapper(dynamicWizardWrapper);
				String resp = OB_FlowControlUtility.saveDraft(step, data, stepsDefinition, dynamicWizardWrapper,stringWizard);
				response.description = resp;
                //START-12-04-2019-salvatore.pianura-set response.result code for saveDraft method
                // response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
								response.result = bit2flow.DynamicWizardStepWrapper.OKCODEANDSHOWMESSAGE;	//simone misani  22/05/2019 RI-68 change 	bit2flow.DynamicWizardStepWrapper.OKCODE with	bit2flow.DynamicWizardStepWrapper.OKCODEANDSHOWMESSAGE				
								response.data = data;//  simone misani  22/05/2019 RI-68 add response.data becouse required for Bit2Flow
                //END-12-04-2019-salvatore.pianura-set response.result code for saveDraft method
			} 
			//	END 	marco.armato 24/12/2018 - SAVE AS DRAFT 
            when else
            {
			 response.result = '666'; //errore
			 response.description = 'something has not validated properly in executeMethod';
			 response.dynamicWizardWrapper = dynamicWizardWrapper; 
		   }
		}
		return response;
	}
	
    global bit2flow.DynamicWizardStepWrapper init( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper )
    {
		System.debug('Init Method');
		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		response.stepToGo = 4;
		return response;
	}
		
    global bit2flow.DynamicWizardStepWrapper save( String step, map<String, Object> data, String targetObjectKey, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper )
		{

		bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper();
		try
		{
		System.debug('SAVE METHOD');

		String orderHeaderString =JSON.serialize(data.get('OrderHeader'));
		NE__Order_Header__c orderHeader = (NE__Order_Header__c)JSON.deserialize(orderHeaderString, NE__Order_Header__c.class);
		//START francesca.ribezzi 13/09/19 - R1F3-48 - setting OB_ExitFlow to true 
		orderHeader.OB_ExitFlow__c = true;
		//END francesca.ribezzi 13/09/19 - R1F3-48 
		
		String bankProfileString =JSON.serialize(data.get('bankProfile'));
		OB_Bank_Profile__c bankProfileValue = (OB_Bank_Profile__c)JSON.deserialize(bankProfileString, OB_Bank_Profile__c.class);

		String configurationString =JSON.serialize(data.get('Configuration'));
		NE__Order__c configurationValue = (NE__Order__c)JSON.deserialize(configurationString, NE__Order__c.class);
		String configurationId = configurationValue.Id;

		//START - elena.preteni R1F3-25 04/09/2019 manual pan flag on ORH
		List<NE__OrderItem__c> oiList = [SELECT id,
												NE__OrderId__r.NE__Configuration_Type__c,
												NE__OrderId__r.OB_ApprovalStatus__c,
												NE__ProdId__c,
												NE__ProdId__r.OB_Acquirer__c,
												NE__ProdId__r.RecordType.DeveloperName,
												NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
												NE__ProdId__r.OB_Codice_sfdc__c, 
												NE__Root_Order_Item__c,
												NE__OrderId__c,
												OB_isNotIntegrated__c,
												OB_Enablement__c,  
												NE__Action__c,
												NE__ProdId__r.Name,
												NE__Service_Point__r.OB_Typology__c,
												OB_Old_Enablement__c,
												NE__Parent_Order_Item__c 
										FROM NE__OrderItem__c 
										WHERE NE__OrderId__c = :configurationId];

		OB_Utility.updateOrhFlagManualPan(orderHeader, oiList);
	
		//END - elena.preteni R1F3-25 04/09/2019 manual pan flag on ORH
		//giovanni spinelli 12/04/2019 add if to stop this method - start
		Boolean missingFieldsBoolean = Boolean.valueOf(data.get('missingFieldsBoolean'));
		System.debug('THERE ARE MISSING FIELD? ' + missingFieldsBoolean);
		OB_Utility.opsEndFlow(configurationId, missingFieldsBoolean);
		
		//giovanni spinelli 12/04/2019 add if to stop this method - end
		}
		catch(Exception ecc) 
		{
			System.debug('[EXCE] OB_FlowControlUtility.riepilogoSave '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
		response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
		response.data = data;

		return response;
    }
		
    /*******************************************************************************
    Purpose:  Method calls method of setting order status
    Parameters: Map<String, Object> data
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/05/2019      Created         NEXI-50
    ********************************************************************************/
    private static void setOrderStatusOnSave( Map<String, Object> data )
    {
        String orderToDeserialize = JSON.serialize( data.get( 'Configuration' ) );
        NE__Order__c orderToUpdate = ( NE__Order__c ) JSON.deserialize( orderToDeserialize, NE__Order__c.class );
        OB_Order_ChangeStatus.setOrderStatusOrderToBeCompleted( orderToUpdate );
    }
}