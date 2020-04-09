global without sharing class OB_TrackingUtility {

    global class TrackingOrderRequestMaintenance
	{
		global String orderId 										{get;set;}
		global List<Acquiring> Acquiring	 					    {get;set;}
		global List<GT> GT 											{get;set;}
		global TrackingOrderRequestMaintenance()
		{
			Acquiring 		= new List<Acquiring>();
			GT 				= new List<GT>();
		}
	}

    global class Acquiring
	{
		global String source		 								{get;set;}
		global String companyCode	 								{get;set;}
		global List<ErrorList> errori								{get;set;}		
		global List<puntoVendita> PVCodes	 						{get;set;}	
		global Acquiring()
		{
			PVCodes 	= new List<puntoVendita>();
		}
	}
    
    global class puntoVendita
	{	
		global String itemId										{get;set;}		//	NON PRESENTE NEL JSON
		global String PVCode										{get;set;}		//	@Acq
		global String startDate										{get;set;}		//	@Both
		global String endDate										{get;set;}		//	@Acq
		global String reasonOfClosure								{get;set;}		//	@Acq
		global String tipo											{get;set;}		//	NON PRESENTE NEL JSON
		global String ctiCode										{get;set;}		//	@GT
		global String StabiCode										{get;set;}		//	@GT
		global String siaPVCode										{get;set;}		//	@GT
		global String siaProgressiveCode							{get;set;}		//	@GT
		global String siaMerchantCode								{get;set;}		//	@GT
		global String assistanceNumber								{get;set;}		//	@GT
		global String dataInizioAttivita							{get;set;}		//	NON PRESENTE NEL JSON
		global List<TermsIdInformation> terminalInformation         {get;set;}		//	@GT
        global List<Changes> changes                                {get;set;}
			//  @Acq
        global puntoVendita()
        {
            changes                 = new List<Changes>();
			
        }
	}

    global class GT 
	{
		global String source										{get;set;}
		global String statoProvisioning								{get;set;} //NON PRESENTE NEL JSON
		global String gtCompanyCode									{get;set;}
		global List<ErrorList> errors								{get;set;}				
		global List<puntoVendita> PVCodes 							{get;set;}
		global GT()
		{
			PVCodes 				= new List<puntoVendita>();
			errors 					= new List<ErrorList>();
		}
	}

	global class ErrorList
	{
		global String code	 									{get;set;}
		global String description 								{get;set;}
	}

	global class TermsIdInformation
	{
		global String terminalId									{get;set;}
		global String model											{get;set;}
		global String connectionType								{get;set;}
		global String modality										{get;set;}
		global String modelDescription								{get;set;}
		global String release										{get;set;}
		global String releaseDescription							{get;set;}
		global String status										{get;set;}
		global String reasonOfRejection								{get;set;}
		global String installationDate								{get;set;}		
		global String uninstallationDate							{get;set;}
		global pricingChange pricingChange     						{get;set;}//Simone Misani  WN-135 18/07/2019 //francesca.ribezzi WN-187 - 18/09/19 pricingChange is not a list 
		global List<CodiciConvenzioni> agreementCodes	 			{get;set;}
		global List<ErrorList> errors							    {get;set;}		
		global TermsIdInformation(){
            			errors 					= new List<ErrorList>(); //francesca.ribezzi WN-187 - 18/09/19 pricingChange is not a list
		}
	}
	//START----Simone Misani  WN-135 18/07/2019
	global class pricingChange
	{
        global String       status       	{get;set;}	
        global String       startDate    	{get;set;}	
      	global List<ErrorList> errors       {get;set;}
        global pricingChange()
		{
			errors 		= new List<ErrorList>(); 
		}

    }
	//END----Simone Misani  WN-135 18/07/2019
	 

	global class CodiciConvenzioni
	{
		global String idItemSalesforce 								{get;set;} //NON PRESENTE NEL JSON
		global String companyCode									{get;set;}
		global String companyName									{get;set;}
		global String code											{get;set;}
		global String causaleRifiuto								{get;set;} //Only if 'status' is 'Rifiutato'
		global String startDate									    {get;set;}
		global String endDate										{get;set;}
		global String status										{get;set;} //ADDED
	}
	
    global class Changes
    {
        global String externalId                                    {get;set;}
        global String result                                        {get;set;}
		global List<ErrorList> errors								{get;set;}
		global Changes()
        {
            errors                 = new List<ErrorList>();
        }
    }
	
    //	RESPONSE
    global class TrackingOrderResponseMaintenance
	{
		global Integer httpStatus 									{get;set;}
		global String message										{get;set;}
	}

}