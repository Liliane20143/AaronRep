/*********************************************************************
Name:  OB_MerchantGetDocument
======================================================================                                                                                                       
History                                                            
                                                        
  AUTHOR            DATE CREATED        DESCRIPTION
  gianluigi.virga   27/08/2019			Class to handle the retrieve of documents in test class

**********************************************************************/
@isTest
global class OB_MockGetDocument implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req){
        String merchantId;
        List<Account> merch = [select Id from Account where name = 'MERCHANTGETDOCUMENTACCOUNTTEST' limit 1]; 
        if(!merch.isEmpty() && merch != null){
            merchantId = merch.get(0).id;
        }else{
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
            merchantId = merchant.id;
        }
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

        NE__Service_Point__c sp = new NE__Service_Point__c(	NE__Account__c=merchantId,
                                                           Name='TEST SP',
                                                           OB_Status__c='Inactive');
        insert sp;
        
        NE__Order_Header__c oh = new NE__Order_Header__c(NE__AccountId__c=merchantid, OB_ProposerABI__c = merchantId, OB_Main_Process__c='Setup', NE__Type__c='');
        insert oh;

        NE__Order__c order = new NE__Order__c(  OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO, OB_Service_Point__c = sp.Id, 
                                              NE__BillingProfId__c = billProf.Id, NE__BillAccId__c = acc.Id, OB_BankAccount_Acquiring__c= billProf.Id );
        order.NE__Order_Header__c = oh.Id;
        insert order;

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"documents": [{"documentId": "{TESTMOCK}","metadata": [{"indexId": "285","metadataLabel": "documentFilename","values": [{"string": "TEST.pdf"}]}, {"indexId": "494","metadataLabel": "merchantId","values": [{"string": "'+ merchantId +'"}]}, {"indexId": "495","metadataLabel": "salesPointId","values": [{"string": "'+sp.id+'"}]}, {"indexId": "496","metadataLabel": "documentStatus","values": [{"string": "ACTIVE"}]}, {"indexId": "500","metadataLabel": "documentType","values": [{"string": "DOCUMENTO DI IDENTITA"}]}, {"indexId": "502","metadataLabel": "orderId","values": [{"string": "'+ order.id +'"}]}, {"indexId": "498","metadataLabel": "documentTemplateName","values": [{"string": ""}]}]}]}');
        res.setStatusCode(200);
        return res;
    }
}