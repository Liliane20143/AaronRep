public without sharing class TitolareEffettivoSectionController {
	@AuraEnabled
	public static List<Contact> getAllTitolariEffettivi(String accId) {

		//List<Contact> contacts = [SELECT Id, AccountId, Name, Role__c FROM Contact WHERE AccountId =:accId AND Role__c = 'Titolare Effettivo'];
		// micol.ferrari 10/09/2018 - Deleting Role__c filter on record type
		List<Contact> contacts = [ SELECT Id, AccountId, Name, RecordType.DeveloperName FROM Contact WHERE AccountId =:accId AND RecordType.DeveloperName = 'Titolare_Effettivo' ];
		
		System.debug('total titolari effettivi: ' + contacts);
		return contacts;
		
	}    


	@AuraEnabled
	public static List<Contact> insertTitolareEffettivo(List<String> contacts) {
		List<Contact> contactList = new List<Contact>();
	   // ContactDTO c1 = new ContactDTO();
	   Contact  c = new Contact();
	   for(String contact : contacts){
		   // c1 = (ContactDTO)JSON.deserialize(contact, ContactDTO.class);
		   c = (Contact)JSON.deserialize(contact, Contact.class);
		   if(c.FirstName != '' &&  c.LastName != ''){
		   	contactList.add(c);
		   }
		}
		try {
			upsert contactList;
			} catch (DmlException e) {
				e.getStackTraceString();
			}
			return contactList;
		}


		@AuraEnabled
		public static Map<String, String> validationCheck(String contactString, String lastIndex, Map<String, Object> data){
			system.debug('contactVal'+contactString);
			Map<String, String> mapFinal = new Map<String, String>();
			try{
				Object errorEEMapObject = data.get('errorEEMap');
				system.debug('errorEEMapObject::'+errorEEMapObject);
				Map<String,Object> mappaErrorEE = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(errorEEMapObject));
				Contact con = (Contact)JSON.deserialize(contactString, Contact.class);
				mapFinal = OB_FlowControlUtility.checkMandatoryValCheckCont(con, lastIndex, mappaErrorEE);
				} catch(Exception ecc){
					System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
				}
				system.debug(mapFinal);
				return mapFinal;
			} 

		/*******************************************************************************
		Purpose:  Method to retrieve all 'titolari effettivi' from server for current merchant and current ABI

		History
		--------
		VERSION     AUTHOR                  DATE            DETAIL          Description
		1.0         gianluigi.virga       	02/09/2019      Created         
		********************************************************************************/
		@AuraEnabled
		public static List<Contact> retrieveTitolariEffettiviFromServer(String accId, String ABI) {
			List<Contact> contacts = [SELECT AccountId,
										FirstName,
										Id,
										LastName,
										OB_Address_City__c,
										OB_Address_Country_Code__c,
										OB_Address_Country__c,
										OB_Address_PostalCode__c,
										OB_Address_State_Code__c,
										OB_Address_State__c,
										OB_Address_Street_Number__c,
										OB_Address_Street__c,
										OB_Bank__c,
										OB_Birth_City__c,
										OB_Birth_Date__c,
										OB_Birth_State_Code__c,
										OB_Birth_State__c,
										OB_Cadastral_Code__c,
										OB_Citizenship__c,
										OB_Contact_State__c,
										OB_Country_Birth__c,
										OB_Document_Expiration_Date__c,
										OB_Document_Number__c,
										OB_Document_Release_Authority__c,
										OB_Document_Release_City__c,
										OB_Document_Release_Country_Code__c,
										OB_Document_Release_Country__c,
										OB_Document_Release_Date__c,
										OB_Document_Release_State_Code__c,
										OB_Document_Release_State__c,
										OB_Document_Type__c,
										OB_Fiscal_Code__c,
										OB_PEP__c,
										OB_Sex__c,
										RecordTypeId,
										OB_Country_Birth_Code__c
										FROM Contact 
										WHERE AccountId =:accId 
										AND OB_Bank__r.OB_ABI__c =:ABI 
										AND RecordType.DeveloperName = 'Titolare_Effettivo' 
										AND OB_Contact_State__c = 'Active'];
			System.debug('All titolari effettivi for current merchant and current ABI: ' + contacts);
			return contacts;
		}    

}