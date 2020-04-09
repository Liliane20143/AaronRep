global without sharing class OB_UtilityConstants {

    // NEX-140 Michal Targiel, <michal.targiel@accenture.com>, 03/07/2019 START
    global static final String LIVIGNO = 'Livigno';
    // NEX-140 Michal Targiel, <michal.targiel@accenture.com>, 03/07/2019 STOP

    // NEX-116 wojciech.szuba@accenture.com 05/07/2019 START
    global static final String FLOW_MERCHANT = 'merchant';
    global static final String B_AND_B = 'Bed & Breakfast';
    global static final String FLOW_ORDER = 'order';
    global static final String ALBERGHI_CODE = '0004';
    global static final String FLOW_WIZARD_NAME_NUOVO_CONTRATTO = 'OB_Nuovo_Contratto';
    // NEX-116 wojciech.szuba@accenture.com 05/07/2019 STOP

    // Daniele Gandini <daniele.gandini@accenture.com>	- 15/05/2019 - TerminalsReplacement - Constants for replacement - START
    global static final String TERMINALS_REPLACEMENT = 'sostituzione terminali';
    global static final String REMOVE_ACTION = 'Remove';
    global static final String ADD_ACTION = 'Add';
    global static final String CUSTOM_MET_TECHDETAILS_USER = 'OB_TechDetailsCheckProfile';
    global static final String M_POS = 'M-POS';
    global static final String CODICE_SIA = 'Codice SIA';
    global static final String CODICE_STABILIMENTO_SIA = 'Codice Stabilimento SIA';
    global static final String PROGRESSIVO_SIA = 'Progressivo SIA';
    global static final String HEADER_SUBPROCESS_TERMINAOFFERTA = 'termina offerta'; // <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2 
    // Daniele Gandini <daniele.gandini@accenture.com> - 15/05/2019 - TerminalsReplacement - Constants for replacement - END
    global static final String PARTNER_COMMUNITY_LICENSE = 'OB_PartnerCommunityRequestor'; // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 
    global static final String BANCA = 'Banca'; // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 

    global static final String FIRST_PARAM = 'grant_type';
    global static final String SECOND_PARAM = 'client_id';
    global static final String THIRD_PARAM = 'client_secret';
    global static final String METHOD_GET = 'GET';
    global static final String METHOD_POST = 'POST';
    global static final String PREFIX = 'Bearer ';
    global static final String AUTH = 'Authorization';
    global static final String NAMED_CREDENTIAL_SERVICE = 'callout:OB_callService';
    global static final String NAMED_CREDENTIAL_TOKEN = 'callout:OB_getToken_Service';
    global static final String ERROR = 'Error';
    global static final String TRACE_ID_HEADER = 'TRACE-ID';
    global static final String CONTENT_TYPE ='Content-Type';//Simone Misani 11/07/2019 call mip
    global static final String APPLICATION_JSON ='application/json';//Simone Misani 11/07/2019 call mip

    //Start----- Simone Misani 02/07/2019 F2Wave2-82
    global static final String ACQUIRING_UPI = 'UPI';
    global static final String VAS_TAX_FREE = 'Tax Free';
    global static final String VAS_DCC = 'Servizio DCC';
    global static final String VAS_PREAUT = 'Preautorizzazione';
    


    //Start----- Simone Misani 02/07/2019 F2Wave2-82

    /** Start lea.emalieu 27/08/2018 ******/
    // Constants for OB_FlowControlUtility class
    global static final String MASTER_MERCHANT = 'Master_Merchant';
    global static final String MERCHANTRT = 'Merchant';
    global static final String BANKRT = 'Bank';
    global static final String TITOLARE_EFFETTIVO = 'Titolare_Effettivo';
    global static final String ESECUTORE = 'Esecutore';

    global static final String REFERENTE_PUNTO_VENDITA = 'Referente_Punto_Vendita';
    global static final String REFERENTE_TECNICO = 'Referente_Tecnico';
    global static final String RESPONSABILE_AMMINISTRATIVO = 'Responsabile_Amministrativo';

    global static final String ORDER = 'Order';
    global static final String DATI_SOCIETA_LEGALE = 'Dati_Societ_Legale';
    global static final String REFERENTE_AMMINISTRATIVO = 'Referente_Amministrativo';
    global static final String LEGALE_RAPPRESENTANTE = 'legale_rappresentante';
    global static final String SERVICE_POINT_FISICO = 'Fisico';
    global static final String SERVICE_POINT_VIRTUALE = 'Virtuale';

    global static final String STEP_IDENTIFICA_SOCIETA = 'IDENTIFICA_SOCIETA';
    global static final String STEP_GT = 'GT';
    global static final String STEP_OFFERTA = 'OFFERTA';
    global static final String STEP_CONDIZIONI_ECONOMICHE = 'CONDIZIONI_ECONOMICHE';
    global static final String STEP_DATI_OPERATIVI = 'DATI_OPERATIVI';
    global static final String STEP_DATI_SOCIETA = 'DATI_SOCIETA';
    global static final String STEP_TITOLARE_EFFETTIVO = 'TITOLARE_EFFETTIVO';
    global static final String STEP_PUNTO_VENDITA = 'PUNTO_VENDITA';
    global static final String STEP_CARICA_DOCUMENTI = 'CARICA_DOCUMENTI';
    global static final String STEP_SUMMARY = 'SUMMARY';

    //global static final String PRICING 							= 'PRICING';
    global static final String CARTA_DI_IDENTITA = 'Carta di Identità';
    global static final String PASSAPORTO = 'Passaporto';
    global static final String PATENTE = 'Patente';
    global static final String COMUNE = 'Comune';
    global static final String QUESTURA = 'Questura';
    global static final String PREFETTURA = 'Prefettura';
    global static final String MOTORIZZAZIONE = 'Motorizzazione';
    global static final String UCO = 'UCO';
    global static Map<String, String> MAP_STEP_FLOW = new Map<String, String>{
            STEP_IDENTIFICA_SOCIETA => '1',
            STEP_GT => '2',
            STEP_OFFERTA => '3',
            STEP_DATI_OPERATIVI => '4',
            STEP_DATI_SOCIETA => '5',
            STEP_TITOLARE_EFFETTIVO => '6',
            STEP_PUNTO_VENDITA => '7',
            STEP_CARICA_DOCUMENTI => '8',
            STEP_SUMMARY => '9'
    };
    /* End lea.emalieu 27/08/2018  ******/

    global static final String GT_NEXI = 'Nexi';
    global static final String VisaM = 'Visa/Mastercard';
    global static final String GT_NEXICAPS = 'NEXI';
    global static final String GT_OTHER = 'Other';
    global static final String PAGOBANCOMAT = 'Pagobancomat';
    global static final String POS_TERZI_ATTENDED = 'POS_TERZI_ATTENDED';
    global static final String POS_TERZI_UNATTENDED = 'POS_TERZI_UNATTENDED';
    global static final String EQUENS = 'EQUENS';
    global static final String SIA = 'SIA';
    global static final String PAGOBANCOMAT_BANCARIO = 'Pagobancomat bancario';
    global static final String PAGOBANCOMAT_SUBLICENZA = 'Pagobancomat sub-licenza';
    global static final String PREPAGATO = 'Prepagato';
    global static final String POSTPAGATO = 'Postpagato';
    global static final String ACQUIRING = 'Acquiring';

    global static final String SERVICEPOINTSZERO = '[]';
    global static final String SERVICEPOINTSONE = '[{"ServicePoint": { "action": "add", "id": "1", "acquiringCode": "KMAPS:1234567", "GTCode": "TVB:1234567", "shopName": "Bulgari", "Address": {"street": "VIALE DEI MILLE","civicNumber": "31","careOf": "string","postalCode": "20129","city": "MILANO","province": "MILANO","country": "ITALIA","district": "string" }, "PhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456" }, "MobilePhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456" }, "FaxNumber": {"callingCode": "+39","prefix": "0571","number": "123456" }, "merchantCategoryCode": "5947", "isHotel": true, "isCarRental": true, "receiptHeader": "string", "receiptLocation": "string", "startOfBusinessActivity": "2018-06-30", "endOfBusinessActivity": "2018-06-30", "paymentModel": "net", "reportType": "electronic", "TechnicalContact": {"action": "add","type": "executor","firstName": "string","lastName": "string","birthDate": "2018-06-25","birthCity": "string","birthProvince": "string","birthCountry": "string","fiscalCode": "string","gender": "M","PhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"MobilePhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"FaxNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"ResidenceAddress": {"street": "string","civicNumber": "string","careOf": "string","postalCode": "string","city": "string","province": "string","country": "string","district": "string"},"PersonalDocument": {"type": "string","number": "string","releaseDate": "2018-06-25","expirationDate": "2018-06-25","releaseAuthority": "comune","releaseCity": "string","releaseProvince": "string","releaseCountry": "string"},"citizenship": "string","flagPEP": true }, "email": "string", "PEC": "string", "uniqueCustomerCode": "string", "ownerCondi": "maintenance", "contractFormABI": "string", "contractReleaseFormABI": "string", "flagPrivacyC3": true, "flagPrivacyC4": true, "flagPrivacyC5": true, "openingTimes": {"openingHour": "08:00","closingHour": "18:30","startBreak": "13:00","endBreak": "14:30","startSeasonalActivity": "2018-06-25","endSeasonalActivity": "2018-06-30","closingDays": {"mondayMorning": true,"mondayAfternoon": true,"tuesdayMorning": true,"tuesdayAfternoon": true,"wednesdayMorning": true,"wednesdayAfternoon": true,"thursdayMorning": true,"thursdayAfternoon": true,"fridayMorning": true,"fridayAfternoon": true,"saturdayMorning": true,"saturdayAfternoon": true,"sundayMorning": true,"sundayAfternoon": true} }, "RACSIA": "string", "service": "POS", "orderNote": "string", "BankAccountDetails": {"action": "add","iban": "string","accountHolder": "string" }, "Terminals": [{"action": "add","id": "string","ownerABI": "string","enablements": [ {"action": "add","name": "DCC","value": "string","oldValue": "string" }],"terminalOffers": [ {"id": "string","name": "POS Tradizionale SMART","type": "string","technicalSolutionCode": "string","property": "string","hasSIM": true,"SIMProperty": "string","managerCode": "string","Pricing": [{ "code": "CANONE DI LOCAZIONE", "description": "string", "family": "CANONE", "startDate": "2018-06-25", "endDate": "2018-06-30", "attributes": [{"name": "Importo","value": "10 EUR"} ]}] }]} ], "Acquiring": {"action": "add","VisaMastercard": {"id": "string","technicalSolutionCode": "string","code": "string","Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]},"AMEX": {"id": "string","technicalSolutionCode": "string","conventionCode": "string","Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]},"JCB": {"id": "string","technicalSolutionCode": "string","code": "string","Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]},"PagoBancomat": {"id": "string","stipulationDate": "2018-06-25","siaCode": "string","siaStab": "string","siaProg": "string","rate": 0,"Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]} }, "VAS": [{"action": "add","id": "string","name": "Get Your Bill","technicalSolutionCode": "string","mode": "Diretta","stipulationDate": "2018-06-25","Pricing": { "code": "CANONE DI LOCAZIONE", "description": "string", "family": "CANONE", "startDate": "2018-06-25", "endDate": "2018-06-30", "attributes": [{"name": "Importo","value": "10 EUR"} ]}} ], "Modalities": [{"action": "add","id": "string","name": "LORDO NEXI","technicalSolutionCode": "string"} ], "PagoBancomat": {"id": "string","stipulationDate": "2018-06-25","rate": 0,"Pricing": [{ "code": "CANONE DI LOCAZIONE", "description": "string", "family": "CANONE", "startDate": "2018-06-25", "endDate": "2018-06-30", "attributes": [{"name": "Importo","value": "10 EUR"} ]}] }},"TechnicalParams": [ {"servicePointCode": "string","paymentModel": "net","isHotel": true,"isCarRental": true,"endOfBusinessActivity": "2018-06-30","lastVariation": "2018-06-30","flagP": true,"ABICondi": "string","isReferral": true }]} ]';

    global static final String SERVICEPOINTSTWO = '[{"ServicePoint": { "action": "add", "id": "1", "acquiringCode": "KMAPS:1234567", "GTCode": "TVB:1234567", "shopName": "Armani", "Address": {"street": "VIALE DEI MILLE","civicNumber": "31","careOf": "string","postalCode": "20129","city": "MILANO","province": "MILANO","country": "ITALIA","district": "string" }, "PhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456" }, "MobilePhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456" }, "FaxNumber": {"callingCode": "+39","prefix": "0571","number": "123456" }, "merchantCategoryCode": "5947", "isHotel": true, "isCarRental": true, "receiptHeader": "string", "receiptLocation": "string", "startOfBusinessActivity": "2018-06-30", "endOfBusinessActivity": "2018-06-30", "paymentModel": "net", "reportType": "electronic", "TechnicalContact": {"action": "add","type": "executor","firstName": "string","lastName": "string","birthDate": "2018-06-25","birthCity": "string","birthProvince": "string","birthCountry": "string","fiscalCode": "string","gender": "M","PhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"MobilePhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"FaxNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"ResidenceAddress": {"street": "string","civicNumber": "string","careOf": "string","postalCode": "string","city": "string","province": "string","country": "string","district": "string"},"PersonalDocument": {"type": "string","number": "string","releaseDate": "2018-06-25","expirationDate": "2018-06-25","releaseAuthority": "comune","releaseCity": "string","releaseProvince": "string","releaseCountry": "string"},"citizenship": "string","flagPEP": true }, "email": "string", "PEC": "string", "uniqueCustomerCode": "string", "ownerCondi": "maintenance", "contractFormABI": "string", "contractReleaseFormABI": "string", "flagPrivacyC3": true, "flagPrivacyC4": true, "flagPrivacyC5": true, "openingTimes": {"openingHour": "08:00","closingHour": "18:30","startBreak": "13:00","endBreak": "14:30","startSeasonalActivity": "2018-06-25","endSeasonalActivity": "2018-06-30","closingDays": {"mondayMorning": true,"mondayAfternoon": true,"tuesdayMorning": true,"tuesdayAfternoon": true,"wednesdayMorning": true,"wednesdayAfternoon": true,"thursdayMorning": true,"thursdayAfternoon": true,"fridayMorning": true,"fridayAfternoon": true,"saturdayMorning": true,"saturdayAfternoon": true,"sundayMorning": true,"sundayAfternoon": true} }, "RACSIA": "string", "service": "POS", "orderNote": "string", "BankAccountDetails": {"action": "add","iban": "string","accountHolder": "string" }, "Terminals": [{"action": "add","id": "string","ownerABI": "string","enablements": [ {"action": "add","name": "DCC","value": "string","oldValue": "string" }],"terminalOffers": [ {"id": "string","name": "POS Tradizionale SMART","type": "string","technicalSolutionCode": "string","property": "string","hasSIM": true,"SIMProperty": "string","managerCode": "string","Pricing": [{ "code": "CANONE DI LOCAZIONE", "description": "string", "family": "CANONE", "startDate": "2018-06-25", "endDate": "2018-06-30", "attributes": [{"name": "Importo","value": "10 EUR"} ]}] }]} ], "Acquiring": {"action": "add","VisaMastercard": {"id": "string","technicalSolutionCode": "string","code": "string","Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]},"AMEX": {"id": "string","technicalSolutionCode": "string","conventionCode": "string","Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]},"JCB": {"id": "string","technicalSolutionCode": "string","code": "string","Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]},"PagoBancomat": {"id": "string","stipulationDate": "2018-06-25","siaCode": "string","siaStab": "string","siaProg": "string","rate": 0,"Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]} }, "VAS": [{"action": "add","id": "string","name": "Get Your Bill","technicalSolutionCode": "string","mode": "Diretta","stipulationDate": "2018-06-25","Pricing": { "code": "CANONE DI LOCAZIONE", "description": "string", "family": "CANONE", "startDate": "2018-06-25", "endDate": "2018-06-30", "attributes": [{"name": "Importo","value": "10 EUR"} ]}} ], "Modalities": [{"action": "add","id": "string","name": "LORDO NEXI","technicalSolutionCode": "string"} ], "PagoBancomat": {"id": "string","stipulationDate": "2018-06-25","rate": 0,"Pricing": [{ "code": "CANONE DI LOCAZIONE", "description": "string", "family": "CANONE", "startDate": "2018-06-25", "endDate": "2018-06-30", "attributes": [{"name": "Importo","value": "10 EUR"} ]}] }},"TechnicalParams": [ {"servicePointCode": "string","paymentModel": "net","isHotel": true,"isCarRental": true,"endOfBusinessActivity": "2018-06-30","lastVariation": "2018-06-30","flagP": true,"ABICondi": "string","isReferral": true }]},{"ServicePoint": { "action": "add", "id": "2", "acquiringCode": "KMAPS:1234567", "GTCode": "TVB:1234567", "shopName": "Bulgari", "Address": {"street": "VIALE DEI MILLE","civicNumber": "32","careOf": "string","postalCode": "20129","city": "MILANO","province": "MILANO","country": "ITALIA","district": "string" }, "PhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456" }, "MobilePhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456" }, "FaxNumber": {"callingCode": "+39","prefix": "0571","number": "123456" }, "merchantCategoryCode": "5947", "isHotel": true, "isCarRental": true, "receiptHeader": "string", "receiptLocation": "string", "startOfBusinessActivity": "2018-06-30", "endOfBusinessActivity": "2018-06-30", "paymentModel": "net", "reportType": "electronic", "TechnicalContact": {"action": "add","type": "executor","firstName": "string","lastName": "string","birthDate": "2018-06-25","birthCity": "string","birthProvince": "string","birthCountry": "string","fiscalCode": "string","gender": "M","PhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"MobilePhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"FaxNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"ResidenceAddress": {"street": "string","civicNumber": "string","careOf": "string","postalCode": "string","city": "string","province": "string","country": "string","district": "string"},"PersonalDocument": {"type": "string","number": "string","releaseDate": "2018-06-25","expirationDate": "2018-06-25","releaseAuthority": "comune","releaseCity": "string","releaseProvince": "string","releaseCountry": "string"},"citizenship": "string","flagPEP": true }, "email": "string", "PEC": "string", "uniqueCustomerCode": "string", "ownerCondi": "maintenance", "contractFormABI": "string", "contractReleaseFormABI": "string", "flagPrivacyC3": true, "flagPrivacyC4": true, "flagPrivacyC5": true, "openingTimes": {"openingHour": "08:00","closingHour": "18:30","startBreak": "13:00","endBreak": "14:30","startSeasonalActivity": "2018-06-25","endSeasonalActivity": "2018-06-30","closingDays": {"mondayMorning": true,"mondayAfternoon": true,"tuesdayMorning": true,"tuesdayAfternoon": true,"wednesdayMorning": true,"wednesdayAfternoon": true,"thursdayMorning": true,"thursdayAfternoon": true,"fridayMorning": true,"fridayAfternoon": true,"saturdayMorning": true,"saturdayAfternoon": true,"sundayMorning": true,"sundayAfternoon": true} }, "RACSIA": "string", "service": "POS", "orderNote": "string", "BankAccountDetails": {"action": "add","iban": "string","accountHolder": "string" }, "Terminals": [{"action": "add","id": "string","ownerABI": "string","enablements": [ {"action": "add","name": "DCC","value": "string","oldValue": "string" }],"terminalOffers": [ {"id": "string","name": "POS Tradizionale SMART","type": "string","technicalSolutionCode": "string","property": "string","hasSIM": true,"SIMProperty": "string","managerCode": "string","Pricing": [{ "code": "CANONE DI LOCAZIONE", "description": "string", "family": "CANONE", "startDate": "2018-06-25", "endDate": "2018-06-30", "attributes": [{"name": "Importo","value": "10 EUR"} ]}] }]} ], "Acquiring": {"action": "add","VisaMastercard": {"id": "string","technicalSolutionCode": "string","code": "string","Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]},"AMEX": {"id": "string","technicalSolutionCode": "string","conventionCode": "string","Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]},"JCB": {"id": "string","technicalSolutionCode": "string","code": "string","Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]},"PagoBancomat": {"id": "string","stipulationDate": "2018-06-25","siaCode": "string","siaStab": "string","siaProg": "string","rate": 0,"Pricing": [ {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{ "name": "Importo", "value": "10 EUR"}] }]} }, "VAS": [{"action": "add","id": "string","name": "Get Your Bill","technicalSolutionCode": "string","mode": "Diretta","stipulationDate": "2018-06-25","Pricing": { "code": "CANONE DI LOCAZIONE", "description": "string", "family": "CANONE", "startDate": "2018-06-25", "endDate": "2018-06-30", "attributes": [{"name": "Importo","value": "10 EUR"} ]}} ], "Modalities": [{"action": "add","id": "string","name": "LORDO NEXI","technicalSolutionCode": "string"} ], "PagoBancomat": {"id": "string","stipulationDate": "2018-06-25","rate": 0,"Pricing": [{ "code": "CANONE DI LOCAZIONE", "description": "string", "family": "CANONE", "startDate": "2018-06-25", "endDate": "2018-06-30", "attributes": [{"name": "Importo","value": "10 EUR"} ]}] }},"TechnicalParams": [ {"servicePointCode": "string","paymentModel": "net","isHotel": true,"isCarRental": true,"endOfBusinessActivity": "2018-06-30","lastVariation": "2018-06-30","flagP": true,"ABICondi": "string","isReferral": true }]} ]';

    global static final String SERVICEPOINTSTEST = '{"ServicePoint": {"action": "add","id": "string","acquiringCode": "KMAPS:1234567","GTCode": "TVB:1234567","shopName": "string","Address": {"street": "string","civicNumber": "string","careOf": "string","postalCode": "string","city": "string","province": "string","country": "string","district": "string"},"PhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"MobilePhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"FaxNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"merchantCategoryCode": "string","isHotel": true,"isCarRental": true,"receiptHeader": "string","receiptLocation": "string","startOfBusinessActivity": "2018-06-30","endOfBusinessActivity": "2018-06-30","paymentModel": "net","reportType": "electronic","TechnicalContact": {"action": "add","type": "executor","firstName": "string","lastName": "string","birthDate": "2018-06-25","birthCity": "string","birthProvince": "string","birthCountry": "string","fiscalCode": "string","gender": "M","PhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"MobilePhoneNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"FaxNumber": {"callingCode": "+39","prefix": "0571","number": "123456"},"ResidenceAddress": {"street": "string","civicNumber": "string","careOf": "string","postalCode": "string","city": "string","province": "string","country": "string","district": "string"},"PersonalDocument": {"type": "string","number": "string","releaseDate": "2018-06-25","expirationDate": "2018-06-25","releaseAuthority": "comune","releaseCity": "string","releaseProvince": "string","releaseCountry": "string"},"citizenship": "string","flagPEP": true},"email": "string","PEC": "string","uniqueCustomerCode": "string","ownerCondi": "maintenance","contractFormABI": "string","contractReleaseFormABI": "string","flagPrivacyC3": true,"flagPrivacyC4": true,"flagPrivacyC5": true,"openingTimes": {"openingHour": "08:00","closingHour": "18:30","startBreak": "13:00","endBreak": "14:30","startSeasonalActivity": "2018-06-25","endSeasonalActivity": "2018-06-30","closingDays": {"mondayMorning": true,"mondayAfternoon": true,"tuesdayMorning": true,"tuesdayAfternoon": true,"wednesdayMorning": true,"wednesdayAfternoon": true,"thursdayMorning": true,"thursdayAfternoon": true,"fridayMorning": true,"fridayAfternoon": true,"saturdayMorning": true,"saturdayAfternoon": true,"sundayMorning": true,"sundayAfternoon": true}},"RACSIA": "string","service": "POS","orderNote": "string","BankAccountDetails": {"action": "add","iban": "string","accountHolder": "string"},"Terminals": [{"action": "add","id": "string","ownerABI": "string","enablements": [{"action": "add","name": "DCC","value": "string","oldValue": "string"}],"terminalOffers": [{"id": "string","name": "POS Tradizionale SMART","type": "string","technicalSolutionCode": "string","property": "string","hasSIM": true,"SIMProperty": "string","managerCode": "string","Pricing": [{"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{"name": "Importo","value": "10 EUR"}]}]}]}],"Acquiring": {"action": "add","VisaMastercard": {"id": "string","technicalSolutionCode": "string","code": "string","Pricing": [{"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{"name": "Importo","value": "10 EUR"}]}]},"AMEX": {"id": "string","technicalSolutionCode": "string","conventionCode": "string","Pricing": [{"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{"name": "Importo","value": "10 EUR"}]}]},"JCB": {"id": "string","technicalSolutionCode": "string","code": "string","Pricing": [{"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{"name": "Importo","value": "10 EUR"}]}]},"PagoBancomat": {"id": "string","stipulationDate": "2018-06-25","siaCode": "string","siaStab": "string","siaProg": "string","rate": 0,"Pricing": [{"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{"name": "Importo","value":"10EUR"}]}]}},"VAS":[{"action":"add","id":"string","name":"Get Your Bill","technicalSolutionCode": "string","mode": "Diretta","stipulationDate": "2018-06-25","Pricing": {"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{"name": "Importo","value": "10 EUR"}]}}],"Modalities": [{"action": "add","id": "string","name": "LORDO NEXI","technicalSolutionCode": "string"}],"PagoBancomat": {"id": "string","stipulationDate": "2018-06-25","rate": 0,"Pricing": [{"code": "CANONE DI LOCAZIONE","description": "string","family": "CANONE","startDate": "2018-06-25","endDate": "2018-06-30","attributes": [{"name": "Importo","value": "10 EUR"}]}]}},"TechnicalParams": [{"servicePointCode": "string","paymentModel": "net","isHotel": true,"isCarRental": true,"endOfBusinessActivity": "2018-06-30","lastVariation": "2018-06-30","flagP": true,"ABICondi": "string","isReferral": true}]}';

    global static final String TESTSERVICE = '{"ServicePoint": {"action": "add","id": "pippo","acquiringCode": "KMAPS:1234567","GTCode": "TVB:1234567"}}';
    global static final String EMPTYOBJ = '{}';
    global static final String NEWRESPONSESERVICEPOINT = '{"salePoints":[{"shopName":"insegna","receiptHeader":"insegnascontrino","receiptLocation":"indirizzoscontrino","type":"FISICO","merchantCategoryCode":"7894","address":{"street":"VIAIVNOVEMBRE","civicNumber":"4","careOf":"centrocommercialeItalMark","postalCode":"14100","city":"Assago","province":"MI","country":"ITA"},"acquiringDetails":[{"acquiringCode":"5555","companyCode":"3333","moto":true,"processor":"EQUENS","activityStartDate":"2018-06-25","updatedDate":"2018-06-25","pricingType":"STANDARD","eCommerceType":"OneClick","distinctiveServices":{"isCarRental":true,"isHotel":true},"settlementMethods":[{"mode":"NETTO","schema":"00"}],"abiCondi":["9876"]}],"posDetails":[{"gtCompanyCode":"3334","gtSalePointCode":"2222","gtCode":"NEXI","agreementCodes":[{"code":"AMEX","processor":"EQUENS"}]}]}]}';

    global static final String NEWRESPONSESERVICEPOINTTWO = '{"salePoints":[{"shopName":"insegna","receiptHeader":"insegnascontrino","receiptLocation":"indirizzoscontrino","type":"FISICO","merchantCategoryCode":"7894","address":{"street":"VIAIVNOVEMBRE","civicNumber":"4","careOf":"centrocommercialeItalMark","postalCode":"14100","city":"Assago","province":"MI","country":"ITA"},"acquiringDetails":[{"acquiringCode":"5555","companyCode":"3333","moto":true,"processor":"EQUENS","activityStartDate":"2018-06-25","updatedDate":"2018-06-25","pricingType":"STANDARD","eCommerceType":"OneClick","distinctiveServices":{"isCarRental":true,"isHotel":true},"settlementMethods":[{"mode":"NETTO","schema":"00"}],"abiCondi":["9876"]}],"posDetails":[{"gtCompanyCode":"3334","gtSalePointCode":"2222","gtCode":"NEXI","agreementCodes":[{"code":"AMEX","processor":"EQUENS"}]}]},{"shopName":"insegna 2","receiptHeader":"insegnascontrino 2","receiptLocation":"indirizzoscontrino 2","type":"FISICO 2","merchantCategoryCode":"7942","address":{"street":"VIAIVNOVEMBRE 2","civicNumber":"4 2","careOf":"centrocommercialeItalMark 2","postalCode":"14100","city":"Assago","province":"MI","country":"ITA"},"acquiringDetails":[{"acquiringCode":"5555","companyCode":"3333","moto":true,"processor":"EQUENS","activityStartDate":"2018-06-25","updatedDate":"2018-06-25","pricingType":"STANDARD","eCommerceType":"OneClick","distinctiveServices":{"isCarRental":true,"isHotel":true},"settlementMethods":[{"mode":"NETTO","schema":"00"}],"abiCondi":["9876"]}],"posDetails":[{"gtCompanyCode":"3334","gtSalePointCode":"2222","gtCode":"NEXI","agreementCodes":[{"code":"AMEX","processor":"EQUENS"}]}]}]}';

    global static final String MERCHANTZERO = '[]';
    global static final String MERCHANTONE = '{"pgId": "89999999","fiscalCode": "VRDFNC90P01D969G","vatCode": "01101170009","name": "Esselunga","legalForm": "DITTA_INDIVIDUALE","PEC": "mario.rossi@pec.it","yearConstitutionCompany": 2018,"companyRegistrationNumber": "000309406","provinceChamberOfCommerce": "CN","commoditySectorCodeSAE": "430","atecoCode": "4651","RegisteredOfficeAddress": {"street": "VIA IV NOVEMBRE","civicNumber": "4","careOf": "centro commerciale ItalMark","postalCode": "14100","city": "Assago","province": "MI","country": "ITALIA"},"InvoicingAddress": {"street": "VIA IV NOVEMBRE","civicNumber": "4","careOf": "centro commerciale ItalMark","postalCode": "14100","city": "Assago","province": "MI","country": "ITALIA"},"AdmistrativeAddress": {"street": "VIA IV NOVEMBRE","civicNumber": "4","careOf": "centro commerciale ItalMark","postalCode": "14100","city": "Assago","province": "MI","country": "ITALIA"},"Acquiring": [{"socId": "79999999","processor": "EQUENS","activityStartDate": "2017-04-26","updatedDate": "2018-08-31","pricingType": "STANDARD","typeOfAccountStatement": "SOCIETA_CUMULATIVO"}],"POS": [{"clientId": "123456789","gt": "NEXI","updatedDate": "2018-09-06"}],"result": 0 }';

    global static final String MERCHANTTWO = '{"pgId": "89999999","fiscalCode": "VRDFNC90P01D969G","vatCode": "01101170009","name": "Esselunga","legalForm": "DITTA_INDIVIDUALE","PEC": "mario.rossi@pec.it","yearConstitutionCompany": 2018,"companyRegistrationNumber": "000309406","provinceChamberOfCommerce": "CN","commoditySectorCodeSAE": "430","atecoCode": "4651","RegisteredOfficeAddress": {"street": "VIA IV NOVEMBRE","civicNumber": "4","careOf": "centro commerciale ItalMark","postalCode": "14100","city": "Assago","province": "MI","country": "ITALIA"},"InvoicingAddress": {"street": "VIA IV NOVEMBRE","civicNumber": "4","careOf": "centro commerciale ItalMark","postalCode": "14100","city": "Assago","province": "MI","country": "ITALIA"},"AdmistrativeAddress": {"street": "VIA IV NOVEMBRE","civicNumber": "4","careOf": "centro commerciale ItalMark","postalCode": "14100","city": "Assago","province": "MI","country": "ITALIA"},"Acquiring": [{"socId": "79999999","processor": "EQUENS","activityStartDate": "2017-04-26","updatedDate": "2018-08-31","pricingType": "STANDARD","typeOfAccountStatement": "SOCIETA_CUMULATIVO"}],"POS": [{"clientId": "123456789","gt": "NEXI","updatedDate": "2018-09-06"}],"result": 0 }';

    global static final String MERCHANTONERROR = '{"pgId":"","fiscalCode":"","vatCode":"","name":"","legalForm":"","PEC":"","yearConstitutionCompany":"","companyRegistrationNumber":"","provinceChamberOfCommerce":"",	"commoditySectorCodeSAE":"","atecoCode":"",	"RegisteredOfficeAddress":{"street":"","civicNumber":"","careOf":"","postalCode":"","city":"","province":"","country":""},"InvoicingAddress":{"street":"","civicNumber":"","careOf":"","postalCode":"","city":"","province":"","country":""	},"AdmistrativeAddress":{"street":"","civicNumber":"","careOf":"","postalCode":"","city":"","province":"","country":""},"Acquiring":[{"socId":"","processor":"","activityStartDate":"","updatedDate":"","pricingType":"","typeOfAccountStatement":""}],	"POS":[{"clientId":"","gt":"","updatedDate":""}],"result":1}';
    //GIOVANNI SPINELLI 05-09-2018
    /*constant map of merchant and service point value to control;
      string is the node of object data map and in the list the are its values */
    global static final String BANK = 'bank';
    global static final String USER = 'user';
    global static final String MERCHANT = 'merchant';
    global static final String SERVICEPOINT = 'pv';
    global static final String CONFIGURATION = 'Configuration';
    global static final String ORDERHEADER = 'OrderHeader';
    global static final String SERVICEPOINTEE = 'pvee';
    global static final String BILLINGPROFILE = 'BillingProfilePOS';
    global static final String CONTACTONE = 'contact1';
    global static final String CONTACTTWO = 'contact2';
    global static final String CONTACTTHREE = 'contact3';
    global static final String CONTACTFOUR = 'contact4';
    global static final String CONTACTFIVE = 'contact5';
    global static final String CONTACTSIX = 'contact6';
    global static final String CONTACTONEEE = 'contact1EE';
    global static final String CONTACTTWOEE = 'contact2EE';
    global static final String CONTACTTHREEEE = 'contact3EE';
    global static final String CONTACTFOUREE = 'contact4EE';
    global static final String CONTACTFIVEEE = 'contact5EE';
    global static final String CONTACTSIXEE = 'contact6EE';
    global static final String MAINTACCOUNT = 'acc';
    global static final String MAINTLEGALADDRESS = 'legalOffice';
    global static final String MAINTEXECUTOR = 'executor';
    global static final String MAINTEXECUTOREE = 'executorEE';
    global static final String LEGALE_RAPPRESENTANTEEE = 'legale_rappresentanteee';

    // DG - 15/03/2019
    global static final String CONTRACT_TEMPLATE_NAME_MFAPos = 'Modulo Funzionalità aggiuntive POS';
    /**GIOVANNI SPINELLI 15/11/2018 START**/
    global static final String APPROVAZIONE_PRICING = ' - Approvazione Pricing';
    //	micol.ferrari 24/12/2018
    global static final String APPROVAZIONE_PRICING_L2 = ' - Approvazione Pricing L2'; //R1F2_RP_004 21.03.2019 Z. Urban <z.urban@accenture.com> Add value
    global static final String APPROVAZIONE_PRICING_L3 = ' - Approvazione Pricing L3'; //R1F2_RP_004 21.03.2019 Z. Urban <z.urban@accenture.com> Add value
    global static final String L1 = 'L1'; //R1F2_RP_012 01.04.2019 Z. Urban <z.urban@accenture.com> Add value
    global static final String L2 = 'L2'; //R1F2_RP_012 21.03.2019 Z. Urban <z.urban@accenture.com> Add value
    global static final String L3 = 'L3'; //R1F2_RP_012 21.03.2019 Z. Urban <z.urban@accenture.com> Add value
    global static final String BIO = 'BIO'; //R1F2_RP_004 21.03.2019 Z. Urban <z.urban@accenture.com> Add value
    global static final String APPROVAZIONE_BIO = ' - Approvazione BIO';
    
    // ANDREA MORITTU START 08-Nov-2019  - EVO_BACKLOG - 143
    global static final String AMEX_PRODUCT_NAME = 'AMEX';
    // ANDREA MORITTU END 08-Nov-2019  - EVO_BACKLOG - 143
    
    /**GIOVANNI SPINELLI 15/11/2018 START**/
    
    //10/07/19 francesca.ribezzi adding lineAttributeList for Dati Operativi
    global static final List<String> LINEITEMATTRNAMELIST = new List<String>{'SimCard','PinPad','Soluzione Tecnica','Proprietà','URL','APP','Paymail'};
    global static final Map<String, Map<String, String>> MANDATORYINPUTMAP = new Map<String, Map<String, String>>{
            BANK => new Map<String, String>{
                    'OB_ABI__c' => 'ABI'
            },
            ORDERHEADER => new Map<String, String>{
                    'OB_NDG__c' => 'NDGOrderHeader'
            },
            //START gianluigi.virga 15/07/2019 - BACKLOG-153
            CONFIGURATION => new Map<String, String>{
                    'OB_Check_in_date__c' => 'orderCheckInDate'
            },
            //END gianluigi.virga
            USER => new Map<String, String>{
                    'OB_CAB__c' => 'CAB'
            },
            MERCHANT => new Map<String, String>{
                    'NE__VAT__c' => 'vat',
                    'NE__Fiscal_code__c' => 'fiscalCode',
                    'Name' => 'name',
                    'NE__E_mail__c' => 'eMail',
                    'OB_DescriptionVATNotPresent__c' => 'typeOfCompany',
                    'Phone' => 'phone',
                    'OB_Employees_Number__c' => 'employeesNumber',
                    'OB_Annual_Revenue__c' => 'annualRevenue'
            },
            SERVICEPOINT => new Map<String, String>{
                    'Name' => 'namePv',
                    'OB_MCC_Description__c' => 'mccDescription',
                    'NE__Province__c' => 'provincia',
                    'NE__City__c' => 'comune',
                    'NE__Street__c' => 'strada',
                    'OB_Street_Number__c' => 'civico',
                    'OB_Typology__c' => 'typologySP',
                	//Doris Dongmo - Start
                	'NE__Zip_Code__c' =>'zipcode'
                	//Doris Dongmo - END

            },
            SERVICEPOINTEE => new Map<String, String>{
                    'Name' => 'namePv',
                    'OB_MCC_Description__c' => 'mccDescription',
                    'OB_Typology__c' => 'typologySP',
                    'OB_Street_Number__c' => 'civicoEE',
                    //'NE__Province__c'                =>'provinceEE',
                    'NE__City__c' => 'cityEE',
                    'NE__Street__c' => 'streetEE'

            }
    };
    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPCOMPANYDATA = new Map<String, Map<String, String>>{

            MERCHANT => new Map<String, String>{
                    'OB_Legal_Address_State__c' => 'provinciaSedeLegale',
                    'OB_Legal_Address_City__c' => 'comuneSedeLegale',
                    'OB_Legal_Address_Street__c' => 'stradaSedeLegale',
                    'OB_Legal_Address_Street_Number__c' => 'civicoSedeLegale',
                    'OB_Administrative_Office_State__c' => 'provinciasedeAmministrativa',
                    'OB_Administrative_Office_City__c' => 'comunesedeAmministrativa',
                    'OB_Administrative_Office_Street__c' => 'stradasedeAmministrativa',
                    'OB_Administrative_Office_Street_number__c' => 'civicosedeAmministrativa',
                    'OB_SAE_Code__c' => 'SAE',
                    'OB_Legal_Form__c' => 'FormaGiuridica'
            },
            LEGALE_RAPPRESENTANTE => new Map<String, String>{
                    'OB_Address_State__c' => 'provincialegaleRappresentante',
                    'OB_Address_City__c' => 'comunelegaleRappresentante',
                    'OB_Address_Street__c' => 'stradalegaleRappresentante',
                    'OB_Address_Street_Number__c' => 'civicolegaleRappresentante',
					//Doris Dongmo . Start-16/05/2019
					'OB_Address_PostalCode__c' => 'zipcodelegaleRappresentante',
					//Doris Dongmo . End  - 16/05/2019
                    'OB_Document_Release_State__c' => 'provincialegaleRappDoc',
                    'OB_Document_Release_City__c' => 'comunelegaleRappDoc',
                    'OB_Birth_State__c' => 'provincialegaleRappBirth',
                    'OB_Birth_City__c' => 'comunelegaleRappBirth',
                    'OB_Document_Type__c' => 'documentTypelegaleRappDoc',
                    'OB_Birth_Date__c' => 'birthDatelegaleRappDoc',
                    'OB_Document_Number__c' => 'documentNumberlegaleRappDoc',
                    'OB_Document_Release_Authority__c' => 'documentAuthlegaleRappDoc',
                    'OB_Document_Release_Date__c' => 'documentReleaseDatelegaleRappDoc',
                    'OB_Document_Expiration_Date__c' => 'documentExpirationDatelegaleRappDoc'
            },

            LEGALE_RAPPRESENTANTEEE => new Map<String, String>{
                    'OB_Address_City__c' => 'cityEElegaleRappresentante',
                    'OB_Address_Street__c' => 'streetEElegaleRappresentante',
                    'OB_Address_Street_Number__c' => 'civicoEElegaleRappresentante',
                    'OB_Document_Release_City__c' => 'cityEElegaleRappDoc',
                    'OB_Birth_City__c' => 'cityEElegaleRappBirth'
            },
            //START - elena.preteni 17/07/2019 F3 ABI mandatory
            BANK => new  Map<String, String>{
                    'OB_ABI__c' =>'ABI'
            }
            //END - elena.preteni 17/07/2019 F3 ABI mandatory
    };
    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPOPERATIONALDATA = new Map<String, Map<String, String>>{
            BILLINGPROFILE => new Map<String, String>{
                    'OB_CountryCode__c' => 'countryCode',
                    'OB_EuroControlCode__c' => 'euroControlCode',
                    'OB_CINCode__c' => 'cin',
                    'OB_ABICode__c' => 'abi',
                    'OB_CABCode__c' => 'cab',
                    'OB_Bank_Account_Number__c' => 'bankAccountNumber',
                    'OB_HeaderInternational__c' => 'headerInternational'
            }
    };

    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPTITOLARE1 = new Map<String, Map<String, String>>{
            CONTACTONE => new Map<String, String>{
                    'OB_Address_State__c' => 'provinciacontact1Full',
                    'OB_Address_City__c' => 'comunecontact1Full',
                    'OB_Address_Street__c' => 'stradacontact1Full',
                    'OB_Address_Street_Number__c' => 'civicocontact1Full',
                    'OB_Document_Release_State__c' => 'provinciacontact1Doc',
                    'OB_Document_Release_City__c' => 'comunecontact1Doc',
                    'OB_Birth_State__c' => 'provinciacontact1Birth',
                    'OB_Birth_City__c' => 'comunecontact1Birth',
                    'OB_Document_Type__c' => 'documentTypecontact1Doc',
                    'OB_Birth_Date__c' => 'birthDatecontact1Doc',
                    'OB_Document_Number__c' => 'documentNumbercontact1Doc',
                    'OB_Document_Release_Authority__c' => 'documentAuthcontact1Doc',
                    'OB_Document_Release_Date__c' => 'documentReleaseDatecontact1Doc',
                    'OB_Document_Expiration_Date__c' => 'documentExpirationDatecontact1Doc'
            },
            CONTACTONEEE => new Map<String, String>{
                    'OB_Address_City__c' => 'cityEEcontact1Full',
                    'OB_Address_Street__c' => 'streetEEcontact1Full',
                    'OB_Address_Street_Number__c' => 'civicoEEcontact1Full',
                    'OB_Document_Release_City__c' => 'cityEEcontact1Doc',
                    'OB_Birth_City__c' => 'cityEEcontact1Birth'
            }
    };

    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPTITOLARE2 = new Map<String, Map<String, String>>{
            CONTACTTWO => new Map<String, String>{
                    'OB_Address_State__c' => 'provinciacontact2Full',
                    'OB_Address_City__c' => 'comunecontact2Full',
                    'OB_Address_Street__c' => 'stradacontact2Full',
                    'OB_Address_Street_Number__c' => 'civicocontact2Full',
                    'OB_Document_Release_State__c' => 'provinciacontact2Doc',
                    'OB_Document_Release_City__c' => 'comunecontact2Doc',
                    'OB_Birth_State__c' => 'provinciacontact2Birth',
                    'OB_Birth_City__c' => 'comunecontact2Birth',
                    'OB_Document_Type__c' => 'documentTypecontact2Doc',
                    'OB_Birth_Date__c' => 'birthDatecontact2Doc',
                    'OB_Document_Number__c' => 'documentNumbercontact2Doc',
                    'OB_Document_Release_Authority__c' => 'documentAuthcontact2Doc',
                    'OB_Document_Release_Date__c' => 'documentReleaseDatecontact2Doc',
                    'OB_Document_Expiration_Date__c' => 'documentExpirationDatecontact2Doc'
            },
            CONTACTTWOEE => new Map<String, String>{
                    'OB_Address_City__c' => 'cityEEcontact2Full',
                    'OB_Address_Street__c' => 'streetEEcontact2Full',
                    'OB_Address_Street_Number__c' => 'civicoEEcontact2Full',
                    'OB_Document_Release_City__c' => 'cityEEcontact2Doc',
                    'OB_Birth_City__c' => 'cityEEcontact2Birth'
            }
    };
    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPTITOLARE3 = new Map<String, Map<String, String>>{
            CONTACTTHREE => new Map<String, String>{
                    'OB_Address_State__c' => 'provinciacontact3Full',
                    'OB_Address_City__c' => 'comunecontact3Full',
                    'OB_Address_Street__c' => 'stradacontact3Full',
                    'OB_Address_Street_Number__c' => 'civicocontact3Full',
                    'OB_Document_Release_State__c' => 'provinciacontact3Doc',
                    'OB_Document_Release_City__c' => 'comunecontact3Doc',
                    'OB_Birth_State__c' => 'provinciacontact3Birth',
                    'OB_Birth_City__c' => 'comunecontact3Birth',
                    'OB_Document_Type__c' => 'documentTypecontact3Doc',
                    'OB_Birth_Date__c' => 'birthDatecontact3Doc',
                    'OB_Document_Number__c' => 'documentNumbercontact3Doc',
                    'OB_Document_Release_Authority__c' => 'documentAuthcontact3Doc',
                    'OB_Document_Release_Date__c' => 'documentReleaseDatecontact3Doc',
                    'OB_Document_Expiration_Date__c' => 'documentExpirationDatecontact3Doc'
            },
            CONTACTTHREEEE => new Map<String, String>{
                    'OB_Address_City__c' => 'cityEEcontact3Full',
                    'OB_Address_Street__c' => 'streetEEcontact3Full',
                    'OB_Address_Street_Number__c' => 'civicoEEcontact3Full',
                    'OB_Document_Release_City__c' => 'cityEEcontact3Doc',
                    'OB_Birth_City__c' => 'cityEEcontact3Birth'
            }
    };

    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPTITOLARE4 = new Map<String, Map<String, String>>{

            CONTACTFOUR => new Map<String, String>{
                    'OB_Address_State__c' => 'provinciacontact4Full',
                    'OB_Address_City__c' => 'comunecontact4Full',
                    'OB_Address_Street__c' => 'stradacontact4Full',
                    'OB_Address_Street_Number__c' => 'civicocontact4Full',
                    'OB_Document_Release_State__c' => 'provinciacontact4Doc',
                    'OB_Document_Release_City__c' => 'comunecontact4Doc',
                    'OB_Birth_State__c' => 'provinciacontact4Birth',
                    'OB_Birth_City__c' => 'comunecontact4Birth',
                    'OB_Document_Type__c' => 'documentTypecontact4Doc',
                    'OB_Birth_Date__c' => 'birthDatecontact4Doc',
                    'OB_Document_Number__c' => 'documentNumbercontact4Doc',
                    'OB_Document_Release_Authority__c' => 'documentAuthcontact4Doc',
                    'OB_Document_Release_Date__c' => 'documentReleaseDatecontact4Doc',
                    'OB_Document_Expiration_Date__c' => 'documentExpirationDatecontact4Doc'
            },
            CONTACTFOUREE => new Map<String, String>{
                    'OB_Address_City__c' => 'cityEEcontact4Full',
                    'OB_Address_Street__c' => 'streetEEcontact4Full',
                    'OB_Address_Street_Number__c' => 'civicoEEcontact4Full',
                    'OB_Document_Release_City__c' => 'cityEEcontact4Doc',
                    'OB_Birth_City__c' => 'cityEEcontact4Birth'
            }
    };

    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPTITOLARE5 = new Map<String, Map<String, String>>{
            CONTACTFIVE => new Map<String, String>{
                    'OB_Address_State__c' => 'provinciacontact5Full',
                    'OB_Address_City__c' => 'comunecontact5Full',
                    'OB_Address_Street__c' => 'stradacontact5Full',
                    'OB_Address_Street_Number__c' => 'civicocontact5Full',
                    'OB_Document_Release_State__c' => 'provinciacontact5Doc',
                    'OB_Document_Release_City__c' => 'comunecontact5Doc',
                    'OB_Birth_State__c' => 'provinciacontact5Birth',
                    'OB_Birth_City__c' => 'comunecontact5Birth',
                    'OB_Document_Type__c' => 'documentTypecontact5Doc',
                    'OB_Birth_Date__c' => 'birthDatecontact5Doc',
                    'OB_Document_Number__c' => 'documentNumbercontact5Doc',
                    'OB_Document_Release_Authority__c' => 'documentAuthcontact5Doc',
                    'OB_Document_Release_Date__c' => 'documentReleaseDatecontact5Doc',
                    'OB_Document_Expiration_Date__c' => 'documentExpirationDatecontact5Doc'
            },
            CONTACTFIVEEE => new Map<String, String>{
                    'OB_Address_City__c' => 'cityEEcontact5Full',
                    'OB_Address_Street__c' => 'streetEEcontact5Full',
                    'OB_Address_Street_Number__c' => 'civicoEEcontact5Full',
                    'OB_Document_Release_City__c' => 'cityEEcontact5Doc',
                    'OB_Birth_City__c' => 'cityEEcontact5Birth'
            }
    };

    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPTITOLARE6 = new Map<String, Map<String, String>>{
            CONTACTSIX => new Map<String, String>{
                    'OB_Address_State__c' => 'provinciacontact6Full',
                    'OB_Address_City__c' => 'comunecontact6Full',
                    'OB_Address_Street__c' => 'stradacontact6Full',
                    'OB_Address_Street_Number__c' => 'civicocontact6Full',
                    'OB_Document_Release_State__c' => 'provinciacontact6Doc',
                    'OB_Document_Release_City__c' => 'comunecontact6Doc',
                    'OB_Birth_State__c' => 'provinciacontact6Birth',
                    'OB_Birth_City__c' => 'comunecontact6Birth',
                    'OB_Document_Type__c' => 'documentTypecontact6Doc',
                    'OB_Birth_Date__c' => 'birthDatecontact6Doc',
                    'OB_Document_Number__c' => 'documentNumbercontact6Doc',
                    'OB_Document_Release_Authority__c' => 'documentAuthcontact6Doc',
                    'OB_Document_Release_Date__c' => 'documentReleaseDatecontact6Doc',
                    'OB_Document_Expiration_Date__c' => 'documentExpirationDatecontact6Doc'
            },
            CONTACTSIXEE => new Map<String, String>{
                    //'OB_Address_State__c' =>'provinceEEcontact6Full',
                    'OB_Address_City__c' => 'cityEEcontact6Full',
                    'OB_Address_Street__c' => 'streetEEcontact6Full',
                    'OB_Address_Street_Number__c' => 'civicoEEcontact6Full',
                    //'OB_Document_Release_State__c' =>'provinceEEcontact6Doc',
                    'OB_Document_Release_City__c' => 'cityEEcontact6Doc',
                    //'OB_Birth_State__c' =>'provinceEEcontact6Birth',
                    'OB_Birth_City__c' => 'cityEEcontact6Birth'
            }
    };
    /*
    * History   :       Morittu Andrea - Added privacy input to mandatory map
    */
    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPSERVICEPOINT = new Map<String, Map<String, String>>{
            SERVICEPOINT => new Map<String, String>{
                    'OB_Break_Start_Time__c'    =>      'breakStartTime',
                    'OB_Break_End_Time__c'      =>      'breakEndTime',
                    'OB_Opening_Time__c'        =>      'openingTime',
                    'OB_Ending_Time__c'         =>      'ClosingTime',
                    'OB_Privacy_C3__c'          =>      'OB_Privacy_C3__c',
                    'OB_Privacy_C4__c'          =>      'OB_Privacy_C4__c',
                    'OB_Privacy_C5__c'          =>      'OB_Privacy_C5__c'
            }
    };

    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPSERVICEPOINTBREAKTIME = new Map<String, Map<String, String>>{
            SERVICEPOINT => new Map<String, String>{
                    'OB_Break_Start_Time__c' => 'breakStartTime',
                    'OB_Break_End_Time__c' => 'breakEndTime'
            }
    };
    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPSERVICEPOINTOPENING = new Map<String, Map<String, String>>{
            SERVICEPOINT => new Map<String, String>{
                    'OB_Opening_Time__c' => 'openingTime',
                    'OB_Ending_Time__c' => 'ClosingTime'
            }
    };
    global static final Map<String, Map<String, String>> MANDATORYINPUTMAPSERVICEPOINTANNUAL = new Map<String, Map<String, String>>{
            SERVICEPOINT => new Map<String, String>{
                    'OB_Annual_Revenue__c' => 'annualRevenue_SP',
                    'OB_Annual_Negotiated__c' => 'annualNegotiated_SP'
            }
    };

    global static final Map<String, Map<String, String>> MANDATORYMAINTENANCECOMPANYDATA = new Map<String, Map<String, String>>{
            MAINTACCOUNT => new Map<String, String>{
                    'OB_Legal_Address_State__c' => 'provinciaSedeLegale',
                    'OB_Legal_Address_City__c' => 'comuneSedeLegale',
                    'OB_Legal_Address_Street__c' => 'stradaSedeLegale',
                    'OB_Legal_Address_Street_Number__c' => 'civicoSedeLegale',
                    'OB_Administrative_Office_State__c' => 'provinciasedeAmministrativa',
                    'OB_Administrative_Office_City__c' => 'comunesedeAmministrativa',
                    'OB_Administrative_Office_Street__c' => 'stradasedeAmministrativa',
                    'OB_Administrative_Office_Street_number__c' => 'civicosedeAmministrativa',
                    'OB_Legal_Form__c' => 'FormaGiuridica'
            }
    };

    global static final Map<String, Map<String, String>> MANDATORYMAINTENANCEEXECUTOR = new Map<String, Map<String, String>>{
            MAINTEXECUTOR => new Map<String, String>{
                    'FirstName' => 'FirstNameModal',
                    'LastName' => 'LastNameModal',
                    'OB_Sex__c' => 'OB_Sex__c',
                    'OB_Company_Link_Type__c' => 'OB_Company_Link_Type__c',
                    'OB_Fiscal_Code__c' => 'fiscalCodelegaleRapp',
                    'OB_Address_State__c' => 'provincialegaleRappresentante',
                    'OB_Address_City__c' => 'comunelegaleRappresentante',
                    'OB_Address_Street__c' => 'stradalegaleRappresentante',
                    'OB_Address_Street_Number__c' => 'civicolegaleRappresentante',
                    'OB_Document_Release_State__c' => 'provincialegaleRappDoc',
                    'OB_Document_Release_City__c' => 'comunelegaleRappDoc',
                    'OB_Birth_State__c' => 'provincialegaleRappBirth',
                    'OB_Birth_City__c' => 'comunelegaleRappBirth',
                    'OB_Document_Type__c' => 'documentTypelegaleRappDoc',
                    'OB_Birth_Date__c' => 'birthDatelegaleRappDoc',
                    'OB_Document_Number__c' => 'documentNumberlegaleRappDoc',
                    'OB_Document_Release_Authority__c' => 'documentAuthlegaleRappDoc',
                    'OB_Document_Release_Date__c' => 'documentReleaseDatelegaleRappDoc',
                    'OB_Document_Expiration_Date__c' => 'documentExpirationDatelegaleRappDoc'
            },
            MAINTEXECUTOREE => new Map<String, String>{
                    'OB_Address_City__c' => 'cityEElegaleRappresentante',
                    'OB_Address_Street__c' => 'streetEElegaleRappresentante',
                    'OB_Address_Street_Number__c' => 'civicoEElegaleRappresentante',
                    'OB_Document_Release_City__c' => 'cityEElegaleRappDoc',
                    'OB_Birth_City__c' => 'cityEElegaleRappBirth'
            }
    };

    /*
        START : Costants to execute logic to retrieve documents to upload
    */
    //COMMERCIAL PRODUCTS ENGIN CODES
    global static final String ECOMMERCE = 'a129E00000108UeQAI';
    global static final String MOTO = 'a129E000001BHN0QAO';
    global static final String ECOMMERCE_LAVORATORE_AUTONOMO = 'a129E00000108UeQAI';
    global static final String MOTO_LAVORATORE_AUTONOMO = 'a129E000001BHN0QAO';
    global static final String ECOMMERCE_LAVORATORE_NON_AUTONOMO = 'a129E00000108UeQAI';
    global static final String MOTO_LAVORATORE_NON_AUTONOMO = 'a129E000001BHN0QAO';
    global static final String ECOMMERCE_PO118 = 'a129E00000108UeQAI';
    global static final String MOTO_PO118 = 'a129E000001BHN0QAO';
    global static final String SERVIZIO_ALBERGO_AUTONOLEGGIO = 'a129E000001BEJsQAO';

    //LOV NAME
    global static final String MCC_LOV_GAMBLING = 'Gambling';
    global static final String ATECO_LOV_GAMBLING = 'Gambling';
    global static final String MCC_LOV_PO118 = 'PO118';
    global static final String ATECO_LOV_PO118 = 'PO118';
    global static final String ATECO_LOV_FIDUCIARE = 'Fiduciare';
    global static final String ATECO_LOV_MONEYTRANSFER = 'Moneytransfer';
    global static final String OB_MCC_OR_ATECO_FORMA_GIURIDICA_LOV_FG = '2';
    global static final String OB_PRODUCT_ACTIVATION_FORMA_GIURIDICA_AND_NOT_LOV_FG = '40';
    global static final String OB_FORMA_GIURIDICA_ONLUS_LOV_FG = '55';
    global static final String OB_FORMA_GIURIDICA_OR_ATECO_LOV_FG = '54';
    global static final String OB_FORMA_GIURIDICA_TRUST_LOV_FG = '53';

    /*
        END:Costants to execute logic to retrieve documents to upload
    */

    //	APPROVAL PROCESS micol.ferrari 31/10/2018
    global static final Set<String> SET_ORDERHEADERFIELDS = new Set<String>{
            'OB_Gambling__c', 'OB_PO118_Ecommerce__c', 'OB_PO118_MOTO__c', 'OB_HotelCarRental__c'
    };

    global static final Map<String, String> MAPLETTERSTONUMBERS = new Map<String, String>{
            'A' => '1',
            'B' => '2',
            'C' => '3',
            'D' => '4',
            'E' => '5',
            'F' => '6',
            'G' => '7',
            'H' => '8',
            'I' => '9',
            'J' => '10',
            'K' => '11',
            'L' => '12',
            'M' => '13',
            'N' => '14',
            'O' => '15',
            'P' => '16',
            'Q' => '17',
            'R' => '18',
            'S' => '19',
            'T' => '20',
            'U' => '21',
            'V' => '22',
            'W' => '23',
            'X' => '24',
            'Y' => '25',
            'Z' => '26'
    };

    global static final Map<String, String> MAPNUMBERSTOLETTER = new Map<String, String>{
            '3' => 'A',
            '4' => 'B',
            '5' => 'C',
            '6' => 'D',
            '7' => 'E',
            '8' => 'F',
            '9' => 'G',
            '10' => 'H',
            '11' => 'I',
            '12' => 'J',
            '13' => 'K'
    };

    //	START 	micol.ferrari 15/11/2018
    global static final String ORDER_BANKAPPROVALSTATUS_RIGETTATO = 'Rigettato';
    global static final String ORDER_BANKAPPROVALSTATUS_APPROVATO = 'Approvato';
    global static final String ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE = 'In Approvazione';
    //	END 	micol.ferrari 15/11/2018

    //23/11/2018 --- Salvatore P. --- Constants ofr OB_Utility Apex Class ---
    global static final String PRODUCT_RECORDTYPE_ACQUIRING = 'Acquiring' ;
    global static final String PRODUCT_RECORDTYPE_COMMISSIONE = 'Commissione';//Simone misani 25/06/2019 R1F2-275
    global static final String PRODUCT_RECORDTYPE_PCI = 'PCI' ;
    global static final String PRODUCT_RECORDTYPE_PAGOBANCOMAT = 'Pagobancomat' ;
    global static final String PRODUCT_RECORDTYPE_VAS = 'Vas' ;
    global static final String PRODUCT_RECORDTYPE_ECOMMERCE = 'Ecommerce' ; //francesca.ribezzi 23/07/19 adding ecommerce recordtype
    // NEXI-232, Michal Targiel <michal.tagiel@accenture.com>, 23.07.2019, START
    global static final String PRODUCT_RECORDTYPE_MOTO = 'Moto' ;
    global static final String OB_PO118_MOTO = 'OB_PO118_MOTO__c' ;
    // NEXI-232, Michal Targiel <michal.tagiel@accenture.com>, 23.07.2019, STOP
    global static final String PRODUCT_ACQUIRER_NEXI = 'Nexi' ;
    global static final String ORDERITEM_STATUS_CANCELLED = 'Cancelled' ;
    global static final String ORDERITEM_ACTION_REMOVE = 'Remove' ;   //davide.franzini 20/05/2019 - R1F2-153
    global static final String ORDERITEM_ACTION_ADD = 'Add' ;   //Andrea Saracini 12/06/2019 - R1F2-153v2
    global static final String ORDERITEM_ACTION_NONE = 'None' ;   //Simone Misani 27/06/2019 F2Wave2-34 
     global static final String ORDERITEM_ACTION_CHANGE = 'Change' ;
    global static final String REJECTION_REASON_FINAL_REJ = 'Rifiuto definitivo' ;
    global static final String ORDERS_STATUS_SENT = 'Sent' ;
    global static final String ORDERS_STATUS_PENDING = 'Pending' ;
    global static final String ORDERS_STATUS_FAILED = 'Failed' ; //AF-Funnel-v3.0_status_logic_5.1 z.urban@accenture.com 29/04/2019
    global static final String LOGREQUEST_STATUS_DRAFT = 'Bozza' ;
    global static final String LOGREQUEST_STATUS_INATTESA = 'In attesa' ;
    global static final String LOGREQUEST_STATUS_INAPPROVAZIONE = 'In attesa di Controlli Interni' ;
    global static final String LOGREQUEST_STATUS_CONFERMATO = 'Confermato' ; //NEXI-181 Marta Stempien <marta.stempien@accenture.com> 16/07/2019
    global static final String LOGREQUEST_FINALREJECTIONREASON = 'Rifiutato da controlli interni' ;
    //-----------------------------------------------------------------------

    //	START 	micol.ferrari 23/11/2018
    global static final String STATUS_ACTIVE = 'Active';
    global static final String STATUS_INACTIVE = 'Inactive';
    global static final String STATUS_PROSPECT = 'Prospect';
    //	END 	micol.ferrari 23/11/2018
    //	START 	micol.ferrari 26/11/2018
    global static final String ACC_RT_MERCHANT = 'Merchant';
    global static final String ACC_RT_MASTERMERCHANT = 'Master_Merchant';
    global static final String ACC_RT_GROUP = 'Group';
    global static final String ACC_RT_BANK = 'Bank';
    global static final String ACC_RT_BANKGROUP = 'Bank_Group';
    global static final String ACC_RT_HOLDING = 'Holding';
    global static final String ASSET_STATUS_DISCONNECTED = 'Disconnected';
    //	END 	micol.ferrari 26/11/2018
    //START Andrea 26/11/2018
    global static final String ACCEPTEDSPECIALCHAR = ' abcdefghijklmnopqrstuvwxyz0123456789.()”?!&%$£=^°//\\\'';
    //	END 	Andrea 26/11/2018

    //	START 	micol.ferrari 24/12/2018
    global static final String APPROV_TYPE_BIO = 'BIO';
    global static final String APPROV_TYPE_PRICING = 'Pricing';

    //	START	  micol.ferrari 13/03/2019 - R1F2 MultiPV 7.2
    global static final String APPROV_TYPE_ACQUIRING = 'Acquiring';
    //	END		micol.ferrari 13/03/2019 - R1F2 MultiPV 7.2

    global static final String ORDER_APPROVALSTATUS_APPROVATOBIO = 'Approvato BIO';
    global static final String ORDER_APPROVALSTATUS_RIGETTATOBIO = 'Rigettato BIO';
    global static final String ORDER_APPROVALSTATUS_INAPPROVBIO = 'In Approvazione BIO';
    global static final String ORDER_APPROVALSTATUS_APPROVATOPRICING = 'Approvato Pricing';
    global static final String ORDER_APPROVALSTATUS_RIGETTATOPRICING = 'Rigettato Pricing';
    global static final String ORDER_APPROVALSTATUS_INAPPROVPRICING = 'In Approvazione Pricing';
    //	END 	micol.ferrari 24/12/2018
    //	START 	daniele.gandini 05/02/2019
    global static final String HEADER_SUBPROCESS_ECONOMICA = 'variazione economica';
    global static final String HEADER_SUBPROCESS_OPERATIVA = 'variazione operativa';
    //	END 	daniele.gandini 05/02/2019
    global static final List<String> BOOLEANVALUES_LIST = new List<String>{
            'OB_PEP__c',
            'OB_Opening_Sunday_Afternoon__c',
            'OB_Opening_Saturday_Afternoon__c',
            'OB_Opening_Friday_Afternoon__c',
            'OB_Opening_Thursday_Afternoon__c',
            'OB_Opening_Wednesday_Afternoon__c',
            'OB_Opening_Tuesday_Afternoon__c',
            'OB_Opening_Monday_Afternoon__c',
            'OB_Opening_Sunday_Morning__c',
            'OB_Opening_Saturday_Morning__c',
            'OB_Opening_Friday_Morning__c',
            'OB_Opening_Thursday_Morning__c',
            'OB_Opening_Wednesday_Morning__c',
            'OB_Opening_Tuesday_Morning__c',
            'OB_Opening_Monday_Morning__c'
    };

    global static final Map<String, Integer> SEQUENCE_SORTING_MAP = new Map<String, Integer>{
        //  WN-87 - Micol Ferrari <micol.ferrari@accenture.com>, 13/07/2019 - Added fields - START
        'Name' => 1,
        //  WN-87 - Micol Ferrari <micol.ferrari@accenture.com>, 13/07/2019 - Added fields - STOP
        'OB_Opening_Time__c' => 1,
        'OB_Ending_Time__c' => 2,
        'OB_Break_Start_Time__c' => 3,
        'OB_Break_End_Time__c' => 4,
        'OB_Opening_Monday_Morning__c' => 5,
        'OB_Opening_Monday_Afternoon__c' => 6,
        'OB_Opening_Tuesday_Morning__c' => 7,
        'OB_Opening_Tuesday_Afternoon__c' => 8,
        'OB_Opening_Wednesday_Morning__c' => 9,
        'OB_Opening_Wednesday_Afternoon__c' => 10,
        'OB_Opening_Thursday_Morning__c' => 11,
        'OB_Opening_Thursday_Afternoon__c' => 12,
        'OB_Opening_Friday_Morning__c' => 13,
        'OB_Opening_Friday_Afternoon__c' => 14,
        'OB_Opening_Saturday_Morning__c' => 15,
        'OB_Opening_Saturday_Afternoon__c' => 16,
        'OB_Opening_Sunday_Morning__c' => 17,
        'OB_Opening_Sunday_Afternoon__c' => 18,
        'FirstName' => 19,
        'LastName' => 20,
        'Email' => 21,
        'MobilePhone' => 22,
        //  F2WAVE2-112 - Micol Ferrari <micol.ferrari@accenture.com>, 13/07/2019 - Added fields - START
        'OB_Legal_Address_City__c' => 23,
        'OB_Legal_Address_Country__c' => 24,
        'OB_Legal_Address_Country_Code__c' => 25,
        'OB_Legal_Address_Detail__c' => 26,
        'OB_Legal_Address_Hamlet__c' => 27,
        'OB_Legal_Address_Name__c' => 28,
        'OB_Legal_Address_State__c' => 29,
        'OB_Legal_Address_State_Code__c' => 30,
        'OB_Legal_Address_Street__c' => 31,
        'OB_Legal_Address_Street_Number__c' => 32,
        'OB_Legal_Address_ZIP__c' => 33,
        'OB_Administrative_Office_City__c' => 34,
        'OB_Administrative_Office_Country__c' => 35,
        'OB_Administrative_Office_Country_Code__c' => 36,
        'OB_Administrative_Office_Address_Details__c' => 37,
        'OB_Administrative_Office_Hamlet__c' => 38,
        'OB_Administrative_Office_Name__c' => 39,
        'OB_Administrative_Office_State__c' => 40,
        'OB_Administrative_Office_State_Code__c' => 41,
        'OB_Administrative_Office_Street__c' => 42,
        'OB_Administrative_Office_Street_number__c' => 43,
        'OB_Administrative_Office_ZIP__c' => 44
        //  F2WAVE2-112 - Micol Ferrari <micol.ferrari@accenture.com>, 13/07/2019 - Added fields - STOP
    };

    global static final String MAINTENANCE = 'Maintenance';
    global static final String SETUP = 'Setup';
    global static final String OPERATION ='Operation';//Simone Misani 11/07/2019  var-coba

    // NEXI-208, Wojciech Szuba, <wojciech.szuba@accenture.com>, 25/07/2019, START
    global static final List<String> ATECO_GAMBLING_LIST = new List<String>{
            OB_UtilityConstants.GAMBLING_VALUE_920,
            OB_UtilityConstants.GAMBLING_VALUE_9200,
            OB_UtilityConstants.GAMBLING_VALUE_92000,
            OB_UtilityConstants.GAMBLING_VALUE_920001,
            OB_UtilityConstants.GAMBLING_VALUE_920002,
            OB_UtilityConstants.GAMBLING_VALUE_920009,
            OB_UtilityConstants.GAMBLING_VALUE_93293,
            OB_UtilityConstants.GAMBLING_VALUE_932903
    };
    global static final List<String> MCC_GAMBLING_LIST = new List<String>{
            OB_UtilityConstants.GAMBLING_VALUE_7995,
            OB_UtilityConstants.GAMBLING_VALUE_7996,
            OB_UtilityConstants.GAMBLING_VALUE_7932
    };
    global static final List<String> SAE_FIDUCIARE_LIST = new List<String>{
            OB_UtilityConstants.FIDUCIARIE_VALUE_273,
            OB_UtilityConstants.FIDUCIARIE_VALUE_265
    };
    global static final List<String> ATECO_FIDUCIARE_LIST = new List<String>{
            OB_UtilityConstants.FIDUCIARIE_VALUE_66193,
            OB_UtilityConstants.FIDUCIARIE_VALUE_661930
    };
    global static final List<String> ATECO_MONEYTRANSFER_LIST = new List<String>{
            OB_UtilityConstants.MONEYTRANSFER_VALUE_66195,
            OB_UtilityConstants.MONEYTRANSFER_VALUE_661950
    };
    // NEXI-208, Wojciech Szuba, <wojciech.szuba@accenture.com>, 25/07/2019, STOP

    //	START 	micol.ferrari 14/01/2019
    global static final String FULFILMENTSTATUS_DRAFT = 'Draft';
    global static final String FULFILMENTSTATUS_PENDING = 'Pending';
    global static final String FULFILMENTSTATUS_TOAPPROVE = 'To Approve';
    global static final String FULFILMENTSTATUS_CANCELLED = 'Cancelled';
    global static final String FULFILMENTSTATUS_COMPLETED = 'Completed';
    //START AF-Funnel-v3.0_status_logic_5.1 z.urban@accenture.com 29/04/2019
    global static final String FULFILMENTSTATUS_FAILED = 'Failed'; 
    global static final String FULFILMENTSTATUS_SENT = 'Sent';
    global static final String FASECONTROL_OPERATIONAL_CONTROLS = 'Controlli operativi'; 
    global static final String FASECONTROL_CONTROLS_AML = 'Controlli AML'; 
    global static final String FASECONTROL_SECURITY_CHECKS = 'Controlli sicurezza'; 
    global static final String REJECTION_ABSENT_DOCUMENTATION = 'Documentazione assente';
    global static final String REJECTION_MISSING_DOCUMENTATION = 'Documentazione mancante';
    global static final String REJECTION_INCOMPLETE_DOCUMENTATION = 'Documentazione incompleta'; 
    global static final String TECHOUTCOME_OK = 'OK'; 
    global static final String TECHOUTCOME_KO = 'KO';
    //STOP AF-Funnel-v3.0_status_logic_5.1 z.urban@accenture.com 29/04/2019    
    //	END 	micol.ferrari 14/01/2019
    //  START   giovanni.spinelli 18/01/2019
    global static final String CONSISTENZA      = 'Consistenza';
    global static final String ANAGRAFICA       = 'Anagrafica';
    global static final String PRICING          = 'Pricing';
    global static final String CAMBIOCOBA       = 'Cambio CoBa'; //salvatore.pianura 03/05/2019

    //START elena.preteni descoping consistenza log request ecommerce
    global static final String CONSISTENZA_ECOMMERCE      = 'Consistenza eCommerce';
    //END elena.preteni descoping consistenza log request ecommerce

    // NEXI-180, Wojciech Szuba, <wojciech.szuba@accenture.com>, 23/07/2019, START
    global static final String SETTLEMENT_PROCEDURE_API_NAME = 'OB_Settlement_Procedure__c';
    global static final String INTERNATIONAL_SETTLEMENT_METHOD_API_NAME = 'OB_InternationalSettlementMethod__c';
    global static final String SETTLEMENT_TYPE_BANCA_LORDO = 'BANCA (ACCREDITO AL LORDO DELLE COMMISSIONI)';
    global static final String FIELD_SET_NAME_MODALITA = 'Modalita di Liquidazione';
    // NEXI-180, Wojciech Szuba, <wojciech.szuba@accenture.com>, 23/07/2019, STOP

    global static final String INATTESA = 'In attesa';
    global static final String CONFERMATO = 'Confermato';
    global static final String RIFIUTATO = 'Rifiutato';
    global static final String INATTESADICONTROLLIINTERNI = 'In attesa di Controlli Interni';
    global static final String BOZZA = 'Bozza';

    global static final String CONSISTENZART    = 'OB_Consistenza';
    global static final String CONFIGURATORETECNICORT    = 'OB_Configuratore_Tecnico';//Simone Misani F2-WAVE2-66-18 08/07/2019
    global static final String CONFIGURATORETECNICO    = 'Configuratore Tecnico';//Simone Misani F2-WAVE2-66-18 08/07/2019
    //START - salvatore.pianura 03/05/2019
    global static final String ANAGRAFICART     = 'OB_Anagrafica';
    global static final String PRICINGRT        = 'OB_Pricing';
    global static final String CAMBIOCOBART     = 'OB_CambioCoBa';
    //END - salvatore.pianura 03/05/2019
    //START----Simone Misani 25/07/2019 Wn-190
    global static final String MIGLIORATIVA     = 'MIGLIORATIVA';
    global static final String PEGGIORATIVA     = 'PEGGIORATIVA';
    //END----Simone Misani 25/07/2019 Wn-190

    // START - giovanni.spinelli 18/01/2019
    global static final String ACQUIRING_RT = 'Acquiring';
    global static final String POS_RT = 'Terminali';
    // NEXI-046 marta.stempien@accenture.com 14/05/2019 START
    global static final String SERVICE_RT = 'Service';
    // NEXI-046 marta.stempien@accenture.com 14/05/2019 STOP
    // END - giovanni.spinelli 18/01/2019 STOP

    // NEX-006 joanna.mielczarek@accenture.com 28/03/2019 START
    global static final String NEXI_PARTNER_USER_PROFILE_NAME = 'Nexi Partner User';
    global static final String NEXI_PARTNER_APPROVER_L1_PROFILE_NAME = 'Nexi Partner Approver L1';
    global static final String NEXI_PARTNER_APPROVER_L2_PROFILE_NAME = 'Nexi Partner Approver L2';
    global static final String NEXI_PARTNER_APPROVER_L3_PROFILE_NAME = 'Nexi Partner Approver L3';
    // NEX-006 joanna.mielczarek@accenture.com 28/03/2019 STOP

    // NEX-000 marta.stempien@accenture.com START 25/03/2019
    global static final String APPLICATION_LOG_ERROR = 'Error';
    global static final String APPLICATION_LOG_INFO = 'Info';
    global static final String APPLICATION_LOG_WARNING = 'Warning';
    global static final String APPLICATION_LOG_DEBUG = 'Debug';
    // NEX-000 marta.stempien@accenture.com STOP 25/03/2019

    //Andrea Saracini 18.04.2019 Card No Present START
    global static final String START_SFDC = 'START';
    global static final String CUSTOM_SFDC = 'PERSONALIZZATA';
    //Andrea Saracini 18.04.2019 Card No Present STOP

    // NEXI-046 marta.stempien@accenture.com 14/05/2019 START
    global static final String SOBJECT_ORDERITEM = 'NE__OrderItem__c';
    global static final String SOBJECT_ACCOUNT = 'Account'; //NEXI-179 Marta Stempien <marta.stempien@accenture.com>, 31/07/2019
    // NEXI-046 marta.stempien@accenture.com 14/05/2019 STOP

    //giovanni spinelli - 15/07/2019 add constants to OB_Bank_OrderStatus on NE__Order__c object - start
    global static final String BANKORDERSTATUS_DRAFT = 'Draft';
    global static final String BANKORDERSTATUS_NEXIPROCESSING = 'Procedure in Nexi processing';
    global static final String BANKORDERSTATUS_ORDERFULFILLED = 'Order fulfilled';
    global static final String BANKORDERSTATUS_DRAFTINCOMPLETEORDER = 'Draft - incomplete order';
    global static final String BANKORDERSTATUS_ORDERCANCELLED = 'Order cancelled';
    global static final String BANKORDERSTATUS_ECONOMICCONDITIONAPPROVAL = 'Economic conditions approval';
    global static final String BANKORDERSTATUS_BANKVERIFICATION = 'Bank verification';
    global static final String BANKORDERSTATUS_PROCEDUREREFUSED = 'Procedure Refused';
    global static final String BANKORDERSTATUS_ORDERFULFILLEDPARTIALY = 'Order fulfilled partially';
    //giovanni spinelli - 15/07/2019 add constants to OB_Bank_OrderStatus on NE__Order__c object - start

    //start giovanni spinelli <spinelli.giovanni@accenture.com> add field to filter query with record type = standard PRODOB-390
    global static final String RTASSETSTANDARD = 'Standard';
    //end giovanni spinelli <spinelli.giovanni@accenture.com> add field to filter query with record type = standard PRODOB-390
    //start giovanni spinelli <spinelli.giovanni@accenture.com> add recort type developer name
    global static final String RTPRICINGPRODUCT = 'Pricing';
    global static final String RTPRICEBANKABI   = 'OB_PriceBankABI';
    //end giovanni spinelli <spinelli.giovanni@accenture.com> add recort type developer name

        // ANDREA MORITTU START 01-10-2019 - EVO_BACKLOG_245
        global static final String VISA_MASTERCARD_PRODUCT_NAME = 'Visa/Mastercard';
        global static final String  ASSET_Commissione_Differenziata = 'Commissione Differenziata e Altre offerte';
        global static final String  ASSET_Commissione_Unica = 'Commissione Unica';
        // ANDREA MORITTU END 01-10-2019 EVO_BACKLOG_245
    

    //NEXI-207 Michal Targiel <michal.targiel@accenture.com>, 30/07/2019, START
    global static final String OBCodiceMPAN = 'MPAN';
    global static final String OBCodiceALBAUTO = 'ALB_AUTO';
    global static final String VISAMASTERCARD = 'VISAMASTERCARD';
    //NEXI-207 Michal Targiel <michal.targiel@accenture.com>, 30/07/2019, STOP

    //NEXI-186 Zuzanna Urban <z.urban@accenture.com> 16/07/2019 Start, data for Special Categories
    global static final String SPECIAL_CATEGORY_GAMBLING = 'Gambling';
    global static final String SPECIAL_CATEGORY_FIDUCIARIE = 'Fiduciarie';
    global static final String SPECIAL_CATEGORY_ONLUS = 'Onlus';
    global static final String SPECIAL_CATEGORY_MONEYTRANSFER = 'Moneytransfer';
    global static final String SPECIAL_CATEGORY_TRUST = 'Trust';
    global static final String SPECIAL_CATEGORY_CROWDFUNDING = 'Crowdfunding';
    global static final String LEGAL_FORM_CODE_NO_PROFIT = 'ORG_NO_PROFIT';
    global static final String LEGAL_FORM_MONEY = 'Money transfer';
    global static final String LEGAL_FORM_CODE_MONEY = 'MONEYTRANSFER';
    global static final String LEGAL_FORM_TRUST = 'Trust/strutture analoghe';
    global static final String LEGAL_FORM_CODE_TRUST = 'TRUST';
    global static final String LEGAL_FORM_CODE_NONPROFIT = 'ORG_NO_PROFIT'; // NEXI-325 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019
    global static final String DESCRIPTIONVAT_NO_PROFIT = 'Organizzazione non profit/strutture analoghe';
    global static final String LOG_REQUEST_OBJECT = 'OB_LogRequest__c';
    global static final String ORDER_HEADER_OBJECT = 'NE__Order_Header__c';
    global static final String GAMBLING_VALUE_7995 = '7995';
    global static final String GAMBLING_VALUE_7996 = '7996';
    global static final String GAMBLING_VALUE_7932 = '7932';
    // NEXI-324 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019 START removed dots from ateco codes
    global static final String GAMBLING_VALUE_920 = '920';
    global static final String GAMBLING_VALUE_9200 = '9200';
    global static final String GAMBLING_VALUE_92000 = '92000';
    global static final String GAMBLING_VALUE_920001 = '920001';
    global static final String GAMBLING_VALUE_920002 = '920002';
    global static final String GAMBLING_VALUE_920009 = '920009';
    global static final String GAMBLING_VALUE_93293 = '93293';
    global static final String GAMBLING_VALUE_932903 = '932930';
    global static final String FIDUCIARIE_VALUE_273 = '273';
    global static final String FIDUCIARIE_VALUE_265 = '265';
    global static final String FIDUCIARIE_VALUE_66193 = '66193';
    global static final String FIDUCIARIE_VALUE_661930 = '661930';
    global static final String MONEYTRANSFER_VALUE_66195 = '66195';
    global static final String MONEYTRANSFER_VALUE_661950 = '661950';
    // NEXI-324 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019 STOP
    //NEXI-186 Zuzanna Urban <z.urban@accenture.com> 16/07/2019 Stop, data for Special Categories

    //NEXI-217 Zuzanna Urban <z.urban@accenture.com> 23/07/2019 Start, values for approval
    global static final String APPROVAL_STEP_2 = '2';
    global static final String APPROVAL_STEP_3 = '3';
    global static final String APPROVAL_STEP_4 = '4';
    global static final String APPROVAL_STEP_5 = '5';
    //NEXI-217 Zuzanna Urban <z.urban@accenture.com> 23/07/2019 Stop, values for approval

    // NEXI-125 kinga.fornal@accenture.com 28/06/2019 START
    global static final String DITTA_INDIVIDUALE= 'Ditta individuale';
    global static final String LIBERO_PROFESSIONISTA = 'Libero professionista';
    global static final String LAVORATORE_AUTONOMO = 'Lavoratore autonomo';
    global static final String IMPRENDITORE_INDIVIDUALE_AGRICOLO = 'Imprenditore individuale agricolo';
    global static final String IMPRENDITORE_INDIVIDUALE_NON_AGRICOLO = 'imprenditore individuale non agricolo';
    // NEXI-125 kinga.fornal@accenture.com 28/06/2019 STOP

    //NEXI-121 <damian.krzyzaniak@accenture.com> 24.07.2019 START
    global static final String TYPE_LEGALFORM = 'legalform';
    global static final String DITTA_INDIVIDUALE_CODE = 'DITTA_INDIVIDUALE';
    global static final STRING ORG_NO_PROFIT_CODE = 'ORG_NO_PROFIT';
    global static final String ORG_NO_PROFIT = 'ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE';
    //NEXI-121 <damian.krzyzaniak@accenture.com> 24.07.2019 STOP

    // NEXI-123 damian.krzyzaniak@accenture.com 09/07/2019 START
    global static final Set<String> legalFormsRequiringCheckInLowerCase = new Set<String>
    {
            DITTA_INDIVIDUALE.toLowerCase( ),
            LIBERO_PROFESSIONISTA.toLowerCase( ),
            LAVORATORE_AUTONOMO.toLowerCase( ),
            IMPRENDITORE_INDIVIDUALE_AGRICOLO.toLowerCase( ),
            IMPRENDITORE_INDIVIDUALE_NON_AGRICOLO.toLowerCase( )
    };
    // NEXI-123 damian.krzyzaniak@accenture.com 09/07/2019 STOP
    // NEXI-119, Michal Targiel <michal.tagiel@accenture.com>, 23/07/2019, START
    global static final String ATECO_0000 = '0000';
    // NEXI-119, Michal Targiel <michal.tagiel@accenture.com>, 23/07/2019, STOP

    //NEXI-117 Michal Targiel <michal.targiel@accenture.com>, 24/07/2019, START
    global static final String MESSAGE = 'message';
    //NEXI-117 Michal Targiel <michal.targiel@accenture.com>, 24/07/2019, STOP
    //NEXI-287 Marta Stempien <marta.stempien@accneture.com>, 29/08/2019, START
    global static final String ORDER_HEADER_FASE_CONTROLLI_CONTROLLI_OPERATIVI = 'Controlli Operativi';
    global static final String ORDER_HEADER_FASE_CONTROLLI_CONTROLLI_AML = 'Controlli AML';
    global static final String ORDER_HEADER_FASE_CONTROLLI_CONTROLLI_SICUREZZA = 'Controlli sicurezza';
    //NEXI-287 Marta Stempien <marta.stempien@accneture.com>, 29/08/2019, STOP

    //davide.franzini - WN-584 - 10/10/2019
    global static final String BUSINESSMODEL_BANCARIO = 'Bancario';
      
}