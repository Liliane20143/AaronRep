/**************************************************************
* Date Created       : 13/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_ConfigurazioniTableBankController
***************************************************************
*/
@isTest
public with sharing class OB_ConfigurazioniTableBank_Test {

	@isTest
	public static void getConfigurazioni_Test() {

		Test.startTest();
		Decimal pageSize   = 5;
		Decimal pageNumber = 4;
		String offerta ; 
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
		//giovanni spinelli 19/04/2019 add new params and pass them in running method- start
		String orderName=null;
		String sortDirection='ASC';		
		OB_ConfigurazioniTableBankController.getConfigurazioni( pageSize, pageNumber, offerta, abi, orderName,sortDirection);
		orderName ='OB_Componente__r.NE__Product_Name__c';
		OB_ConfigurazioniTableBankController.getConfigurazioni( pageSize, pageNumber, offerta, abi, orderName,sortDirection);
		//giovanni spinelli 19/04/2019 add new params and pass them in running method- end
		Test.stopTest();
		
	}
	

	@isTest
	public static void searchConfigurazioniServer_Test() {

		Decimal pageSize   = 2;
		Decimal pageNumber = 5;
		String name        = 'test';
		DateTime fromDate  = Datetime.newInstance(1960, 2, 17);
		DateTime toDate    = Datetime.newInstance(2018, 2, 9);
		String offerta ; 
		String listino = 'test';
		List<String> schemaPrezzi = new List<String> ();
		schemaPrezzi.add('Trilaterale');
		// schemaPrezzi.add('Trilaterale Nuovo');
		List<String> modello = new List<String> ();
		 modello.add('Bancario');
		String abi = '05696';
         NE__catalog_header__c catHeader = new NE__catalog_header__c();
		 catHeader.NE__Name__c='abcd123456';
		 insert catHeader;
		 NE__Item_Header__c headeritem = new NE__Item_Header__c();
		insert headeritem;

		NE__Product__c prod       = new NE__Product__c();
        insert prod;

		 NE__Catalog__c cat        = new NE__Catalog__c();
         cat.NE__Catalog_Header__c = catHeader.Id;
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
		ci.NE__Catalog_Id__c = cat.id;
		ci.NE__ProductId__c = prod.id;
		ci.NE__Item_Header__c = headeritem.Id;
        insert ci;
		String nameCatItem = string.valueOf(ci.id);

        


		
		NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
												  Name 						        = 'test',
												  NE__Configuration_Type__c 		= 'Free',
												  NE__BaseRecurringCharge__c		= 12.00,
												  NE__RecurringChargeFrequency__c 	= 'Annual',
												  NE__Start_Date__c 				= system.now(),
												  NE__End_Date__c 					= system.now().addDays(1));
      	insert offertaMatrix;
      	offerta = offertaMatrix.id;

		List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
		NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c();

		NE__Matrix_Parameter__c  matrixParameterListino  = new NE__Matrix_Parameter__c();
		matrixParameterListino.OB_Componente__c = ci.Id;
		matrixParameterListino.OB_Listino__c    = rowParent.Id;
		matrixParameterListino.OB_SchemaPrezzi__c='Trilaterale';
		matrixParameterListino.OB_Offerta__c  = offertaMatrix.id; 
		insert matrixParameterListino;

		NE__Matrix_Parameter__c  matrixParameter  = new NE__Matrix_Parameter__c();
		matrixparameter.OB_Componente__c = ci.Id;
		matrixParameter.OB_Listino__c    = rowParent.Id;
		matrixParameter.OB_SchemaPrezzi__c='Trilaterale';
		matrixParameter.OB_Offerta__c  = offertaMatrix.id; 
		insert matrixParameter;
			

		rowParent.OB_ABI_BANCA__c  	      = abi ;	
		rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
		rowParent.RecordTypeId 			  = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
		insert rowParent;


		Test.startTest();
		OB_ConfigurazioniTableBankController.searchConfigurazioniServer( pageSize, pageNumber, '','','', '','', schemaPrezzi, modello, abi );
		Test.stopTest();
		
	}

	
	@isTest
	public static void getConfigurazioni_Test_Catch() {

        Decimal pageSize   = 2;
		Decimal pageNumber = 5;
		String name        = 'test';
		DateTime fromDate  = Datetime.newInstance(1960, 2, 17);
		DateTime toDate    = Datetime.newInstance(2018, 2, 9);
		String offerta ; 
		String listino = 'test';
		List<String> schemaPrezzi = new List<String> ();
		schemaPrezzi.add('test 1');
		schemaPrezzi.add('test 2');
		List<String> modello = new List<String> ();
		modello.add('modello 1');
		modello.add('modello 2');
		String abi = '05696';
        NE__Item_Header__c headeritem = new NE__Item_Header__c();
		insert headeritem;

		NE__Product__c prod       = new NE__Product__c();
        insert prod;

		 NE__Catalog__c cat        = new NE__Catalog__c();
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
		ci.NE__Catalog_Id__c = cat.id;
		ci.NE__ProductId__c = prod.id;
		ci.NE__Item_Header__c = headeritem.Id;
        insert ci;
        
		
        
		

		
		NE__Bundle__c offertaMatrix = new NE__Bundle__c( 
												  Name 						        = 'test',
												  NE__Configuration_Type__c 		= 'Free',
												  NE__BaseRecurringCharge__c		= 12.00,
												  NE__RecurringChargeFrequency__c 	= 'Annual',
												  NE__Start_Date__c 				= system.now(),
												  NE__End_Date__c 					= system.now().addDays(1));
      	insert offertaMatrix;
      	offerta = offertaMatrix.Name;

		List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
		NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c();
				NE__Matrix_Parameter__c  matrixParameterParent  = new NE__Matrix_Parameter__c();
       
		NE__Matrix_Parameter__c  matrixParameter  = new NE__Matrix_Parameter__c();

		matrixParameter.OB_Componente__c=ci.Id;	
		//matrixParameter.OB_Offerta__c  = .id;
		//matrixParameter.OB_Listino__r  = matrixParameter.Id;
 
		insert matrixParameter;



		rowParent.OB_ABI_BANCA__c  	      = abi ;	
		rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
		rowParent.RecordTypeId 			  = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
		insert rowParent;

		Test.startTest();
		OB_ConfigurazioniTableBankController.searchConfigurazioniServer( pageSize, pageNumber, name,String.valueOf(fromDate),String.valueOf(toDate), offerta,listino, schemaPrezzi, modello, abi );
		Test.stopTest();
		
		
		
	}





	@isTest
	public static void creaConfigurazioneServer_Test() {

		Decimal pageSize   = 3;
		Decimal pageNumber = 4;
		String name        = '';
		DateTime fromDate  = Datetime.newInstance(1960, 2, 17);
		DateTime toDate    = Datetime.newInstance(2018, 2, 9);
		
		List<String> schemaPrezzi = new List<String> ();
		schemaPrezzi.add('Trilaterale');

		List<String> modello = new List<String> ();
		modello.add('Bancario');
		String abi = '05696';

		NE__Bundle__c offertaMatrix = new NE__Bundle__c();
		offertaMatrix.Name = 'Bundle Free';	

		NE__Catalog__c catalog= new NE__Catalog__c(Name = 'Nexi');
		insert 	catalog;

		NE__Catalog_Item__c  catalogItem = new NE__Catalog_Item__c( NE__Active__c = true, NE__Catalog_Id__c = catalog.id);
		insert catalogItem;

		NE__Matrix_Parameter__c matrixListino   = new NE__Matrix_Parameter__c();
		insert matrixListino;

		NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c();
		matrixParameter.NE__Active__c     = true;
		matrixParameter.NE__Start_Date__c = Date.newInstance(2018, 2, 9);
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
		OB_ConfigurazioniTableBankController.creaConfigurazioneServer( pageSize, pageNumber, name,fromDate,toDate, offertaMatrix.id,listino, schemaPrezzi, modello);
		Test.stopTest();
		
	}




	
	// @isTest
	// public static void creaConfigurazioneServer_Test_Catch() {

	// 	Decimal pageSize   = 3;
	// 	Decimal pageNumber = 4;
	// 	String name        = '';
	// 	String listino     = '';
	// 	DateTime fromDate  = Datetime.newInstance(1960, 2, 17);
	// 	DateTime toDate    = Datetime.newInstance(2018, 2, 9);
		
	// 	List<String> schemaPrezzi = new List<String> ();
	// 	List<String> modello = new List<String> ();

	// 	NE__Bundle__c offertaMatrix = new NE__Bundle__c();
	// 	offertaMatrix.Name = 'Bundle Free';	
		
	// 	Test.startTest();
	// 	OB_ConfigurazioniTableBankController.creaConfigurazioneServer( pageSize, pageNumber, name,fromDate,toDate, offertaMatrix.id,listino, schemaPrezzi, modello);
	// 	Test.stopTest();
		
	// }



	@isTest
	public static void deleteconfigurazioneServer_Test() {

		Decimal pageSize   = 2;
		Decimal pageNumber = 4;
		String name        = 'test';
		DateTime fromDate  = Datetime.newInstance(1960, 2, 17);
		DateTime toDate    = Datetime.newInstance(2018, 2, 9);
		String offerta 	   = 'Offerta';
		String listino 	   = 'test';
		List<String> schemaPrezzi = new List<String> ();
		schemaPrezzi.add('test 1');
		schemaPrezzi.add('test 2');
		List<String> modello = new List<String> ();
		modello.add('modello 1');
		modello.add('modello 2');
		String abi = '05696';
		NE__Matrix_Parameter__c configurazioneToDelete = new NE__Matrix_Parameter__c();
		configurazioneToDelete.NE__Active__c = true;
		configurazioneToDelete.NE__Start_Date__c = Date.newInstance(2018, 2, 9);
		configurazioneToDelete.OB_ModelloAcquiring__c = 'Bancario';
		configurazioneToDelete.OB_SchemaPrezzi__c = 'Trilaterale';
		insert configurazioneToDelete;

		Test.startTest();
		OB_ConfigurazioniTableBankController.deleteconfigurazioneServer( pageSize, pageNumber,  configurazioneToDelete, offerta);
		Test.stopTest();
		
	}


	@isTest
	public static void deleteconfigurazioneServer_Test_Catch() {

		Decimal pageSize   = 2;
		Decimal pageNumber = 4;
		String offerta 	   = 'Offerta';		
		NE__Matrix_Parameter__c configurazioneToDelete = new NE__Matrix_Parameter__c();		

		Test.startTest();
		OB_ConfigurazioniTableBankController.deleteconfigurazioneServer( pageSize, pageNumber,  configurazioneToDelete, offerta);
		Test.stopTest();
		
	}


	@isTest
	public static void searchForProducts_Test() {

		String searchText = 'test';
		Test.startTest();
		OB_ConfigurazioniTableBankController.searchForProducts(searchText);
		Test.stopTest();
		
	}

	@isTest
	public static void searchForCatalogs_Test() {

		String searchText = 'test';
		Test.startTest();
		OB_ConfigurazioniTableBankController.searchForCatalogs(searchText);
		Test.stopTest();
		
	}







}