public class OB_QueueableClassCheckApprovalProcesses implements Queueable, Database.AllowsCallouts
{
	public final String data;
    @testVisible private static Boolean isSetLessTwenty = false;// Roland Nieznanski <roland.nieznanski@accenture.com> 03/09/2019 Variable used in test and controls variables settings

	public OB_QueueableClassCheckApprovalProcesses(String input)
	{
		data = input;
	}
    /**
    *@author 
    *@Method execute
    *@History:           30/08/19 enrico.purificato/francesca.ribezzi method refactoring 
    */
	public void execute(QueueableContext context) 
	{

		try
		{
			System.debug('@Execute OB_QueueableClassCheckApprovalProcesses');
            //START - 2019/05/08 - salvatore.pianura - fix on configuration query
            NE__Order__c configuration = new NE__Order__c();
            List<NE__Order__c> listOfConf = new List<NE__Order__c>();
            //30/04/19 francesca.ribezzi adding fields to query: NE__Order_Header__r.OB_Sub_Process__c and OB_Model_Changed__c
            listOfConf = [  SELECT  Id,OB_AdditionalDocumentationRequired__c,NE__Order_Header__c,NE__AccountId__c,
                                                    NE__Order_Header__r.OB_ProposerABI__c,NE__Order_Header__r.OB_Main_Process__c,
                                                    NE__AccountId__r.Id,OB_Service_Point__c,NE__Order_Header__r.OB_ABI__c,NE__Order_Header__r.OB_CAB__c,
                                                    NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c,
                                                    NE__Order_Header__r.OB_Sub_Process__c, OB_Model_Changed__c
                                            FROM    NE__Order__c
                                            WHERE   Id =: data];
            
            // Start    antonio.vatrano 10/05/2019 - R1F2-112 – Retrieve license of current User
            String license = OB_CatalogController.retrieveUserLicense();
            Boolean isSalesforce = license == 'Salesforce' ? true : false;
            // end    antonio.vatrano 10/05/2019 - R1F2-112 – Retrieve license of current User
            //START francesca.ribezzi 30/08/19 - returning if there's no configuration
            if(listOfConf.size() == 0){
				return;
			}
            //END francesca.ribezzi 30/08/19 
			configuration = listOfConf.get(0);
			
			String stringConcat;
			String orderHeaderId                    = configuration.NE__Order_Header__c;
			String proposerAbi                      = configuration.NE__Order_Header__r.OB_ProposerABI__c;
			String mainProcess                      = configuration.NE__Order_Header__r.OB_Main_Process__c;
			Boolean checkBio = false;
			String subProcess                       = configuration.NE__Order_Header__r.OB_Sub_Process__c; // <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2  
			Id bankRt                               = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.ACC_RT_BANK ).getRecordTypeId();
			//START - 2019/05/08 - salvatore.pianura - fix on account query
			Account bank = new Account();
			List<Account> listOfAccount = new List<Account>();
			listOfAccount = [   SELECT  Id,Name,
									(SELECT Id,OB_NeedBIO__c FROM Bank_Profiles1__r)
								FROM    Account
								WHERE   RecordTypeId =: bankRt
								AND     Id =: proposerAbi   
								LIMIT   1];
			//START francesca.ribezzi 30/08/19 - throwing exception if either the account list or the bank profile's are empty
            if(listOfAccount.isEmpty())
			{
				throw new customException('[EXCE] OB_QueueableClassCheckApprovalProcesses - listOfAccount is empty');
			}
			bank = listOfAccount.get(0);
			//END - 2019/05/08 - salvatore.pianura - fix on account qu ery
			if(bank.Bank_Profiles1__r == null){
				throw new customException('[EXCE] OB_QueueableClassCheckApprovalProcesses - Bank_Profiles1__r is empty');
			}
            //END francesca.ribezzi 30/08/19 - throwing exception id the account list is empty
			list<OB_Bank_Profile__c> listOfBankProfiles = bank.Bank_Profiles1__r;
			OB_Bank_Profile__c currentBankProfile = listOfBankProfiles.get(0);
			System.debug('OB_QueueableClassCheckApprovalProcesses : currentBankProfile ' + JSON.serialize(currentBankProfile));
			Boolean checkAcquiring = OB_Utility.retrieveSpecialCategoryConfigurations(orderHeaderId); //francesca.ribezzi 02/09/19 checkAcquiring process moved back here
			System.debug('checkAcquiring: ' + checkAcquiring);

            // NEXI-314 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 11/09/2019 START
            if ( OB_Utility.isOperation( ) && OB_UtilityConstants.SETUP.equalsIgnoreCase( mainProcess ) )
            {
                System.debug( LoggingLevel.FINE, 'OB_QueueableClassCheckApprovalProcesses user: Operation, flow: setup' );
                OB_Utility.updateOrderToApprove( configuration.Id, OB_UtilityConstants.BIO );
                OB_Utility.updateOrderHeaderPending( orderHeaderId );
            }
            // NEXI-314 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 11/09/2019 STOP

            if(currentBankProfile.OB_NeedBIO__c == true && configuration.OB_AdditionalDocumentationRequired__c == true && !isSalesforce )     //antonio.vatrano 10/05/2019 - R1F2-112 – add condition about license of current User)
			{
				checkBio = true;
				System.debug('INTO IF APROVAL PROCESS BIO');
				configuration.OB_ApprovalType__c 	= OB_UtilityConstants.APPROV_TYPE_BIO;
				configuration.ob_bankapprovalstatus__c = '';
				stringConcat 				        = configuration.NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_BIO;

				List<Group> groupSelected 	= [	SELECT 	Id,Name 
												FROM 	Group 
												WHERE 	Type = 'Queue'
												AND 	Name = :stringConcat
												LIMIT 	1		];
				System.debug('groupSelected: ' + groupSelected);

				if( groupSelected != null && groupSelected.size() > 0 )
				{
					configuration.OwnerId = groupSelected[0].Id;
					System.debug('CONF OWNER ID: ' +configuration.OwnerId);
				}

				update configuration;
                //francesca.ribezzi 30/08/19 calling updateLogRequestStatus to update log request status to draft - needBIO:
				updateLogRequestStatus(configuration.Id, OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT);
				OB_Utility.submitApprovalProcess(configuration.Id,Label.OB_BIO_ApprovalProcess);
				return; 	//francesca.ribezzi 30/08/19 returning
			}

			//francesca.ribezzi 30/08/19 - else deleted
			if(checkAcquiring)
			{
                 //francesca.ribezzi 30/08/19 calling updateLogRequestStatus to update log request status to draft - checkAcquiring:
				updateLogRequestStatus(configuration.Id, OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT);
				System.debug('CALL APPROVAL PROCESS ACQUIRING');
				OB_Utility.submitApprovalProcess(orderHeaderId,Label.OB_ApprovalProcessAcquiring);
				return; 	//francesca.ribezzi 30/08/19 returning
			}
            //START francesca.ribezzi 02/09/19 - R1F3-24 - call  OB_QueueableClass for setup process
            if(mainProcess == 'Setup'){
                System.debug('calling OB_QueueableClass - setup');
                System.enqueueJob(new OB_QueueableClass(orderHeaderId));
                return;
            }
            //END francesca.ribezzi 02/09/19 - R1F3-24

			if(subProcess == OB_UtilityConstants.HEADER_SUBPROCESS_TERMINAOFFERTA){ 
				return;
			}
            String typology;// Simone Misani WN-577 08/10/2019	
			List<NE__OrderItem__c> listOfItems = 
            [
                SELECT Id,Name,NE__ProdId__r.OB_Codice_sfdc__c,NE__ProdId__r.Name,NE__Action__c,NE__Parent_Order_Item__c,OB_Processor__c, OB_Enablement__c, OB_Old_Enablement__c,NE__OrderId__r.OB_Service_Point__r.OB_Typology__c
                FROM NE__OrderItem__c
                WHERE NE__OrderId__c =: configuration.Id 
            ];
			List<String> acqProdList = new list<String>{'JCB', 'UPI', 'VISAMASTERCARD'}; 
			Boolean isIntegrated = false;
			Boolean isNotIntegrated = false;
            // Simone Misani WN-577 08/10/2019 STARt
           if(!listOfItems.isEmpty()){
               typology = listOfItems.get(0).NE__OrderId__r.OB_Service_Point__r.OB_Typology__c;
           }
            // Simone Misani WN-577 08/10/2019 END
			for(NE__OrderItem__c o : listOfItems){
				if(o.NE__Action__c == 'Remove' && (acqProdList.contains(o.NE__ProdId__r.OB_Codice_sfdc__c))){
					isNotIntegrated = true;
				}
				else if(o.NE__Action__c == 'Change' && o.OB_Enablement__c == 'N' && acqProdList.contains(o.NE__ProdId__r.OB_Codice_sfdc__c)){
					isNotIntegrated = true;	
				}
                else if(o.NE__Action__c != 'None'){ // antonio.vatrano wn-413 16/09/2019 check if context item' action != NONE
					isIntegrated = true;
				}
		
			}
			if(isNotIntegrated && !isIntegrated){
				return;
			}
			
			// <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2 - STOP  
			if(mainProcess == 'Maintenance') // <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2 - else removed
			{
                //francesca.ribezzi 23/09/19 - WN-449 - check if it is tech configurator process: 
                Boolean confTech = OB_Maintenance_Consistenza_LogRequest_CC.compatibilityTechnicalConfigurator( configuration.Id );
				Boolean SIAToBeApproved = OB_UtilityCallingServices.checkOperation(configuration,listOfItems);
                System.debug('SIAToBeApproved: ' + SIAToBeApproved);
                Boolean isPricing = (configuration.NE__Order_Header__r.OB_Sub_Process__c == OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA && configuration.OB_Model_Changed__c == false);
				Boolean isCommissionModel = (configuration.NE__Order_Header__r.OB_Sub_Process__c == OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA && configuration.OB_Model_Changed__c);
				if(!SIAToBeApproved && (isPricing || isCommissionModel)){ //02/09/19 francesca.ribezzi calling this method if is pricing or commission model process
					//francesca.ribezzi 21/05/19 commenting this line and calling orderItemCheckerDateServer
					System.debug('calling orderItemCheckerDateServer'); 
                    OB_OrderItemCheckerDate.orderItemCheckerDateServer(listOfConf); //enqueueJob is called inside this method
				}else if(!confTech && typology !='Virtuale'){  //francesca.ribezzi 23/09/19 - WN-449 - check if it is tech configurator process:// Simone Misani WN-577 08/10/2019
                    System.debug('calling OB_QueueableClass');
                    System.enqueueJob(new OB_QueueableClass(orderHeaderId));
                }
			
				//30/04/19 START francesca.ribezzi checking if we are on editing pricing process or on changing commission model process:
				if(isPricing){
					OB_QueueableClassCheckApprovalProcesses.updateStartDatePricing(configuration.Id);
				}else if(isCommissionModel){
					OB_QueueableClassCheckApprovalProcesses.updateStartDateCommissionModel(configuration.Id);
				}
                    //30/04/19 END francesca.ribezzi

                


			}
		}
		catch(Exception ecc)
		{
			System.debug('[EXCE] OB_QueueableClassCheckApprovalProcesses '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
	}
    /**
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 30/08/2019
    *@description updating logRequest
    *@parameters: configuration Id and LogRequest status
    */
    public static void updateLogRequestStatus(Id confId, String status){
        Id logReqConsRt					    = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.CONSISTENZART ).getRecordTypeId();
        //Simone Misani  WN-380 STArt 10/09/2019
        Id logReqConftechRt					    = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.CONFIGURATORETECNICORT ).getRecordTypeId();
        List<Id> listRecordTypeId = new List<Id>();
        listRecordTypeId.add(logReqConftechRt);
        listRecordTypeId.add(logReqConsRt);
        //START francesca.ribezzi 02/09/19 changing logRequest select to List:
        List<OB_LogRequest__c> logRequestList = 	
        [ 
            SELECT  Id,OB_Status__c
            FROM OB_LogRequest__c
            WHERE OB_OrderId__c =: confId
            AND    RecordTypeId IN : listRecordTypeId
            LIMIT 1
        ];
        //Simone Misani  WN-380 STOP 10/09/2019
        if(logRequestList.size() > 0){
            for(OB_LogRequest__c logRequest : logRequestList){
                logRequest.OB_Status__c		=	status;     
            }
            update logRequestList;	
        }
        //END francesca.ribezzi 02/09/19
    }

    /**
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 30/03/2019
    *@description updating StartDate and StartValidationDate on orderItems for Edit pricing process
    */
    public static void updateStartDatePricing(Id configuration){
        List<NE__OrderItem__c> orderItems =
            [
                SELECT 
                id,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__OrderId__r.OB_AgreedChanges__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                NE__OrderId__r.OB_Variation__c,
                OB_VariationPOSPB__c,//Simone Misani 26/07/2019 WN-67
                NE__OrderId__r.OB_ApprovalType__c, //Simone Misani 26/07/2019 WN-67
                NE__Root_Order_Item__r.RecordType.DeveloperName // NEXI-246 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 31/07/2019 added field
                FROM NE__OrderItem__c 
                WHERE NE__Action__c = 'Change' 
                AND NE__OrderId__c = :configuration
            ];
        Boolean agreedChanges = false;
        String variation = '';
        DateTime mipDayPlusSixty = DateTime.Now().AddDays(60);
        Boolean isFirstDay = false;
        if(mipDayPlusSixty.day() == 1){
            isFirstDay = true;
        }
        //START--- Simone Misani 25/07/2019 WN-190
        DateTime mipDayToday = DateTime.Now();
        //Date datetoday = Date.Now();
        Integer month = DateTime.Now().month();
        Integer years = DateTime.Now().year();
        Integer countday = Date.daysInMonth(years,  month);
        Integer missingday = (countday - mipDayToday.day())+1;
        Boolean isLessTwenty = false;
        Boolean isMoreTwenty = false;
        
        if(mipDayToday.day()<= 20){
            isLessTwenty = true;
        }else{
            isMoreTwenty = true;
        }
        // Roland Nieznanski <roland.nieznanski@accenture.com> 03/09/2019 START it is used only in test methods
        if( Test.isRunningTest() )
        {
            if( isSetLessTwenty )
            {
                isLessTwenty = true;
                isFirstDay = false;
            }
            else
            {
                isMoreTwenty = true;
                isLessTwenty = false;
                isFirstDay = true;
            }

        }
        // Roland Nieznanski <roland.nieznanski@accenture.com> 03/09/2019 START it is used only in test methods

        if(orderItems.size() > 0){
            agreedChanges = orderItems[0].NE__OrderId__r.OB_AgreedChanges__c;
            variation = orderItems[0].NE__OrderId__r.OB_Variation__c;
        }      

         for(NE__OrderItem__c o : orderItems){
               
                if(o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Acquiring' ||o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Vas')// Simone Misani WN-617-15/10/2019
                {
                   if(agreedChanges || (!agreedChanges && o.OB_VariationPOSPB__c == 'MIGLIORATIVA')){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(1);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(1);
                   }else if(!agreedChanges && o.OB_VariationPOSPB__c == 'PEGGIORATIVA'){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(70);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(70);
                   }
                }else if(o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Terminali' ||o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Pagobancomat' || o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'eCommerce' || o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Moto')// Simone Misani WN-617-15/10/2019
                {
                    if(agreedChanges){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(1);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(1);
                    }else if(!agreedChanges && o.OB_VariationPOSPB__c == 'MIGLIORATIVA'&& isLessTwenty){
                        o.NE__StartDate__c =  DateTime.Now();
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now();
                    // START antonio.vatrano 25/11/2019 PROD-169
                    }else if(!agreedChanges && o.OB_VariationPOSPB__c == 'MIGLIORATIVA'&& isMoreTwenty){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(missingday);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(missingday);
                    }else if(!agreedChanges && o.OB_VariationPOSPB__c == 'PEGGIORATIVA' && isFirstDay){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(60);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(60);
                    }else if(!agreedChanges && o.OB_VariationPOSPB__c == 'PEGGIORATIVA' && !isFirstDay){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(90);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(90);
                    }
                    // END antonio.vatrano 25/11/2019 PROD-169
                }
            }//END--- Simone Misani 25/07/2019 WN-190
            try{
                update orderItems;
            }		
            catch(Exception ecc)
            {
                System.debug('[EXCE] OB_QueueableClassCheckApprovalProcesses updateStartDatePricing: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            }
    }

    /**
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 30/03/2019
    *@description updating StartDate for pricing orderItems and StartValidationDate on V/M - Edit Commission Model Process
    */
    public static void updateStartDateCommissionModel(Id configuration){
        List<NE__OrderItem__c> orderItems =
            [
            SELECT id,OB_StartValidationDate__c, NE__StartDate__c,NE__ProdId__r.OB_Codice_sfdc__c,NE__Root_Order_Item__c
            FROM NE__OrderItem__c 
            WHERE ((RecordType.developerName = 'Pricing' AND NE__Action__c = 'Add') 
            OR (NE__Root_Order_Item__c = null AND NE__ProdId__r.OB_Codice_sfdc__c = 'visamastercard'))
            AND NE__OrderId__c  = :configuration
        ];
        for(NE__OrderItem__c o : orderItems){
            if(o.NE__ProdId__r.OB_Codice_sfdc__c == 'visamastercard' && o.NE__Root_Order_Item__c == null){
                //OB_StartValidationDate__c equals to MIP send date plus one
                o.OB_StartValidationDate__c =  DateTime.Now().AddDays(1);
            }else{
                o.NE__StartDate__c =  DateTime.Now().AddDays(1);
            }
        }
        try{
            update orderItems;
        }		
        catch(Exception ecc)
        {
            System.debug('[EXCE] OB_QueueableClassCheckApprovalProcesses updateStartDateCommissionModel: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
    }


    public class customException extends Exception {

    }
}