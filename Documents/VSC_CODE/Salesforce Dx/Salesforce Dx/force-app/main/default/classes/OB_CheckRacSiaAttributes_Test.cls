/*------------------------------------------------------------
Author:         Andrea Saracini
Company:        Accenture Tecnology
Description:    OB_CheckRacSiaAttributes test class 
Inputs:
History:
<Date>          <Authors Name>      <Brief Description of Change>
2019-04-15      Andrea Saracini     Creator
------------------------------------------------------------*/
@isTest
public class OB_CheckRacSiaAttributes_Test {

    @isTest
	public static void checkRacSiaAttributesTest(){
		Account acc = OB_TestDataFactory.getAccount();
        insert acc;

        //Doris Dongmo , <doris.tatiana.dongmo@accenture.com> - 13/06/2019  - Start
        Id recordTypeIdProd = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( 'Terminali' ).getRecordTypeId();
        NE__Product__c prod = new NE__Product__c( Name = 'test ',
                OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial',
                RecordTypeId = recordTypeIdProd);
        insert prod;

        //Doris Dongmo , <doris.tatiana.dongmo@accenture.com> - 13/06/2019  - END

        NE__Billing_Profile__c billProf = new  NE__Billing_Profile__c();
        billProf.NE__Account__c = acc.Id;
        billProf.OB_ABICode__c = '03138';
        billProf.OB_ABI__c = '03138';
        billProf.OB_CABCode__c = '12300';
        billProf.OB_CINCode__c = 'G';
        billProf.OB_CountryCode__c = 'IT';
        billProf.OB_Bank_Account_Number__c = '000241351661';
        billProf.OB_EuroControlCode__c = '64';//Andrea Saracini 02/05/2019 RI-12-bis
        insert billProf;
        NE__Billing_Profile__c billProfile = [SELECT Id, 
                                                NE__Account__c,
                                                OB_ABICode__c,
                                                OB_ABI__c,
                                                OB_CINCode__c,
                                                OB_CountryCode__c,
                                                OB_Bank_Account_Number__c,
                                                OB_EuroControlCode__c,
                                                OB_IBAN__c 
                                            FROM NE__Billing_Profile__c 
                                            WHERE OB_Bank_Account_Number__c = '000241351661' LIMIT 1
                                        ];
        System.debug('### billProf: '+billProfile.OB_IBAN__c);

        NE__Order_Header__c ordHeader = OB_TestDataFactory.getOrderHeader();
        //START Andrea Saracini 02/05/2019 RI-12-bis
        ordHeader.OB_Main_Process__c = OB_UtilityConstants.MAINTENANCE;
        insert ordHeader;
        //STOP Andrea Saracini 02/05/2019 RI-12-bis

        NE__Order__c ord =  OB_TestDataFactory.getOrder(ordHeader);
        ord.NE__BillingProfId__c = billProfile.Id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__AccountId__c = acc.Id;
        ord.OB_FulfilmentStatus__c = '';
        insert ord;

        //START Andrea Saracini 02/05/2019 RI-12-bis
        NE__Product__c product = OB_TestDataFactory.getProduct();
        product.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.POS_RT).getRecordTypeId();
        insert product;
        //STOP Andrea Saracini 02/05/2019 RI-12-bis

        NE__OrderItem__c ordItem = OB_TestDataFactory.getOrderItem(ord.Id);
        ordItem.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.POS_RT).getRecordTypeId();
        ordItem.OB_RAC_SIA__c = '123456712345123';
        //START Andrea Saracini 02/05/2019 RI-12-bis
        ordItem.NE__Action__c = 'Add';
        ordItem.NE__Account__c = acc.Id;
        ordItem.NE__ProdId__c = product.Id;
        //STOP Andrea Saracini 02/05/2019 RI-12-bis
        insert ordItem;

        //davide.franzini - 02/07/2019 - START
        NE__Order__c ord1 =  OB_TestDataFactory.getOrder(ordHeader);
        ord1.NE__BillingProfId__c = billProfile.Id;
        ord1.NE__BillAccId__c = acc.Id;
        ord1.NE__AccountId__c = acc.Id;
        ord1.OB_FulfilmentStatus__c = '';
        insert ord1;

        NE__OrderItem__c ordItem1 = OB_TestDataFactory.getOrderItem(ord1.Id);
        ordItem1.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.POS_RT).getRecordTypeId();
        ordItem1.OB_RAC_SIA__c = '123456712345123';
        ordItem1.NE__Action__c = 'Add';
        ordItem1.NE__Account__c = acc.Id;
        ordItem1.NE__ProdId__c = product.Id;
        insert ordItem1;
        //davide.franzini - 02/07/2019 - END 

        //Doris Dongmo , <doris.tatiana.dongmo@accenture.com> - 14/06/2019 - Start        
        List<NE__OrderItem__c> ordItList = new  List<NE__OrderItem__c>();
        ordItList.add(ordItem);       
        Map<Id, List<NE__OrderItem__c>> ordIdPosMap = new Map<Id, List<NE__OrderItem__c>>(); 
        ordIdPosMap.put(ordItem.id, ordItList );
        //Doris Dongmo , <doris.tatiana.dongmo@accenture.com> - 14/06/2019 - END

        NE__Order_Item_Attribute__c orderItemAttr = OB_TestDataFactory.getOrderItemAttribute(ordItem.Id);
        orderItemAttr.Name = 'Codice SIA';
        orderItemAttr.NE__Value__c = '1234567';
        insert orderItemAttr;    

        Map<String, Object> ordItemMap = new Map<String, Object>();
        ordItemMap.put(ordItem.Id,  ordItem);
        String ordItemString = JSON.serialize(ordItem);

        Asset assets = OB_TestDataFactory.getAsset();
        assets.NE__Order_Config__c = ord.Id;
        assets.AccountId = acc.Id;
        assets.OB_RAC_SIA__c = '123456712345123';
        //START Andrea Saracini 02/05/2019 RI-12-bis
        assets.NE__BillingProf__c = billProfile.Id;
        //STOP Andrea Saracini 02/05/2019 RI-12-bis
        // Doris Dongmo , <doris.tatiana.dongmo@accenture.com> - 14/06/2019 - START
        assets.NE__ProdId__c = prod.id;
        assets.NE__Status__c = 'Active';
        // Doris Dongmo ,<doris.tatiana.dongmo@accenture.com> - 14/06/2019 - END
        insert assets;
         //Doris Dongmo ,<doris.tatiana.dongmo@accenture.com> - 14/06/2019 - Start        
        List<Asset> astList = new  List<Asset>();
        astList.add(assets);
       
        //Doris Dongmo, <doris.tatiana.dongmo@accenture.com> - 14/06/2019 - END

        NE__AssetItemAttribute__c assetItem = OB_TestDataFactory.getAssetItemAttribute(assets.Id);
        assetItem.Name = 'Codice SIA';
        assetItem.NE__Value__c = '1234567'; 
        assetItem.NE__Asset__c = assets.Id;
        insert assetItem;
        
        String objectDataString = '{"merchant":{"sobjectType":"account","Id":"' + acc.id + '"}, "BillingProfilePOS":{"sobjectType":"ne__billing_profile__c","id":"' + billProf.id + '","NE__Account__c":"' + acc.id + '","RecordTypeId":"","OB_ABI__c":"03138","OB_Bank_Account_Number__c":"000241351661","OB_Bank_Account_Owner__c":"' + acc.id + '","OB_Bank_Account_Type__c":"Debit","OB_ABICode__c":"03138","OB_CABCode__c":"12300","OB_CINCode__c":"G","OB_CountryCode__c":"IT","OB_EuroControlCode__c":"64","OB_IBAN__c":"IT64G031381200000241351661"}, "Configuration":{"Id":"' + ord.Id + '"}}';

        Map<String, String> inputSiaValuesMap = new Map<String, String>();
        inputSiaValuesMap.put('Codice SIA', '1234567');
        inputSiaValuesMap.put('Codice Stabilimento SIA', '12345');
        inputSiaValuesMap.put('Progressiva SIA', '123');
        String inputSiaValues = JSON.serialize(inputSiaValuesMap);

        List<NE__OrderItem__c> ordItList2 = [SELECT Id, 
                                                   OB_RAC_SIA__c,
                                                   /*START Andrea Saracini 02/05/2019 RI-12-bis*/
                                                   NE__Action__c,
                                                   NE__OrderId__c,
                                                   NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
                                                   NE__OrderId__r.NE__BillingProfId__r.OB_IBAN__c,
                                                   NE__Account__c,
                                                   NE__ProdId__r.RecordType.DeveloperName
                                                   /*STOP Andrea Saracini 02/05/2019 RI-12-bis*/
                                            FROM NE__OrderItem__c
                                        ];
        System.debug('### ordItList2: '+ordItList2.get(0));

        OB_CheckRacSiaAttributes callcheckAttr = new OB_CheckRacSiaAttributes();
        Boolean isvalid = false;
        Test.startTest();
        //davide.franzini - 02/07/2019 - START
        Map<String,Object> itToUpdateMap = new Map<String,Object>();
        itToUpdateMap.put(ordItem.Id, null);
        String itToUpdateString = JSON.serialize(itToUpdateMap);
		isvalid = callcheckAttr.checkRacSiaAttributes(objectDataString, '123456712345123', inputSiaValues, itToUpdateString, false);
        //davide.franzini - 02/07/2019 - END
      
        List<String> racSiaList = callcheckAttr.checkSiaCodeByCoba(objectDataString);
        System.assert(racSiaList!=null);
        isvalid = callcheckAttr.checkSiaInUse(objectDataString, '123456712345123');
        isvalid = callcheckAttr.checkIbanFromOrderItems(ordItList, '123456712345123');
        isvalid = callcheckAttr.checkIbanFromAssets(astList, '123456712345123');
        System.assert(true);
        Test.stopTest();
    }

    /*******************************************************************************
    Purpose:  Method tests .checkRacSiaAttributes - updating ordet item attributes

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?     15/03/2019    Created       -
    1.1       Joanna Mielczarek   08/08/2019    Modified   NEXI-266 increased cc
    ********************************************************************************/
    @isTest
    private static void checkRacSiaAttributesIsReset( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        insert testOrderItem;
        NE__Order_Item_Attribute__c testOrderItemAttribute = OB_TestDataFactory.getOrderItemAttribute( testOrderItem.Id );
        insert testOrderItemAttribute;

        String sia = '12345';
        Map<String, Object> siaValues = new Map<String, Object>( );
        siaValues.put( testOrderItemAttribute.Name, sia );
        Map<String, Object> items = new Map<String, Object>( );
        items.put( testOrderItem.Id, testOrderItem );

        OB_CheckRacSiaAttributes checkRacSia = new OB_CheckRacSiaAttributes( );
        Boolean result = checkRacSia.checkRacSiaAttributes( '', sia, JSON.serialize( siaValues ), JSON.serialize( items ), true );
        System.assert( result );
    }

    /*******************************************************************************
    Purpose:  Method tests .checkSiaCodeByCoba - existing assets scenario

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   15/03/2019    Created       -
    1.1       Joanna Mielczarek   08/08/2019    Modified   NEXI-266 increased cc
    ********************************************************************************/
    @isTest
    private static void checkSiaCodeByCobaAssets( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        NE__Billing_Profile__c testBillingProfile = OB_TestDataFactory.getBillingProfile( testAccount.Id );
        testBillingProfile.OB_CountryCode__c = 'IT';
        testBillingProfile.OB_EuroControlCode__c = '00';
        testBillingProfile.OB_CINCode__c = 'A';
        testBillingProfile.OB_ABICode__c = testAccount.OB_ABI__c;
        testBillingProfile.OB_CABCode__c = '00000';
        testBillingProfile.OB_Bank_Account_Number__c = '123456789101';
        insert testBillingProfile;
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_Main_Process__c = OB_UtilityConstants.MAINTENANCE;
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.NE__BillAccId__c = testAccount.Id;
        testOrder.NE__BillingProfId__c = testBillingProfile.Id;
        testOrder.NE__AccountId__c = testAccount.Id;
        insert testOrder;
        NE__Product__c testProduct = OB_TestDataFactory.getProduct( );
        testProduct.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        insert testProduct;
        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.NE__BillingProf__c = testBillingProfile.Id;
        testAsset.NE__ProdId__c = testProduct.Id;
        testAsset.OB_RAC_SIA__c = '12345';
        testAsset.AccountId = testAccount.Id;
        insert testAsset;

        Map<String, Object> objectDataMap = new Map<String, Object>( );
        objectDataMap.put( 'merchant', testAccount );
        objectDataMap.put( 'BillingProfilePOS', testBillingProfile );
        objectDataMap.put( 'Configuration', testOrder );

        Test.startTest( );
        OB_CheckRacSiaAttributes checkRacSia = new OB_CheckRacSiaAttributes( );
        List<String> result = checkRacSia.checkSiaCodeByCoba( JSON.serialize( objectDataMap ) );
        Test.stopTest( );

        System.assert( !result.isEmpty( ) );
    }
}