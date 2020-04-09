@isTest
public class OB_Maintenance_DynamicTable_Test 
{
	@isTest
	public static void OB_Maintenance_DynamicTableTest()
	{
		Test.startTest();
		OB_Maintenance_DynamicTable_Controller dtc = new OB_Maintenance_DynamicTable_Controller();
		Test.stopTest();
	}

	@isTest
    public static void FieldWrapperTest()
    {
        Schema.DescribeFieldResult dfr_DATE     = Account.NE__SLAExpirationDate__c.getDescribe();
        Schema.DescribeFieldResult dfr_DATETIME = Account.LastModifiedDate.getDescribe();
        Schema.DescribeFieldResult dfr_CURRENCY = Account.AnnualRevenue.getDescribe();
        Schema.DescribeFieldResult dfr_EMAIL    = Account.NE__E_mail__c.getDescribe();
        Schema.DescribeFieldResult dfr_PHONE    = Account.Phone.getDescribe();
        Schema.DescribeFieldResult dfr_TEXT     = Account.Description.getDescribe();

        Test.startTest();
        OB_Maintenance_DynamicTable_Controller.FieldWrapper fw_DATE     = new OB_Maintenance_DynamicTable_Controller.FieldWrapper(dfr_DATE);
        OB_Maintenance_DynamicTable_Controller.FieldWrapper fw_DATETIME = new OB_Maintenance_DynamicTable_Controller.FieldWrapper(dfr_DATETIME);
        OB_Maintenance_DynamicTable_Controller.FieldWrapper fw_CURRENCY = new OB_Maintenance_DynamicTable_Controller.FieldWrapper(dfr_CURRENCY);
        OB_Maintenance_DynamicTable_Controller.FieldWrapper fw_EMAIL    = new OB_Maintenance_DynamicTable_Controller.FieldWrapper(dfr_EMAIL);
        OB_Maintenance_DynamicTable_Controller.FieldWrapper fw_PHONE    = new OB_Maintenance_DynamicTable_Controller.FieldWrapper(dfr_PHONE);
        OB_Maintenance_DynamicTable_Controller.FieldWrapper fw_TEXT     = new OB_Maintenance_DynamicTable_Controller.FieldWrapper(dfr_TEXT);
        Test.stopTest();
    }

    @isTest
    public static void SchemaWrapperTest()
    {
        Test.startTest();
        OB_Maintenance_DynamicTable_Controller.SchemaWrapper schemaWrapper = new OB_Maintenance_DynamicTable_Controller.SchemaWrapper();
        Test.stopTest(); 
    }

    //********************************Start AV 06/12/2018********************************************************************

    @isTest
    public static void revertListOfAssetTest()
    {
        List<Asset> listofEnablement = new List<Asset>();
        String merchantRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1].Id;
        Account merchant = new Account( Name = 'name', 
            RecordTypeId = merchantRecordTypeId, 
            OB_Employees_Number__c = 'Minore di 10', 
            NE__Fiscal_code__c = 'AAAAAA11A11A111A', 
            OB_VAT_Not_Present__c = true, 
            OB_DescriptionVATNotPresent__c = 'desc');
        insert merchant;
        Asset assetFather     = new Asset();
        assetFather.Name      = 'assetFather';
        assetFather.AccountId = merchant.id;
        insert assetFather;
        Asset  assetSon = new Asset();
        assetSon.Name                        = 'assetSon';
        assetSon.AccountId                   = merchant.id;
        assetSon.NE__Bundle_Configuration__c = assetFather.id;
        insert assetSon;
        listofEnablement.add(assetFather);
        listofEnablement.add(assetSon);
        Test.startTest();
        OB_Maintenance_DynamicTable_Controller.revertListOfAsset(listofEnablement);
        Test.stopTest(); 
    }


    @isTest
    public static void retriveTerminalInformationTest()
    {
      Id rtTerminal = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Terminali' ).getRecordTypeId(); // TO DO - Remove terminal , sobstitute with constants
      NE__Product__c prod = new NE__Product__c();
      prod.RecordTypeId = rtTerminal;
      insert prod;

      List<OB_Maintenance_DynamicTable_Controller.ObjectWrapper> dataToShow = new List<OB_Maintenance_DynamicTable_Controller.ObjectWrapper>(); 
        String merchantRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1].Id;
        Account merchant = new Account( Name = 'name', 
            RecordTypeId = merchantRecordTypeId, 
            OB_Employees_Number__c = 'Minore di 10', 
            NE__Fiscal_code__c = 'AAAAAA11A11A111A', 
            OB_VAT_Not_Present__c = true, 
            OB_DescriptionVATNotPresent__c = 'desc');
        insert merchant;

        Asset assetFather     = new Asset();
        assetFather.Name      = 'assetFather';
        assetFather.AccountId = merchant.id;
        insert assetFather;

        Asset  assetSon = new Asset();
        assetSon.Name                        = 'assetSon';
        assetSon.AccountId                   = merchant.id;
        assetSon.NE__Bundle_Configuration__c = assetFather.id;
        assetSon.NE__ProdId__c = prod.Id; 
        insert assetSon;
        String offerid = assetFather.Id;
        List<String> fieldsToRetrive = new List<String>{'Name'};
        Test.startTest();
        OB_Maintenance_DynamicTable_Controller.retriveTerminalInformation(fieldsToRetrive, offerid, dataToShow );
        Test.stopTest(); 
    }








    @isTest
    public static void retriveInformation_Test()
    {
	   Id merchantRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1].Id;
       Id bankRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'bank' AND SobjectType = 'Account' LIMIT 1].Id;

       Account merchant = new Account();
       merchant.Name = 'name';
       merchant.RecordTypeId = merchantRecordTypeId;
       merchant.OB_Employees_Number__c = 'Minore di 10'; 
       merchant.NE__Fiscal_code__c = 'AAAAAA11A11A111A'; 
       merchant.OB_VAT_Not_Present__c = true;
       merchant.OB_DescriptionVATNotPresent__c = 'desc';
       insert merchant;
   	
       Account bank = new Account();
	   bank.Name = 'bank';
	   bank.RecordTypeId = bankRecordTypeId;
       bank.OB_ABI__c = '00112';
	   insert bank;
        
       Asset assetFather     = new Asset();
       assetFather.Name      = 'assetFather';
       assetFather.AccountId = merchant.id;
       insert assetFather;
        
       Asset  assetSon = new Asset();
       assetSon.Name                        = 'assetSon';
       assetSon.AccountId                   = merchant.id;
       assetSon.OB_ProposerABI__c = bank.id;
       assetSon.NE__Bundle_Configuration__c = assetFather.id;
       insert assetSon;
       List<String> fieldsToRetrive = new List<String>{'Name'};
       String SObjectToRetrive    = 'Asset'; 
       String queryType_OFFER     = 'OFFER';
       String queryType_TERMINAL  = 'TERMINAL';    	
       String queryType_ACQUIRING = 'ACQUIRING';   
       String queryType_VAS = 'VAS';     
	
       String parentid            = 'parentid';
       Test.startTest();
	   // retriveInformation(list<string> fieldsToRetrive, string SObjectToRetrive, string queryType, string parentid, string proposerABI,String bundleConfiguration)
       OB_Maintenance_DynamicTable_Controller.retriveInformation(fieldsToRetrive, SObjectToRetrive, queryType_OFFER, assetFather.id, bank.id,assetFather.Id);
       OB_Maintenance_DynamicTable_Controller.retriveInformation(fieldsToRetrive, SObjectToRetrive, queryType_TERMINAL, assetFather.id, bank.id,assetFather.Id);
       OB_Maintenance_DynamicTable_Controller.retriveInformation(fieldsToRetrive, SObjectToRetrive, queryType_ACQUIRING, assetFather.id, bank.id,assetFather.Id);
       OB_Maintenance_DynamicTable_Controller.retriveInformation(fieldsToRetrive, SObjectToRetrive, queryType_VAS, assetFather.id, bank.id,assetFather.Id);
       Test.stopTest(); 
   }

   @isTest
   public static void EnablementsWrapperTest()
   {
       Test.startTest();
       OB_Maintenance_DynamicTable_Controller.EnablementsWrapper enablementsWrapper = new OB_Maintenance_DynamicTable_Controller.EnablementsWrapper('n', 'i');
       Test.stopTest(); 
   }

   @isTest
   public static void retriveEnablementsTest()
   {
       String merchantRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1].Id;
       String bankRecordTypeid = [SELECT Id FROM RecordType WHERE Name = 'bank' AND SobjectType = 'Account' LIMIT 1].Id;
       
       Account merchant = new Account( Name = 'name', 
        RecordTypeId = merchantRecordTypeId, 
        OB_Employees_Number__c = 'Minore di 10', 
        NE__Fiscal_code__c = 'AAAAAA11A11A111A', 
        OB_VAT_Not_Present__c = true, 
        OB_DescriptionVATNotPresent__c = 'desc');
       insert merchant;
       
       Account bank = new Account();
	   bank.Name = 'bank';
	   bank.RecordTypeId = bankRecordTypeid;
       bank.OB_ABI__c = '00112';
	   insert bank;

       NE__Product__c   product = new NE__Product__c();
       product.OB_Codice_sfdc__c   = 'PRE-AUT';
       product.OB_Acquirer__c      = 'NEXI';
       product.OB_Contract_Type__c = 'A. CANONE DI LOCAZIONE';
       product.RecordTypeid        =  Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Vas').getRecordTypeId();          
       insert product; 

       Asset assetFather     = new Asset();
       assetFather.Name      = 'assetFather';
       assetFather.AccountId = merchant.id;
       insert assetFather;

       Asset  assetSon = new Asset();
       list<Asset> listofEnablement = new list<Asset>();
       assetSon.Name                        = 'assetSon';
       assetSon.AccountId                   = merchant.id;
       assetSon.OB_ProposerABI__c 			= bank.id;
       assetSon.NE__Bundle_Configuration__c = assetFather.id;
       assetSon.NE__Root_Order_Item__c      = assetFather.id;
       assetSon.NE__ProdId__c               = product.id;
       assetSon.RecordTypeId                = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Vas' ).getRecordTypeId();
       listofEnablement.add(assetSon);
       insert listofEnablement;
       system.debug('listofEnablement ---> ::' + listofEnablement);
       Test.startTest();
       OB_Maintenance_DynamicTable_Controller.retriveEnablements(assetFather.id, bank.id);
       Test.stopTest(); 
   }
//*********************************************** DD ***************************************************//

@isTest
public static void retriveInformationTree_Test()
{
    list<String> fieldsToRetrive = new List<String>{'Name'};

        //Map <String,Map <String,Schema.DescribeFieldResult>> objType2fieldData = new Map<String,Map<String,Schema.DescribeFieldResult>>();
        //objType2fieldData.putAll(OB_Maintenance_Helper.fieldObjType2APINameSchema('Asset'));
        //Map <String,Schema.DescribeFieldResult> mapOfFields = objType2fieldData.get('Asset');

        String merchantRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'merchant' AND SobjectType = 'Account' LIMIT 1].Id;
        Account merchant = new Account( Name                           = 'name', 
            RecordTypeId                   = merchantRecordTypeId, 
            OB_Employees_Number__c         = 'Minore di 10', 
            NE__Fiscal_code__c             = 'AAAAAA11A11A111A', 
            OB_VAT_Not_Present__c          = true, 
            OB_DescriptionVATNotPresent__c = 'desc');
        insert merchant;

        //NE__Product__c   product = new NE__Product__c();
        //product.Name          = 'PRE-AUT';
        //product.RecordTypeid  =  Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Vas').getRecordTypeId();          
        //insert product; 

        Asset assetFather     = new Asset();
        assetFather.Name      = 'assetFather';
        assetFather.AccountId = merchant.id;
        insert assetFather;
        
        Asset  assetSon = new Asset();
        assetSon.Name                        = 'assetSon';
        assetSon.AccountId                   = merchant.id;
        assetSon.NE__Bundle_Configuration__c = assetFather.id;
        //assetSon.NE__Root_Order_Item__c      = assetFather.id;
        //assetSon.NE__ProdId__c               = product.id;
        //assetSon.RecordTypeId                = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Vas' ).getRecordTypeId();
        insert assetSon ;
        String offerid = assetSon.Id;
        system.debug('fieldsToRetrive ---> ::' + fieldsToRetrive);
        system.debug('assetSon ---> ::' + assetSon);
        //SObject dataToShow = new SObject();

        Test.startTest();
        OB_Maintenance_DynamicTable_Controller.retriveInformationTree(fieldsToRetrive, offerid);
        Test.stopTest(); 
    }

    @isTest
    public static void getUserLicenseServerTest()
    {
      Id userId = UserInfo.getUserId();
      Test.startTest();
      OB_Maintenance_DynamicTable_Controller.getUserLicenseServer(userId);
      Test.stopTest();
    }
     /*******************************************************************************
	Purpose:  test getAssetItemAttribute method
	Parameters: -
	Returns: Asset
	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Giovanni Spinelli     11/10/2019        Created          
********************************************************************************/
    @isTest
    public static void getAssetAttributeServer_test()
    {
        Asset asset = OB_TestDataFactory.getAsset();
        insert asset;
        NE__AssetItemAttribute__c assetAttribute = OB_TestDataFactory.getAssetItemAttribute( asset.Id );
        insert assetAttribute;
        
        Test.startTest();
        List<NE__AssetItemAttribute__c> testAssetList = OB_Maintenance_DynamicTable_Controller.getAssetAttributeServer(asset.Id);
        System.assertEquals(testAssetList.get(0).name, 'testAssetItemAttribute');
        Test.stopTest();
    }

}