/*******************************************************************************
Purpose:  ?

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         ?                       ?               Created         ?
1.1         Zuzanna Urban       31/05/2019          NEXI-102        Format, delete not necessary code and add System Asserts, adjust code to the new logic
********************************************************************************/
@isTest
public class OB_SearchMobileController_Test
{
    @isTest
	public static void serverFilterByContactPhoneTest()
    {
        Account merchantAccountTest = OB_TestDataFactory.getAccount( );
        insert merchantAccountTest;

        Account bankAccountTest = OB_TestDataFactory.getAccount( );
        bankAccountTest.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_BANK ).getRecordTypeId( );
        insert bankAccountTest;

        NE__Service_Point__c servicePointTest = OB_TestDataFactory.getServicePoint( );
        insert servicePointTest;

        Contact contactTest = OB_TestDataFactory.getContact( merchantAccountTest );
        contactTest.OB_Bank__c = bankAccountTest.Id;
        contactTest.OB_Service_Point__c = servicePointTest.Id;
        contactTest.MobilePhone = '3333333333';
        insert contactTest;

        Contact cntSelected = new Contact();
        cntSelected =
        [
                SELECT MobilePhone,
                        AccountId,
                        OB_Bank__c,
                        OB_Service_Point__c,
                        RecordType.DeveloperName
            FROM Contact
            WHERE Id =: contactTest.Id
        ];

        System.assertNotEquals( null, OB_SearchMobileController.serverFilterByContactPhone( cntSelected.MobilePhone, cntSelected.AccountId, cntSelected.OB_Bank__c, cntSelected.OB_Service_Point__c, cntSelected.RecordType.DeveloperName ));
    }
}