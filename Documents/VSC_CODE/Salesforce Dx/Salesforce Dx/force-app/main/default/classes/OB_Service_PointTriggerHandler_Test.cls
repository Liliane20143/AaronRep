/*
CLASS NAME TO TEST : OB_Service_PointTriggerHandler
AUTHOR: DORIS TATIANA
DATE  : 10/11/2018
*/

@isTest
public class OB_Service_PointTriggerHandler_Test {  

	@isTest
	public static void setInvalidNameOnServicePointName_Test() {

		List<NE__Service_Point__c> servicePoints = new List<NE__Service_Point__c> ();
		List<NE__Service_Point__c> oldSPoints = new List<NE__Service_Point__c>();
		NE__Service_Point__c sp1 = new NE__Service_Point__c();
		NE__Service_Point__c sp2 = new NE__Service_Point__c(Name = 'çqwert',OB_Service_Point_Name__c= 'services Points',OB_BypassValidation__c = false);

		oldSPoints.add(sp1);
		insert oldSPoints;

		servicePoints.add(sp2);
		insert servicePoints;

		Test.startTest();
		OB_Service_PointTriggerHandler spH = new OB_Service_PointTriggerHandler();
		spH.setInvalidNameOnServicePointName(servicePoints, oldSPoints);
		Test.stopTest();
		
	}

	@isTest
	public static void setInvalidServicePointName_Test() {
	
		List<NE__Service_Point__c> servicePoints = new List<NE__Service_Point__c> ();
		List<NE__Service_Point__c> oldSPoints = new List<NE__Service_Point__c>();
		NE__Service_Point__c sp1 = new NE__Service_Point__c(Name = 'çqwert',OB_Service_Point_Name__c= 'servicesè*Points',OB_BypassValidation__c = false);
		NE__Service_Point__c sp2 = new NE__Service_Point__c();
		oldSPoints.add(sp2);
		insert oldSPoints;
		servicePoints.add(sp1);
		insert servicePoints;

		Test.startTest();
		OB_Service_PointTriggerHandler spH = new OB_Service_PointTriggerHandler();
		spH.setInvalidServicePointName(servicePoints, oldSPoints);
        sph.checkCoherencyWithSeasonalInput(servicePoints, oldSPoints);
		Test.stopTest();
        
	}
    
    @isTest
	public static void setcheckCoherencyWithSeasonalInput_Test() {
        
            NE__Service_Point__c sp1 = new NE__Service_Point__c(Name = 'puntovendita',OB_Service_Point_Name__c= 'puntovendita',OB_BypassValidation__c = false,OB_Start_Seasonal__c='01',OB_End_Seasonal__c='03');
			insert sp1;
            Test.startTest();
            sp1.OB_Start_Seasonal__c = '02';
            update sp1;
            Test.stopTest();
		
	}


}