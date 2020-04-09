/*
Controller name class : OB_AnagraficaServicePointController
Doris Tatiana, 30/10/2018
*/

@isTest
public  class OB_AnagraficaServicePoint_Test {
	
    @isTest
	public static void  getretrieveMerchantTest() {

	String fiscalCode='';
	String vatCode='';
	
	Test.startTest();
	Object t = OB_AnagraficaServicePointController.getretrieveMerchant(fiscalCode,vatCode); //14/05/2019 EP changed signature
    Test.stopTest();
		
    }
}