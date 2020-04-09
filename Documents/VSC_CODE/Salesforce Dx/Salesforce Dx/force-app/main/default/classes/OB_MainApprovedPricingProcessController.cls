public without sharing class OB_MainApprovedPricingProcessController {
	@AuraEnabled
	public static NE__Order__c setConfigurationToApprove(String confId){

        NE__Order__c ord = [
            select id,NE__Order_Header__r.OB_Sub_Process__c, NE__Order_Header__r.OB_CAB__c, NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c, OB_CAB__c, NE__Order_Header__c, OB_AgreedChanges__c, NE__AccountId__c, NE__AccountId__r.OB_ATECO__c, NE__AccountId__r.OB_Legal_Form__c, OB_Service_Point__c, OB_Service_Point__r.OB_MCC__c, OB_MCC__c 
            from NE__Order__c 
            where id = :confId
        ];

        return ord;
    }
   
     @AuraEnabled
	public static String createLogRequestServer(String merchantId, String servicePointId, String confId, String abi, String cab, String subProcess){
		String logReqId; 
		Boolean hasAcquiring = false;
		Boolean hasPOS = false;
        
        
		
		//	START 	micol.ferrari 06/02/2019
		// List<NE__OrderItem__c> orderItemPOS = [
		// 	select id,OB_VariationPOSPB__c 
		// 	from NE__OrderItem__c 
		// 	where NE__Parent_Order_Item__r.RecordType.DeveloperName 
		// 	IN ('Terminali','Pagobancomat') 
		// 	and OB_VariationPOSPB__c !='' 
		// 	and NE__OrderId__c = :confId
		// 	LIMIT 1
		// ];

		List<NE__OrderItem__c> orderItemPOS = [
			SELECT id,OB_VariationPOSPB__c 
			FROM NE__OrderItem__c 
			WHERE 
			NE__OrderId__c = :confId
			AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing'
			AND	NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName IN ('Terminali','Pagobancomat') 
			AND (NE__Action__c = 'Add' OR NE__Action__c = 'Change')
		];
        system.debug('orderItemPOS '+orderItemPOS);
		//	END 	micol.ferrari 06/02/2019

		if(orderItemPOS.size() > 0 ){
			hasPOS = true;
		}
		
		//	START 	micol.ferrari 06/02/2019
		// List<NE__OrderItem__c> orderItemAcqVAS = [
		// 	select id,OB_VariationPOSPB__c 
		// 	from NE__OrderItem__c 
		// 	where NE__Parent_Order_Item__r.RecordType.DeveloperName 
		// 	IN ('VAS','Acquiring') 
		// 	and OB_VariationPOSPB__c !='' 
		// 	and NE__OrderId__c = :confId
		// 	LIMIT 1
		// ];

		List<NE__OrderItem__c> orderItemAcqVAS = [
			SELECT id,OB_VariationPOSPB__c 
			FROM NE__OrderItem__c  
			WHERE 
			NE__OrderId__c = :confId
			AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing'
			AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName IN ('VAS','Acquiring') 
			AND (NE__Action__c = 'Add' OR NE__Action__c = 'Change')
		];
        system.debug('orderItemAcqVAS '+orderItemAcqVAS);
		//	END 	micol.ferrari 06/02/2019

		if(orderItemAcqVAS.size() > 0 ){
			hasAcquiring = true;
		} 

		//	START 	micol.ferrari 14/02/2019 - CREATION OF THE LOG REQUEST AFTER WE KNOW THAT THE BIO APPROVAL PRICING MUST START
		NE__Order__c conf = new NE__Order__c();
		String stringConcat;
		// R1F2-240 - 12/06/2019 - <daniele.gandini@accenture.com> - added NE__FulfilmentStatus__c field
		List<NE__Order__c>listOfconf = [	SELECT 	Id,NE__FulfilmentStatus__c,OB_ApprovalType__c,OB_AdditionalDocumentationRequired__c,OwnerId,OB_ABI__c,OB_CAB__c, NE__Order_Header__c
																			FROM 	NE__Order__c
																			WHERE 	Id =: confId];
		// R1F2-240 - 12/06/2019 - <daniele.gandini@accenture.com> - added NE__FulfilmentStatus__c field
		Boolean needBIO = false;
		Boolean callBIO = false;
        system.debug('in if listOfconf needBIO'+listOfconf);
		// Start    antonio.vatrano 10/05/2019 - R1F2-112 – Retrieve license of current User
		String license = OB_CatalogController.retrieveUserLicense();
		Boolean isSalesforce = license == 'Salesforce' ? true : false;
		// end    antonio.vatrano 10/05/2019 - R1F2-112 – Retrieve license of current User
		if(!listOfconf.isEmpty())
		{
            system.debug('in if conf ');
			conf = listOfconf.get(0);
	
			List<OB_Bank_Profile__c> listOfBankProf = [SELECT Id,OB_NeedBIO__c FROM OB_Bank_Profile__c WHERE OB_Bank__r.OB_ABI__c=:listOfconf.get(0).OB_ABI__c LIMIT 1];
			if(!listOfBankProf.isEmpty()) 
			{
                
				needBIO = listOfBankProf.get(0).OB_NeedBIO__c;
                system.debug('in if bankprofile needBIO'+needBIO);
			}
		
			// if(subProcess == 'variazione economica'){
			// 	logRequest.OB_MaintenanceType__c	=     OB_UtilityConstants.PRICING; 
			// }else if(subProcess == 'variazione operativa'){
			// 	logRequest.OB_MaintenanceType__c	=     OB_UtilityConstants.CONSISTENZA; 
			// }
			Id rtPricing 										  = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName().get('OB_Pricing').getRecordTypeId();
			OB_LogRequest__c  logRequest 			= new OB_LogRequest__c();
			callBIO = (needBIO && conf.OB_AdditionalDocumentationRequired__c) ? true : false;
            system.debug('in OB_AdditionalDocumentationRequired__c '+conf.OB_AdditionalDocumentationRequired__c);
            system.debug(' callBIO'+callBIO);
            
			if(callBIO && !isSalesforce ){     //antonio.vatrano 10/05/2019 - R1F2-112 – add condition about license of current User
                system.debug(' in if callBIO');
				logRequest.OB_Status__c 				= 	  OB_UtilityConstants.BOZZA;
			}else{
				logRequest.OB_Status__c       	=     OB_UtilityConstants.BOZZA;
                system.debug(' in else callBIO');
				// R1F2-240 - 12/06/2019 - <daniele.gandini@accenture.com> - Logic for changing OB_FulfilmentStatus__c in SENT and updat e OB_Bank_OrderStatus__c and OB_Nexi_OrderStatus__c - START
				conf.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_SENT;
                conf.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_NEXI_PROCESSING;
                conf.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_WAITING_FOR_PROCESSING;
				update conf;
				// R1F2-240 - 12/06/2019 - <daniele.gandini@accenture.com> - Logic for changing OB_FulfilmentStatus__c in SENT and update OB_Bank_OrderStatus__c and OB_Nexi_OrderStatus__c - STOP
			}
			logRequest.OB_AccountId__c        =     merchantId;
			logRequest.OB_ServicePointId__c 	=     servicePointId;
			logRequest.OB_OrderId__c        	=     confId;
			logRequest.OB_ABI__c            	=     listOfconf.get(0).OB_ABI__c; 
			logRequest.OB_CAB__c            	=     listOfconf.get(0).OB_CAB__c;
			logRequest.OB_MaintenanceType__c	=     OB_UtilityConstants.PRICING; //PRICING
			logRequest.OB_HasAcquiring__c   	=     hasAcquiring; //tbd
			logRequest.OB_HasPos__c           =     hasPOS;//tbd
			logRequest.RecordTypeId           =     rtPricing; //OB_Pricing
			logRequest.OB_RequestDate__c	    =   Date.today();
			logRequest.OB_isNotIntegrated__c  = false;
			// <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - start
			Boolean isPartnerCommunityLogged = OB_Utility.isPartnerCommunity(UserInfo.getUserId());
			if(isPartnerCommunityLogged){
				logRequest.OB_Requestor__c = OB_UtilityConstants.Banca;
			}
			// <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - stop
							
			try{ 
				insert logRequest;
				logReqId = logRequest.Id ;
			}catch(Exception e){	
				System.debug('Exception creating a log request: ' + e.getMessage());
				System.debug('Exception type caught: ' + e.getTypeName());    
				System.debug('Message: ' + e.getMessage());    
				System.debug('Cause: ' + e.getCause());
				System.debug('Line number: ' + e.getLineNumber());    
				System.debug('Stack trace: ' + e.getStackTraceString()); 
			}

			if(callBIO && !isSalesforce ){     //antonio.vatrano 10/05/2019 - R1F2-112 – add condition about license of current User
				try{
                     system.debug(' in if callBIO call process');
					conf.OB_ApprovalType__c 	= OB_UtilityConstants.APPROV_TYPE_BIO;
                    //  START   micol.ferrari 22/02/2019
                    conf.OB_BankApprovalStatus__c   = '';
                    //  END     micol.ferrari 22/02/2019

					//  R1F2-95 Micol Ferrari <micol.ferrari@accenture.com>, 06/05/2019 - START
					stringConcat 						= listOfconf.get(0).OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_BIO;
					//  R1F2-95 Micol Ferrari <micol.ferrari@accenture.com>, 06/05/2019 - STOP

					system.debug(' stringConcat'+stringConcat);
					List<Group> groupSelected 	= [	SELECT 	Id,Name 
													FROM 	Group 
													WHERE 	Type = 'Queue'
													AND 	Name = :stringConcat
													LIMIT 	1		];
                    
                    
					System.debug('OB_CatalogController : *CHECK BIO* : groupSelected : ' + groupSelected);
					if( groupSelected != null && groupSelected.size() > 0 )
					{
						conf.OwnerId = groupSelected[0].Id;
						System.debug('OB_CatalogController : *CHECK BIO* : CONF OWNER ID: ' +conf.OwnerId);
					}
					update conf;
					OB_Utility.submitApprovalProcess(conf.Id,Label.OB_BIO_ApprovalProcess);	
				}catch(Exception e){	
					System.debug('Exception starting a BIO approval process: ' + e.getMessage());
					System.debug('Exception type caught: ' + e.getTypeName());    
					System.debug('Message: ' + e.getMessage());    
					System.debug('Cause: ' + e.getCause());
					System.debug('Line number: ' + e.getLineNumber());    
					System.debug('Stack trace: ' + e.getStackTraceString()); 
				}
			}

			Boolean checkAcquiring = OB_Utility.retrieveSpecialCategoryConfigurations(conf.NE__Order_Header__c);
                
                if(!callBIO && !checkAcquiring){//Simone misani WN-347
                     System.enqueueJob(new OB_QueueableClass(conf.NE__Order_Header__c));//Simone misani  beacouse don't start the call vs MIp
                }
		}
		//	END 	micol.ferrari 14/02/2019 - CREATION OF THE LOG REQUEST AFTER WE KNOW THAT THE BIO APPROVAL PRICING MUST START
		return logReqId;
	
	}

	// DG - 09/02/2019 - 1316
		@AuraEnabled
		public static String getStringUrl(){
			
			String urlString = '';
			try{
				urlString = OB_ContinuationCOntroller.getVFBaseURL();
				if(String.isBlank(urlString) && String.isEmpty(urlString)){
					urlString = 'Empty or null Value';
				}
			}catch(Exception ecc){
				System.debug('Url exception: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
				urlString = 'Exception';
			}
			return urlString;
		}

		@AuraEnabled
		public static Boolean acquiringChangesServer(List<Id> configurationId){
			Boolean toReturn = false;
			try {
				if(!configurationId.isEmpty()) {
					Boolean acquiringChanges = OB_Utility.checkForAcquiringChanges(configurationId); 
					if(acquiringChanges) {
						toReturn = acquiringChanges;
						return toReturn;
					}
				}
				return toReturn;
			}catch(Exception ecc){
				System.debug('acquiringChanges exception: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
				return false;
			}
		}

}