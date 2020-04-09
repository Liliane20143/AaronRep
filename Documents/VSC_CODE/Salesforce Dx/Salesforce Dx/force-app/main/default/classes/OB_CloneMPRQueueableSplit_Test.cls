/*****************************************************************
Name: OB_CloneMPRQueueableSplit_Test
Purpose:  Class tests OB_CloneMPRQueueableSplit class

History
--------
VERSION     AUTHOR                  DATE            DETAIL          
1.0         misani.simone           25/10/2019      created            
********************************************************************************/
@isTest
public class OB_CloneMPRQueueableSplit_Test {
  @isTest
       public static void test11 ()
    {
        NE__Catalog__c nexiCatalog = new NE__Catalog__c( Name = 'Catalogo_Nexi' );
        insert nexiCatalog;
        NE__Product__c product = OB_TestDataFactory.getProduct( );
        product.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        insert product;
        NE__Catalog_Item__c catalogItem = new NE__Catalog_Item__c( );
        catalogItem.NE__Catalog_Id__c = nexiCatalog.Id;
        catalogItem.NE__ProductId__c = product.Id;
        insert catalogItem;
        NE__Family__c family = new NE__Family__c( );
        insert family;
        NE__DynamicPropertyDefinition__c dynamic = new NE__DynamicPropertyDefinition__c( );
        insert dynamic;

        NE__Bundle__c offerta = new NE__Bundle__c( );
        offerta.Name = 'Test Offerta';
        offerta.NE__BaseRecurringCharge__c = 1;
        offerta.NE__RecurringChargeFrequency__c = 'Annual';
        offerta.NE__Catalog__c = nexiCatalog.Id;
        offerta.NE__Start_Date__c = System.now( ).addDays( -1 );
        offerta.NE__End_Date__c = System.now( ).addDays( 1 );
        offerta.NE__Active__c = true;
        insert offerta;

        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        matrixParameter.NE__Active__c = true;
        matrixParameter.NE__Start_Date__c = Date.newInstance( 2018, 2, 9 );
        matrixParameter.OB_Offerta__c = offerta.Id;
        matrixParameter.OB_Componente__c = catalogItem.Id;
        matrixParameter.OB_SchemaPrezzi__c = 'Trilaterale';
        insert matrixParameter;
        
         NE__Matrix_Parameter_Row__c row1 = new NE__Matrix_Parameter_Row__c( );
        row1.NE__Matrix_Parameter__c = matrixParameter.Id;
        row1.OB_ABI_BANCA__c = '05116';
        row1.OB_Cab__c = '12345';
        row1.OB_Componente__c = matrixParameter.OB_Componente__c;
        row1.OB_Family__c = family.Id;
        row1.OB_DynamicPropertyDefinition__c = dynamic.Id;
        row1.OB_Schema_Prezzi__c = matrixParameter.OB_SchemaPrezzi__c;
        row1.OB_SelfLookup__c = null;
        insert row1;

        NE__Matrix_Parameter_Row__c row = new NE__Matrix_Parameter_Row__c( );
        row.NE__Matrix_Parameter__c = matrixParameter.Id;
        row.OB_ABI_BANCA__c = '05116';
        row.OB_Cab__c = '12345';
        row.OB_Componente__c = matrixParameter.OB_Componente__c;
        row.OB_Family__c = family.Id;
        row.OB_DynamicPropertyDefinition__c = dynamic.Id;
        row.OB_Schema_Prezzi__c = matrixParameter.OB_SchemaPrezzi__c;
        row.OB_SelfLookup__c = row1.id;
        insert row;
		List<NE__Matrix_Parameter_Row__c> listRow = new List<NE__Matrix_Parameter_Row__c>();
        listRow.add(row);
        Map<String, String> matrixIdAbiSetmap = new Map<String,String>( );
        Set<String> abiSet = new Set<String>( );
        String abi = '05116';
        String cab = '12345';
       
        matrixIdAbiSetmap.put( matrixParameter.Id, abi );

        OB_CloneMPRQueueableSplit updater = new OB_CloneMPRQueueableSplit( matrixIdAbiSetmap ,listRow );
    
    User testUser = [ SELECT Id FROM User WHERE Profile.UserLicense.Name = 'Salesforce' AND IsActive = true LIMIT 1 ].get( 0 );
   
    System.runAs( testUser )
        {
            Test.startTest( );
            System.enqueueJob(updater);
            List<NE__Matrix_Parameter_Row__c> listMPR = [SELECT id FROM NE__Matrix_Parameter_Row__c WHERE NE__Matrix_Parameter__r.OB_Offerta__c =: offerta.id];

            Boolean listMPRVuota = (listMPR.isEmpty());

            System.assertEquals(false, listMPRVuota);
            Test.stopTest( );
        }
    }

}