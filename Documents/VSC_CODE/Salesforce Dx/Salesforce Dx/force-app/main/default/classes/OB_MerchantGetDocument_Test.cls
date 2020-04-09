/*********************************************************************
Name:  OB_MerchantGetDocument_Test
======================================================================                                                                                                       
History                                                            
                                                        
  AUTHOR            DATE CREATED        DESCRIPTION
  gianluigi.virga   09/08/2019          Test class for OB_MerchantGetDocument

**********************************************************************/
@isTest
global with sharing class OB_MerchantGetDocument_Test{
    @testSetup
    public static void setup(){
        OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c();
        ic.Name = 'DEV1';
        ic.OB_Domain__c = 'dev1';
        ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.nynF9045u2M-1WGn007JxObPiM3PBK0Q4GM8EBwQS0o6fJutTABfMSTtekOlCpQEv4vKSLmj0-Rgk5rQgireCX-cOp_Vvh9IYLl6xfOJfUR8f5mLUmY4r7BGrWtLbaM5wwTIJXQs8kFpp2VIePragkN2MahtjIOtBp1vQW2y';
        ic.OB_timestamp__c = '1542902538147';
        ic.OB_Timeout_Continuation__c = '30';
        insert ic; 

        Account merchant = new Account();
        merchant.NE__VAT__c             = '05218600962';
        merchant.NE__Fiscal_code__c     = '05218600962';
        merchant.Name                   = 'STRADIVARIUS ITALIA SRL';
        merchant.OB_Legal_Form__c       = 'ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE'; 
        merchant.NE__E_mail__c          = 'test@gmail.it';
        merchant.OB_Employees_Number__c = 'Minore di 10';
        merchant.OB_Legal_Address_Street__c = 'POLO DELLA QUALITA\' ASI SUD MOD	';
        merchant.OB_Legal_Address_Street_Number__c   = '';
        merchant.OB_Legal_Address_Detail__c   = 'STUDIO DE MATTEIS	';
        merchant.OB_Legal_Address_ZIP__c      = '81025';
        merchant.OB_Legal_Address_City__c     = 'MARCIANISE';
        merchant.OB_Legal_Address_State_Code__c   = '';
        merchant.OB_Legal_Address_Country_Code__c = '';
        merchant.OB_No_Profit_Recipient_Class__c  = 'Senza tetto'; 
        merchant.OB_No_Profit_Class__c            = 'Fondazioni';
        merchant.RecordTypeId                     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bank').getRecordTypeId();
        insert merchant;

        Id merchantId    = merchant.id ;
        Id proposerABIId = merchantId; 
        Id rtEsecutore = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Esecutore').getRecordTypeId();
        
        Contact legalReference  = new Contact();
        legalReference.Phone = '123456765';
        legalReference.Email    = 'contact@gmail.com';
        legalReference.MobilePhone = '56767676';
        legalReference.FirstName = 'RIRI'; 
        legalReference.LastName = 'TOTI' ; 
        legalReference.OB_Sex__c = 'M';
        legalReference.OB_Fiscal_Code__c = 'TTORRI00A01D150K'; 
        legalReference.OB_Document_Release_Authority__c = 'Questura';
        legalReference.OB_Document_Type__c = 'Passaporto';
        legalReference.OB_Document_Number__c  = '123erty645';
        legalReference.OB_Birth_Date__c = Date.newInstance(2000, 01, 01);
        legalReference.OB_Document_Expiration_Date__c = Date.newInstance(2028, 10, 25);
        legalReference.OB_Document_Release_Date__c  =  Date.newInstance(2018, 10, 26);
        legalReference.Fax = '2345456';  
        legalReference.RecordTypeId = rtEsecutore;
        legalReference.OB_bank__c = proposerABIId ; 
        insert legalReference;

        NE__Service_Point__c sp = new NE__Service_Point__c(	NE__Account__c=merchant.Id,
                                                           Name='TEST SP',
                                                           OB_Status__c='Inactive');
        insert sp;

        List<NE__Order__c> configurations = new List<NE__Order__c> ();
        NE__Order_Header__c oh = new NE__Order_Header__c(NE__AccountId__c=merchantId, OB_ProposerABI__c = merchantId, OB_Main_Process__c='Setup', NE__Type__c='');
        insert oh;

        NE__Product__c prod = new NE__Product__c(OB_Codice_sfdc__c = '1111');
        insert prod;

        Account acc = new Account(Name = 'test');
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.NE__Fiscal_code__c = '12345678909';
        acc.NE__VAT__c = '67543456789';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );//grzegorz.banach@accenture.com SETUP-251 15-04-2019 deleted space which made the method fail
        insert acc;

        NE__Billing_Profile__c billProf = new NE__Billing_Profile__c();
        String iban = 'IT26D0511611703000000002340';
        billProf.NE__Iban__c = iban;
        billProf.OB_ABICode__c = '05116';
        billProf.OB_CABCode__c = '11703';
        billProf.OB_CINCode__c = 'D';
        billProf.OB_Bank_Account_Number__c  = '000000002340';
        billProf.OB_EuroControlCode__c  = '26';
        billProf.OB_CountryCode__c = 'IT';
        billProf.OB_BypassValidation__c = false;
        billProf.NE__Account__c = acc.Id;
        insert billProf; 

        NE__Order__c order = new NE__Order__c(  OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO, OB_Service_Point__c = sp.Id, 
                                              NE__BillingProfId__c = billProf.Id, NE__BillAccId__c = acc.Id, OB_BankAccount_Acquiring__c= billProf.Id );
        order.NE__Order_Header__c = oh.Id;
        configurations.add(order);
        insert configurations;

        NE__OrderItem__c configurationItem  = new NE__OrderItem__c();
        configurationItem.NE__Description__c = 'I\'m a test';
        configurationItem.NE__Qty__c = 10;
        configurationItem.NE__OrderId__c = configurations[0].Id;
        configurationItem.NE__ProdId__c = prod.Id;
        insert configurationItem;
    }
    
    @isTest
	public static void getMerchantDocumentsFromFilenet_Test()
	{
        Account merchant = new Account();
        merchant.NE__VAT__c             = '05218600962';
        merchant.NE__Fiscal_code__c     = '05218600962';
        merchant.Name                   = 'MERCHANTGETDOCUMENTACCOUNTTEST';
        merchant.OB_Legal_Form__c       = 'ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE'; 
        merchant.NE__E_mail__c          = 'test@gmail.it';
        merchant.OB_Employees_Number__c = 'Minore di 10';
        merchant.OB_Legal_Address_Street__c = 'POLO DELLA QUALITA\' ASI SUD MOD	';
        merchant.OB_Legal_Address_Street_Number__c   = '';
        merchant.OB_Legal_Address_Detail__c   = 'STUDIO DE MATTEIS	';
        merchant.OB_Legal_Address_ZIP__c      = '81025';
        merchant.OB_Legal_Address_City__c     = 'MARCIANISE';
        merchant.OB_Legal_Address_State_Code__c   = '';
        merchant.OB_Legal_Address_Country_Code__c = '';
        merchant.OB_No_Profit_Recipient_Class__c  = 'Senza tetto'; 
        merchant.OB_No_Profit_Class__c            = 'Fondazioni';
        merchant.RecordTypeId                     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bank').getRecordTypeId();
        insert merchant;
        
        Test.setMock(HttpCalloutMock.class, new OB_MockGetDocument());
		Test.startTest();
        Map<String, Map<String, String>> mapOfDocuments = OB_MerchantGetDocument.getMerchantDocumentsFromFilenet(merchant.id);
        System.AssertNotEquals(mapOfDocuments.keySet(), null);
        Test.stopTest();
	}
    
    @isTest
    public static void getServicePointNameAndAbiForServicePoint_Test(){
        List<NE__Order__c> orderList = [select Id from NE__Order__c where OB_Service_Point__c != null limit 1];
        List<String> order = new List<String>();
        if(!orderList.isEmpty() && orderList != null){
            String currentId = orderList.get(0).Id;
            order.add(currentId);
        }
        Test.startTest();
        if(!order.isEmpty() && order != null){
		   // Map<Id, NE__Order__c> mapServicePointNameAndAbi = OB_MerchantGetDocument.getServicePointNameAndAbiForServicePoint( order.Id, null, null );
        }
        Test.stopTest();
    }
    
    @isTest
    public static void getTokenJWE_Test()
    {
        Test.setMock(HttpCalloutMock.class, new MockMakeGetCalloutController());
        Test.startTest();
        OB_MerchantGetDocument.getTokenJWE('test');
        Test.stopTest();
    }
    
    /*
        * Author    :   Morittu Andrea
        * Date      :   02-Sep-2019
        * Task      :   Covering getDynamicFieldsFromMapOfDocuments()
    */
    @isTest
    public static void getDynamicFieldsFromMapOfDocuments_Test()  {
        List<String> listOfOrder = new List<String>();
        List<String> listOfLogReq = new List<String>();
        Map<String, Map<String, String>> mapOfDocuments = new Map<String, Map<String, String>>();
        
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader();
        insert orderHeader;
        for(Integer i = 0; i< 10; i++) {
            NE__Order__c order = OB_TestDataFactory.getOrder(orderHeader);
            insert order;
            listOfOrder.add(order.Id);
        }
        
        for(Integer i = 0; i< 10; i++) {
            OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest();
            insert logRequest;
            listOfLogReq.add(logRequest.Id);
        }
        
        Test.startTest();
        	OB_MerchantGetDocument.getDynamicFieldsFromMapOfDocuments(listOfOrder, listOfLogReq, null);
        Test.stopTest();
    }
}