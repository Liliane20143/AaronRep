@isTest
public class OB_Maintenance_Flow_Override_Test 
{
    @isTest
    public static void validateTest()
    {
        
        String step2 =  'step2';
        String step3 = 'step3';
        String step4 = 'step4';
        String step5 = 'step5';
        
        Map<String, Object> data = new Map<String, Object>();
        List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
        bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();
        
        Test.startTest();
        OB_Maintenance_Flow_Override.validate(step2, data, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.validate(step3, data, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.validate(step4, data, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.validate(step5, data, stepsDefinition, dynamicWizardWrapper);
        Test.stopTest();
    }
    
    @isTest
    public static void overwriteNextTest()
    {
        
        String step1 = '1';
        String step5 = '5';
        
        Map<String, Object> data = new Map<String, Object>();
        List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
        bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();
        
        Test.startTest();
        OB_Maintenance_Flow_Override.overwriteNext(step1, data, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.overwriteNext(step5, data, stepsDefinition, dynamicWizardWrapper);
        Test.stopTest();
    }
    
    @isTest
    public static void overwritePreviousTest()
    {        
        String step2 = '2';
        String step4 = '4';
        String step5 = '5';
        String step6 = '6';
        
        Map<String, Object> data = new Map<String, Object>();
        List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
        bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();
        
        Test.startTest();
        OB_Maintenance_Flow_Override.overwritePrevious(step2, data, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.overwritePrevious(step4, data, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.overwritePrevious(step5, data, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.overwritePrevious(step6, data, stepsDefinition, dynamicWizardWrapper);
        Test.stopTest();
    }
    
    @isTest
    public static void overwriteSaveTest()
    {
        
        String step2 = '2';
        String step3 = '3';
        String step4 = '4';
        String step5 = '5';
        
        Map<String, Object> data = new Map<String, Object>();
        List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
        bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();
        String targetObjectKey = '';
        
        
        Test.startTest();
        OB_Maintenance_Flow_Override.overwriteSave(step2, data, stepsDefinition, dynamicWizardWrapper, targetObjectKey);
        OB_Maintenance_Flow_Override.overwriteSave(step3, data, stepsDefinition, dynamicWizardWrapper, targetObjectKey);
        OB_Maintenance_Flow_Override.overwriteSave(step4, data, stepsDefinition, dynamicWizardWrapper, targetObjectKey);
        OB_Maintenance_Flow_Override.overwriteSave(step5, data, stepsDefinition, dynamicWizardWrapper, targetObjectKey);
        Test.stopTest();
    }
    
    @isTest
    public static void overwriteExitTest()
    {
        
        String step = '';
        
        Map<String, Object> data = new Map<String, Object>();
        List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
        bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();
        String targetObjectKey = '';
        
        
        Test.startTest();
        OB_Maintenance_Flow_Override.overwriteExit(step, data, stepsDefinition, dynamicWizardWrapper, targetObjectKey);
        Test.stopTest();
    }
    
    @isTest
    public static void updateSectionTest()
    {
        
        bit2flow.DynamicWizardWrapper wizardWrapper = new bit2flow.DynamicWizardWrapper();
        String stepName = '';
        Integer sectionPos;
        Boolean hidden = true;
        
        Test.startTest();
        OB_Maintenance_Flow_Override.updateSection(wizardWrapper, stepName, sectionPos, hidden);
        Test.stopTest();
    }
    
    @isTest
    public static void executeMethodTest()
    {
        
        String step = '';
        Map<String, Object> data = new Map<String, Object>();
        String targetObjectKey            = '';
        String operationalDatamethod      = 'operationalData';
        String companyDataMethod          = 'companyData';
        String actualOwnerMethod          = 'actualOwner';
        String servicePointMethod         = 'servicePoint';
        String downloadDocumentMethod     = 'downloadDocument';
        String companyDataPreviousMethod  = 'companyDataPrevious';
        String servicePointPreviousMethod = 'servicePointPrevious';
        String riepilogoPreviousMethod    = 'riepilogoPrevious';
        String saveDraftMethod            = 'saveDraft';
        String elseMethod                 = 'else';
        
        List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
        bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();
        
        
        Test.startTest();
        OB_Maintenance_Flow_Override.executeMethod(step, data, targetObjectKey, operationalDatamethod, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.executeMethod(step, data, targetObjectKey, companyDataMethod, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.executeMethod(step, data, targetObjectKey, actualOwnerMethod, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.executeMethod(step, data, targetObjectKey, servicePointMethod, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.executeMethod(step, data, targetObjectKey, downloadDocumentMethod, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.executeMethod(step, data, targetObjectKey, companyDataPreviousMethod, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.executeMethod(step, data, targetObjectKey, servicePointPreviousMethod, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.executeMethod(step, data, targetObjectKey, riepilogoPreviousMethod, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.executeMethod(step, data, targetObjectKey, saveDraftMethod, stepsDefinition, dynamicWizardWrapper);
        OB_Maintenance_Flow_Override.executeMethod(step, data, targetObjectKey, elseMethod, stepsDefinition, dynamicWizardWrapper);
        Test.stopTest();
    }
    
    @isTest
    public static void init_Test()
    {
    
        Id recordTypeMerchant = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
        Id recordTypeResponsabile_Amministrativo = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Responsabile Amministrativo').getRecordTypeId();
        Id recordTypeReferente_Punto_Vendita     = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Referente Punto Vendita').getRecordTypeId();
        Id recordTypeReferente_Tecnico           = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Referente Tecnico').getRecordTypeId();
        Account a = new Account(Name = 'a', OB_Employees_Number__c = 'Minore di 10', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'description', NE__Fiscal_code__c = 'AAAAAA11A11A111A', RecordTypeId = recordTypeMerchant);
        insert a;
        Account bank = new Account();
        bank.Name = 'bank';
        bank.RecordTypeId = [SELECT Id FROM RecordType WHERE Developername = 'Bank' AND sObjectType = 'Account' LIMIT 1].id;
        bank.OB_Employees_Number__c = 'Minore di 10';
        bank.OB_VAT_Not_Present__c = true;
        bank.OB_DescriptionVATNotPresent__c = 'description';
        bank.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        bank.OB_BypassValidation__c = true;
        bank.OB_Status__c = 'Active'; 
        bank.OB_Year_constitution_company__c = 2018.0;
        insert bank;

        Contact responsabile_AmministrativoContact = new Contact();
        responsabile_AmministrativoContact.LastName = 'responsabile_AmministrativoContacttest';
        responsabile_AmministrativoContact.AccountId = a.id;
        responsabile_AmministrativoContact.OB_Bank__c = bank.id;
        responsabile_AmministrativoContact.OB_Contact_State__c = 'Active';
        responsabile_AmministrativoContact.RecordTypeId = recordTypeResponsabile_Amministrativo;
        insert responsabile_AmministrativoContact;
        
        Contact referente_Punto_VenditaContact = new Contact(LastName = 'referente_Punto_VenditaContacttest', recordTypeId = recordTypeReferente_Punto_Vendita);
        insert referente_Punto_VenditaContact;
        Contact referente_TecnicoContact = new Contact(LastName = 'referente_TecnicoContacttest', recordTypeId = recordTypeReferente_Tecnico);
        insert referente_TecnicoContact;
        
        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Diretto';
        oh.OB_ProposerABI__c = bank.id;
        insert oh;
        Contact c = new Contact();
        c.LastName = 'test';
        c.AccountId = a.id;
        c.OB_Bank__c = bank.id;
        c.OB_Contact_State__c = 'Active';
        c.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Esecutore' AND sObjectType = 'Contact' LIMIT 1].id;
        insert c;
//---------------------------------   DD   -------------- 09/02/2019 ------------------------------------------------------------//
        Contact c1 = new Contact();
        c1.LastName = 'test';
        c1.AccountId = a.id;
        c1.OB_Bank__c = bank.id;
        c1.OB_Contact_State__c = 'Active';
        c1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dati_Societ_Legale' AND sObjectType = 'Contact' LIMIT 1].id;
        insert c1;

        Contact c2 = new Contact();
        c2.LastName = 'test';
        c2.AccountId = a.id;
        c2.OB_Bank__c = bank.id;
        c2.OB_Contact_State__c = 'Active';
        c2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Titolare_Effettivo' AND sObjectType = 'Contact' LIMIT 1].id;
        insert c2;

        Contact c3 = new Contact();
        c3.LastName = 'test';
        c3.AccountId = a.id;
        c3.OB_Bank__c = bank.id;
        c3.OB_Contact_State__c = 'Active';
        c3.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Referente_Punto_Vendita' AND sObjectType = 'Contact' LIMIT 1].id;
        insert c3;

        Contact c4 = new Contact();
        c4.LastName = 'test';
        c4.AccountId = a.id;
        c4.OB_Bank__c = bank.id;
        c4.OB_Contact_State__c = 'Active';
        c4.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Referente_Tecnico' AND sObjectType = 'Contact' LIMIT 1].id;
        insert c4;


//---------------------------------   DD   -------------------------------------------------------------------------------------//
        NE__Service_Point__c sp = new NE__Service_Point__c();
        insert sp;
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c(NE__Account__c = a.id);
        insert bp;
        // NE__Billing_Profile__c bp1 = new NE__Billing_Profile__c(NE__Account__c = a.id);
        // insert bp1;
        NE__Order__c configuration = new NE__Order__c(OB_Service_Point__c = sp.id, NE__Order_Header__c = oh.id, NE__AccountId__c = a.id);
        // configuration.NE__BillingProfId__c        = bp1.id;
        configuration.OB_BankAccount_Acquiring__c = bp.id;
        insert configuration;
        
        String step = '';
        Map<String, Object> data = new Map<String, Object>();
        data.put('Configuration',configuration);
        Map<String, Object> mapUnbind = new Map<String, Object>();
        Map<String, Object> mapUser   = new Map<String, Object>();
        mapUnbind = (Map<String, Object>)JSON.deserializeUntyped('{ "sobjectType": "UNBIND", "RecordTypeId": "", "nextCheckout": "", "nextCheck": "", "orderId": "", "UNBIND7": "ACQUIRING", "UNBIND5": "", "UNBIND6": "", "DenominazioneSociale" : "" , "VAT_notPresent" : "", "InsegnaPv" : "", "yearOfConstitutionCompany": ""}');
        mapUser   = (Map<String, Object>)JSON.deserializeUntyped('{ "sobjectType": "USER", "RecordTypeId": "", "nextCheckout": "", "nextCheck": "", "orderId": "", "OB_CAB__c": "99999", "UNBIND5": "", "UNBIND6": "", "DenominazioneSociale" : "" , "VAT_notPresent" : "", "InsegnaPv" : "", "yearOfConstitutionCompany": ""}');
        data.put('unbind', mapUnbind);
        data.put('user',mapUser);

        List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
        bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();
        
        Test.startTest();
        OB_Maintenance_Flow_Override mfo = new OB_Maintenance_Flow_Override();
        mfo.init(step, data, stepsDefinition, dynamicWizardWrapper);
        Test.stopTest();
    }
    


    @isTest
    public static void save_Test()//APPROVAL PROCESS BIO 
    {
        Id recordTypeMerchant = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
        Id recordTypeBank     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bank').getRecordTypeId();
        Id recordTypeResponsabile_Amministrativo = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Responsabile Amministrativo').getRecordTypeId();
        Id recordTypeReferente_Punto_Vendita = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Referente Punto Vendita').getRecordTypeId();
        Id recordTypeReferente_Tecnico       = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Referente Tecnico').getRecordTypeId();
        Id recordTypeEsecutore               = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Esecutore').getRecordTypeId();

        Contact responsabile_AmministrativoContact = new Contact( LastName = 'responsabile_AmministrativoContacttest', 
                                                                  recordTypeId = recordTypeResponsabile_Amministrativo);
        insert responsabile_AmministrativoContact;

        Contact referente_Punto_VenditaContact     = new Contact( LastName = 'referente_Punto_VenditaContacttest', 
                                                                  recordTypeId = recordTypeReferente_Punto_Vendita);
        insert referente_Punto_VenditaContact;

        Contact referente_TecnicoContact           = new Contact( LastName = 'referente_TecnicoContacttest', 
                                                                  recordTypeId = recordTypeReferente_Tecnico);
        insert referente_TecnicoContact;

        Contact legale_rappresentante              = new Contact(  LastName = 'legale_rappresentante', 
                                                                recordTypeId = recordTypeEsecutore);
        insert legale_rappresentante;

        NE__Order_Header__c oh = new NE__Order_Header__c(OB_Business_Model_Acquiring__c = 'Diretto');
        insert oh;

        NE__Service_Point__c sp = new NE__Service_Point__c();
        insert sp;

        Account merchant = new Account(    Name = 'a', OB_Employees_Number__c = 'Minore di 10', 
                                           OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'description', 
                                           NE__Fiscal_code__c = 'AAAAAA11A11A111A', RecordTypeId = recordTypeMerchant, OB_ABI__c = '67543');
        insert merchant;  

        Account bankOwner = new Account(Name = 'bank Owner', 
                                        OB_Employees_Number__c = 'Minore di 10', 
                                        OB_VAT_Not_Present__c = true, 
                                        OB_DescriptionVATNotPresent__c = 'description', 
                                        NE__Fiscal_code__c = 'AAAAAA11A11A111A', 
                                        RecordTypeId = recordTypeBank);
        insert bankOwner;  

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c(NE__Account__c = merchant.id);
        insert bp;

        NE__Order__c configuration = new NE__Order__c(OB_Service_Point__c = sp.id, NE__Order_Header__c = oh.id, NE__AccountId__c = merchant.id);
        configuration.OB_AdditionalDocumentationRequired__c = true;
        insert configuration;

        List<NE__Order__c> configList = new List<NE__Order__c>();
        configList.add(configuration);

        OB_Bank_Profile__c  bankProfile = new OB_Bank_Profile__c();
        bankProfile.OB_NeedBIO__c                       = true;
        bankProfile.OB_Bank__c                          = bankOwner.id;
        bankProfile.OB_Service_Type__c                  = 'Servizio GT';
        bankProfile.OB_Business_Model_POS__c            = 'Bilaterale  ';
        bankProfile.OB_Circuit__c                       = 'JCB;UPI';
        bankProfile.OB_Other_Acquirer__c                = 'Amex;Diners';
        bankProfile.OB_Applicant_RAC_Code_SIA__c        = 'Nexi';
        bankProfile.OB_Terminal_Id_Generator__c         = 'Nexi';
        bankProfile.OB_Technical_component_invoicing__c = 'Al p.v.';
        bankProfile.OB_GT__c                            = 'Nexi';
        bankProfile.OB_Processor__c                     = 'EQUENS (KCCS)';
        bankProfile.OB_Bilateral_Pricing__c             = 'NO';
        bankProfile.OB_Sending_Contract_to_Nexi__c      = 'NO';
        bankProfile.OB_SME_Factory__c                   = 'NO';

        insert bankProfile;
//---------------------------------- DD ---- 09/02/2019---------------------- ELSE() -------//
         OB_Bank_Profile__c  bankProfile1 = new OB_Bank_Profile__c();
        bankProfile1.OB_NeedBIO__c                       = false;
        bankProfile1.OB_Bank__c                          = bankOwner.id;
        bankProfile1.OB_Service_Type__c                  = 'Servizio GT';
        bankProfile1.OB_Business_Model_POS__c            = 'Bilaterale  ';
        bankProfile1.OB_Circuit__c                       = 'JCB;UPI';
        bankProfile1.OB_Other_Acquirer__c                = 'Amex;Diners';
        bankProfile1.OB_Applicant_RAC_Code_SIA__c        = 'Nexi';
        bankProfile1.OB_Terminal_Id_Generator__c         = 'Nexi';
        bankProfile1.OB_Technical_component_invoicing__c = 'Al p.v.';
        bankProfile1.OB_GT__c                            = 'Nexi';
        bankProfile1.OB_Processor__c                     = 'EQUENS (KCCS)';
        bankProfile1.OB_Bilateral_Pricing__c             = 'NO';
        bankProfile1.OB_Sending_Contract_to_Nexi__c      = 'NO';
        bankProfile1.OB_SME_Factory__c                   = 'NO';
        insert bankProfile1;
//---------------------------------------- DD ----------------------------------------------//       

        List<NE__OrderItem__c> listOfItems = new List<NE__OrderItem__c>();
        NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        orderItem.NE__Action__c='Add';
        insert orderItem;
        listOfItems.add(orderItem);
        
        String step = '';
        String targetObjectKey = '';
        Map<String, Object> data = new Map<String, Object>();
        data.put('OrderHeader'  ,oh);
        data.put('bankProfile'  , bankProfile);
        data.put('Configuration', configuration);
        data.put('merchant' , merchant);
        data.put('pv',sp);
        data.put('legale_rappresentante' , legale_rappresentante);

//---------------------------------- DD ---- 09/02/2019-------------------------------------//
        Map<String, Object> data1 = new Map<String, Object>();
        data1.put('OrderHeader'  ,oh);
        data1.put('bankProfile'  , bankProfile1);
        data1.put('Configuration', configuration);
        data1.put('merchant' , merchant);
        data1.put('pv',sp);
        data1.put('legale_rappresentante' , legale_rappresentante);
//---------------------------------- DD ----------------------------------------------------//

        List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List<bit2flow.DynamicWizardWrapper.StepDefinitions>();
        bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();

        Group groupToSelect = new Group(Name = 'group name', Type = 'Queue');
        insert groupToSelect;
        Group groupToSelect1 = new Group(Name = 'group name', Type = 'Queue');
        insert groupToSelect1;
        List<Group> groupSelected   =  new List<Group> ();
        groupSelected.add(groupToSelect);
        groupSelected.add(groupToSelect1);

        Test.startTest();
        OB_Maintenance_Flow_Override mfo = new OB_Maintenance_Flow_Override();
        mfo.save(step, data, targetObjectKey, stepsDefinition, dynamicWizardWrapper);
        mfo.save(step, data1, targetObjectKey, stepsDefinition, dynamicWizardWrapper);// DD--- 09/02/2019
        Test.stopTest();
    }


    @isTest
    public static void createServicePointNode_Test()
    {
        
        NE__Service_Point__c spoint = new NE__Service_Point__c();
        insert spoint;
        List<NE__Service_Point__c> spList= new List<NE__Service_Point__c> () ;
        spList.add(spoint);
        
        String pvId = '';
        Test.startTest();
        OB_Maintenance_Flow_Override.createServicePointNode(spoint.id );
        Test.stopTest();  
        
    }
    
    @isTest
    public static void createMerchantNode_Test()
    {
        
        List<Account> accList= new List<Account> () ;
        Account merchant = new Account(
            Name='Test1',
            OB_Employees_Number__c='Minore di 10',
            OB_VAT_Not_Present__c=true, 
            OB_DescriptionVATNotPresent__c='description', 
            NE__Fiscal_code__c='RSSMRA80A01F205X',
            OB_BypassValidation__c=true,
            OB_Status__c='Active',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(OB_UtilityConstants.MERCHANTRT).getRecordTypeId()
            );
        insert merchant;
        accList.add(merchant);
        
        String merchantId = '';
        Test.startTest();
        OB_Maintenance_Flow_Override.createMerchantNode(merchant.id);
        Test.stopTest();  
        
    }
    @isTest
    public static void createOrderHeaderNode_Test()
    {
        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
        insert orderHeader;
        List<NE__Order_Header__c> ordHeadList = new List<NE__Order_Header__c>();
        ordHeadList.add(orderHeader);
        
        Test.startTest();
        OB_Maintenance_Flow_Override.createOrderHeaderNode(orderHeader.id);
        Test.stopTest();  
        
    } 
    
    @isTest
    public static void createConfigurationNode_Test()
    {
        
        NE__Order__c configuration = new NE__Order__c();
        insert configuration;
        List<NE__Order__c> configurationList = new List<NE__Order__c>();
        configurationList.add(configuration);
        
        Test.startTest();
        OB_Maintenance_Flow_Override.createConfigurationNode(configuration.id);
        Test.stopTest();  
        
    }
    @isTest
    public static void createContactsNodes_Test()
    {

        Account merchant = new Account(
            Name='Test1',
            OB_Employees_Number__c='Minore di 10',
            OB_VAT_Not_Present__c=true, 
            OB_DescriptionVATNotPresent__c='description', 
            NE__Fiscal_code__c='RSSMRA80A01F205X',
            OB_BypassValidation__c=true,
            OB_Status__c='Active',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(OB_UtilityConstants.MERCHANTRT).getRecordTypeId()
            );
        insert merchant;
        
        Contact nodes = new Contact (
            FirstName='RIRI',
            LastName='TOTI',
            OB_Fiscal_Code__c='TTORRI00B01D150K',
            OB_Document_Release_Authority__c='Comune',
            OB_Document_Type__c='Carta di Identità',
            OB_Sex__c='M',
            OB_BypassValidation__c=false, 
            OB_Document_Number__c ='123erty644');
        
        insert nodes;
        List<Contact> contactsNodes = new List<Contact>();
        contactsNodes.add(nodes);
        
        String accountId = ''; 
        String proposerABI = '';
        
        Test.startTest();
        OB_Maintenance_Flow_Override.createContactsNodes(merchant.Id, proposerABI);
        Test.stopTest();     
        
    }
    @isTest
    public static void getLookupsFromConfigurations_Test()
    {
        NE__Order__c order = new NE__Order__c();
        insert order;
        List<NE__Order__c> orderList=new List<NE__Order__c>(); 
        orderList.add(order);
        
        Test.startTest();
        OB_Maintenance_Flow_Override.getLookupsFromConfigurations(order.id);
        Test.stopTest();      
        
    }
    @isTest
    public static void createContactsSPNode_Test()
    {
        List<String> lookupSPContact = new List<String>();
        String merchantId = '';
        String proposerABI = '';

        
        Test.startTest();
        OB_Maintenance_Flow_Override.createContactsSPNode(merchantId, proposerABI, lookupSPContact );
        Test.stopTest();   
    }
    @isTest
    public static void createBankProfileNode_Test()
    {
        Id recordTypeBank     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bank').getRecordTypeId();

        Account bankOwner = new Account(Name = 'bank Owner', 
                                        OB_Employees_Number__c = 'Minore di 10', 
                                        OB_VAT_Not_Present__c = true, 
                                        OB_DescriptionVATNotPresent__c = 'description', 
                                        NE__Fiscal_code__c = 'AAAAAA11A11A111A', 
                                        RecordTypeId = recordTypeBank);
        insert bankOwner; 

        OB_Bank_Profile__c  bankProfile = new OB_Bank_Profile__c();
        bankProfile.OB_NeedBIO__c                       = true;
        bankProfile.OB_Bank__c                          = bankOwner.id;
        bankProfile.OB_Service_Type__c                  = 'Servizio GT';
        bankProfile.OB_Business_Model_POS__c            = 'Bilaterale  ';
        bankProfile.OB_Circuit__c                       = 'JCB;UPI';
        bankProfile.OB_Other_Acquirer__c                = 'Amex;Diners';
        bankProfile.OB_Applicant_RAC_Code_SIA__c        = 'Nexi';
        bankProfile.OB_Terminal_Id_Generator__c         = 'Nexi';
        bankProfile.OB_Technical_component_invoicing__c = 'Al p.v.';
        bankProfile.OB_GT__c                            = 'Nexi';
        bankProfile.OB_Processor__c                     = 'EQUENS (KCCS)';
        bankProfile.OB_Bilateral_Pricing__c             = 'NO';
        bankProfile.OB_Sending_Contract_to_Nexi__c      = 'NO';
        bankProfile.OB_SME_Factory__c                   = 'NO';

        insert bankProfile;

        List<OB_Bank_profile__c> bankProfileList = new List<OB_Bank_profile__c>();
        bankProfileList.add(bankProfile);
        String proposerABI = String.valueOf(bankProfile.OB_Bank__c); 
        Test.startTest();
        OB_Maintenance_Flow_Override.createBankProfileNode(proposerABI);
        Test.stopTest();   
        
    }
    @isTest
    public static void createBillingProfileNode_Test()
    {
        List<String> billingProfLookups=new List<String>();
        List<NE__Billing_Profile__c> billingProfileList = new List<NE__Billing_Profile__c>();
        Test.startTest();
        OB_Maintenance_Flow_Override.createBillingProfileNode(billingProfLookups);
        OB_Maintenance_Flow_Override.createBillingProfileNode(null);// catch()
        Test.stopTest();
    }
    @isTest
    public static void createExternalSourceNode_Test()
    {
        List<ExternalSourceMapping__c> externalSourceMappingList = new List<ExternalSourceMapping__c>();
        String merchantId = '';
        
        Test.startTest();
        OB_Maintenance_Flow_Override.createExternalSourceNode(merchantId);
        Test.stopTest();
    }
    
    @isTest
    public static void createOrderItemNode_Test()
    { 
        Id RecordTypeIdrtPOS        = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.POS_RT ).getRecordTypeId(); 
        Id RecordTypeIdACQUIRING_RT = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId();
        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
        insert configuration; 
        
        NE__OrderItem__c mapOrder = new NE__OrderItem__c();
        mapOrder.NE__Qty__c=1;
        mapOrder.NE__OrderId__c=configuration.id;
        mapOrder.RecordTypeId=RecordTypeIdrtPOS;
        mapOrder.NE__Action__c='Add'; 
        insert mapOrder;

        NE__OrderItem__c mapOrder1 = new NE__OrderItem__c();
        mapOrder1.NE__Qty__c=1;
        mapOrder1.NE__OrderId__c=configuration.id;
        mapOrder1.RecordTypeId=RecordTypeIdACQUIRING_RT;
        mapOrder1.NE__Action__c='Add'; 
        insert mapOrder1;
        
        List<NE__OrderItem__c> orderItemList =new List<NE__OrderItem__c>();
        orderItemList.add(mapOrder);
        orderItemList.add(mapOrder1);

        Map<String , List<NE__OrderItem__c>> mapOrderItemAdded = new Map<String , List<NE__OrderItem__c>>();
        
        Test.startTest();
        OB_Maintenance_Flow_Override.createOrderItemNode(configuration.id);
        Test.stopTest();
    }
    @isTest
    public static void createTempNodeTest()
    { 
        
        String objectToTemp = '';
        Test.startTest();
        OB_Maintenance_Flow_Override.createTempNode(objectToTemp);
        Test.stopTest();
    }
    
    @isTest
    public static void createObjDataMapTest()
    { 
        Id rtPOS       = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.POS_RT ).getRecordTypeId();
        Id rtACQUIRING = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get(OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId();
        String configId = '';
        NE__Order_Header__c orderHeader = new NE__Order_Header__c();
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
        insert configuration; 
  
        NE__OrderItem__c mapOrder = new NE__OrderItem__c(
            NE__Qty__c=1,
            NE__OrderId__c=configuration.id);
            mapOrder.RecordTypeId = rtPOS;
        insert mapOrder;

        NE__OrderItem__c mapOrder1 = new NE__OrderItem__c(
            NE__Qty__c=1,
            NE__OrderId__c=configuration.id);
            mapOrder.RecordTypeId = rtACQUIRING;
        insert mapOrder1;
        
        List<NE__OrderItem__c> orderItemList =new List<NE__OrderItem__c>();
        orderItemList.add(mapOrder);
        orderItemList.add(mapOrder1);


        String objDataMap = '';
        String accountId='';
        String pvId ='';
        String orderHeaderId='';
        String billProfId='';
        
        Test.startTest();
        OB_Maintenance_Flow_Override.createObjDataMap(configuration.id);
        Test.stopTest();
    }

    /*------------------------------------------------------------
    Author:        Daniele Gandini
    Company:       Accenture Tecnology
    Description:   retrieve old terminals info
    Date:          31/05/2019
   ------------------------------------------------------------*/
    static testMethod void checkIfReplacementCase_Test() {
            NE__Order_Header__c ohOrderHeader = OB_TestDataFactory.getOrderHeader();
            ohOrderHeader.OB_Sub_Process__c = OB_UtilityConstants.TERMINALS_REPLACEMENT;
            insert ohOrderHeader;
            NE__Order__c order = OB_TestDataFactory.getOrder();
            order.NE__Order_Header__c = ohOrderHeader.Id;
            insert order;

            Test.startTest();
            OB_Maintenance_Flow_Override.checkIfReplacementCase(order.id);
            Test.stopTest();
    }

    /*------------------------------------------------------------
    Author:        Daniele Gandini
    Company:       Accenture Tecnology
    Description:   retrieve old terminals info
    Date:          31/05/2019
   ------------------------------------------------------------*/
    static testMethod void retrieveTerminalIdFromRemovedPOS_Test() {
            Id recordTypeTerminali = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get(OB_UtilityConstants.POS_RT ).getRecordTypeId();
            NE__Order__c order = OB_TestDataFactory.getOrder();
            insert order;
            NE__Product__c product = OB_TestDataFactory.getProduct();
            product.RecordTypeId = recordTypeTerminali;
            insert product;
            NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem(order.Id);
            orderItem.NE__ProdId__c = product.Id;
            orderItem.NE__Action__c = OB_UtilityConstants.REMOVE_ACTION;
            insert orderItem;

            Test.startTest();
            OB_Maintenance_Flow_Override.retrieveTerminalIdFromRemovedPOS(order.id);
            Test.stopTest();
    }

    /*******************************************************************************
    Purpose:  Method tests init

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/08/2019      Created         just increase cc
    ********************************************************************************/
    @isTest
    private static void init( )
    {
        Account merchant = OB_TestDataFactory.getAccount( );
        insert merchant;
        Account bankAccount = OB_TestDataFactory.getBankAccount( );
        insert bankAccount;
        OB_Bank_Profile__c bankProfile = OB_TestDataFactory.getBankProfile( bankAccount );
        insert bankProfile;
        NE__Billing_Profile__c testBillingProfile = OB_TestDataFactory.getBillingProfile( bankAccount.Id );
        insert testBillingProfile;
        Contact testContact = OB_TestDataFactory.getContact( merchant );
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get( OB_UtilityConstants.TITOLARE_EFFETTIVO ).getRecordTypeId();
        testContact.OB_Bank__c = bankAccount.Id;
        testContact.OB_Contact_State__c = 'Active';
        insert testContact;

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = merchant.Id;
        testServicePoint.OB_Typology__c = 'Fisico';
        insert testServicePoint;

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.NE__AccountId__c = merchant.Id;
        testOrderHeader.OB_ProposerABI__c = bankAccount.Id;
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.NE__AccountId__c = merchant.Id;
        testOrder.OB_Service_Point__c = testServicePoint.Id;
        testOrder.NE__BillAccId__c = bankAccount.Id;
        testOrder.NE__BillingProfId__c = testBillingProfile.Id;
        insert testOrder;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        insert testOrderItem;

        Map<String, Object> dataMap = new Map<String, Object>( );
        dataMap.put( 'Configuration', testOrder );
        Map<String, Object> userMap = new Map<String, Object>( );
        userMap.put( 'OB_CAB__c', testOrder.OB_CAB__c );
        dataMap.put( 'user', userMap );
        Map<String, Object> unbindMap = new Map<String, Object>( );
        unbindMap.put( 'sobjectType', 'UNBIND' );
        unbindMap.put( 'RecordTypeId', '' );
        unbindMap.put( 'nextCheckout', '' );
        unbindMap.put( 'orderId', '' );
        unbindMap.put( 'UNBIND5', '' );
        unbindMap.put( 'UNBIND6', '' );
        unbindMap.put( 'UNBIND7', 'ACQUIRING' );
        unbindMap.put( 'DenominazioneSociale', '' );
        unbindMap.put( 'VAT_notPresent', '' );
        unbindMap.put( 'isCompanyDataModified', '' );
        unbindMap.put( 'InsegnaPv', '' );
        unbindMap.put( 'yearOfConstitutionCompany', '' );
        dataMap.put( 'unbind', unbindMap );

        Test.startTest( );
        OB_Maintenance_Flow_Override flowOverride = new OB_Maintenance_Flow_Override( );
        bit2flow.DynamicWizardStepWrapper result = flowOverride.init( '1', dataMap, new List<bit2flow.DynamicWizardWrapper.StepDefinitions>( ), null );
        Test.stopTest( );

        System.assertEquals( bit2flow.DynamicWizardStepWrapper.OKCODE, result.result );
    }

    /*******************************************************************************
    Purpose:  Method tests save

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/08/2019      Created         just increase cc
    ********************************************************************************/
    @isTest
    private static void save( )
    {
        Account merchant = OB_TestDataFactory.getAccount( );
        insert merchant;
        Contact testContact = OB_TestDataFactory.getContact( merchant );
        insert testContact;
        Account bankAccount = OB_TestDataFactory.getBankAccount( );
        insert bankAccount;
        OB_Bank_Profile__c bankProfile = OB_TestDataFactory.getBankProfile( bankAccount );
        insert bankProfile;

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_ABI__c = '03138';
        testOrderHeader.OB_CAB__c = '12345';
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.OB_Processor__c = OB_UtilityConstants.SIA;
        insert testOrderItem;

        NE__Product__c acqNexi = OB_TestDataFactory.getProduct( );
        acqNexi.Name = 'Visa/Mastercard';
        acqNexi.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId( );
        acqNexi.OB_Acquirer__c = 'NEXI';
        acqNexi.OB_Codice_sfdc__c = 'PCI';
        insert acqNexi;
        NE__OrderItem__c acquiringNexi = OB_TestDataFactory.getOrderItem( testOrder.Id );
        acquiringNexi.NE__ProdId__c = acqNexi.Id;
        insert acquiringNexi;

        NE__Product__c commAdd = OB_TestDataFactory.getProduct( );
        commAdd.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.PRODUCT_RECORDTYPE_COMMISSIONE ).getRecordTypeId( );
        insert commAdd;
        NE__OrderItem__c commAddItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        commAddItem.NE__Action__c = 'Add';
        insert commAddItem;

        NE__Product__c posProduct = OB_TestDataFactory.getProduct( );
        posProduct.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        insert posProduct;
        NE__OrderItem__c posOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        posOrderItem.NE__Action__c = 'Add';
        insert posOrderItem;

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = merchant.Id;
        testServicePoint.OB_Typology__c = 'Fisico';
        insert testServicePoint;

        Map<String, Object> dataMap = new Map<String, Object>( );
        dataMap.put( 'OrderHeader', testOrderHeader );
        dataMap.put( 'Configuration', testOrder );
        dataMap.put( 'merchant', merchant );
        dataMap.put( 'pv', testServicePoint );
        dataMap.put( 'bankProfile', bankProfile );
        dataMap.put( 'legale_rappresentante', testContact );
        dataMap.put( 'OB_HasAcquiring__c', 'true' );
        dataMap.put( 'OB_HasPos__c', 'false' );
        dataMap.put( 'OB_HasVas__c', 'false' );

        Test.startTest( );
        OB_Maintenance_Flow_Override flowOverride = new OB_Maintenance_Flow_Override( );
        bit2flow.DynamicWizardStepWrapper result = flowOverride.save( '1', dataMap, '', new List<bit2flow.DynamicWizardWrapper.StepDefinitions>( ), null );
        Test.stopTest( );

        System.assertEquals( bit2flow.DynamicWizardStepWrapper.OKCODE, result.result );
    }

    /*******************************************************************************
    Purpose:  Method tests createOrderItemNode - POS and Acquiring scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/08/2019      Created         just increase cc
    ********************************************************************************/
    @isTest
    private static void createOrderItemNode( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        NE__Product__c testProductPOS = OB_TestDataFactory.getProduct( );
        testProductPOS.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        insert testProductPOS;
        NE__OrderItem__c testOrderItemPOS = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItemPOS.NE__Action__c = OB_UtilityConstants.ADD_ACTION;
        testOrderItemPOS.NE__ProdId__c = testProductPOS.Id;
        insert testOrderItemPOS;
        NE__Product__c testProductAcq = OB_TestDataFactory.getProduct( );
        testProductAcq.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId( );
        insert testProductAcq;
        NE__OrderItem__c testOrderItemAcq = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItemAcq.NE__Action__c = OB_UtilityConstants.ADD_ACTION;
        testOrderItemAcq.NE__ProdId__c = testProductAcq.Id;
        insert testOrderItemAcq;

        Test.startTest( );
        Map<String, List<NE__OrderItem__c>> result = OB_Maintenance_Flow_Override.createOrderItemNode( testOrder.Id );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests getIsSIAtoApprove - true scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/08/2019      Created         just increase cc
    ********************************************************************************/
    @isTest
    private static void getIsSIAtoApprove( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.OB_Processor__c = OB_UtilityConstants.SIA;
        insert testOrderItem;

        Test.startTest( );
        Boolean result = OB_Maintenance_Flow_Override.getIsSIAtoApprove( testOrder.Id );
        Test.stopTest( );

        System.assert( result );
    }

    /*******************************************************************************
    Purpose:  Method tests updateOrderItemActionNone - happy scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/08/2019      Created         just increase cc
    ********************************************************************************/
    @isTest
    private static void updateOrderItemActionNone( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__Action__c = OB_UtilityConstants.ORDERITEM_ACTION_NONE;
        testOrderItem.NE__Status__c = OB_UtilityConstants.ORDERITEM_ACTION_ADD;//Roland Nieznanski <roland.nieznanski@accenture.com> 21/08/2019 fix status//Simone Misani 30/08/2019
        insert testOrderItem;

        Test.startTest( );
        OB_Maintenance_Flow_Override.updateOrderItemActionNone( testOrderHeader.Id );
        Test.stopTest( );

        List<NE__OrderItem__c> result = [ SELECT OB_FulfilmentStatus__c FROM NE__OrderItem__c ];
        System.assertEquals( OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED, result.get( 0 ).OB_FulfilmentStatus__c );//Roland Nieznanski <roland.nieznanski@accenture.com> 21/08/2019//Simone Misani 30/08/2019
    }

}