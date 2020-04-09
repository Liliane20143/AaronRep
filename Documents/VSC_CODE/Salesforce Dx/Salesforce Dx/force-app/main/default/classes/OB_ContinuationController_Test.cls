@isTest
public class OB_ContinuationController_Test {
    
    @testSetup
    public static void setup() {
        OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c();
        ic.Name = 'DEV1';
        ic.OB_Domain__c = 'dev1';
        ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.nynF9045u2M-1WGn007JxObPiM3PBK0Q4GM8EBwQS0o6fJutTABfMSTtekOlCpQEv4vKSLmj0-Rgk5rQgireCX-cOp_Vvh9IYLl6xfOJfUR8f5mLUmY4r7BGrWtLbaM5wwTIJXQs8kFpp2VIePragkN2MahtjIOtBp1vQW2y';
        ic.OB_timestamp__c = '1542902538147';
        ic.OB_Timeout_Continuation__c = '30';
        //ic.OB_CAsigned_name__c = 'CPQIntegrationUserCert';
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
        
        //List<Contact> contactList = new List<Contact>();
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
        //legalReference.OB_Document_Release_Date__c = Date.newInstance(2018, 10, 26);
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
    public static void OB_ContinuationControllerTest() {
        OB_ContinuationController cc = new OB_ContinuationController();
    }
    
    @isTest
    public static void getVFBaseURLTest() {
        UserRole r = new UserRole(
            DeveloperName = 'MyCustomRole', 
            Name = 'My Role');
        insert r;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id);
        
        
        Test.startTest();
        OB_ContinuationController.getVFBaseURL();
        Test.stopTest();
    }

    @isTest
    public static void invokeElse() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('else', new List<String>());
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest1() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('getPostel', new List<String>{
                'provincia', 'a', 'b'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest2() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('getPostel', new List<String>{
                'comune', 'a', 'b'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest3() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('getPostel', new List<String>{
                'frazione', 'a', 'b'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest4() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('getPostel', new List<String>{
                'strada', 'a', 'b'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest5() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('retriveServicePoint', new List<String>{
                'provincia', 'a', 'b', 'c', 'd', 'e', 'f'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest6() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('retriveServicePoint', new List<String>{
                'comune', 'a', 'b', 'c', 'd', 'e', 'f'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest7() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('retriveServicePoint', new List<String>{
                'frazione', 'a', 'b', 'c', 'd', 'e', 'f'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest8() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('retriveServicePoint', new List<String>{
                'strada', 'a', 'b', 'c', 'd', 'e', 'f'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest9() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('retriveMerchant', new List<String>{
                'provincia', 'a', 'b'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest10() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('retriveMerchant', new List<String>{
                'comune', 'a', 'b'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest11() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('retriveMerchant', new List<String>{
                'frazione', 'a', 'b'
        });
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest12() {
        
        
        Test.startTest();
        OB_ContinuationController.invoke('retriveMerchant', new List<String>{
                'strada', 'a', 'b'
        });
        Test.stopTest();
    }
    
    
  /*  @isTest
    public static void invokeTest17() {
        
        
        Test.startTest();
        //OB_ContinuationController.invoke('filenetUpload', new List<String>{'provincia', 'a', 'b', 'c', 'd', 'e', 'f', 'true'});
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest18() {
        
        
        Test.startTest();
        //OB_ContinuationController.invoke('filenetUpload', new List<String>{'comune', 'a', 'b', 'c', 'd', 'e', 'f', 'g'});
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest19() {
        
        
        Test.startTest();
        //OB_ContinuationController.invoke('filenetUpload', new List<String>{'frazione', 'a', 'b', 'c', 'd', 'e', 'f', 'g'});
        Test.stopTest();
    }
    
    @isTest
    public static void invokeTest20() {
        
        
        Test.startTest();
        //OB_ContinuationController.invoke('filenetUpload', new List<String>{'strada', 'a', 'b', 'c', 'd', 'e', 'f', 'g'});
        Test.stopTest();
    }*/
    
    @isTest static void geBase64DocIdTest() {
        OB_Contract__c contract = new OB_Contract__c(   OB_Description_contract__c = 'Contratto Trilaterale POS', 
                                                     Name='Contratto Trilaterale POS',
                                                     OB_Typology__c = 'Famiglia POS'
                                                    );
        insert contract;
        
        List<String> paramsFalse = new List<String>(); 
        Id merchantId =  [SELECT Id FROM Account WHERE Name = 'STRADIVARIUS ITALIA SRL'].Id;
        paramsFalse.add(merchantId);
        Id spId =  [SELECT Id FROM NE__Service_Point__c WHERE Name = 'TEST SP'].Id;
        paramsFalse.add(spId);
        Id orderHeaderId =  [SELECT Id FROM NE__Order_Header__c LIMIT 1].Id;
        paramsFalse.add(orderHeaderId);
        Id configurationItemId =  [SELECT Id FROM NE__Order__c LIMIT 1].Id;
        paramsFalse.add(configurationItemId);
        paramsFalse.add(contract.Id);
        paramsFalse.add('false');
        paramsFalse.add('');
        paramsFalse.add('Descrzione Test');

        List<String> paramsTrue = new List<String>(); 
        paramsTrue.add(merchantId);
        paramsTrue.add(spId);
        paramsTrue.add(orderHeaderId);
        paramsTrue.add(configurationItemId);
        paramsTrue.add(contract.Id);
        paramsTrue.add('true');
        paramsTrue.add('');
        paramsTrue.add('Descrzione Test');
        
        Test.startTest();
        OB_ContinuationController.invoke('getBase64DocID', paramsFalse); 
        OB_ContinuationController.invoke('getBase64DocID', paramsTrue); 
        Test.stopTest();
    }
    
    @isTest static void filenetUploadTest1() {  
        Test.startTest();
        List<String> params = new List<String>(); 
        Id merchantId =  [SELECT Id FROM Account WHERE Name = 'STRADIVARIUS ITALIA SRL'].Id;
        params.add(merchantId);
        Id spId =  [SELECT Id FROM NE__Service_Point__c WHERE Name = 'TEST SP'].Id;
        params.add(spId);
        Id orderHeaderId =  [SELECT Id FROM NE__Order_Header__c LIMIT 1].Id;
        params.add(orderHeaderId);
        params.add('DOCUMENTO DI IDENTITA');
        params.add('VEVTVCBGSUxFTkVU');
        params.add('false');
        params.add('');
        params.add('Descrzione Test.tx');
        OB_ContinuationController.invoke('filenetUpload',params);
        Test.stopTest();
    }
    @isTest static void filenetUploadTest2() {  
        Test.startTest();
        List<String> params = new List<String>(); 
        Id merchantId =  [SELECT Id FROM Account WHERE Name = 'STRADIVARIUS ITALIA SRL'].Id;
        params.add(merchantId);
        Id spId =  [SELECT Id FROM NE__Service_Point__c WHERE Name = 'TEST SP'].Id;
        params.add(spId);
        Id orderHeaderId =  [SELECT Id FROM NE__Order_Header__c LIMIT 1].Id;
        params.add(orderHeaderId);
        params.add('DOCUMENTO DI IDENTITA');
        params.add('VEVTVCBGSUxFTkVU');
        params.add('true');
        params.add('1234567890-asedrftyuio-234567');
        params.add('Descrzione Test.tx');
        OB_ContinuationController.invoke('filenetUpload',params);
        Test.stopTest();
    }
    
    @isTest static void visualizeDocLoadTest1() {  
        Test.startTest();
        List<String> params = new List<String>(); 
        Id merchantId =  [SELECT Id FROM Account WHERE Name = 'STRADIVARIUS ITALIA SRL'].Id;
        params.add(merchantId);
        Id spId =  [SELECT Id FROM NE__Service_Point__c WHERE Name = 'TEST SP'].Id;
        params.add(spId);
        //Id orderHeaderId =  [SELECT Id FROM NE__Order_Header__c LIMIT 1].Id;
        //params.add(orderHeaderId);
        Id configurationItemId =  [SELECT Id FROM NE__Order__c LIMIT 1].Id;
        params.add(configurationItemId);
        /*params.add('DOCUMENTO DI IDENTITA');
params.add('VEVTVCBGSUxFTkVU');
params.add('true');*/
        params.add('1234567890-asedrftyuio-234567');
        // params.add('Descrzione Test.tx');
        OB_ContinuationController.invoke('visualizeDocLoad',params);
        Test.stopTest();
    }
    
    @isTest static void visualizeDocLoadLogRequestTest1() {  
        Test.startTest();
        List<String> params = new List<String>(); 
        Id merchantId =  [SELECT Id FROM Account WHERE Name = 'STRADIVARIUS ITALIA SRL'].Id;
        params.add(merchantId);
        Id spId =  [SELECT Id FROM NE__Service_Point__c WHERE Name = 'TEST SP'].Id;
        params.add(spId);
        //Id orderHeaderId =  [SELECT Id FROM NE__Order_Header__c LIMIT 1].Id;
        //params.add(orderHeaderId);
        Id configurationItemId =  [SELECT Id FROM NE__Order__c LIMIT 1].Id;
        params.add(configurationItemId);
        /*params.add('DOCUMENTO DI IDENTITA');
params.add('VEVTVCBGSUxFTkVU');
params.add('true');*/
        params.add('1234567890-asedrftyuio-234567');
        // params.add('Descrzione Test.tx');
        OB_ContinuationController.invoke('visualizeDocLoadLogRequest',params);
        Test.stopTest();
    }
    
    @isTest
    public static void callbackTestProvince() {
        HttpResponse response = new HttpResponse();
        response.setBody('Mock response body');
        response.setStatusCode(200);
        HttpRequest req = new HttpRequest();
        
        Account state = new Account();
        
        Test.startTest();
        OB_ContinuationController.requestBodyFromTestClass ='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><response><errorMessage/><indexSize>111</indexSize><originalInput/><match>false</match><time>0</time><format>PROVINCE</format><item><sigla>AG</sigla><id>1</id><istat>084</istat><nome>AGRIGENTO</nome></item><item><sigla>AL</sigla><id>2</id><istat>006</istat><nome>ALESSANDRIA</nome></item></response>';
        OB_ContinuationController.callback(state);
        Test.stopTest();
    }

    @isTest
    public static void callbackTestComune() {
        HttpResponse response = new HttpResponse();
        response.setBody('Mock response body');
        response.setStatusCode(200);
        HttpRequest req = new HttpRequest();
        
        Account state = new Account();
        
        Test.startTest();
        OB_ContinuationController.requestBodyFromTestClass ='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><response><errorMessage/><indexSize>111</indexSize><originalInput/><match>false</match><time>0</time><format>COMUNE</format><item><id>1</id><istat>084</istat><nome>MILANO</nome></item></response>';
        OB_ContinuationController.callback(state);
        Test.stopTest();
    } 

    @isTest
    public static void callbackTestFrazione() {
        HttpResponse response = new HttpResponse();
        response.setBody('Mock response body');
        response.setStatusCode(200);
        HttpRequest req = new HttpRequest();
        
        Account state = new Account();
        
        Test.startTest();
        OB_ContinuationController.requestBodyFromTestClass ='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><response><errorMessage/><indexSize>111</indexSize><originalInput/><match>false</match><time>0</time><format>FRAZIONE</format><item><id>1</id><istat>084</istat><nome>FRAZIONETEST</nome></item></response>';
        OB_ContinuationController.callback(state);
        Test.stopTest();
    } 

    @isTest
    public static void callbackTestStrada() {
        HttpResponse response = new HttpResponse();
        response.setBody('Mock response body');
        response.setStatusCode(200);
        HttpRequest req = new HttpRequest();
        
        Account state = new Account();
        
        Test.startTest();
        OB_ContinuationController.requestBodyFromTestClass ='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><response><errorMessage/><indexSize>111</indexSize><originalInput/><match>false</match><time>0</time><format>STRADA</format><item><id>1</id><istat>084</istat><nome>STRADATEST</nome></item></response>';
        OB_ContinuationController.callback(state);
        Test.stopTest();
    } 
    
    @isTest
    public static void callbackTest2() {
        HttpResponse response = new HttpResponse();
        response.setBody('Mock response body');
        response.setStatusCode(200);
        HttpRequest req = new HttpRequest();
        
        Account state = new Account();
    //     	public class ResponseGenerate {
	// 	public String documentId 			{get;set;}
	// 	public String fileName 			{get;set;}
	// 	public String documentStream  	{get;set;}
	// 	public String documentFileName 	{get;set;}
	// 	public Error error = new Error();
	// }
	// public class Error {
	// 	public String code 		{get;set;}
	// 	public String message 	{get;set;}
	// }
        Test.startTest();
        OB_ContinuationController.requestBodyFromTestClass = '{"documentId" : "documentIdValue", "fileName" : "fileNameValue", "documentStream" : "documentStreamValue", "documentFileName" : "documentFileNameValue", "error" : {"code" : "codeValue", "message" : "messageValue"}}';
        OB_ContinuationController.callback(state);
        Test.stopTest();
    }
    
        @isTest
    public static void callbackTest3() {
        // HttpResponse response = new HttpResponse();
        // response.setBody('Mock response body');
        // response.setStatusCode(200);
        // HttpRequest req = new HttpRequest();
        
        Account state = new Account();
    //     	public class ResponseGenerate {
	// 	public String documentId 			{get;set;}
	// 	public String fileName 			{get;set;}
	// 	public String documentStream  	{get;set;}
	// 	public String documentFileName 	{get;set;}
	// 	public Error error = new Error();
	// }
	// public class Error {
	// 	public String code 		{get;set;}
	// 	public String message 	{get;set;}
	// }
        Test.startTest();
        OB_ContinuationController.requestBodyFromTestClass = 'else';
        OB_ContinuationController.callback(state);
        Test.stopTest();
    }
    
    
    @isTest
    public static void testWebService() {
        Continuation conti = (Continuation) OB_ContinuationController.invoke('getPostel', new List<String>{
                'strada', 'a', 'b'
        });
        
        Map<String, HttpRequest> requests = conti.getRequests();
        
        HttpResponse response = new HttpResponse();
        response.setBody('Mock response body');
        response.setStatusCode(200);
        HttpRequest req = new HttpRequest();
        //Test.setContinuationResponse(conti.addHttpRequest(req), response);
        //Test.invokeContinuationMethod(controller, conti);
        Test.startTest();
        //OB_ContinuationController.callback(conti.addHttpRequest(req));
        Test.stopTest();
    }
    
    
    /*  @isTest
public static void getFileNameTest()
{

String merchantId =  [SELECT Id FROM Account WHERE Name = 'STRADIVARIUS ITALIA SRL'].Id;
String spId =  [SELECT Id FROM NE__Service_Point__c WHERE Name = 'TEST SP'].Id;
String configurationItemId =  [SELECT Id FROM NE__Order__c LIMIT 1].Id;
Test.startTest();
Test.setMock(HttpCalloutMock.class, new MockGetFileName());
OB_ContinuationController.getFileName(merchantId, spId, configurationItemId, '1234567890-asedrftyuio-234567');
Test.stopTest();
}*/
    
    @isTest
    public static void getFileNameTest() {
        
        
        String merchantId = '';
        String salespointsId = '';
        String salespointsIdNotNull = 'salespointsIdNotNull';
        String configurationIdOrLogRequest = '';
        String docId = '';
        Boolean isLogRequestTrue = true;
        Boolean isLogRequestFalse = false;
        
        Test.setMock(HttpCalloutMock.class, new MockMakeGetCalloutController());
        Test.startTest();
        OB_ContinuationController.getFileName(merchantId, salespointsId, configurationIdOrLogRequest, docId, isLogRequestTrue);
        OB_ContinuationController.getFileName(merchantId, salespointsId, configurationIdOrLogRequest, docId, isLogRequestFalse);
        OB_ContinuationController.getFileName(merchantId, salespointsIdNotNull, configurationIdOrLogRequest, docId, isLogRequestTrue);
        Test.stopTest();
        
    }

    /*******************************************************************************
    Purpose: Method test getTokenJWE with 1 parameters

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0 		Giovanni Spinelli	    03/06/2019		Created 		    ?
    2.0 		Marta Stempien			11/09/2019		Modified		    NEXI-298
    ********************************************************************************/
    @isTest
    private static void getTokenJWEOneParameterTest()
    {
        Test.setMock(HttpCalloutMock.class, new MockMakeGetCalloutController());
        Test.startTest();
        Map<String,String> returnedMap = OB_ContinuationController.getTokenJWE('test');
        Test.stopTest();
        System.assertEquals('test' , returnedMap.get('documentId') );
    }

    /*******************************************************************************
    Purpose: Method test getTokenJWE with 2 parameters

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0 		Marta Stempien			10/09/2019		Created		    NEXI-298
    ********************************************************************************/
    @isTest
    private static void getTokenJWETwoParametersTest()
    {
        Test.setMock(HttpCalloutMock.class, new MockMakeGetCalloutController());
        Test.startTest();
        String logRequestId = 'testId';
        Map<String,String> returnedMap = OB_ContinuationController.getTokenJWE('test', logRequestId);
        Test.stopTest();
        System.assertEquals( logRequestId, returnedMap.get('logRequestId') );
    }
    
    /*******************************************************************************
	Purpose:  Test method for retrieveQuoteTemplate

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         20/09/2019      Created        
 	********************************************************************************/
    @isTest 
    public static void retrieveQuoteTemplate_Test( )
    {
        String templateName = 'Contratto Trilaterale POS';
        OB_Contract__c template = new OB_Contract__c();
        template.OB_Template_Name__c = templateName;
        insert template;
        
        Test.startTest( );
        String templateId = OB_ContinuationController.retrieveQuoteTemplate( templateName );
        System.assertNotEquals( null, templateId );
        Test.stopTest( );
    }
}