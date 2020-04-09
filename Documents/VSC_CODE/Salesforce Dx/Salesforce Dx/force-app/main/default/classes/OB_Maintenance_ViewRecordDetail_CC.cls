public with sharing class OB_Maintenance_ViewRecordDetail_CC
{
    @AuraEnabled
    public static Map<String, Object> retrieveLogRequestServer( String logrequestId )
    {
        Map<String, Object> mapToReturn = new Map<String, Object>( );
        mapToReturn.put( 'isConfirmButton', false );//NEXI-33 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 14/05/2019
        List<OB_LogRequest__c> logRequests = new List<OB_LogRequest__c>( );
        logRequests = null;
        try
        {
            logRequests =
            [
                    SELECT OB_AccountId__c,
                            OB_AccountId__r.NE__Fiscal_code__c,
                            OB_AccountId__r.NE__VAT__c,
                            OB_ABI__c,//NEXI-91 24/06/2019 grzegorz.banach@accenture.com
                            OB_NewLegalRepresentative__c,
                            OB_RejectReason__c,
                            OB_ApprovalProcessStatus__c,
                            OB_ServicePointId__r.Name,
                            OB_ServicePointId__r.OB_AddressFormula__c,
                            OB_Status__c,
                            OB_StatusFormula__c,
                            OB_MaintenanceType__c,
                            OB_ChangeLegalRepresentative__c,
                            OB_ChangeLegalForm__c,
                            OB_ChangeCompanyData__c,
                            OB_ChangeServicePointData__c,
                            OB_ChangeMerchantName__c,
                            OB_Change_of_data_of_beneficial_owners__c,//NEXI-91 24/06/2019 grzegorz.banach@accenture.com
							//NEXI-187 11/07/2019 Grzegorz Banach <grzegorz.banach@accenture.com> START
							OB_change_of_reporting_type__c,
							OB_Settlement_Procedure__c,
							//NEXI-187 11/07/2019 Grzegorz Banach <grzegorz.banach@accenture.com> STOP
							CreatedDate,
                            OB_OrderId__c,
                            OB_OrderId__r.Id,
                            OB_OrderId__r.Name,
                            OB_SIAToBeApproved__c,
                            OB_EquensMoneticaToBeApproved__c,
                            OB_Requestor__c,
                            OB_RequestDate__c,
							OB_Error_Tracking__c,//Simone Misani 22/07/2019 fix tracking
							OB_Response_Track__c,//Simone Misani 22/07/2019 fix tracking
                            OB_Note__c,
							OB_isNotIntegrated__c, //antonio.vatrano 31/07/2019 wn-213
							OB_Save_as_Draft__c,
                            OB_LogType__c,
                            OB_Gianos__c//NEXI-205 18/07/2019 m.lukomska-rogala@accenture.com
                    FROM OB_LogRequest__c
                    WHERE Id = :logrequestId
            ];
            System.debug( 'logRequests is: ' + logRequests );
            if ( !logRequests.isEmpty( ) )
            {
                OB_LogRequest__c contextLogRequest = logRequests.get( 0 );
                System.debug( 'contextLogRequest is: ' + contextLogRequest );
                String userId = UserInfo.getUserId( );
                if ( contextLogRequest != null )
                {
                    List<User> listOfUsers =
                    [
                            SELECT Id,
                                    Profile.Name,
                                    Profile.UserLicense.Name
                            FROM User
                            WHERE Id = :userId
                            LIMIT 1
                    ];
                    if ( !listOfUsers.isEmpty( ) )
                    {
                        User user = listOfUsers.get( 0 );
                        String license = user.Profile.UserLicense.Name;
                        String profile = user.Profile.Name;
                        System.debug( 'license:  ' + license );
                        System.debug( 'profile:  ' + profile );

                        String confInfProfiles;
                        Boolean profileIsInConfInf = false;
                        OB_ConfigurationInformation__mdt configurationInformation = new OB_ConfigurationInformation__mdt( );
                        OB_ConfigurationInformation__mdt[] listOfConfigurationInformations =
                        [
                                SELECT Id,MasterLabel,Label,QualifiedApiName,OB_String_Value__c
                                FROM OB_ConfigurationInformation__mdt
                                WHERE QualifiedApiName = :System.Label.OB_PartnerCommunityProfiles
                        ];

                        if ( !listOfConfigurationInformations.isEmpty( ) )
                        {
                            configurationInformation = listOfConfigurationInformations.get( 0 );
                            confInfProfiles = configurationInformation.OB_String_Value__c;
                            System.debug( '@confInfProfiles : ' + confInfProfiles );
                            profileIsInConfInf = confInfProfiles.contains( profile );
                            System.debug( '@profileIsInConfInf : ' + profileIsInConfInf );
                            mapToReturn.put( 'logRequest', contextLogRequest );
                        }
                        if ( ( contextLogRequest.OB_ChangeLegalRepresentative__c == true || contextLogRequest.OB_NewLegalRepresentative__c == true ) &&
                                ( contextLogRequest.OB_RejectReason__c != OB_UtilityConstants.REJECTION_REASON_FINAL_REJ &&
                                        contextLogRequest.OB_RejectReason__c != null &&
                                        contextLogRequest.OB_RejectReason__c != '' &&
                                        contextLogRequest.OB_ApprovalProcessStatus__c == OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO ) &&
                                profileIsInConfInf == true )
                        {
                            System.debug( '@Show button resubmit' );
                            mapToReturn.put( 'resubmitBoolean', true );
                            //return true
                        }
						//START---Simone Misani 22/07/2019
						if(OB_UtilityConstants.CONSISTENZA.equalsIgnoreCase( contextLogRequest.OB_MaintenanceType__c)){
							String confId = contextLogRequest.OB_OrderId__c;
							OB_Maintenance_Flow_Override.updateOrderItemActionNone(confId);
						}//END---Simone Misani 22/07/2019
                        //NEXI-33 Adrian Dlugolecki <adrian.dlugolecki@accenture.com>, 14/05/2019 Start
                        if ( 'Variazione Coba'.equalsIgnoreCase( contextLogRequest.OB_MaintenanceType__c )
                                || ( 'Anagrafica'.equalsIgnoreCase( contextLogRequest.OB_MaintenanceType__c ) ) ) // NEXI-97 Marta Stempien <marta.stempien@accenture.com> 07/06/2019
						{
                            Boolean isOperationProfile = 'Operation'.equalsIgnoreCase( profile );
                            Boolean isInAttesaStatus = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA.equalsIgnoreCase( contextLogRequest.OB_Status__c );
                            mapToReturn.put( 'isConfirmButton', isOperationProfile && isInAttesaStatus && contextLogRequest.OB_isNotIntegrated__c ); //antonio.vatrano 31/07/2019 wn-213
                        }
                        //NEXI-33 Adrian Dlugolecki <adrian.dlugolecki@accenture.com>, 14/05/2019 Stop
                    }
                }
            }
        } catch ( Exception ecc )
        {
            System.debug( 'Exception in OB_OrderHeaderDetailsPage_CC.getInfo_apex at line ' + ecc.getLineNumber( ) + '. Error message: ' + ecc.getMessage( ) );
        }
        return mapToReturn;
    }


	@AuraEnabled
	public static void inApprovalProcess(String logrequestId) {
		try
		{
			OB_LogRequest__c log = new OB_LogRequest__c();
			List<OB_LogRequest__c> listOfLogRequest = [	SELECT 	Id, OB_StartApprovalProcess__c,OB_Status__c
			FROM 	OB_LogRequest__c
			WHERE 	Id =: logrequestId	];

			if(!listOfLogRequest.isEmpty())
			{
				log = listOfLogRequest.get(0);
				log.OB_StartApprovalProcess__c = true;
				log.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INAPPROVAZIONE;
				update log;
				OB_Utility.submitApprovalProcess(logrequestId,Label.OB_MAINTENANCE_APPROVALPROCESS);
			}
		} 
		catch(Exception ecc)
		{
			System.debug('[EXCE] OB_Utility.inApprovalProcess '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}

	}

	@AuraEnabled
	public static String retrieveStatus(String logrequestId) 
	{	
		String status= '';
		try
		{
			List<OB_LogRequest__c> listOfLogs = [SELECT id,OB_Status__c,OB_StatusFormula__c FROM OB_LogRequest__c WHERE Id =: logrequestId];
			if (!listOfLogs.isEmpty())
			{
				OB_LogRequest__c log		= listOfLogs.get(0);
				status = log.OB_Status__c; 
			}
		}catch(Exception ecc){
			System.debug('[EXCE] OB_Utility.retrieveStatus '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
		return status;
	}


	@AuraEnabled
	public static void checkOnLogRequest(String logRequestId)
	{
		try
		{
			if(!String.isBlank(logRequestId))
			{
				OB_Utility.checkLogRequest(logRequestId);
				OB_Maintenance_EditAccount_Controller.confirmDocs(logRequestId); // antonio.vatrano hide btn caricadocumenti
				System.debug('@Called OB_Utility.checkLogRequest from OB_Maintenance_ViewRecordDetail_CC');
			}
		}
		catch(Exception ecc)
		{
			System.debug('[EXCE] OB_Maintenance_ViewRecordDetail_CC.checkOnLogRequest '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
	}



	@AuraEnabled
	public static Boolean checkProfilesDraft(String logRequestId){

		Boolean profileIsInConfInf = false;
		List<OB_LogRequest__c> logrequests = [	SELECT 	OB_AccountId__c,OB_ChangeLegalRepresentative__c,
													OB_NewLegalRepresentative__c,OB_RejectReason__c,OB_ApprovalProcessStatus__c
											FROM 	OB_LogRequest__c
											WHERE 	id =:logRequestId];
		if(!logrequests.isEmpty())
		{
			OB_LogRequest__c logrequest = logrequests.get(0);
			String userId = UserInfo.getUserId();
			if(logrequest != null)
			{

				list<User> listOfUsers = [	SELECT 	Id, Profile.Name, Profile.UserLicense.Name
											FROM 	User
											WHERE 	Id =: userId
											LIMIT 	1	];
				if(!listOfUsers.isEmpty())
				{
					User user= listOfUsers.get(0);
					//String license = user.Profile.UserLicense.Name;
					String profile = user.Profile.Name;
					//System.debug('license:  '+license);
					System.debug('profile:  '+profile);

					String confInfProfiles;
					OB_ConfigurationInformation__mdt configurationInformation = new OB_ConfigurationInformation__mdt();
					OB_ConfigurationInformation__mdt[] listOfConfigurationInformations = [	SELECT Id,MasterLabel,Label,QualifiedApiName,OB_String_Value__c
																							FROM OB_ConfigurationInformation__mdt 
																							WHERE QualifiedApiName = 'OB_PartnerCommunityProfilesLogReqDraft'	];
					if(!listOfConfigurationInformations.isEmpty())
					{
						configurationInformation = listOfConfigurationInformations.get(0);
						confInfProfiles = configurationInformation.OB_String_Value__c;
						System.debug('@confInfProfiles : ' +  confInfProfiles);
						profileIsInConfInf = confInfProfiles.contains(profile);
						System.debug('@profileIsInConfInf : ' +  profileIsInConfInf);
					}
				}
			}
		}
		return profileIsInConfInf;
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

		

	/*****************************************************************
	Purpose: Update log Request when update related documents
	Parameters: OB_LogRequest__C logRequest

	History 
	--------
	VERSION AUTHOR 				DATE 		DETAIL 		Description
	1.0 	Salvatore Pianura 	13/05/2019 	Created 	CSR: 
	*****************************************************************/
	@AuraEnabled
	public static void updateRequest(OB_LogRequest__c logRequest)
	{
		System.debug('@Into OB_Maintenance_ViewRecordDetail.updateRequest()');
		if(	logRequest.OB_SIAToBeApproved__c == false && logRequest.OB_EquensMoneticaToBeApproved__c == false && 
			logRequest.OB_Status__c != OB_UtilityConstants.LOGREQUEST_STATUS_INAPPROVAZIONE)
		{
			OB_Utility.serializeAnagrafica(logRequest.Id);
		}
		else
		{
			if(logRequest.OB_Status__c != OB_UtilityConstants.LOGREQUEST_STATUS_INAPPROVAZIONE)
			{
				logRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
				update logRequest;
			}
		}
	}

	/*****************************************************************
	Purpose: Confirm log request
	Parameters: Id logRequestId

	History
	--------
	VERSION AUTHOR 				DATE 		DETAIL 		Description
	1.0 	Adrian Dlugolecki 	14/05/2019 	Created 	NEXI-33
	*****************************************************************/
	@AuraEnabled
	public static boolean confirmLogRequest( String inLogRequestId )
	{
		System.debug(LoggingLevel.INFO,'OB_Maintenance_ViewRecordDetail_CC.confirmLogRequest in log request '+inLogRequestId);
		try
		{
            String result = OB_Maintenance_View_Request_Controller.acceptLogRequestFinal(inLogRequestId); //elena.preteni 13/07/2019 F2wave2-136 not saving values
			return true;
		} catch ( DmlException exc )
		{
			System.debug( '[EXC] OB_Maintenance_ViewRecordDetail_CC.confirmLogRequest ' + exc.getMessage( ) + ' stack trace: ' + exc.getStackTraceString( ) );
		}
		return false;
	}


    /*****************************************************************
    Purpose: Method pass Log Request ID to OB_Maintenance_EditAccount_Controller.startApprovalProcess
    Parameters: Id logRequestId
    Returns: -

    History
    --------
    VERSION AUTHOR 				DATE 		DETAIL 		Description
    1.0 	Wojciech Kucharek 	05/07/2019 	Created 	NEXI-156
        *****************************************************************/
    @AuraEnabled
    public static void startApprovalProcess( Id logRequestId )
    {
        OB_Maintenance_EditAccount_Controller.startApprovalProcess( logRequestId );
    }
}