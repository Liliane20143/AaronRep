/*****************************************************************************
Purpose:  Class tests AddressManagementCN

History
--------
VERSION     AUTHOR                      DATE            DETAIL          Description
1.0         Marlena Łukomska-Rogala     13/06/2019      Created
*******************************************************************************/

@isTest
public with sharing class AddressManagementCN_Test {

    /*****************************************************************************
    Purpose:  Test getAddressAutoComplete method with invalid data given.

    History
    --------
    VERSION     AUTHOR                      DATE            DETAIL          Description
    1.0         Marlena Łukomska-Rogala     13/06/2019      Modified
    *******************************************************************************/

    @isTest
    public static void testGetAddressAutoCompleteWhenInvalidTypeIsGiven(){
        Test.setMock(HttpCalloutMock.class, new MockAutoCompleteComponentController());
        String expectedJson = '{"status":null,"predictions":null}';
        Test.startTest();
        System.assertEquals(expectedJson, AddressManagementCN.getAddressAutoComplete('Vict', 'region'));
        Test.stopTest();
    }

    /*****************************************************************************
    Purpose:  Test getPlaceDetail method with invalid data given.

    History
    --------
    VERSION     AUTHOR                      DATE            DETAIL          Description
    1.0         Marlena Łukomska-Rogala     13/06/2019      Modified
    *******************************************************************************/
    @IsTest
    public static void testGetPlaceDetailWithInvalidInput(){
        Test.setMock(HttpCalloutMock.class, new MockAutoCompleteComponentController());
        String expectedJson = '{"Status":null,"result":null,"html_attributions":null}';
        Test.startTest();
        System.assertEquals(expectedJson, AddressManagementCN.getPlaceDetail(''));
        Test.stopTest();
    }

}