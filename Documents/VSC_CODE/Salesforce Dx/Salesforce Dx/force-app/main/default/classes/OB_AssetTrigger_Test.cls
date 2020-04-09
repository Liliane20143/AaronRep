//	micol.ferrari 28/11/2018
@isTest
private class OB_AssetTrigger_Test
{
	@isTest 
	static void test_assettrigger() 
	{
		Test.startTest();
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
		triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableAssetTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP

		Account myAccount 		= new Account(	Name='TEST',
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect');
		insert myAccount;
		Asset myAsset 			= new Asset(AccountId=myAccount.Id,
											Name='TEST',
											NE__Status__c='Disconnected');
		insert myAsset;
		myAsset.NE__Status__c 	= 'Active';
		update myAsset;

		Test.stopTest();
	}
}