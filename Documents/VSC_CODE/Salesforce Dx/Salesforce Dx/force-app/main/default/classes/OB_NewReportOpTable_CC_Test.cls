@isTest
public with sharing class OB_NewReportOpTable_CC_Test {
    @isTest
    public static void getReportTest(){
        Test.startTest();
        Report rep = new Report();
        rep = OB_NewReportOpTable_CC.getReport('Test');
        Test.stopTest();
    }
    @isTest
    public static void getSessionIdTest(){
        Test.startTest();
        String str = '';
        str = OB_NewReportOpTable_CC.getSessionId();
        Test.stopTest();
    }
    @isTest
    public static void getFieldUserLoggedTest(){
        Test.startTest();
        Map<String,Object> us1 = new Map<String,Object>();

        us1 = OB_NewReportOpTable_CC.getFieldUserLogged();

        Test.stopTest();
    }
    /* simone.misani@accenture.com
15/04/2019 .*/

    /*******************************************************************************
   Purpose:  Method tests OB_NewReportOpTable_CC.getCurrentReport tested any report for this Setup, without this the class can't be covered
   Parameters: -
   Returns: -
   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0      Michał Targiel           19/06/2019        Created             ---
   ********************************************************************************/

    @isTest(SeeAllData=true)
    public static void getFilteredReportTest(){
        // simone Misani  modify this class for coverage the report.

        List <Report> reportList = [ SELECT Id
                                     FROM Report
                                     WHERE DeveloperName = 'Report_Order_Header_nLa'];

        String reportId = (String)reportList.get(0).get('Id');
        Reports.ReportMetadata reportMetadata =  Reports.ReportManager.describeReport(reportId).getReportMetadata();
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId);

        Test.startTest();
        //TEST CATCH EXCEPTION
        String listFilters = '[{"column":"NE__Order_Header__c.NE__BillAccId__c.Name","operator":"equals","value":""}]';
        System.debug(reportMetadata.getReportFilters());
        String result = OB_NewReportOpTable_CC.getFilteredReport(reportId,  listFilters);
        System.debug(result);
        Test.stopTest();
        //System.assert(result.equalsIgnoreCase('[The filter logic references an undefined filter.]'));


    }

    /*******************************************************************************
   Purpose:  Method tests OB_NewReportOpTable_CC.getCurrentReport tested concrete report Report_Order_Header_nLa without this the class can't be covered.
   Parameters: -
   Returns: -
   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0      Michał Targiel           19/06/2019        Created             ---
   ********************************************************************************/
    @isTest(SeeAllData=true)
    public static void getCurrentReport_test(){

        List <Report> reportList = [ SELECT Id
                                     FROM Report
                                     WHERE DeveloperName = 'Report_Order_Header_nLa'];

        Report contextreport = reportList.get(0);
        Map<String, String> expected = new Map<String, String>();
        expected.put('ABI','NE__Order_Header__c.OB_ABI__c');
        expected.put('CAB',null);

        Test.startTest();
        Map<String, String> result = OB_NewReportOpTable_CC.getCurrentReport(String.valueOf(contextreport.Id));

        System.debug(result);
        System.assert(result.size()>0);

        List<Report> reportList2 = [ SELECT Id
                                     FROM Report
                                     WHERE DeveloperName = 'Report_AnagraficaService_Point_HEr'];

        contextreport = reportList2.get(0);
        result = OB_NewReportOpTable_CC.getCurrentReport(String.valueOf(contextreport.Id));

        System.debug(result);
        Test.stopTest();
        System.assert(expected.equals(result));




    }
}