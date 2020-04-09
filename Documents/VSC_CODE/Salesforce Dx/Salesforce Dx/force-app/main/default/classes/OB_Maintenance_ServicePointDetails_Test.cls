@isTest
public class OB_Maintenance_ServicePointDetails_Test 
{
	@isTest
	public static void getServicePointDetailsTest()
	{
		NE__Service_Point__c sp = new NE__Service_Point__c();
		insert sp; 
		OB_LogRequest__c lr = new OB_LogRequest__c(OB_ServicePointId__c = sp.id);
		insert lr;
		String logRequestId = lr.id; 
		Test.startTest();
		OB_Maintenance_ServicePointDetails_CC.getServicePointDetails(logRequestId);
		OB_Maintenance_ServicePointDetails_CC.getServicePointDetails('123');
		Test.stopTest();	
	}
}