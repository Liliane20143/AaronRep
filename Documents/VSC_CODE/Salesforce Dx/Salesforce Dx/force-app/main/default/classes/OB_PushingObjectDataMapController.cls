public class OB_PushingObjectDataMapController {

	@AuraEnabled
    public static String FindStaticResourceBody(String resourceName) {
        StaticResource staticResource = new StaticResource();
		
		if(Test.isRunningTest()){
			staticResource.Body = Blob.valueOf('my blob');
		} else
		{
			staticResource = [SELECT Body FROM StaticResource WHERE Name = :resourceName];
		}
		
		System.debug('@@@ My staticResourceBody is: ' + staticResource);
		/*14/05/2019 ENRICO PURIFICATO -- ADD TRY CATCH START*/
		String decodedStaticResource ;
		try{
			decodedStaticResource = staticResource.Body.toString();
		} catch(Exception e){
		    System.debug('The following exception has occurred: ' + e.getMessage());
		}
		/*14/05/2019 ENRICO PURIFICATO -- ADD TRY CATCH END*/
		System.debug('@@@ My decodedStaticResourceBody is: ' + decodedStaticResource);
		
		return decodedStaticResource;
    }
}