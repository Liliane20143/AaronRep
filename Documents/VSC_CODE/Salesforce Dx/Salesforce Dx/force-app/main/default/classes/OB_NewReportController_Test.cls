@isTest
public class OB_NewReportController_Test {
    /*
    public static List<NE__Lov__c> createLovs(Integer numLovs, String abi) {
        List<NE__Lov__c> lovs = new List<NE__Lov__c>();
        
        for(Integer i=0;i<numLovs;i++) {
            NE__Lov__c lov = new NE__Lov__c(Name='TestLov' + i, NE__Value1__c='Value1' + i, NE__Value2__c=abi, NE__Value3__c='Categoria' + i, NE__Type__c = 'LinkReference', NE__Sub_Type__c = 'TIPOLOGICHE');
            lovs.add(lov);
        }
        insert lovs;
        return lovs;
    }
    */
    
 //   @isTest(SeeAllData=true)
    //public static void getReportTest(){
    //  Report report = [SELECT Name, Id FROM Report LIMIT 1];
 //       Report retrievedReport = OB_NewReportController.getReport(report.Name);
 //       System.assertEquals(report, retrievedReport);
    //}

    //@isTest
    //public static void getReportTest()
    //{
    //    String reportName = '';
    //    Test.startTest();
    //    OB_NewReportController.getReport(reportName);
    //    Test.stopTest();
    //}

    @isTest
    public static void getSessionIdTest()
    {
        Test.startTest();
        OB_NewReportController.getSessionId();
        Test.stopTest();
    }
    
    @isTest
    public static void getFieldUserLoggedTest()
    {
        String userId       = UserInfo.getUserId();
        String columns      = 'Contact.Account.OB_ABI__c';
        String columns2     = 'OB_Test__c';
        String columns3     = '';
        //String query        = 'SELECT '+columns+ ' FROM User WHERE id =\'' + userId+ '\' LIMIT 1';
        //String query2       = 'SELECT '+columns2+' FROM User WHERE id =\'' + userId+ '\' LIMIT 1';
        //User currentUser    = Database.query(query);
        //User currentUser2   = Database.query(query2);
        //User retrievedUser  = OB_NewReportController.getFieldUserLogged(columns );
        //User retrievedUser2 = OB_NewReportController.getFieldUserLogged(columns2);
        //System.assertEquals(currentUser , retrievedUser );
        //System.assertEquals(currentUser2, retrievedUser2);

        Test.startTest();
        OB_NewReportController.getFieldUserLogged(columns);
        OB_NewReportController.getFieldUserLogged(columns2);
        OB_NewReportController.getFieldUserLogged(columns3);
        Test.stopTest();
    }
}