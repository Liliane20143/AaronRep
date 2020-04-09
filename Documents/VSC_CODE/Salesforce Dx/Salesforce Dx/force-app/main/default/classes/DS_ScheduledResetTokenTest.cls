@istest
class DS_ScheduledResetTokenTest {
    

    static testmethod void test() {
        Test.startTest();
        
        Account pr = new Account(
                        Name = 'MPS',
                        DS_Token_Totali__c = 0,
                        DS_Token_Usati__c = 0,
                        DS_Token_per_Mese__c = 100,
                        DS_Banca__c = 'MPS');
        pr.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation Token' and SobjectType ='Account'  limit 1].Id;
        insert (pr);
        
        // Schedule the test job
        
        String jobId = System.schedule('Reset Token Test',
                                       '0 15 9 24 7 ? 2022', 
                                       new DS_ScheduledResetToken());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals('0 15 9 24 7 ? 2022', 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-07-24 09:15:00', 
                            String.valueOf(ct.NextFireTime));
        System.assertNotEquals(100,
                               [SELECT id, DS_Token_Totali__c FROM Account Limit 1].DS_Token_Totali__c);
        
        Test.stopTest();
        
        System.assertEquals(100,
                            [SELECT id, DS_Token_Totali__c FROM Account Limit 1].DS_Token_Totali__c);
        
    }
}