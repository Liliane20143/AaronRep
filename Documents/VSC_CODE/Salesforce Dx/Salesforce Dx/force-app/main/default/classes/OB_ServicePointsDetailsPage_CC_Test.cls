/*******************************************************************************
Purpose:  Class that is test for OB_ServicePointsDetailsPage_CC

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Joanna Mielczarek       03/07/2019      Created         NEXI-143
********************************************************************************/
@isTest
public with sharing class OB_ServicePointsDetailsPage_CC_Test  
{

    /*******************************************************************************
    Purpose:  Method tests getInfo_apex - happy flow

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/07/2019      Created         NEXI-143
    ********************************************************************************/
    @isTest
    private static void getInfo_apexTest( )
    {
        // NEXI-143 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__Account__c = testAccount.Id;
        insert testServicePoint;
        Contact testContact = OB_TestDataFactory.getContact( testAccount );
        testContact.OB_Service_Point__c = testServicePoint.Id;
        insert testContact;

        Test.startTest( );
        Map<String, List<Object>> result = OB_ServicePointsDetailsPage_CC.getInfo_apex( testServicePoint.Id );
        Test.stopTest( );

        System.assert( result.get( 'contextAccount' ) != null );
        System.assert( result.get( 'contextServicePoint' ) != null );
        System.assert( result.get( 'contacts' ) != null );
    }

    /*******************************************************************************
    Purpose:  Method tests getInfo_apex - empty param

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/07/2019      Created         NEXI-143
    ********************************************************************************/
    @isTest
    private static void getInfo_apexTestNullParamTest( )
    {
        // NEXI-143 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        Test.startTest( );
        Map<String, List<Object>> result = OB_ServicePointsDetailsPage_CC.getInfo_apex( null );
        Test.stopTest( );
        System.assertEquals( new Map<String, List<Object>>( ), result );
    }

    /*******************************************************************************
    Purpose:  Method tests getAbi- happy flow

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/07/2019      Created         NEXI-143
    ********************************************************************************/
    @isTest
    private static void getAbiTest( )
    {
        // NEXI-143 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        Account testAccount;
        User testCommunityUser;

        System.runAs( portalAccountOwner )
        {
            testAccount = OB_TestDataFactory.getAccount( );
            testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile( ).Id;
            insert testCommunityUser;
        }

        System.runAs( testCommunityUser )
        {
            System.assertEquals( testAccount.OB_ABI__c, OB_ServicePointsDetailsPage_CC.getAbi( ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests getAbi- empty return value

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/07/2019      Created         NEXI-143
    ********************************************************************************/
    @isTest
    private static void getAbiEmptyTest( )
    {
        // NEXI-143 <joanna.mielczarek@accenture.com> - just covered method to increase CC

        System.assertEquals( '', OB_ServicePointsDetailsPage_CC.getAbi( ) );
    }

}