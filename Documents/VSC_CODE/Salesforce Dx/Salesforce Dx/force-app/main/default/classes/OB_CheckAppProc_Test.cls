@isTest
public  class OB_CheckAppProc_Test {
    
    static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        // Create your test data
        NE__Order_Header__c header = new NE__Order_Header__c( OB_In_Approvazione_a__c 	= 'Controlli AML', 
                                                                OB_AcquiringApproval__c 	= false,
                                                                OB_StartApprovalProcess__c 	= true);

        insert header;
        
        Test.startTest();

        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new OB_CheckOrderHeadersInApprovalProcess());

        Test.stopTest();
        // Add assert here to validate result
    }

}