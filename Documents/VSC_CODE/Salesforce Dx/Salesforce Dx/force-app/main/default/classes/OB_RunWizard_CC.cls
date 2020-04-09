/*****************************************************************
Name:  OB_RunWizard_CC

============================================================
Purpose:   get the wizard Id from the API name, controller of OB_RunWizard.cmp
============================================================
History                                                            
-------                                                            
AUTHOR             				DATE           	DETAIL     
micol.ferrari   				24/09/2018      Created 
*****************************************************************/
public with sharing class OB_RunWizard_CC
{
	@AuraEnabled
	public static String getWizardIdFromAPIName(String wizardName) 
	{
		String toReturn = null;

		//	GET WIZARD ID FROM WIZARD NAME
		List<Attachment> listOfWizardAttachments = [SELECT Id,Name 
													FROM Attachment 
													WHERE parentId IN 
														(SELECT Id 
														 FROM bit2flow__Wizard_Definition__c 
														 WHERE bit2flow__Name__c=:wizardName) 
														 LIMIT 1];
		if (!listOfWizardAttachments.isEmpty())
		{
			toReturn = listOfWizardAttachments.get(0).Id;
		}
		return toReturn;	
	}
}