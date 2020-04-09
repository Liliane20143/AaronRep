//	 micol.ferrari 28/11/2018
@isTest
public class OB_AssetTriggerHandler_Test 
{
	@isTest 
	static void test_merchantLifeCycle_ToActive() 
	{
		Test.startTest();
		Id rtMerchant 			= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		Account myAccount 		= new Account(	Name='TEST',
												RecordTypeId=rtMerchant,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect');
		insert myAccount;
		NE__Service_Point__c sp = new NE__Service_Point__c(	NE__Account__c=myAccount.Id,
															Name='TEST',
															OB_Status__c='Inactive');
		insert sp;
		Asset myAsset 			= new Asset(AccountId=myAccount.Id,
											Name='TEST',
											NE__Status__c='Disconnected',
											NE__Service_Point__c=sp.Id);
		insert myAsset;
		myAsset.NE__Status__c 	= 'Active';
		update myAsset;

		myAsset.NE__Status__c 	= 'Disconnected';
		update myAsset;

		Test.stopTest();
	}

	@isTest 
	static void test_merchantLifeCycle_ToActive2() 
	{
		Test.startTest();
		Id rtMerchant 			= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		Account myAccount 		= new Account(	Name='TEST',
												RecordTypeId=rtMerchant,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect');
		insert myAccount;
		NE__Service_Point__c sp = new NE__Service_Point__c(	NE__Account__c=myAccount.Id,
															Name='TEST',
															OB_Status__c='Inactive');
		insert sp;
		Asset myAsset 			= new Asset(AccountId=myAccount.Id,
											Name='TEST',
											NE__Status__c='Disconnected',
											NE__Service_Point__c=sp.Id);
		insert myAsset;
		Asset myAsset2 			= new Asset(AccountId=myAccount.Id,
											Name='TEST',
											NE__Status__c='Disconnected',
											NE__Service_Point__c=sp.Id);
		insert myAsset2;
		myAsset.NE__Status__c 	= 'Active';
		update myAsset;
		myAsset2.NE__Status__c 	= 'Active';
		update myAsset2;

		myAsset.NE__Status__c 	= 'Disconnected';
		update myAsset;

		Test.stopTest();
	}

	@isTest 
	static void test_merchantLifeCycle_ToDisconnected() 
	{
		Id rtMerchant 			= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		Account myAccount 		= new Account(	Name='TEST',
												RecordTypeId=rtMerchant,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Active');
		insert myAccount;
		NE__Service_Point__c sp = new NE__Service_Point__c(	NE__Account__c=myAccount.Id,
															Name='TEST',
															OB_Status__c='Active');
		insert sp;
		Asset myAsset 			= new Asset(AccountId=myAccount.Id,
											Name='TEST',
											NE__Status__c='Active',
											NE__Service_Point__c=sp.Id);
		insert myAsset;

		Test.startTest();
		myAsset.NE__Status__c 	= 'Disconnected';
		update myAsset;

		Test.stopTest();
	}
}