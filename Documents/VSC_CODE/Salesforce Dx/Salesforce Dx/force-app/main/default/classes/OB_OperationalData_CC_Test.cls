@isTest
private class OB_OperationalData_CC_Test
{

    @isTest
    public static void getReportTypeValuesTest( )
    {
        Test.startTest( );
        OB_OperationalData_CC.getReportTypeValues( );
        Test.stopTest( );
    }

    @isTest
    public static void splitOrderItem2Test( )
    {
        NE__Order__c ord = new NE__Order__c( );
        insert ord;
        Id recordTypeId = [ SELECT Id FROM RecordType WHERE sobjectType = 'NE__OrderItem__c' AND DeveloperName = 'Terminali' LIMIT 1 ].Id;
        NE__OrderItem__c parentItem = new NE__OrderItem__c( NE__OrderId__c = ord.id, NE__Qty__c = 2, RecordTypeId = recordTypeId );
        insert parentItem;
        NE__OrderItem__c item = new NE__OrderItem__c( NE__Parent_Order_Item__c = parentItem.id, NE__OrderId__c = ord.id, NE__Qty__c = 2 );
        insert item;
        NE__Order_Item_Attribute__c attr = new NE__Order_Item_Attribute__c( Name = 'Terminal Id', NE__Order_Item__c = parentItem.id );
        insert attr;

        String idOrder = ord.id;
        Test.startTest( );
        OB_OperationalData_CC.splitOrderItem2( idOrder );
        Test.stopTest( );
    }

    @isTest
    public static void callTerminalIdService_Test( )
    {
        Test.setMock( HttpCalloutMock.class, new OB_OperationalData_Mock( ) );
        OB_Integration_Configuration__c intConf = new OB_Integration_Configuration__c( );
        intConf.Name = 'DEV1';
        intConf.OB_timestamp__c = '1000';
        insert intconf;
        Account acc = new Account( Name = 'accTest', OB_Employees_Number__c = 'Minore di 10' );
        NE__Order_Header__c oh = new NE__Order_Header__c( OB_ProposerABI__c = acc.id );
        insert oh;
        NE__Order__c order = new NE__Order__c( NE__Order_Header__c = oh.Id );
        insert order;
        String terminalId = '';
        Test.startTest( );
        OB_OperationalData_CC.callTerminalIdService( false, order.Id, acc.Id, 'Fisico', '1231231231', order.Id );
        Test.stopTest( );
    }

    @isTest
    public static void insertBillingProfilesUpdateOrderHeaderTest1( )
    {
        Id acquiringProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( 'Acquiring' ).getRecordTypeId( );
        NE__Product__c prodAcquiring = new NE__Product__c( RecordTypeId = acquiringProductRecordTypeId );
        insert prodAcquiring;

        Id pagoBancomatProductRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( 'Pagobancomat' ).getRecordTypeId( );
        NE__Product__c prodPagoBancomat = new NE__Product__c( RecordTypeId = pagoBancomatProductRecordTypeId, OB_Acquirer__c = 'NEXI' );
        insert prodPagoBancomat;

        Account acc = new Account( Name = 'merchant', OB_Employees_Number__c = 'Minore di 10', NE__Fiscal_code__c = 'AAAAAA11A11A111A', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'description' );
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( ); //NEXI-125 Kinga Fornal kinga.fornal@accenture.com, 23.07.2019, test fix
        insert acc;
        NE__Billing_Profile__c billingProfilePOS = new NE__Billing_Profile__c( OB_Bank_Account_Number__c = '123123123123', NE__Account__c = acc.id );
        insert billingProfilePOS;
        NE__Billing_Profile__c billingProfileAcquiring = new NE__Billing_Profile__c( OB_Bank_Account_Number__c = '123123123123', NE__Account__c = acc.Id );
        insert billingProfileAcquiring;
        NE__Order_Header__c oh = new NE__Order_Header__c( );
        insert oh;
        NE__Order__c order = new NE__Order__c( NE__Order_Header__c = oh.id, NE__BillingProfId__c = billingProfilePOS.id, NE__BillAccId__c = acc.id );
        insert order;
        Id acquiringRecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName( ).get( 'Acquiring' ).getRecordTypeId( );
        NE__OrderItem__c acquiringOi = new NE__OrderItem__c( NE__ProdId__c = prodAcquiring.id, RecordTypeId = acquiringRecordTypeId, NE__Account__c = acc.Id, NE__Qty__c = 1, NE__OrderId__c = order.Id );
        insert acquiringOi;
        acquiringOi = [ SELECT Id,RecordType.DeveloperName,NE__BillingProfId__c,OB_DebitProfId__c,OB_Billing_Profile_Credit_Acquiring__c,OB_BankAccount_Debit_Acquiring__c, NE__ProdId__r.RecordType.DeveloperName, NE__ProdId__r.OB_Acquirer__c FROM NE__OrderItem__c WHERE Id = :acquiringOi.id ];
        update acquiringOi;
        Id terminaliRecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName( ).get( 'Terminali' ).getRecordTypeId( );
        NE__OrderItem__c terminaliOi = new NE__OrderItem__c( NE__ProdId__c = prodPagoBancomat.id, RecordTypeId = terminaliRecordTypeId, NE__Account__c = acc.Id, NE__Qty__c = 1, NE__OrderId__c = order.Id );
        insert terminaliOi;
        terminaliOi = [ SELECT Id,RecordType.DeveloperName,NE__BillingProfId__c,OB_DebitProfId__c,OB_Billing_Profile_Credit_Acquiring__c,OB_BankAccount_Debit_Acquiring__c, NE__ProdId__r.RecordType.DeveloperName, NE__ProdId__r.OB_Acquirer__c FROM NE__OrderItem__c WHERE Id = :terminaliOi.id ];
        update terminaliOi;

        List<Account> accList = new List<Account>( );
        Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Merchant' ).getRecordTypeId( );
        Account myMastMerchant = new Account( Name = 'TEST',
                RecordTypeId = rtMerchant,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_Status__c = 'Active' );

        Id accountBankRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Bank' ).getRecordTypeId( );
        Account bankAccount = new Account( Name = 'TEST',
                RecordTypeId = accountBankRecordId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_Status__c = 'Active' );
        accList.add( myMastMerchant );
        insert accList;

        String objectDataStringErrorDate = '{"errorDateMap" : {"key" : true}}';
        String objectDataStringError = '{ "OrderHeader": { "type": "NE__Order_Header__c", "OB_Business_Model_Acquiring__c": "Diretto", "Id": "' + oh.id + '", "OB_PreliminaryVerificationCode__c": false}, "Configuration": { "type": "NE__Order__c", "NE__Order_Header__c": "' + oh.id + '", "OB_MCCL2__c": "mcc2", "OB_ShopSign__c": "ss", "Id": "' + order.id + '", "OB_PBSettlementMethod__c": true }, "bankProfile":{"sobjectType":"ob_bank_profile__c","OB_Bank__c":"' + bankAccount.id + '","RecordTypeId":"","OB_GT__c":"Nexi","OB_Business_Model_POS__c":"Bilaterale","OB_Business_Model_Acquiring__c":"Associate","OB_Service_Type__c":"Servizio GT","OB_Circuit__c":"JCB;UPI","OB_Other_Acquirer__c":"Amex;Diners","OB_SettlementType__c":"Prepagato","OB_AccountHolder__c":"false","OB_Applicant_RAC_Code_SIA__c":"Nexi","OB_Terminal_Id_Generator__c":"Nexi","OB_NDG__c":true}, "BillingProfilePOS": { "sobjectType": "ne__billing_profile__c", "RecordTypeId": "", "OB_ABI__c": "", "OB_Bank_Account_Number__c": "123", "OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "Debit", "OB_ABICode__c": "12345", "OB_CABCode__c": "12345", "OB_CINCode__c": "1", "OB_CountryCode__c": "IT", "OB_EuroControlCode__c": "eu", "OB_HeaderInternational__c": "123" }, "BillingProfileAcquiring": { "sobjectType": "ne__billing_profile__c", "RecordTypeId": "", "OB_ABI__c": "", "OB_Bank_Account_Number__c": "123", "OB_Bank_Account_Owner__c": "", "OB_Bank_Account_Type__c": "Debit", "OB_ABICode__c": "12345", "OB_CABCode__c": "12345", "OB_CINCode__c": "1", "OB_CountryCode__c": "IT", "OB_EuroControlCode__c": "eu", "OB_HeaderInternational__c": "123" }, "merchant": { "Name": "insegna", "OB_FATECO__c": "S", "OB_VAT_Not_Present__c": true }, "reportTypeRO": false, "prelimVerifCodeRO": false, "viewSettMeth": true, "OB_PBSettlementMethod__c": true }';
        String objectDataString = '{"OrderHeader":{"type":"NE__Order_Header__c","OB_Business_Model_Acquiring__c":"Diretto","Id":"' + oh.id + '","OB_PreliminaryVerificationCode__c":false,"OB_Report_Type__c":false},"Configuration":{"type":"NE__Order__c","NE__Order_Header__c":"' + oh.id + '","OB_MCCL2__c":"mcc2","OB_ShopSign__c":"ss","Id":"' + order.id + '","OB_PBSettlementMethod__c":true,"NE__BillingProfId__c":"' + billingProfilePOS.id + '","OB_BankAccount_Acquiring__c":"' + billingProfileAcquiring.id + '","NE__BillAccId__c":"' + acc.id + '"},"bankProfile":{"sobjectType":"ob_bank_profile__c","OB_Bank__c":"' + bankAccount.id + '","RecordTypeId":"","OB_GT__c":"Nexi","OB_Business_Model_POS__c":"Bilaterale","OB_Business_Model_Acquiring__c":"Associate","OB_Service_Type__c":"Servizio GT","OB_Circuit__c":"JCB;UPI","OB_Other_Acquirer__c":"Amex;Diners","OB_SettlementType__c":"Prepagato","OB_AccountHolder__c":"false","OB_Applicant_RAC_Code_SIA__c":"Nexi","OB_Terminal_Id_Generator__c":"Nexi","OB_NDG__c":true},"BillingProfilePOS":{"sobjectType":"ne__billing_profile__c","id":"' + billingProfilePOS.id + '","NE__Account__c":"' + acc.id + '","RecordTypeId":"","OB_ABI__c":"","OB_Bank_Account_Number__c":"123","OB_Bank_Account_Owner__c":"' + acc.id + '","OB_Bank_Account_Type__c":"Debit","OB_ABICode__c":"12345","OB_CABCode__c":"12345","OB_CINCode__c":"1","OB_CountryCode__c":"IT","OB_EuroControlCode__c":"eu","OB_HeaderInternational__c":"123"},"BillingProfileAcquiring":{"sobjectType":"ne__billing_profile__c","RecordTypeId":"","OB_ABI__c":"","OB_Bank_Account_Number__c":"123","OB_Bank_Account_Owner__c":"","OB_Bank_Account_Type__c":"Debit","OB_ABICode__c":"12345","OB_CABCode__c":"12345","OB_CINCode__c":"1","OB_CountryCode__c":"IT","OB_EuroControlCode__c":"eu","OB_HeaderInternational__c":"123","id":"' + billingProfileAcquiring.id + '","NE__Account__c":"' + acc.id + '"},"merchant":{"Id":"' + acc.id + '","Name":"insegna","OB_FATECO__c":"S","OB_VAT_Not_Present__c":true},"reportTypeRO":false,"prelimVerifCodeRO":false,"viewSettMeth":true,"OB_PBSettlementMethod__c":true}';
        Test.startTest( );
        OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader( objectDataStringErrorDate, myMastMerchant.Id, bankAccount.Id, true );
        OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader( objectDataStringError, myMastMerchant.Id, bankAccount.Id, true );
        OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader( objectDataString, acc.Id, bankAccount.Id, true );
        Test.stopTest( );
    }

    @isTest
    public static void createCartListFromMapTest( )
    {
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Bank' ).getRecordTypeId( );
        Account acc = new Account( Name = 'TEST2',
                RecordTypeId = accountRecordTypeId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_Status__c = 'Active',
                OB_ABI__c = '05116' );
        insert acc;
        NE__Order_Header__c oh = new NE__Order_Header__c( OB_ProposerABI__c = acc.id, OB_Business_Model_Acquiring__c = 'Bancario', OB_Business_Model_POS__c = 'Trilaterale Nuovo', OB_Main_Process__c = 'Setup' );
        insert oh;
        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.id );
        insert ord;
        NE__Product__c prod = new NE__Product__c( );
        insert prod;
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c( NE__Account__c = acc.id );
        insert bp;
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        Asset ass = new Asset( );
        ass.AccountId = acc.id;
        ass.OB_DebitProfId__c = bp.id;
        ass.OB_ProposerABI__c = acc.id;
        ass.IsCompetitorProduct = false;
        ass.IsInternal = false;
        ass.Name = 'Offerta Personalizzata';
        ass.NE__Action__c = 'Change';
        ass.NE__AssetItemEnterpriseId__c = '123123123';
        ass.NE__BaseOneTimeFee__c = 0;
        ass.NE__BaseRecurringCharge__c = 0;
        ass.NE__Billing_Account__c = acc.id;
        ass.NE__Commitment__c = false;
        ass.NE__Discount_One_time__c = 0;
        ass.NE__Discount__c = 0;
        ass.NE__Generate_Asset_Item__c = true;
        ass.NE__Item_Code__c = '9951092441';
        ass.NE__Order_Config__c = ord.id;
        ass.NE__ProdId__c = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c = false;
        ass.NE__Service_Account__c = acc.id;
        ass.NE__Service_Point__c = sp.id;
        ass.NE__Status__c = 'In Progress';
        ass.OB_enablement__c = 'N';
        ass.OB_MCCL2__c = '0001';
        ass.OB_MCC__c = '5200';
        ass.OB_Report_Type__c = 'Punto Vendita';
        ass.OB_Ro__c = 'N';
        ass.OB_Visible__c = 'N';
        ass.Quantity = 1;
        ass.RecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1 ].id;
        insert ass;
        Test.startTest( );
        OB_OperationalData_CC.createCartListFromMap( ord.Id );
        Test.stopTest( );
    }

    @isTest
    public static void createCartListFromMapTest2( )
    {
        NE__Order__c ord = new NE__Order__c( );
        insert ord;
        Account acc = new Account( );
        acc.Name = 'Test';
        acc.RecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank' LIMIT 1 ].Id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = true;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active';
        acc.OB_ABI__c = '05116';
        insert acc;
        Asset ass = new Asset( );
        ass.Name = 'test';
        ass.AccountId = acc.id;
        insert ass;
        Test.startTest( );
        OB_OperationalData_CC.createCartListFromMap( ord.id );
        //OB_OperationalData_CC.createCartListFromMap(ass.id);
        Test.stopTest( );
    }
    /*******************************************************************************
    Purpose:  Method tests createCartListFromMapLight

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Francesca Ribezzi       28/11/2019      Created         Performance
    ********************************************************************************/
    @isTest
    public static void createCartListFromMapLight_Test(){
      
        NE__Catalog_Header__c catH = new NE__Catalog_Header__c( NE__Name__c = 'TestCatHead' );
        catH.NE__Active__c = true;
        catH.NE__Start_Date__c = System.today( );
        insert catH;
        NE__Catalog__c cat = new NE__Catalog__c( NE__Catalog_Header__c = catH.id );
        cat.NE__Active__c = true;
        cat.NE__StartDate__c = System.today( );
        insert cat;
        NE__Catalog_Item__c catIt = new NE__Catalog_Item__c( NE__Catalog_Id__c = cat.id );
        catIt.NE__Active__c = true;
        catIt.NE__ConfigurationRequired__c = false;
        catIt.NE__Min_Qty__c = 10;
        catIt.NE__Start_Date__c = System.today( );
        insert catIt;
        NE__Order__c ord = new NE__Order__c( );
        insert ord;
        NE__OrderItem__c ordItem = OB_TestDataFactory.getOrderItem( ord.Id );
        ordItem.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        ordItem.NE__CatalogItem__c = catIt.id;
        insert ordItem;
        NE__Order_Item_Attribute__c orderItemAttr = OB_TestDataFactory.getOrderItemAttribute( ordItem.Id );
        orderItemAttr.Name = 'Terminal Id'; 
        orderItemAttr.NE__Value__c = '1234567';
        insert orderItemAttr;
        Test.startTest( ); 
            Object obj =  OB_OperationalData_CC.createCartListFromMapLight( ord.id , false);
            //System.assertEquals(null, obj);  
        Test.stopTest( );

    }
    
    

    @isTest
    public static void enrichOrderWrapper( )
    {
        NE__Order_Header__c oh = new NE__Order_Header__c(
                OB_Business_Model_Acquiring__c = 'Bancario',
                OB_Business_Model_POS__c = 'Trilaterale Nuovo',
                OB_Main_Process__c = 'Setup' );
        insert oh;
        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.id );
        insert ord;

        Test.startTest( );
        OB_OperationalData_CC.enrichOrderWrapper( ord.id );
        Test.stopTest( );
    }

    @isTest
    public static void callConfigurationInfoServer_Test( )
    {
        Id recordTypeMerchant = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Merchant' ).getRecordTypeId( );
        NE__Order_Header__c oh = new NE__Order_Header__c( OB_Business_Model_Acquiring__c = 'Diretto', OB_Main_Process__c = 'Maintenance' );
        insert oh;
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        Account a = new Account( Name = 'a', OB_Employees_Number__c = 'Minore di 10', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'description', NE__Fiscal_code__c = 'AAAAAA11A11A111A', RecordTypeId = recordTypeMerchant );
        insert a;
        NE__Order__c ord = new NE__Order__c( OB_Service_Point__c = sp.id, NE__Order_Header__c = oh.id );
        insert ord;
        Test.startTest( );
        OB_OperationalData_CC.callConfigurationInfoServer( ord.id );
        Test.stopTest( );
    }

    @isTest
    public static void createMapFromAsset_Test( )
    {
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Bank' ).getRecordTypeId( );
        Account acc = new Account( Name = 'TEST',
                RecordTypeId = accountRecordTypeId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_Status__c = 'Active',
                OB_ABI__c = '05116' );
        insert acc;
        NE__Order_Header__c oh = new NE__Order_Header__c( OB_ProposerABI__c = acc.id, OB_Business_Model_Acquiring__c = 'Bancario', OB_Business_Model_POS__c = 'Trilaterale Nuovo', OB_Main_Process__c = 'Setup' );
        insert oh;
        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.id );
        insert ord;
        NE__Product__c prod = new NE__Product__c( );
        insert prod;
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c( NE__Account__c = acc.id );
        insert bp;
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        NE__Catalog_Header__c catH = new NE__Catalog_Header__c( NE__Name__c = 'TestCatHead' );
        catH.NE__Active__c = true;
        catH.NE__Start_Date__c = System.today( );
        insert catH;
        NE__Catalog__c cat = new NE__Catalog__c( NE__Catalog_Header__c = catH.id );
        cat.NE__Active__c = true;
        cat.NE__StartDate__c = System.today( );
        insert cat;
        NE__Catalog_Item__c catIt = new NE__Catalog_Item__c( NE__Catalog_Id__c = cat.id );
        catIt.NE__Active__c = true;
        catIt.NE__ConfigurationRequired__c = false;
        catIt.NE__Min_Qty__c = 10;
        catIt.NE__Start_Date__c = System.today( );
        insert catIt;

        OB_Bank_Profile__c bankProf = new OB_Bank_Profile__c( );
        bankProf.OB_Bank__c = acc.id;
        bankProf.OB_Business_Model_Acquiring__c = 'Bancario';
        bankProf.OB_Business_Model_POS__c = 'Bilaterale';
        bankProf.OB_Service_Type__c = 'Acquiring';
        bankProf.OB_Circuit__c = 'JCB;UPI;Pagobancomat bancario;Micropagamenti';
        bankProf.OB_Other_Acquirer__c = 'Amex;Diners;Aura;Agos;Pellegrini;QN';
        bankProf.OB_Applicant_RAC_Code_SIA__c = 'Nexi';
        bankProf.OB_Terminal_Id_Generator__c = 'Nexi';
        bankProf.OB_Technical_component_invoicing__c = 'Al p.v.';
        bankProf.OB_GT__c = 'Nexi';
        bankProf.OB_Processor__c = 'EQUENS (KCCS)';
        bankProf.OB_Bilateral_Pricing__c = 'NO';
        bankProf.OB_Sending_Contract_to_Nexi__c = 'SI';
        bankProf.OB_SME_Factory__c = 'NO';

        insert bankProf;

        Asset singleAsset = new Asset( );
        singleAsset.AccountId = acc.id;
        singleAsset.OB_DebitProfId__c = bp.id;
        singleAsset.OB_ProposerABI__c = acc.id;
        singleAsset.IsCompetitorProduct = false;
        singleAsset.IsInternal = false;
        singleAsset.Name = 'Offerta Personalizzata';
        singleAsset.NE__Action__c = 'Change';
        singleAsset.NE__AssetItemEnterpriseId__c = '123123123';
        singleAsset.NE__BaseOneTimeFee__c = 0;
        singleAsset.NE__BaseRecurringCharge__c = 0;
        singleAsset.NE__Billing_Account__c = acc.id;
        singleAsset.NE__Commitment__c = false;
        singleAsset.NE__Discount_One_time__c = 0;
        singleAsset.NE__Discount__c = 0;
        singleAsset.NE__Generate_Asset_Item__c = true;
        singleAsset.NE__Item_Code__c = '9951092441';
        singleAsset.NE__Order_Config__c = ord.id;
        singleAsset.NE__ProdId__c = prod.id;
        singleAsset.NE__RecurringChargeFrequency__c = 'Monthly';
        singleAsset.NE__Remove_from_total__c = false;
        singleAsset.NE__Service_Account__c = acc.id;
        singleAsset.NE__Service_Point__c = sp.id;
        singleAsset.NE__Status__c = 'In Progress';
        singleAsset.OB_enablement__c = 'N';
        singleAsset.OB_MCCL2__c = '0001';
        singleAsset.OB_MCC__c = '5200';
        singleAsset.OB_Report_Type__c = 'Punto Vendita';
        singleAsset.OB_Ro__c = 'N';
        singleAsset.OB_Visible__c = 'N';
        singleAsset.Quantity = 1;
        singleAsset.NE__Catalog__c = cat.id;
        singleAsset.NE__CatalogItem__c = catIt.id;
        //START Andrea Saracini 12/06/2019 - R1F2-153v2
        singleAsset.OB_StartValidationDate__c = System.today( );
        singleAsset.NE__StartDate__c = dateTime.now().addDays(-3);
        //STOP Andrea Saracini 12/06/2019 - R1F2-153v2
        singleAsset.RecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1 ].id;
        insert singleAsset;

        Asset childAsset = new Asset( );
        childAsset.AccountId = acc.id;
        childAsset.OB_DebitProfId__c = bp.id;
        childAsset.OB_ProposerABI__c = acc.id;
        childAsset.IsCompetitorProduct = false;
        childAsset.IsInternal = false;
        childAsset.Name = 'Offerta Personalizzata';
        childAsset.NE__Action__c = 'Change';
        childAsset.NE__AssetItemEnterpriseId__c = '123123123';
        childAsset.NE__BaseOneTimeFee__c = 0;
        childAsset.NE__BaseRecurringCharge__c = 0;
        childAsset.NE__Billing_Account__c = acc.id;
        childAsset.NE__Commitment__c = false;
        childAsset.NE__Discount_One_time__c = 0;
        childAsset.NE__Discount__c = 0;
        childAsset.NE__Generate_Asset_Item__c = true;
        childAsset.NE__Item_Code__c = '9951092441';
        childAsset.NE__Order_Config__c = ord.id;
        childAsset.NE__ProdId__c = prod.id;
        childAsset.NE__RecurringChargeFrequency__c = 'Monthly';
        childAsset.NE__Remove_from_total__c = false;
        childAsset.NE__Service_Account__c = acc.id;
        childAsset.NE__Service_Point__c = sp.id;
        childAsset.NE__Status__c = 'In Progress';
        childAsset.OB_enablement__c = 'N';
        childAsset.OB_MCCL2__c = '0001';
        childAsset.OB_MCC__c = '5200';
        childAsset.OB_Report_Type__c = 'Punto Vendita';
        childAsset.OB_Ro__c = 'N';
        childAsset.OB_Visible__c = 'N';
        childAsset.Quantity = 1;
        childAsset.NE__Catalog__c = cat.id;
        childAsset.NE__CatalogItem__c = catIt.id;
        childAsset.NE__Bundle_Configuration__c = singleAsset.id;
        childAsset.NE__StartDate__c = dateTime.now().addDays(-3);
        childAsset.RecordTypeId = [ SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1 ].id;
        insert childAsset;

        NE__Family__c family = new NE__Family__c( );
        insert family;

        NE__DynamicPropertyDefinition__c dpd = new NE__DynamicPropertyDefinition__c( );
        insert dpd;

        NE__ProductFamilyProperty__c pfp = new NE__ProductFamilyProperty__c( );
        pfp.NE__PropId__c = dpd.id;
        pfp.NE__FamilyId__c = family.id;
        insert pfp;
        NE__AssetItemAttribute__c assItemAttr = new NE__AssetItemAttribute__c( NE__Asset__c = childAsset.id, NE__FamPropId__c = pfp.id, ob_attribute_code__c = 'IMPORTO' );
        insert assItemAttr;
        NE__AssetItemAttribute__c assItemAttr2 = new NE__AssetItemAttribute__c( NE__Asset__c = childAsset.id, ob_attribute_code__c = 'IMPORTO' );
        insert assItemAttr2;

        Map<Id, NE__AssetItemAttribute__c> attrMap = new Map<Id, NE__AssetItemAttribute__c>( );
        attrMap.put( assItemAttr.id, assItemAttr );

        Attachment att = new Attachment( );
        att.Name = 'B2WGIN';
        att.Body = Blob.valueOf( '{"fields" : {}, "listOfAttributes" : [{"fields" : {"pfpId" : "' + pfp.id + '", "idfamily" : "", "propid" : ""}}]}' );
        att.ParentId = catIt.id;
        insert att;

        Test.startTest( );
        OB_OperationalData_CC.createMapFromAsset( singleAsset.id );
        Test.stopTest( );
    }

    @isTest
    public static void getApprovalStatusOfConfiguration( )
    {
        Id recordTypeMerchant = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Merchant' ).getRecordTypeId( );
        NE__Order_Header__c oh = new NE__Order_Header__c( OB_Business_Model_Acquiring__c = 'Diretto', OB_Main_Process__c = 'Maintenance' );
        insert oh;
        NE__Service_Point__c sp = new NE__Service_Point__c( );
        insert sp;
        Account a = new Account( Name = 'a', OB_Employees_Number__c = 'Minore di 10', OB_VAT_Not_Present__c = true, OB_DescriptionVATNotPresent__c = 'description', NE__Fiscal_code__c = 'AAAAAA11A11A111A', RecordTypeId = recordTypeMerchant );
        insert a;
        NE__Order__c ord = new NE__Order__c( OB_Service_Point__c = sp.id, NE__Order_Header__c = oh.id );
        insert ord;

        Test.startTest( );
        OB_OperationalData_CC.getApprovalStatusOfConfiguration( ord.id );
        Test.stopTest( );
    }

    //START Andrea Saracini 12/06/2019 - R1F2-153v2
    @isTest
    public static void getUserInformationTest( )
    {
        Test.startTest( );
        OB_OperationalData_CC.getUserInformation( );
        Test.stopTest( );
    }

    @isTest
    public static void checkActiveTerminalsIBANTest( )
    {
        Account acc = OB_TestDataFactory.getAccount( );
        acc.NE__Fiscal_code__c = '00079470142';
        insert acc;

        NE__Billing_Profile__c billProf = new NE__Billing_Profile__c( );
        billProf.NE__Account__c = acc.Id;
        billProf.OB_ABICode__c = '12345';
        billProf.OB_CABCode__c = '12345';
        billProf.OB_CINCode__c = '1';
        billProf.OB_CountryCode__c = 'IT';
        billProf.OB_Bank_Account_Number__c = '123';
        insert billProf;

        NE__Order_Header__c ordHeader = OB_TestDataFactory.getOrderHeader( );

        NE__Order__c ord = OB_TestDataFactory.getOrder( ordHeader );
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__AccountId__c = acc.Id;
        ord.OB_FulfilmentStatus__c = '';
        insert ord;

        NE__Product__c prod = OB_TestDataFactory.getProduct( );
        prod.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        insert prod;

        NE__OrderItem__c ordItem = OB_TestDataFactory.getOrderItem( ord.Id );
        ordItem.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        ordItem.NE__Status__c = 'Active';
        ordItem.NE__Action__c = 'Add';
        ordItem.NE__ProdId__c = prod.Id;
        ordItem.OB_DebitProfId__c = billProf.Id;
        insert ordItem;

        String objectDataString = '{"merchant":{"sobjectType":"account","Id":"' + acc.id + '", "NE__Fiscal_code__c":"' + acc.NE__Fiscal_code__c + '"}, "Configuration":{"Id":"' + ord.Id + '"}}';

        Test.startTest( );
        OB_OperationalData_CC.checkActiveTerminalsIBAN( objectDataString );
        Test.stopTest( );
    }

    @isTest
    public static void updateTerminalIdServeTest( )
    {
        NE__Order_Header__c ordHeader = OB_TestDataFactory.getOrderHeader( );

        NE__Order__c ord = OB_TestDataFactory.getOrder( ordHeader );
        ord.OB_FulfilmentStatus__c = '';
        insert ord;

        NE__OrderItem__c ordItem = OB_TestDataFactory.getOrderItem( ord.Id );
        ordItem.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        insert ordItem;

        NE__Order_Item_Attribute__c orderItemAttr = OB_TestDataFactory.getOrderItemAttribute( ordItem.Id );
        orderItemAttr.Name = 'Terminal Id';
        orderItemAttr.NE__Value__c = '1234567';
        insert orderItemAttr;

        Map<Id, String> mapItemIdTerminalId = new Map<Id, String>( );
        mapItemIdTerminalId.put( ordItem.Id, orderItemAttr.NE__Value__c );

        Test.startTest( );
        Boolean termidIsOK = OB_OperationalData_CC.updateTerminalIdServer( mapItemIdTerminalId );
        Test.stopTest( );
    }
    //STOP Andrea Saracini 12/06/2019 - R1F2-153v2

    /*******************************************************************************
    Purpose:  Method tests .checkProfileLoggedUser / just increase cc

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/07/2019      Created         NEXI-116
    ********************************************************************************/
    @isTest
    private static void checkProfileLoggedUser( )
    {
        User testOperationUser =  [ SELECT Id FROM User WHERE Profile.Name = :OB_UtilityConstants.OPERATION AND IsActive = true LIMIT 1 ];//Roland Nieznanski <roland.nieznanski@accenture.com> 12/09/2019 add check for active

        System.runAs( testOperationUser )
        {
            Boolean result = OB_OperationalData_CC.checkProfileLoggedUser( );
            System.assert( result );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests .updateReplacedOrderItem / just increase cc

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/07/2019      Created         NEXI-116
    1.1         Joanna Mielczarek       20/08/2019      Modified        NEXI-216 added admin - run as
    ********************************************************************************/
    @isTest
    private static void updateReplacedOrderItem( )
    {
        User admin = OB_TestDataFactory.getUser( );
        admin.ProfileId = [ SELECT Id FROM Profile WHERE Name = 'OB_System_Administrator' ].get( 0 ).Id;
        insert admin;

        System.runAs( admin )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            insert testAccount;

            NE__Billing_Profile__c testBillingProfile = OB_TestDataFactory.getBillingProfile( testAccount.Id );
            insert testBillingProfile;

            NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
            insert testOrder;

            NE__OrderItem__c testOrderItemAdd = OB_TestDataFactory.getOrderItem( testOrder.Id );
            testOrderItemAdd.NE__Action__c = OB_UtilityConstants.ADD_ACTION;
            testOrderItemAdd.OB_TermId__c = '12345';
            testOrderItemAdd.NE__BillingProfId__c = testBillingProfile.Id;
            testOrderItemAdd.OB_DebitProfId__c = testBillingProfile.Id;
            testOrderItemAdd.OB_Billing_Profile_Credit_Acquiring__c = testBillingProfile.Id;
            testOrderItemAdd.OB_BankAccount_Debit_Acquiring__c = testBillingProfile.Id;
            insert testOrderItemAdd;

            NE__OrderItem__c testOrderItemRemove = OB_TestDataFactory.getOrderItem( testOrder.Id );
            testOrderItemRemove.NE__Action__c = OB_UtilityConstants.REMOVE_ACTION;
            testOrderItemRemove.OB_TermId__c = '12345';
            testOrderItemRemove.NE__BillingProfId__c = testBillingProfile.Id;
            testOrderItemRemove.OB_DebitProfId__c = testBillingProfile.Id;
            testOrderItemRemove.OB_Billing_Profile_Credit_Acquiring__c = testBillingProfile.Id;
            testOrderItemRemove.OB_BankAccount_Debit_Acquiring__c = testBillingProfile.Id;
            insert testOrderItemRemove;

            List<Id> result = OB_OperationalData_CC.updateReplacedOrderItem( testOrder.Id, new List<String> {'12345'} );
            System.assertEquals( 1, result.size( ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests .retrieveSiaCodes() - just increase cc

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/07/2019      Created         NEXI-116
    1.1         Joanna Mielczarek       20/08/2019      Modified        NEXI-216 added admin - run as
    ********************************************************************************/
    @isTest
    private static void retrieveSiaCodes( )
    {
        User admin = OB_TestDataFactory.getUser( );
        admin.ProfileId = [ SELECT Id FROM Profile WHERE Name = 'OB_System_Administrator' ].get( 0 ).Id;
        insert admin;

        System.runAs( admin )
        {
            NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
            insert testOrder;

            NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
            testOrderItem.NE__Action__c = OB_UtilityConstants.REMOVE_ACTION;
            testOrderItem.OB_TermId__c = '12345';
            insert testOrderItem;

            NE__Order_Item_Attribute__c testOrderItemAttribute = OB_TestDataFactory.getOrderItemAttribute( testOrderItem.Id );
            testOrderItemAttribute.NE__Action__c = OB_UtilityConstants.REMOVE_ACTION;
            testOrderItemAttribute.Name = OB_UtilityConstants.CODICE_SIA;
            insert testOrderItemAttribute;

            Map<String, Map<String, String>> result = OB_OperationalData_CC.retrieveSiaCodes( testOrder.Id, new List<String> {'12345'} );
            System.assert( !result.isEmpty( ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method prepares data for doInitMethod()
    Params:   String settlementType, String productRT, String processor, String settlementMethod
    Returns:  String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       01/08/2019      Created         NEXI-246 just increase cc
    ********************************************************************************/
    private static String prepareDataForInitMethod( String settlementType, String productRT, String processor, String settlementMethod )
    {
        Account bankAccount = OB_TestDataFactory.getBankAccount( );
        insert bankAccount;

        OB_Bank_Profile__c testBankProfile = OB_TestDataFactory.getBankProfile( bankAccount );
        testBankProfile.OB_Circuit__c = OB_UtilityConstants.PAGOBANCOMAT_SUBLICENZA;
        testBankProfile.OB_SettlementType__c = settlementType;
        insert testBankProfile;

        Account merchantAccount = OB_TestDataFactory.getAccount( );
        merchantAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );
        insert merchantAccount;

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_Main_Process__c = 'Maintenance';
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        NE__Product__c testProduct = OB_TestDataFactory.getProduct( );
        testProduct.OB_Acquirer__c = OB_UtilityConstants.GT_NEXICAPS;
        testProduct.OB_Codice_sfdc__c = OB_EnrichOrder.UNATTENDED;
        testProduct.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( productRT ).getRecordTypeId( );
        insert testProduct;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.OB_Processor__c = processor;
        testOrderItem.NE__ProdId__c = testProduct.Id;
        testOrderItem.OB_MCCL2__c = '3007';
        testOrderItem.OB_MCC__c = OB_EnrichOrder.PETROL;
        testOrderItem.OB_CompanyCode__c = '0000';
        testOrderItem.OB_ShopCode__c = '1111';
        testOrderItem.OB_ServicePointCode__c = '1111';
        testOrderItem.NE__Account__c = merchantAccount.Id;
        testOrderItem.NE__Action__c = OB_EnrichOrder.NONE;
        testOrderItem.OB_SettlementMethod__c = settlementMethod;
        insert testOrderItem;

        NE__Order_Item_Attribute__c testOrderItemAttribute = OB_TestDataFactory.getOrderItemAttribute( testOrderItem.Id );
        insert testOrderItemAttribute;

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = merchantAccount.Id;
        insert testServicePoint;

        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.AccountId = merchantAccount.Id;
        testAsset.NE__Service_Point__c = testServicePoint.Id;
        testAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        testAsset.OB_ShopCode__c = '1111';
        testAsset.OB_ServicePointCode__c = '1111';
        testAsset.OB_CompanyCode__c = '0000';
        testAsset.OB_MCCL2__c = '3007';
        testAsset.OB_MCC__c = OB_EnrichOrder.PETROL;
        insert testAsset;

        ExternalSourceMapping__c testESM = new ExternalSourceMapping__c( );
        testESM.OB_Merchant_ID__c = merchantAccount.Id;
        testESM.OB_Service_Point_ID__c = testServicePoint.Id;
        testESM.OB_ServicePointCodeShopCode__c = '1111';
        testESM.OB_Source__c = OB_UtilityConstants.SIA;
        testESM.OB_CTICode__c = '1111';
        testESM.OB_CustomerCodeClientCode__c = '0000';
        testESM.OB_ServicePointCodeShopCode__c = '1111';
        testESM.OB_Conventioncode__c = '1111';
        testESM.OB_ConventionCodeSource__c = '1111';
        testESM.OB_PBSettlementMethod__c = testOrderItem.OB_SettlementMethod__c;
        testESM.OB_MCCL2__c = '3007';
        testESM.OB_MCC__c = OB_EnrichOrder.PETROL;
        testESM.OB_Pricing__c = OB_EnrichOrder.UNATTENDED;
        insert testESM;

        Map<String, Object> testMap = new Map<String, Object>( );
        testMap.put( 'OrderHeader', testOrderHeader );
        testMap.put( 'Configuration', testOrder );
        testMap.put( 'bankProfile', testBankProfile );
        testMap.put( 'merchant', merchantAccount );
        testMap.put( 'ExternalAccount', new List<ExternalSourceMapping__c> {testESM} );

        return JSON.serialize( testMap );
    }

    /*******************************************************************************
    Purpose:  Method tests .doInitMethod() - just increase cc

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/07/2019      Created         NEXI-116
    ********************************************************************************/
    @isTest
    private static void doInitMethodTestSIAUnattended( )
    {
        String testData = prepareDataForInitMethod( null, OB_EnrichOrder.ACQUIRING, OB_EnrichOrder.SIA, OB_EnrichOrder.UNATTENDED );
        Test.startTest( );
        Map<String, Object> result = OB_OperationalData_CC.doInitMethod( testData );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests .doInitMethod() - just increase cc

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/07/2019      Created         NEXI-116
    ********************************************************************************/
    @isTest
    private static void doInitMethodTestSIAPostpagato( )
    {
        String testData = prepareDataForInitMethod( OB_UtilityConstants.POSTPAGATO, OB_EnrichOrder.ACQUIRING, OB_EnrichOrder.SIA, null );
        Test.startTest( );
        Map<String, Object> result = OB_OperationalData_CC.doInitMethod( testData );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests .doInitMethod() - just increase cc

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/07/2019      Created         NEXI-116
    ********************************************************************************/
    @isTest
    private static void doInitMethodTestSIAPrepagato( )
    {
        String testData = prepareDataForInitMethod( OB_UtilityConstants.PREPAGATO, OB_EnrichOrder.ACQUIRING, OB_EnrichOrder.SIA, null );
        Test.startTest( );
        Map<String, Object> result = OB_OperationalData_CC.doInitMethod( testData );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests .doInitMethod() - just increase cc

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/07/2019      Created         NEXI-116
    ********************************************************************************/
    @isTest
    private static void doInitMethodTestEQUENS( )
    {
        String testData = prepareDataForInitMethod( null, OB_EnrichOrder.ACQUIRING, OB_EnrichOrder.EQUENS, OB_EnrichOrder.UNATTENDED );
        Test.startTest( );
        Map<String, Object> result = OB_OperationalData_CC.doInitMethod( testData );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests .doInitMethod() - just increase cc

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/07/2019      Created         NEXI-116
    ********************************************************************************/
    @isTest
    private static void doInitMethodTestNotAcquiringPrepagato( )
    {
        String testData = prepareDataForInitMethod( OB_UtilityConstants.PREPAGATO, OB_EnrichOrder.VAS, OB_EnrichOrder.EQUENS, OB_EnrichOrder.SIA );
        Test.startTest( );
        Map<String, Object> result = OB_OperationalData_CC.doInitMethod( testData );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests .doInitMethod() - just increase cc

    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/07/2019      Created         NEXI-116
    ********************************************************************************/
    @isTest
    private static void doInitMethodTestNotAcquiringPostpagato( )
    {
        String testData = prepareDataForInitMethod( OB_UtilityConstants.POSTPAGATO, OB_EnrichOrder.VAS, OB_EnrichOrder.EQUENS, OB_EnrichOrder.SIA );
        Test.startTest( );
        Map<String, Object> result = OB_OperationalData_CC.doInitMethod( testData );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateAllItemsServer - happy flow

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-246 just increase cc
    ********************************************************************************/
    @isTest
    private static void updateAllItemsServer( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        insert testOrderItem;

        NE__Order_Item_Attribute__c testOrderItemAttribute = OB_TestDataFactory.getOrderItemAttribute( testOrderItem.Id );
        insert testOrderItemAttribute;

        Map<String, Object> objectMap = new Map<String, Object>( );
        objectMap.put( 'idLineAttribute', testOrderItemAttribute.Id );
        objectMap.put( 'value', '1' );
        objectMap.put( 'NE__Action__c', 'Add' );
        objectMap.put( 'Old_Value__c', '0' );

        Boolean result = OB_OperationalData_CC.updateAllItemsServer( new List<Object> {testOrderItem},
                new List<Object> {JSON.deserializeUntyped( JSON.serialize( objectMap ) )} , testOrder.Id);
        System.assert( result );
    }

    /*******************************************************************************
    Purpose:  Method tests getOrderDataServer - happy flow

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-246 just increase cc
    ********************************************************************************/
    @isTest
    private static void getOrderDataServer( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        System.assert( OB_OperationalData_CC.getOrderDataServer( testOrder.Id ).Id != null );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieveMatrix - empty list

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-246 just increase cc
    ********************************************************************************/
    @isTest
    private static void retrieveMatrix( )
    {
        NE__Bundle__c testBundle = new NE__Bundle__c( );
        testBundle.NE__RecurringChargeFrequency__c = '	Monthly';
        testBundle.NE__BaseRecurringCharge__c = 100.00;
        testBundle.NE__Start_Date__c = System.today( );
        insert testBundle;

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_Business_Model_Acquiring__c = 'Diretto';
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__Bundle__c = testBundle.Id;
        insert testOrderItem;

        System.assert( OB_OperationalData_CC.retrieveMatrix( testOrder.Id ).isEmpty( ) );
    }
    @isTest
    private static void createSimCard_Test( )
    {
      NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        insert testOrderItem;

        NE__Order_Item_Attribute__c testOrderItemAttribute = OB_TestDataFactory.getOrderItemAttribute( testOrderItem.Id );
        insert testOrderItemAttribute;

        Map<String, Object> objectMap = new Map<String, Object>( );
        objectMap.put( 'idLineAttribute', testOrderItemAttribute.Id );
        objectMap.put( 'value', 'Nexi' );
        objectMap.put( 'NE__Action__c', 'Add' );
        objectMap.put( 'SimCard', 'SimCard' );
        objectMap.put( 'Old_Value__c', '0' );

        OB_OperationalData_CC.createSimCard( objectMap , testOrder.Id);

    }

    /*******************************************************************************
   Purpose:  Method tests insertBillingProfilesUpdateOrderHeader - operational user

   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0         Kinga Fornal            09/09/2019      Created         NEXI-315
   ********************************************************************************/
    @isTest
    private static void insertBillingProfilesUpdateOrderHeaderOperational( )
    {
        Account merchantAccount = OB_TestDataFactory.getAccount( );
        insert merchantAccount;
        Account bankAccount = OB_TestDataFactory.getAccount( );
        insert bankAccount;
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;
        NE__Billing_Profile__c testBillingProfile = OB_TestDataFactory.getBillingProfile( merchantAccount.Id );
        testBillingProfile.OB_BypassValidation__c = true;
        testBillingProfile.NE__Account__c = merchantAccount.Id;
        testBillingProfile.OB_ABICode__c = '12345';
        testBillingProfile.OB_CABCode__c = '12345';
        testBillingProfile.OB_CINCode__c = '1';
        testBillingProfile.OB_CountryCode__c = 'IT';
        testBillingProfile.OB_EuroControlCode__c = '31';
        testBillingProfile.OB_Bank_Account_Number__c = '123';
        testBillingProfile.OB_HeaderInternational__c = '123';
        insert testBillingProfile;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.NE__AccountId__c = merchantAccount.Id;
        testOrder.NE__BillAccId__c = merchantAccount.Id;
        testOrder.OB_BillingProfId__c = testBillingProfile.Id;
        testOrder.OB_BankAccount_Acquiring__c = testBillingProfile.Id;
        insert testOrder;

        Map<String, Object> dataMap = new Map<String, Object>
        {
                'isOperation' => true,
                'errorDateMap' => new Map<String, Object> {},
                'isIbanValid' => true,
                'vatNotPresent' => true,
                'merchant' => merchantAccount,
                'OrderHeader' => testOrderHeader,
                'BillingProfilePOS' => testBillingProfile,
                'BillingProfileAcquiring' => testBillingProfile,
                'Configuration' => testOrder
        };

        String objectDataString = JSON.serialize( dataMap );
        Map<String, Object> result = OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader( objectDataString, merchantAccount.Id, bankAccount.Id, false );
        List<NE__Order_Header__c> testOrderHeaderAfterUpdate = [ SELECT Id,OB_CAB__c FROM NE__Order_Header__c WHERE Id = :testOrderHeader.Id LIMIT 1 ];
        System.assertEquals( testBillingProfile.OB_CABCode__c, testOrderHeaderAfterUpdate.get( 0 ).OB_CAB__c );
    }

   /*******************************************************************************
   Purpose:  Method tests updateConfigurationServer 

   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0         Francesca Ribezzi      07/10/2019      Created              WN-566
   ********************************************************************************/
    @isTest
    private static void updateConfigurationServer_Test(){
        NE__Order_Header__c oh = OB_TestDataFactory.getOrderHeader();
        insert oh;
        NE__Order__c o = OB_TestDataFactory.getOrder(oh);
        insert o;
        String confString = JSON.serialize(o);
        Test.startTest( );
           Boolean toReturn = OB_OperationalData_CC.updateConfigurationServer(confString);
        Test.stopTest( );
        System.assertEquals(true, toReturn); 
    }

	/*
	*	Author	:	Morittu Andrea
	*	Date	:	09-Oct-2019
	*	Task	:	EVO_BACKLOG_245
	*	Description	: Covering getOldAssetItemAttributes_VM method
	----------------------------------------------------------------------------------
	* History 	:	1.1 -> 16-Oct-2019 Raising coverage of method
	*/
    @isTest
	public static void getOldAssetItemAttributes_VM_Test() {
		Account bankAcc = OB_TestDataFactory.getBankAccount();
		bankAcc.OB_ABI__c = '03138';
		bankAcc.NE__Status__c = 'Active';
		insert bankAcc;

		Account  merchantAcc = OB_TestDataFactory.getAccount();
		merchantAcc.NE__VAT__c = '12289830155';
		merchantAcc.NE__Status__c = 'Prospect';
		merchantAcc.OB_Bank_owner__c = bankAcc.Id;
		merchantAcc.OB_BypassValidation__c = true;
		merchantAcc.OB_Employees_Number__c = 'Minore di 10';
		merchantAcc.OB_Legal_Form__c = 'SOCIETÀ PER AZIONI';
		merchantAcc.OB_Status__c = 'Active';
		insert merchantAcc;

		NE__Order_Header__c orderHead = OB_TestDataFactory.getOrderHeader();
		insert orderHead;

		NE__Order__c configuration = OB_TestDataFactory.getOrder(orderHead);
		insert configuration;

        Id recordTypeProductPricing = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
		NE__Product__c pricingVisaProduct = new NE__Product__c();
        pricingVisaProduct.Name = 'VISA/MASTERCARD';
        pricingVisaProduct.RecordTypeId = recordTypeProductPricing;
        insert pricingVisaProduct;

		NE__Billing_Profile__c billingProf = new NE__Billing_Profile__c();
		billingProf.NE__Account__c = merchantAcc.Id;
		billingProf.OB_Bank_Account_Owner__c = bankAcc.Id;
		billingProf.OB_Bank_Account_Type__c = 'Debit';
		billingProf.OB_ABICode__c ='03138';
		billingProf.OB_CABCode__c = '12300';
		billingProf.OB_CINCode__c = 'Q';
		billingProf.OB_CountryCode__c = 'IT';
		billingProf.OB_EuroControlCode__c = '31';
		insert billingProf;
		
        NE__Product__c uniqueCommissionProduct = new NE__Product__c();
        uniqueCommissionProduct.name = 'Commissione Unica';
        insert uniqueCommissionProduct;
        
        NE__Product__c visaMastercardProduct = new NE__Product__c();
        visaMastercardProduct.name = 'VISA/MASTERCARD';
        visaMastercardProduct.RecordTypeId = recordTypeProductPricing;
        insert visaMastercardProduct;
        
		Asset offerAsset = OB_TestDataFactory.getAsset();
		offerAsset.Name = 'Offerta Personalizzata';
		offerAsset.OB_ProposerABI__c = bankAcc.Id;
		offerAsset.AccountId = merchantAcc.Id;
		offerAsset.Quantity = 1;
		offerAsset.NE__Action__c = 'None';
		offerAsset.NE__BillingProf__c = billingProf.Id;
        offerAsset.NE__ProdId__c  = visaMastercardProduct.Id;
        offerAsset.NE__Status__c = 'Active'; 
        offerAsset.NE__Order_Config__c = configuration.Id;
		insert offerAsset;
        
        Asset uniqueCommissionAsset = new  Asset();  
        uniqueCommissionAsset.Name = 'Commissione Unica';
        uniqueCommissionAsset.AccountId = merchantAcc.Id;
		uniqueCommissionAsset.NE__Bundle_Configuration__c = offerAsset.Id;
        uniqueCommissionAsset.NE__ProdId__c = uniqueCommissionProduct.Id;
        insert uniqueCommissionAsset; 
            
		Asset visaAsset = new Asset();
		visaAsset.AccountId = merchantAcc.Id;
		visaAsset.Name = 'VISA/MASTERCARD';
		visaAsset.NE__BillingProf__c = billingProf.Id;
		visaAsset.NE__Billing_Account__c = bankAcc.Id;
		visaAsset.NE__Bundle_Configuration__c = offerAsset.Id;
		visaAsset.NE__Order_Config__c = configuration.Id;
        visaAsset.NE__ProdId__c = visaMastercardProduct.Id;
		insert visaAsset;
        
        Test.startTest();
        	/* ANDREA MORITTU START 16-Oct-209 - FIX_Code_review	*/
        	Map<String, List<NE__AssetItemAttribute__c>> toMatch = OB_OperationalData_CC.getOldAssetItemAttributes_VM(configuration.Id);
        	System.assertNotEquals(toMatch.size(), 0);
        	/* ANDREA MORITTU END 16-Oct-209 - FIX_Code_review	*/
        Test.stopTest();
	} 
}