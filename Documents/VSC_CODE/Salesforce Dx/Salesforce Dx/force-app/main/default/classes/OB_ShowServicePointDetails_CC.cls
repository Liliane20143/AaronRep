public without sharing class OB_ShowServicePointDetails_CC {
	
	/*
	*	Author		:		Morittu Andrea
	*	Date		:		21-Oct-2019
	*	Task		:		Show Service Point Details
	*	Description	:		Wrapper class containing main data 
	*/
    @TestVisible
	public class servicePointDetailWrapper {
		@AuraEnabled public String bankABI 						    {get;set;}
		@AuraEnabled public NE__Service_Point__c mainServicePoint 	{get;set;}
		@AuraEnabled public List<Contact> mainServicePointReferent 	{get;set;}
		@AuraEnabled public List<Contact> technicalReferent 				{get;set;}
		@AuraEnabled public List<Contact> administrativeResponsible 		{get;set;}
		
		public servicePointDetailWrapper() {
			mainServicePoint 			= new NE__Service_Point__c();
			mainServicePointReferent	= new List<Contact>();
			technicalReferent			= new List<Contact>();
			administrativeResponsible	= new List<Contact>();
		}
	}
	
	/*
	*	Author		:		Morittu Andrea
	*	Date		:		21-Oct-2019
	*	Task		:		Show Service Point Details
	*	Description	:		method to retrieve main SP data
	*/
	@AuraEnabled
    public static servicePointDetailWrapper getServicePointInfo_Server(String orderHeaderId ) {
		servicePointDetailWrapper mainWrapperClass = new servicePointDetailWrapper();
		String query = '';
		List<NE__Order__c > ordersRelated = new List<NE__Order__c >();
		NE__Order__c orderRelated = new NE__Order__c();
		
		try {
			if(!String.isBlank(orderHeaderId)) {
				try {
					Id orderHeaderIdParsed = (Id) orderHeaderId;
				} catch (SecurityException secException) {
					System.debug('An error has occured inside getServicePointInfo_Server : ' + secException.getMessage() + ' - ' + secException.getCause() + ' - ' + 'SOQL INJECTION');
				} finally {
					/* PRIMARY OBJECT TARGET */

					query =  ' SELECT Id, '
                            + ' NE__BillingProfId__c, NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c, '
                            /*-------------------- MAIN SP FIELDS --------------------*/
                            + ' OB_Service_Point__r.Name, OB_Service_Point__r.OB_Typology__c, OB_Service_Point__r.OB_Mobile_Phone_Number__c,'
                            + ' OB_Service_Point__r.OB_Phone_Number__c, OB_Service_Point__r.OB_Email__c, '
							/*-------------------- SP ADDRESS FIELDS --------------------*/
							+ ' OB_Service_Point__r.NE__Country__c, '
							+ ' OB_Service_Point__r.NE__City__c, '
							+ ' OB_Service_Point__r.NE__Zip_Code__c, '
							+ ' OB_Service_Point__r.NE__Street__c, '
							+ ' OB_Service_Point__r.OB_Street_Number__c, '
							+ ' OB_Service_Point__r.OB_Address_Detail__c, '
							+ ' OB_Service_Point__r.OB_District__c, '
							+ ' OB_Service_Point__r.NE__Province__c, '
							/* -------------------- SP TIME FIELDS -------------------- */
							+ ' OB_Service_Point__r.OB_Opening_Sunday_Morning__c, 		OB_Service_Point__r.OB_Opening_Sunday_Afternoon__c,  	'
							+ ' OB_Service_Point__r.OB_Start_Seasonal__c, 				OB_Service_Point__r.OB_End_Seasonal__c, 				'
							+ ' OB_Service_Point__r.OB_Opening_Monday_Morning__c, 		OB_Service_Point__r.OB_Opening_Monday_Afternoon__c, 	'
							+ ' OB_Service_Point__r.OB_Opening_Tuesday_Morning__c, 		OB_Service_Point__r.OB_Opening_Tuesday_Afternoon__c, 	'
							+ ' OB_Service_Point__r.OB_Opening_Wednesday_Morning__c, 	OB_Service_Point__r.OB_Opening_Wednesday_Afternoon__c, 	'
							+ ' OB_Service_Point__r.OB_Opening_Thursday_Morning__c, 	OB_Service_Point__r.OB_Opening_Thursday_Afternoon__c, 	'
							+ ' OB_Service_Point__r.OB_Opening_Friday_Morning__c, 		OB_Service_Point__r.OB_Opening_Friday_Afternoon__c, 	'
							+ ' OB_Service_Point__r.OB_Opening_Saturday_Morning__c, 	OB_Service_Point__r.OB_Opening_Saturday_Afternoon__c, 	'
							+ ' OB_Service_Point__r.OB_Break_Start_Time__c, 			OB_Service_Point__r.OB_Break_End_Time__c, 				'
							+ ' OB_Service_Point__r.OB_Opening_Time__c, 				OB_Service_Point__r.OB_Ending_Time__c					'
							+ ' FROM NE__Order__c '
							+ ' WHERE NE__Order_Header__c =: orderHeaderIdParsed ';

					System.debug('query in getServicePointInfo_Server is: ' + query );
					ordersRelated = (List<NE__Order__c>) Database.query(query);
					
					if(!ordersRelated.isEmpty() ) {
						orderRelated = ordersRelated.get(0);
						mainWrapperClass.bankABI = orderRelated.NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c;
						
						NE__Service_Point__c mainServicePoint = (NE__Service_Point__c) orderRelated.OB_Service_Point__r;
						if(mainServicePoint != null) {
							mainWrapperClass.mainServicePoint = mainServicePoint;
							contactsRelatedToServicePointAndBank(mainWrapperClass);
						} else {
							throw new OB_Utility.applicationException('There is no service point related to this offer. Please, check if the record is coherent :  ');
						}
					} else {
						throw new OB_Utility.applicationException('There isn\'t any configuration related to this orderHeader : ' + orderHeaderId);
					}
				}
			}
		} catch(OB_Utility.applicationException exc) {
			System.debug('An error has occured inside getServicePointInfo_Server : ' + exc.getMessage() + ' - ' + exc.getCause() + ' - at line : ' + exc.getLineNumber() );
		}
        return mainWrapperClass;
	}
	
	/*
	*	Author		:		Morittu Andrea
	*	Date		:		21-Oct-2019
	*	Task		:		Show Service Point Details
	*	Description	:		method to retrieve main Cotnacts data
	*/
    @TestVisible
	private static void contactsRelatedToServicePointAndBank(servicePointDetailWrapper wrapper) {
		List<Contact> contactsFound = new List<Contact>();
        System.debug('wrapper inside contact query is : ' + wrapper);
        System.debug('wrapper inside contact query is : ' + wrapper.mainServicePoint.Id);
		String query = '';
		try {
					/*-------------------- MAIN FIELDS --------------------*/ 
                    




			query 	= ' SELECT Id, FirstName, LastName, MobilePhone, Phone, '
					+ ' Email, OB_Bank__r.OB_ABI__c, Name, OB_Service_Point__c, RecordTypeId, RecordType.DeveloperName, CreatedDate, OB_Contact_State__c '
					+ ' FROM Contact '
					+ ' WHERE OB_Service_Point__c       = \''+ wrapper.mainServicePoint.Id  +'\''
					+ ' AND OB_Bank__r.OB_ABI__c        = \''+  wrapper.bankABI +'\''
					+ ' AND OB_Contact_State__c         = \'' + OB_UtilityConstants.STATUS_ACTIVE + '\''
					+ ' AND ( ' 
					+ '		RecordType.DeveloperName    = \'' + OB_UtilityConstants.Referente_Punto_Vendita + '\''
					+ '		OR '
					+ ' 	RecordType.DeveloperName    = \'' + OB_UtilityConstants.Responsabile_Amministrativo + '\''
					+ '		OR '
					+ ' 	RecordType.DeveloperName    = \'' + OB_UtilityConstants.Referente_Tecnico + '\''
					+ ')'
					+ ' ORDER BY CreatedDate ';
			System.debug('query in contact is: ' + query );
			contactsFound = Database.query(query);
			if( !contactsFound.isEmpty() ) {
				for(Integer i = 0; i < contactsFound.size() ; i++ ) {
					if(contactsFound[i].RecordType.DeveloperName.equalsIgnoreCase(OB_UtilityConstants.Referente_Punto_Vendita)) {
                        // A CONTACT MUST HAVE MAX THREE SERVICE POINT REFERENTS
                        if(i < 3) {
                            wrapper.mainServicePointReferent.add(contactsFound[i]);
                        }
					}
					else if(contactsFound[i].RecordType.DeveloperName.equalsIgnoreCase(OB_UtilityConstants.Referente_Tecnico)) {
						wrapper.technicalReferent.add(contactsFound[i]);
					}
					else if(contactsFound[i].RecordType.DeveloperName.equalsIgnoreCase(OB_UtilityConstants.Responsabile_Amministrativo)) {
						wrapper.administrativeResponsible.add(contactsFound[i]);
					}
				}
			}
			if(wrapper.mainServicePointReferent == null)  {
				throw new OB_Utility.applicationException('There is no service point referent. This is not possible ');
			}
		} catch(Exception exc) {
			System.debug('An error has occured inside contactsRelatedToServicePointAndBank : ' + exc.getMessage());
		}
	}
}