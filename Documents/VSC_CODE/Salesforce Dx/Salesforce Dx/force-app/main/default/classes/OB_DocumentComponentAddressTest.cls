/*
Controller name class : OB_DocumentComponentAddressController
Doris Tatiana, 30/10/2018
*/

@isTest
public  class OB_DocumentComponentAddressTest {

	@isTest
	static void  getDocTypeValuesTest() {

		Map<String,String> pickListValuesList= new Map<String,String>();
		Contact cont = new Contact();
		
		Test.startTest();
        OB_DocumentComponentAddressController.getDocTypeValues();
        Test.stopTest();
		
	}


	@isTest
	static void  getDocAuthValuesTest() {

		Map<String,String> pickListValuesList= new Map<String,String>();
		Contact cont = new Contact();
		
		Test.startTest();
        OB_DocumentComponentAddressController.getDocAuthValues();
        Test.stopTest();
		
	}
}