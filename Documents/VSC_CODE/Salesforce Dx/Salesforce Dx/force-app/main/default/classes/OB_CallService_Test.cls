/*
Andrea Morittu, 25/07/2018
*/
@isTest
public class OB_CallService_Test {

	@isTest
	static void getProvinceService() {
        Test.startTest(); 
        OB_CallService provinciaService = new OB_CallService();
        Map<String, String> resp = OB_CallService.getService('PROVINCIA', 'prova');

		Test.stopTest();
	}
	
	@isTest
	static void getMunicipalityService(){
     Test.startTest(); 
        OB_CallService comuneService = new OB_CallService();
        Map<String, String> resp = OB_CallService.getService('COMUNE', 'prova');

		Test.stopTest();
	}
	
	@isTest
	static void getStreetService(){
    Test.startTest(); 
        OB_CallService stradaService = new OB_CallService();
		Map<String, String> resp = OB_CallService.getService('STRADA', 'prova');

	Test.stopTest();
	}
	
	@isTest
	static void getNormService(){
	Test.startTest(); 
        OB_CallService normaService = new OB_CallService();
        Map<String, String> resp = OB_CallService.getService('NORMA', 'prova');

		Test.stopTest();
	}
	
	@isTest
	static void getDistrictService(){
	Test.startTest(); 
        OB_CallService frazioneService = new OB_CallService();
        Map<String, String> resp = OB_CallService.getService('FRAZIONE', 'prova');

		Test.stopTest();
	}
    
    @isTest
	static void getContinuationService(){
	Test.startTest(); 
        OB_CallService continuationService = new OB_CallService();
        Map<String, String> resp = OB_CallService.getService('CONTINUATION', 'prova');

		Test.stopTest();
	}
    
     @isTest
	static void getRetrieveMerchantService(){
	Test.startTest(); 
        OB_CallService continuationService = new OB_CallService();
        Map<String, String> resp = OB_CallService.getService('RETRIEVEMERCHANT', 'prova');

		Test.stopTest();
	}
    
     @isTest
	static void getRetrieveServicePointService(){
	Test.startTest(); 
        OB_CallService continuationService = new OB_CallService();
        Map<String, String> resp = OB_CallService.getService('RETRIEVESERVICEPOINT', 'prova');

		Test.stopTest();
	}
}