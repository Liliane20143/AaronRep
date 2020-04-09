/*****************************************************************
Name: OB_ManageRacSia_Test
Copyright © 2016 ITC
============================================================
Purpose:  Class tests OB_ManageRacSia class

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Andrea Saracini           19/04/2019       Created         Test Class of OB_ManageRacSia
********************************************************************************/
@isTest
public class OB_ManageRacSia_Test {
    /*******************************************************************************
    Purpose:  Tests manageRacSiaTestMethod() method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Andrea Saracini       19/04/2019        Created         Test method
    ********************************************************************************/
    @isTest
	public static void manageRacSiaTestMethod(){
        Account acc = OB_TestDataFactory.getAccount();
        insert acc;

        NE__Billing_Profile__c billProf = new  NE__Billing_Profile__c();
        billProf.NE__Account__c = acc.Id;
        billProf.OB_ABICode__c = '12345';
        billProf.OB_CABCode__c = '12345';
        billProf.OB_CINCode__c = '1';
        billProf.OB_CountryCode__c = 'IT';
        billProf.OB_Bank_Account_Number__c = '123';
        insert billProf;

        NE__Order_Header__c ordHeader = OB_TestDataFactory.getOrderHeader();

        NE__Order__c ord =  OB_TestDataFactory.getOrder(ordHeader);
        ord.NE__BillingProfId__c = billProf.Id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__AccountId__c = acc.Id;
        ord.OB_FulfilmentStatus__c = '';
        insert ord;

        NE__OrderItem__c ordItem = OB_TestDataFactory.getOrderItem(ord.Id);
        ordItem.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.POS_RT).getRecordTypeId();
        ordItem.OB_RAC_SIA__c = '123456712345123';
        insert ordItem;

        NE__Order_Item_Attribute__c orderItemAttr = OB_TestDataFactory.getOrderItemAttribute(ordItem.Id);
        orderItemAttr.Name = 'Codice SIA';
        orderItemAttr.NE__Value__c = '1234567';
        insert orderItemAttr;    

        Map<String, Object> ordItemMap = new Map<String, Object>();
        ordItemMap.put(ordItem.Id,  ordItem);
        String ordItemString = JSON.serialize(ordItemMap);

        Asset assets = OB_TestDataFactory.getAsset();
        assets.NE__Order_Config__c = ord.Id;
        assets.AccountId = acc.Id;
        assets.OB_RAC_SIA__c = '123456712345123';
        insert assets;

        NE__AssetItemAttribute__c assetItem = OB_TestDataFactory.getAssetItemAttribute(assets.Id);
        assetItem.Name = 'Codice SIA';
        assetItem.NE__Value__c = '1234567'; 
        assetItem.NE__Asset__c = assets.Id;
        insert assetItem;
        
        String objectDataString = '{"merchant":{"sobjectType":"account","Id":"' + acc.id + '"}, "BillingProfilePOS":{"sobjectType":"ne__billing_profile__c","id":"' + billProf.id + '","NE__Account__c":"' + acc.id + '","RecordTypeId":"","OB_ABI__c":"","OB_Bank_Account_Number__c":"123","OB_Bank_Account_Owner__c":"' + acc.id + '","OB_Bank_Account_Type__c":"Debit","OB_ABICode__c":"12345","OB_CABCode__c":"12345","OB_CINCode__c":"1","OB_CountryCode__c":"IT","OB_EuroControlCode__c":"eu","OB_HeaderInternational__c":"123"}, "Configuration":{"Id":"' + ord.Id + '"}}';

        Map<String, String> inputSiaValuesMap = new Map<String, String>();
        inputSiaValuesMap.put('Codice SIA', '1234567');
        inputSiaValuesMap.put('Codice Stabilimento SIA', '12345');
        inputSiaValuesMap.put('Progressiva SIA', '123');
        String inputSiaValues = JSON.serialize(inputSiaValuesMap);

        Boolean siaIsValid = OB_ManageRacSia.setAttributeRacSiaOnTerminal(objectDataString, '123456712345123', inputSiaValues, String.valueOf(ordItem.Id), 'false');
        System.assert(!siaIsValid);
        siaIsValid = OB_ManageRacSia.checkSiaInUseOtherMerchant(objectDataString, '123456712345123');
        System.assert(!siaIsValid);
        List<String> racSiaList = OB_ManageRacSia.checkSiaCodeOnIbanInsert(objectDataString);
        System.assert(racSiaList.isEmpty()); // Doris Dongmo - Changed  '!racSiaList' to 'racSiaList' - 13/06/2019
    }
}