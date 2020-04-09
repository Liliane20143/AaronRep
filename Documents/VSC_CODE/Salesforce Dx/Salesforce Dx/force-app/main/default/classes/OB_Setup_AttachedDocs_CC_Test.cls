/*****************************************************************
Name: OB_Setup_AttachedDocs_CC_Test
Copyright © 2016 ITC
============================================================
Purpose:  Class tests OB_Setup_AttachedDocs_CC methods
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Monika Kocot            14/06/2019         Created             ---
********************************************************************************/
@isTest
public with sharing class OB_Setup_AttachedDocs_CC_Test {

    /*******************************************************************************
    Purpose:  Method tests OB_Setup_AttachedDocs_CC.getProductDocumentsServer,
              checks if result of method is as expected.
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Monika Kocot            14/06/2019         Created             ---
    ********************************************************************************/
    @isTest
    public static void getProductDocumentsServerTest(){

        String inputOrderHeaderId;
        String inputAteco;
        String inputLegalForm;
        String inputMechantId;
        String inputAbi;

        NE__Order_Header__c ordHead = OB_TestDataFactory.getOrderHeader();
        insert ordHead;

        NE__Order__c order = OB_TestDataFactory.getOrder();
        order.NE__Order_Header__c = ordHead.id;
        //order.id = inputOrderId;
        insert order;
        List<NE__Order__c> orders = new List<NE__Order__c>();
        orders.add(order);
        String mcc =  orders.get(0).OB_MCC__c;

        NE__OrderItem__c  orderIt= OB_TestDataFactory.getOrderItem(order.id);
        String mainProcess = '';
        insert orderIt;
        List<NE__OrderItem__c> orderItems = new List<NE__OrderItem__c>();
        orderItems.add(orderIt);
        Set<String> businessModel = new Set<String>();

        List<OB_Special_Category_Configuration__c> listSpecialCategory = OB_Utility.getSpecialCategory();
        Set<String> setClientType = new Set<String>();
        setClientType = OB_UtilityCallingServices.getClientTypeSet(listSpecialCategory,orderItems,mcc,inputAteco,inputLegalForm,inputMechantId,null,inputAbi,mainProcess);
        List<String> listClientType = new List<String>();
        listClientType.addAll(setClientType);

        List<OB_Product_Document__c> documents = OB_Utility.getAllDocuments(listClientType, mainProcess);
        Map<String, Map<String,map<String,String>>> mapdist = OB_Setup_AttachedDocs_CC.mapDocumentDistrinct(documents);

        Test.startTest();
        Map<String, Map<String,map<String,String>>> result = OB_Setup_AttachedDocs_CC.getProductDocumentsServer(order.Id,inputOrderHeaderId,inputAteco,inputLegalForm,inputMechantId,inputAbi);
        Test.stopTest();

        System.assertNotEquals(null,result);
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Setup_AttachedDocs_CC.mapDocumentDistrinct
              checks if value for key in the returned map is correct, when Object's field
              Related_To__c equals 'Merchant'.
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Monika Kocot            17/06/2019         Created             ---
    ********************************************************************************/
    @isTest
    public static void mapDocumentDistrinctMerchantTest() {
        OB_Product_Document__c prodDoc = OB_TestDataFactory.getProductDocument();
        prodDoc.Related_To__c = 'Merchant';
        prodDoc.OB_Document_Typology__c ='CONTRATTO FIRMATO';
        insert prodDoc;
        List<OB_Product_Document__c> listDocuments = new List<OB_Product_Document__c>();
        listDocuments.add(prodDoc);

        Map<String,map<String,String>> mapMerchant= new Map<String,map<String,String>>();
        Map<String,map<String,String>> mapServicePoint= new Map<String,map<String,String>>();

        Test.startTest();
        Map<String, Map<String,map<String,String>>> result = OB_Setup_AttachedDocs_CC.mapDocumentDistrinct(listDocuments);
        Test.stopTest();

        System.assertNotEquals(null,result);
        System.assertEquals('CONTRATTO FIRMATO',result.get('MERCHANT').get(prodDoc.OB_Description__c).get('TYPOLOGY'));

    }

    /*******************************************************************************
    Purpose:  Method tests OB_Setup_AttachedDocs_CC.mapDocumentDistrinct
              checks if value for key in the returned map is correct, when Object's field
              Related_To__c not equals 'Merchant'.
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Monika Kocot            17/06/2019         Created             ---
    ********************************************************************************/
    @isTest
    public static void mapDocumentDistrinctServicePointTest() {
        OB_Product_Document__c prodDoc = OB_TestDataFactory.getProductDocument();
        prodDoc.Related_To__c = 'Service';
        prodDoc.OB_Document_Typology__c ='CONTRATTO FIRMATO';
        insert prodDoc;
        List<OB_Product_Document__c> listDocuments = new List<OB_Product_Document__c>();
        listDocuments.add(prodDoc);

        Map<String,map<String,String>> mapMerchant= new Map<String,map<String,String>>();
        Map<String,map<String,String>> mapServicePoint= new Map<String,map<String,String>>();

        Test.startTest();
        Map<String, Map<String,map<String,String>>> result = OB_Setup_AttachedDocs_CC.mapDocumentDistrinct(listDocuments);
        Test.stopTest();

        System.assertNotEquals(null,result);
        System.assertEquals('CONTRATTO FIRMATO',result.get('SERVICEPOINT').get(prodDoc.OB_Description__c).get('TYPOLOGY'));
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Setup_AttachedDocs_CC.checkNeedBio
              checks if NE__Order__c Object is upserted correctly.
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Monika Kocot            17/06/2019         Created             ---
    ********************************************************************************/
    @isTest
    public static void checkNeedBioTest() {

        String inputAbi= '12345';

        //INSERTION OF PRODUCT_DOCUMENT
        OB_Product_Document__c prodDoc = OB_TestDataFactory.getProductDocument();
        prodDoc.OB_Document_Typology__c ='CONTRATTO FIRMATO';
        insert prodDoc;
        List<OB_Product_Document__c> listDocuments = new List<OB_Product_Document__c>();
        listDocuments.add(prodDoc);

        //INSERTION OF ACCOUNT
        Id recordTypeIdBank = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( OB_UtilityConstants.BANKRT ).getRecordTypeId( );
        Account bankAccount = OB_TestDataFactory.getAccount();
        bankAccount.OB_ABI__c = inputAbi;
        bankAccount.RecordTypeId = recordTypeIdBank;
        insert bankAccount;

        //INSERTION OF BANK_PROFILE
        OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c();
        bankProfile.OB_NeedBIO__c = true;
        bankProfile.OB_Bank__c = bankAccount.Id;
        bankProfile.OB_Service_Type__c = 'Acquiring';
        bankProfile.OB_Business_Model_POS__c = 'Bilaterale';
        bankProfile.OB_Circuit__c = 'JCB';
        bankProfile.OB_Other_Acquirer__c = 'Amex';
        bankProfile.OB_Applicant_RAC_Code_SIA__c = 'Banca';
        bankProfile.OB_Terminal_Id_Generator__c = 'Banca';
        bankProfile.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)';
        bankProfile.OB_GT__c = 'Nexi';
        bankProfile.OB_Processor__c = 'SIA SMAC';
        bankProfile.OB_Bilateral_Pricing__c = 'SI';
        bankProfile.OB_Sending_Contract_to_Nexi__c = 'SI';
        bankProfile.OB_SME_Factory__c = 'SI';
        insert bankProfile;

        //INSERTION OF ORDER_HEADER
        NE__Order_Header__c ordHead = OB_TestDataFactory.getOrderHeader();
        insert ordHead;

        //INSERTION OF ORDER
        NE__Order__c order = OB_TestDataFactory.getOrder();
        order.NE__Order_Header__c = ordHead.id;
        order.OB_AdditionalDocumentationRequired__c = true;
        insert order;

        Test.startTest();
        OB_Setup_AttachedDocs_CC.checkNeedBio(order.id,inputAbi,listDocuments);
        Test.stopTest();

        NE__Order__c afterUpdate =
        [Select id, OB_CheckApprovalProcessAcquiring__c
        from NE__Order__c
        where id = :order.Id limit 1];
        //insert afterUpdate;

        System.assertEquals(true, afterUpdate.OB_CheckApprovalProcessAcquiring__c);
    }
    /*******************************************************************************
    Purpose:  Method tests OB_Setup_AttachedDocs_CC.updateDocReqTrue
              checks if NE__Order_Header__c Object is upserted correctly
              when isToTriggered equals true.
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Monika Kocot            18/06/2019         Created             ---
    ********************************************************************************/
    @isTest
    public static void updateDocReqTrueTestisToTriggeredTrue() {

        Boolean inputIsToTriggered = true;
        NE__Order_Header__c ordHead = OB_TestDataFactory.getOrderHeader();
        insert ordHead;

        Test.startTest();
        OB_Setup_AttachedDocs_CC.updateDocReqTrue(ordHead.Id,inputIsToTriggered);
        Test.stopTest();

        NE__Order_Header__c afterUpdate =
        [SELECT Id,OB_AdditionalDocumentationRequired__c
        FROM NE__Order_Header__c
        WHERE Id =: ordHead.id];

        System.assertEquals(true,afterUpdate.OB_AdditionalDocumentationRequired__c);
    }

    /*******************************************************************************
    Purpose:  Method tests OB_Setup_AttachedDocs_CC.updateDocReqTrue
              checks if NE__Order_Header__c Object is upserted correctly
              when isToTriggered equals true.
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Monika Kocot            18/06/2019         Created             ---
    ********************************************************************************/
    @isTest
    public static void updateDocReqTrueTestisToTriggeredFalse() {

        Boolean inputIsToTriggered = false;
        NE__Order_Header__c ordHead = OB_TestDataFactory.getOrderHeader();
        insert ordHead;

        Test.startTest();
        OB_Setup_AttachedDocs_CC.updateDocReqTrue(ordHead.Id,inputIsToTriggered);
        Test.stopTest();

        NE__Order_Header__c afterUpdate =
        [SELECT Id,OB_AdditionalDocumentationRequired__c
        FROM NE__Order_Header__c
        WHERE Id =: ordHead.id];

        System.assertEquals(false,afterUpdate.OB_AdditionalDocumentationRequired__c);
    }
}