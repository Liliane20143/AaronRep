public with sharing class OB_AnagraficaServicePointController {
   
//    @AuraEnabled
//    public static NE__Service_Point__C getServicePointById(String idServicePoint){
//        return  [select id, Name, OB_MCC__c
//                    from NE__Service_Point__C
//                    where Id =: idServicePoint  
//                    limit 1];
//    }

//    @AuraEnabled
//    public static NE__Service_Point__C updateServicePoint(String idServicePoint){ 
//        NE__Service_Point__C servicePointLocal = OB_AnagraficaServicePointController.getServicePointById(idServicePoint);
//        String servicePointService = (String)OB_ContinuationController.invoke('retriveServicePoint', new List<String>{'RSSNDR80A01F205O'});
//        List<NE__Service_Point__C> servicePointsFromService = (List<NE__Service_Point__C>) System.JSON.deserialize(servicePointService, List<NE__Service_Point__C>.class);
//        //accLocal.NE__Name__c = accountsFromService[0].merchantName == '' ? accLocal.NE__Name__c : accountsFromService[0].merchantName;
//        //accLocal.OB_ATECO__c = accountsFromService[0].atecoCode == '' ? accLocal.OB_ATECO__c : accountsFromService[0].atecoCode;
//        servicePointLocal.Name = String.isBlank(servicePointsFromService[0].Name) ? servicePointLocal.Name : servicePointsFromService[0].Name;
//        servicePointLocal.OB_MCC__c =  String.isBlank(servicePointsFromService[0].OB_MCC__c) ? servicePointLocal.Name : servicePointsFromService[0].Name;

       
//        try{
//            update(servicePointLocal);
//            return servicePointLocal;
//        }catch(Exception ex){
//            throw new AuraHandledException('Error query Update From Service Merchant');
//        }
//    }


/********************************** START Antonio Vatrano  18-12-18 **********************/

	@AuraEnabled
    public static Object getretrieveMerchant(String fiscalCode, String vatCode)
    {
    	Object res;
    	try
    	{
	        res = OB_RetrieveAnagraficaMerchantController.retrieveMerchantNew(fiscalCode, vatCode);
        }
        catch(Exception ecc){
            System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
        System.debug('*****RES: '+res);
	    return res;
    }

}
/********************************** END Antonio Vatrano  18-12-18 **********************/