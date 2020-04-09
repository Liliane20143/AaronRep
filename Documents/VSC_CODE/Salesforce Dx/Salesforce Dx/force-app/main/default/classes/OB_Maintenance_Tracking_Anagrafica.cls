/*****************************************************************
Name: OB_Maintenance_Tracking_Anagrafica()
============================================================
Purpose: Method to call to get the Tracking of Maintenance Anagrafica informations
============================================================ 
History 
-------
VERSION  AUTHOR 			DATE 		DETAIL 		Description 
1.0 	 Salvatore Pianura 	29/04/2019 	Created 	CSR: 
*****************************************************************/
@RestResource(urlMapping='/TrackingAnagrafica/*')
global without sharing class OB_Maintenance_Tracking_Anagrafica
{
	public final static String OK 				= 'OK';
	public final static String KO 				= 'KO';
	public final static String NOBODYREQUEST 	= 'OB_Maintenance_Tracking_Anagrafica - There are no body for the request ';
	public final static String NOREQUESTID		= 'There are no request id ';
	public final static String NODETAILSSOURCE 	= 'There are no source in one of details ';
	public final static String NOMERCHANTID 	= 'Mandatory field is empty - merchantId';
	public final static String NOSERVICEPOINTID = 'Mandatory field is empty - salesPointId';
	public final static String NOBANKACCOUNTID 	= 'Mandatory field is empty - bankAccountId';
	public final static String NOTERMID 		= 'Mandatory field is empty - termId';
	public final static String NOCOMPANYCODE 	= 'Mandatory field is empty - companyCode';
	public final static String NOPVCODE			= 'Mandatory field is empty - PVcode';
	public final static String MONETICA 		= 'MONETICA';
	public final static String SIA 				= 'SIA';
	public final static String EQUENS			= 'EQUENS';

	@HttpPost
	global static OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaResponse trackAnag()
	{
		RestResponse res = RestContext.response;
		OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaResponse response = new OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaResponse();
		Plc_LogHelper.LogStructure ls = new Plc_LogHelper.LogStructure();
		String logRequestId; //francesca.ribezzi 26/09/19 - F2WAVE2-189 - adding logRequestId
		try
		{
			if(RestContext.request.requestBody==null)
			{
				throw new applicationException(NOBODYREQUEST);
			}
			String req 	= RestContext.request.requestBody.toString();
			TrackingAnagraficaRequest request 	= (OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaRequest)JSON.deserialize(req,OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaRequest.class);
			response = getTrackingAnagrafica(request);
			logRequestId =  request.requestId;  //francesca.ribezzi 26/09/19 - F2WAVE2-189 - adding logRequestId
			//START elena.preteni@accenture.com 31/5/2019 Add PLC-LOG record
			ls.httpMethod = 'POST';
			ls.requestUri = '/TrackingAnagrafica/*';

			//  WN-139 Micol Ferrari <micol.ferrari@accenture.com>, 18/07/2019 - START
			//ls.requestBody=JSON.serialize(RestContext.response);
            ls.requestBody=req;
			//  WN-139 Micol Ferrari <micol.ferrari@accenture.com>, 18/07/2019 - STOP
			ls.responseBody  = JSON.serialize(response);
			ls.responseStatus  = 'S';
			ls.responseStackTrace  = '200';
			ls.responseMessage = String.valueOf( response.message);//Simone Misani F2Wave-139 18/07/2019
			Id plcId = Plc_LogHelper.logCall(ls); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
			//END elena.preteni@accenture.com 31/5/2019 Add PLC-LOG record
			//francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog with the logRequest id: 
			OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, logRequestId);

		}
		catch(Exception e)
		{
			System.debug('[EXCE] - OB_Maintenance_Tracking_Anagrafica Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
			response.httpStatus = 400;
			res.statusCode 		= 400;
			//START elena.preteni@accenture.com 31/5/2019 Add PLC-LOG record
			ls.httpMethod = 'POST';
			ls.requestUri = '/TrackingAnagrafica/*';
			ls.requestBody=JSON.serialize(RestContext.response);
			ls.responseBody  = JSON.serialize(response);
			ls.responseStatus  = 'E';
			ls.responseStackTrace  = '400';
			ls.responseMessage ='OB_Maintenance_Tracking_Anagrafica.getTrackingAnagrafica Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString();//Simone Misani F2Wave-139 18/07/2019
			Id plcId = Plc_LogHelper.logCall(ls); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
			//END elena.preteni@accenture.com 31/5/2019 Add PLC-LOG record
			//francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog with the logRequest id: 
			OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, logRequestId);
		}
		return response;
	}

global static OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaResponse getTrackingAnagrafica(TrackingAnagraficaRequest request)
{
	System.debug('Tracking Anagrafica - request: '+JSON.serialize(request));
	RestResponse res = RestContext.response;
	OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaResponse response = new OB_Maintenance_Tracking_Anagrafica.TrackingAnagraficaResponse();
	Integer responseStatus = 500;
	String message= '';
	try
	{
		if(request==null)
		{
			responseStatus = 400;
			throw new applicationException(NOBODYREQUEST);
		}
		if(String.isBlank(request.requestId) && String.isBlank(request.responseCode))//Simone Misani 13/07/2019 fix Tracking
		{
			responseStatus = 400;
			throw new applicationException(NOREQUESTID);
		}
		Boolean isMerchant = false;
		Boolean isServicePoint = false;
		List<Details> listOfDetails = new List<Details>();
		if(!request.Details.isEmpty())
		{
			listOfDetails = request.Details;
		}
		if(!listOfDetails.isEmpty())
		{
			for(Details singleDetails : listOfDetails)
			{
				if(String.isBlank(singleDetails.source))  //  WN-139 Micol Ferrari <micol.ferrari@accenture.com>, 18/07/2019
				{
					responseStatus = 400;
					throw new applicationException(NODETAILSSOURCE);
				}
			}
		}

		List<String> listOfRecordType = new List<String>();
		listOfRecordType.add(OB_UtilityConstants.ANAGRAFICART);
		listOfRecordType.add(OB_UtilityConstants.CAMBIOCOBART);
		//GET LOG REQUEST
		OB_LogRequest__c currentLogRequest = new OB_LogRequest__c();
		List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>();
		listOfLogRequest = [SELECT 	Id,
									OB_OrderId__c,
									OB_LogType__c,
									RecordType.DeveloperName,
									OB_ChangeCompanyData__c,
									OB_ChangeLegalForm__c,
									OB_ChangeLegalRepresentative__c,
									OB_ChangeMerchantName__c,
									OB_ChangeServicePointData__c,
									OB_Status__c,
									OB_ReducedNewData__c,
									OB_AccountId__c,//elena.preteni wn-137 23/07/2019
									OB_ReducedOldData__c,
									OB_SIAToBeApproved__c,
									OB_EquensMoneticaToBeApproved__c,//elena.preteni wn-137 23/07/2019
									CreatedById //elena.preteni wn-137 23/07/2019
							FROM 	OB_LogRequest__c
							WHERE 	Id =: request.requestId
							AND 	RecordType.DeveloperName IN: listOfRecordType
							LIMIT 	1];
		if(!listOfLogRequest.isEmpty())
		{
			currentLogRequest = listOfLogRequest.get(0);
		}
		if(currentLogRequest!=null)
		{
			if(currentLogRequest.RecordType.DeveloperName==OB_UtilityConstants.ANAGRAFICART)
			{
				if(currentLogRequest.OB_ChangeServicePointData__c==true)
				{
					isServicePoint = true;
				}
				else if(currentLogRequest.OB_ChangeCompanyData__c==true||currentLogRequest.OB_ChangeLegalForm__c==true||
					currentLogRequest.OB_ChangeMerchantName__c==true||currentLogRequest.OB_NewLegalRepresentative__c==true||
					currentLogRequest.OB_ChangeLegalRepresentative__c==true)
				{
					isMerchant = true;
				}
			}
			//START ----Simone Misani 119  overwrite 10/07/2019
			if(currentLogRequest.RecordType.DeveloperName==OB_UtilityConstants.CAMBIOCOBART)
			{
				String termId;  
				Boolean emptyTermId = false;
				for(Details detail : listOfDetails)
				{
					if(String.isBlank(detail.termId))
					{
						emptyTermId = true;
					}else{
						termId = detail.termId;
					}
				}
				if(!emptyTermId)
				{
					
						if(request.responseCode == OK)
						{
							List<Object> mapReducednewDataList 	= (List<Object> )JSON.deserializeUntyped(currentLogRequest.OB_ReducedNewData__c);
							List<String> racs = new List<String>();
							String iban;
							for(Object mapReducednewData :mapReducednewDataList ){
								Map<String,Object> mappa = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(mapReducednewData));
								if(mappa.containsKey('racSia') && mappa.containsKey('iban')){
									racs.add(String.valueOf(mappa.get('racSia'))); 
									iban=String.valueOf(mappa.get('iban'));
								}
							}
							List<Asset> assetsRetrieved = [SELECT id,
																	OB_RAC_SIA__c,
																	NE__BillingProf__c,
																	OB_DebitProfId__c,
																	NE__Status__c,
																	OB_ProposerABI__c//Simone Misani 24/04/2019 WN-137
															FROM Asset
															WHERE OB_RAC_SIA__c = :racs
															AND OB_TermId__c  =: termId];//Simone Misani 24/04/2019 WN-137
							Asset retriveAssetforBill = new Asset();
							if(!assetsRetrieved.isEmpty()){//Simone Misani 24/04/2019 WN-137
								retriveAssetforBill = assetsRetrieved.get(0);//Simone Misani 24/04/2019 WN-137
							
								NE__Billing_Profile__c bill = new NE__Billing_Profile__c();
								bill.NE__Account__c = currentLogRequest.OB_AccountId__c;
								bill.OB_ABICode__c=iban.substring( 5, 10 );
								bill.OB_Bank_Account_Number__c= iban.substring( 15 );
								bill.OB_Bank_Account_Owner__c = retriveAssetforBill.OB_ProposerABI__c; //elena.preteni 23/07/2019 wn-137 //Simone Misani 24/04/2019 WN-137
								bill.OB_CABCode__c= iban.substring( 10, 15 );
								bill.OB_CINCode__c=iban.substring( 4, 5 );
								bill.OB_CountryCode__c=iban.substring( 0, 2 );
								bill.OB_EuroControlCode__c=iban.substring( 2, 4 );
								insert bill;
							
								List<Asset> assetsToUpdate = new List<Asset> ();
							
								for(Asset a : assetsRetrieved){
									Asset assetToAdd = new Asset();
									assetToAdd.id=a.Id;
									assetToAdd.NE__Status__c='Active';
									assetToAdd.NE__BillingProf__c = bill.id;
									assetToAdd.OB_DebitProfId__c=bill.id;
									assetsToUpdate.add(assetToAdd);
								}
								update assetsToUpdate;
								// currentLogRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
								// update currentLogRequest;
								//responseStatus = updateLogRequest(listOfDetails,currentLogRequest);//Simone Misani 18/07/2019 WN-139
								// responseStatus = updateLogRequest(listOfDetails,currentLogRequest);
							}//Simone Misani 24/04/2019 WN-137
						}
					responseStatus = updateLogRequest(listOfDetails,currentLogRequest);
					//END ----Simone Misani 119  overwrite 10/07/2019
				}
				else
				{
					responseStatus = 400;
					throw new applicationException(NOTERMID);
				}
			
			}
		}
		System.debug('isMerchant: '+isMerchant);
		System.debug('isServicePoint: '+isServicePoint);

		if(isMerchant)
		{
			
			Boolean emptyCompanyCode= false;
			for(Details detail : listOfDetails)
			{
				if(String.isBlank(detail.companyCode))
				{
					emptyCompanyCode= true;
				}
			}
			if(!emptyCompanyCode)
			{                /*
				List<Account> listOfAccount = new List<Account>();
				listOfAccount = [SELECT Id
								FROM	Account
								WHERE 	Id =: request.merchantId];
				
				if(listOfAccount.size()>0)
				{*/
					//START---Simone Misani 18/07/2019 WN-139
					// if(request.responseCode == OK)
					// {
						responseStatus = updateLogRequest(listOfDetails,currentLogRequest);
					// }
					//END--Simone Misani 18/07/2019 WN-139
				//}
			}
			else
			{
				responseStatus = 400;
				throw new applicationException(NOCOMPANYCODE);
			}
			
		}
		if(isServicePoint)
		{
			if(!String.isBlank(request.merchantId)&&!String.isBlank(request.salesPointId))
			{
				Boolean emptyCompanyCode 	= false;
				Boolean emptyPvCode 		= false;
				for(Details detail : listOfDetails)
				{
					if(String.isBlank(detail.companyCode) && detail.responseCode == 'OK')//Simone Misani 29/07/2019
					{
						emptyCompanyCode = true;
					}
					if(String.isBlank(detail.PVcode) && detail.responseCode == 'OK')//Simone Misani 29/07/2019
					{
						emptyPvCode = true;
					}
				}
				if(!emptyCompanyCode&&!emptyPvCode)
				{
					// List<NE__Service_Point__c>listOfServicePoint = new List<NE__Service_Point__c>();
					// listOfServicePoint = [	SELECT 	Id
					// 						FROM 	NE__Service_Point__c
					// 						WHERE 	Id =: request.salesPointId];
					// if(listOfServicePoint.size()>0)
					// {
					//START---Simone Misani 18/07/2019 WN-139
					// if(request.responseCode == OK)
					// {
						responseStatus = updateLogRequest(listOfDetails,currentLogRequest);
					// }
					//END--Simone Misani 18/07/2019 WN-139
					//}
				}
				else
				{
					if(emptyCompanyCode)
					{
						responseStatus = 400;
						throw new applicationException(NOCOMPANYCODE);
					}
					else if(emptyPvCode)
					{
						responseStatus = 400;
						throw new applicationException(NOPVCODE);
					}
				}
			}
			else
			{
				responseStatus = 400;
				throw new applicationException(NOSERVICEPOINTID);
			}
		}
		//  WN-139 Micol Ferrari <micol.ferrari@accenture.com>, 18/07/2019 - START
		responseStatus = 200;
		message= 'OK';
		//  WN-139 Micol Ferrari <micol.ferrari@accenture.com>, 18/07/2019 - STOP
		
	}
	catch(Exception e)
	{
		System.debug('OB_Maintenance_Tracking_Anagrafica.getTrackingAnagrafica Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
		response.httpStatus = responseStatus;
		response.message =  e.getMessage() + ' ' + e.getStackTraceString();//Simone Misani F2Wave-139 18/07/2019
		System.debug('Error response : ' + res);
		res.statusCode = responseStatus;
		System.debug('Response Status : ' + responseStatus + ' Header Status : ' + responseStatus);
	}
	response.httpStatus = responseStatus;//elena.preteni wn-137 23/07/2019
	response.message = message;
	return response;
}

public static Integer updateLogRequest(List<Details> listOfDetails,OB_LogRequest__c currentLogRequest)
{
	System.debug( LoggingLevel.FINE, 'OB_Maintenance_Tracking_Anagrafica.updateLogRequest currentLogRequest Id: ' + currentLogRequest.Id );
	Integer responseStatus = 400;
	Boolean okDetails = true;
	for(Details dtls : listOfDetails)
	{
		if(dtls.responseCode==KO)
		{
			okDetails 	= false;
		}
	}
	if(okDetails && currentLogRequest.OB_SIAToBeApproved__c==false)
	{
		System.debug( LoggingLevel.FINE, 'OB_Maintenance_Tracking_Anagrafica.updateLogRequest OK' );
		currentLogRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
		update currentLogRequest;
		String updateObject = OB_Maintenance_View_Request_Controller.acceptLogRequestFinal(currentLogRequest.Id);
		System.debug('UPDATE OBJECT FROM TRACKING ANAG: '+updateObject);
		responseStatus = 200;
	}
	else
	{
		System.debug( LoggingLevel.FINE, 'OB_Maintenance_Tracking_Anagrafica.updateLogRequest KO' );
		currentLogRequest.OB_Status__c = OB_UtilityConstants.INATTESA;
		currentLogRequest.OB_EquensMoneticaToBeApproved__c = okDetails ? false : true;
		update currentLogRequest;
		responseStatus = 200;
	}
	return responseStatus;
}
// - - - - - - - -REQUEST- - - - - - -
global class TrackingAnagraficaRequest
{
	global String requestId 	    	{get;set;}
	global String merchantId        	{get;set;}
	global String salesPointId	    	{get;set;}
	global String bankAccountId     	{get;set;}
	global String responseCode          {get;set;}
	global String responseDescription   {get;set;}
	global List<Details> Details    	{get;set;}
	global TrackingAnagraficaRequest()
	{
		Details = new List<Details>();
	}
}

global class Details
{
	global String source	            {get;set;}
	global String code                  {get;set;}
	global String companyCode			{get;set;}
	global String PVcode				{get;set;}
	global String termId				{get;set;}
	global String responseCode          {get;set;}
	global String responseDescription   {get;set;}
}
// - - - - - - - -RESPONSE- - - - - - -
global class TrackingAnagraficaResponse
{
	global Integer httpStatus 	{get;set;}
	global String message		{get;set;}//Simone Misani F2Wave-139 18/07/2019
}
public class applicationException extends Exception {}
}