/**************************************************************
* Date Created       : 14/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_ConfigurazioniTableCABController
***************************************************************
*/
@isTest
public  class OB_ConfigurazioniTableCAB_Test {
    
    @isTest
    public static void getConfigurazioni_Test() {

        
        Test.startTest();
        Decimal pageSize   = 5;
        Decimal pageNumber = 4;
        String offerta ; 
        String abi = '05696';
        String cab = '89764';
        
        NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
                                                  Name                              = 'test',
                                                  NE__Configuration_Type__c         = 'Free',
                                                  NE__BaseRecurringCharge__c        = 12.00,
                                                  NE__RecurringChargeFrequency__c   = 'Annual',
                                                  NE__Start_Date__c                 = system.now(),
                                                  NE__End_Date__c                   = system.now().addDays(1));
        insert offertaMatrix;

        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter_Row__c     rowMatrix = new NE__Matrix_Parameter_Row__c();      
        NE__Matrix_Parameter__c  matrixParameter  = new NE__Matrix_Parameter__c();          
        matrixParameter.OB_Offerta__c  = offertaMatrix.id; 
        insert matrixParameter;

        rowParent.OB_ABI_BANCA__c         = abi ;   
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        rowParent.RecordTypeId            = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
        insert rowParent;

        rowMatrix.NE__Active__c             = false;
        rowMatrix.NE__Matrix_Parameter__c   = matrixParameter.id;
        rowMatrix.RecordTypeId              = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
        insert rowMatrix;

        rowList.add(rowParent);

        offerta = offertaMatrix.Name;       
        OB_ConfigurazioniTableCABController.getConfigurazioni( pageSize, pageNumber, offerta, abi,cab );
        Test.stopTest();
        
    }

    @isTest
    public static void getConfigurazioni_Test2() 
    {
        Decimal pageSize   = 5;
        Decimal pageNumber = 4;
        String offerta ; 
        String abi = '05696';
        String cab = '89764';
        
        NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
                                                  Name                              = 'test',
                                                  NE__Configuration_Type__c         = 'Free',
                                                  NE__BaseRecurringCharge__c        = 12.00,
                                                  NE__RecurringChargeFrequency__c   = 'Annual',
                                                  NE__Start_Date__c                 = system.now(),
                                                  NE__End_Date__c                   = system.now().addDays(1));
        insert offertaMatrix;

        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter_Row__c     rowMatrix = new NE__Matrix_Parameter_Row__c();      
        NE__Matrix_Parameter__c  matrixParameter  = new NE__Matrix_Parameter__c();          
        matrixParameter.OB_Offerta__c  = offertaMatrix.id; 
        insert matrixParameter;

        rowParent.OB_ABI_BANCA__c         = abi ;   
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        rowParent.RecordTypeId            = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
        insert rowParent;

        rowMatrix.NE__Active__c             = false;
        rowMatrix.NE__Matrix_Parameter__c   = matrixParameter.id;
        rowMatrix.RecordTypeId              = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
        insert rowMatrix;

        rowList.add(rowParent);

        offerta = offertaMatrix.Name;   

        NE__Bundle__c offertaMatrix2 = new NE__Bundle__c( 
                                                  Name                              = 'Offerta',
                                                  NE__Configuration_Type__c         = 'Free',
                                                  NE__BaseRecurringCharge__c        = 12.00,
                                                  NE__RecurringChargeFrequency__c   = 'Annual',
                                                  NE__Start_Date__c                 = system.now(),
                                                  NE__End_Date__c                   = system.now().addDays(1));
        insert offertaMatrix2;
        //offerta = String.valueOf(offertaMatrix.id);
        NE__Catalog__c catalog  = new NE__Catalog__c();
        catalog.Name = 'Nexi';
        catalog.NE__Active__c = false;
        insert catalog;

        NE__Item_Header__c itemHead = new NE__Item_Header__c();
        insert itemHead;
        NE__Product__c prod = new NE__Product__c();
        prod.Name = 'Product';
        insert prod;

        NE__Catalog_Item__c  catalogItem = new NE__Catalog_Item__c( NE__Active__c = true);
        catalogItem.NE__Catalog_Id__c  = catalog.id;
        catalogItem.NE__ProductId__c = prod.id;
        //catalogItem.NE__Product_Name__c = //formula --> Product Name
        catalogItem.NE__Item_Header__c = itemHead.id;
        insert catalogItem;

        List<NE__Matrix_Parameter_Row__c> rowList2 = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter__c  matrixParameter3  = new NE__Matrix_Parameter__c();
        matrixParameter3.name = 'matrix2';
        insert matrixParameter3;
        NE__Matrix_Parameter__c  matrixParameter2  = new NE__Matrix_Parameter__c();
        matrixParameter2.Name = 'Test';
        matrixParameter2.NE__Active__c = true;
        Datetime dtEnd = (Datetime) system.now().addDays(1);
        matrixParameter2.NE__End_Date__c = dtEnd.date();
        Datetime dtStart = (Datetime) system.now();
        matrixParameter2.NE__Start_Date__c = dtStart.date();
        matrixParameter.OB_ModelloAcquiring__c = 'Bancario';
        matrixParameter2.OB_SchemaPrezzi__c = 'Diretto';
        matrixParameter2.OB_Componente__c = catalogItem.id;
        // matrixParameter.OB_Componente__r.NE__Product_Name__c,
        // matrixParameter.OB_Componente__r.NE__Item_Header__c,
        matrixParameter2.OB_Listino__c = matrixParameter2.id;
        matrixParameter2.OB_Offerta__c  = offertaMatrix.id; 
        insert matrixParameter2;

        NE__Matrix_Parameter_Row__c     rowParent2 = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c = matrixParameter.id);
        rowParent2.OB_ABI_BANCA__c = abi;
        rowParent2.OB_CAB__c = cab;
        rowParent2.RecordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
        insert rowParent2;
        Test.startTest();   
        OB_ConfigurazioniTableCABController.getConfigurazioni( pageSize, pageNumber, offerta, abi,cab );
        Test.stopTest();
        
    }


    @isTest
    public static void getConfigurazioni_Test_Catch() {

        
        Test.startTest();
        Decimal pageSize   = 5;
        Decimal pageNumber = 4;
        String offerta     = ''; 
        String abi         = '';
        String cab         = '';
    
        OB_ConfigurazioniTableCABController.getConfigurazioni( pageSize, pageNumber, offerta, abi,cab );
        Test.stopTest();
        
    }


    @isTest
    public static void searchConfigurazioniServer_Test() {

        Decimal pageSize   = 2;
        Decimal pageNumber = 5;
        String name     = 'test';
        String fromDate = String.valueOf(Datetime.newInstance(1960, 2, 17));
        String toDate   = String.valueOf(Datetime.newInstance(2018, 2, 9));
        String offerta  = 'Offerta'; 
        String listino  = 'test';
        List<String> schemaPrezzi = new List<String> ();
        schemaPrezzi.add('Trilaterale');
        //schemaPrezzi.add('test 2');
        List<String> modello = new List<String> ();
        modello.add('Bancario');
        //modello.add('modello 2');
        String abi = '05696';
        String cab = '12345';

        NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
                                                  Name                              = 'test',
                                                  NE__Configuration_Type__c         = 'Free',
                                                  NE__BaseRecurringCharge__c        = 12.00,
                                                  NE__RecurringChargeFrequency__c   = 'Annual',
                                                  NE__Start_Date__c                 = system.now(),
                                                  NE__End_Date__c                   = system.now().addDays(1));
        insert offertaMatrix;
        offerta = String.valueOf(offertaMatrix.id);

        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter__c  matrixParameter  = new NE__Matrix_Parameter__c();
            
        matrixParameter.OB_Offerta__c  = offertaMatrix.id; 
        insert matrixParameter;

        rowParent.OB_ABI_BANCA__c         = abi ;   
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        rowParent.RecordTypeId            = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        insert rowParent;

        Test.startTest();
        OB_ConfigurazioniTableCABController.searchConfigurazioniServer2( pageSize, pageNumber, name,fromDate,toDate, offerta,listino, schemaPrezzi, modello, abi ,cab);
        Test.stopTest();
        
    }

    @isTest
    public static void searchConfigurazioniServer_Test2() {

        Decimal pageSize   = 2;
        Decimal pageNumber = 5;
        String name     = '';
        String fromDate = '';
        String toDate   = '';
        String offerta  = 'Offerta'; 
        String listino  = '';
        List<String> schemaPrezzi = new List<String> ();
        //schemaPrezzi.add('Trilaterale');
        List<String> modello = new List<String> ();
        //modello.add('Bancario');
        String abi = '05696';
        String cab = '12345';

        NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
                                                  Name                              = 'test',
                                                  NE__Configuration_Type__c         = 'Free',
                                                  NE__BaseRecurringCharge__c        = 12.00,
                                                  NE__RecurringChargeFrequency__c   = 'Annual',
                                                  NE__Start_Date__c                 = system.now(),
                                                  NE__End_Date__c                   = system.now().addDays(1));
        insert offertaMatrix;
        offerta = String.valueOf(offertaMatrix.id);

        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter__c  matrixParameter  = new NE__Matrix_Parameter__c();
            
        matrixParameter.OB_Offerta__c  = offertaMatrix.id; 
        insert matrixParameter;

        rowParent.OB_ABI_BANCA__c         = abi ;   
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        rowParent.RecordTypeId            = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        insert rowParent;

        Test.startTest();
        OB_ConfigurazioniTableCABController.searchConfigurazioniServer( pageSize, pageNumber, name,fromDate,toDate, offerta,listino, schemaPrezzi, modello, abi ,cab);
        Test.stopTest();
        
    }

    @isTest
    public static void searchConfigurazioniServer_Test3() {

        Decimal pageSize   = 2;
        Decimal pageNumber = 5;
        String name     = 'test';
        String fromDate = '2019-02-14';
        String toDate   = '2020-09-09'; 
        String offerta  = 'Offerta'; 
        String listino  = 'test';
        List<String> schemaPrezzi = new List<String> ();
        schemaPrezzi.add('Trilaterale');
        schemaPrezzi.add('Diretto');
        List<String> modello = new List<String> ();
        modello.add('Bancario');
        modello.add('Bilaterale');
        String abi = '05696';
        String cab = '12345';

        NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
                                                  Name                              = 'Offerta',
                                                  NE__Configuration_Type__c         = 'Free',
                                                  NE__BaseRecurringCharge__c        = 12.00,
                                                  NE__RecurringChargeFrequency__c   = 'Annual',
                                                  NE__Start_Date__c                 = system.now(),
                                                  NE__End_Date__c                   = system.now().addDays(1));
        insert offertaMatrix;
        //offerta = String.valueOf(offertaMatrix.id);
        NE__Catalog__c catalog  = new NE__Catalog__c();
        catalog.Name = 'Nexi';
        catalog.NE__Active__c = false;
        insert catalog;

        NE__Item_Header__c itemHead = new NE__Item_Header__c();
        insert itemHead;
        NE__Product__c prod = new NE__Product__c();
        prod.Name = 'Product';
        insert prod;

        NE__Catalog_Item__c  catalogItem = new NE__Catalog_Item__c( NE__Active__c = true);
        catalogItem.NE__Catalog_Id__c  = catalog.id;
        catalogItem.NE__ProductId__c = prod.id;
        //catalogItem.NE__Product_Name__c = //formula --> Product Name
        catalogItem.NE__Item_Header__c = itemHead.id;
        insert catalogItem;

        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter__c  matrixParameter2  = new NE__Matrix_Parameter__c();
        matrixParameter2.name = 'matrix2';
        insert matrixParameter2;
        NE__Matrix_Parameter__c  matrixParameter  = new NE__Matrix_Parameter__c();
        matrixParameter.Name = 'Test';
        matrixParameter.NE__Active__c = true;
        Datetime dtEnd = (Datetime) system.now().addDays(1);
        matrixParameter.NE__End_Date__c = dtEnd.date();
        Datetime dtStart = (Datetime) system.now();
        matrixParameter.NE__Start_Date__c = dtStart.date();
        matrixParameter.OB_ModelloAcquiring__c = 'Bancario';
        matrixParameter.OB_SchemaPrezzi__c = 'Diretto';
        matrixParameter.OB_Componente__c = catalogItem.id;
        // matrixParameter.OB_Componente__r.NE__Product_Name__c,
        // matrixParameter.OB_Componente__r.NE__Item_Header__c,
        matrixParameter.OB_Listino__c = matrixParameter2.id;
        matrixParameter.OB_Offerta__c  = offertaMatrix.id; 
        insert matrixParameter;

        NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c = matrixParameter.id);
        rowParent.OB_ABI_BANCA__c = abi;
        rowParent.OB_CAB__c = cab;
        rowParent.RecordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
        insert rowParent;
        
        Test.startTest();
        OB_ConfigurazioniTableCABController.searchConfigurazioniServer( pageSize, pageNumber, name,fromDate,toDate, offerta,listino, schemaPrezzi, modello, abi ,cab);
        Test.stopTest();
        
    }

    @isTest
    public static void creaConfigurazioneServer_Test() {
        
        Decimal pageSize   = 3;
        Decimal pageNumber = 6;
        String name        = 'test';
        String fromDate = String.valueOf(Datetime.newInstance(1960, 2, 17));
        String toDate = String.valueOf(Datetime.newInstance(2018, 2, 9));
        
        List<String> schemaPrezzi = new List<String> ();
        schemaPrezzi.add('Trilaterale');

        List<String> modello = new List<String> ();
        modello.add('Bancario');
        String abi = '05696';

        NE__Bundle__c offertaMatrix = new NE__Bundle__c();
        offertaMatrix.Name = 'Bundle Free';
        //insert offertaMatrix;
        //Id offerta = offertaMatrix.id;
        
        NE__Catalog__c catalog  = new NE__Catalog__c();
        catalog.Name = 'Nexi';
        catalog.NE__Active__c = false;
        insert catalog;

        NE__Catalog_Item__c  catalogItem = new NE__Catalog_Item__c( NE__Active__c = true);
        catalogItem.NE__Catalog_Id__c  = catalog.id;
        insert catalogItem;

        NE__Matrix_Parameter__c matrixListino   = new NE__Matrix_Parameter__c();
        insert matrixListino;

        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c();
        matrixParameter.NE__Active__c          = true;
        matrixParameter.NE__Start_Date__c      = Date.newInstance(2018, 2, 9);
        matrixParameter.OB_ModelloAcquiring__c = 'Bancario';
        matrixParameter.OB_SchemaPrezzi__c     = 'Trilaterale';
        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        matrixParameter.RecordTypeId     = recordTypeId;
        matrixParameter.OB_Listino__c    = matrixListino.id;
        matrixParameter.OB_Offerta__c    = offertaMatrix.id;
        matrixParameter.OB_Componente__c = catalogItem.id; 
        insert matrixParameter;

        String listino = String.valueOf( matrixListino.id);
        
        Test.startTest();
        OB_ConfigurazioniTableCABController.creaConfigurazioneServer( pageSize, pageNumber, catalogItem.Name,fromDate,toDate, offertaMatrix.id,listino, schemaPrezzi, modello);
        Test.stopTest();
        
    }



    
    @isTest
    public static void creaConfigurazioneServer_Test_Catch() {
        
        Decimal pageSize   = 3;
        Decimal pageNumber = 6;
        String name        = 'test';
        String listino     = '';
        String fromDate = String.valueOf(Datetime.newInstance(1960, 2, 17));
        String toDate = String.valueOf(Datetime.newInstance(2018, 2, 9));
        
        List<String> schemaPrezzi = new List<String> ();
        schemaPrezzi.add('Trilaterale');

        List<String> modello = new List<String> ();
        modello.add('Bancario');
        String abi = '05696';

        NE__Bundle__c offertaMatrix = new NE__Bundle__c();
        offertaMatrix.Name = 'Bundle Free';
            
        Test.startTest();
        OB_ConfigurazioniTableCABController.creaConfigurazioneServer( pageSize, pageNumber, name,fromDate,toDate, offertaMatrix.id,listino, schemaPrezzi, modello);
        Test.stopTest();
        
    }

    @isTest
    public static void creaConfigurazioneServer_Test3() {
        
        Decimal pageSize   = 3;
        Decimal pageNumber = 6;
        String name        = 'test';
        String fromDate = String.valueOf(Datetime.newInstance(1960, 2, 17));
        String toDate = String.valueOf(Datetime.newInstance(2018, 2, 9));
        
        List<String> schemaPrezzi = new List<String> ();
        schemaPrezzi.add('Trilaterale');

        List<String> modello = new List<String> ();
        modello.add('Bancario');
        String abi = '05696';

        NE__Bundle__c offertaMatrix = new NE__Bundle__c();
        offertaMatrix.Name = 'Bundle Free';
        //insert offertaMatrix;
        //Id offerta = offertaMatrix.id;
        
        NE__Catalog__c catalog  = new NE__Catalog__c();
        catalog.Name = 'Nexi';
        catalog.NE__Active__c = false;
        insert catalog;

        NE__Catalog_Item__c  catalogItem = new NE__Catalog_Item__c( NE__Active__c = true);
        catalogItem.NE__Catalog_Id__c  = catalog.id;
        insert catalogItem;

        NE__Matrix_Parameter__c matrixListino   = new NE__Matrix_Parameter__c();
        insert matrixListino;

        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c();
        matrixParameter.NE__Active__c          = true;
        matrixParameter.NE__Start_Date__c      = Date.newInstance(2018, 2, 9);
        matrixParameter.OB_ModelloAcquiring__c = 'Bancario';
        matrixParameter.OB_SchemaPrezzi__c     = 'Trilaterale';
        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        matrixParameter.RecordTypeId     = recordTypeId;
        matrixParameter.OB_Listino__c    = matrixListino.id;
        matrixParameter.OB_Offerta__c    = offertaMatrix.id;
        matrixParameter.OB_Componente__c = catalogItem.id; 
        insert matrixParameter;

        String listino = String.valueOf( matrixListino.id);
        
        NE__Matrix_Parameter__c matrixDuplicate = new NE__Matrix_Parameter__c();
        matrixDuplicate.NE__Active__c = true;
        Id recordTypeIdDuplicate = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
        matrixDuplicate.RecordTypeId = recordTypeIdDuplicate;
        matrixDuplicate.OB_Offerta__c = offertaMatrix.id;
        matrixDuplicate.OB_Componente__c = catalogItem.Name;
        matrixDuplicate.NE__Start_Date__c = Date.valueOf(fromDate);
        matrixDuplicate.OB_SchemaPrezzi__c = '';
        matrixDuplicate.OB_ModelloAcquiring__c = 'Bancario';
        matrixDuplicate.NE__End_Date__c = Date.valueOf(toDate);

        insert matrixDuplicate;

        Test.startTest();
        OB_ConfigurazioniTableCABController.creaConfigurazioneServer( pageSize, pageNumber, catalogItem.Name,fromDate,toDate, offertaMatrix.id,listino, schemaPrezzi, modello);
        Test.stopTest();
        
    }


    @isTest
    public static void deleteconfigurazioneServer_Test() {

        Decimal pageSize = 3;
        Decimal pageNumber = 5;
        String offerta ;

        NE__Bundle__c offertaMatrix = new NE__Bundle__c();
        offertaMatrix.Name = 'Bundle Free';
        //insert offertaMatrix;

        NE__Matrix_Parameter__c configurazioneToDelete = new NE__Matrix_Parameter__c();
        configurazioneToDelete.NE__Active__c          = true;
        configurazioneToDelete.NE__Start_Date__c      = Date.newInstance(2018, 2, 9);
        configurazioneToDelete.OB_ModelloAcquiring__c = 'Bancario';
        configurazioneToDelete.OB_SchemaPrezzi__c     = 'Trilaterale';
        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        configurazioneToDelete.RecordTypeId           = recordTypeId;
        offerta = offertaMatrix.Name;
        insert configurazioneToDelete;

        Test.startTest();
        OB_ConfigurazioniTableCABController.deleteconfigurazioneServer( pageSize, pageNumber,  configurazioneToDelete, offerta);
        Test.stopTest();
        
    }

    @isTest
    public static void deleteconfigurazioneServer_Test_Catch() {

        Decimal pageSize   = 2;
        Decimal pageNumber = 4;
        String offerta     = '';

        NE__Matrix_Parameter__c configurazioneToDelete = new NE__Matrix_Parameter__c();
        Test.startTest();
        OB_ConfigurazioniTableCABController.deleteconfigurazioneServer( pageSize, pageNumber,  configurazioneToDelete, offerta);
        Test.stopTest();
        
    }



    @isTest
    public static void searchForProducts_Test() {

        String searchText = 'test';
        List<NE__Catalog_Item__c> catalogItems = new List<NE__Catalog_Item__c> ();

        Test.startTest();
        OB_ConfigurazioniTableCABController.searchForProducts(searchText);
        Test.stopTest();
        
    }

    @isTest
    public static void searchForCatalogs_Test() {

        String searchText = 'test';
        NE__Matrix_Parameter__c   matrixParameter = new NE__Matrix_Parameter__c();
        List<NE__Matrix_Parameter__c> listini = new List<NE__Matrix_Parameter__c>();
        listini.add(matrixParameter);

        Test.startTest();
        OB_ConfigurazioniTableCABController.searchForCatalogs(searchText);
        Test.stopTest();
        
    }       
}