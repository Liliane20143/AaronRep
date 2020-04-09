/**************************************************************
* Date Created       : 12/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_ConfigurationDetailsBankCABController
***************************************************************
*/

@isTest
public class OB_ConfigurationDetailsBankCAB_Test {

    @isTest
    public static void getRowsByMatrixParameterId_test() {

        String offerName;
        String abi;
        NE__Matrix_Parameter__c matrixParameter   = new NE__Matrix_Parameter__c();
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        
        Test.startTest();
        OB_ConfigurationDetailsBankCABController.getRowsByMatrixParameterId(offerName, abi, matrixParameter);
        Test.stopTest();

        
    }


    @isTest
    public static void calculateDate_test() {

        Date myDate = Date.newInstance(1990, 11, 21);
        Date newDate = myDate.addMonths(-1);

        String startDate = String.valueOf(newDate);
        
        Test.startTest();
        OB_ConfigurationDetailsBankCABController.calculateDate(startDate);
        Test.stopTest();

        
    }

    @isTest
    public static void insertCloneRow_test() {

        Date myDate = Date.newInstance(1990, 11, 21);
        Date newDate = myDate.addMonths(-1);

        NE__Matrix_Parameter_Row__c rowParent  = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter_Row__c rowParent1 = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c();

        rowParent.NE__Start_Date__c  = myDate;
        rowParent1.NE__Start_Date__c = newDate;

        List<NE__Matrix_Parameter_Row__c> rowChildren = new List<NE__Matrix_Parameter_Row__c>();
        rowChildren.add(rowParent);
        rowChildren.add(rowParent1);
        //insert rowChildren;
        Test.startTest();
        OB_ConfigurationDetailsBankCABController.insertCloneRow(rowParent,rowChildren );
        Test.stopTest();

        
    }


    @isTest
    public static void getCatalogItems_test() {

        String searchText = '';

        Test.startTest();
        OB_ConfigurationDetailsBankCABController.getCatalogItems(searchText );
        Test.stopTest();

        
    }



    @isTest
    public static void getChildCatalogItems_test() {

        //String productId = '';
        NE__Product__c  product   = new NE__Product__c ();
        product.Name = 'OneClick';
        insert product;

        Test.startTest();
        OB_ConfigurationDetailsBankCABController.getChildCatalogItems(product.Id );
        Test.stopTest();

        
    }

    
    @isTest
    public static void updateRows_test() {

        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter__c   matrixParameter = new NE__Matrix_Parameter__c();
        insert matrixParameter;
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        rowList.add(rowParent);

        Test.startTest();
        OB_ConfigurationDetailsBankCABController.updateRows( rowList );
        Test.stopTest();

        
    }



    @isTest
    public static void insertNewRowsServer_test() 
    {

        NE__Matrix_Parameter__c   matrixParameter = new NE__Matrix_Parameter__c(    Name = 'test');
     
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c       newRow  = new NE__Matrix_Parameter_Row__c();
        
        NE__Family__c  famille = new NE__Family__c();
        insert famille;
        String matrixParameterId ;//= matrixParameter.id;
        //newRow.NE__Matrix_Parameter__c = matrixParameter.id;
        newRow.OB_Family__c = famille.id;
        newRow.NE__Active__c = true;
    
        rowList.add(newRow);

        Test.startTest();
        OB_ConfigurationDetailsBankCABController.insertNewRowsServer(rowList, newRow, matrixParameterId );
        Test.stopTest();

        
    }
    
    @isTest
    public static void insertNewRowsServer_test2() 
    {
        
        NE__Family__c  famille = new NE__Family__c();
        insert famille;

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
        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        matrixParameter.RecordTypeId     = recordTypeId;
        matrixParameter.OB_Listino__c    = matrixListino.id;
        matrixParameter.OB_Offerta__c    = offertaMatrix.id;
        matrixParameter.OB_Componente__c = catalogItem.id; 
        insert matrixParameter;

        String matrixParameterId = matrixParameter.id;
        
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c       newRow2  = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter_Row__c       newRow3  = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter_Row__c       newRow4  = new NE__Matrix_Parameter_Row__c();
        //newRow.NE__Matrix_Parameter__c = matrixParameter.id;
        // newRow.OB_Family__c = famille.id;
        // newRow.NE__Active__c = true;
        rowList.add(newRow2);
        rowList.add(newRow3);
        rowList.add(newRow4);

        NE__Matrix_Parameter_Row__c       newRow  = new NE__Matrix_Parameter_Row__c();
        // newRow.NE__Matrix_Parameter__c = matrixParameter.id;
        // newRow.OB_Family__c = famille.id;
        // newRow.NE__Active__c = true;
        // insert newRow;

        Test.startTest();
        OB_ConfigurationDetailsBankCABController.insertNewRowsServer(rowList, newRow, matrixParameterId );
        Test.stopTest();
    }


    @isTest
    public static void insertNewRowServer_test() {

        String componente;
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c();
        NE__Matrix_Parameter_Row__c newRow      = new NE__Matrix_Parameter_Row__c();
        
        Test.startTest();
        OB_ConfigurationDetailsBankCABController.insertNewRowServer(newRow, componente, matrixParameter);
        Test.stopTest();

        
    }


    @isTest
    public static void getFamiliesServer_test() {

        String componente;
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c();
        NE__Matrix_Parameter_Row__c newRow      = new NE__Matrix_Parameter_Row__c();
        
        Test.startTest();
        OB_ConfigurationDetailsBankCABController.getFamiliesServer( componente);
        Test.stopTest();

        
    }


    @isTest
    public static void getFamiliesForChildrenRowsServer_test() {

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
        OB_ConfigurationDetailsBankCABController.getFamiliesForChildrenRowsServer( products);
        Test.stopTest();

        
    }


    @isTest
    public static void retrieveAttributesFromFamilies_test() {

        List<NE__family__c>  families = new List<NE__family__c>();
        NE__Family__c  famille  = new NE__Family__c();
        families.add(famille);
        insert families;        
        Test.startTest();
        OB_ConfigurationDetailsBankCABController.retrieveAttributesFromFamilies( families);
        Test.stopTest();

        
    }



    @isTest
    public static void deleteSelectedRow_test() {

        List<NE__Matrix_Parameter_Row__c> listToDelete = new List<NE__Matrix_Parameter_Row__c>();
        NE__Matrix_Parameter_Row__c       newRow       = new NE__Matrix_Parameter_Row__c();
        NE__Matrix_Parameter__c        matrixParameter = new NE__Matrix_Parameter__c(   Name = 'test');
        insert matrixParameter;
        newRow.NE__Matrix_Parameter__c = matrixParameter.id;
        listToDelete.add(newRow);
        insert listToDelete;
        
        Test.startTest();
        OB_ConfigurationDetailsBankCABController.deleteSelectedRow( listToDelete);
        Test.stopTest();

        
    }





}