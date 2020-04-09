/*****************************************************************
Name: OB_ServicePointFromJSON_Test
Copyright © 2016 ITC
============================================================
Purpose:  Class tests OB_ServicePointFromJSON
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Kinga Fornal            19/06/2019         Created
********************************************************************************/
@isTest
public with sharing class OB_ServicePointFromJSON_Test
{

    /*******************************************************************************
       Purpose:  Method tests OB_ServicePointFromJSON parse method and checks if returned
       object is correct
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                  DATE            DETAIL          Description
       1.0      Kinga Fornal            19/06/2019         Created             ---
       ********************************************************************************/
    @isTest
    public static void servicePointFromJSONTest( )
    {
        NE__Service_Point__c sp = OB_TestDataFactory.getServicePoint();
        insert sp;
        OB_ServicePointFromJSON servicePoint = OB_ServicePointFromJSON.parse(JSON.serialize(sp));

        System.assertNotEquals(null, servicePoint);
        System.assertEquals(sp.Id, servicePoint.id);
    }
}