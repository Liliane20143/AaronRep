/*****************************************************************
Name:  OB_TrackingOrder_Test
============================================================
Purpose: Test class for OB_TrackingOrder.apxc
============================================================
History
-------                                                            
VERSION         AUTHOR              DATE            DETAIL          Description
1.0             Eros Orlando       08/01/2019      Created         Creation of the class
*****************************************************************/
@isTest
public class OB_ValidatingOrder_Test {
    @isTest
    public static void constructorsTest()
    {
        Test.startTest();
        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof('');
        OB_ValidatingOrder.getValidatingOrder();
        Test.stopTest();
    }
    
    @isTest
    public static void constructorsTest2()
    {
        Test.startTest();
        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  null;
        OB_ValidatingOrder.getValidatingOrder();
        Test.stopTest();
    }
    
    @isTest
    public static void getValidatingOrder_NoGTACQ_Test()
    {
        

        List<Account> accList = new List<Account>();
        Id rtMerchant           = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
        Account myMastMerchant  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active'); 

        Id accountBankRecordId          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
        Account bankAccount     = new Account(  Name='TEST',
                                                RecordTypeId=accountBankRecordId,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');   
        accList.add(myMastMerchant);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Setup' );
        insert orderHeader;
        System.debug('ORDER HEADER: ' +orderHeader );
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id, OB_MCCL2__c = 'test');
        insert configuration;
        
        
        OB_TrackingOrder.TrackingOrderRequest requestTracking   = new OB_TrackingOrder.TrackingOrderRequest();
        
        NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        
        insert orderItem;


        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/




        
        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c=bankAccount.Id;
        bp.OB_Service_Type__c = 'Acquiring'; 
        bp.OB_Business_Model_POS__c = 'Bilaterale'; 
        bp.OB_Circuit__c = 'JCB'; 
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
        bp.OB_Terminal_Id_Generator__c = 'Banca'; 
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
        bp.OB_GT__c = 'Nexi'; 
        bp.OB_Processor__c = 'SIA SMAC'; 
        bp.OB_Bilateral_Pricing__c = 'SI'; 
        bp.OB_Sending_Contract_to_Nexi__c = 'SI'; 
        bp.OB_SME_Factory__c = 'SI';
        insert bp;
        System.debug([SELECT id,OB_Business_Model_Acquiring__c FROM OB_Bank_Profile__c where OB_Bank__c =:bankAccount.Id]);
        Datetime dataInizio = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}]}';
        requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);

        //EO
        String requestOK = '{"orderHeaderId": "'+orderHeader.id+'","sourceName":"MONETICA","sourceType":"GT12","errorCode":"0","errorDescription":"OK","timeStamp":"2019-01-09 10:21:00"}';
        OB_ValidatingOrder.ValidatingOrderRequest requestTrackingOK = new OB_ValidatingOrder.ValidatingOrderRequest();
        
        requestTrackingOK = (OB_ValidatingOrder.ValidatingOrderRequest)JSON.deserialize(requestOK, OB_ValidatingOrder.ValidatingOrderRequest.class);
        
        
        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(requestOK);
        Id rtProduct           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c product = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProduct );
        insert product;
        
        orderItem.NE__OrderId__c=requestTracking.idOrdineSfdc ; 
        
        orderItem.OB_TermId__c='123456';//text field
        orderItem.OB_Terminal_Id__c = '123456';
        orderItem.NE__ProdId__c=product.Id;
        orderItem.OB_Processor__c = requestTracking.Acquiring[0].sistemaSorgente;

        update orderItem;
        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        NE__Service_Point__c servicePoint2 = new NE__Service_Point__c();
        insert servicePoint2;
        
        ExternalSourceMapping__c ext3 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=configuration.NE__AccountId__c,
            OB_Service_Point_ID__c=servicePoint2.Id,
             OB_CustomerCodeClientCode__c='TEST'  );
        Account accExt  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');
        insert accExt;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=accExt.Id,
            OB_Service_Point_ID__c=servicePoint2.Id ,
             OB_CustomerCodeClientCode__c='TEST' );
        extList.add(ext2);
        extList.add(ext3);
        insert extList;
        System.debug('EXTERNAL LIST: '     + extList);
        System.debug('REQUEST ACQUIRING: ' + requestTracking.Acquiring);
        

        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c  = 'mcc';
        lovMCC2.ne__value3__c = 'L2';
        lovMCC2.OB_Value4__c = configuration.OB_MCCL2__c;
        insert lovMCC2;
        
        Test.startTest();
        OB_ValidatingOrder.getValidatingOrder();
        Test.stopTest();
    }
    
    @isTest
    public static void getValidatingOrderGT_NoTS_Test()
    {
        

        List<Account> accList = new List<Account>();
        Id rtMerchant           = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
        Account myMastMerchant  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active'); 

        Id accountBankRecordId          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
        Account bankAccount     = new Account(  Name='TEST',
                                                RecordTypeId=accountBankRecordId,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');   
        accList.add(myMastMerchant);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Setup' );
        orderHeader.OB_GT_Error_Code__c = 1;
        orderHeader.OB_GT_Error_Desc__c = 'Test';
        orderHeader.OB_GT_Error_TS__c = DateTime.newInstance(1997, 1, 31, 7, 8, 16);
        insert orderHeader;
        System.debug('ORDER HEADER: ' +orderHeader );
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id, OB_MCCL2__c = 'test');
        insert configuration;
        
        
        OB_TrackingOrder.TrackingOrderRequest requestTracking   = new OB_TrackingOrder.TrackingOrderRequest();
        
        NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        
        insert orderItem;


        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/




        
        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c=bankAccount.Id;
        bp.OB_Service_Type__c = 'Acquiring'; 
        bp.OB_Business_Model_POS__c = 'Bilaterale'; 
        bp.OB_Circuit__c = 'JCB'; 
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
        bp.OB_Terminal_Id_Generator__c = 'Banca'; 
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
        bp.OB_GT__c = 'Nexi'; 
        bp.OB_Processor__c = 'SIA SMAC'; 
        bp.OB_Bilateral_Pricing__c = 'SI'; 
        bp.OB_Sending_Contract_to_Nexi__c = 'SI'; 
        bp.OB_SME_Factory__c = 'SI';
        insert bp;
        System.debug([SELECT id,OB_Business_Model_Acquiring__c FROM OB_Bank_Profile__c where OB_Bank__c =:bankAccount.Id]);
        Datetime dataInizio = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}]}';
        requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);

        //EO
        String requestOK = '{"orderHeaderId": "'+orderHeader.id+'","sourceName":"MONETICA","sourceType":"GT","errorCode":"0","errorDescription":"OK","timeStamp":"2019-01-09 10:21:00"}';
        OB_ValidatingOrder.ValidatingOrderRequest requestTrackingOK = new OB_ValidatingOrder.ValidatingOrderRequest();
        
        requestTrackingOK = (OB_ValidatingOrder.ValidatingOrderRequest)JSON.deserialize(requestOK, OB_ValidatingOrder.ValidatingOrderRequest.class);
        
        
        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(requestOK);
        Id rtProduct           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c product = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProduct );
        insert product;
        
        orderItem.NE__OrderId__c=requestTracking.idOrdineSfdc ; 
        
        orderItem.OB_TermId__c='123456';//text field
        orderItem.OB_Terminal_Id__c = '123456';
        orderItem.NE__ProdId__c=product.Id;
        orderItem.OB_Processor__c = requestTracking.Acquiring[0].sistemaSorgente;

        update orderItem;
        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        NE__Service_Point__c servicePoint2 = new NE__Service_Point__c();
        insert servicePoint2;
        
        ExternalSourceMapping__c ext3 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=configuration.NE__AccountId__c,
            OB_Service_Point_ID__c=servicePoint2.Id,
             OB_CustomerCodeClientCode__c='TEST'  );
        Account accExt  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');
        insert accExt;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=accExt.Id,
            OB_Service_Point_ID__c=servicePoint2.Id ,
             OB_CustomerCodeClientCode__c='TEST' );
        extList.add(ext2);
        extList.add(ext3);
        insert extList;
        System.debug('EXTERNAL LIST: '     + extList);
        System.debug('REQUEST ACQUIRING: ' + requestTracking.Acquiring);
        

        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c  = 'mcc';
        lovMCC2.ne__value3__c = 'L2';
        lovMCC2.OB_Value4__c = configuration.OB_MCCL2__c;
        insert lovMCC2;
        
        Test.startTest();
        OB_ValidatingOrder.getValidatingOrder();
        Test.stopTest();
    }
    
    @isTest
    public static void getValidatingOrderACQ_NoTS_Test()
    {
        List<Account> accList = new List<Account>();
        Id rtMerchant           = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
        Account myMastMerchant  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active'); 

        Id accountBankRecordId          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
        Account bankAccount     = new Account(  Name='TEST',
                                                RecordTypeId=accountBankRecordId,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');   
        accList.add(myMastMerchant);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Setup' );
        orderHeader.OB_ACQ_Error_Code__c = 1;
        orderHeader.OB_ACQ_Error_Desc__c = 'Test';
        orderHeader.OB_ACQ_Error_TS__c = DateTime.newInstance(1997, 1, 31, 7, 8, 16);
        insert orderHeader;
        System.debug('ORDER HEADER: ' +orderHeader );
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id, OB_MCCL2__c = 'test');
        insert configuration;
        
        
        OB_TrackingOrder.TrackingOrderRequest requestTracking   = new OB_TrackingOrder.TrackingOrderRequest();
        
        NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        
        insert orderItem;


        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/




        
        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c=bankAccount.Id;
        bp.OB_Service_Type__c = 'Acquiring'; 
        bp.OB_Business_Model_POS__c = 'Bilaterale'; 
        bp.OB_Circuit__c = 'JCB'; 
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
        bp.OB_Terminal_Id_Generator__c = 'Banca'; 
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
        bp.OB_GT__c = 'Nexi'; 
        bp.OB_Processor__c = 'SIA SMAC'; 
        bp.OB_Bilateral_Pricing__c = 'SI'; 
        bp.OB_Sending_Contract_to_Nexi__c = 'SI'; 
        bp.OB_SME_Factory__c = 'SI';
        insert bp;
        System.debug([SELECT id,OB_Business_Model_Acquiring__c FROM OB_Bank_Profile__c where OB_Bank__c =:bankAccount.Id]);
        Datetime dataInizio = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}]}';
        requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);

        //EO
        String requestOK = '{"orderHeaderId": "'+orderHeader.id+'","sourceName":"EQUENS","sourceType":"ACQUIRING","errorCode":"0","errorDescription":"OK","timeStamp":"2019-01-09 10:21:00"}';
        OB_ValidatingOrder.ValidatingOrderRequest requestTrackingOK = new OB_ValidatingOrder.ValidatingOrderRequest();
        
        requestTrackingOK = (OB_ValidatingOrder.ValidatingOrderRequest)JSON.deserialize(requestOK, OB_ValidatingOrder.ValidatingOrderRequest.class);
        
        
        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(requestOK);
        Id rtProduct           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c product = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProduct );
        insert product;
        
        orderItem.NE__OrderId__c=requestTracking.idOrdineSfdc ; 
        
        orderItem.OB_TermId__c='123456';//text field
        orderItem.OB_Terminal_Id__c = '123456';
        orderItem.NE__ProdId__c=product.Id;
        orderItem.OB_Processor__c = requestTracking.Acquiring[0].sistemaSorgente;

        update orderItem;
        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        NE__Service_Point__c servicePoint2 = new NE__Service_Point__c();
        insert servicePoint2;
        
        ExternalSourceMapping__c ext3 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=configuration.NE__AccountId__c,
            OB_Service_Point_ID__c=servicePoint2.Id,
             OB_CustomerCodeClientCode__c='TEST'  );
        Account accExt  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');
        insert accExt;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=accExt.Id,
            OB_Service_Point_ID__c=servicePoint2.Id ,
             OB_CustomerCodeClientCode__c='TEST' );
        extList.add(ext2);
        extList.add(ext3);
        insert extList;
        System.debug('EXTERNAL LIST: '     + extList);
        System.debug('REQUEST ACQUIRING: ' + requestTracking.Acquiring);
        

        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c  = 'mcc';
        lovMCC2.ne__value3__c = 'L2';
        lovMCC2.OB_Value4__c = configuration.OB_MCCL2__c;
        insert lovMCC2;
        
        Test.startTest();
        OB_ValidatingOrder.getValidatingOrder();
        Test.stopTest();
    }
    
    @isTest
    public static void getValidatingOrderGT_OK_Test(){
        

        List<Account> accList = new List<Account>();
        Id rtMerchant           = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
        Account myMastMerchant  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active'); 

        Id accountBankRecordId          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
        Account bankAccount     = new Account(  Name='TEST',
                                                RecordTypeId=accountBankRecordId,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');   
        accList.add(myMastMerchant);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Setup' );
        insert orderHeader;
        System.debug('ORDER HEADER: ' +orderHeader );
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id, OB_MCCL2__c = 'test');
        insert configuration;
        
        
        OB_TrackingOrder.TrackingOrderRequest requestTracking   = new OB_TrackingOrder.TrackingOrderRequest();
        
        NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        
        insert orderItem;


        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/




        
        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c=bankAccount.Id;
        bp.OB_Service_Type__c = 'Acquiring'; 
        bp.OB_Business_Model_POS__c = 'Bilaterale'; 
        bp.OB_Circuit__c = 'JCB'; 
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
        bp.OB_Terminal_Id_Generator__c = 'Banca'; 
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
        bp.OB_GT__c = 'Nexi'; 
        bp.OB_Processor__c = 'SIA SMAC'; 
        bp.OB_Bilateral_Pricing__c = 'SI'; 
        bp.OB_Sending_Contract_to_Nexi__c = 'SI'; 
        bp.OB_SME_Factory__c = 'SI';
        insert bp;
        System.debug([SELECT id,OB_Business_Model_Acquiring__c FROM OB_Bank_Profile__c where OB_Bank__c =:bankAccount.Id]);
        Datetime dataInizio = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}]}';
        requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);

        //EO
        String requestOK = '{"orderHeaderId": "'+orderHeader.id+'","sourceName":"MONETICA","sourceType":"GT","errorCode":"0","errorDescription":"OK","timeStamp":"2019-01-09 10:21:00"}';
        OB_ValidatingOrder.ValidatingOrderRequest requestTrackingOK = new OB_ValidatingOrder.ValidatingOrderRequest();
        
        requestTrackingOK = (OB_ValidatingOrder.ValidatingOrderRequest)JSON.deserialize(requestOK, OB_ValidatingOrder.ValidatingOrderRequest.class);
        
        
        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(requestOK);
        Id rtProduct           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c product = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProduct );
        insert product;
        
        orderItem.NE__OrderId__c=requestTracking.idOrdineSfdc ; 
        
        orderItem.OB_TermId__c='123456';//text field
        orderItem.OB_Terminal_Id__c = '123456';
        orderItem.NE__ProdId__c=product.Id;
        orderItem.OB_Processor__c = requestTracking.Acquiring[0].sistemaSorgente;

        update orderItem;
        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        NE__Service_Point__c servicePoint2 = new NE__Service_Point__c();
        insert servicePoint2;
        
        ExternalSourceMapping__c ext3 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=configuration.NE__AccountId__c,
            OB_Service_Point_ID__c=servicePoint2.Id,
             OB_CustomerCodeClientCode__c='TEST'  );
        Account accExt  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');
        insert accExt;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=accExt.Id,
            OB_Service_Point_ID__c=servicePoint2.Id ,
             OB_CustomerCodeClientCode__c='TEST' );
        extList.add(ext2);
        extList.add(ext3);
        insert extList;
        System.debug('EXTERNAL LIST: '     + extList);
        System.debug('REQUEST ACQUIRING: ' + requestTracking.Acquiring);
        

        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c  = 'mcc';
        lovMCC2.ne__value3__c = 'L2';
        lovMCC2.OB_Value4__c = configuration.OB_MCCL2__c;
        insert lovMCC2;
        
        Test.startTest();
        OB_ValidatingOrder.getValidatingOrder();
        Test.stopTest();
    }
    
    @isTest
    public static void getValidatingOrderGT_KO_Test(){
        

        List<Account> accList = new List<Account>();
        Id rtMerchant           = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
        Account myMastMerchant  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active'); 

        Id accountBankRecordId          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
        Account bankAccount     = new Account(  Name='TEST',
                                                RecordTypeId=accountBankRecordId,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');   
        accList.add(myMastMerchant);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Setup' );
        insert orderHeader;
        System.debug('ORDER HEADER: ' +orderHeader );
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id, OB_MCCL2__c = 'test');
        insert configuration;
        
        
        OB_TrackingOrder.TrackingOrderRequest requestTracking   = new OB_TrackingOrder.TrackingOrderRequest();
        
        NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        
        insert orderItem;


        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/




        
        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c=bankAccount.Id;
        bp.OB_Service_Type__c = 'Acquiring'; 
        bp.OB_Business_Model_POS__c = 'Bilaterale'; 
        bp.OB_Circuit__c = 'JCB'; 
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
        bp.OB_Terminal_Id_Generator__c = 'Banca'; 
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
        bp.OB_GT__c = 'Nexi'; 
        bp.OB_Processor__c = 'SIA SMAC'; 
        bp.OB_Bilateral_Pricing__c = 'SI'; 
        bp.OB_Sending_Contract_to_Nexi__c = 'SI'; 
        bp.OB_SME_Factory__c = 'SI';
        insert bp;
        System.debug([SELECT id,OB_Business_Model_Acquiring__c FROM OB_Bank_Profile__c where OB_Bank__c =:bankAccount.Id]);
        Datetime dataInizio = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}]}';
        requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);

        //EO
        String requestOK = '{"orderHeaderId": "'+orderHeader.id+'","sourceName":"MONETICA","sourceType":"GT","errorCode":"101","errorDescription":"Error 101 in Monetica","timeStamp":"2019-01-09 10:21:00"}';
        OB_ValidatingOrder.ValidatingOrderRequest requestTrackingOK = new OB_ValidatingOrder.ValidatingOrderRequest();
        
        requestTrackingOK = (OB_ValidatingOrder.ValidatingOrderRequest)JSON.deserialize(requestOK, OB_ValidatingOrder.ValidatingOrderRequest.class);
        
        
        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(requestOK);
        Id rtProduct           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c product = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProduct );
        insert product;
        
        orderItem.NE__OrderId__c=requestTracking.idOrdineSfdc ; 
        
        orderItem.OB_TermId__c='123456';//text field
        orderItem.OB_Terminal_Id__c = '123456';
        orderItem.NE__ProdId__c=product.Id;
        orderItem.OB_Processor__c = requestTracking.Acquiring[0].sistemaSorgente;

        update orderItem;
        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        NE__Service_Point__c servicePoint2 = new NE__Service_Point__c();
        insert servicePoint2;
        
        ExternalSourceMapping__c ext3 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=configuration.NE__AccountId__c,
            OB_Service_Point_ID__c=servicePoint2.Id,
             OB_CustomerCodeClientCode__c='TEST'  );
        Account accExt  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');
        insert accExt;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=accExt.Id,
            OB_Service_Point_ID__c=servicePoint2.Id ,
             OB_CustomerCodeClientCode__c='TEST' );
        extList.add(ext2);
        extList.add(ext3);
        insert extList;
        System.debug('EXTERNAL LIST: '     + extList);
        System.debug('REQUEST ACQUIRING: ' + requestTracking.Acquiring);
        

        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c  = 'mcc';
        lovMCC2.ne__value3__c = 'L2';
        lovMCC2.OB_Value4__c = configuration.OB_MCCL2__c;
        insert lovMCC2;
        
        Test.startTest();
        OB_ValidatingOrder.getValidatingOrder();
        Test.stopTest();
    }
    
    
    @isTest
    public static void getValidatingOrderACQ_OK_Test(){
        

        List<Account> accList = new List<Account>();
        Id rtMerchant           = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
        Account myMastMerchant  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active'); 

        Id accountBankRecordId          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
        Account bankAccount     = new Account(  Name='TEST',
                                                RecordTypeId=accountBankRecordId,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');   
        accList.add(myMastMerchant);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Setup' );
        insert orderHeader;
        System.debug('ORDER HEADER: ' +orderHeader );
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id, OB_MCCL2__c = 'test');
        insert configuration;
        
        
        OB_TrackingOrder.TrackingOrderRequest requestTracking   = new OB_TrackingOrder.TrackingOrderRequest();
        
        NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        
        insert orderItem;


        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/




        
        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c=bankAccount.Id;
        bp.OB_Service_Type__c = 'Acquiring'; 
        bp.OB_Business_Model_POS__c = 'Bilaterale'; 
        bp.OB_Circuit__c = 'JCB'; 
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
        bp.OB_Terminal_Id_Generator__c = 'Banca'; 
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
        bp.OB_GT__c = 'Nexi'; 
        bp.OB_Processor__c = 'SIA SMAC'; 
        bp.OB_Bilateral_Pricing__c = 'SI'; 
        bp.OB_Sending_Contract_to_Nexi__c = 'SI'; 
        bp.OB_SME_Factory__c = 'SI';
        insert bp;
        System.debug([SELECT id,OB_Business_Model_Acquiring__c FROM OB_Bank_Profile__c where OB_Bank__c =:bankAccount.Id]);
        Datetime dataInizio = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}]}';
        requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);

        //EO
        String requestOK = '{"orderHeaderId": "'+orderHeader.id+'","sourceName":"EQUENS","sourceType":"ACQUIRING","errorCode":"0","errorDescription":"OK","timeStamp":"2019-01-09 10:21:00"}';
        OB_ValidatingOrder.ValidatingOrderRequest requestTrackingOK = new OB_ValidatingOrder.ValidatingOrderRequest();
        
        requestTrackingOK = (OB_ValidatingOrder.ValidatingOrderRequest)JSON.deserialize(requestOK, OB_ValidatingOrder.ValidatingOrderRequest.class);
        
        
        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(requestOK);
        Id rtProduct           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c product = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProduct );
        insert product;
        
        orderItem.NE__OrderId__c=requestTracking.idOrdineSfdc ; 
        
        orderItem.OB_TermId__c='123456';//text field
        orderItem.OB_Terminal_Id__c = '123456';
        orderItem.NE__ProdId__c=product.Id;
        orderItem.OB_Processor__c = requestTracking.Acquiring[0].sistemaSorgente;

        update orderItem;
        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        NE__Service_Point__c servicePoint2 = new NE__Service_Point__c();
        insert servicePoint2;
        
        ExternalSourceMapping__c ext3 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=configuration.NE__AccountId__c,
            OB_Service_Point_ID__c=servicePoint2.Id,
             OB_CustomerCodeClientCode__c='TEST'  );
        Account accExt  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');
        insert accExt;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=accExt.Id,
            OB_Service_Point_ID__c=servicePoint2.Id ,
             OB_CustomerCodeClientCode__c='TEST' );
        extList.add(ext2);
        extList.add(ext3);
        insert extList;
        System.debug('EXTERNAL LIST: '     + extList);
        System.debug('REQUEST ACQUIRING: ' + requestTracking.Acquiring);
        

        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c  = 'mcc';
        lovMCC2.ne__value3__c = 'L2';
        lovMCC2.OB_Value4__c = configuration.OB_MCCL2__c;
        insert lovMCC2;
        
        Test.startTest();
        OB_ValidatingOrder.getValidatingOrder();
        Test.stopTest();
    }
    
    @isTest
    public static void getValidatingOrderACQ_KO_Test(){
        

        List<Account> accList = new List<Account>();
        Id rtMerchant           = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
        Account myMastMerchant  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active'); 

        Id accountBankRecordId          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
        Account bankAccount     = new Account(  Name='TEST',
                                                RecordTypeId=accountBankRecordId,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');   
        accList.add(myMastMerchant);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Setup' );
        insert orderHeader;
        System.debug('ORDER HEADER: ' +orderHeader );
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id, OB_MCCL2__c = 'test');
        insert configuration;
        
        
        OB_TrackingOrder.TrackingOrderRequest requestTracking   = new OB_TrackingOrder.TrackingOrderRequest();
        
        NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        
        insert orderItem;


        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/




        
        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c=bankAccount.Id;
        bp.OB_Service_Type__c = 'Acquiring'; 
        bp.OB_Business_Model_POS__c = 'Bilaterale'; 
        bp.OB_Circuit__c = 'JCB'; 
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
        bp.OB_Terminal_Id_Generator__c = 'Banca'; 
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
        bp.OB_GT__c = 'Nexi'; 
        bp.OB_Processor__c = 'SIA SMAC'; 
        bp.OB_Bilateral_Pricing__c = 'SI'; 
        bp.OB_Sending_Contract_to_Nexi__c = 'SI'; 
        bp.OB_SME_Factory__c = 'SI';
        insert bp;
        System.debug([SELECT id,OB_Business_Model_Acquiring__c FROM OB_Bank_Profile__c where OB_Bank__c =:bankAccount.Id]);
        Datetime dataInizio = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}]}';
        requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);

        //EO
        String requestOK = '{"orderHeaderId": "'+orderHeader.id+'","sourceName":"EQUENS","sourceType":"ACQUIRING","errorCode":"101","errorDescription":"Error 101 in Equens","timeStamp":"2019-01-09 10:21:00"}';
        OB_ValidatingOrder.ValidatingOrderRequest requestTrackingOK = new OB_ValidatingOrder.ValidatingOrderRequest();
        
        requestTrackingOK = (OB_ValidatingOrder.ValidatingOrderRequest)JSON.deserialize(requestOK, OB_ValidatingOrder.ValidatingOrderRequest.class);
        
        
        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(requestOK);
        Id rtProduct           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c product = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProduct );
        insert product;
        
        orderItem.NE__OrderId__c=requestTracking.idOrdineSfdc ; 
        
        orderItem.OB_TermId__c='123456';//text field
        orderItem.OB_Terminal_Id__c = '123456';
        orderItem.NE__ProdId__c=product.Id;
        orderItem.OB_Processor__c = requestTracking.Acquiring[0].sistemaSorgente;

        update orderItem;
        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        NE__Service_Point__c servicePoint2 = new NE__Service_Point__c();
        insert servicePoint2;
        
        ExternalSourceMapping__c ext3 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=configuration.NE__AccountId__c,
            OB_Service_Point_ID__c=servicePoint2.Id,
             OB_CustomerCodeClientCode__c='TEST'  );
        Account accExt  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true, 
                                                OB_DescriptionVATNotPresent__c='description', 
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');
        insert accExt;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=accExt.Id,
            OB_Service_Point_ID__c=servicePoint2.Id ,
             OB_CustomerCodeClientCode__c='TEST' );
        extList.add(ext2);
        extList.add(ext3);
        insert extList;
        System.debug('EXTERNAL LIST: '     + extList);
        System.debug('REQUEST ACQUIRING: ' + requestTracking.Acquiring);
        

        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c  = 'mcc';
        lovMCC2.ne__value3__c = 'L2';
        lovMCC2.OB_Value4__c = configuration.OB_MCCL2__c;
        insert lovMCC2;
        
        Test.startTest();
        OB_ValidatingOrder.getValidatingOrder();
        Test.stopTest();
    }
}