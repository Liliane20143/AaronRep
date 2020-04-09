@isTest
public class TitolareEffettivoSectionController_Test {
    @isTest
    static void getAllTitolariEffettiviTest(){
        List<Contact> contacts = new List<Contact>();
        Account acc = new Account();
        String accId = acc.id;
        Test.startTest();
            TitolareEffettivoSectionController.getAllTitolariEffettivi(accId);
        Test.stopTest();
    }
    
    @isTest
    static void insertTitolareEffettivoTest(){
        Test.startTest();
            List<Contact> contactList = new List<Contact>();
            Contact ctc = new Contact();
            ctc.LastName = 'test';
            ctc.FirstName = 'Class';
            List<String> contactListString = new List<String>{JSON.serialize(ctc)};
            TitolareEffettivoSectionController.insertTitolareEffettivo(contactListString);
        Test.stopTest();
    }
    
    @isTest
    	static void insertTitolareEffettivoExcTest(){
        Test.startTest();
        List<String> contactListString = new List<String>{JSON.serialize(new Contact())};
        List<Contact> outputList = TitolareEffettivoSectionController.insertTitolareEffettivo(contactListString);
        Test.stopTest();
    }
    
    @isTest
    	static void validationCheck_test(){
        String contactString;
        String lastIndex;
        Map<String, Object> data = new Map<String, Object>();
            
		Test.startTest();
            TitolareEffettivoSectionController.validationCheck(contactString, lastIndex, data);
        Test.stopTest();
    }      

    /*******************************************************************************
		Purpose:  Method to test retrieveTitolariEffettiviFromServer

		History
		--------
		VERSION     AUTHOR                  DATE            DETAIL          Description
		1.0         gianluigi.virga       	03/09/2019      Created         
	********************************************************************************/
    @isTest
    	static void retrieveTitolariEffettiviFromServer_test(){
        Account acc = new Account();
        String accId = acc.id;
        String ABI = '03138';
            
		Test.startTest();
        TitolareEffettivoSectionController.retrieveTitolariEffettiviFromServer(accId, ABI);
        Test.stopTest();
    }        
}