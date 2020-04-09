@IsTest
public with sharing class OB_ABI_CAB_Selection_CC_Test {

    private static final Map<String, Schema.RecordTypeInfo> ACCOUNT_INFO = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( );
    private static final Id ACCOUNT_RT_ID = ACCOUNT_INFO.get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );

    /*******************************************************************************
       Purpose:  Method to test getUserInformation() method for NexiPartnerUser - scenario - success.
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                       DATE            DETAIL          Description
       1.0         Marlena Łukomska-Rogala      17/06/2019      Created
       2.0         Marlena Łukomska-Rogala      18/06/2019      Modified
       ********************************************************************************/

    @IsTest public static void testGettingUserInformationForNexiPartnerUser() {

        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs(portalAccountOwner) {
            Account testAccount = OB_TestDataFactory.getAccount();
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact(testAccount);
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser(testContact);
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile().Id;
            insert testCommunityUser;

            System.runAs(testCommunityUser) {

                Test.startTest();
                String partnerCommunity = System.Label.OB_License_PartnerCommunity;
                OB_ABI_CAB_Selection_CC.getUserInformation();
                Test.stopTest();
            }
        }
    }

    /*******************************************************************************
       Purpose:  Method to test getUserInformation() method for NexiPartnerUser - scenario - NexiPartnerUser with empty OB_ABI__c.
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                       DATE            DETAIL          Description
       1.0         Marlena Łukomska-Rogala      18/06/2019      Created
       ********************************************************************************/


        @IsTest public static void testGettingUserInformationForNexiPartnerUserWithEmptyABI(){

            User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
            insert portalAccountOwner;

            User testCommunityUser;
            System.runAs(portalAccountOwner) {
                Account testAccount = OB_TestDataFactory.getAccount();
                testAccount.OwnerId = portalAccountOwner.Id;
                testAccount.RecordTypeId = ACCOUNT_RT_ID;
                testAccount.OB_ABI__c='';
                insert testAccount;
                Contact testContact = OB_TestDataFactory.getContact(testAccount);
                insert testContact;
                testCommunityUser = OB_TestDataFactory.getCommunityUser(testContact);
                testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile().Id;
                insert testCommunityUser;

                System.runAs(testCommunityUser) {

                    Test.startTest();
                    String partnerCommunity = System.Label.OB_License_PartnerCommunity;
                    OB_ABI_CAB_Selection_CC.getUserInformation();
                    Test.stopTest();
                }
            }
    }

    /*******************************************************************************
       Purpose:  Method to test getUserInformation() method for NexiPartnerUser - scenario - NexiPartnerUser with few OB_CAB__c.
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                       DATE            DETAIL          Description
       1.0         Marlena Łukomska-Rogala      18/06/2019      Created
       ********************************************************************************/


    @IsTest public static void testGettingUserInformationForNexiPartnerUserWithFewCAB(){

        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs(portalAccountOwner) {
            Account testAccount = OB_TestDataFactory.getAccount();
            testAccount.OwnerId = portalAccountOwner.Id;
            testAccount.RecordTypeId = ACCOUNT_RT_ID;
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact(testAccount);
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser(testContact);
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile().Id;
            testCommunityUser.OB_CAB__c = '123;456';
            insert testCommunityUser;

            System.runAs(testCommunityUser) {

                Test.startTest();
                String partnerCommunity = System.Label.OB_License_PartnerCommunity;
                OB_ABI_CAB_Selection_CC.getUserInformation();
                Test.stopTest();
            }
        }
    }

    /*******************************************************************************
       Purpose:  Method to test getUserInformation() method for OperationalUser - scenario - success.
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                       DATE            DETAIL          Description
       1.0         Marlena Łukomska-Rogala      18/06/2019      Created
       ********************************************************************************/

    @IsTest public static void testGettingUserInformationForNonPartnerUser(){

        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner();
        insert portalAccountOwner;

        User testCommunityUser;
        System.runAs(portalAccountOwner) {
            testCommunityUser = OB_TestDataFactory.getPortalAccountOwner();
            testCommunityUser.Username='portalAccountOwnerSecond@test.com';
            Profile testOperationProfile = [ SELECT Id FROM Profile WHERE Name =: System.Label.OB_Operation LIMIT 1 ];
            testCommunityUser.ProfileId = testOperationProfile.Id;
            insert testCommunityUser;

            System.runAs(testCommunityUser) {

                Test.startTest();
                String operationProfile = System.Label.OB_Operation;
                OB_ABI_CAB_Selection_CC.getUserInformation();
                Test.stopTest();
            }
        }
    }
}