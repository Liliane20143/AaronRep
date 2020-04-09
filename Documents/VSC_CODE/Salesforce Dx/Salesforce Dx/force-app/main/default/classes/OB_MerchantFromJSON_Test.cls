@isTest
public class OB_MerchantFromJSON_Test {

	@isTest
	public static void parseTest(){

		String json = '{"pgId" : "425080", "fiscalCode" : "05218600962"}';
		Test.startTest();
		OB_MerchantFromJSON.parse(json);
		Test.stopTest();
	}

/*
	@isTest
	public static void cls_AdmistrativeAddressTest(){

		Test.startTest();
		OB_MerchantFromJSON.cls_AdmistrativeAddress address = new OB_MerchantFromJSON.cls_AdmistrativeAddress();
		OB_MerchantFromJSON instanceOfOB_MerchantFromJSON = new OB_MerchantFromJSON();
		OB_MerchantFromJSON.AdmistrativeAddress = address;
		Test.stopTest();
	}
	*/
}