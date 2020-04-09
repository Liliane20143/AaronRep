/**************************************************************
* Date Created       : 16/11/2018  							  *
* Author             : Doris Tatiana						  *
* Class name to test : OB_ConfigurazioniTableNexiController   *
***************************************************************
*/
@isTest
public  class OB_ConfigurazioniTableNexi_Test {

	@isTest
	public static void getConfigurazioni_Test() {

		Test.startTest();
		Decimal pageSize   = 1;
		Decimal pageNumber = 10;
		String offerta ; 
		String abi         = '05116';

		NE__Bundle__c offertaMatrix = new NE__Bundle__c();
		offertaMatrix.Name 						       	= 'test';
		offertaMatrix.NE__Configuration_Type__c 		= 'Free';
		offertaMatrix.NE__BaseRecurringCharge__c		= 12.00;
		offertaMatrix.NE__RecurringChargeFrequency__c 	= 'Annual';
		offertaMatrix.NE__Start_Date__c 				= system.now();
		offertaMatrix.NE__End_Date__c 					= system.now().addDays(1);
      	insert offertaMatrix;

		List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
		NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c();
		NE__Matrix_Parameter__c  matrixParameter  = new NE__Matrix_Parameter__c();
			
		matrixParameter.OB_Offerta__c  = offertaMatrix.id; 
		insert matrixParameter;

		rowParent.OB_ABI_BANCA__c  	      = abi ;	
		rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
		rowParent.RecordTypeId 			  = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
		insert rowParent;
		offerta = offertaMatrix.Name;
		Schema.DescribeSObjectResult objSchema = NE__Matrix_Parameter__c.sObjectType.getDescribe();

        OB_ConfigurazioniTableNexiController.getConfigurazioni( pageSize, pageNumber, offerta, abi, null, null);
		Test.stopTest();
        
	}

	@isTest
	public static void getConfigurazioni_Test2() 
	{
		Decimal pageSize   = 0;
		Decimal pageNumber = 0;
		String offerta = ''; 
		String abi = '';
		Test.startTest();
        OB_ConfigurazioniTableNexiController.getConfigurazioni( pageSize, pageNumber, offerta, abi, null, null);
		Test.stopTest();
		
	}


	@isTest
	public static void searchConfigurazioniServer_Test() {

		Decimal pageSize   = 23;
		Decimal pageNumber = 45;
		String name = 'test';
		List<String> nameProduct = new List<String> ();
		nameProduct.add( name );
		String fromDate  = String.valueof(Datetime.newInstance(1960, 2, 17));
		String toDate    = String.valueof(Datetime.newInstance(2018, 2, 9));
		String offerta     = 'test'; 
		String listino     = 'test';
		List<String> schemaPrezzi = new List<String> ();
		schemaPrezzi.add('test 1');
		schemaPrezzi.add('test 2');
		List<String> modello = new List<String> ();
		modello.add('modello 1');
		modello.add('modello 2');
		String abi = '05696';

		NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
												  Name 						        = 'test',
												  NE__Configuration_Type__c 		= 'Free',
												  NE__BaseRecurringCharge__c		= 12.00,
												  NE__RecurringChargeFrequency__c 	= 'Annual',
												  NE__Start_Date__c 				= system.now(),
												  NE__End_Date__c 					= system.now().addDays(1));
      	insert offertaMatrix;

		List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
		NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c();
		NE__Matrix_Parameter__c  matrixParameter  = new NE__Matrix_Parameter__c();
			
		matrixParameter.OB_Offerta__c  = offertaMatrix.id; 
		insert matrixParameter;

		rowParent.OB_ABI_BANCA__c  	      = abi ;	
		rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
		rowParent.RecordTypeId 			  = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
		insert rowParent;
		offerta = offertaMatrix.Name;
		Schema.DescribeSObjectResult objSchema = NE__Matrix_Parameter__c.sObjectType.getDescribe();

		Test.startTest();
        OB_ConfigurazioniTableNexiController.searchConfigurazioniServer(pageSize, pageNumber, nameProduct ,fromDate,toDate, offerta,listino, schemaPrezzi, modello, abi, null, null);
		Test.stopTest();
		
	}

	@isTest
	public static void searchConfigurazioniServer_Test2() 
	{
		Decimal pageSize   = 2;
		Decimal pageNumber = 5;
		String name     = 'test';
		List<String> nameProduct = new List<String> ();
		nameProduct.add( name );
		String fromDate = '2019-01-01';
		String toDate   = '2021-09-09'; 
		String offerta; 
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
												  Name 						        = 'Offerta',
												  NE__Configuration_Type__c 		= 'Free',
												  NE__BaseRecurringCharge__c		= 12.00,
												  NE__RecurringChargeFrequency__c 	= 'Annual',
												  NE__Start_Date__c 				= system.now(),
												  NE__End_Date__c 					= system.now().addDays(1));
      	insert offertaMatrix;
		offerta = String.valueOf(offertaMatrix.id);

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

		NE__Matrix_Parameter_Row__c rowParent = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c = matrixParameter.id);
		rowParent.OB_ABI_BANCA__c = abi;
		rowParent.OB_CAB__c = cab;
		rowParent.RecordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
		insert rowParent;

		Test.startTest();
		OB_ConfigurazioniTableNexiController.searchConfigurazioniServer(pageSize, pageNumber, nameProduct,fromDate,toDate, offerta,listino, schemaPrezzi, modello, abi, null, null);
		Test.stopTest();
		
	}


	@isTest
	public static void creaConfigurazioneServer_Test() {

		Decimal pageSize   = 10;
		Decimal pageNumber = 1;
		String name        = 'test';
		DateTime fromDate  = Datetime.newInstance(1960, 2, 17);
		DateTime toDate    = Datetime.newInstance(2018, 2, 9);
		
		List<String> schemaPrezzi = new List<String> ();
		schemaPrezzi.add('Trilaterale');
		schemaPrezzi.add('Bilaterale');

		List<String> modello = new List<String> ();
		modello.add('Bancario');
		String abi = '05696';

		NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
												  Name 						        = 'test',
												  NE__Configuration_Type__c 		= 'Free',
												  NE__BaseRecurringCharge__c		= 12.00,
												  NE__RecurringChargeFrequency__c 	= 'Annual',
												  NE__Start_Date__c 				= system.now(),
												  NE__End_Date__c 					= system.now().addDays(1));
      	insert offertaMatrix;
		
		NE__Catalog__c cat = new NE__Catalog__c();
		insert cat;

		NE__Catalog_Item__c  catalogItem = new NE__Catalog_Item__c( NE__Catalog_Id__c = cat.Id, NE__Active__c = true);
		insert catalogItem;
		NE__Matrix_Parameter__c matrixListino   = new NE__Matrix_Parameter__c();
		insert matrixListino;

		NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c();
		matrixParameter.NE__Active__c           = true;
		matrixParameter.NE__Start_Date__c       = Date.newInstance(2018, 2, 9);
		matrixParameter.OB_ModelloAcquiring__c  = 'Bancario';
		matrixParameter.OB_SchemaPrezzi__c      = 'Trilaterale';
		Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
		matrixParameter.RecordTypeId     = recordTypeId;
		matrixParameter.OB_Listino__c    = matrixListino.id;
		matrixParameter.OB_Offerta__c    = offertaMatrix.id;
		matrixParameter.OB_Componente__c = catalogItem.id; 
		insert matrixParameter;

		String listino = String.valueOf( matrixListino.id);
		
		Test.startTest();
		OB_ConfigurazioniTableNexiController.creaConfigurazioneServer( pageSize, pageNumber,  String.valueOf(catalogItem.id) ,fromDate,toDate, offertaMatrix.id,listino, schemaPrezzi, modello);
		Test.stopTest();

	}


	@isTest
	public static void deleteconfigurazioneServer_Test() {

		Decimal pageSize   = 23;
		Decimal pageNumber = 45;
		String offerta ;

		NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
									        Name 						    = 'test',
									        NE__Configuration_Type__c 		= 'Free',
									        NE__BaseRecurringCharge__c		= 12.00,
									        NE__RecurringChargeFrequency__c = 'Annual',
									        NE__Start_Date__c 				= system.now(),
									        NE__End_Date__c 				= system.now().addDays(1));
      	insert offertaMatrix;		

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
		OB_ConfigurazioniTableNexiController.deleteconfigurazioneServer( pageSize, pageNumber,  configurazioneToDelete, offerta);
		Test.stopTest();
		
	}



	@isTest
	public static void deleteconfigurazioneServer_Test_Catch() {

		Decimal pageSize   = 2;
		Decimal pageNumber = 4;
		String offerta 	   = 'Offerta';		
		NE__Matrix_Parameter__c configurazioneToDelete = new NE__Matrix_Parameter__c();		

		Test.startTest();
		OB_ConfigurazioniTableNexiController.deleteconfigurazioneServer( pageSize, pageNumber,  configurazioneToDelete, offerta);
		Test.stopTest();
		
	}



	@isTest
	public static void searchForProducts_Test() {

		String searchText = 'test';
		Test.startTest();
		OB_ConfigurazioniTableNexiController.searchForProducts(searchText);
		Test.stopTest();
		
	}

	@isTest
	public static void searchForCatalogs_Test() {

		String searchText = 'test';
		Test.startTest();
		OB_ConfigurazioniTableNexiController.searchForCatalogs(searchText);
		Test.stopTest();
		
	}		

}