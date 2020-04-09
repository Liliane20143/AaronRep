@isTest
public with sharing class OB_CABOffersController_Test 
{
    @isTest
    public static void getABIbyUserIdServerTest() 
    {
        Profile profile1 = [ SELECT     Id
                             FROM       Profile 
                             WHERE      Name = 'System Administrator' ];

        User user = new User( LastName          = 'test'+UserInfo.getOrganizationId(),
                              Alias             = 'test123x',
                              Email             = 'test123@'+UserInfo.getOrganizationId()+'test.com',
                              Username          = 'name@' + UserInfo.getOrganizationId()+ 'test.com',
                              CommunityNickname = 'tests'+UserInfo.getOrganizationId(),
                              ProfileId         =  profile1.Id,
                              EmailEncodingKey  = 'ISO-8859-1',
                              TimeZoneSidKey    = 'Europe/Rome',
                              LocaleSidKey      = 'it_IT',
                              LanguageLocaleKey = 'en_US' );
        insert user;
        String userId = String.valueOf(user.Id);
        Test.startTest();
        OB_CAB_OffersController.getABIbyUserIdServer(userId);
        Test.stopTest();
    }

    @isTest
    public static void getCABListFromInputTest()
    {
        String cab = '';
        String abi = '';
        Test.startTest();
        OB_CAB_OffersController.getCABListFromInput(abi,cab);
        Test.stopTest();
    }

    @isTest
    public static void getOffersByABIServerTest()
    {
        String cab = '11111';
        String abi = '22222';
        NE__Bundle__c bundle = new NE__Bundle__c( Name                              = 'test',
                                                  NE__Configuration_Type__c         = 'Free',
                                                  NE__BaseRecurringCharge__c        = 12.00,
                                                  NE__RecurringChargeFrequency__c   = 'Annual',
                                                  NE__Start_Date__c                 = system.now(),
                                                  NE__End_Date__c                   = system.now().addDays(1));
        insert bundle;
        NE__Matrix_Parameter__c mp = new NE__Matrix_Parameter__c( Name              = 'test',
                                                                  OB_Offerta__c     = bundle.Id);
        insert mp;
        NE__Matrix_Parameter_Row__c mpr1 = new NE__Matrix_Parameter_Row__c( NE__Matrix_Parameter__c = mp.Id,
                                                                            RecordTypeId            = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId(),
                                                                            OB_ABI_BANCA__c         = abi,
                                                                            OB_CAB__c               = cab);
        insert mpr1;

        Test.startTest();
        OB_CAB_OffersController.getOffersByABIServer(abi,cab);
        Test.stopTest();
    }

    @isTest
    public static void getAllOffersToEnableServerTest()
    {
        List<NE__Bundle__c> cabOffers = new List<NE__Bundle__c>();
        String cab = '11111';
        String abi = '22222';
        NE__Bundle__c bundle                = new NE__Bundle__c( Name               = 'test',
                                                  NE__Configuration_Type__c         = 'Free',
                                                  NE__BaseRecurringCharge__c        = 12.00,
                                                  NE__RecurringChargeFrequency__c   = 'Annual',
                                                  NE__Start_Date__c                 = system.now(),
                                                  NE__End_Date__c                   = system.now().addDays(1));
        insert bundle;
        cabOffers.add(bundle);
        NE__Matrix_Parameter__c mp          = new NE__Matrix_Parameter__c( Name     = 'test',
                                                                            OB_Offerta__c   = bundle.Id);
        insert mp;
        NE__Matrix_Parameter_Row__c mpr1    = new NE__Matrix_Parameter_Row__c(  NE__Matrix_Parameter__c = mp.Id,
                                                                                RecordTypeId            = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId(),
                                                                                OB_ABI_BANCA__c         = abi,
                                                                                OB_CAB__c               = null);
        insert mpr1;

        Test.startTest();
        OB_CAB_OffersController.getAllOffersToEnableServer(cabOffers,cab,abi);
        Test.stopTest();
    }

    @isTest
    public static void searchForOffersToEnableTest()
    {
        NE__Bundle__c bundle = new NE__Bundle__c(   Name                            = 'test',
                                                    NE__Configuration_Type__c       = 'Free',
                                                    NE__BaseRecurringCharge__c      = 12.00,
                                                    NE__RecurringChargeFrequency__c = 'Annual',
                                                    NE__Start_Date__c               = system.now(),
                                                    NE__End_Date__c                 = system.now().addDays(1)   );
        insert bundle;
        List<NE__Bundle__c> bankOffers = new List<NE__Bundle__c>();
        bankOffers.add(bundle); 
        String searchText = '';
        Test.startTest();
        OB_CAB_OffersController.searchForOffersToEnable(bankOffers,searchText);
        Test.stopTest();
    }

    @isTest
    public static void getBundleOffersTest()
    {
        String abi = '';
        Test.startTest();
        OB_CAB_OffersController.getBundleOffers(abi);
        Test.stopTest();
    }

    @isTest
    public static void getBundleOffersOrderByTest()
    {
        String selectedValue = 'Name';
        List<NE__Matrix_Parameter_Row__c> bundleOffers = new List<NE__Matrix_Parameter_Row__c>();
        Test.startTest();
        OB_CAB_OffersController.getBundleOffersOrderBy(selectedValue,bundleOffers);
        Test.stopTest();
    }

    @isTest
    public static void cloneParametersAndRowsTest()
    {
        String cab = '11111';
        String abi = '22222';

        NE__DynamicPropertyDefinition__c dynPropDef     = new NE__DynamicPropertyDefinition__c(     Name                = 'test',
                                                                                                    NE__Description__c  = '%'   );
        insert dynPropDef;

        NE__Family__c commAcq                       = new NE__Family__c(    Name = 'test000' );
        insert commAcq;

        NE__Product__c prod                         = new NE__Product__c(   Name                = 'testProd',
                                                                            NE__Description__c  = ''    );
        insert prod;

        NE__Catalog__c cat = new NE__Catalog__c();
        insert cat;

        NE__Catalog_Item__c catIt                   = new NE__Catalog_Item__c(  NE__ProductId__c        = prod.Id,
                                                                                NE__Catalog_Id__c       = cat.Id    );
        insert catIt;

        NE__Bundle__c bundle                        = new NE__Bundle__c(    Name                            = 'test',
                                                                            NE__Configuration_Type__c       = 'Free',
                                                                            NE__BaseRecurringCharge__c      = 12.00,
                                                                            NE__RecurringChargeFrequency__c = 'Annual',
                                                                            NE__Start_Date__c               = system.now(),
                                                                            NE__End_Date__c                 = system.now().addDays(1)   );
        insert bundle;
        List<Id> activeOffers = new List<Id>();
        activeOffers.add(bundle.id);
        //insert activeOffers;

        NE__Matrix_Parameter__c mp                  = new NE__Matrix_Parameter__c( Name             = 'test',
                                                                                   OB_Offerta__c    = bundle.Id,
                                                                                   NE__End_Date__c  = Date.today().addDays(1) );
        insert mp;

        NE__Matrix_Parameter_Row__c mpr2 = new NE__Matrix_Parameter_Row__c( NE__Matrix_Parameter__c             = mp.Id,
                                                                            RecordTypeId                        = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId(),
                                                                            OB_ABI_BANCA__c                     = abi,
                                                                            OB_CAB__c                           = null,
                                                                            OB_Codici__c                        = 'IMPORTO',
                                                                            OB_DynamicPropertyDefinition__c     = dynPropDef.Id,
                                                                            OB_Family__c                        = commAcq.Id,
                                                                            OB_ReadOnly__c                      = false,
                                                                            OB_Read_Only_banca__c               = false);
        insert mpr2;

        NE__Matrix_Parameter_Row__c mpr             = new NE__Matrix_Parameter_Row__c(  NE__Matrix_Parameter__c             = mp.Id,
                                                                                        RecordTypeId                        = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId(),
                                                                                        OB_ABI_BANCA__c                     = abi,
                                                                                        OB_CAB__c                           = null,
                                                                                        OB_Codici__c                        = 'IMPORTO',
                                                                                        OB_DynamicPropertyDefinition__c     = dynPropDef.Id,
                                                                                        OB_Family__c                        = commAcq.Id,
                                                                                        OB_ReadOnly__c                      = false,
                                                                                        OB_Read_Only_banca__c               = false,
                                                                                        OB_Sequence__c                      = 180.0,
                                                                                        OB_Componente__c                    = catIt.Id,
                                                                                        NE__End_Date__c                     = Date.today().addDays(1),
                                                                                        NE__Start_Date__c                   = Date.today(),
                                                                                        OB_Product__c                       = prod.Id,
                                                                                        OB_Massimale__c                     = 9.0,
                                                                                        OB_Massimo__c                       = 8.0,
                                                                                        OB_Minimo__c                        = 2.0,
                                                                                        OB_Soglia_Max_Approvazione__c       = 6.0,
                                                                                        OB_Soglia_Min_Approvazione__c       = 4.0,
                                                                                        OB_Valore_Default__c                = 5.0,
                                                                                        OB_SelfLookup__c                    = mpr2.Id   
                                                                                        );
        insert mpr;
        //mpr1.OB_SelfLookup__c = mpr1.Id;

        Test.startTest();
        OB_CAB_OffersController.cloneParametersAndRows(activeOffers,abi,cab);
        Test.stopTest();
    }
}