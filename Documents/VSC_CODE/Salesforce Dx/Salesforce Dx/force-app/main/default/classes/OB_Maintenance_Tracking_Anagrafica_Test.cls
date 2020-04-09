@isTest
public class OB_Maintenance_Tracking_Anagrafica_Test 
{
    @isTest
    public static void trackAnagTest()
    {
        Account acc = OB_TestDataFactory.getAccount();
        insert acc;
        NE__Service_Point__c servicePoint = OB_TestDataFactory.getServicePoint();
        insert servicePoint;
        Map<String,String> changeMerchantNameMap = new Map<String,String>();
        Id rtAnagrafica = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ANAGRAFICART).getRecordTypeId(); 
        changeMerchantNameMap.put('OB_AccountId__c',acc.Id);
        changeMerchantNameMap.put('OB_ServicePointId__c',null);
        changeMerchantNameMap.put('OB_ChangeCompanyData__c','false');
        changeMerchantNameMap.put('OB_ChangeLegalForm__c','false');
        changeMerchantNameMap.put('OB_ChangeLegalRepresentative__c','false');
        changeMerchantNameMap.put('OB_ChangeMerchantName__c','true');
        changeMerchantNameMap.put('OB_ChangeServicePointData__c','false');
        changeMerchantNameMap.put('OB_NewLegalRepresentative__c','false');
        changeMerchantNameMap.put('OB_CAB__c','12345');
        changeMerchantNameMap.put('OB_ABI__c',acc.OB_ABI__c);
        changeMerchantNameMap.put('OB_MaintenanceType__c','Anagrafica');
        changeMerchantNameMap.put('OB_Status__c','Draft');
        changeMerchantNameMap.put('OB_SIAToBeApproved__c','false');
        changeMerchantNameMap.put('RecordTypeId',rtAnagrafica);
        changeMerchantNameMap.put('OB_ReducedNewData__c','{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mpvFPQAY"},"OB_Document_Number__c":"docNumb880","Id":"0039E00000mpvFPQAY"}]}');
        OB_LogRequest__c logRequest = OB_Utility.insertLogRequest(changeMerchantNameMap);
       	OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaRequest trackingRequest = new OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaRequest();
        OB_Maintenance_Tracking_Anagrafica.Details details = new OB_Maintenance_Tracking_Anagrafica.Details();
        details.termId                      = null;
        details.source                      = 'EQUENS';
        details.responseDescription         = 'SUCCESS';
        details.responseCode                = 'OK';
        details.PVcode                      = null;
        details.companyCode                 = 'CC123';
        details.code                        = '1234567890';
        trackingRequest.salesPointId        =  null;
        trackingRequest.responseDescription = null;
        trackingRequest.responseCode        = 'OK';
        trackingRequest.requestId           = logRequest.Id;
        trackingRequest.merchantId          = acc.Id;
        trackingRequest.bankAccountId       = null;
        trackingRequest.Details.add(details);

        Test.startTest();
		RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res = new RestResponse();
		RestContext.response = res;
		RestContext.request = req;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();

        trackingRequest.details.get(0).companyCode = null;
		RestRequest req2 = new RestRequest();
        req2.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res2 = new RestResponse();
		RestContext.response = res2;
		RestContext.request = req2;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();

        trackingRequest.details.get(0).responseCode = 'KO';
		RestRequest req3 = new RestRequest();
        req3.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res3 = new RestResponse();
		RestContext.response = res3;
		RestContext.request = req3;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();

        trackingRequest.responseCode = 'KO';
		RestRequest req4 = new RestRequest();
        req4.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res4 = new RestResponse();
		RestContext.response = res4;
		RestContext.request = req4;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();

        trackingRequest.requestId = null;
		RestRequest req5 = new RestRequest();
        req5.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res5 = new RestResponse();
		RestContext.response = res5;
		RestContext.request = req5;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();


        Test.stopTest();

    }

    @isTest
    public static void trackAnagTest2()
    {
        Account acc = OB_TestDataFactory.getAccount();
        insert acc;
        NE__Service_Point__c servicePoint = OB_TestDataFactory.getServicePoint();
        insert servicePoint;
        Map<String,String> changeMerchantNameMap = new Map<String,String>();
        Id rtAnagrafica = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ANAGRAFICART).getRecordTypeId();
        Map<String,String> modifyServicePointMap = new Map<String,String>();
        modifyServicePointMap.put('OB_AccountId__c',acc.Id);
        modifyServicePointMap.put('OB_ServicePointId__c',servicePoint.Id);
        modifyServicePointMap.put('OB_ChangeCompanyData__c','false');
        modifyServicePointMap.put('OB_ChangeLegalForm__c','false');
        modifyServicePointMap.put('OB_ChangeLegalRepresentative__c','false');
        modifyServicePointMap.put('OB_ChangeMerchantName__c','false');
        modifyServicePointMap.put('OB_ChangeServicePointData__c','true');
        modifyServicePointMap.put('OB_NewLegalRepresentative__c','false');
        modifyServicePointMap.put('OB_CAB__c','12345');
        modifyServicePointMap.put('OB_ABI__c',acc.OB_ABI__c);
        modifyServicePointMap.put('OB_MaintenanceType__c','Anagrafica');
        modifyServicePointMap.put('OB_Status__c','Draft');
        modifyServicePointMap.put('OB_SIAToBeApproved__c','false');
        modifyServicePointMap.put('RecordTypeId',rtAnagrafica);
        modifyServicePointMap.put('OB_ReducedNewData__c','{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mpvFPQAY"},"OB_Document_Number__c":"docNumb880","Id":"0039E00000mpvFPQAY"}]}');
        OB_LogRequest__c logRequest = OB_Utility.insertLogRequest(modifyServicePointMap);
      
       	OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaRequest trackingRequest = new OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaRequest();
        OB_Maintenance_Tracking_Anagrafica.Details details = new OB_Maintenance_Tracking_Anagrafica.Details();
        details.termId                      = null;
        details.source                      = 'EQUENS';
        details.responseDescription         = 'SUCCESS';
        details.responseCode                = 'OK';
        details.PVcode                      = 'PV123';
        details.companyCode                 = 'CC123';
        details.code                        = '1234567890';
        trackingRequest.salesPointId        = servicePoint.Id;
        trackingRequest.responseDescription = null;
        trackingRequest.responseCode        = 'OK';
        trackingRequest.requestId           = logRequest.Id;
        trackingRequest.merchantId          = acc.Id;
        trackingRequest.bankAccountId       = null;
        trackingRequest.Details.add(details);

        Test.startTest();
		RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res = new RestResponse();
		RestContext.response = res;
		RestContext.request = req;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();

        trackingRequest.details.get(0).companyCode = null;
		RestRequest req2 = new RestRequest();
        req2.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res2 = new RestResponse();
		RestContext.response = res2;
		RestContext.request = req2;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();

        trackingRequest.details.get(0).PVcode = null;
        trackingRequest.details.get(0).responseCode = 'KO';
		RestRequest req3 = new RestRequest();
        req3.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res3 = new RestResponse();
		RestContext.response = res3;
		RestContext.request = req3;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();

        trackingRequest.salesPointId = null;
		RestRequest req4 = new RestRequest();
        req4.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res4 = new RestResponse();
		RestContext.response = res4;
		RestContext.request = req4;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();
		Test.stopTest();
    }

    @isTest
    public static void trackAnagTest3()
    {
        Account acc = OB_TestDataFactory.getAccount();
        insert acc;
        Account bankAcc = OB_TestDataFactory.getAccount();
        Id recordTypeIdBank = Schema.SObjectType.Account.getRecordTypeInfosByName().get(OB_UtilityConstants.BANKRT).getRecordTypeId();
        bankAcc.RecordTypeId = recordTypeIdBank;
        insert bankAcc;
        NE__Service_Point__c servicePoint = OB_TestDataFactory.getServicePoint();
        insert servicePoint;
        Map<String,String> changeCoBaMap = new Map<String,String>();
        Id rtCoBa = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.CAMBIOCOBART).getRecordTypeId(); 
        changeCoBaMap.put('OB_AccountId__c',acc.Id);
        changeCoBaMap.put('OB_ServicePointId__c',null);
        changeCoBaMap.put('OB_ChangeCompanyData__c','false');
        changeCoBaMap.put('OB_ChangeLegalForm__c','false');
        changeCoBaMap.put('OB_ChangeLegalRepresentative__c','false');
        changeCoBaMap.put('OB_ChangeMerchantName__c','false');
        changeCoBaMap.put('OB_ChangeServicePointData__c','false');
        changeCoBaMap.put('OB_NewLegalRepresentative__c','false');
        changeCoBaMap.put('OB_CAB__c','12345');
        changeCoBaMap.put('OB_ABI__c',acc.OB_ABI__c);
        changeCoBaMap.put('OB_MaintenanceType__c','Cambio CoBa');
        changeCoBaMap.put('OB_Status__c','Draft');
        changeCoBaMap.put('OB_SIAToBeApproved__c','false');
        changeCoBaMap.put('OB_ReducedNewData__c','{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v46.0/sobjects/Contact/0039E00000mpvFPQAY"},"OB_Document_Number__c":"docNumb880","Id":"0039E00000mpvFPQAY"}]}');
        changeCoBaMap.put('RecordTypeId',rtCoBa);
        OB_LogRequest__c logRequest = OB_Utility.insertLogRequest(changeCoBaMap);
       	OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaRequest trackingRequest = new OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaRequest();
        OB_Maintenance_Tracking_Anagrafica.Details details = new OB_Maintenance_Tracking_Anagrafica.Details();
        details.termId                      = '12345678';
        details.source                      = 'EQUENS';
        details.responseDescription         = 'SUCCESS';
        details.responseCode                = 'OK';
        details.PVcode                      = null;
        details.companyCode                 = 'CC123';
        details.code                        = '1234567890';
        trackingRequest.salesPointId        = null;
        trackingRequest.responseDescription = null;
        trackingRequest.responseCode        = 'OK';
        trackingRequest.requestId           = logRequest.Id;
        trackingRequest.merchantId          = acc.Id;
        trackingRequest.bankAccountId       = bankAcc.Id;
        trackingRequest.Details.add(details);

        Test.startTest();
		RestRequest req = new RestRequest();
         req.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res = new RestResponse();
		RestContext.response = res;
		RestContext.request = req;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();

        trackingRequest.bankAccountId = null;
		RestRequest req2 = new RestRequest();
        req2.requestBody = Blob.valueOf(JSON.serialize(trackingRequest));
    	RestResponse res2 = new RestResponse();
		RestContext.response = res2;
		RestContext.request = req2;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();

        RestRequest req3 = new RestRequest();
        req2.requestBody = null;
    	RestResponse res3 = new RestResponse();
		RestContext.response = res3;
		RestContext.request = req3;
		OB_Maintenance_Tracking_Anagrafica.trackAnag();

        //<daniele.gandini@ccenture.com> F2Wave-107--BIS - 15/07/2019 - start
        OB_Maintenance_Tracking_Anagrafica.getTrackingAnagrafica(null);
        //<daniele.gandini@ccenture.com> F2Wave-107--BIS - 15/07/2019 - stop
    
        Test.stopTest();
    }

    @isTest
    public static void updateLogRequest_Test(){

        OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
        insert log;
       OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaRequest trackingRequest = new OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaRequest();
        OB_Maintenance_Tracking_Anagrafica.Details details = new OB_Maintenance_Tracking_Anagrafica.Details();
        details.termId                      = '12345678';
        details.source                      = 'EQUENS';
        details.responseDescription         = 'SUCCESS';
        details.responseCode                = 'OK';
        details.PVcode                      = null;
        details.companyCode                 = 'CC123';
        details.code                        = '1234567890';
        trackingRequest.Details.add(details);
        Test.startTest();
        OB_Maintenance_Tracking_Anagrafica.updateLogRequest(trackingRequest.Details,log);
        Test.stopTest();

    }
}