@isTest
public class OB_TestApprovalProcess_Test {
    
    @testSetup 
    public static void setUp() 
    { 
        Account a = new Account();
        a.Name = 'a'; 
        a.NE__VAT__c = '12345678901'; 
        a.OB_Employees_Number__c = 'Minore di 10';
        a.NE__Fiscal_code__c = 'AAAAAA11A11A111A';
        a.OB_ABI__c = '12345';
        insert a;
        
        Contact c = new Contact();
        c.LastName = 'c';
        c.AccountId = a.id;
        insert c;

    }

    @isTest
    public static void OB_BankOrderDashControllerTest()
    {    
//        UserRole portalRole = [Select Id From UserRole Where PortalType = 'Partner' Limit 1];
//        Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
//        User portalAccountOwner = new User();
//        portalAccountOwner.ProfileId = pAdmin.id;
//        portalAccountOwner.Username ='portalAccountOwner@test.com';
//        portalAccountOwner.Alias = 'alias';
//        portalAccountOwner.Email='portalAccountOwner@test.com';
//        portalAccountOwner.EmailEncodingKey='UTF-8';
//        portalAccountOwner.Firstname='firstName';
//        portalAccountOwner.Lastname='lastName';
//        portalAccountOwner.LanguageLocaleKey='en_US';
//        portalAccountOwner.LocaleSidKey='en_US';
//        portalAccountOwner.TimeZoneSidKey='America/Chicago';
//        portalAccountOwner.UserRoleId = portalRole.id;
//        insert portalAccountOwner;
        
//        System.runAs(portalAccountOwner) {
        
//            Account acc = [SELECT Id FROM Account WHERE Name = 'a'];
//            acc.ownerid = portalAccountOwner.id;
//            update acc;
            
            
//        }   
        
//        Contact con = [SELECT Id FROM Contact WHERE LastName = 'c' LIMIT 1];
//        Profile p = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'];
        
        
        
//        //User user = new User();
//        //            user.Username = 'user123123@test.com';
//        //            user.ContactId = con.id;
//        //            user.ProfileId = p.id;
//        //            user.ob_cab__c = '12345';
//        //            user.Alias = 'alias';
//        //            user.Email = 'user@test.com';
//        //            user.EmailEncodingKey = 'UTF-8';
//        //            user.LastName = 'lastName';
//        //            user.CommunityNickname = 'test12345';
//        //            user.TimeZoneSidKey = 'America/Los_Angeles';
//        //            user.LocaleSidKey = 'en_US';
//        //            user.LanguageLocaleKey = 'en_US';
//        //            user.OB_CAB__c = '12345';
//        //            insert user;
////UserRole role = new UserRole(Name = 'a Partner Manager');
////insert role;
//                    User userPartnerManager = new User();
//                    userPartnerManager.Username = 'userPartnerManager123123@test.com';
//                    userPartnerManager.ob_cab__c = '12345';
//                    userPartnerManager.ContactId = con.id;
//                    userPartnerManager.ProfileId = p.id;
//                    userPartnerManager.Alias = 'alias';
//                    userPartnerManager.Email = 'user@test.com';
//                    userPartnerManager.EmailEncodingKey = 'UTF-8';
//                    userPartnerManager.LastName = 'lastName';
//                    userPartnerManager.CommunityNickname = 'test12345';
//                    userPartnerManager.TimeZoneSidKey = 'America/Los_Angeles';
//                    userPartnerManager.LocaleSidKey = 'en_US';
//                    userPartnerManager.LanguageLocaleKey = 'en_US';
//                    userPartnerManager.OB_CAB__c = '12345';
//                    //userPartnerManager.UserRoleId = role.id;
//                    insert userPartnerManager;
                     
        




//System.runAs(userPartnerManager) 
//        {

            Test.startTest();
       		TestApprovalProcess.startApprovalProcess();
            Test.stopTest();
        //}
        
    }
}