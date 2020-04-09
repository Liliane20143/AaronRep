/**************************************************************
* Date Created       : 30/10/2018                             *
* Author             : Doris Tatiana                          *
* Class name to test : OB_CatalogDetailsController            *
***************************************************************
*/
@isTest
public  class OB_CatalogDetailsTest {

    @isTest
    public static void getRowsByMatrixParameterId_Test() {

        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c>();
        NE__Matrix_Parameter_Row__c matrixRow = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter__c matrixParam = new NE__Matrix_Parameter__c();
        insert matrixParam;

        matrixRow.NE__Matrix_Parameter__c = matrixParam.Id;
        matrixRow.RecordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        //insert matrixRow;
        matrixRow.NE__Matrix_Parameter__c = matrixParam.id ;
        insert matrixRow;

        Test.startTest();
        OB_CatalogDetailsController.getRowsByMatrixParameterId(matrixParam);
        Test.stopTest();
    }

    @isTest
    public static void calculateDate_Test() {

        Date myDate            = Date.newInstance(1960, 2, 17);
        Date endDateParent     = mydate.addDays(-1);
        String newDateToString = String.valueof(endDateParent);

        Test.startTest();
        OB_CatalogDetailsController.calculateDate(newDateToString);
        Test.stopTest();
    }  


    @isTest
    public static void insertCloneRow_Test() {

        List<NE__Matrix_Parameter_Row__c> rowChildren = new List<NE__Matrix_Parameter_Row__c>();
        List<NE__Catalog_Item__c> catalogItemsToClone = new List<NE__Catalog_Item__c>();
        NE__Matrix_Parameter_Row__c rowParent         = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter__c   matrixParam         = new NE__Matrix_Parameter__c(Name = 'Test');
        insert matrixParam;

        rowParent.NE__Matrix_Parameter__c = matrixParam.Id;
        rowParent.NE__Start_Date__c = Date.newInstance(1960, 2, 17);
        //insert rowParent;
        NE__Catalog__c cat = new NE__Catalog__c();
        insert cat;

        NE__Catalog_Item__c  catalogItem = new NE__Catalog_Item__c( NE__Catalog_Id__c = cat.Id, NE__Active__c = true);
        //insert catalogItem;

        NE__Matrix_Parameter_Row__c newRowParent  = rowParent.clone(false, false, false, false);
        
    
        rowChildren.add(rowParent);
        catalogItemsToClone.add(catalogItem);
        insert rowChildren;
        insert catalogItemsToClone;

        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceNexi').getRecordTypeId();
        newRowParent.NE__Start_Date__c = rowParent.NE__Start_Date__c.addDays(1);
        newRowParent.NE__End_Date__c   = null;
        newRowParent.RecordTypeId = recordTypeId;
        
        Test.startTest();
        OB_CatalogDetailsController.insertCloneRow(rowParent, rowChildren,catalogItemsToClone);
        Test.stopTest();
    }   


    @isTest
    public static void updateRows_Test() {

        List<NE__Matrix_Parameter_Row__c> rowList  = new List<NE__Matrix_Parameter_Row__c>();
        NE__Matrix_Parameter_Row__c     rowParent  = new NE__Matrix_Parameter_Row__c();
        rowParent.NE__Start_Date__c                = Date.newInstance(2002, 2, 17);
        rowParent.NE__End_Date__c                  = Date.newInstance(2018, 12, 12);
        map<id,NE__Matrix_Parameter_Row__c> rowmap = new map<id,NE__Matrix_Parameter_Row__c>();
        rowList.add(rowParent);
        rowmap.putAll(rowList);

        Test.startTest();
        OB_CatalogDetailsController.updateRows(rowList);
        Test.stopTest();
    }  



    @isTest
    public static void getCatalogItemsByProductIdServer_Test() {

        String productName;
        Test.startTest();
        OB_CatalogDetailsController.getCatalogItemsByProductIdServer(productName);
        Test.stopTest();
    } 

    @isTest
    public static void fetchCatalogItemsByProductIdServer_Test() {

        String productName;
        List<NE__Product__c> prodIdList = new List<NE__Product__c>();
        List<NE__Catalog_Item__c> catalogItems = new List<NE__Catalog_Item__c>();
        Set<NE__Product__c> prodIdSet = new Set<NE__Product__c>(prodIdList);
        Test.startTest();
        OB_CatalogDetailsController.fetchCatalogItemsByProductIdServer(productName ,prodIdList );
        Test.stopTest();
    }

        
    @isTest
    public static void getCommercialProducts_Test() {

        List<NE__Matrix_Parameter_Row__c> rows = new List<NE__Matrix_Parameter_Row__c>();
        Test.startTest();
        OB_CatalogDetailsController.getCommercialProducts(rows);
        Test.stopTest();
    }   


    @isTest
    public static void insertNewRowsServer_Test() {
        //List<NE__Matrix_Parameter_Row__c> newRows,NE__Matrix_Parameter_Row__c newRow, String matrixParameterId, NE__Matrix_Parameter__c matrixParameter)
        List<NE__Matrix_Parameter_Row__c> rows = new List<NE__Matrix_Parameter_Row__c>();
        NE__Matrix_Parameter_Row__c newRow     = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter__c matrixParam    = new NE__Matrix_Parameter__c();
        //insert matrixParam;
        NE__DynamicPropertyDefinition__c dpd   = new NE__DynamicPropertyDefinition__c();
        insert dpd; 
        NE__Family__c  famille                 = new NE__Family__c();
        insert famille; 
        
        String matrixParameterId = matrixParam.id;
        Id newId;
        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId();
        newRow.RecordTypeId                    = recordTypeId;
        //newRow.NE__Matrix_Parameter__c         = matrixParameterId;
        newRow.OB_DynamicPropertyDefinition__c = dpd.id;
        newRow.OB_Family__c                    = famille.id;
        newRow.NE__Active__c                   = true;
        rows.add(newRow);
        //insert newRow;
        //insert rows;      
        Test.startTest();
        List<NE__Matrix_Parameter_Row__c> result = OB_CatalogDetailsController.insertNewRowsServer(rows, newRow, matrixParameterId,matrixParam);
        Test.stopTest();
    }   

    @isTest
    public static void insertNewRowsServer_test2() 
    {
        List<NE__Matrix_Parameter_Row__c> rows = new List<NE__Matrix_Parameter_Row__c>();
        NE__DynamicPropertyDefinition__c dpd   = new NE__DynamicPropertyDefinition__c();
        insert dpd; 
        NE__Family__c  famille                 = new NE__Family__c();
        insert famille; 
        Id newId;
        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId();
        
        NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
                                                  Name                              = 'Bundle Free',
                                                  NE__Configuration_Type__c         = 'Free',
                                                  NE__BaseRecurringCharge__c        = 12.00,
                                                  NE__RecurringChargeFrequency__c   = 'Annual',
                                                  NE__Start_Date__c                 = system.now(),
                                                  NE__End_Date__c                   = system.now().addDays(1));
        insert offertaMatrix;
        
        NE__Catalog__c catalog  = new NE__Catalog__c();
        catalog.Name = 'Nexi';
        catalog.NE__Active__c = false;
        insert catalog;

        NE__Catalog_Item__c  catalogItem = new NE__Catalog_Item__c( NE__Active__c = true);
        catalogItem.NE__Catalog_Id__c  = catalog.id;
        catalogItem.NE__Recurring_Charge_Frequency__c = 'Monthly';
        catalogItem.NE__BaseRecurringCharge__c = 3;
        insert catalogItem;

        NE__Matrix_Parameter__c matrixListino   = new NE__Matrix_Parameter__c();
        insert matrixListino;

        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c();
        matrixParameter.NE__Active__c          = true;
        matrixParameter.NE__Start_Date__c      = Date.newInstance(2018, 2, 9);
        matrixParameter.OB_ModelloAcquiring__c = 'Bancario';
        matrixParameter.OB_SchemaPrezzi__c     = 'Trilaterale';
        Id recordTypeId2 = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        matrixParameter.RecordTypeId     = recordTypeId2;
        matrixParameter.OB_Listino__c    = matrixListino.id;
        matrixParameter.OB_Offerta__c    = offertaMatrix.id;
        matrixParameter.OB_Componente__c = catalogItem.id; 
        insert matrixParameter;

        String matrixParameterId = matrixParameter.id;
        
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c       newRow2  = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter_Row__c       newRow3  = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter_Row__c       newRow4  = new NE__Matrix_Parameter_Row__c();
        rows.add(newRow2);
        rows.add(newRow3);
        rows.add(newRow4);

        NE__Matrix_Parameter_Row__c       newRow  = new NE__Matrix_Parameter_Row__c();

        Test.startTest();
        List<NE__Matrix_Parameter_Row__c> result = OB_CatalogDetailsController.insertNewRowsServer(rows, newRow, matrixParameterId,matrixParameter);
        Test.stopTest();
    }



    @isTest
    public static void getFamiliesForChildrenRowsServer_Test() {

        List<NE__Product__c> products  = new List<NE__Product__c>();
        NE__Product__c       product   = new NE__Product__c ();
        product.Name = 'OneClick';
        products.add(product);  
        insert products;

        NE__Family__c  famille  = new NE__Family__c();
        famille.NE__Hidden__c   = false;
        //famille.NE__Number_of_attributes__c = 11;
        insert famille; 

        List<NE__ProductFamily__c> listToReturn = new List<NE__ProductFamily__c>();
        NE__ProductFamily__c productFamily      = new NE__ProductFamily__c();
        productFamily.NE__ProdId__c   = product.id;
        productFamily.NE__FamilyId__c = famille.id;
        listToReturn.add(productFamily);
        insert listToReturn;
        
        Test.startTest();
        OB_CatalogDetailsController.getFamiliesForChildrenRowsServer(products);
        Test.stopTest();
    } 


    @isTest
    public static void getFamiliesServer_Test() {

        String productId;

        List< NE__ProductFamily__c> families = new List< NE__ProductFamily__c> ();
        NE__ProductFamily__c productFamily = new NE__ProductFamily__c();
        families.add(productFamily);

        Test.startTest();
        OB_CatalogDetailsController.getFamiliesServer(productId);
        Test.stopTest();
    } 



    @isTest
    public static void retrieveAttributesFromFamilies_Test() {

        //NE__family__c families  = new NE__family__c ();
        List<NE__ProductFamilyProperty__c> attributes = new List<NE__ProductFamilyProperty__c>();
        List<Id>  families = new List<Id> ();        
    
        Test.startTest();
        List<NE__ProductFamilyProperty__c> result = OB_CatalogDetailsController.retrieveAttributesFromFamilies(families);
        Test.stopTest();
    } 


    @isTest
    public static void searchForProducts_Test() {

        String searchText;
        List<NE__Product__c> products = new List<NE__Product__c>();
            
        Test.startTest();
        OB_CatalogDetailsController.searchForProducts(searchText);
        Test.stopTest();
    } 


    @isTest
    public static void deleteSelectedRow_Test() {

        List<NE__Matrix_Parameter_Row__c> listToDelete = new List<NE__Matrix_Parameter_Row__c> ();

        Test.startTest();
        OB_CatalogDetailsController.deleteSelectedRow(listToDelete);
        Test.stopTest();
    } 


}