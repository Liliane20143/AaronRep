@isTest///
public class OB_EngineUtilities_Test
{
	@isTest
	public static void APIGenericMethod_retrieveItemData_SuccessfulTest()
	{
		NE__Product__c product = new NE__Product__c();
		product.NE__Engine_Code__c = 'NE__Engine_Code__c';
		insert product;
		NE__Catalog__c catalog = new NE__Catalog__c();
		insert catalog;
		NE__Catalog_Item__c catalogItemFather = new NE__Catalog_Item__c();
		catalogItemFather.NE__Catalog_Id__c = catalog.id;
		insert catalogItemFather;
		NE__Item_Header__c itemHeader = new NE__Item_Header__c();
		itemHeader.NE__Catalog_Item__c = catalogItemFather.id;
		insert itemHeader;
		NE__Catalog_Item__c catalogItemSon = new NE__Catalog_Item__c();
		catalogItemSon.NE__ProductId__c = product.id;
		catalogItemSon.NE__Item_Header__c = itemHeader.id;
		catalogItemSon.NE__Catalog_Id__c = catalog.id;
		insert catalogItemSon;
		Organization orgDetails = [SELECT LanguageLocaleKey FROM Organization WHERE Id = :UserInfo.getOrganizationId() LIMIT 1];
		Attachment attachment = new Attachment();
		attachment.Name = 'B2WGin_Element_' + orgDetails.LanguageLocaleKey + '.JSON';
		attachment.body = Blob.valueOf('test');
		attachment.ParentId = catalogItemSon.id;
		insert attachment;

		String paramsString = '{"service" : "retrieveItemData", "parentVid" : "", "rootVid" : "", "rootcatalogItemId" : "' + String.valueOf(catalogItemFather.id) + '", "productenginecodetoadd" : "NE__Engine_Code__c"}';
		Object params = (Map<String, String>)JSON.deserialize(paramsString, Map<String, String>.class);
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.APIGenericMethod(params);
		Test.stopTest();
	}

	@isTest
	public static void APIGenericMethod_retrieveItemData_FailedTest1()
	{
		NE__Product__c product = new NE__Product__c();
		product.NE__Engine_Code__c = 'NE__Engine_Code__c';
		insert product;
		NE__Catalog__c catalog = new NE__Catalog__c();
		insert catalog;
		NE__Catalog_Item__c catalogItemFather = new NE__Catalog_Item__c();
		catalogItemFather.NE__Catalog_Id__c = catalog.id;
		insert catalogItemFather;
		NE__Item_Header__c itemHeader = new NE__Item_Header__c();
		itemHeader.NE__Catalog_Item__c = catalogItemFather.id;
		insert itemHeader;
		NE__Catalog_Item__c catalogItemSon = new NE__Catalog_Item__c();
		catalogItemSon.NE__ProductId__c = product.id;
		catalogItemSon.NE__Item_Header__c = itemHeader.id;
		catalogItemSon.NE__Catalog_Id__c = catalog.id;
		insert catalogItemSon;

		String paramsString = '{"service" : "retrieveItemData", "parentVid" : "", "rootVid" : "", "rootcatalogItemId" : "' + String.valueOf(catalogItemFather.id) + '", "productenginecodetoadd" : "NE__Engine_Code__c"}';
		Object params = (Map<String, String>)JSON.deserialize(paramsString, Map<String, String>.class);
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.APIGenericMethod(params);
		Test.stopTest();
	}

	@isTest
	public static void APIGenericMethod_retrieveItemData_FailedTest2()
	{
		String paramsString = '{"service" : "retrieveItemData", "parentVid" : "", "rootVid" : "", "rootcatalogItemId" : "rootcatalogItemIdValue", "productenginecodetoadd" : "NE__Engine_Code__c"}';
		Object params = (Map<String, String>)JSON.deserialize(paramsString, Map<String, String>.class);
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.APIGenericMethod(params);
		Test.stopTest();
	}

	@isTest
	public static void APIGenericMethod_retrieveItemListData_SuccessfulTest()
	{
		NE__Product__c product = new NE__Product__c();
		product.NE__Engine_Code__c = 'NE__Engine_Code__c';
		insert product;
		NE__Catalog__c catalog = new NE__Catalog__c();
		insert catalog;
		NE__Catalog_Item__c catalogItemFather = new NE__Catalog_Item__c();
		catalogItemFather.NE__Catalog_Id__c = catalog.id;
		insert catalogItemFather;
		NE__Item_Header__c itemHeader = new NE__Item_Header__c();
		itemHeader.NE__Catalog_Item__c = catalogItemFather.id;
		insert itemHeader;
		NE__Catalog_Item__c catalogItemSon = new NE__Catalog_Item__c();
		catalogItemSon.NE__ProductId__c = product.id;
		catalogItemSon.NE__Item_Header__c = itemHeader.id;
		catalogItemSon.NE__Catalog_Id__c = catalog.id;
		insert catalogItemSon;
		Organization orgDetails = [SELECT LanguageLocaleKey FROM Organization WHERE Id = :UserInfo.getOrganizationId() LIMIT 1];
		Attachment attachment = new Attachment();
		attachment.Name = 'B2WGin_Element_' + orgDetails.LanguageLocaleKey + '.JSON';
		attachment.body = Blob.valueOf('test');
		attachment.ParentId = catalogItemSon.id;
		insert attachment;


		// Roland Nieznanski <roland.nieznanski@accenture.com 07/08/2019 START
		List<String> itemsToAddList = new List<String>( );
		itemsToAddList.add('NE__Engine_Code__c');
		OB_EngineUtilities.Poselement poselementWrapper = new OB_EngineUtilities.Poselement();
		poselementWrapper.bundleElement = 'bundleElementValue';
		poselementWrapper.bundleId = 'bundleIdValue';
		poselementWrapper.bundlevid = 'bundlevidValue';
		poselementWrapper.rootCatalogItem = catalogItemFather.id;
		poselementWrapper.itemsToAdd = itemsToAddList;

		map<String,OB_EngineUtilities.Poselement> mapOfRquest        =   new map<String,OB_EngineUtilities.Poselement>();
		mapOfRquest.put(String.valueOf(catalogItemFather.id),poselementWrapper);

		Map<String, String> params = new Map<String, String>();
		params.put('service', 'retrieveItemListData');
		params.put('prodMap', JSON.serialize(mapOfRquest));
		// Roland Nieznanski <roland.nieznanski@accenture.com 07/08/2019 STOP
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.APIGenericMethod(params);
		Test.stopTest();
	}

	@isTest
	public static void APIGenericMethod_retrieveItemListData_FailedTest1()
	{

		// Roland Nieznanski <roland.nieznanski@accenture.com 07/08/2019 START
        List<String> itemsToAddList = new List<String>( );
        itemsToAddList.add('NE__Engine_Code__c');
		OB_EngineUtilities.Poselement poselementWrapper = new OB_EngineUtilities.Poselement();
		poselementWrapper.bundleElement = 'bundleElementValue';
		poselementWrapper.bundleId = 'bundleIdValue';
		poselementWrapper.bundlevid = 'bundlevidValue';
		poselementWrapper.rootCatalogItem = 'Tests';
		poselementWrapper.itemsToAdd = itemsToAddList;

		map<String,OB_EngineUtilities.Poselement> mapOfRquest        =   new map<String,OB_EngineUtilities.Poselement>();
		mapOfRquest.put('testP',poselementWrapper);

		Map<String, String> params = new Map<String, String>();
		params.put('service', 'retrieveItemListData');
		params.put('prodMap', JSON.serialize(mapOfRquest));
		params.put('service', 'retrieveItemListData');
		params.put('prodMap', JSON.serialize(mapOfRquest));
		// Roland Nieznanski <roland.nieznanski@accenture.com 07/08/2019 STOP
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.APIGenericMethod(params);
		Test.stopTest();
	}

	@isTest
	public static void APIGenericMethod_retrieveItemsFromMatrices_Test()
	{
		NE__Catalog__c catalog = new NE__Catalog__c();
		insert catalog;
		NE__Catalog_Item__c catalogItemFather = new NE__Catalog_Item__c();
		catalogItemFather.NE__Catalog_Id__c = catalog.id;
		insert catalogItemFather;
		NE__Catalog_Item__c catalogItem1 = new NE__Catalog_Item__c();
		catalogItem1.NE__Catalog_Id__c = catalog.id;
		insert catalogItem1;
		NE__Catalog_Item__c catalogItem2 = new NE__Catalog_Item__c();
		catalogItem2.NE__Catalog_Id__c = catalog.id;
		insert catalogItem2;
		NE__Matrix_Parameter__c mp1 = new NE__Matrix_Parameter__c();
		mp1.OB_Componente__c = catalogItemFather.id;
		insert mp1;
		NE__Matrix_Parameter__c mp2 = new NE__Matrix_Parameter__c();
		mp2.OB_Componente__c = catalogItemFather.id;
		insert mp2;
		List<NE__Matrix_Parameter_Row__c> mprList = new List<NE__Matrix_Parameter_Row__c>();
		NE__Matrix_Parameter_Row__c mpr1 = new NE__Matrix_Parameter_Row__c();
		mpr1.OB_Componente__c = catalogItem1.id;
		mpr1.NE__Matrix_Parameter__c = mp1.id;
		mprList.add(mpr1);
		NE__Matrix_Parameter_Row__c mpr2 = new NE__Matrix_Parameter_Row__c();
		mpr2.OB_Componente__c = catalogItem2.id;
		mpr2.NE__Matrix_Parameter__c = mp2.id;
		mprList.add(mpr2);
		insert mprList;
		Organization orgDetails = [SELECT LanguageLocaleKey FROM Organization WHERE Id = :UserInfo.getOrganizationId() LIMIT 1];
		Attachment attachment1 = new Attachment();
		attachment1.Name = 'B2WGin_Element_' + orgDetails.LanguageLocaleKey + '.JSON';
		attachment1.body = Blob.valueOf('Attachment1');
		attachment1.ParentId = catalogItem1.id;
		insert attachment1;
		Attachment attachment2 = new Attachment();
		attachment2.Name = 'B2WGin_Element_' + orgDetails.LanguageLocaleKey + '.JSON';
		attachment2.body = Blob.valueOf('Attachment2');
		attachment2.ParentId = catalogItem2.id;
		insert attachment2;
		Map<String, String> params = new Map<String, String>();
		params.put('service', 'retrieveItemsFromMatrices');
		String mprListString = '[ { "OB_Componente__c": "' + catalogItem1.id + '", "NE__Matrix_Parameter__c": "' + mp1.id + '", "Id": "' + mpr1.id + '", "OB_Parent_Componente__c" : "' + mpr1.OB_Parent_Componente__c + '" }, { "OB_Componente__c": "' + catalogItem2.id + '", "NE__Matrix_Parameter__c": "' + mp2.id + '", "Id": "' + mpr2.id + '", "OB_Parent_Componente__c" : "' + mpr2.OB_Parent_Componente__c + '" } ]';
		params.put('matricesString', mprListString);
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.APIGenericMethod(params);
		Test.stopTest();
	}

	@isTest
	public static void APIGenericMethod_retrieveMatrices_SuccesfulTest()
	{
		NE__Order__c order = new NE__Order__c();
		order.NE__order_date__c = Date.newInstance(2019, 2, 1);
		order.OB_Abi__c = '12345';
		order.OB_Cab__c = '54321';
		insert order;
		NE__Catalog__c catalog = new NE__Catalog__c();
		insert catalog;
		NE__Catalog_Item__c catalogItemFather = new NE__Catalog_Item__c();
		catalogItemFather.NE__Catalog_Id__c = catalog.id;
		insert catalogItemFather;
		NE__Bundle__c bundle = new NE__Bundle__c();
		bundle.NE__Start_Date__c = Date.newInstance(2019, 1, 1);
		bundle.NE__BaseRecurringCharge__c = 12.00;
		bundle.NE__RecurringChargeFrequency__c = 'Annual';
		insert bundle;
		NE__Matrix_Parameter__c matrixParameterFather = new NE__Matrix_Parameter__c();
		matrixParameterFather.OB_Componente__c = catalogItemFather.id;
		matrixParameterFather.OB_Offerta__c = bundle.id;
		insert matrixParameterFather;
		NE__Matrix_Parameter_Row__c mpr = new NE__Matrix_Parameter_Row__c();
		mpr.NE__Active__c = true;
		mpr.OB_Componente__c = catalogItemFather.id;
		mpr.OB_ABI_BANCA__c = '12345';
		mpr.OB_ModelloAcquiring__c = 'Bancario';
		mpr.NE__Start_date__c = Date.newInstance(2019, 1, 1);
		mpr.NE__End_Date__c = Date.newInstance(2019, 3, 1);
		mpr.OB_Cab__c = '54321';
		mpr.NE__Matrix_Parameter__c = matrixParameterFather.id;
		insert mpr;
		Map<String, String> params = new Map<String, String>();
		params.put('service', 'retrieveMatrices');
		params.put('businessModAcq', 'Bancario');
		params.put('config', JSON.serialize(order));
		params.put('bundId', bundle.id);
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.APIGenericMethod(params);
		Test.stopTest();
	}

	@isTest
	public static void APIGenericMethod_retrieveMatrices_FailedTest()
	{
		NE__Order__c order = new NE__Order__c();
		order.NE__order_date__c = Date.newInstance(2019, 2, 1);
		order.OB_Abi__c = '12345';
		order.OB_Cab__c = '54321';
		insert order;
		Map<String, String> params = new Map<String, String>();
		params.put('service', 'retrieveMatrices');
		params.put('businessModAcq', 'businessModAcqValue');
		params.put('config', JSON.serialize(order));
		params.put('bundId', 'bundIdValue');
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.APIGenericMethod(params);
		Test.stopTest();
	}

	@isTest
	public static void retrieveItemsUtility_Test()
	{
		NE.RetrieveItemsService.Output retrieveItems = new NE.RetrieveItemsService.Output();
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.retrieveItemsUtility(retrieveItems);
		Test.stopTest();
	}

	@isTest
	public static void retrieveAttributesUtility_Test()
	{
		NE.RetrieveAttributesService.Output retrieveAttributes = new NE.RetrieveAttributesService.Output();
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.retrieveAttributesUtility(retrieveAttributes);
		Test.stopTest();
	}

	@isTest
	public static void cartCheckoutUtility_Test()
	{
		NE.CartCheckOutService.Input cartCheckOut = new NE.CartCheckOutService.Input();
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.cartCheckoutUtility(cartCheckOut);
		Test.stopTest();
	}

	@isTest
	public static void retrieveCatalogsUtility_Test()
	{
		NE.RetrieveCatalogsService.Output retrieveCatalogs = new NE.RetrieveCatalogsService.Output();
		Test.startTest();
		OB_EngineUtilities engineUtilities = new OB_EngineUtilities();
		engineUtilities.retrieveCatalogsUtility(retrieveCatalogs);
		Test.stopTest();
	}
}