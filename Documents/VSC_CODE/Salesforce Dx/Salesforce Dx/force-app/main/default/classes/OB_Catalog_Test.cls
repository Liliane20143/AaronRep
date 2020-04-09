@isTest
public class OB_Catalog_Test
{
    
    @isTest
    public static void setConfigurationToApproveTest1( )
    {
        NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;

        NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = oh.id);
        ord.OB_ApprovalLevel__c = OB_UtilityConstants.L1; //R1F2_RP_012 Z. Urban <z.urban@accenture.com> 29/03/2019 Add OB_ApprovalLevel__c value
        insert ord;

        //START R1F2_RP_012 Z. Urban <z.urban@accenture.com> 02/04/2019 Assert not updated
        Boolean isUpdated = OB_CatalogController.setConfigurationToApprove( ord.id );
        System.assertEquals( false, isUpdated );
        //STOP R1F2_RP_012  Z. Urban <z.urban@accenture.com> 02/04/2019
    }

    @isTest
    public static void setConfigurationToApproveTest2( )
    {
        String stringConcat = '05116' + OB_UtilityConstants.APPROVAZIONE_PRICING + ' ' + OB_UtilityConstants.L2;

        Group g = new Group(Name = stringConcat, Type = 'Queue');
        insert g;

        System.runAs( new User( Id = UserInfo.getUserId( ) ) )
        {
            QueuesObject q = new QueueSObject( QueueID = g.id, SobjectType = 'NE__Order__c' );
            insert q;
        }

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId( );
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

        NE__Order_Header__c oh = new NE__Order_Header__c(OB_ProposerABI__c = acc.id, OB_Business_Model_Acquiring__c = 'Bancario', OB_Business_Model_POS__c = 'Trilaterale Nuovo', OB_Main_Process__c = 'Setup');
        insert oh;

        NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = oh.id, OwnerId = UserInfo.getUserId( ) ); //R1F2_RP_012 Z. Urban <z.urban@accenture.com> 02/04/2019 Change Id
        ord.OB_ApprovalLevel__c = OB_UtilityConstants.L2; //R1F2_RP_012 Z. Urban <z.urban@accenture.com> 29/03/2019 Add OB_ApprovalLevel__c value
        insert ord;

        //START R1F2_RP_012 Z. Urban <z.urban@accenture.com> 02/04/2019 Assert updated
        Boolean isUpdated = OB_CatalogController.setConfigurationToApprove( ord.id );
        System.assertEquals( true , isUpdated );  
        //STOP R1F2_RP_012  Z. Urban <z.urban@accenture.com> 02/04/2019
    }

    @isTest
    public static void setConfigurationToApproveTest3( )
    {
        String stringConcat = '05116' + OB_UtilityConstants.APPROVAZIONE_PRICING + ' ' + OB_UtilityConstants.L3;

        Group g = new Group(Name = stringConcat, Type = 'Queue');
        insert g;

        System.runAs(new User(Id = UserInfo.getUserId( ))) {
            QueuesObject q = new QueueSObject(QueueID = g.id, SobjectType = 'NE__Order__c');
            insert q;
        }

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Bank' ).getRecordTypeId( );
        Account acc = new Account( Name = 'TEST3',
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

        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.id, OwnerId = g.id );
        ord.OB_ApprovalLevel__c = OB_UtilityConstants.L3; //R1F2_RP_012 Z. Urban <z.urban@accenture.com> 29/03/2019 Add OB_ApprovalLevel__c value
        insert ord;
        
        //START R1F2_RP_012 Z. Urban <z.urban@accenture.com> 02/04/2019 Assert not updated
        Boolean isUpdated = OB_CatalogController.setConfigurationToApprove( ord.id );
        System.assertEquals( false, isUpdated );
        //STOP R1F2_RP_012  Z. Urban <z.urban@accenture.com> 02/04/2019
    }

    /**
    *@author Z. Urban <z.urban@accenture.com> 
    *@date 29/03/2019
    *@description R1F2_RP_012 Method tests not available level approval
    */
    @isTest
    public static void setConfigurationToApprove_NullApproval()
    {


        String stringConcat = '05116' + OB_UtilityConstants.APPROVAZIONE_PRICING + ' ' + OB_UtilityConstants.L3;

        Group g = new Group(Name = stringConcat, Type = 'Queue');
        insert g;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            QueuesObject q = new QueueSObject( QueueID = g.id, SobjectType = 'NE__Order__c' );
            insert q;
        }

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get( 'Bank' ).getRecordTypeId( );
        Account acc = new Account( Name = 'TEST4',
                RecordTypeId = accountRecordTypeId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'BTTMHR00D03H504T',
                OB_BypassValidation__c = true,
                OB_Status__c = 'Active',
                OB_ABI__c = '05116' );
        insert acc;

        NE__Order_Header__c oh = new NE__Order_Header__c( OB_ProposerABI__c = acc.id, OB_Business_Model_Acquiring__c = 'Bancario', OB_Business_Model_POS__c = 'Trilaterale Nuovo', OB_Main_Process__c = 'Setup' );
        insert oh;

        NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = oh.id, OwnerId = UserInfo.getUserId( ) );
        ord.OwnerId = UserInfo.getUserId();
        ord.OB_ApprovalLevel__c = 'null';
        insert ord;
        
        Boolean isUpdated = OB_CatalogController.setConfigurationToApprove( ord.id );
        System.assertEquals( false, isUpdated ); 
    }

    @isTest
    public static void saveAndExitBit2FlowCallerTest1( )
    {
        OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c();
        ic.Name = 'DEV1';
        ic.OB_Domain__c = 'dev1';
        ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.nynF9045u2M-1WGn007JxObPiM3PBK0Q4GM8EBwQS0o6fJutTABfMSTtekOlCpQEv4vKSLmj0-Rgk5rQgireCX-cOp_Vvh9IYLl6xfOJfUR8f5mLUmY4r7BGrWtLbaM5wwTIJXQs8kFpp2VIePragkN2MahtjIOtBp1vQW2y';
        ic.OB_timestamp__c = '1542902538147';
        ic.OB_Timeout_Continuation__c = '30';
        insert ic;
        NE__Order_Header__c oh = new NE__Order_Header__c( );
        insert oh;
        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.id );
        insert ord;

        bit2flow__Wizard_Definition__c b2F = new bit2flow__Wizard_Definition__c( bit2flow__Description__c = 'Test', bit2flow__Label__c = 'Test', bit2flow__Name__c = 'Test' );
        insert b2F;

        Map<String, Object> data = new Map<String, Object>( );

        String stringData = String.valueOf( data );

        String wizardWrapperString = '{"label" : "' + b2F.bit2flow__Label__c + '", "name" : "' + b2F.bit2flow__Name__c + '", "id" : "' + b2F.id + '"}';
        Boolean isCommunity = true;
        Test.startTest( );
        OB_CatalogController.saveAndExitBit2FlowCaller( stringData, wizardWrapperString, isCommunity );
        Test.stopTest( );
    }

    @isTest
    public static void saveAndExitBit2FlowCallerTest2( )
    {
        Map<String, Object> data = new Map<String, Object>();
        String stringData = String.valueOf(data);
        String wizardWrapperString = '{"label" : "myLabel", "name" : "myName", "id" : null}';
        Boolean isCommunity = true;
        Test.startTest();
        OB_CatalogController.saveAndExitBit2FlowCaller( stringData, wizardWrapperString, isCommunity );
        Test.stopTest();
    }

    @isTest
    public static void saveAndExitBit2FlowCallerTest3( )
    {
        Test.startTest( );
        NE__Order_Header__c oh = new NE__Order_Header__c( );
        insert oh;
        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.id );
        insert ord;

        Map<String, Object> data = new Map<String, Object>( );
        String stringData = String.valueOf( data );

        String wizardWrapperString = 'null';
        Boolean isCommunity = true;
        OB_CatalogController.saveAndExitBit2FlowCaller( stringData, wizardWrapperString, isCommunity );
        Test.stopTest( );
    }

    /*******************************************************************************
       Purpose:  Method tests OB_CatalogController.saveAndExitBit2FlowCaller, checks
                 if returned String (URL) is not null, nor blank
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                  DATE            DETAIL          Description
       1.0      Natalia Nawrocka        17/06/2019         Created             ---
       ********************************************************************************/
    @isTest
    public static void saveAndExitBit2FlowCallerTest4( )
    {
        OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c();
        ic.Name = 'DEV1';
        ic.OB_Domain__c = 'dev1';
        ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.nynF9045u2M-1WGn007JxObPiM3PBK0Q4GM8EBwQS0o6fJutTABfMSTtekOlCpQEv4vKSLmj0-Rgk5rQgireCX-cOp_Vvh9IYLl6xfOJfUR8f5mLUmY4r7BGrWtLbaM5wwTIJXQs8kFpp2VIePragkN2MahtjIOtBp1vQW2y';
        ic.OB_timestamp__c = '1542902538147';
        ic.OB_Timeout_Continuation__c = '30';
        insert ic;

        NE__Order_Header__c oh = new NE__Order_Header__c( );
        insert oh;
        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.Id );
        insert ord;

        bit2flow__Wizard_Definition__c testWizard = OB_TestDataFactory.getWizardDefinition( );
        insert testWizard;

        Map<String, Object> data = new Map<String, Object>( );
        data.put('OrderHeader', oh);
        String stringData = JSON.serialize(data);
        System.debug(String.valueOf(data));

        String wizardWrapperString = '{"label" : "Test Wizard", "name" : "Test Wizard", "id" : "' + testWizard.Id + '" }';
        Boolean isCommunity = true;
        String toTest = OB_CatalogController.saveAndExitBit2FlowCaller( stringData, wizardWrapperString, isCommunity );
        System.assert(String.isNotBlank(toTest));
    }

    @isTest
    public static void updateConfigVariation( )
    {
        Test.startTest( );
        String variation = 'CONFERMATO';
        NE__Order__c order = new NE__Order__c( );
        order.OB_Variation__c = variation;
        insert order;
        OB_CatalogController.updateConfigVariation( order.Id, variation );
        Test.stopTest( );
    }

    @isTest
    public static void launchMaintenanceWizard_Test( )
    {
        String wizardName = 'testWiz';
        Test.startTest( );
        OB_CatalogController.launchMaintenanceWizard( wizardName );
        Test.stopTest( );
    }

    @isTest
    public static void createLogRequestServer_Test1( )
    {
        Test.startTest( );
        NE__Order_Header__c oh = new NE__Order_Header__c(
                OB_Business_Model_Acquiring__c = 'Bancario',
                OB_Business_Model_POS__c = 'Trilaterale Nuovo',
                OB_Main_Process__c = 'Setup' );
        insert oh;
        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.id );
        insert ord;

        Id recordTypeIdProd = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( 'Terminali' ).getRecordTypeId( );
        NE__Product__c prod = new NE__Product__c( Name = 'test ',
                OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial',
                RecordTypeId = recordTypeIdProd);

        insert prod;

        Id recordTypeIdTerm = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName( ).get( 'Terminali' ).getRecordTypeId( );
        NE__OrderItem__c orderItemP = new NE__OrderItem__c( NE__OrderId__c = ord.Id,
                NE__ProdId__c = prod.Id,
                NE__Qty__c = 1,
                OB_VariationPOSPB__c = 'PEGGIORATIVA'
        );
        orderItemP.RecordTypeId = recordTypeIdTerm;

        List<NE__OrderItem__c> orderItemPOS = new List<NE__OrderItem__c>( );
        orderItemPOS.add(orderItemP);
        insert orderItemPOS;
        System.debug( 'orderItemPOS = ' + orderItemPOS );

        Id recordTypeIdProd1 = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( 'Acquiring' ).getRecordTypeId( );
        NE__Product__c prod1 = new NE__Product__c( Name = 'test ',
                OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial',
                RecordTypeId = recordTypeIdProd1);

        insert prod1;

        Id recordTypeIdAcq = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName( ).get( 'Acquiring' ).getRecordTypeId( );
        NE__OrderItem__c orderItemV = new NE__OrderItem__c( NE__OrderId__c = ord.Id,
                NE__Qty__c = 1,
                NE__ProdId__c = prod1.Id,
                OB_VariationPOSPB__c = 'PEGGIORATIVA'
        );
        orderItemV.RecordTypeId = recordTypeIdAcq;

        List<NE__OrderItem__c> orderItemAcqVAS = new List<NE__OrderItem__c>();
        orderItemAcqVAS.add(orderItemV);
        insert orderItemAcqVAS;

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Merchant' ).getRecordTypeId( );
        Account acc = new Account( Name = 'TEST',
                RecordTypeId = accountRecordTypeId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_Status__c = 'Active',
                OB_ABI__c = '05116');
        insert acc;

        NE__Service_Point__c servicePoint = new NE__Service_Point__c(  );

        String merchantId = acc.id;
        String servicePointId = servicePoint.id;
        String confId = String.valueOf(ord.id);
        String abi = '05116';
        String cab = '12345';
        String subProcess = 'variazione economica';
        Boolean checkBIO = True ;
        OB_CatalogController.createLogRequestServer( merchantId, servicePointId, confId, abi, cab, subProcess, checkBIO );

        Test.stopTest( );
    }

    @isTest
    public static void createLogRequestServer_Test2( )
    {
        Test.startTest( );
        NE__Order_Header__c oh = new NE__Order_Header__c(
                OB_Business_Model_Acquiring__c = 'Bancario',
                OB_Business_Model_POS__c = 'Trilaterale Nuovo',
                OB_Main_Process__c = 'Setup');
        insert oh;
        NE__Order__c ord = new NE__Order__c( NE__Order_Header__c = oh.id );
        insert ord;

        Id recordTypeIdProd = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( 'Acquiring' ).getRecordTypeId( );
        NE__Product__c prod = new NE__Product__c( Name = 'test',
                OB_Contract_Type__c = 'Contratto Acquiring',
                RecordTypeId = recordTypeIdProd);

        insert prod;

        Id recordTypeIdTerm = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName( ).get( 'Acquiring' ).getRecordTypeId( );
        NE__OrderItem__c orderItemP = new NE__OrderItem__c( NE__OrderId__c = ord.Id,
                NE__ProdId__c = prod.Id,
                NE__Qty__c = 1,
                OB_VariationPOSPB__c = 'PEGGIORATIVA'
        );
        orderItemP.RecordTypeId = recordTypeIdTerm;

        List<NE__OrderItem__c> orderItemAcqVAS = new List<NE__OrderItem__c>( );
        orderItemAcqVAS.add( orderItemP );
        insert orderItemAcqVAS;
        System.debug( 'orderItemAcqVAS = ' + orderItemAcqVAS );

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Merchant' ).getRecordTypeId( );
        Account acc = new Account(Name = 'TEST',
                RecordTypeId = accountRecordTypeId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_Status__c = 'Active',
                OB_ABI__c = '05116');
        insert acc;

        NE__Service_Point__c servicePoint = new NE__Service_Point__c( );

        String merchantId = acc.id;
        String servicePointId = servicePoint.id;
        String confId = String.valueOf( ord.id );
        String abi = '05116';
        String cab = '12345';
        String subProcess = 'subProcess';
        Boolean checkBIO = True ;
        OB_CatalogController.createLogRequestServer( merchantId, servicePointId, confId, abi, cab, subProcess, checkBIO );
        Test.stopTest( );
    }

    //@author Francesca Ribezzi <francesca.ribezzi@accenture.com>
    //@date 16/04/19
    //@description checkForAcquiringChangesServer test method
    @isTest
    public static void checkForAcquiringChangesServer_Test() 
    {
        NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;
        NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = oh.id);            
        insert ord; 

        Test.startTest();
            OB_CatalogController.checkForAcquiringChangesServer(ord.Id);
        Test.stopTest();

    }
}