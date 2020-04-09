@isTest public class OB_Maintenance_EditNewExec_Interm_Test {
    @isTest
    public static void saveDraftTest() {
        OB_LogRequest__c logrequest = new OB_LogRequest__c();
        insert logrequest;
        Test.startTest();
        OB_Maintenance_EditNewExec_Interm_CC.saveDraft(logrequest.Id);
        Test.stopTest();
    }
    @isTest
    public static void saveDraftTest1() {
        String logId = '';

        Test.startTest();
        OB_Maintenance_EditNewExec_Interm_CC.saveDraft(logId);
        Test.stopTest();
    }

    /*******************************************************************************
       Purpose:  Method tests OB_Maintenance_EditNewExec_Interm_CC.checkOnLogRequest,
                 checks if OB_Status__c field of object OB_LogRequest__c is correctly updated
                 by the tested method
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                  DATE            DETAIL          Description
       1.0         Natalia Nawrocka        14/06/2019      Created             ---
       1.1         Kinga Fornal            08/08/2019      Updated         set OB_NewLegalRepresentative__c to true
       ********************************************************************************/
    @isTest
    public static void checkOnLogRequest() {

        OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c();
        ic.Name = 'DEV1';
        ic.OB_Domain__c = 'dev1';
        ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.nynF9045u2M-1WGn007JxObPiM3PBK0Q4GM8EBwQS0o6fJutTABfMSTtekOlCpQEv4vKSLmj0-Rgk5rQgireCX-cOp_Vvh9IYLl6xfOJfUR8f5mLUmY4r7BGrWtLbaM5wwTIJXQs8kFpp2VIePragkN2MahtjIOtBp1vQW2y';
        ic.OB_timestamp__c = '1542902538147';
        ic.OB_Timeout_Continuation__c = '30';
        insert ic;

        OB_LogRequest__c logRequest = new OB_LogRequest__c();
        logRequest.OB_ChangeLegalRepresentative__c = false;
        logRequest.OB_NewLegalRepresentative__c = true;
        logRequest.OB_Status__c = 'status';
        insert logRequest;

        Test.startTest();
        OB_Maintenance_EditNewExec_Interm_CC.checkOnLogRequest(logRequest.Id);
        Test.stopTest();

        List<OB_LogRequest__c> requests = [
                SELECT Id, Name, OB_Status__c
                FROM OB_LogRequest__c
                WHERE Id = :logRequest.Id
                LIMIT 1
        ];
        OB_LogRequest__c resultLogRequest = requests.get(0);

        System.assertEquals(OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA, resultLogRequest.OB_Status__c);
    }
}