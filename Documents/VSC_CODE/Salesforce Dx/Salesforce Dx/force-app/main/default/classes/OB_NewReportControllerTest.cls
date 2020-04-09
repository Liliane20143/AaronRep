@isTest
public class OB_NewReportControllerTest {
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
	//	Report report = [SELECT Name, Id FROM Report LIMIT 1];
 //       Report retrievedReport = OB_NewReportController.getReport(report.Name);
 //       System.assertEquals(report, retrievedReport);
	//}
    
    @isTest
	public static void getSessionId(){
		
        String sessionId = OB_NewReportController.getSessionId();
        
        System.assertNotEquals(sessionId, '');
	}
    
    @isTest
	public static void getFieldUserLoggedTest(){
        String userId = UserInfo.getUserId();
        String columns = 'Contact.Account.OB_ABI__c';
		String query = 'select '+columns+' from User where id =\'' + userId+ '\' LIMIT 1';
        User currentUser = Database.query(query);
        User retrievedUser = OB_NewReportController.getFieldUserLogged(columns);
        System.assertEquals(currentUser, retrievedUser);
	}
}