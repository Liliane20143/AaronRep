@isTest
public class OB_MaintenanceSearch_Controller_Test 
{   
    // <daniele.gandini@accenture.com> - 14/06/2019 - start
    private static final Map<String, Schema.RecordTypeInfo> ACCOUNT_INFO = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( );
    private static final Id ACCOUNT_RT_ID = ACCOUNT_INFO.get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );
    // <daniele.gandini@accenture.com> - 14/06/2019 - stop

    @testSetup
    static void setup() 
    {       
        Account a = new Account();
        a.Name                   = 'a'; 
        a.NE__VAT__c             = '12345678901'; 
        a.OB_Employees_Number__c = 'Minore di 10';
        a.NE__Fiscal_code__c     = 'AAAAAA11A11A111A';
        a.OB_ABI__c              = '12345';
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        insert a;
        
        Contact c   = new Contact();
        c.LastName  = 'c';
        c.AccountId = a.id;
        c.Email = 'user@test.com';
        insert c;

        Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT).getRecordTypeId();
        Id rtBank = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
        
        List<Account> accounts = new List<Account>();

        Account bank1 = new Account();
            bank1.Name = 'bank1';
            bank1.OB_Employees_Number__c = 'Minore di 10'; 
            bank1.OB_VAT_Not_Present__c = true;
            bank1.OB_DescriptionVATNotPresent__c = 'description'; 
            bank1.NE__Fiscal_code__c = 'RSSMRA80A01F001B';
            bank1.OB_ABI__c = '05116';
            bank1.RecordTypeid = rtBank;
        accounts.add(bank1);

        Account bank2 = new Account();
            bank2.Name = 'bank2';
            bank2.OB_Employees_Number__c = 'Minore di 10'; 
            bank2.OB_VAT_Not_Present__c = true;
            bank2.OB_DescriptionVATNotPresent__c = 'description'; 
            bank2.NE__Fiscal_code__c = 'RSSMRA80A01F002B';
            bank2.OB_ABI__c = '05116';
            bank2.RecordTypeid = rtBank;
        accounts.add(bank2);

        Account bank3 = new Account();
            bank3.Name = 'bank3';
            bank3.OB_Employees_Number__c = 'Minore di 10'; 
            bank3.OB_VAT_Not_Present__c = true;
            bank3.OB_DescriptionVATNotPresent__c = 'description'; 
            bank3.NE__Fiscal_code__c = 'RSSMRA80A01F003B';
            bank3.OB_ABI__c = '05116';
            bank3.RecordTypeid = rtBank;
        accounts.add(bank3);

        //LUBRANO -- 2019-03-29 --BANK WITH BLANK ABI FOR COVERAGE searchOnAsset AND retriveBankOwner
        Account bank4 = new Account();
            bank4.Name = 'bank4';
            bank4.OB_Employees_Number__c = 'Minore di 10'; 
            bank4.OB_VAT_Not_Present__c = true;
            bank4.OB_DescriptionVATNotPresent__c = 'description'; 
            bank4.NE__Fiscal_code__c = 'RSSMRA80A01F003B';
            bank4.OB_ABI__c = '';
            bank4.RecordTypeid = rtBank;
        accounts.add(bank4);

        Account merchant1 = new Account();
            
            merchant1.Name = 'merchant1';
            merchant1.OB_Employees_Number__c = 'Minore di 10';
            merchant1.OB_VAT_Not_Present__c = true;
            merchant1.OB_DescriptionVATNotPresent__c = 'description';
            merchant1.NE__Fiscal_code__c = 'RSSMRA80A01F001M';
            merchant1.RecordTypeid = rtMerchant;
        accounts.add(merchant1);

        Account merchant2 = new Account();
            merchant2.Name = 'merchant2';
            merchant2.OB_Employees_Number__c = 'Minore di 10'; 
            merchant2.OB_VAT_Not_Present__c = true;
            merchant2.OB_DescriptionVATNotPresent__c = 'description'; 
            merchant2.NE__Fiscal_code__c = 'RSSMRA80A01F002M';
            merchant2.OB_ABI__c = '00112';
            merchant2.RecordTypeid = rtMerchant;
        accounts.add(merchant2);

        //LUBRANO -- 2019-03-29 --BANK WITH BLANK ABI FOR COVERAGE searchOnAsset AND retriveBankOwner
        Account merchant3 = new Account();
            merchant3.Name = 'merchant3';
            merchant3.OB_Employees_Number__c = 'Minore di 10'; 
            merchant3.OB_VAT_Not_Present__c = true;
            merchant3.OB_DescriptionVATNotPresent__c = 'description'; 
            merchant3.NE__Fiscal_code__c = 'RSSMRA80A01F003M';
            merchant3.OB_ABI__c = '';
            merchant3.RecordTypeid = rtMerchant;
            
        accounts.add(merchant3);

        insert accounts;

        merchant3.OB_Bank_owner__c = bank4.Id;
        update merchant3;

        Id rtLegalEntity = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.DATI_SOCIETA_LEGALE ).getRecordTypeId();
        Id rtExecutor = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ESECUTORE ).getRecordTypeId();

        List<Contact> contacts = new List<Contact>(); 

        Contact contactBank1 = new Contact();
            contactBank1.LastName = 'contactBank1';
            contactBank1.AccountId = bank1.Id;
            contactBank1.Recordtypeid = rtLegalEntity;
            contactBank1.Email = 'user@test.com';
        contacts.add(contactBank1); 

        Contact contactBank2 = new Contact();
            contactBank2.LastName = 'contactBank2';
            contactBank2.AccountId = bank2.Id;
            contactBank2.Recordtypeid = rtLegalEntity;
            contactBank2.Email = 'user@test.com';
        contacts.add(contactBank2); 

        Contact contactBank3 = new Contact();
            contactBank3.LastName = 'contactBank3';
            contactBank3.AccountId = bank3.Id;
            contactBank3.Recordtypeid = rtLegalEntity;
            contactBank3.Email = 'user@test.com';
        contacts.add(contactBank3); 

        Contact contactMerchant1 = new Contact();
            contactMerchant1.LastName = 'contactMerchant1';
            contactMerchant1.AccountId = merchant1.Id;
            contactMerchant1.Recordtypeid = rtLegalEntity;
            contactMerchant1.Email = 'user@test.com';
        contacts.add(contactMerchant1); 

        Contact contactMerchant2 = new Contact();
            contactMerchant2.LastName = 'contactMerchant2';
            contactMerchant2.AccountId = merchant2.Id;
            contactMerchant2.Recordtypeid = rtLegalEntity;
            contactMerchant2.Email = 'user@test.com';
        contacts.add(contactMerchant2); 

        insert contacts; 

        NE__Service_Point__c spBank1 = new NE__Service_Point__c();
            spBank1.Name = 'spBank1';
            spBank1.NE__Account__c = bank1.Id;
        insert spBank1; 

        NE__Order__c ord = new NE__Order__c();
        insert ord;

        
        NE__Order__c ord2 = new NE__Order__c();
        insert ord2;

        NE__Bundle__c bundle = new NE__Bundle__c();
            bundle.Name = 'bundle';
            bundle.NE__RecurringChargeFrequency__c = 'Monthly';
            bundle.NE__Start_Date__c = Date.newInstance(2018, 10, 10);
        insert bundle;

        Asset asset1 = new Asset();
            asset1.AccountId = merchant1.Id;
            asset1.Name = 'Test Asset';
            asset1.OB_ProposerABI__c = bank1.Id;
            asset1.OB_ServicePointCode__c = '2222';
            asset1.OB_TermId__c = '3333';
            asset1.OB_CompanyCode__c = '4444';
            asset1.OB_ShopCode__c = '5555';
            asset1.NE__Bundle__c = bundle.id;
            asset1.NE__Order_Config__c = ord.id;
            asset1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Asset' AND DeveloperName = 'Standard'].id;
        insert asset1;

        //LUBRANO -- 2019-03-29 --BANK WITH BLANK ABI FOR COVERAGE searchOnAsset AND retriveBankOwner
        Asset asset2 = new Asset();
            asset2.AccountId = merchant3.Id;
            asset2.Name = 'Test Asset 2';
            asset2.OB_ProposerABI__c = bank4.Id;
            asset2.OB_ServicePointCode__c = '2222';
            asset2.OB_TermId__c = '3333';
            asset2.OB_CompanyCode__c = '4444';
            asset2.OB_ShopCode__c = '5555';
            asset2.NE__Bundle__c = bundle.id;
            asset2.NE__Order_Config__c = ord2.id;
        insert asset2;        

        OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c(    OB_Bank__c = bank1.Id, 
                                                                    OB_GT__c = 'Nexi', 
                                                                    OB_Business_Model_POS__c = 'Bilaterale', 
                                                                    OB_Business_Model_Acquiring__c = 'Associate', 
                                                                    OB_Service_Type__c='Servizio GT',
                                                                    OB_Circuit__c = 'JCB;UPI',
                                                                    OB_Other_Acquirer__c = 'Amex;Diners',
                                                                    OB_SettlementType__c = 'Prepagato',
                                                                    OB_AccountHolder__c = false,
                                                                    OB_Applicant_RAC_Code_SIA__c = 'Nexi',
                                                                    OB_Terminal_Id_Generator__c = 'Nexi',
                                                                    OB_Technical_component_invoicing__c = 'Al p.v.',
                                                                    OB_Processor__c = 'EQUENS (KCCS)',
                                                                    OB_Sending_Contract_to_Nexi__c = 'NO',
                                                                    OB_SME_Factory__c = 'NO',
                                                                    OB_Bilateral_Pricing__c = 'NO'
                                                                    );    
        insert bankProfile;

        OB_Bank_Profile__c bankProfile2 = new OB_Bank_Profile__c(   OB_Bank__c = bank2.Id, 
                                                                    OB_GT__c = 'Nexi', 
                                                                    OB_Business_Model_POS__c = 'Bilaterale', 
                                                                    OB_Business_Model_Acquiring__c = 'Diretto', 
                                                                    OB_Service_Type__c='Servizio GT',
                                                                    OB_Circuit__c = 'JCB;UPI',
                                                                    OB_Other_Acquirer__c = 'Amex;Diners',
                                                                    OB_SettlementType__c = 'Prepagato',
                                                                    OB_AccountHolder__c = false,
                                                                    OB_Applicant_RAC_Code_SIA__c = 'Nexi',
                                                                    OB_Terminal_Id_Generator__c = 'Nexi',
                                                                    OB_Technical_component_invoicing__c = 'Al p.v.',
                                                                    OB_Processor__c = 'EQUENS (KCCS)',
                                                                    OB_Sending_Contract_to_Nexi__c = 'NO',
                                                                    OB_SME_Factory__c = 'NO',
                                                                    OB_Bilateral_Pricing__c = 'NO'
                                                                     
                                                                    );    
        insert bankProfile2;

        //LUBRANO -- 2019-03-29 --BANK WITH BLANK ABI FOR COVERAGE searchOnAsset AND retriveBankOwner
        OB_Bank_Profile__c bankProfile3 = new OB_Bank_Profile__c(   OB_Bank__c = bank4.Id, 
                                                                    OB_GT__c = 'Nexi', 
                                                                    OB_Business_Model_POS__c = 'Bilaterale', 
                                                                    OB_Business_Model_Acquiring__c = 'Servicing', 
                                                                    OB_Service_Type__c='Servizio GT',
                                                                    OB_Circuit__c = 'JCB;UPI',
                                                                    OB_Other_Acquirer__c = 'Amex;Diners',
                                                                    OB_SettlementType__c = 'Prepagato',
                                                                    OB_AccountHolder__c = false,
                                                                    OB_Applicant_RAC_Code_SIA__c = 'Nexi',
                                                                    OB_Terminal_Id_Generator__c = 'Nexi',
                                                                    OB_Technical_component_invoicing__c = 'Al p.v.',
                                                                    OB_Processor__c = 'EQUENS (KCCS)',
                                                                    OB_Sending_Contract_to_Nexi__c = 'NO',
                                                                    OB_SME_Factory__c = 'NO',
                                                                    OB_Bilateral_Pricing__c = 'NO'
                                                                     
                                                                    );    
        insert bankProfile3;
    }

    // @isTest
    // public static void searchOnAssetTest()
    // {
    //     UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    //     Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
    //     User portalAccountOwner = new User();
    //     portalAccountOwner.ProfileId = pAdmin.id;
    //     portalAccountOwner.Username ='portalAccountOwner@test.com';
    //     portalAccountOwner.Alias = 'alias';
    //     portalAccountOwner.Email='portalAccountOwner@test.com';
    //     portalAccountOwner.EmailEncodingKey='UTF-8';
    //     portalAccountOwner.Firstname='firstName';
    //     portalAccountOwner.Lastname='lastName';
    //     portalAccountOwner.LanguageLocaleKey='en_US';
    //     portalAccountOwner.LocaleSidKey='en_US';
    //     portalAccountOwner.TimeZoneSidKey='America/Chicago';
    //     portalAccountOwner.UserRoleId = portalRole.id;
    //     insert portalAccountOwner;
        
    //     System.runAs(portalAccountOwner) {
        
    //         Account acc = [SELECT Id FROM Account WHERE Name = 'a'];            
    //         acc.ownerid = portalAccountOwner.id;
    //         update acc;
            
            
    //     }   
        
    //     Contact con = [SELECT Id FROM Contact WHERE LastName = 'c' LIMIT 1];
    //     Profile p = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'];
        
        
        
    //     User user = new User();
    //                 user.Username = 'user123123@test.com';
    //                 user.ContactId = con.id;
    //                 user.ProfileId = p.id;
    //                 user.Alias = 'alias';
    //                 user.Email = 'user@test.com';
    //                 user.EmailEncodingKey = 'UTF-8';
    //                 user.LastName = 'lastName';
    //                 user.CommunityNickname = 'test12345';
    //                 user.TimeZoneSidKey = 'America/Los_Angeles';
    //                 user.LocaleSidKey = 'en_US';
    //                 user.LanguageLocaleKey = 'en_US';
    //                 user.OB_CAB__c = '12345';
    //     insert user;

    //     OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
    //     searchWrapper.TerminalId = '3333';
    //     String jsonWrap = JSON.serialize(searchWrapper);
  
    //     System.runAs(user){ 
    //         Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT ).getRecordTypeId();
    //         Id rtBank = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
    //         Account bank1 = new Account();
    //             bank1.Name = 'bank1';
    //             bank1.OB_Employees_Number__c = 'Minore di 10'; 
    //             bank1.OB_VAT_Not_Present__c = true;
    //             bank1.OB_DescriptionVATNotPresent__c = 'description'; 
    //             bank1.NE__Fiscal_code__c = 'RSSMRA80A01F001B';
    //             bank1.OB_ABI__c = '05116';
    //             bank1.RecordTypeid = rtBank;
    //         insert bank1;
    //         Account a4 = new Account(   Name = 'a4', 
    //                                 OB_Employees_Number__c = 'Minore di 10', 
    //                                 OB_VAT_Not_Present__c = true, 
    //                                 OB_DescriptionVATNotPresent__c = 'description', 
    //                                 NE__Fiscal_code__c = 'RSSMRA80A01F210X',
    //                                 OB_ABI__c = '00112',
    //                                 RecordTypeid = rtMerchant,
    //                                 OB_Bank_owner__c = bank1.Id
    //                             );
    //         insert a4;

    //         NE__Order__c ord = new NE__Order__c();
    //         insert ord;

    //         NE__Bundle__c bundle = new NE__Bundle__c(Name = 'bundle', 
    //                                                 NE__RecurringChargeFrequency__c = 'Monthly',
    //                                                 NE__Start_Date__c = Date.newInstance(2018, 10, 10));
    //         insert bundle;

           

    //         NE__Service_Point__c sp = new NE__Service_Point__c(
    //                                 Name = 'Service Point Test',
    //                                 NE__Account__c = a4.Id
    //                             );
    //         insert sp;

    //         Asset ass = new Asset(  AccountId = a4.Id,
    //                                 Name = 'Test Asset',
    //                                 OB_ProposerABI__c = bank1.Id,
    //                                 OB_ServicePointCode__c = '2222',
    //                                 OB_TermId__c = '3333',
    //                                 OB_CompanyCode__c = '4444',
    //                                 OB_ShopCode__c = '5555',
    //                                 NE__Bundle__c = bundle.id,
    //                                 NE__Order_Config__c = ord.id,
    //                                 NE__Service_Point__c = sp.Id
    //                             );
    //         insert ass;

    // //     OB_MaintenanceSearch_Controller.SearchResultWrapper result = new OB_MaintenanceSearch_Controller.SearchResultWrapper(); 
    // //     result.acc                = acc;
    // //     result.executor           = esecutore;
    // //     result.legalOffice        = esecutore;
    // //     result.listOfServicePoint = listOfServicePoint;
    // //     result.executorModifiedAllowed = true;
    // //    // result.selectedAsset      = ass;

    //         System.debug('ASSET insert: '+ass);
    //         Test.startTest();
    //         OB_MaintenanceSearch_Controller.search(jsonWrap);
    //         Test.stopTest();
    //     }
    // }

    // @isTest
    // public static void searchOnAssetMultipleTest()
    // {
        
    //     UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    //     Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
    //     User portalAccountOwner = new User();
    //     portalAccountOwner.ProfileId = pAdmin.id;
    //     portalAccountOwner.Username ='portalAccountOwner@test.com';
    //     portalAccountOwner.Alias = 'alias';
    //     portalAccountOwner.Email='portalAccountOwner@test.com';
    //     portalAccountOwner.EmailEncodingKey='UTF-8';
    //     portalAccountOwner.Firstname='firstName';
    //     portalAccountOwner.Lastname='lastName';
    //     portalAccountOwner.LanguageLocaleKey='en_US';
    //     portalAccountOwner.LocaleSidKey='en_US';
    //     portalAccountOwner.TimeZoneSidKey='America/Chicago';
    //     portalAccountOwner.UserRoleId = portalRole.id;
    //     insert portalAccountOwner;
        
    //     System.runAs(portalAccountOwner) {
        
    //         Account acc = [SELECT Id FROM Account WHERE Name = 'a'];            
    //         acc.ownerid = portalAccountOwner.id;
    //         update acc;
            
            
    //     }   
        
    //     Contact con = [SELECT Id FROM Contact WHERE LastName = 'c' LIMIT 1];
    //     Profile p = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'];
        
        
        
    //     User user = new User();
    //                 user.Username = 'user123123@test.com';
    //                 user.ContactId = con.id;
    //                 user.ProfileId = p.id;
    //                 user.Alias = 'alias';
    //                 user.Email = 'user@test.com';
    //                 user.EmailEncodingKey = 'UTF-8';
    //                 user.LastName = 'lastName';
    //                 user.CommunityNickname = 'test12345';
    //                 user.TimeZoneSidKey = 'America/Los_Angeles';
    //                 user.LocaleSidKey = 'en_US';
    //                 user.LanguageLocaleKey = 'en_US';
    //                 user.OB_CAB__c = '12345';
    //     insert user;

       
  
  
    //     //Account a2 = [SELECT Id FROM Account WHERE Name = 'a2'];

    //     System.runAs(user)
    //     {
    //         NE__Order__c ord = new NE__Order__c();
    //         insert ord;

    //         NE__Bundle__c bundle = new NE__Bundle__c();
    //         bundle.Name = 'bundle';
    //         bundle.NE__RecurringChargeFrequency__c = 'Monthly';
    //         bundle.NE__Start_Date__c = Date.newInstance(2018, 10, 10);
    //         insert bundle;

    //         Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT ).getRecordTypeId();
    //         Id rtBank = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
    //         Account bank1 = new Account();
    //             bank1.Name = 'bank1';
    //             bank1.OB_Employees_Number__c = 'Minore di 10'; 
    //             bank1.OB_VAT_Not_Present__c = true;
    //             bank1.OB_DescriptionVATNotPresent__c = 'description'; 
    //             bank1.NE__Fiscal_code__c = 'RSSMRA80A01F001B';
    //             bank1.OB_ABI__c = '05116';
    //             bank1.RecordTypeid = rtBank;
    //         insert bank1;
    //         Account a4 = new Account(   Name = 'a4', 
    //                                 OB_Employees_Number__c = 'Minore di 10', 
    //                                 OB_VAT_Not_Present__c = true, 
    //                                 OB_DescriptionVATNotPresent__c = 'description', 
    //                                 NE__Fiscal_code__c = 'RSSMRA80A01F210X',
    //                                 OB_ABI__c = '00112',
    //                                 RecordTypeid = rtMerchant,
    //                                 OB_Bank_owner__c = bank1.Id
    //                             );
    //         insert a4;
        
    //         NE__Service_Point__c sp = new NE__Service_Point__c(
    //                                 Name = 'Service Point Test',
    //                                 NE__Account__c = a4.Id
    //                             );
    //         insert sp;

           

            

    //         Asset ass = new Asset(  AccountId = a4.Id,
    //                                 Name = 'Test Asset',
    //                                 OB_ProposerABI__c = bank1.Id,
    //                                 OB_ServicePointCode__c = '2222',
    //                                 OB_TermId__c = '3333',
    //                                 OB_CompanyCode__c = '4444',
    //                                 OB_ShopCode__c = '5555',
    //                                 NE__Bundle__c = bundle.id,
    //                                 NE__Order_Config__c = ord.id,
    //                                 NE__Service_Point__c = sp.Id
    //                             );
    //         insert ass;

    //         Asset ass2 = new Asset(  AccountId = a4.Id,
    //                                 Name = 'Test Asset 2',
    //                                 OB_ProposerABI__c = bank1.Id,
    //                                 OB_ServicePointCode__c = '2222',
    //                                 OB_TermId__c = '3333',
    //                                 OB_CompanyCode__c = '4444',
    //                                 OB_ShopCode__c = '5555',
    //                                 NE__Bundle__c = bundle.id,
    //                                 NE__Order_Config__c = ord.id,
    //                                 NE__Service_Point__c = sp.Id
    //                             ); 
    //         insert ass2;
 
    //    OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
    //     /*searchWrapper.AccountName = '';*/ 
    //     searchWrapper.ServicePoint = sp.Id;
    //     //searchWrapper.SIACode = '1111'; 
    //     //searchWrapper.SiaEstablishment = '2222'; 
    //     searchWrapper.TerminalId = '3333';
    //     //searchWrapper.MoneticaCustomerCode = '4444';
    //     //searchWrapper.MoneticaEstablishmentCode = '5555';
    //     String jsonWrap = JSON.serialize(searchWrapper);
    //         System.debug('ASSET insert: '+ass);

    //         OB_MaintenanceSearch_Controller.search(jsonWrap);
    //     }
    // }

    // @isTest
    // public static void searchOnAssetExternalTest()
    // {
    //      //NE__Service_Point__c sp = [SELECT Id FROM NE__Service_Point__c WHERE Name = 'Service Point Test']; 
        
    //     UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    //     Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
    //     User portalAccountOwner = new User();
    //     portalAccountOwner.ProfileId = pAdmin.id;
    //     portalAccountOwner.Username ='portalAccountOwner@test.com';
    //     portalAccountOwner.Alias = 'alias';
    //     portalAccountOwner.Email='portalAccountOwner@test.com';
    //     portalAccountOwner.EmailEncodingKey='UTF-8';
    //     portalAccountOwner.Firstname='firstName';
    //     portalAccountOwner.Lastname='lastName';
    //     portalAccountOwner.LanguageLocaleKey='en_US';
    //     portalAccountOwner.LocaleSidKey='en_US';
    //     portalAccountOwner.TimeZoneSidKey='America/Chicago';
    //     portalAccountOwner.UserRoleId = portalRole.id;
    //     insert portalAccountOwner;
        
    //     System.runAs(portalAccountOwner) {
        
    //         Account acc = [SELECT Id FROM Account WHERE Name = 'a'];            
    //         acc.ownerid = portalAccountOwner.id;
    //         update acc;
            
            
    //     }   
        
    //     Contact con = [SELECT Id FROM Contact WHERE LastName = 'c' LIMIT 1];
    //     Profile p = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'];
        
        
        
    //     User user = new User();
    //                 user.Username = 'user123123@test.com';
    //                 user.ContactId = con.id;
    //                 user.ProfileId = p.id;
    //                 user.Alias = 'alias';
    //                 user.Email = 'user@test.com';
    //                 user.EmailEncodingKey = 'UTF-8';
    //                 user.LastName = 'lastName';
    //                 user.CommunityNickname = 'test12345';
    //                 user.TimeZoneSidKey = 'America/Los_Angeles';
    //                 user.LocaleSidKey = 'en_US';
    //                 user.LanguageLocaleKey = 'en_US';
    //                 user.OB_CAB__c = '12345';
    //     insert user;

    //     OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
    //     /*searchWrapper.AccountName = '';*/ 
    //     //searchWrapper.ServicePoint = sp.Id;
    //     //searchWrapper.SIACode = '1111'; 
    //     //searchWrapper.SiaEstablishment = '2222'; 
    //     searchWrapper.TerminalId = '3333';
    //     //searchWrapper.MoneticaCustomerCode = '4444';
    //     //searchWrapper.MoneticaEstablishmentCode = '5555';
    //     String jsonWrap = JSON.serialize(searchWrapper);
  
    //     //Account a2 = [SELECT Id FROM Account WHERE Name = 'a2'];

    //     System.runAs(user){ 
    //         Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT ).getRecordTypeId();
    //         Id rtBank = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
    //         Account bank2 = new Account();
    //             bank2.Name = 'bank2';
    //             bank2.OB_Employees_Number__c = 'Minore di 10'; 
    //             bank2.OB_VAT_Not_Present__c = true;
    //             bank2.OB_DescriptionVATNotPresent__c = 'description'; 
    //             bank2.NE__Fiscal_code__c = 'RSSMRA80A01F002B';
    //             bank2.OB_ABI__c = '05116';
    //             bank2.RecordTypeid = rtBank;
    //         insert bank2;
    //         Account a4 = new Account(   Name = 'a4', 
    //                                 OB_Employees_Number__c = 'Minore di 10', 
    //                                 OB_VAT_Not_Present__c = true, 
    //                                 OB_DescriptionVATNotPresent__c = 'description', 
    //                                 NE__Fiscal_code__c = 'RSSMRA80A01F210X',
    //                                 OB_ABI__c = '00112',
    //                                 RecordTypeid = rtMerchant,
    //                                 OB_Bank_owner__c = bank2.Id
    //                             );
    //         insert a4;

    //         NE__Order__c ord = new NE__Order__c();
    //         insert ord;

    //         NE__Bundle__c bundle = new NE__Bundle__c(Name = 'bundle', 
    //                                                 NE__RecurringChargeFrequency__c = 'Monthly',
    //                                                 NE__Start_Date__c = Date.newInstance(2018, 10, 10));
    //         insert bundle;

           

    //         NE__Service_Point__c sp = new NE__Service_Point__c(
    //                                 Name = 'Service Point Test',
    //                                 NE__Account__c = a4.Id
    //                             );
    //         insert sp;

    //         Asset ass = new Asset(  AccountId = a4.Id,
    //                                 Name = 'Test Asset',
    //                                 OB_ProposerABI__c = bank2.Id,
    //                                 OB_ServicePointCode__c = '2222',
    //                                 OB_TermId__c = '3332',
    //                                 OB_CompanyCode__c = '4444',
    //                                 OB_ShopCode__c = '5555',
    //                                 NE__Bundle__c = bundle.id,
    //                                 NE__Order_Config__c = ord.id,
    //                                 NE__Service_Point__c = sp.Id
    //                             );
    //         insert ass;

    //         ExternalSourceMapping__c    esm = new ExternalSourceMapping__c(
    //                                     OB_Merchant_ID__c = a4.Id,
    //                                     OB_ServicePointCodeShopCode__c = sp.Id
    //                             );
    //         insert esm;

    //         searchWrapper.ServicePoint = sp.Id;
    //         jsonWrap = JSON.serialize(searchWrapper);

    //         System.debug('ASSET insert: '+ass);

    //         OB_MaintenanceSearch_Controller.search(jsonWrap);
    //     }
    // }
    
    // @isTest
    // public static void searchfromAccountTest(){
    //     OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
    //     searchWrapper.AccountName = 'RSSMRA80A01F205X';
    //     searchWrapper.ServicePoint = '';
    //     searchWrapper.SIACode = '';
    //     searchWrapper.SiaEstablishment = '';
    //     searchWrapper.TerminalId = '';
    //     searchWrapper.MoneticaCustomerCode = '';
    //     searchWrapper.MoneticaEstablishmentCode = '';

    //     UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    //     Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
    //     User portalAccountOwner = new User();
    //     portalAccountOwner.ProfileId = pAdmin.id;
    //     portalAccountOwner.Username ='portalAccountOwner@test.com';
    //     portalAccountOwner.Alias = 'alias';
    //     portalAccountOwner.Email='portalAccountOwner@test.com';
    //     portalAccountOwner.EmailEncodingKey='UTF-8';
    //     portalAccountOwner.Firstname='firstName';
    //     portalAccountOwner.Lastname='lastName';
    //     portalAccountOwner.LanguageLocaleKey='en_US';
    //     portalAccountOwner.LocaleSidKey='en_US';
    //     portalAccountOwner.TimeZoneSidKey='America/Chicago';
    //     portalAccountOwner.UserRoleId = portalRole.id;
    //     insert portalAccountOwner;
        
    //     System.runAs(portalAccountOwner) {
        
    //         Account acc = [SELECT Id FROM Account WHERE Name = 'a'];            
    //         acc.ownerid = portalAccountOwner.id;
    //         update acc;
            
            
    //     }   
        
    //     Contact con = [SELECT Id FROM Contact WHERE LastName = 'c' LIMIT 1];
    //     Profile p = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'];
        
        
        
    //     User user = new User();
    //                 user.Username = 'user123123@test.com';
    //                 user.ContactId = con.id;
    //                 user.ProfileId = p.id;
    //                 user.Alias = 'alias';
    //                 user.Email = 'user@test.com';
    //                 user.EmailEncodingKey = 'UTF-8';
    //                 user.LastName = 'lastName';
    //                 user.CommunityNickname = 'test12345';
    //                 user.TimeZoneSidKey = 'America/Los_Angeles';
    //                 user.LocaleSidKey = 'en_US';
    //                 user.LanguageLocaleKey = 'en_US';
    //                 user.OB_CAB__c = '12345';
    //     insert user;

    //     System.runAs(user){ 
    //         String jsonWrap = JSON.serialize(searchWrapper);
    //         OB_MaintenanceSearch_Controller.search(jsonWrap);
    //     }
    // }

    // @isTest
    // public static void searchfromAccountErrTest(){
    //     OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
    //     searchWrapper.AccountName = '';
    //     searchWrapper.ServicePoint = '';
    //     searchWrapper.SIACode = '';
    //     searchWrapper.SiaEstablishment = '';
    //     searchWrapper.TerminalId = ''; 
    //     searchWrapper.MoneticaCustomerCode = '';
    //     searchWrapper.MoneticaEstablishmentCode = '';
    //     String jsonWrap = JSON.serialize(searchWrapper);
    //     OB_MaintenanceSearch_Controller.search(jsonWrap);
    // }

    @isTest
    public static void ExternalSourceMappingTest(){
        //NE__Service_Point__c sp = [SELECT Id FROM NE__Service_Point__c ]; //WHERE Name = 'spBank1'
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'][0];
        
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
        
        Contact con = [SELECT Id, AccountId, Email FROM Contact WHERE LastName = 'c' LIMIT 1];
        
        User userTest = OB_TestDataFactory.getCommunityUserWithInsert(con);

        NE__Service_Point__c sp = new NE__Service_Point__c();
        sp.NE__Street__c = 'Lepetit';
        sp.OB_MCC_Description__c = 'descr2';
        sp.OB_Service_Point_Name__c = 'SPname';
        
        

        OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
        /*searchWrapper.AccountName = '';*/ 
        searchWrapper.ServicePoint = sp.id;
        searchWrapper.SIACode = '1111'; 
        searchWrapper.SiaEstablishment = '2222'; 
        searchWrapper.TerminalId = '12345679';
        searchWrapper.MoneticaCustomerCode = '4444';
        searchWrapper.MoneticaEstablishmentCode = '5555';
        searchWrapper.AccountName = 'pippo';
        searchWrapper.VatNumber = '1234567';
        String jsonWrap = JSON.serialize(searchWrapper);
  


        System.runAs(userTest)
        { 
            Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT ).getRecordTypeId();
            Id rtBank = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();

            

            Account bank1 = new Account();
                bank1.Name = 'bank1';
                bank1.OB_Employees_Number__c = 'Minore di 10'; 
                bank1.OB_VAT_Not_Present__c = true;
                bank1.OB_DescriptionVATNotPresent__c = 'description'; 
                bank1.NE__Fiscal_code__c = 'RSSMRA80A01F001B';
                bank1.OB_ABI__c = '05116';
                bank1.RecordTypeid = rtBank;
            insert bank1;

            Account a4 = new Account(   Name = 'a4', 
                                    OB_Employees_Number__c = 'Minore di 10', 
                                    OB_VAT_Not_Present__c = true, 
                                    OB_DescriptionVATNotPresent__c = 'description', 
                                    NE__Fiscal_code__c = 'RSSMRA80A01F210X',
                                    OB_ABI__c = '00112',
                                    RecordTypeid = rtMerchant,
                                    OB_Bank_owner__c=bank1.id
                                   
                                );
            insert a4;
            

             OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c(    OB_Bank__c = bank1.Id, 
                                                                    OB_GT__c = 'Nexi', 
                                                                    OB_Business_Model_POS__c = 'Bilaterale', 
                                                                    OB_Business_Model_Acquiring__c = 'Associate', 
                                                                    OB_Service_Type__c='Servizio GT',
                                                                    OB_Circuit__c = 'JCB;UPI',
                                                                    OB_Other_Acquirer__c = 'Amex;Diners',
                                                                    OB_SettlementType__c = 'Prepagato',
                                                                    OB_AccountHolder__c = false,
                                                                    OB_Applicant_RAC_Code_SIA__c = 'Nexi',
                                                                    OB_Terminal_Id_Generator__c = 'Nexi',
                                                                    OB_Technical_component_invoicing__c = 'Al p.v.',
                                                                    OB_Processor__c = 'EQUENS (KCCS)',
                                                                    OB_Sending_Contract_to_Nexi__c = 'NO',
                                                                    OB_SME_Factory__c = 'NO',
                                                                    OB_Bilateral_Pricing__c = 'NO'
                                                                    );    
        insert bankProfile;
            // OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
            // bp.OB_Bank__c = bank1.Id;
            // bp.OB_Service_Type__c = 'Acquiring'; 
            // bp.OB_Business_Model_POS__c = 'Bilaterale'; 
            // bp.OB_Circuit__c = 'JCB'; 
            // bp.OB_Other_Acquirer__c = 'Amex';
            // bp.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
            // bp.OB_Terminal_Id_Generator__c  = 'Banca'; 
            // bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
            // bp.OB_GT__c = 'Nexi'; 
            // bp.OB_Processor__c = 'SIA SMAC'; 
            // bp.OB_Bilateral_Pricing__c = 'SI'; 
            // bp.OB_Sending_Contract_to_Nexi__c = 'SI'; 
            // bp.OB_SME_Factory__c = 'SI';
            // bp.OB_NeedBIO__c     = true;
            // insert bp;

            Account merchant = new Account();
        
        merchant.NE__VAT__c             = '05218600962';
        merchant.NE__Fiscal_code__c     = '05218600962';
        merchant.Name                   = 'STRADIVARIUS ITALIA SRL';
        merchant.OB_Legal_Form__c       = 'ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE'; 
        merchant.NE__E_mail__c          = 'test@gmail.it';
        merchant.OB_Employees_Number__c = 'Minore di 10';
        merchant.OB_Legal_Address_Street__c = 'POLO DELLA QUALITA\' ASI SUD MOD	';
        merchant.OB_Legal_Address_Street_Number__c   = '';
        merchant.OB_Legal_Address_Detail__c   = 'STUDIO DE MATTEIS	';
        merchant.OB_Legal_Address_ZIP__c      = '81025';
        merchant.OB_Legal_Address_City__c     = 'MARCIANISE';
        merchant.OB_Legal_Address_State_Code__c   = '';
        merchant.OB_Legal_Address_Country_Code__c = '';
        merchant.OB_No_Profit_Recipient_Class__c  = 'Senza tetto'; 
        merchant.OB_No_Profit_Class__c            = 'Fondazioni';
        merchant.RecordTypeId                     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bank').getRecordTypeId();
        
        insert merchant;

            Id rtExecutor = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ESECUTORE ).getRecordTypeId();
            Contact c4 = new Contact(   FirstName = 'Name Contact Test 4',
                                    LastName = 'LastName Contact Test 4',
                                    accountId = a4.Id, 
                                    recordtypeid = rtExecutor
                                ); 
            insert c4; 
            
            ExternalSourceMapping__c    esm = new ExternalSourceMapping__c(
                                        OB_Merchant_ID__c = merchant.id,
                                        OB_ServicePointCodeShopCode__c = sp.Id
                                );
            insert esm;
            OB_MaintenanceSearch_Controller.search(jsonWrap);
        }
    }

    // @isTest
    // public static void ExternalSourceMappingWithAssetTest(){
    //     //NE__Service_Point__c sp = [SELECT Id FROM NE__Service_Point__c WHERE Name = 'Service Point Test']; 
        
    //     UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    //     Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
    //     User portalAccountOwner = new User();
    //     portalAccountOwner.ProfileId = pAdmin.id;
    //     portalAccountOwner.Username ='portalAccountOwner@test.com';
    //     portalAccountOwner.Alias = 'alias';
    //     portalAccountOwner.Email='portalAccountOwner@test.com';
    //     portalAccountOwner.EmailEncodingKey='UTF-8';
    //     portalAccountOwner.Firstname='firstName';
    //     portalAccountOwner.Lastname='lastName';
    //     portalAccountOwner.LanguageLocaleKey='en_US';
    //     portalAccountOwner.LocaleSidKey='en_US';
    //     portalAccountOwner.TimeZoneSidKey='America/Chicago';
    //     portalAccountOwner.UserRoleId = portalRole.id;
    //     insert portalAccountOwner;
        
    //     System.runAs(portalAccountOwner) {
        
    //         Account acc = [SELECT Id FROM Account WHERE Name = 'a'];            
    //         acc.ownerid = portalAccountOwner.id;
    //         update acc;
            
            
    //     }   
        
    //     Contact con = [SELECT Id FROM Contact WHERE LastName = 'c' LIMIT 1];
    //     Profile p = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'];
        
        
        
    //     User user = new User();
    //                 user.Username = 'user123123@test.com';
    //                 user.ContactId = con.id;
    //                 user.ProfileId = p.id;
    //                 user.Alias = 'alias';
    //                 user.Email = 'user@test.com';
    //                 user.EmailEncodingKey = 'UTF-8';
    //                 user.LastName = 'lastName';
    //                 user.CommunityNickname = 'test12345';
    //                 user.TimeZoneSidKey = 'America/Los_Angeles';
    //                 user.LocaleSidKey = 'en_US';
    //                 user.LanguageLocaleKey = 'en_US';
    //                 user.OB_CAB__c = '12345';
    //     insert user;

    //     OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
    //     /*searchWrapper.AccountName = '';*/ 
    //     //searchWrapper.ServicePoint = sp.Id;
    //     searchWrapper.SIACode = '1111'; 
    //     searchWrapper.SiaEstablishment = '2222'; 
    //     searchWrapper.TerminalId = '3333';
    //     searchWrapper.MoneticaCustomerCode = '4444';
    //     searchWrapper.MoneticaEstablishmentCode = '5555';
    //     //String jsonWrap = JSON.serialize(searchWrapper);
  
    //     //Account a2 = [SELECT Id FROM Account WHERE Name = 'a2'];

    //     System.runAs(user){ 
    //          Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT ).getRecordTypeId();
    //         Id rtBank = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
    //         Account bank1 = new Account();
    //             bank1.Name = 'bank1';
    //             bank1.OB_Employees_Number__c = 'Minore di 10'; 
    //             bank1.OB_VAT_Not_Present__c = true;
    //             bank1.OB_DescriptionVATNotPresent__c = 'description'; 
    //             bank1.NE__Fiscal_code__c = 'RSSMRA80A01F001B';
    //             bank1.OB_ABI__c = '05116';
    //             bank1.RecordTypeid = rtBank;
    //         insert bank1;
    //         Account a4 = new Account(   Name = 'a4', 
    //                                 OB_Employees_Number__c = 'Minore di 10', 
    //                                 OB_VAT_Not_Present__c = true, 
    //                                 OB_DescriptionVATNotPresent__c = 'description', 
    //                                 NE__Fiscal_code__c = 'RSSMRA80A01F210X',
    //                                 OB_ABI__c = '00112',
    //                                 RecordTypeid = rtMerchant,
    //                                 OB_Bank_owner__c = bank1.Id
    //                             );
    //         insert a4;

    //         Id rtExecutor = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ESECUTORE ).getRecordTypeId();
    //         Contact c4 = new Contact(   FirstName = 'Name Contact Test 4',
    //                                 LastName = 'LastName Contact Test 4',
    //                                 accountId = a4.Id, 
    //                                 recordtypeid = rtExecutor
    //                             ); 
    //         insert c4; 
            
           

    //         NE__Order__c ord = new NE__Order__c();
    //         insert ord;

    //         NE__Bundle__c bundle = new NE__Bundle__c(Name = 'bundle', 
    //                                                 NE__RecurringChargeFrequency__c = 'Monthly',
    //                                                 NE__Start_Date__c = Date.newInstance(2018, 10, 10));
    //         insert bundle;
 
    //         NE__Service_Point__c sp = new NE__Service_Point__c(
    //                                 Name = 'Service Point Test',
    //                                 NE__Account__c = a4.Id
    //                             );
    //         insert sp;

    //         ExternalSourceMapping__c    esm = new ExternalSourceMapping__c(
    //                                     OB_Merchant_ID__c = a4.Id,
    //                                     OB_ServicePointCodeShopCode__c = sp.Id,
    //                                     OB_Service_Point_ID__c = sp.Id
    //                             );
    //         insert esm;

    //         Asset ass = new Asset(  AccountId = a4.Id,
    //                                 Name = 'Test Asset',
    //                                 OB_CustomerCode__c = '1111',
    //                                 OB_ProposerABI__c = bank1.Id,
    //                                 OB_ServicePointCode__c = '2222',
    //                                 OB_TermId__c = '3333',
    //                                 OB_CompanyCode__c = '4444',
    //                                 OB_ShopCode__c = '5555',
    //                                 NE__Bundle__c = bundle.id,
    //                                 NE__Order_Config__c = ord.id,
    //                                 NE__Service_Point__c = sp.Id

    //                             );
    //         insert ass;

    //         searchWrapper.ServicePoint = sp.Id; 
    //         String jsonWrap = JSON.serialize(searchWrapper);

    //         OB_MaintenanceSearch_Controller.search(jsonWrap);
    //     }
    // }
    
    @isTest
    public static void searchOnExternalSourceMappingNoServiceListTest(){
        //NE__Service_Point__c sp = new NE__Service_Point__c(Name = 'Bella Location');
        //insert sp;
        // NE__Service_Point__c sp= [SELECT Id FROM NE__Service_Point__c WHERE Name = 'Bella Location']; 
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'][0];
        
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
        
        Contact con = [SELECT Id, AccountId, Email FROM Contact WHERE LastName = 'c' LIMIT 1];
        
        User userTest = OB_TestDataFactory.getCommunityUserWithInsert(con);

        OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
        OB_MaintenanceSearch_Controller.SearchResultWrapper result  = new OB_MaintenanceSearch_Controller.SearchResultWrapper();
        /*searchWrapper.AccountName = '';*/ 
        //no service point!!
        //searchWrapper.ServicePoint = sp.Id;
        searchWrapper.SIACode = '1111'; 
        searchWrapper.SiaEstablishment = '2222'; 
        searchWrapper.TerminalId = '3333';
        searchWrapper.MoneticaCustomerCode = '4444';
        searchWrapper.MoneticaEstablishmentCode = '5555';
        String jsonWrap = JSON.serialize(searchWrapper);
  
        //Account a2 = [SELECT Id FROM Account WHERE Name = 'a2'];

        System.runAs(userTest){
            Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT ).getRecordTypeId();
            Id rtBank = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
            Account bank1 = new Account();
                bank1.Name = 'bank1';
                bank1.OB_Employees_Number__c = 'Minore di 10'; 
                bank1.OB_VAT_Not_Present__c = true;
                bank1.OB_DescriptionVATNotPresent__c = 'description'; 
                bank1.NE__Fiscal_code__c = 'RSSMRA80A01F001B';
                bank1.OB_ABI__c = '05116';
                bank1.RecordTypeid = rtBank;
            insert bank1;
           /* Account acc = new Account();
            acc.Name = 'Test';
            acc.NE__E_mail__c  = 'test@null.it';
            acc.OB_Employees_Number__c = 'Minore di 10';
            acc.NE__VAT__c  = '12345678901';
            acc.NE__Fiscal_code__c= '12345678901';
            acc.OB_VAT_Not_Present__c = false;
            insert acc;*/
            Account a4 = new Account(   Name = 'a4', 
                                    OB_Employees_Number__c = 'Minore di 10', 
                                    OB_VAT_Not_Present__c = true, 
                                    OB_DescriptionVATNotPresent__c = 'description', 
                                    NE__Fiscal_code__c = 'RSSMRA80A01F211X',
                                    OB_ABI__c = '05116',
                                    RecordTypeid = rtMerchant,
                                    OB_Bank_owner__c = bank1.Id
                                );
            insert a4;

            Id rtExecutor = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ESECUTORE ).getRecordTypeId();
            Contact c3 = new Contact(   FirstName = 'Name Contact Test 3',
                                    LastName = 'LastName Contact Test 3',
                                    accountId = a4.Id, 
                                    recordtypeid = rtExecutor
                                ); 
            insert c3; 

            Asset ass2 = new Asset(     AccountId = a4.Id,
                                        Name = 'Test Asset',
                                        OB_ProposerABI__c = bank1.Id,
                                        OB_ServicePointCode__c = '2222',
                                        OB_TermId__c = '3333',
                                        OB_CompanyCode__c = '4444',
                                        OB_ShopCode__c = '5555' 
                                    );
            insert ass2;
            //no service point!
          /*  ExternalSourceMapping__c    esm = new ExternalSourceMapping__c(
                                        OB_Merchant_ID__c = a4.Id
                                        //OB_ServicePointCodeShopCode__c = sp.Id
                                );
            insert esm;*/
            
    //String  result =    OB_MaintenanceSearch_Controller.searchfromAccount(jsonWrap);
            

           OB_MaintenanceSearch_Controller.searchOnExternalSourceMapping(searchWrapper, result);
           OB_MaintenanceSearch_Controller.searchByOtherKeys(searchWrapper); 
           
           searchWrapper.ServicePoint = '2222';
           OB_MaintenanceSearch_Controller.searchByOtherKeys(searchWrapper); 
           //this method calls searchOnExternalSourceMapping
        }
        OB_MaintenanceSearch_Controller.searchOnExternalSourceMapping(searchWrapper, result);
        
    }
    
    
    
    

    @isTest
    public static void countAccountidTest()
    {
        Account acc = new Account(Name = 'acc', 
                                OB_Employees_Number__c = 'Minore di 10', 
                                OB_VAT_Not_Present__c = true, 
                                OB_DescriptionVATNotPresent__c = 'description', 
                                NE__Fiscal_code__c = 'RSSMRA80A01F205X');
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        insert acc;
        Asset asset = new Asset(Name = 'asset', AccountId = acc.id);
        asset.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Asset' AND DeveloperName = 'Standard'].id;
        insert asset;
        list<Asset> listOfAsset = new List<Asset>();
        listOfAsset.add(asset);
        
        list<ExternalSourceMapping__c> listOfExternalSource = new list<ExternalSourceMapping__c>();
        ExternalSourceMapping__c externalSource = new ExternalSourceMapping__c();
        insert externalSource;
        listOfExternalSource.add(externalSource);           
        
        Test.startTest();
        OB_MaintenanceSearch_Controller.countAccountid(listOfAsset);
        OB_MaintenanceSearch_Controller.countAccountid(listOfExternalSource);
        Test.stopTest();
    }

    @isTest
    public static void retrieveAllDataFromAccountTest_Catch()
    {
        
        Account acc = new Account(Name = 'acc', 
                                OB_Employees_Number__c = 'Minore di 10', 
                                OB_VAT_Not_Present__c = true, 
                                OB_DescriptionVATNotPresent__c = 'description', 
                                NE__Fiscal_code__c = 'RSSMRA80A01F205X');
    
        Contact esecutore      = new Contact();
		esecutore.FirstName 					   = 'RIRI';
		esecutore.LastName 						   = 'TOTI';
		esecutore.OB_Fiscal_Code__c 			   = 'TTORRI00B01D150K';
		esecutore.OB_Document_Release_Authority__c = 'Comune' ;
		esecutore.OB_Document_Type__c 			   = 'Carta di Identità';
		esecutore.OB_Sex__c 					   = 'M';
		esecutore.OB_BypassValidation__c 		   = false;
		esecutore.OB_Document_Number__c 		   = '123erty644';
		esecutore.RecordTypeId                     = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Esecutore').getRecordTypeId();
		esecutore.AccountId                        = acc.id;

        insert esecutore;

        NE__Service_Point__c sp = new NE__Service_Point__c(	NE__Account__c = acc.Id,
															Name='TEST',
															OB_Status__c='Inactive');
		insert sp;

        // Asset ass = new Asset(Name = 'asset', AccountId = acc.id, ContactId = esecutore.id);
        // insert ass;

        list<NE__Service_Point__c> listOfServicePoint = new list<NE__Service_Point__c>();
        listOfServicePoint.add(sp);
        

        OB_MaintenanceSearch_Controller.SearchResultWrapper result = new OB_MaintenanceSearch_Controller.SearchResultWrapper(); 
        result.acc                = acc;
        result.executor           = esecutore;
        result.legalOffice        = esecutore;
        result.listOfServicePoint = listOfServicePoint;
        result.executorModifiedAllowed = true;
       // result.selectedAsset      = ass;


        String terminalId = '';
        Id rtLegalEntity = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.DATI_SOCIETA_LEGALE ).getRecordTypeId();
        Id rtExecutor    = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Esecutore').getRecordTypeId();
        Contact con = new Contact(LastName = 'ln', RecordTypeId = rtExecutor, AccountId = acc.Id);
        insert con;
        Contact con1 = new Contact(LastName = 'toti', RecordTypeId = rtLegalEntity, AccountId = acc.Id);
        insert con1;
        /*List<Contact> listOfContact =new List<Contact>();
        listOfContact.add(con);
        listOfContact.add(con1);*/
        Test.startTest();
        OB_MaintenanceSearch_Controller.retrieveAllDataFromAccount(result, terminalId);
        Test.stopTest();
    }
    
       @isTest
    //try 
    public static void retrieveAllDataFromAccountTestTry()
    {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    	Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'][0];
    	
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
    	
    	Contact con = [SELECT Id, AccountId, Email FROM Contact WHERE LastName = 'c' LIMIT 1];
    	
    	User userTest = OB_TestDataFactory.getCommunityUserWithInsert(con);
      
        System.runAs(userTest)
        {
            OB_MaintenanceSearch_Controller.SearchResultWrapper result = new OB_MaintenanceSearch_Controller.SearchResultWrapper();  
            Account acc = new Account(Name = 'acc', 
                                      OB_Employees_Number__c = 'Minore di 10', 
                                      OB_VAT_Not_Present__c = true, 
                                      OB_DescriptionVATNotPresent__c = 'description', 
                                      NE__Fiscal_code__c = 'RSSMRA80A01F205X');
            result.acc = acc;
            String terminalId = '';
            Id rtLegalEntity = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.DATI_SOCIETA_LEGALE ).getRecordTypeId();
            Id rtExecutor = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Esecutore').getRecordTypeId();
            Contact cont = new Contact(LastName = 'ln', RecordTypeId = rtExecutor, AccountId = acc.Id);
            insert cont;
            Contact con1 = new Contact(LastName = 'toti', RecordTypeId = rtLegalEntity, AccountId = acc.Id);
            insert con1;
            Test.startTest();
            OB_MaintenanceSearch_Controller.retrieveAllDataFromAccount(result, terminalId);
            Test.stopTest();
        }
    }
    //14-02-2019-S.P.
    @isTest
    public static void retrieveAllDataFromAccount_Test()
    {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    	Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'][0];
    	
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
	    
	    System.runAs(portalAccountOwner) 
        {
    	
    		Account acc = [SELECT Id FROM Account WHERE Name = 'a'];    		
    		acc.ownerid = portalAccountOwner.id;
    		update acc;
    	}   
    	
    	Contact con = [SELECT Id, AccountId, Email FROM Contact WHERE LastName = 'c' LIMIT 1];
        User userTest = OB_TestDataFactory.getCommunityUserWithInsert(con);
      
        System.runAs(userTest)
        {
            OB_MaintenanceSearch_Controller.SearchResultWrapper result = new OB_MaintenanceSearch_Controller.SearchResultWrapper();  
            Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
            Account acc = new Account(Name = 'acc', 
                                      OB_Employees_Number__c = 'Minore di 10', 
                                      OB_VAT_Not_Present__c = true, 
                                      OB_DescriptionVATNotPresent__c = 'description', 
                                      NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                                      OB_ABI__c = '12345',
                                     RecordTypeId = rtMerchant);
            insert acc;
            result.acc = acc;
            String terminalId = '';
            Id rtLegalEntity = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.DATI_SOCIETA_LEGALE ).getRecordTypeId();
            Id rtExecutor = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Esecutore').getRecordTypeId();
            Contact cont = new Contact(LastName = 'ln', RecordTypeId = rtExecutor, AccountId = acc.Id);
            insert cont;
            Contact con1 = new Contact(LastName = 'toti', RecordTypeId = rtLegalEntity, AccountId = acc.Id);
            insert con1;
            Test.startTest();
            OB_MaintenanceSearch_Controller.retrieveAllDataFromAccount(result, terminalId);
            Test.stopTest();
        }
    }

    @isTest
    public static void retriveAccountInformationTest()
    {
        OB_MaintenanceSearch_Controller.SearchResultWrapper result = new OB_MaintenanceSearch_Controller.SearchResultWrapper(); 
        Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account acc = new Account(Name = 'acc', 
                                OB_Employees_Number__c = 'Minore di 10', 
                                OB_VAT_Not_Present__c = true, 
                                OB_DescriptionVATNotPresent__c = 'description', 
                                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                                RecordTypeId = rtMerchant);
        insert acc;
        String terminalId = '';
        
        
        Test.startTest();
        OB_MaintenanceSearch_Controller.retriveAccountInformation(result, acc.Id, terminalId);
        Test.stopTest();
    }


    @isTest
    public static void isInternalUserTest(){
        OB_MaintenanceSearch_Controller.isInternalUSer();
    }

    @isTest
    public static void searchfromAccountNexiTest(){
        OB_MaintenanceSearch_Controller.searchWrapper searchWrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
        searchWrapper.AccountName = 'RSSMRA80A01F205X';
        searchWrapper.ServicePoint = '';
        searchWrapper.SIACode = '';
        searchWrapper.SiaEstablishment = '';
        searchWrapper.TerminalId = '';
        searchWrapper.MoneticaCustomerCode = '';
        searchWrapper.MoneticaEstablishmentCode = '';

        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'][0];
        
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
        
        Contact con = [SELECT Id, AccountId, Email FROM Contact WHERE LastName = 'c' LIMIT 1];
        User userTest = OB_TestDataFactory.getCommunityUserWithInsert(con);

        String jsonWrap = JSON.serialize(searchWrapper);
        System.runAs(userTest){
            OB_MaintenanceSearch_Controller.search(jsonWrap);
            searchWrapper.ServicePoint = '222';
            
        }
        jsonWrap = JSON.serialize(searchWrapper);
        OB_MaintenanceSearch_Controller.search(jsonWrap);
    }
    
    //getAbi
    @isTest 
    static void getAbi_Test() 
    {
        //List<NE__Order__c> toReturn = null;
        //String contextABI;
        Test.startTest();
        OB_MaintenanceSearch_Controller.getAbi();
        Test.stopTest();
    }


    
//-------------------------------------- DD .-----------------------------------------//
    //retriveContactABI
    @isTest 
    static void retriveContactABI_Test() 
    {
         List<User> listOfUsers = [SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c FROM User WHERE Id = : userinfo.getuserid() LIMIT 1];
        Test.startTest();
        OB_MaintenanceSearch_Controller.retriveContactABI();
        Test.stopTest();
    }


    //searchOnAsset

    @isTest 
    static void searchOnAsset_Test() 
    {
        OB_MaintenanceSearch_Controller.searchWrapper      Wrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
        OB_MaintenanceSearch_Controller.SearchResultWrapper result = new OB_MaintenanceSearch_Controller.SearchResultWrapper();
        Account acc = new Account(Name = 'acc', 
                                OB_Employees_Number__c = 'Minore di 10', 
                                OB_VAT_Not_Present__c = true, 
                                OB_DescriptionVATNotPresent__c = 'description', 
                                NE__Fiscal_code__c = 'RSSMRA80A01F205X');
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        insert acc;
        Asset asset = new Asset(Name = 'asset', AccountId = acc.id);
        asset.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Asset' AND DeveloperName = 'Standard'].id;
        insert asset;
 
        OB_MaintenanceSearch_Controller.searchOnAsset(Wrapper,result);
 

        //LUBRANO -- 2019-03-29 --BANK WITH BLANK ABI FOR COVERAGE searchOnAsset AND retriveBankOwner

        NE__Order__c ord3 = new NE__Order__c();
        insert ord3;

        NE__Bundle__c bundle =[SELECT id  FROM NE__Bundle__c WHERE Name = 'bundle'];
        Account bank4 = [SELECT ID FROM Account WHERE nAME = 'bank4'];
        Account merchant3 = [SELECT ID FROM Account WHERE nAME = 'merchant3'];
        Asset asset3 = new Asset();
            asset3.AccountId = merchant3.id;
            asset3.Name = 'Test Asset 3';
            // asset3.OB_ProposerABI__c = bank4.Id;
            // asset3.OB_ServicePointCode__c = '2222';
            // asset3.OB_TermId__c = '3333';
            // asset3.OB_CompanyCode__c = '4444';
            // asset3.OB_ShopCode__c = '5555';
            // asset3.NE__Bundle__c = bundle.id;
            // asset3.NE__Order_Config__c = ord3.id;
        insert asset3; 
        asset.AccountId =  merchant3.id;
        update asset; 
        OB_MaintenanceSearch_Controller.searchOnAsset(Wrapper,result);
 

    }

 //-------------------------------------- DD .-----------------------------------------//   
@isTest 
static void searchfromAccount_Test() {


    Account merchant3 = [SELECT ID,name,NE__Fiscal_Code__c FROM Account WHERE name = 'merchant3' LIMIT 1];
    OB_MaintenanceSearch_Controller.searchWrapper Wrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
    OB_MaintenanceSearch_Controller.SearchResultWrapper result = new OB_MaintenanceSearch_Controller.SearchResultWrapper();
    merchant3.OB_status__c = 'Active';
    update merchant3;
	NE__Service_Point__c spBank1 = [SELECT ID  FROM NE__Service_Point__c WHERE Name = 'spBank1' LIMIT 1];
            
			
    Wrapper.AccountName = merchant3.NE__Fiscal_Code__c;
	// searchfromAccount(searchWrapper Wrapper  ,SearchResultWrapper result ,String merchantId , String servicePointId ,String abi)
    OB_MaintenanceSearch_Controller.searchfromAccount(Wrapper,result,merchant3.id,spBank1.Id,'123');
    // merchant3.OB_status__c = '';
    // update merchant3;
    // OB_MaintenanceSearch_Controller.searchfromAccount(Wrapper,result,merchant3.id,'');


}

    /**
    *@author Daniele Gandini <daniele.gandini@accenture.com>
    *@date 25/03/2019
    *@description Method tests getUserWrapper
    */
    @isTest 
    static void getUserWrapper_Test() {

        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL1Profile( ).Id;
            insert testCommunityUser;
        }
        System.runAs( testCommunityUser )
        {   
            Test.startTest();
            String userWrapper = OB_MaintenanceSearch_Controller.getUserWrapper();
            Test.stopTest();
            
        }
        
    }

    /**
    *@author Daniele Gandini <daniele.gandini@accenture.com>
    *@date 25/03/2019
    *@description Method tests getCABbyLov
    */
    @isTest 
    static void getCABbyLov_OK_Test() {

        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL1Profile( ).Id;
            insert testCommunityUser;
            system.debug('@@@@ useris' + testCommunityUser);
        }

        System.runAs( testCommunityUser )
        {   
            Test.startTest();
            List<NE__Lov__c> lovs = new List<NE__Lov__c>();
            NE__Lov__c lov1 = OB_TestDataFactory.getLov();
            lov1.Name = '12345';
            lov1.NE__Active__c = true;
            lov1.NE__Type__c = 'CAB';
            lov1.NE__Sub_Type__c = 'Tipologiche';
            lov1.NE__Value1__c = '03138';
            insert lov1;
            lovs.add(lov1);

            List<NE__Lov__c> lovList = OB_MaintenanceSearch_Controller.getCABbyLov();
            Test.stopTest();
            System.assertEquals(lovList[0].Id, lovs[0].Id);
        }
    }

    /**
    *@author Daniele Gandini <daniele.gandini@accenture.com>
    *@date 25/03/2019
    *@description Method tests getCABbyLov
    */
    @isTest 
    static void getCABbyLov_KO_Test() {

        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL1Profile( ).Id;
            insert testCommunityUser;
        }

        System.runAs( testCommunityUser )
        {   
            Test.startTest();
            List<NE__Lov__c> lovList = OB_MaintenanceSearch_Controller.getCABbyLov();
            Test.stopTest();
            System.assertEquals(null, lovList);
        }
    }

    /**
    *@author Daniele Gandini <daniele.gandini@accenture.com>
    *@date 25/03/2019
    *@description Method tests getCabValues
    */
    @isTest 
    static void getCabValues_OK_Test() {

        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL1Profile( ).Id;
            insert testCommunityUser;
        }

        System.runAs( testCommunityUser )
        {   
            List<String> cabs = new List<String>();
            String cabString = testCommunityUser.OB_CAB__c;
            cabs.add(cabString);

            Test.startTest();
            List<String> cabList = OB_MaintenanceSearch_Controller.getCabValues();
            Test.stopTest();
            System.assertEquals(cabs, cabList);
        }
    }

     /**
    *@author Daniele Gandini <daniele.gandini@accenture.com>
    *@date 25/03/2019
    *@description Method tests getInputToShow
    */
    @isTest 
    static void getInputToShow_Test() {
   
        List<OB_ConfigurationInformation__mdt> listOfConfigurationInformations = new List<OB_ConfigurationInformation__mdt>();
        List<String> strings = new List<String>();

        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User communityUserL2;
        System.runAs( portalAccountOwner )
        {
        listOfConfigurationInformations =    [SELECT    Id,
                                                        MasterLabel, 
                                                        Label, 
                                                        QualifiedApiName, 
                                                        OB_String_Value__c,
                                                        OB_String_Value_2__c
                                            FROM OB_ConfigurationInformation__mdt 
                                            WHERE QualifiedApiName = 'OB_MultiCABFirstStep'];
            
            if(!listOfConfigurationInformations.isEmpty()){
                for(OB_ConfigurationInformation__mdt metadata : listOfConfigurationInformations){
                    strings.add(metadata.OB_String_Value_2__c);
                }
            }

            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            communityUserL2 = OB_TestDataFactory.getCommunityUser( testContact );
            communityUserL2.ProfileId = OB_TestDataFactory.getNexiPartnerApproverL2Profile( ).Id;
            insert communityUserL2;
        }

        System.runAs( communityUserL2 )
        {   
            Test.startTest();
            List<String> listInputToShow = OB_MaintenanceSearch_Controller.getInputToShow();
            Test.stopTest();
            System.assertEquals(listInputToShow, strings);
        }

    }

	/*
	*	Author	:	Morittu	Andrea
	*	Date	:	04-Sep-2019
	*	Task	:	Covering countBundleId Method
	*/
    @isTest
    public static void countBundleId_Test() {
        
        NE__Bundle__c mainBundle = new NE__Bundle__c();
        mainBundle.NE__Active__c = true;
        mainBundle.NE__BaseRecurringCharge__c = 12345;
        mainBundle.NE__RecurringChargeFrequency__c = 'Monthly';
        mainBundle.NE__Start_Date__c	= System.today();
        mainBundle.NE__End_Date__c		= System.today().addYears(10);
        insert mainBundle;
        
        List<Asset> assetList = new List<Asset>();
        for(Integer i = 0; i < 10; i++) {
            Asset asset = OB_TestDataFactory.getAsset();
            asset.NE__Bundle__c = mainBundle.Id;
            insert asset;
            assetList.add(asset);
        }
        Test.startTest();
        	OB_MaintenanceSearch_Controller.countBundleId(assetList);
		Test.stopTest();
    }
    
    /* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Method testing retrieveObjectFieldsDetails()
    */
    @isTest
    public static void retrieveObjectFieldsDetails_Test(){
        String objectType = 'Account';
        Test.startTest();
        	OB_MaintenanceSearch_Controller.retrieveObjectFieldsDetails(objectType);
        Test.stopTest();
    }
    /* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Method testing retrieveMultipleAccountFromSearch()
    */
    @isTest
    public static void retrieveMultipleAccountFromSearch_Test(){
        Id recordTypeIdMerch  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT).getRecordTypeId();
        
       // Id recordTypeIdMerch  = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT).getRecordTypeId();
        
        Account acc = OB_TestDataFactory.getAccount();
        acc.Name = 'Acc 1';
        acc.NE__VAT__c = '12345678901';
        acc.RecordTypeId = recordTypeIdMerch;
       	acc.OB_Status__c = 'Active';
        insert acc;
        
        Account acc2 = OB_TestDataFactory.getAccount();
        acc2.Name = 'Acc 2';
        acc2.NE__VAT__c = '12345678901';
        acc2.RecordTypeId = recordTypeIdMerch;
        insert acc2;
        
        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint();
        sp.NE__Account__c = acc.Id;
        insert sp;
        
        List<Account> accList = new List<Account>();
        accList.add(acc);
        accList.add(acc2);
        
        Set<String> accListId = new Set<String>();
        accListId.add(acc.Id);
        accListId.add(acc2.Id);
        
        OB_MaintenanceSearch_Controller.searchWrapper wrapper = new OB_MaintenanceSearch_Controller.searchWrapper();
        wrapper.ServicePoint = sp.Id;
        wrapper.AccountName = acc.Name;
        wrapper.VatNumber = acc.NE__VAT__c;
        wrapper.ABI 		= '05116';
        String jsonWrap = JSON.serialize(wrapper);
        
        OB_MaintenanceSearch_Controller.SearchResultWrapper result = new OB_MaintenanceSearch_Controller.SearchResultWrapper();
        result.outcome						=	'Operazione avvenuta con successo';
        result.acc							= 	acc;
		result.accountIds					=	accListId;
		result.accountList					=	accList;
        
    	
        
        Test.startTest();
            OB_MaintenanceSearch_Controller.retrieveMultipleAccountFromSearch(wrapper , result , result.accountIds , sp.Id, wrapper.abi);
        Test.stopTest();
        
    }
}