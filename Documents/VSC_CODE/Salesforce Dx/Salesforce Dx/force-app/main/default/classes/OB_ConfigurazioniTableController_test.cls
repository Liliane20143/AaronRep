@isTest
private class OB_ConfigurazioniTableController_test {
///////////////
    static testMethod void testgetConfigurazioni() {

      Test.startTest();
      OB_ConfigurazioniTableController.getConfigurazioni(0,0,'test','OB_Listino__r.Name','asc' );
      List<String> schemaPrezzi = new List<String>();
      schemaPrezzi.add('Trilaterale');
      schemaPrezzi.add('Bilaterale');
      List<String> modello = new List<String>();
      modello.add('Bancario');
      List<String> nameProduct = new List<String>();
      nameProduct.add('test');
      //  List<String> modello2 = new List<String>();
      // modello2.add('Bancario');
      // modello2.add('Bancario2');
      // modello2.add('Bancario3');
      // System.System.debug(modello2);

      

     // OB_ConfigurazioniTableController.searchConfigurazioniServer(5, 2,'test', String.valueOf(System.now()), String.valueOf(System.now()) ,'offerta test','listino test', schemaPrezzi, modello);
      NE__Bundle__c bundle = new NE__Bundle__c(Name='test', NE__Configuration_Type__c ='Free',NE__BaseRecurringCharge__c=12.00, NE__RecurringChargeFrequency__c = 'Annual', NE__Start_Date__c = system.now(), NE__End_Date__c = system.now().addDays(1));
      insert bundle;
      NE__Matrix_Parameter__c mp = new NE__Matrix_Parameter__c(Name = 'test',OB_Offerta__c=bundle.Id,RecordTypeId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId());
      

      insert mp;
      //System.debug(mp.OB_Offerta__r.Name);
      NE__Matrix_Parameter_Row__c mpr1 = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c = mp.Id, 
                                                                         RecordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId());
      insert mpr1;
      NE__Matrix_Parameter_Row__c mpr2 = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c = mp.Id, 
                                                                         RecordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId(), OB_SelfLookup__c=mpr1.Id);

      insert mpr2;
      List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c>();

      rowList.add(mpr2);

      OB_ConfigurazioniTableController.searchConfigurazioniServer(5, 2, nameProduct, String.valueOf(System.now()), String.valueOf(System.now()) ,'offerta test','listino test', schemaPrezzi, modello, null, null);

      OB_ConfigurazioniTableController.creaConfigurazioneServer(5, 2,'', String.valueOf(System.now()) , String.valueOf(System.now()) ,bundle.Id, mp.Id, schemaPrezzi, modello);      
     // OB_ConfigurazioniTableController.creaConfigurazioneServer(5, 2,'', String.valueOf(System.now()) , String.valueOf(System.now()) ,bundle.Id, mp.Id, schemaPrezzi, modello2);      

      OB_ConfigurazioniTableController.deleteconfigurazioneServer(5,2,mp,'test');
      OB_ConfigurazioniTableController.searchForProducts('test');
      OB_ConfigurazioniTableController.searchForCatalogs('test');
      Test.stopTest();
    }

    //  @isTest
    //    public static void getConfigurazioni_catch_Test() {
    //       Test.startTest();
    //       OB_ConfigurazioniTableController.getConfigurazioni(null,null,null);

    //       Test.stopTest();
    //    }



    @isTest
	public static void deleteconfigurazioneServer_Test_Catch() {

		Decimal pageSize   = 2;
		Decimal pageNumber = 4;
		String offerta 	   = 'Offerta';		
		NE__Matrix_Parameter__c configurazioneToDelete = new NE__Matrix_Parameter__c();		

		Test.startTest();
		OB_ConfigurazioniTableController.deleteconfigurazioneServer( pageSize, pageNumber,  configurazioneToDelete, offerta);
		Test.stopTest();
		
	}
}