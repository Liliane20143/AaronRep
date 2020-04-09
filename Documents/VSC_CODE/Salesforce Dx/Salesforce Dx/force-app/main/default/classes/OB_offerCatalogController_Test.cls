@isTest
public class OB_offerCatalogController_Test {
/*
    @isTest
    public static void getBundleOffersTest1(){

        String selectedValue = 'Name';
        NE__bundle__c bundle = new NE__bundle__c(NE__Start_Date__c = Date.newInstance(2018, 10, 04), NE__BaseRecurringCharge__c = 1, NE__RecurringChargeFrequency__c = 'Monthly');
        //NE__RecurringChargeFrequency__c , NE__BaseRecurringCharge__c
        insert bundle;
        Test.startTest();
        OB_offerCatalogController.getBundleOffers(selectedValue);
        Test.stopTest();
    }


    @isTest
    public static void getBundleOffersTest2(){

        String selectedValue = '';
        NE__bundle__c bundle = new NE__bundle__c(NE__Start_Date__c = Date.newInstance(2018, 10, 04), NE__BaseRecurringCharge__c = 1, NE__RecurringChargeFrequency__c = 'Monthly');
        //NE__RecurringChargeFrequency__c , NE__BaseRecurringCharge__c
        insert bundle;
        Test.startTest();
        OB_offerCatalogController.getBundleOffers(selectedValue);
        Test.stopTest();
    }
    */
    @isTest
    public static void searchForOfferTest(){

        NE__bundle__c bundle = new NE__bundle__c(NE__Start_Date__c = Date.newInstance(2018, 10, 04), Name = 'myName', NE__BaseRecurringCharge__c = 1, NE__RecurringChargeFrequency__c = 'Monthly');
    	insert bundle;
        String searchText = 'yNa';
        Test.startTest();
        OB_offerCatalogController.searchForOffer(searchText);
        Test.stopTest();

    }

    @isTest
    public static void getBundleOffersWithoutSelectedValueTest(){
        DateTime startDateTime =DateTime.newInstance(2017, 10, 28, 23, 59, 59);
        DateTime endDateTime = startDateTime.addDays(10);
        NE__bundle__c bundle = new NE__bundle__c(Name ='Test Name', NE__RecurringChargeFrequency__c='Monthly', NE__Start_Date__c=startDateTime, NE__End_Date__c=endDateTime );
        List<NE__bundle__c> listBundles = new List<NE__bundle__c>();
        listBundles.add(bundle);
        insert listBundles; 
        OB_offerCatalogController.getBundleOffers('',listBundles);
    }

    @isTest
    public static void getBundleOffersWithSelectedValueTest(){
        DateTime startDateTime =DateTime.newInstance(2017, 10, 28, 23, 59, 59);
        DateTime endDateTime = startDateTime.addDays(10);
        NE__bundle__c bundle = new NE__bundle__c(Name ='Test Name', NE__RecurringChargeFrequency__c='Monthly', NE__Start_Date__c=startDateTime, NE__End_Date__c=endDateTime );
        List<NE__bundle__c> listBundles = new List<NE__bundle__c>();
        listBundles.add(bundle);
        insert listBundles; 
        OB_offerCatalogController.getBundleOffers('Name',listBundles);
    }

    @isTest
    public static void orderBundleOffers_Test(){

        DateTime startDateTime =DateTime.newInstance(2017, 10, 28, 23, 59, 59);
        Datetime dt = Datetime.newInstance(1900, 12, 31, 00, 00, 00);
        DateTime endDateTime = startDateTime.addDays(10);
        NE__bundle__c bundle = new NE__bundle__c(Name ='Test Name', NE__RecurringChargeFrequency__c='Monthly', NE__Start_Date__c=startDateTime, NE__End_Date__c=endDateTime );
        //bundle.CreatedDate = dt;
        List<NE__bundle__c> bundleOffers = new List<NE__bundle__c>();
        bundleOffers.add(bundle);
        insert bundleOffers; 
        OB_offerCatalogController.orderBundleOffers('CreatedDate',bundleOffers);
    }

    @isTest
    public static void orderBundleOffers_Test2(){

        DateTime startDateTime =DateTime.newInstance(2017, 10, 28, 23, 59, 59);
        Datetime dt = Datetime.newInstance(1900, 12, 31, 00, 00, 00);
        DateTime endDateTime = startDateTime.addDays(10);
        NE__bundle__c bundle = new NE__bundle__c(Name ='Test Name', NE__RecurringChargeFrequency__c='Monthly', NE__Start_Date__c=startDateTime, NE__End_Date__c=endDateTime );
        //bundle.CreatedDate = dt;
        List<NE__bundle__c> bundleOffers = new List<NE__bundle__c>();
        bundleOffers.add(bundle);
        insert bundleOffers; 
        OB_offerCatalogController.orderBundleOffers('LastModifiedDate',bundleOffers);
    }

    //davide.franzini - 02/07/2019 - START
    @isTest
    public static void getAbiListTest(){

        DateTime startDateTime =DateTime.newInstance(2017, 10, 28, 23, 59, 59);
        DateTime endDateTime = startDateTime.addDays(10);
        NE__bundle__c bundle = new NE__bundle__c(Name ='Test Name', NE__RecurringChargeFrequency__c='Monthly', NE__Start_Date__c=startDateTime, NE__End_Date__c=endDateTime );
        List<NE__bundle__c> bundleOffers = new List<NE__bundle__c>();
        bundleOffers.add(bundle);
        insert bundleOffers;
        String abi = '01234';
        NE__Matrix_Parameter__c mp = new NE__Matrix_Parameter__c(
            OB_Offerta__c = bundle.Id,
            OB_ABI__c = abi
            );
        insert mp;
        NE__Matrix_Parameter_Row__c mpr = new NE__Matrix_Parameter_Row__c(
            NE__Matrix_Parameter__c = mp.Id,
            OB_ABI_BANCA__c = abi
        );
        insert mpr;
        OB_offerCatalogController.getAbiList(bundle.Id, abi);
    }
    //davide.franzini - 02/07/2019 - END

    
}