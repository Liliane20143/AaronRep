@isTest
public class OB_Maintenance_ViewRecordDetail_Test 
{
    @isTest
    public static void retrieveLogRequestServerTest(){
        Id merchantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account acc = new Account(Name = 'acc');
        acc.RecordTypeId = merchantRecordTypeId;
        acc.OB_BypassValidation__c = true;
        insert acc;
        OB_LogRequest__c lr = new OB_LogRequest__c();
        lr.OB_AccountId__c = acc.id;
        lr.OB_ChangeLegalRepresentative__c = true;
        lr.OB_NewLegalRepresentative__c = true;
        lr.OB_RejectReason__c = 'Cancelled';
        lr.OB_ApprovalProcessStatus__c = 'Rigettato';
        insert lr;
        String logrequestId = lr.id;
        Test.startTest();
        OB_Maintenance_ViewRecordDetail_CC.retrieveLogRequestServer(logrequestId);
        Test.stopTest();

    }

    
    @isTest
    public static void inApprovalProcessTest()
    {
        Id merchantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account acc = new Account(Name = 'acc');
        acc.RecordTypeId = merchantRecordTypeId;
        acc.OB_BypassValidation__c = true;
        insert acc;
        OB_LogRequest__c lr = new OB_LogRequest__c();
        lr.OB_AccountId__c = acc.id;
        lr.OB_ChangeLegalRepresentative__c = true;
        lr.OB_NewLegalRepresentative__c = true;
        lr.OB_RejectReason__c = 'Cancelled';
        lr.OB_ApprovalProcessStatus__c = 'Rigettato';
        insert lr;
        String logrequestId = lr.id;
        Test.startTest();
        OB_Maintenance_ViewRecordDetail_CC.inApprovalProcess(logrequestId);
        Test.stopTest();
    }
    

    @isTest
    public static void retrieveStatusTest(){
        OB_LogRequest__c logrequest = new OB_LogRequest__c();
        logrequest.OB_Status__c = 'Rejected';
        insert logRequest;
        OB_Maintenance_ViewRecordDetail_CC.retrieveStatus(String.valueOf(logRequest.Id));
    }
    /*
    @isTest
    public static void editLogStatusTest(){
        OB_LogRequest__c logrequest = new OB_LogRequest__c();
        insert logRequest;
        OB_Maintenance_ViewRecordDetail_CC.editLogStatus(String.valueOf(logRequest.Id));
    }*/


   
    @isTest
    public static void checkProfilesDraftTest(){
        OB_LogRequest__c logrequest = new OB_LogRequest__c();
        insert logRequest;
        OB_Maintenance_ViewRecordDetail_CC.checkProfilesDraft(String.valueOf(logRequest.Id));
    }

    @isTest
    public static void getStringUrlTest(){

        // OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c();
        // ic.Name = 'DEV1';
        // ic.OB_Domain__c = 'dev1';
        // ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.nynF9045u2M-1WGn007JxObPiM3PBK0Q4GM8EBwQS0o6fJutTABfMSTtekOlCpQEv4vKSLmj0-Rgk5rQgireCX-cOp_Vvh9IYLl6xfOJfUR8f5mLUmY4r7BGrWtLbaM5wwTIJXQs8kFpp2VIePragkN2MahtjIOtBp1vQW2y';
        // ic.OB_timestamp__c = '1542902538147';
        // ic.OB_Timeout_Continuation__c = '30';
        // insert ic; 
        

        
        OB_Maintenance_ViewRecordDetail_CC.getStringUrl();
            }



    /*@isTest
    public static void checkOrderDetailsVisibilityTest(){
        OB_LogRequest__c  logRequest = new OB_LogRequest__c();
        insert logRequest;
        List<OB_LogRequest__c> logrequests = new List<OB_LogRequest__c>();
        logrequests.add(logRequest);
        Test.startTest();
        OB_Maintenance_ViewRecordDetail_CC.checkOrderDetailsVisibility(String.valueOf(logRequest.Id));
        Test.stopTest();
    }*/
 }