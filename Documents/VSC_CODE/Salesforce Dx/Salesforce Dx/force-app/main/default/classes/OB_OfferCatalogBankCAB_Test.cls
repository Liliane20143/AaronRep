@isTest
private class OB_OfferCatalogBankCAB_Test {

    static testMethod void classTest() {
    	Profile profile1 = [ SELECT 	Id
							 FROM 		Profile 
							 WHERE 		Name = 'System Administrator' ];

		User user = new User( LastName 			= 'test',
							  Alias 			= 'test123',
							  Email 			= 'test123@test.com',
							  Username 			= 'test123@test123.it',
							  CommunityNickname = 'tests',
							  ProfileId 		=  profile1.Id,
							  EmailEncodingKey 	= 'ISO-8859-1',
							  TimeZoneSidKey 	= 'Europe/Rome',
							  LocaleSidKey 		= 'it_IT',
							  LanguageLocaleKey = 'en_US' );
		insert user;
    	NE__Bundle__c bundle = new NE__Bundle__c(Name='test', NE__Active__c = true,  NE__Configuration_Type__c ='Free',NE__BaseRecurringCharge__c=12.00, NE__RecurringChargeFrequency__c = 'Annual', NE__Start_Date__c = system.now(), NE__End_Date__c = system.now().addDays(1));
      	insert bundle;
    	NE__Matrix_Parameter__c mp = new NE__Matrix_Parameter__c(Name = 'test', NE__Active__c = true, OB_Offerta__c = bundle.Id);
        insert mp;
        NE__Matrix_Parameter_Row__c mpr1 = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c = mp.Id, OB_ABI_BANCA__c = '05000' , OB_Cab__c = '01876', NE__Active__c = true);
        NE__Matrix_Parameter_Row__c mpr2 = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c = mp.Id, OB_ABI_BANCA__c = '' , OB_Cab__c = '', NE__Active__c = true);
        List<NE__Matrix_Parameter_Row__c> listMpr = new List<NE__Matrix_Parameter_Row__c>();
        listMpr.add(mpr1);
        listMpr.add(mpr2);
        insert listMpr;
        List<NE__Bundle__c> listB = new List<NE__Bundle__c>();
        listB.add(bundle);
    	OB_OfferCatalogBankCABController.getUserCABandABIServer(user.Id);
        OB_OfferCatalogBankCABController.getOffersByABIandCABServer('05000' , '01876');
        OB_OfferCatalogBankCABController.getBundleOffers();
        OB_OfferCatalogBankCABController.getBundleOffersOrderBy('Name' ,listMpr);
        OB_OfferCatalogBankCABController.searchForOffer('test','05000' , '01876');
        OB_OfferCatalogBankCABController.cloneParametersAndRows(listB,'05000' , '01876',listMpr);
        
    }
}