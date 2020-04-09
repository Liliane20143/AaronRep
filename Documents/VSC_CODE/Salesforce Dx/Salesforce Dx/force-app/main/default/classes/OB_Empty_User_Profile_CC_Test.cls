/*
Controller class name : OB_Empty_User_Profile_CC
Enrico Purificato , 11/07/2019 
copy of original test class OB_Empty_User_Profile_test
*/
@isTest
public with sharing class OB_Empty_User_Profile_CC_Test {
@isTest
	public static void retrieveStaticImg_test() {

		String userId = UserInfo.getUserId();
		List<User> listOfUser = new List<User> ();

		Test.startTest();
		OB_Empty_User_Profile_CC.retrieveStaticImg();
		Test.stopTest();

		
	}
	@isTest
	public static void getVFBaseURLServer_Test(){
		User user = new User();
		
		OB_Integration_Configuration__c intConfig = new OB_Integration_Configuration__c();
		intConfig.Name            = 'DEV1';
		intConfig.OB_Token_1__c   = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
		intConfig.OB_Timestamp__c = '1542025783107';
		intConfig.OB_Domain__c ='dev1';
		insert intConfig;
		
		 

		

	Test.startTest();
	OB_Empty_User_Profile_CC.getVFBaseURLServer();
	Test.stopTest();

	} 
}