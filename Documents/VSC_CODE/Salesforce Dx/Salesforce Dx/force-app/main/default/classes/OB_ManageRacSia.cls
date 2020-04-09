/*------------------------------------------------------------
Author:         Andrea Saracini
Company:        Accenture Tecnology
Description:    Cmp controller. Call checkRacSiaAttributes controller to check RAC SIA code 
Inputs:
Test Class:     OB_ManageRacSia_Test
History:
<Date>          <Authors Name>      <Brief Description of Change>
2019-03-13      Andrea Saracini     Creator
------------------------------------------------------------*/
public with sharing class OB_ManageRacSia {
    @AuraEnabled
	/*------------------------------------------------------------
	Author:         Andrea Saracini
	Company:        Accenture Tecnology
	Description:    Cmp controller. Call checkRacSiaAttributes controller to check RAC SIA code 
	Inputs:  		String objectDataString, String sia, String inputSiaValuesMap, String itemsToUpdate, String isReset
	Output:			Boolean
	History:
	<Date>          <Authors Name>      <Brief Description of Change>
	2019-03-13      Andrea Saracini     Creator
	------------------------------------------------------------*/
	public static Boolean setAttributeRacSiaOnTerminal(String objectDataString, String sia, String inputSiaValuesMap, String itemsToUpdate, String isReset){
		OB_CheckRacSiaAttributes checkSia = new OB_CheckRacSiaAttributes(); 
		System.debug(LoggingLevel.INFO, '### isReset: '+isReset);
		Boolean reset = 'true'.equals(isReset) ? true : false;
		Boolean siaIsValid = checkSia.checkRacSiaAttributes(objectDataString, sia, inputSiaValuesMap, itemsToUpdate, reset);
		System.debug(LoggingLevel.INFO, '### siaIsValid: '+siaIsValid);
		return siaIsValid;
	}

	//D.F. 18-03-2019 check if sia is in use by other merchant - START 
	@AuraEnabled
	public static Boolean checkSiaInUseOtherMerchant(String objectDataString, String sia){
		OB_CheckRacSiaAttributes checkSia = new OB_CheckRacSiaAttributes(); 
		Boolean siaIsValid = checkSia.checkSiaInUse(objectDataString, sia);
		System.debug(LoggingLevel.INFO, '### siaIsValid: '+siaIsValid);
		return siaIsValid;
	}
	
	@AuraEnabled
	public static List<String> checkSiaCodeOnIbanInsert(String objectDataString){
		OB_CheckRacSiaAttributes checkSia = new OB_CheckRacSiaAttributes(); 
		List<String> racSiaList = checkSia.checkSiaCodeByCoba(objectDataString);
		return racSiaList;
	}
	//D.F. END

}