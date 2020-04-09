@isTest
public with sharing class OB_ConfigurationItemsDetailsWrapper_Test {

	/**
    *@author  Giovanni Spinelli <spinelli.giovanni@accenture.com>
    *@date 12/04/2019
    *@description Set up method
    */
    @testSetup 
    public static void setUp() 
    {
        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
        insert orderHeader;
         NE__Order__c configuration = new NE__Order__c(NE__Order_Header__c=orderHeader.Id );
        
        insert configuration;
		Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
        Account a = new Account();
		a.Name 					 = 'a'; 
		a.NE__VAT__c 			 = '12345678901'; 
		a.OB_Employees_Number__c = 'Minore di 10';
		a.NE__Fiscal_code__c 	 = 'AAAAAA11A11A111A';
		a.OB_ABI__c 			 = '12345';
		a.RecordTypeId = rtMerchant;
		insert a;
		
		Contact c   = new Contact();
		c.LastName  = 'c';
		c.AccountId = a.id;
		insert c;
    }
	
	/**
    *@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
    *@date 12/04/2019
    *@description Method for the approval request
    */
    @isTest
    static void submitApprovalRequestMethod_test(){
       	UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    	Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    	
    	User portalAccountOwner = new User();
    	portalAccountOwner.ProfileId = pAdmin.id;
    	portalAccountOwner.Username ='portalAccountOwner@test.com';
    	portalAccountOwner.Alias = 'alias';
    	portalAccountOwner.Email='portalAccountOwner@test.com';
    	portalAccountOwner.EmailEncodingKey='UTF-8';
    	portalAccountOwner.Firstname='firstName';
    	portalAccountOwner.Lastname='lastName';
    	portalAccountOwner.LanguageLocaleKey='en_US';
    	portalAccountOwner.LocaleSidKey='en_US';
    	portalAccountOwner.TimeZoneSidKey='America/Chicago';
    	portalAccountOwner.UserRoleId = portalRole.id;
	    insert portalAccountOwner;
	    
	    System.runAs(portalAccountOwner) {    	
    		Account acc = [SELECT Id FROM Account WHERE Name = 'a'];    		
    		acc.ownerid = portalAccountOwner.id;
    		update acc;
    	}   
    	
    	Contact con = [SELECT Id FROM Contact WHERE LastName = 'c' LIMIT 1];
    	Account bankAccount = [SELECT Id FROM Account WHERE NE__Fiscal_code__c ='AAAAAA11A11A111A'];
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Nexi Partner User'];

        User createdUser = new User();
        createdUser.Username = 'user123123@test.com';
        createdUser.ContactId = con.id;
        createdUser.ProfileId = p.id;
        createdUser.Alias = 'alias';
        createdUser.Email = 'user@test.com';
        createdUser.EmailEncodingKey = 'UTF-8';
        createdUser.LastName = 'lastName';
        createdUser.CommunityNickname = 'test12345';
        createdUser.TimeZoneSidKey = 'America/Los_Angeles';
        createdUser.LocaleSidKey = 'en_US';
        createdUser.LanguageLocaleKey = 'en_US';
        createdUser.OB_CAB__c = '12345';
        Id userId = Site.createExternalUser(createdUser, bankAccount.Id, null, false);
        createdUser.Id = userId;

		System.runAs(createdUser) 
        {
			NE__Order_Header__c oh = new NE__Order_Header__c();
			insert oh;
			
			//Id pId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].id;
			User sAdmin = [SELECT Id FROM User WHERE ProfileId = :pAdmin.Id LIMIT 1];
			
			NE__Order__c configuration = new NE__Order__c();
			configuration.NE__Order_Header__c = oh.id;
			configuration.Ownerid = UserInfo.getuserid();
			configuration.OB_ApprovalType__c = 'Pricing';
			configuration.OB_BankApprovalStatus__c = 'To Approve';
			configuration.OB_ABI__c = '05116';
			insert configuration;
			
			Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
			req1.setComments('Submitting request for approval.');
			req1.setObjectId(configuration.id);
			//req1.setProcessDefinitionNameOrId('Example_Process');
			req1.setSkipEntryCriteria(true);
			req1.setNextApproverIds(new Id[] {sAdmin.id});
			Approval.ProcessResult result = Approval.process(req1);
				
				
			
			ProcessInstance proInstance = [SELECT Id FROM ProcessInstance LIMIT 1];
			
			System.debug('proInstance.id: ' + proInstance.id);       
					
			Test.startTest();         //francesca.ribezzi 06/12/19 - PERF-25 - adding parameter
			OB_ConfigurationItemsDetailsWrapper_CC.submitApprovalRequestMethod(configuration.Id,'test');
			Test.stopTest();
        }              
    }
    
	/**
    *@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
    *@date 12/04/2019
    *@description Method for the rejection of the approval request
    */
    @isTest
    static void rejectApprovalRequestMethod_test()
	{
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    	Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    	String textAreaMessage = '';//giovanni spinelli 10/06/2019
    	User portalAccountOwner = new User();
    	portalAccountOwner.ProfileId = pAdmin.id;
    	portalAccountOwner.Username ='portalAccountOwner@test.com';
    	portalAccountOwner.Alias = 'alias';
    	portalAccountOwner.Email='portalAccountOwner@test.com';
    	portalAccountOwner.EmailEncodingKey='UTF-8';
    	portalAccountOwner.Firstname='firstName';
    	portalAccountOwner.Lastname='lastName';
    	portalAccountOwner.LanguageLocaleKey='en_US';
    	portalAccountOwner.LocaleSidKey='en_US';
    	portalAccountOwner.TimeZoneSidKey='America/Chicago';
    	portalAccountOwner.UserRoleId = portalRole.id;
	    insert portalAccountOwner;
	    
	    System.runAs(portalAccountOwner) {    	
    		Account acc = [SELECT Id FROM Account WHERE Name = 'a'];    		
    		acc.ownerid = portalAccountOwner.id;
    		update acc;	
    	}   
    	
    	Contact con = [SELECT Id FROM Contact WHERE LastName = 'c' LIMIT 1];
    	Account bankAccount = [SELECT Id FROM Account WHERE NE__Fiscal_code__c ='AAAAAA11A11A111A'];
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Nexi Partner User'];

        User createdUser = new User();
        createdUser.Username = 'user123123@test.com';
        createdUser.ContactId = con.id;
        createdUser.ProfileId = p.id;
        createdUser.Alias = 'alias';
        createdUser.Email = 'user@test.com';
        createdUser.EmailEncodingKey = 'UTF-8';
        createdUser.LastName = 'lastName';
        createdUser.CommunityNickname = 'test12345';
        createdUser.TimeZoneSidKey = 'America/Los_Angeles';
        createdUser.LocaleSidKey = 'en_US';
        createdUser.LanguageLocaleKey = 'en_US';
        createdUser.OB_CAB__c = '12345';
        Id userId = Site.createExternalUser(createdUser, bankAccount.Id, null, false);
        createdUser.Id = userId;

		System.runAs(createdUser) 
        {        
			NE__Order_Header__c oh = new NE__Order_Header__c();
			insert oh;
			
			Id pId 		= [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].id;
			User sAdmin = [SELECT Id FROM User WHERE ProfileId = :pId LIMIT 1];
			
			NE__Order__c configuration = new NE__Order__c();
			configuration.NE__Order_Header__c = oh.id;
			configuration.Ownerid = UserInfo.getuserid();
			configuration.OB_ApprovalType__c = 'Pricing';
			configuration.OB_BankApprovalStatus__c = 'To Approve';
			configuration.OB_ABI__c = '05116';
			insert configuration;
			
			Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
			req1.setComments('Submitting request for approval.');
			req1.setObjectId(configuration.id);
			req1.setSkipEntryCriteria(true);
			req1.setNextApproverIds(new Id[] {sAdmin.id});
			Approval.ProcessResult result = Approval.process(req1);

			ProcessInstance proInstance = [SELECT Id FROM ProcessInstance LIMIT 1];
			
			System.debug('proInstance.id: ' + proInstance.id);       
					
			Test.startTest();         
			OB_ConfigurationItemsDetailsWrapper_CC.rejectApprovalRequestMethod(configuration.Id , textAreaMessage);
			Test.stopTest();
        }        
    }

	/*
    #### author Daniele Gandini <daniele.gandini@accenture.com>
    #### date 12/04/2019
    #### description Method for retrieving the Work Items
    */
    @isTest
    static void getWorkItemsId_test()
	{    
        //NE__Order__c configuration = [SELECT id FROM NE__Order__c ];

		UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    	Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    	
    	User portalAccountOwner = new User();
    	portalAccountOwner.ProfileId = pAdmin.id;
    	portalAccountOwner.Username ='portalAccountOwner@test.com';
    	portalAccountOwner.Alias = 'alias';
    	portalAccountOwner.Email='portalAccountOwner@test.com';
    	portalAccountOwner.EmailEncodingKey='UTF-8';
    	portalAccountOwner.Firstname='firstName';
    	portalAccountOwner.Lastname='lastName';
    	portalAccountOwner.LanguageLocaleKey='en_US';
    	portalAccountOwner.LocaleSidKey='en_US';
    	portalAccountOwner.TimeZoneSidKey='America/Chicago';
    	portalAccountOwner.UserRoleId = portalRole.id;
	    insert portalAccountOwner;
	    
	    System.runAs(portalAccountOwner) {    	
    		Account acc = [SELECT Id FROM Account WHERE Name = 'a'];    		
    		acc.ownerid = portalAccountOwner.id;
    		update acc;	
    	}   
    	
    	Contact con = [SELECT Id FROM Contact WHERE LastName = 'c' LIMIT 1];
    	//Profile p	= [SELECT Id FROM Profile WHERE Name = 'Partner Community User'];
		Account bankAccount = [SELECT Id FROM Account WHERE NE__Fiscal_code__c ='AAAAAA11A11A111A'];
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Nexi Partner User'];

        User createdUser = new User();
        createdUser.Username = 'user123123@test.com';
        createdUser.ContactId = con.id;
        createdUser.ProfileId = p.id;
        createdUser.Alias = 'alias';
        createdUser.Email = 'user@test.com';
        createdUser.EmailEncodingKey = 'UTF-8';
        createdUser.LastName = 'lastName';
        createdUser.CommunityNickname = 'test12345';
        createdUser.TimeZoneSidKey = 'America/Los_Angeles';
        createdUser.LocaleSidKey = 'en_US';
        createdUser.LanguageLocaleKey = 'en_US';
        createdUser.OB_CAB__c = '12345';
        Id userId = Site.createExternalUser(createdUser, bankAccount.Id, null, false);
        createdUser.Id = userId;

		System.runAs(createdUser) 
        {        
			NE__Order_Header__c oh = new NE__Order_Header__c();
			insert oh;
			
			Id pId 		= [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].id;
			User sAdmin = [SELECT Id FROM User WHERE ProfileId = :pId LIMIT 1];
			
			NE__Order__c configuration = new NE__Order__c();
			configuration.NE__Order_Header__c = oh.id;
			configuration.Ownerid = UserInfo.getuserid();
			configuration.OB_ApprovalType__c = 'Pricing';
			configuration.OB_BankApprovalStatus__c = 'To Approve';
			configuration.OB_ABI__c = '05116';
			insert configuration; 
			
			Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
			req1.setComments('Submitting request for approval.'); 
			req1.setObjectId(configuration.id);
			req1.setSkipEntryCriteria(true);
			req1.setNextApproverIds(new Id[] {sAdmin.id});
			Approval.ProcessResult result = Approval.process(req1);

			ProcessInstance proInstance = [SELECT Id FROM ProcessInstance LIMIT 1];

			OB_Integration_Configuration__c OrgCustomSetting = new OB_Integration_Configuration__c();
			OrgCustomSetting.Name = 'DEV1';
			OrgCustomSetting.OB_Domain__c = 'dev1';
			insert OrgCustomSetting;
			
			System.debug('proInstance.id: ' + proInstance.id);   
			

			Test.startTest();
			OB_ConfigurationItemsDetailsWrapper_CC.getWorkItemsId(configuration.Id);
			Test.stopTest();
		}
    }

    /*****************************************************************
    Purpose: Test method for checkUserOwnership - CHECK IF CURRENT USER IS MEMBER OF THE APPROVAL QUEUE                                                          
    History                                                            
    --------                                                           
    VERSION  AUTHOR             DATE           DETAIL          Description
    1.0      gianluigi.virga    29/04/2019     Created         CSR: 
    *****************************************************************/
    @isTest
    static void checkUserOwnership_test()
	{    
		NE__Order_Header__c oh = new NE__Order_Header__c();
		insert oh;
		NE__Order__c configuration = new NE__Order__c();
		configuration.NE__Order_Header__c = oh.id;
		insert configuration;
        Test.startTest();
		OB_ConfigurationItemsDetailsWrapper_CC.checkUserOwnership(configuration.Id);
		Test.stopTest();
    }
    //  END gianluigi.virga 29/04/2019
}