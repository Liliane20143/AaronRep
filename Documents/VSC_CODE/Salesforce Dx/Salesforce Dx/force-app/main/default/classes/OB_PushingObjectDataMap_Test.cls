@isTest
public  class OB_PushingObjectDataMap_Test {
	
	@isTest
	public static void FindStaticResourceBody_Test() {

		//StaticResource staticResource = new StaticResource();
		Test.startTest();			
		//staticResource = [SELECT Body,BodyLength,CreatedDate,Name FROM StaticResource WHERE BodyLength = 2 ORDER BY CreatedDate DESC NULLS FIRST LIMIT 1];		
		OB_PushingObjectDataMapController.FindStaticResourceBody('OB_ObjectDataMap_NULL') ;
		Test.stopTest();
		
	}
	
}