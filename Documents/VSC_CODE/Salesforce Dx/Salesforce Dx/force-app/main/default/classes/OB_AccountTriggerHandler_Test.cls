/*
CLASS NAME TO TEST : OB_AccountTriggerHandler
AUTHOR: DORIS TATIANA
DATE  : 09/11/2018
*/

@isTest 
public  class OB_AccountTriggerHandler_Test {

	@isTest
	public static void setInvalidNameOnAccount_Test() {

		Account acc = new Account(Name = 'test');
		acc.OB_Employees_Number__c = 'Minore di 10';
		acc.NE__Fiscal_code__c = '12345678909';
		acc.NE__VAT__c = '67543456789';
		acc.OB_CCIAA__c = 'is Test';
		//acc.OB_BypassValidation__c == false;
		//insert acc;		
		Account acc1 = new Account(Name = 'test');
		acc1.OB_Employees_Number__c = 'Minore di 10';
		acc1.NE__Fiscal_code__c = '12345678909';
		acc1.NE__VAT__c = '67543456789';
		acc1.OB_CCIAA__c = 'is Test';
		//acc1.OB_BypassValidation__c == false
		//insert acc1;		

		List<Account> accs = new List<Account>();
		accs.add(acc);
		insert accs;		

		List<Account> oldAccs = new List<Account>();
		oldAccs.add(acc1);
		insert oldAccs;
		
		Test.startTest();
		OB_AccountTriggerHandler ath = new OB_AccountTriggerHandler();
		//ath.setInvalidNameOnAccount(accs, oldAccs);
        Test.stopTest();
		
	}


	@isTest
	public static void setInvalidNameOnAccount_Test1() {

		Account acc = new Account(Name = 'test&%°à');
		acc.OB_Employees_Number__c = 'Minore di 10';
		acc.NE__Fiscal_code__c = '12345678909';
		acc.NE__VAT__c = '67543456789';
		acc.OB_CCIAA__c = 'is Testçò';
		//acc.OB_BypassValidation__c == false;
		//insert acc;
		try{

			insert acc;
		}
		catch (Exception exc) {
			String errorMsg = 'cannot specify Id in an insert call: [Id] ' + exc.getMessage();
		}


		Account acc1 = new Account(Name = 'test');
		acc1.OB_Employees_Number__c = 'Minore di 10';
		acc1.NE__Fiscal_code__c = '12345678909';
		acc1.NE__VAT__c = '67543456789';
		acc1.OB_CCIAA__c = 'isç@Test';
		//acc1.OB_BypassValidation__c == false;
		try{

			insert acc1;
		}
		catch (Exception exc) {
			String errorMsg = 'cannot specify Id in an insert call: [Id] ' + exc.getMessage();
		}

		List<Account> accs = new List<Account>();
		accs.add(acc);
		//insert accs;
		try{

			insert accs;
		}
		catch (Exception exc) {
			String errorMsg = 'cannot specify Id in an insert call: [Id] ' + exc.getMessage();
		}

		List<Account> oldAccs = new List<Account>();
		oldAccs.add(acc1);
		//insert oldAccs;
		try{

			insert oldAccs;
		}
		catch (Exception exc) {
			String errorMsg = 'cannot specify Id in an insert call: [Id] ' + exc.getMessage();
		}



		Test.startTest();
		OB_AccountTriggerHandler ath = new OB_AccountTriggerHandler();
		//ath.setInvalidNameOnAccount(accs, oldAccs);
        Test.stopTest();
		
	}

	@isTest
	public static void setAccountNumberWithABI_Test() 
	{
		Account acc = new Account(Name = 'test');
		acc.OB_BypassValidation__c = true;
		acc.OB_ABI__c = '12345';
		List<Account> accs = new List<Account>();
		accs.add(acc);
		insert accs;

		Test.startTest();
		OB_AccountTriggerHandler ath = new OB_AccountTriggerHandler();
		ath.setAccountNumberWithABI(accs, new List<Account>());
        Test.stopTest();
	}

	//	START 	micol.ferrari 28/11/2018
	@isTest
	public static void setOBStatusAccount_Test() 
	{		
		List<Account> listAccount 	= new List<Account>();
		Id rtBank 					= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
		Account myAccount 			= new Account(	Name='TEST',
													RecordTypeId=rtBank,
													OB_Employees_Number__c='Minore di 10',
													OB_VAT_Not_Present__c=true, 
													OB_DescriptionVATNotPresent__c='description', 
													NE__Fiscal_code__c='RSSMRA80A01F205X',
													OB_BypassValidation__c=true,
													OB_Status__c='Prospect');
		listAccount.add(myAccount);
		Id rtMerchant 				= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		Account myAccount2 			= new Account(	Name='TEST',
													RecordTypeId=rtMerchant,
													OB_Employees_Number__c='Minore di 10',
													OB_VAT_Not_Present__c=true, 
													OB_DescriptionVATNotPresent__c='description', 
													NE__Fiscal_code__c='RSSMRA80A01F205X',
													OB_BypassValidation__c=true,
													OB_Status__c='Prospect');
		listAccount.add(myAccount2);
		insert listAccount;

		Test.startTest();
		OB_AccountTriggerHandler accountHandler = new OB_AccountTriggerHandler();
		//accountHandler.setOBStatusAccount(listAccount,new List<Account>());
		Test.stopTest();
	}

	@isTest
	public static void setLogicForRecordType_ToActive_Test()
	{
		Map<Id,Account> mapNewAccounts = new Map<Id,Account>();
		Map<Id,Account> mapOldAccounts = new Map<Id,Account>();

		Id rtHolding			= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Holding').getRecordTypeId();
		Account myHolding 		= new Account(	Name='TEST',
												RecordTypeId=rtHolding,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect');
		insert myHolding;
		Id rtMasterMerchant		= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Master_Merchant').getRecordTypeId();
		Account myMastMerchant 	= new Account(	Name='TEST',
												RecordTypeId=rtMasterMerchant,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect');
		Id rtGroup	 			= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Group').getRecordTypeId();
		Account myGroup 		= new Account(	Name='TEST',
												RecordTypeId=rtGroup,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect',
												ParentId=myHolding.Id);
		List<Account> listAccount 	= new List<Account>();
		listAccount.add(myMastMerchant);
		listAccount.add(myGroup);
		insert listAccount;
		Id rtMerchant 			= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		Account myMerchant 		= new Account(	Name='TEST',
												RecordTypeId=rtMerchant,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect',
												OB_Master_Merchant_ID__c=myMastMerchant.Id,
												ParentId=myGroup.Id);
		
		insert myMerchant;
		mapOldAccounts.put(myMerchant.Id,myMerchant);
		mapOldAccounts.put(myGroup.Id,myGroup);

		myMerchant.OB_Status__c = 'Active';
		update myMerchant;
		myGroup.OB_Status__c 	= 'Active';
		update myGroup;
		mapNewAccounts.put(myMerchant.Id,myMerchant);
		mapNewAccounts.put(myGroup.Id,myGroup);

		Test.startTest();
		OB_AccountTriggerHandler accountHandler = new OB_AccountTriggerHandler();
		accountHandler.setLogicForRecordType(mapNewAccounts,mapOldAccounts);
		Test.stopTest();
	}
	@isTest
	public static void setLogicForRecordType_ToInactive_Test()
	{
		Map<Id,Account> mapNewAccounts = new Map<Id,Account>();
		Map<Id,Account> mapOldAccounts = new Map<Id,Account>();

		Id rtHolding			= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Holding').getRecordTypeId();
		Account myHolding 		= new Account(	Name='TEST',
												RecordTypeId=rtHolding,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect');
		insert myHolding;
		Id rtMasterMerchant		= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Master_Merchant').getRecordTypeId();
		Account myMastMerchant 	= new Account(	Name='TEST',
												RecordTypeId=rtMasterMerchant,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect');
		Id rtGroup	 			= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Group').getRecordTypeId();
		Account myGroup 		= new Account(	Name='TEST',
												RecordTypeId=rtGroup,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect',
												ParentId=myHolding.Id);
		List<Account> listAccount 	= new List<Account>();
		listAccount.add(myMastMerchant);
		listAccount.add(myGroup);
		insert listAccount;
		Id rtMerchant 			= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
		Account myMerchant 		= new Account(	Name='TEST',
												RecordTypeId=rtMerchant,
												OB_Employees_Number__c='Minore di 10',
												OB_VAT_Not_Present__c=true, 
												OB_DescriptionVATNotPresent__c='description', 
												NE__Fiscal_code__c='RSSMRA80A01F205X',
												OB_BypassValidation__c=true,
												OB_Status__c='Prospect',
												OB_Master_Merchant_ID__c=myMastMerchant.Id,
												ParentId=myGroup.Id);
		
		insert myMerchant;

		Test.startTest();
		
		myMerchant.OB_Status__c = 'Active';
		update myMerchant;
		myGroup.OB_Status__c 	= 'Active';
		update myGroup;
		mapOldAccounts.put(myMerchant.Id,myMerchant);
		mapOldAccounts.put(myGroup.Id,myGroup);

		myMerchant.OB_Status__c = 'Inactive';
		update myMerchant;
		myGroup.OB_Status__c 	= 'Inactive';
		update myGroup;
		mapNewAccounts.put(myMerchant.Id,myMerchant);
		mapNewAccounts.put(myGroup.Id,myGroup);

		myHolding.OB_Status__c 	= 'Active';
		update myHolding;

		OB_AccountTriggerHandler accountHandler = new OB_AccountTriggerHandler();
		accountHandler.setLogicForRecordType(mapNewAccounts,mapOldAccounts);
		Test.stopTest();
	}
	//	END 	micol.ferrari 28/11/2018
}