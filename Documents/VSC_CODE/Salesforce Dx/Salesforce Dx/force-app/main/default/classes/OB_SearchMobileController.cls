/*******************************************************************************
Purpose:  ?

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Andrea Morittu          ?               Created         Search a contact by his mobile phone.
1.1         Zuzanna Urban       31/05/2019          NEXI-102        Add OB_Service_Point__c =: servicePointId
********************************************************************************/
public class OB_SearchMobileController 
{  
    @AuraEnabled
    public static List<Contact> serverFilterByContactPhone(String inputCel, String merchantId, String bankId, String servicePointId, String RTDeveloperName)
    {
		
		List<Contact> cntsList = new List<Contact>();
        if (!String.isEmpty(inputCel))
        {
	        String inputCelWithoutPrefix =  inputCel.trim();
	        String inputCelWithLongPrefix = '0039'+inputCelWithoutPrefix;
	        String inputCelWithShortPrefix = '+39'+inputCelWithoutPrefix;
	        System.debug( LoggingLevel.INFO, '@@@@@@@ THE QUERY IS: SELECT Id, FirstName, LastName, Email, MobilePhone From Contact WHERE MobilePhone =:'+inputCelWithoutPrefix +' AND AccountId = :'+merchantId+' AND OB_Bank__c = :'+ bankId +' AND ServicePointId = :'+ servicePointId + ' AND RecordType.DeveloperName= :'+RTDeveloperName+' limit 1' );
	        
	        
	        cntsList = [SELECT Id, FirstName, LastName, Email, MobilePhone, RecordTypeId, RecordType.DeveloperName, OB_Bank__c
	                   FROM Contact
	                   WHERE (	  MobilePhone =: inputCelWithoutPrefix 
	                           OR MobilePhone =: inputCelWithLongPrefix
	                           OR MobilePhone =: inputCelWithShortPrefix
	                           )
	                   AND AccountId =:merchantId
	                   AND OB_Bank__c =:bankId
	                   AND RecordType.DeveloperName=:RTDeveloperName
                       AND OB_Service_Point__c =: servicePointId
	                   LIMIT 1
	                  ];
        }
       	return cntsList.size()>0?cntsList:null;
      }	
}