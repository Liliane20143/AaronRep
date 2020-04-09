/**
 * Created by natalia.nawrocka on  14.06.2019.
 */

@isTest
public class OB_CatalogController_Test {
    /**
    *@author Enrico Purificato
    *@date 22/07/02018
    * for simplicity test is going to cover the folowing methods:
    *
    */
    @isTest
    public static void testNewCheckout(){
        NE__Product__c productForItems  =  new NE__Product__c(name='thisIsMyCatalogTest');
		insert productForItems;
        
        NE__Family__c MyFamily = new NE__Family__c(Name='MyFamilyTPCmut',NE__Hidden__c=false,NE__Type__c='Standard');
		insert MyFamily;

		NE__DynamicPropertyDefinition__c dPropDef = new NE__DynamicPropertyDefinition__c(Name='dPropDefTPCmut',NE__Type__c='String');
		insert dPropDef;

		NE__ProductFamilyProperty__c pFamProp = new NE__ProductFamilyProperty__c(NE__Unique__c=false, NE__Required__c='Yes',NE__ValidationExpr__c='[0-9]',NE__FamilyId__c=MyFamily.Id,NE__PropId__c=dPropDef.Id,NE__Sequence__c=0);
		insert pFamProp;

		NE__ProductFamily__c pFamily = new NE__ProductFamily__c(NE__FamilyId__c=MyFamily.Id,NE__ProdId__c=productForItems.Id,NE__Sequence__c=12);
		insert pFamily;

        NE__Catalog_Header__c headerforItems  =  new NE__Catalog_Header__c(NE__Name__c='thisIsMyCatalogTest');
		insert headerforItems;

		NE__Commercial_Model__c  modelForITems  =  new NE__Commercial_Model__c(NE__ProgramName__c='thisIsMyCatalogTest', NE__Catalog_HEader__c=headerforItems.id, NE__Offline__c=false);
		insert modelForITems;

		Date startDate  =  System.today()-7000;
		NE__Catalog__c catalogForItems  =  new NE__Catalog__c(NE__StartDate__c=startDate,name='thisIsMyCatalogTest', NE__Catalog_Header__c = headerforItems.id,NE__Version__c=1, NE__Active__c=true);
		insert catalogForItems;
		NE__Catalog_Category__c categoryForItems  =  new NE__Catalog_Category__c(NE__CatalogId__c=catalogForItems.id,name='thisIsMyCatalogTest');
		insert categoryForItems;

		NE__Catalog_Item__c itemTest      =  
				new NE__Catalog_Item__c
				(
						NE__Catalog_Id__c  =  catalogForItems.id,
						NE__Base_OneTime_Fee__c  =  0,
						NE__BaseRecurringCharge__c  =  0,
						NE__Catalog_Category_Name__c  =  categoryForItems.id,
						NE__Type__c = 'Product',
						NE__Item_Header__c = null,
						NE__ProductId__c = productForItems.id,
						NE__Category_Max_Qty__c = 1,
						NE__Category_Min_Qty__c =1,
						NE__Matrix_Item_Identifier__c = 'testMatrix' ,
						NE__Tax_Code__c='testRemoteCartAPI',
						NE__Currency__c = 'USD',
						NE__Threshold_Identifier__c='Identifier'             
						);
		insert itemTest;

        Account merchantAccount = OB_TestDataFactory.getAccount();
        insert merchantAccount;

        Account bankAccount = OB_TestDataFactory.getBankAccount();
        insert bankAccount;

        OB_Bank_Profile__c bankProf = OB_TestDataFactory.getBankProfile(bankAccount);

        NE__Order_Header__c header = OB_TestDataFactory.getOrderHeader();
        header.OB_ProposerABI__c = bankAccount.Id;
        header.OB_Main_Process__c ='Setup';
        insert header;

        NE__Order__c order = OB_TestDataFactory.getOrder(header);
        insert order;

        Map<String,Object> ordObject = (Map<String,Object>) JSON.deserializeuntyped(JSON.Serialize(order));
        ordObject.put('OB_isSkipToIntBE',false);
        ordObject.put('id',order.Id);
        ordObject.put('NE__CatalogId__c',catalogForItems.Id);
        ordObject.put('NE__accountid__c',merchantAccount.Id);
        ordObject.put('NE__billaccid__c',merchantAccount.Id);
        ordObject.put('NE__servaccid__c',merchantAccount.Id);
        ordObject.put('NE__billingprofid__c',null);
        ordObject.put('NE__CommercialModelId__c',modelForITems.Id);
        ordObject.put('NE__Version__c',1);
        ordObject.put('OB_Predefault__c',true);
        ordObject.put('OB_Variation__c','CONFERMATO');
        ordObject.put('OB_VariationPOS__c','');
        ordObject.put('OB_JCBUPIAlert__c',false);
        ordObject.put('OB_PredefaultPOS__c',false);
        ordObject.put('OB_AgreedChanges__c',true);
        ordObject.put('OB_EXCH_Commission__c',false);
        ordObject.put('OB_ApprovalLevel__c','');
        ordObject.put('OB_isNexiAcquirer__c',true);
        ordObject.put('OB_IsActiveOfferOnSp__c',true);

        Map<String,Object> bundleMap        = new Map<String,Object>();
        Map<String,Object> bundlefields     = new Map<String,Object>();
        bundlefields.put('catalogitemid',itemTest.Id);
        bundlefields.put('itemCode','code1');
        bundleMap.put('fields',bundlefields);

        system.debug('### '+ JSON.serialize(ordObject));

       Id bundleId = OB_CatalogController.createBundleServer(JSON.serialize(bundleMap),JSON.serialize(ordObject));
       System.assertEquals(bundleId.getSObjectType().getDescribe().getName(), 'NE__OrderItem__c');

        Map<String,Object>  attributeFields   = new Map<String,Object>();
        attributeFields.put('name','nome');
        attributeFields.put('attributeCode','onecode');
        attributeFields.put('pfpId',pFamProp.Id);
        attributeFields.put('value','0,3');
        attributeFields.put('previousvalue','');
        attributeFields.put('OB_Attribute_Code__c','10');

        attributeFields.put('OB_Min_Threshold__c',0);
        attributeFields.put('OB_MIn_Absolute__c',0);
        attributeFields.put('OB_Max_Threshold__c',0);
        attributeFields.put('OB_Max_Absolute__c',0);
        attributeFields.put('OB_Massimale__c',0);

        attributeFields.put('OB_PredefaultAttr__c',false);
        attributeFields.put('OB_ReadOnly__c',false);
        attributeFields.put('OB_Hidden__c',false);
        attributeFields.put('NE__AttrEnterpriseId__c','');

        Map<String,Object> attribute        = new Map<String,Object>();
        attribute.put('fields',attributeFields);

        List<Object> listOfAttributes = new List<Object> ();
        listOfAttributes.add(attribute);

        Map<String,Object> rootMap        = new Map<String,Object>();
        Map<String,Object> rootfields     = new Map<String,Object>();
        rootfields.put('catalogitemid',itemTest.Id);
        rootfields.put('itemCode','root1');
        rootfields.put('qty',2);
        rootMap.put('fields',rootfields);
        rootMap.put('listOfAttributes',listOfAttributes);


        Map<String,Object> child1Map        = new Map<String,Object>();
        Map<String,Object> child1fields     = new Map<String,Object>();
        child1fields.put('catalogitemid',itemTest.Id);
        child1fields.put('itemCode','child1');
        child1fields.put('qty',1);
        child1Map.put('fields',child1fields);
        child1Map.put('listOfAttributes',listOfAttributes);

        Map<String,Object> child2Map        = new Map<String,Object>();
        Map<String,Object> child2fields     = new Map<String,Object>();
        child2fields.put('catalogitemid',itemTest.Id);
        child2fields.put('itemCode','child2');
        child2fields.put('qty',1);
        child2Map.put('fields',child2fields);
        child2Map.put('listOfAttributes',listOfAttributes);

        List<Object> childs = new List<Object>();
        childs.add(child1Map);
        childs.add(child2Map);
        rootMap.put('childItems',childs);

        Boolean result = OB_CatalogController.createComplexProductServer(JSON.serialize(rootMap),bundleId,JSON.serialize(ordObject));
        System.assertEquals(result, true);

        //enrico.purificato 22/10/2019 performance start
        delete [select id from NE__OrderItem__c where  NE__Bundle_Configuration__c  != null and  NE__OrderId__c =: order.Id];
        List<Map<String,Object>> productList = new List<Map<String,Object>>();
        productList.add(rootMap);

        Boolean result2 = OB_CatalogController.createAllProductServer(JSON.serialize(productList),bundleId,JSON.serialize(ordObject));
        System.assertEquals(result2, true);
        //enrico.purificato 22/10/2019 performance end

        Map<String, NE__OrderItem__c> resultListMap = OB_CatalogController.getConfigurationItemServer(JSON.serialize(ordObject));//davide.franzini - CheckOut Item Update Fix - 25/07/2019
        List<String> resultList = new List<String>(resultListMap.keySet());
        System.assertEquals(resultList.size()>0, true);

        Map<String,Object> child3Map        = new Map<String,Object>();
        Map<String,Object> child3fields     = new Map<String,Object>();
        child3fields.put('catalogitemid',itemTest.Id);
        child3fields.put('itemCode','child3');
        child3fields.put('qty',1);
        child3fields.put('parentItemId',resultList[0]); //davide.franzini - CheckOut Item Update Fix - 25/07/2019
        child3Map.put('fields',child3fields);
        child3Map.put('listOfAttributes',listOfAttributes);

        childs.clear();
        childs.add(child3Map);
        
        result = OB_CatalogController.insertChildProductsServer(JSON.serialize(childs),JSON.serialize(ordObject),bundleId);
        System.assertEquals(result, true);
        
        List<NE__Order_Item_Attribute__c> attribList = [SELECT id,NE__Order_Item__c FROM NE__Order_Item_Attribute__c WHERE NE__Order_Item__r.NE__OrderId__c = :order.id];
        
        listOfAttributes.clear();
        for(NE__Order_Item_Attribute__c attr: attribList)
        {   
            Map<String,Object>  tmpAttributeFields   = new Map<String,Object>();
            tmpAttributeFields.put('idLineAttribute',attr.id);
            tmpAttributeFields.put('lineId',attr.NE__Order_Item__c);
            tmpAttributeFields.put('value','someval');
            Map<String,Object> tmpAttribute        = new Map<String,Object>();
            tmpAttribute.put('fields',tmpAttributeFields);
            listOfAttributes.add(tmpAttribute);
        }
        result = OB_CatalogController.updateAttributesServer(JSON.serialize(listOfAttributes),order.id);
        System.assertEquals(result, true);
        String termOrdItRT =  Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId(); // francesca.ribezzi - 25/07/2019
        //davide.franzini - CheckOut Item Update Fix - 25/07/2019 - START
        Map<String,Object> child4Map        = new Map<String,Object>();
        Map<String,Object> child4fields     = new Map<String,Object>();
        child4fields.put('catalogitemid',itemTest.Id);
        child4fields.put('itemCode','child4');
        child4fields.put('qty',1);
        child4fields.put('orderitemid',attribList[0].NE__Order_Item__c);
        child4fields.put('OB_Ro__c', 'Y');
        child4fields.put('OB_Sequence__c', 10);
        child4fields.put('OB_enablement__c', 'Y');
        child4fields.put('OB_TermId__c', '01234567');
        child4fields.put('OB_Processor__c', 'EQUENS');
        child4fields.put('OB_VariationPOSPB__c', 'PEGGIORATIVA');
        child4fields.put('OB_Visible__c', 'N');
        child4fields.put('OB_Description__c', 'desc');
        child4fields.put('RecordTypeId', termOrdItRT);  //francesca.ribezzi - 25/07/2019

        child4Map.put('fields',child4fields);
        child4Map.put('listOfAttributes',listOfAttributes);
        List<Object> objList = new List<Object>();
        objList.add(child4Map);
        result = OB_CatalogController.updateItemsServer(JSON.serialize(objList), order.id);
        System.assertEquals(result, true);

        result = OB_CatalogController.removeItemServer(resultList,order.id);
        System.assertEquals(result, true);
        //davide.franzini - CheckOut Item Update Fix - 25/07/2019 - END
    }

    @isTest
    public static void setConfigurationToApprove()
    {
        Group queue = new Group();
        queue.Type = 'Queue';
        queue.Name = '05116 - Approvazione Pricing';
        insert queue;

        Account bankAccount = OB_TestDataFactory.getBankAccount();
        insert bankAccount;

        NE__Order_Header__c header = OB_TestDataFactory.getOrderHeader();
        header.OB_ProposerABI__c = bankAccount.Id;
        insert header;
        NE__Order__c order = OB_TestDataFactory.getOrder(header);
        order.OB_ApprovalLevel__c=OB_UtilityConstants.L1;
        insert order;

        Test.startTest(); 
        OB_CatalogController.setConfigurationToApprove(order.Id);
        Test.stopTest(); 

    }  

    /**
    *@author Micol Ferrari <micol.ferrari@accenture.com>
    *@date 04/07/02018
    */
    @isTest
    public static void checkForAcquiringChangesServer_test()
    {
        NE__Order_Header__c header = OB_TestDataFactory.getOrderHeader();
        NE__Order__c order = OB_TestDataFactory.getOrder(header);
        insert order;

        Test.startTest();
        OB_CatalogController.checkForAcquiringChangesServer(order.Id);
        Test.stopTest();

    } 

    /**
    *@author Micol Ferrari <micol.ferrari@accenture.com>
    *@date 04/07/02018
    */
    @isTest
    public static void retrieveUserLicense_test()
    {

        Test.startTest();
        OB_CatalogController.retrieveUserLicense();
        Test.stopTest();

    } 

    /**
    *@author Micol Ferrari <micol.ferrari@accenture.com>
    *@date 04/07/02018
    */
    @isTest
    public static void launchMaintenanceWizard_test()
    {

        Test.startTest();
        OB_CatalogController.launchMaintenanceWizard('test'); 
        Test.stopTest();

    } 

    /**
    *@author Elena Preteni <elena.preteni@accenture.com>
    *@date 04/07/02018
    */
    @isTest
    public static void updateConfigVariation_test()
    {

        Test.startTest();
        NE__Order__c order = OB_TestDataFactory.getOrder();
        insert order;
        OB_CatalogController.updateConfigVariation(order.Id,'MIGLIORATIVA'); 
        Test.stopTest();

    } 
        /**
    *@author Elena Preteni <elena.preteni@accenture.com>
    *@date 04/07/02018
    */
    @isTest
    public static void createLogRequestServer_test()
    {

        Test.startTest();
        Account bankAccount = OB_TestDataFactory.getBankAccount();
        insert bankAccount;
        Group queue = new Group();
        queue.Type = 'Queue';
        queue.Name = '05116 - Approvazione BIO';
        insert queue;
        OB_Bank_Profile__c bankProf = OB_TestDataFactory.getBankProfile(bankAccount);
        insert bankProf;
        Account acc = OB_TestDataFactory.getAccount();
        insert acc;
        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint();
        insert sp;
        NE__Order_Header__c header = OB_TestDataFactory.getOrderHeader();
        header.OB_ProposerABI__c = bankAccount.Id;
        insert header;
        NE__Order__c order = OB_TestDataFactory.getOrder(header);
        order.OB_AdditionalDocumentationRequired__c = true;
        insert order;
        OB_CatalogController.createLogRequestServer(acc.Id,sp.Id,order.Id,'05116','12300','sostituzione terminali',false); 
        Test.stopTest();

    } 

            /**
    *@author Elena Preteni <elena.preteni@accenture.com>
    *@date 04/07/02018
    */
    @isTest
    public static void createLogRequestServerBIO_test()
    {

        Test.startTest();
        Account acc = OB_TestDataFactory.getAccount();
        insert acc;
        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint();
        insert sp;
        NE__Order__c order = OB_TestDataFactory.getOrder();
        order.OB_AdditionalDocumentationRequired__c =true;
        insert order;
        OB_CatalogController.createLogRequestServer(acc.Id,sp.Id,order.Id,'03138','12300','sostituzione terminali',true); 
        Test.stopTest();

    } 
    /**
    *@author Elena Preteni <elena.preteni@accenture.com>
    *@date 04/07/02018
    */
    @isTest
    public static void updateAssetInMerchantTakeOver_test()
    {

        Test.startTest();
        Asset a = OB_TestDataFactory.getAsset();
        insert a;
        NE__Order__c order = OB_TestDataFactory.getOrder();
        insert order;
        OB_CatalogController.updateAssetInMerchantTakeOver(order.Id,a.Id); 
        Test.stopTest();

    } 

        /**
    *@author Elena Preteni <elena.preteni@accenture.com>
    *@date 04/07/02018
    */
    @isTest
    public static void saveAndExitBit2FlowCaller_test()
    {

        Test.startTest();
        Asset a = OB_TestDataFactory.getAsset();
        insert a;
        NE__Order__c order = OB_TestDataFactory.getOrder();
        insert order;
        String data ='{"OrderHeader": {"attributes": {"type": "NE__Order_Header__c","url": "/services/data/v46.0/sobjects/NE__Order_Header__c/a0w1X000001UzykQAC"},"Id": "a0w1X000001UzykQAC",	"Name": "ORH-0000002470","OB_Business_Model_Acquiring__c": "Bancario","OB_Business_Model_POS__c": "Trilaterale Nuovo","OB_FulfilmentStatus__c": "Draft","OB_FinalRejectionEmail__c": false,"OB_ProposerABI__c": "0011X00000AigOjQAJ","OB_ABI__c": "03138","OB_CAB__c": "12300","OB_Report_Type__c": "Punto Vendita","OB_Main_Process__c": "Maintenance","OB_Sub_Process__c": "variazione operativa"}}';
        Attachment att = new Attachment();
    
        OB_CatalogController.saveAndExitBit2FlowCaller(data,'{"Id":{"xType":"ID","sortable":true,"scale":0,"restrictedPickList":false,"relationshipName":"","regExp":{"flags":"","expression":"","errMsgLabel":""},"referenceTo":{},"referenceFields":[],"readOnly":true,"precision":0,"picklistEntries":[],"objectKey":"","name":"Id","mandatory":false,"length":18,"lcomponentNamespace":"","lcomponentName":"","label":"Record ID","groupable":true,"filterable":true,"digits":0,"defaultValue":"","calculated":false,"b2pDefinition":{"PDF":null,"objectKey":null,"mapName":null,"loadedText":null,"fieldApiName":null,"docCompHeader":null,"dateFormat":null},"addressMapping":{},"accesible":true}}',true); 
        Test.stopTest();

    } 
        /**
    *@author Elena Preteni <elena.preteni@accenture.com>
    *@date 04/07/02018
    */
        @isTest
    public static void setConfigurationToApproveL2()
    {
        NE__Order_Header__c header = OB_TestDataFactory.getOrderHeader();
        NE__Order__c order = OB_TestDataFactory.getOrder(header);
        order.OB_ApprovalLevel__c=OB_UtilityConstants.L2;
        insert order;

        Test.startTest();
        OB_CatalogController.setConfigurationToApprove(order.Id);
        Test.stopTest();

    } 
            /**
    *@author Elena Preteni <elena.preteni@accenture.com>
    *@date 04/07/02018
    */
        @isTest
    public static void setConfigurationToApproveL3()
    {
        NE__Order_Header__c header = OB_TestDataFactory.getOrderHeader();
        NE__Order__c order = OB_TestDataFactory.getOrder(header);
        order.OB_ApprovalLevel__c=OB_UtilityConstants.L3;
        insert order;

        Test.startTest();
        OB_CatalogController.setConfigurationToApprove(order.Id);
        Test.stopTest();

    }

    /*******************************************************************************
    Purpose:  Method tests setConfigurationToApprove - success scenario - operation user

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void setConfigurationToApproveOperation( )
    {
        Account bankAccount = OB_TestDataFactory.getBankAccount( );
        insert bankAccount;
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_Main_Process__c = OB_UtilityConstants.SETUP;
        testOrderHeader.OB_ProposerABI__c = bankAccount.Id;
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.OB_ApprovalLevel__c = OB_UtilityConstants.L1;
        insert testOrder;

        User operation = OB_TestDataFactory.getUser( );
        operation.ProfileId = [ SELECT Id FROM Profile WHERE Name = :OB_UtilityConstants.OPERATION LIMIT 1 ].get( 0 ).Id;
        insert operation;

        System.runAs( operation )
        {
            Boolean result = OB_CatalogController.setConfigurationToApprove( testOrder.Id );
            System.assert( result );
        }
    }

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   19-Sept-2019
    *   Task        :   EVO_PRODOB_452
    *   Description :   Covering cancelOrder
    */
    @isTest
    public static void callCancelOrder_Test( ) {

        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader();
        insert orderHeader;
        NE__Order__c order = OB_TestDataFactory.getOrder(orderHeader);
        insert order;

        List<NE__OrderItem__c> orderItemList = new List<NE__OrderItem__c>();
        for(Integer i = 5; i< 5; i++) {
            NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem(order.Id);
            orderItemList.add(orderItem);
        }
        insert orderItemList;
		
        Test.startTest();
            OB_CatalogController.callCancelOrder(order.Id);
        Test.stopTest();

    }

    /*******************************************************************************
	Purpose:  Test method for getShowQuote

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         20/09/2019      Created        
 	********************************************************************************/
    @isTest
    public static void getShowQuote_Test() {
            User portalUser =   OB_TestDataFactory.getPortalAccountOwner(); 
            System.runAs(portalUser){ 
                Account bankAccount = OB_TestDataFactory.getBankAccount();
                insert bankAccount;

                Contact con = new Contact();
                con.LastName = 'test';
                con.FirstName = 'Class';
                con.AccountId = bankAccount.Id;
                con.Email = 'user@test.com';
                insert con;
                
                User createdUser =  OB_TestDataFactory.getCommunityUserWithInsert(con);
                OB_Bank_Profile__c bankProf = OB_TestDataFactory.getBankProfile(bankAccount);
                bankProf.OB_Bank__c = con.AccountId;
                insert bankProf;
                System.runAs(createdUser)
                {
                    Test.startTest();
                    Boolean showButton = OB_CatalogController.getShowQuote();
                    System.assertNotEquals( null, showButton );
                    Test.stopTest();
                }
            }
    }
    /*******************************************************************************
	Purpose:  Test method for updatePrivacyServicePoint

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         20/09/2019      Created        
 	********************************************************************************/
    @isTest
    public static void updatePrivacyServicePoint_Test() {
        NE__Service_Point__c sp = new NE__Service_Point__c();
        insert sp;
        Test.startTest();
        OB_CatalogController.updatePrivacyServicePoint(sp.Id);
        List<NE__Service_Point__c> currentSp = [SELECT Id, 
													OB_Privacy_C3__c,
													OB_Privacy_C4__c,
													OB_Privacy_C5__c
													FROM NE__Service_Point__c
													WHERE Id =: sp.Id
													LIMIT 1];
        Boolean privacy = currentSp[0].OB_Privacy_C3__c;
        System.assertEquals( true, privacy );
        Test.stopTest();
    }

    /*******************************************************************************
	Purpose:  Test method for getOrderItemId

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         francesca ribezzi     21/11/2019      Created            PROD-145
 	********************************************************************************/
    @isTest
    public static void getOrderItemId_Test() {
        NE__Order__c o = new NE__Order__c(); 
        insert o;
        NE__OrderItem__c oi = OB_TestDataFactory.getOrderItem(o.Id);
        insert oi;
        String itemId = (String)oi.Id;
        Test.startTest();
            Id newId = OB_CatalogController.getOrderItemId(ItemId);
            System.assertEquals( newId, oi.Id ); 
        Test.stopTest(); 
    }

}