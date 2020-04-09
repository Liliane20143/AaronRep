@isTest
public  class OB_OfferCatalogBank_Test {

	@isTest
	public static void getUserCABandABIServer_Test() {

		Profile profile1 = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' ];

		User user = new User( LastName 			= 'test',
							  Alias 			= 'test123',
							  Email 			= 'test123@test.com',
							  Username 			= 'test123@test123_rnd123133.it.nexitest',
							  CommunityNickname = 'tests',
							  ProfileId 		=  profile1.Id,
							  EmailEncodingKey 	= 'ISO-8859-1',
							  TimeZoneSidKey 	= 'Europe/Rome',
							  LocaleSidKey 		= 'it_IT',
							  LanguageLocaleKey = 'en_US' );
		insert user;
		Test.startTest();
		OB_OfferCatalogBankController.getUserCABandABIServer(user.id);
		Test.stopTest();

		
	}


	@isTest
	public static void getOffersByABIServer_Test() {

		String abi = '05116';
		NE__Bundle__c bundle = new NE__Bundle__c( Name 								= 'test',
												  NE__Configuration_Type__c 		= 'Free',
												  NE__BaseRecurringCharge__c		= 12.00,
												  NE__RecurringChargeFrequency__c 	= 'Annual',
												  NE__Start_Date__c 				= system.now(),
												  NE__End_Date__c 					= system.now().addDays(1));
      	insert bundle;
      	NE__Matrix_Parameter__c mp = new NE__Matrix_Parameter__c( Name 				= 'test',
      															  OB_Offerta__c 	= bundle.Id);
      	insert mp;
      	NE__Matrix_Parameter_Row__c mpr1 = new NE__Matrix_Parameter_Row__c( NE__Matrix_Parameter__c = mp.Id,
      																		RecordTypeId 			= Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId(),
																			OB_ABI_BANCA__c 		= abi
																		  );
		insert mpr1;

		Test.startTest();
		OB_OfferCatalogBankController.getOffersByABIServer(abi);
		Test.stopTest();

		
	}


	@isTest
	public static void getBundleOffers_Test() {

		NE__Bundle__c bundle = new NE__Bundle__c(Name='test', NE__Active__c = true,  
												NE__Configuration_Type__c ='Free',
												NE__BaseRecurringCharge__c=12.00, 
												NE__RecurringChargeFrequency__c = 'Annual', 
												NE__Start_Date__c = system.now(), 
												NE__End_Date__c = system.now().addDays(1));
      	insert bundle;
		List<NE__Bundle__c> listBundle = new List<NE__Bundle__c>();
        listBundle.add(bundle);
		String abi = '05116';
		Test.startTest();
		OB_OfferCatalogBankController.getBundleOffers();
		Test.stopTest();

		
	}

	@isTest
	public static void getBundleOffersOrderBy_Test() {

		String selectedValue = 'Name';
		NE__Bundle__c bundle = new NE__Bundle__c(Name='test', 
												 NE__Active__c = true,  
												 NE__Configuration_Type__c ='Free',
												 NE__BaseRecurringCharge__c=12.00, 
												 NE__RecurringChargeFrequency__c = 'Annual', 
												 NE__Start_Date__c = system.now(), 
												 NE__End_Date__c = system.now().addDays(1));
      	insert bundle;
		NE__Matrix_Parameter__c mp = new NE__Matrix_Parameter__c(Name = 'test', 
																 NE__Active__c = true, 
																 OB_Offerta__c = bundle.Id);
        insert mp;
        NE__Matrix_Parameter_Row__c mpr1 = new NE__Matrix_Parameter_Row__c(
        														 NE__Matrix_Parameter__c = mp.Id, 
        														 OB_ABI_BANCA__c = '05000' , 
        														 OB_Cab__c = '01876', 
        														 NE__Active__c = true);
        NE__Matrix_Parameter_Row__c mpr2 = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c = mp.Id, 
        														 OB_ABI_BANCA__c = '' , 
        														 OB_Cab__c = '', 
        														 NE__Active__c = true);

        List<NE__Matrix_Parameter_Row__c> bundleOffers = new List<NE__Matrix_Parameter_Row__c>();
        bundleOffers.add(mpr1);
        bundleOffers.add(mpr2);
        insert bundleOffers;		
        Test.startTest();
		OB_OfferCatalogBankController.getBundleOffersOrderBy(selectedValue,bundleOffers);
		Test.stopTest();		
	}

	//searchForOffer
	@isTest
	public static void searchForOffer_Test() {
		String searchText = 'Name';
		String selectedABI	= '05116' ;
		String selectedCAB	= '01876';
		
		Test.startTest();
		OB_OfferCatalogBankController.searchForOffer(searchText, selectedABI, selectedCAB );
		Test.stopTest();

		
	}

	//cloneParametersAndRows
	@isTest
	public static void cloneParametersAndRows_Test() {
		//List<NE__Bundle__c> activeOffers, String selectedABI,String selectedCAB, List<NE__Matrix_Parameter_Row__c> listToUpdate
		String selectedABI = '05116';
		String selectedCAB = '01876'; 
		NE__Bundle__c bundle = new NE__Bundle__c(Name='test', NE__Active__c = true,  
												NE__Configuration_Type__c ='Free',
												NE__BaseRecurringCharge__c=12.00, 
												NE__RecurringChargeFrequency__c = 'Annual', 
												NE__Start_Date__c = system.now(), 
												NE__End_Date__c = system.now().addDays(1));
    	 insert bundle;
		List<NE__Bundle__c> activeOffers = new List<NE__Bundle__c>();
        activeOffers.add(bundle);
        //insert activeOffers;

        NE__Matrix_Parameter__c mp = new NE__Matrix_Parameter__c(Name = 'test', 
																 NE__Active__c = true, 
																 OB_Offerta__c = bundle.Id);
        insert mp;

		NE__Matrix_Parameter_Row__c mpr = new NE__Matrix_Parameter_Row__c(
																 NE__Matrix_Parameter__c = mp.Id, 
        														 OB_ABI_BANCA__c = '' , 
        														 OB_Cab__c = '', 
        														 NE__Active__c = true);

        List<NE__Matrix_Parameter_Row__c> listToUpdate = new List<NE__Matrix_Parameter_Row__c>();
        listToUpdate.add(mpr);
        insert listToUpdate;
		Test.startTest();
		OB_OfferCatalogBankController.cloneParametersAndRows(activeOffers, selectedABI, selectedCAB , listToUpdate);
		Test.stopTest();

		
	}




}