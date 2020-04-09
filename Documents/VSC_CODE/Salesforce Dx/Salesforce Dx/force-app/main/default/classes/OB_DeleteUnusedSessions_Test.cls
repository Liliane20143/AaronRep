@isTest
public with sharing class OB_DeleteUnusedSessions_Test 
{
    static testMethod void testMethod1()
    {

        NE__Bit2Win_Session__c ssnObj = new NE__Bit2Win_Session__c (OB_Valid__c= false);
        insert ssnObj;
        
        Test.startTest();
             OB_DeleteUnusedSessions b = new OB_DeleteUnusedSessions();
            Id batchprocessid = Database.executeBatch(b);
            System.assertEquals(batchprocessid != null, true);
        Test.stopTest();
    }

}