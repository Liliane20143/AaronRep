/*******************************************************************************
Purpose:  Test class for PicklistCmpCtrl

History: Kinga Fornal<kinga.fornal@accenture.com>, 19/06/2019 Code Coverage Fix, changed private to global scope
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0        ripagano              19/04/2018         Created             ---
********************************************************************************/

@IsTest global class PicklistCmpCtrlTest {
    @IsTest private static void testPickOptsSingle() {

        List<Object> options = (List<Object>) JSON.deserializeUntyped(PicklistCmpCtrl.getPickOpts('Opportunity', 'Type', null, null, null, false, ''));

        Schema.DescribeFieldResult fieldResult = Opportunity.Type.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        System.assertEquals(ple.size(), options.size());
    }

    @IsTest private static void testPickOptsMulti() {
        List<Object> options = (List<Object>) JSON.deserializeUntyped(PicklistCmpCtrl.getPickOpts('Opportunity', 'Type', null, null, null, true, ''));

        Schema.DescribeFieldResult fieldResult = Opportunity.Type.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        System.assertEquals(ple.size(), options.size());
    }

    @IsTest private static void testPickOptsDep() {
//    Can't test better
        List<Object> options = (List<Object>) JSON.deserializeUntyped(PicklistCmpCtrl.getPickOpts('Account', 'Type', null, 'Other', 'AccountSource', true, ''));
    }

    /*******************************************************************************
    Purpose:  Method tests PicklistCmpCtrl GetPickOptions method,
    checks if result is not null for given parameters
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Kamil Entsua-Mensah        19/06/2019      Created             ---
    ********************************************************************************/

    @IsTest private static void testGetPickOptions() {
        Test.setMock(HttpCalloutMock.class, new DepHttpCalloutMockWith500Code());
        String result = PicklistCmpCtrl.getPickOpts('Account', 'Type', 'Dev', null, null, true, '');
        System.debug('testGetPickOptions result: ' + result);
        System.assertNotEquals(result, null);

    }

    /*******************************************************************************
    Purpose:  Method tests PicklistCmpCtrl getPickOpts method,
    checks if result is not null(selected value null)
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Kamil Entsua-Mensah        19/06/2019      Created             ---
    ********************************************************************************/
    @IsTest private static void testGetPickOptionsWithRecordGetTypeNull() {
        Test.setMock(HttpCalloutMock.class, new DepHttpCalloutMockWith500Code());
        String result = PicklistCmpCtrl.getPickOpts(null, null, 'Other', 'Other', null, false, null);

        System.debug('testGetPickOptionsWithRecordGetTypeNull result: ' + result);
        System.assertNotEquals(result, null);
    }

    /*******************************************************************************
    Purpose:  Method tests PicklistCmpCtrl GetPickListValuesByRecordType method,
    check if result list is as expected(size 0)

    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Kamil Entsua-Mensah        19/06/2019      Created             ---
    ********************************************************************************/
    @IsTest private static void testGetPickListValuesByRecordType() {
        Test.setMock(HttpCalloutMock.class, new DepHttpCalloutMockWith500Code());

        String sObjectType = 'Account';
        String recordTypeId = '0011X00000AigPDQAZ';
        String field = 'Type';
        Profile p = [SELECT Id FROM profile WHERE name = 'Standard User'];

        User u = OB_TestDataFactory.getUser();
        u.ProfileId = p.Id;
        List<PicklistCmpCtrl.SelectOption> selectOptions;

        System.runAs(u) {
            Test.startTest();
            selectOptions = PicklistCmpCtrl.getPickListValuesByRecordType(sObjectType, recordTypeId, field);
            Test.stopTest();
        }

        System.debug('testGetPickListValuesByRecordType List<PicklistCmpCtrl.SelectOption>: ' + selectOptions);
        System.assertEquals(0, selectOptions.size());
    }

    /*******************************************************************************
    Purpose:  Method tests PicklistCmpCtrl GetPickListValuesByRecordType method,
    check if result list is as expected(size 4)

    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Kamil Entsua-Mensah        19/06/2019      Created             ---
    ********************************************************************************/
    @IsTest private static void testGetPickListValuesByRecordType2() {
        Test.setMock(HttpCalloutMock.class, new DepHttpCalloutMock());

        String sObjectType = 'Account';
        String recordTypeId = '0121r000000nKeXAAU';
        String pickListValuesJSONString = '{"values":[{"attributes":null,"label":"Prospect","validFor":[],"value":"Prospect"},{"attributes":null,"label":"Customer - Direct","validFor":[],"value":"Customer - Direct"},{"attributes":null,"label":"Customer - Channel","validFor":[],"value":"Customer - Channel"},{"attributes":null,"label":"Channel Partner / Reseller","validFor":[],"value":"Channel Partner / Reseller"}]}';
        String field = 'Type';

        Profile p = [SELECT Id FROM profile WHERE name = 'Standard User'];
        User u = OB_TestDataFactory.getUser();
        u.ProfileId = p.Id;
        insert u;
        System.debug(u);

        Document doc = new Document();
        doc.Name = sObjectType + '_' + recordTypeId + '_' + field;
        doc.FolderId = u.Id;
        doc.Body = Blob.valueOf(pickListValuesJSONString);
        insert doc;

        System.debug(doc);
        Test.startTest();
        List<PicklistCmpCtrl.SelectOption> selectOptions = PicklistCmpCtrl.getPickListValuesByRecordType(sObjectType, recordTypeId, field);
        Test.stopTest();

        System.debug('testGetPickListValuesByRecordType2 List<PicklistCmpCtrl.SelectOption> ' + selectOptions);
        System.assertEquals(4, selectOptions.size());
    }

    /*******************************************************************************
    Purpose:  Method tests PicklistCmpCtrl setSelected setter,
    checks if the field is set correctly(expected value true)

    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Kamil Entsua-Mensah        19/06/2019      Created             ---
    ********************************************************************************/
    @isTest private static void testSetSelected() {
        PicklistCmpCtrl.SelectOption selectOption = new PicklistCmpCtrl.SelectOption('Prospect', 'Prospect', true);
        selectOption.setSelected(true);

        System.assertEquals(true, selectOption.selected);
    }

    /*******************************************************************************
    Purpose:  Class to mock http response status code 500

    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Kamil Entsua-Mensah        19/06/2019      Created             ---
    ********************************************************************************/
    global class DepHttpCalloutMockWith500Code implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');

            response.setBody('');
            response.setStatusCode(500);
            return response;
        }

    }
}