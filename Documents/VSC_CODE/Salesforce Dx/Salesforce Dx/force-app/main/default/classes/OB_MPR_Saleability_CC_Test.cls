/*****************************************************************
Name: OB_MPR_Saleability_Test
============================================================
Purpose:  Class tests OB_MPR_Saleability_CC class

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Francesca Ribezzi          02/07/2019       Created        Catalog On Off Stream
********************************************************************************/
@IsTest

public class OB_MPR_Saleability_CC_Test {

  @TestSetup 
  public static void initTest() {
//    test setup method
NE__Catalog__c catalogo = new NE__Catalog__c(Name='Catalogo_Nexi');
        insert catalogo;  
        Id RecordTypeIdProd = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();
        NE__Product__c prod = new NE__Product__c( );
		prod.Name = 'prod';
        prod.RecordTypeId = RecordTypeIdProd;
		insert prod;
		NE__Catalog_Item__c catItem = new NE__Catalog_Item__c( ); 
        catItem.NE__Catalog_Id__c = catalogo.id;
		catItem.NE__ProductId__c = prod.id;
		insert catItem;
        NE__Family__c family = new NE__Family__c();
        insert family;

        NE__DynamicPropertyDefinition__c dynamic = new NE__DynamicPropertyDefinition__c();
        insert dynamic;

        NE__Bundle__c offerta  = new NE__Bundle__c(Name='Test Offerta', NE__BaseRecurringCharge__c=1, NE__RecurringChargeFrequency__c='Annual', NE__Catalog__c=catalogo.Id, NE__Start_Date__c=System.now().addDays(-1), NE__End_Date__c=System.now().addDays(1), NE__Active__c = true);
        insert offerta;
        Account bank1 = new Account();
        bank1.Name = 'test';
        bank1.OB_ABI__C = '05116'; 
        Id RecordTypeIdBank= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bank').getRecordTypeId();
        bank1.recordTypeId = RecordTypeIdBank;
        insert bank1;

        Id RecordTypeIdMatrix= Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceNexi').getRecordTypeId();
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c(NE__Active__c = true, NE__Start_Date__c = Date.newInstance(2018, 2, 9), OB_Offerta__c=offerta.Id, OB_Componente__c = catItem.id, RecordTypeId = RecordTypeIdMatrix, OB_SchemaPrezzi__c = 'Trilaterale');
        insert matrixParameter;
        NE__Matrix_Parameter__c matrixParameter2 = new NE__Matrix_Parameter__c(NE__Active__c = true, NE__Start_Date__c = Date.newInstance(2018, 2, 9), OB_Offerta__c=offerta.Id, OB_Componente__c = catItem.id, OB_SchemaPrezzi__c = 'Bilaterale');
        insert matrixParameter2;
        //davide.franzini - 09/07/2019 - F2WAVE2-108 - START
        Id RecordTypeIdABI= Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        NE__Matrix_Parameter__c matrixParameter3 = new NE__Matrix_Parameter__c(OB_ABI__c = '01234', NE__Active__c = true, NE__Start_Date__c = Date.newInstance(2018, 2, 9), OB_Offerta__c=offerta.Id, OB_Componente__c = catItem.id, RecordTypeId = RecordTypeIdABI, OB_SchemaPrezzi__c = 'Trilaterale');
        insert matrixParameter3;
        NE__Matrix_Parameter__c matrixParameter4 = new NE__Matrix_Parameter__c(OB_ABI__c = '43210', NE__Active__c = true, NE__Start_Date__c = Date.newInstance(2018, 2, 9), OB_Offerta__c=offerta.Id, OB_Componente__c = catItem.id, RecordTypeId = RecordTypeIdABI, OB_SchemaPrezzi__c = 'Bilaterale');
        insert matrixParameter4;
        //davide.franzini - 09/07/2019 - F2WAVE2-108 - END
        Id RecordTypeIdRow = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceNexi').getRecordTypeId();
        NE__Matrix_Parameter_Row__c row = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c=matrixParameter.Id, OB_ABI_BANCA__c='05116', OB_Componente__c = catItem.id, OB_Family__c = family.Id,  OB_DynamicPropertyDefinition__c = dynamic.Id, OB_Schema_Prezzi__c= 'Trilaterale');
        insert row;
        NE__Matrix_Parameter_Row__c row2 = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c=matrixParameter.Id, OB_ABI_BANCA__c=null, RecordTypeId = RecordTypeIdRow, OB_SelfLookup__c = row.Id,OB_Componente__c = catItem.id, OB_Family__c =  family.Id,  OB_DynamicPropertyDefinition__c = dynamic.Id, OB_Schema_Prezzi__c= 'Trilaterale Nuovo'); 
        insert row2;
        NE__Matrix_Parameter_Row__c row3 = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c=matrixParameter.Id, OB_ABI_BANCA__c=null, RecordTypeId = RecordTypeIdRow,OB_Componente__c = catItem.id, OB_Family__c =  family.Id,  OB_DynamicPropertyDefinition__c = dynamic.Id, OB_Schema_Prezzi__c= 'Bilaterale'); 
        insert row3;


  }
  @isTest
    public static void getAvailableABI_Test() {
        //davide.franzini - 09/07/2019 - F2WAVE2-108 - START
        List<NE__Matrix_Parameter__c>  matrixParameters =   
        [SELECT id, Name,OB_ABI__c,RecordTypeId,OB_Componente__c
            from NE__Matrix_Parameter__c 
        ]; 
        //davide.franzini - 09/07/2019 - F2WAVE2-108 - END

        List<NE__Bundle__c> bundles =  [SELECT id, Name from ne__bundle__c where name = 'Test Offerta'];
        Test.startTest();
            OB_MPR_Saleability_CC.getAvailableABI(bundles[0].Id);
        Test.stopTest();
  
    }
  
}