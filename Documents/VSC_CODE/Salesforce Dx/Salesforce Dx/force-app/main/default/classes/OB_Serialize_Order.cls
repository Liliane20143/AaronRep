global class OB_Serialize_Order
{

    Static final String SEDE_LEGALE_RT = 'Dati_Societ_Legale';
    Static final String SEDE_LEGALE = 'SedeLegale';
    Static final String SEDE_AMMINISTRATIVA = 'SedeAmministrativa';
    Static final String TELEFONO = 'LANDLINE';
    Static final String CELLULARE = 'MOBILE';
    Static final String FAX = 'FAX';
    Static final String TITOLARE = 'Titolare_Effettivo';
    Static final String REFERENTE_PV_RT = 'Referente_Punto_Vendita';
    Static final String REFERENTE_TEC_RT = 'Referente_Tecnico';
    Static final String REFERENTE_AMM_PV_RT = 'Responsabile_Amministrativo';
    Static final String MAINTENANCE = 'Maintenance';
    //michele.lubrano@accenture.com 29-05-2019 -- new constant
    Static final String ACTIVE = 'Active';

    public Static Map<String, Map<String, String>> decodeValues = new Map<String, Map<String, String>>( );
    public Static OB_Order_Wrapper so;

    public OB_Serialize_Order( )
    {
        list<NE__Lov__c> lovs =
        [
                SELECT Name,NE__Value1__c,NE__Value2__c
                FROM NE__Lov__c
                WHERE NE__Sub_Type__c = 'TIPOLOGICHE' AND NE__Type__c = 'SUBMIT'
        ];

        system.debug( '@@ lovs' + lovs );

        /* ********************************************
         * BUILD A MAP FROM SFDC VALUES TO MIP VALUES
         * Name contains the logical gruping
         * NE__Value1__c contains SFDC value
         * NE__Value2__c contains MIP value
         **********************************************/

        for ( NE__Lov__c val : lovs )
        {
            Map<String, String> tmp = new Map<String, String>( );
            if ( decodeValues.containsKey( val.Name ) )
            {
                tmp = decodeValues.get( val.Name );
            }
            tmp.put( val.NE__Value1__c.trim( ), val.NE__Value2__c );
            decodeValues.put( val.Name, tmp );
        }
    }


    public static String decodeVal( String fieldName, String fiedValue )
    {

        if ( !decodeValues.containsKey( fieldName ) )
        {
            return fiedValue;
        }

        if ( decodeValues.get( fieldName ).containsKey( fiedValue ) )
        {
            return decodeValues.get( fieldName ).get( fiedValue );
        }

        return fiedValue;
    }

    public static String serializeDate( Date dT )
    {
        if ( dT != null )
        {
            return dT.year( ) + '-' + String.valueof( dT.month( ) ).leftPad( 2, '0' ) + '-' + String.valueof( dT.day( ) ).leftPad( 2, '0' );
        }
        return null;
    }

    public static String serializeTime( Time tm )
    {
        if ( tm != null )
        {
            return String.valueof( tm.hour( ) ).leftPad( 2, '0' ) + ':' + String.valueof( tm.minute( ) ).leftPad( 2, '0' );
        }
        return null;
    }

    public static String serializeDate( DateTime dT )
    {
        if ( dT != null )
        {
            return dT.year( ) + '-' + String.valueof( dT.month( ) ).leftPad( 2, '0' ) + '-' + String.valueof( dT.day( ) ).leftPad( 2, '0' );
        }
        return null;
    }

    public String serializeOrder( Id headerId )
    {

        so = new OB_Order_Wrapper( headerId );
        NE__Order_Header__c orderHeader = getOrderHeader( headerId );
        system.debug( '@@ orderHeader' + orderHeader );
        RequestDTO req = new RequestDTO( orderHeader );

        return JSON.serialize( req );
    }


    class RequestDTO
    {
        String action { get; set; }
        ContractDTO contract { get; set; }

        RequestDTO( NE__Order_Header__c orderHeader )
        {
            system.debug( '## orderHeader.OB_Main_Process__c: ' + orderHeader.OB_Main_Process__c );
            system.debug( '## orderHeader.NE__Type__c: ' + orderHeader.NE__Type__c );
            action = decodeVal( 'orderHeader.NE__Type__c', String.valueOf( orderHeader.OB_Main_Process__c ) );
            contract = OB_Serialize_Order.serializeContract( orderHeader );
        }
    }

    public static ContractDTO serializeContract( NE__Order_Header__c orderHeader )
    {

        ContractDTO c = new ContractDTO( orderHeader );
        return c;
    }

    //enrico.purificato WN-35 START
    class AdditionalInfoDTO
    {
        String requestorType { get; set; }
        Date requestDate { get; set; }
        String uninstallMethod { get; set; }
        String notes { get; set; }
    }
    //enrico.purificato WN-35 END

    @TestVisible
    class ContractDTO
    {
        String externalId { get; set; }
        String stipulationDate { get; set; }
        //String requestDate { get; set; } // non presente in JSON
        String proposerABI { get; set; }
        String acquirer { get; set; }
        String businessModelAcquiring { get; set; }
        String businessModelPOS { get; set; }
        String ABINDG { get; set; } // @dg 25/02/2019 old value: abi_ndg
		
        //enrico.purificato WN-35 START
        Boolean closedOffer { get; set; }
        AdditionalInfoDTO AdditionalInformation = new AdditionalInfoDTO();
        //enrico.purificato WN-35 END
        
        // michele.lubrano@accenture.com adding Boolean pricingAgree
        Boolean pricingAgree { get; set; }  
																	  
        MerchantDTO merchant;
        List<ServicePointDTO> salesPoints;
        ContractDTO( NE__Order_Header__c orderHeader )
        {
            
            externalId = orderHeader.id;
            if ( orderHeader.NE__Order_date__c != null )
            {
                stipulationDate = OB_Serialize_Order.serializeDate( orderHeader.NE__Order_date__c );
            }
            else
            {
                stipulationDate = OB_Serialize_Order.serializeDate( Date.today( ) );
            }

            proposerABI = orderHeader.OB_ProposerABI__r.OB_ABI__c;
            //businessModelAcquiring  = OB_Serialize_Order.decodeVal('orderHeader.OB_Business_Model_Acquiring__c',String.valueOf(orderHeader.OB_Business_Model_Acquiring__c));
            //businessModelPOS        = OB_Serialize_Order.decodeVal('orderHeader.OB_Business_Model_POS__c',String.valueOf(orderHeader.OB_Business_Model_POS__c));
            if ( String.isNotBlank( orderHeader.OB_NDG__c ) )
            {
                ABINDG = proposerABI + '_' + orderHeader.OB_NDG__c;
            }
            businessModelAcquiring = orderHeader.OB_Business_Model_Acquiring__c;
            businessModelPOS = orderHeader.OB_Business_Model_POS__c;

            //requestDate = OB_Serialize_Order.serializeDate( orderHeader.CreatedDate );
            acquirer = OB_Serialize_Order.decodeVal( 'OB_Bank_owner__c.OB_ABI__c', String.valueOf( orderHeader.NE__AccountId__r.OB_Bank_owner__r.OB_ABI__c ) );
            merchant = OB_Serialize_Order.serializeMerchant( orderHeader.NE__AccountId__c, orderHeader.OB_ProposerABI__c );
            //NEXI-121 Damian Krzyzaniak <damian.krzyzaniak@accenture.com> 17.07.2019 START
            List<Account> accounts = [ SELECT Id,OB_Legal_Form__c,OB_Legal_Form_Code__c FROM Account WHERE Id = :orderHeader.NE__AccountId__c LIMIT 1 ];
            Account merchant = ( accounts.size( ) == 1 ) ? accounts.get( 0 ) : null;
            //OB_Serialize_Order.checkForEmptyLegalFormCode( merchant ); //antonio.vatrano 23/09/2019 wn-448
            //NEXI-121 Damian Krzyzaniak <damian.krzyzaniak@accenture.com> 17.07.2019 STOP
            salesPoints = OB_Serialize_Order.serializeServicePoint( getConfigurations( orderHeader.id ), orderHeader.NE__AccountId__c, orderHeader.OB_ProposerABI__c );
			  // michele.lubrano@accenture.com populate new fields for maintenance START
            closedOffer = (orderHeader.OB_Sub_Process__c != null && orderHeader.OB_Sub_Process__c.equalsIgnoreCase('termina offerta') ) ? true : false;
            //enrico.purificato WN-35 START
            AdditionalInformation.requestorType = getConfigurations(orderHeader.id)[0].OB_Petitioner__c;
            AdditionalInformation.requestDate = getConfigurations(orderHeader.id)[0].OB_RequestDate__c;
            AdditionalInformation.uninstallMethod = getConfigurations(orderHeader.id)[0].OB_Unistallation_Procedure__c;
            AdditionalInformation.notes =  getConfigurations(orderHeader.id)[0].OB_Note__c;
            //enrico.purificato WN-35 END
            // michele.lubrano@accenture.com END
            // michele.lubrano@accenture.com adding Boolean pricingAgree
            pricingAgree = orderHeader.NE__Configurations__r[0].OB_AgreedChanges__c;																		  
																																																		 
																				  
																				 
																								 
																	
												
																		
																					
        }
    }

    public static MerchantDTO serializeMerchant( Id merchantId, Id proposerABIId )
    {
        Account merchant = getMerchant( merchantId, proposerABIId );
        MerchantDTO ma = new MerchantDTO( merchant, merchantId, proposerABIId );

        //system.debug('@@ ma: ' + ma);
        return ma;
    }

    @TestVisible
    class MerchantDTO
    {
        String name { get; set; }
        String nexiCode { get; set; }
        String legalForm { get; set; }
        String vatNumber { get; set; }
        String taxCode { get; set; }
        String email { get; set; }
        String yearConstitutionCompany { get; set; }
        String companyRegistrationNumber { get; set; }
        String provinceChamberOfCommerce { get; set; }
        String commoditySectorCodeSAE { get; set; }
        // NEXI-119 Michal Targiel<michal.targiel@accenture.com>, 09/07/2019 START
        public String atecoCode
        {
            get
            {
                return atecoCode;
            }
            set
            {
                atecoCode = OB_UtilityConstants.ATECO_0000.equals( value ) ? null : value;
            }
        }
        // NEXI-119 Michal Targiel<michal.targiel@accenture.com>, 04/07/2019 STOP
        Boolean mustHaveVAT { get; set; }
        String VATAbsenceReason { get; set; }
        String employeesNumber { get; set; }
        Decimal annualRevenue { get; set; }
        String ONLUSType { get; set; }
        String beneficiariesType { get; set; }
        String beneficiariesDescription { get; set; }
        String PEC { get; set; }

        List<PhonesDTO> phones = new List<PhonesDTO>( );
        AddressDTO registeredOfficeAddress;
        AddressDTO administrativeOfficeAddress;
        List<ContactDTO> contacts = new List<ContactDTO>( );

        @TestVisible
        MerchantDTO( Account merchant, Id merchantId, Id proposerABIId )
        {

            Contact legalReference = new Contact( );

            for ( Contact c : merchant.contacts )
            {
                if ( c.RecordType.DeveloperName == SEDE_LEGALE_RT )
                {
                    legalReference = c ;
                }
            }

            name = merchant.name;
            legalForm = OB_Serialize_Order.decodeval( 'merchant.OB_Legal_Form__c', merchant.OB_Legal_Form__c );
            //OB_Serialize_Order.checkForEmptyLegalFormCode( merchant ); //NEXI-121 Damian Krzyzaniak <damian.krzyzaniak@accenture.com> 17.07.2019  //antonio.vatrano 23/09/2019 wn-448
            vatNumber = merchant.NE__VAT__c;
            taxCode = merchant.NE__Fiscal_code__c;
            //email                             = merchant.NE__E_mail__c ;
            if ( merchant.OB_Year_constitution_company__c != null && merchant.OB_Year_constitution_company__c > 1000 )
            {
                yearConstitutionCompany = String.valueof( merchant.OB_Year_constitution_company__c );
            }
            //yearConstitutionCompany         = String.valueof(merchant.OB_Year_constitution_company__c);
            companyRegistrationNumber = merchant.OB_CCIAA__c;
            provinceChamberOfCommerce = merchant.OB_CCIAA_Province_Code__c;
            commoditySectorCodeSAE = merchant.OB_SAE_Code__c;
            atecoCode = merchant.OB_ATECO__c;
            mustHaveVAT = !merchant.OB_VAT_Not_Present__c;
            //VAbsenceReason                = OB_Serialize_Order.decodeVal('merchant.OB_DescriptionVATNotPresent__c',merchant.OB_DescriptionVATNotPresent__c);
            VATAbsenceReason = OB_Serialize_Order.decodeVal( 'merchant.OB_DescriptionVATNotPresent__c', merchant.OB_DescriptionVATNotPresent__c );

            employeesNumber = !String.isBlank(merchant.OB_Employees_Number__c)? OB_Serialize_Order.decodeVal( 'merchant.OB_Employees_Number__c', merchant.OB_Employees_Number__c ) : ''; //antonio.vatrano wn-456 23/09/2019
            annualRevenue = !String.isBlank(String.valueOf(merchant.OB_Annual_Revenue__c)) ? merchant.OB_Annual_Revenue__c : null;//antonio.vatrano wn-456 23/09/2019

            ONLUSType = OB_Serialize_Order.decodeVal( 'merchant.OB_No_Profit_Class__c', merchant.OB_No_Profit_Class__c ) ;
            beneficiariesDescription = merchant.OB_No_Profit_Recipient_Other__c ;
            beneficiariesType = OB_Serialize_Order.decodeVal( 'merchant.OB_No_Profit_Recipient_Class__c', merchant.OB_No_Profit_Recipient_Class__c );

            nexiCode = merchant.OB_SionID__c ;

            registeredOfficeAddress = new AddressDTO( SEDE_LEGALE, merchant );
            email = legalReference.Email;
            PEC = legalReference.OB_PEC__c;
            phones = serializeContactPhones( legalReference );


            administrativeOfficeAddress = new AddressDTO( SEDE_AMMINISTRATIVA, merchant );
            contacts = OB_Serialize_Order.serializecontacts( merchantId, proposerABIId );
        }
    }

    @TestVisible
    class AddressDTO
    {
        String street ;
        String civicNumber ;
        String careOf ;
        String postalCode ;
        String city ;
        String province ;
        String country ;
        //String district ;

        public boolean isEmpty( )
        {
            return ( String.isBlank( street ) && String.isBlank( civicNumber ) && String.isBlank( careOf )
                    && String.isBlank( postalCode ) && String.isBlank( city ) && String.isBlank( province ) && String.isBlank( country ) );
        }
        AddressDTO( String typ, Account a )
        {
            if ( typ == SEDE_LEGALE )
            {
                street = a.OB_Legal_Address_Street__c;
                civicNumber = a.OB_Legal_Address_Street_Number__c;
                careOf = a.OB_Legal_Address_Detail__c;
                postalCode = a.OB_Legal_Address_ZIP__c;
                city = a.OB_Legal_Address_City__c;
                province = a.OB_Legal_Address_State_Code__c;
                country = a.OB_Legal_Address_Country_Code__c;
                //district      = a.OB_Legal_Address_Hamlet__c;


            }
            if ( typ == SEDE_AMMINISTRATIVA )
            {
                street = a.OB_Administrative_Office_Street__c;
                civicNumber = a.OB_Administrative_Office_Street_number__c;
                careOf = a.OB_Administrative_Office_Address_Details__c;
                postalCode = a.OB_Administrative_Office_ZIP__c;
                city = a.OB_Administrative_Office_City__c;
                province = a.OB_Administrative_Office_State_Code__c;
                country = a.OB_Administrative_Office_Country_Code__c;
                //district      = a.OB_Administrative_Office_Hamlet__c;
            }
        }
        AddressDTO( NE__Order__c c )
        {
            street = c.OB_Service_Point__r.NE__Street__c;
            civicNumber = c.OB_Service_Point__r.OB_Street_Number__c;
            careOf = c.OB_Service_Point__r.OB_Address_Detail__c;
            postalCode = c.OB_Service_Point__r.NE__Zip_Code__c;
            city = c.OB_Service_Point__r.NE__City__c;
            province = c.OB_Service_Point__r.OB_Province_Code__c;
            country = c.OB_Service_Point__r.NE__Country_Code__c;
            //district          = c.OB_Service_Point__r.OB_Address_Hamlet__c;
        }

    }

    public class ResidenceAddressDTO
    {
        String street;
        String civicNumber;
        String careOf;
        String postalCode;
        String city;
        String province;
        String country;
        //String district;

        public boolean isEmpty( )
        {
            return ( String.isBlank( street ) && String.isBlank( civicNumber ) && String.isBlank( careOf )
                    && String.isBlank( postalCode ) && String.isBlank( city ) && String.isBlank( province ) && String.isBlank( country ) );
        }

        ResidenceAddressDTO( Contact co )
        {
            street = co.OB_Address_Street__c;
            civicNumber = co.OB_Address_Street_Number__c;
            postalCode = co.OB_Address_PostalCode__c;
            city = co.OB_Address_City__c;
            province = co.OB_Address_State_Code__c;
            country = co.OB_Address_Country_Code__c;
            //district      = co.OB_Address_Hamlet__c;
        }
    }

    public static List<PhonesDTO> serializeContactPhones( Contact c )
    {
        List<PhonesDTO> tmp = new List<PhonesDTO>( );
        if ( !String.isBlank( c.phone ) )
        {
            PhonesDTO phone = new PhonesDTO( TELEFONO, c.phone );
            tmp.add( phone );
        }
        if ( !String.isBlank( c.mobilephone ) )
        {
            PhonesDTO phoneM = new PhonesDTO( CELLULARE, c.mobilephone );
            tmp.add( phoneM ) ;
        }
        if ( !String.isBlank( c.Fax ) )
        {
            PhonesDTO phoneF = new PhonesDTO( FAX, c.Fax );
            tmp.add( phoneF ) ;
        }

        return tmp;
    }

    public static List<PhonesDTO> serializeServicePointPhones( NE__Order__c c )
    {
        List<PhonesDTO> tmp = new List<PhonesDTO>( );

        if ( !String.isBlank( c.OB_Service_Point__r.OB_Phone_Number__c ) )
        {
            PhonesDTO phone = new PhonesDTO( TELEFONO, c.OB_Service_Point__r.OB_Phone_Number__c );
            tmp.add( phone );
        }
        if ( !String.isBlank( c.OB_Service_Point__r.OB_Mobile_Phone_Number__c ) )
        {
            PhonesDTO phoneM = new PhonesDTO( CELLULARE, c.OB_Service_Point__r.OB_Mobile_Phone_Number__c );
            tmp.add( phoneM ) ;
        }
        if ( !String.isBlank( c.OB_Service_Point__r.OB_Fax_Number__c ) )
        {
            PhonesDTO phoneF = new PhonesDTO( FAX, c.OB_Service_Point__r.OB_Fax_Number__c );
            tmp.add( phoneF ) ;
        }
        return tmp;
    }


    public static List<ServicePointDTO> serializeServicePoint( List<NE__Order__c> configurations, Id merchantId, Id proposerABIId )
    {
        system.debug( '## serializeServicePoint configurations configurations: ' + String.valueOf( configurations ) );
        List<ServicePointDTO> tmp = new List<ServicePointDTO>( );
        for ( NE__Order__c configuration : configurations )
        {
            system.debug( '## Configuration configuration: ' + configuration );
            tmp.add( new ServicePointDTO( configuration, merchantId, proposerABIId ) );
        }
        return tmp;
    }

    public static List<ContactDTO> serializecontacts( Id merchantId, Id proposerABIId )
    {
        List<Contact> contactList = OB_Serialize_Order.getContact( merchantId, proposerABIId );
        List<ContactDTO> tmp = new List<ContactDTO>( );
        for ( Contact c : contactList )
        {
            tmp.add( new ContactDTO( c ) );
        }
        return tmp;
    }
    
    public static List<ContactDTO> serializecontacts( Id merchantId, Id proposerABIId, Id servicePoinId )// elena.preteni chaged signature Id servicePoinId
    {   
        //START - elena.preteni added method to retrieve referents ids
        Set<Id> contactIds = OB_Serialize_Order.gerReferents(merchantId, proposerABIId, servicePoinId);
        //END - elena.preteni added method to retrieve referents ids
        List<Contact> contactList = OB_Serialize_Order.getServicePointContacts( merchantId, proposerABIId, contactIds );
        system.debug( '@@ contactList ' + contactList );
        List<ContactDTO> tmp = new List<ContactDTO>( );
        for ( Contact c : contactList )
        {
            tmp.add( new ContactDTO( c ) );
        }
        return tmp;
    }


    class PhonesDTO
    {
        String modality ;
        String phoneNumber ;

        PhonesDTO( String typ, String num )
        {
            modality = typ;
            phoneNumber = num;
        }
    }


    public class ContactDTO
    {
        String role;
        String firstName;
        String lastName;
        String birthDate;
        String birthCity;
        String birthProvince;
        String birthCountry;
        String fiscalCode;
        String gender;
        String email;
        String citizenship;
        Boolean flagPEP;
        //String companyRelationshipType;
        List<PhonesDTO> Phones = new List<PhonesDTO>( );
        ResidenceAddressDTO residenceAddress;
        DocumentDTO personalDocument;

        ContactDTO( Contact c )
        {
            role = decodeval( 'Contact.OB_Company_link_type__c', c.OB_Company_link_type__c );
            if ( String.isBlank( role ) )
            {
                role = decodeval( 'Contact.RecordType.DeveloperName', c.RecordType.DeveloperName );
            }
            firstName = c.FirstName;
            lastName = c.LastName;
            birthDate = OB_Serialize_Order.serializeDate( c.OB_Birth_Date__c );
            birthCity = c.OB_Birth_City__c;
            birthProvince = c.OB_Birth_State_Code__c;
            birthCountry = c.OB_Country_Birth_Code__c;
            fiscalCode = c.OB_Fiscal_code__c;
            gender = c.OB_Sex__c;
            email = c.Email;
            citizenship = OB_Serialize_Order.decodeval( 'COUNTRY', c.OB_Citizenship__c );
            flagPEP = c.OB_PEP__c;
            Phones = OB_Serialize_Order.serializeContactPhones( c );
            //companyRelationshipType = decodeval('Contact.OB_Company_link_type__c',c.OB_Company_link_type__c);
            ResidenceAddressDTO tmpAddr = new ResidenceAddressDTO( c );

            if ( !tmpAddr.isEmpty( ) )
            {
                residenceAddress = tmpAddr;
            }

            DocumentDTO tmpDoc = new DocumentDTO( c );
            if ( !tmpDoc.isEmpty( ) )
            {
                personalDocument = tmpDoc;
            }


        }
    }
    public class DocumentDTO
    {
        String documentType ;
        String documentNumber ;
        String releaseDate ;
        String expirationDate ;
        String releaseAuthority ;
        String releaseCity ;
        String releaseProvince ;
        String releaseCountry ;

        public Boolean isEmpty( )
        {
            Boolean isEmptyDocument = String.isBlank( documentType ) && String.isBlank( documentNumber ) ;
            isEmptyDocument = isEmptyDocument && String.isBlank( releaseAuthority ) && String.isBlank( releaseCity );
            isEmptyDocument = isEmptyDocument && String.isBlank( releaseProvince ) && String.isBlank( releaseCountry );
            return isEmptyDocument;
        }

        DocumentDTO( Contact c )
        {
            documentType = OB_Serialize_Order.decodeval( 'contact.OB_Document_Type__c', c.OB_Document_Type__c );
            documentNumber = c.OB_Document_Number__c;
            releaseDate = OB_Serialize_Order.serializeDate( c.OB_Document_Release_Date__c );
            expirationDate = OB_Serialize_Order.serializeDate( c.OB_Document_Expiration_Date__c );
            //  START   micol.ferrari 08/11/2018
            system.debug( '## c.OB_Document_Release_Authority__c: ' + c.OB_Document_Release_Authority__c );
            releaseAuthority = c.OB_Document_Release_Authority__c != null && c.OB_Document_Release_Authority__c != '' ? c.OB_Document_Release_Authority__c.toUpperCase( ) : '';
            //releaseAuthority = c.OB_Document_Release_Authority__c.toUpperCase();
            //  END     micol.ferrari 08/11/2018
            releaseCity = c.OB_Document_Release_City__c;
            releaseProvince = c.OB_Document_Release_State_Code__c;
            releaseCountry = c.OB_Document_Release_Country_Code__c; //TO DO MAPPING
        }
    }

    public static List<BankAccountDTO> serializeBankAccount( Id posBP, Id acquiringBP )
    {
        List<BankAccountDTO> tmp = new List<BankAccountDTO>( );
        if(!String.isBlank(posBP)){ //gianluigi.virga 19/09/2019
            tmp.add( new BankAccountDTO( OB_Serialize_Order.getBillingProfile( posBP ), 'POS' ) );
        }
        if(!String.isBlank(acquiringBP)){ //gianluigi.virga 19/09/2019
            tmp.add( new BankAccountDTO( OB_Serialize_Order.getBillingProfile( acquiringBP ), 'Acquiring' ) );
        }
        return tmp;
    }

    public class BankAccountDTO
    {
        String iban ;
        String countryCode ;
        String checkNumber ;
        String CIN ;
        String ABI ;
        String CAB ;
        String bankAccountNumber ;
        String accountHolder ;
        String accountType ;

        BankAccountDTO( NE__Billing_Profile__c bp, String bpType )
        {
            iban = bp.OB_IBAN__c;
            countryCode = bp.OB_CountryCode__c;
            checkNumber = bp.OB_EuroControlCode__c;
            CIN = bp.OB_CINCode__c;
            ABI = bp.OB_ABICode__c;
            CAB = bp.OB_CABCode__c;
            bankAccountNumber = bp.OB_Bank_Account_Number__c;
            accountHolder = bp.OB_HeaderInternational__c;
            accountType = bpType;

        }

    }
    public class OpeningTimeDTO
    {
        String openingHour;
        String closingHour;
        String startBreak;
        String endBreak;
        String startSeasonalActivity;
        String endSeasonalActivity;
        openingDaystDTO openingDays = new openingDaystDTO( );
        OpeningTimeDTO( NE__Order__c c )
        {
            openingHour = OB_Serialize_Order.serializeTime( c.OB_Service_Point__r.OB_Opening_Time__c );
            closingHour = OB_Serialize_Order.serializeTime( c.OB_Service_Point__r.OB_Ending_Time__c );
            startBreak = OB_Serialize_Order.serializeTime( c.OB_Service_Point__r.OB_Break_Start_Time__c );
            endBreak = OB_Serialize_Order.serializeTime( c.OB_Service_Point__r.OB_Break_End_Time__c );
            startSeasonalActivity = c.OB_Service_Point__r.OB_Start_Seasonal__c;
            endSeasonalActivity = c.OB_Service_Point__r.OB_End_Seasonal__c;

            openingDays.mondayMorning = c.OB_Service_Point__r.OB_Opening_Monday_Morning__c;
            openingDays.mondayAfternoon = c.OB_Service_Point__r.OB_Opening_Monday_Afternoon__c;
            openingDays.tuesdayMorning = c.OB_Service_Point__r.OB_Opening_Tuesday_Morning__c;
            openingDays.tuesdayAfternoon = c.OB_Service_Point__r.OB_Opening_Tuesday_Afternoon__c;
            openingDays.wednesdayMorning = c.OB_Service_Point__r.OB_Opening_Wednesday_Morning__c;
            openingDays.wednesdayAfternoon = c.OB_Service_Point__r.OB_Opening_Wednesday_Afternoon__c;
            openingDays.thursdayMorning = c.OB_Service_Point__r.OB_Opening_Thursday_Morning__c;
            openingDays.thursdayAfternoon = c.OB_Service_Point__r.OB_Opening_Thursday_Afternoon__c;
            openingDays.fridayMorning = c.OB_Service_Point__r.OB_Opening_Friday_Morning__c;
            openingDays.fridayAfternoon = c.OB_Service_Point__r.OB_Opening_Friday_Afternoon__c;
            openingDays.saturdayMorning = c.OB_Service_Point__r.OB_Opening_Saturday_Morning__c;
            openingDays.saturdayAfternoon = c.OB_Service_Point__r.OB_Opening_Saturday_Afternoon__c;
            openingDays.sundayMorning = c.OB_Service_Point__r.OB_Opening_Sunday_Morning__c;
            openingDays.sundayAfternoon = c.OB_Service_Point__r.OB_Opening_Sunday_Afternoon__c;
        }
    }
    public class openingDaystDTO
    {
        Boolean mondayMorning;
        Boolean mondayAfternoon;
        Boolean tuesdayMorning;
        Boolean tuesdayAfternoon;
        Boolean wednesdayMorning;
        Boolean wednesdayAfternoon;
        Boolean thursdayMorning;
        Boolean thursdayAfternoon;
        Boolean fridayMorning;
        Boolean fridayAfternoon;
        Boolean saturdayMorning;
        Boolean saturdayAfternoon;
        Boolean sundayMorning;
        Boolean sundayAfternoon;
    }
    public class AcquiringDTO
    {
        List<OB_Order_Wrapper.RailsDTO> schemes = new List<OB_Order_Wrapper.RailsDTO>( );
        String typeOfAccountStatement;

        AcquiringDTO( Id configId )
        {
            schemes = so.serializeAcquiring( configId );
            if ( schemes.size( ) > 0 )
            {
                typeOfAccountStatement = so.geAccountStatement( configId );
            }

        }
    }

    public class ServicePointDTO
    {
        String externalId;
        String shopName;
        String merchantCategoryCode;
        String receiptHeader;
        String receiptLocation;
        String paymentModel;
        String contractTemplate = 'SFDCACQLICENSING';
        String contractTemplateVersion = '1';
        String offerCode;
        String email;
        String PEC;
        Boolean flagPrivacyC3;
        Boolean flagPrivacyC4;
        Boolean flagPrivacyC5;
        OpeningTimeDTO openingTimes;
        String priorVerificationNumber; //TO DO
        String ctiCode; // @dg 25/02/2019 old value: CTICode
        String assistanceNumber; // @dg 25/02/2019 old value: CTIPhoneNumber

        AddressDTO address;
        List<PhonesDTO> phones;
        List<ContactDTO> contacts;
        // TO DO 
        List <BankAccountDTO> bankAccountDetails;
        List<OB_Order_Wrapper.TerminalDTO> terminals = new List<OB_Order_Wrapper.TerminalDTO>( );
        AcquiringDTO acquiring;
        //List<OB_Order_Wrapper.BancomatDTO> pagoBancomatBancario = new List<OB_Order_Wrapper.BancomatDTO>();
        OB_Order_Wrapper.BancomatDTO pagoBancomatBancario = null;


        List<OB_Order_Wrapper.VasDTO> VAS = new List<OB_Order_Wrapper.VasDTO>( );

        ServicePointDTO( NE__Order__c c, Id merchantId, Id proposerABIId )
        {
            system.debug( '## Configuration c: ' + c );
            externalId = c.Id;
            ctiCode = c.OB_CTI_Code__c;
            assistanceNumber = c.OB_Numero_Assitenza_POS__c ; //TO DO
            shopName = c.OB_ShopSign__c ;
            merchantCategoryCode = c.OB_MCC__c;
            receiptHeader = c.OB_ReceiptHeader__c;
            receiptLocation = c.OB_ReceiptCity__c ;
            paymentModel = OB_Serialize_Order.decodeval( 'OB_InternationalSettlementMethod__c', c.OB_FormulaInternationalSettlementMethod__c ) ;
            offerCode = c.NE__Order_Items__r[ 0 ].NE__ProdId__r.OB_Codice_sfdc__c;
            email = c.OB_Service_Point__r.OB_Email__c;
            PEC = c.OB_Service_Point__r.OB_PEC__c;
            flagPrivacyC3 = c.OB_Service_Point__r.OB_Privacy_C3__c;
            flagPrivacyC4 = c.OB_Service_Point__r.OB_Privacy_C4__c;
            flagPrivacyC5 = c.OB_Service_Point__r.OB_Privacy_C5__c;
            openingTimes = new OpeningTimeDTO( c );

            AddressDTO tmpAddress = new AddressDTO( c );
            if ( !tmpAddress.isEmpty( ) )
            {
                address = tmpAddress;
            }

            phones = OB_Serialize_Order.serializeServicePointPhones( c );
            priorVerificationNumber = c.NE__Order_Header__r.OB_PreliminaryVerificationCode__c ;
            if ( c.NE__Order_Header__r.OB_Main_Process__c != MAINTENANCE || ( c.NE__BillingProfId__c != null && c.OB_BankAccount_Acquiring__c != null ) )
            {
                bankAccountDetails = OB_Serialize_Order.serializeBankAccount( c.NE__BillingProfId__c, c.OB_BankAccount_Acquiring__c );
            }

            // Set<Id> contactIds = new Set<Id>( );

            // if ( c.OB_Service_Point__r.OB_ServicePointAdminResponsible__c != null )
            // {
            //     system.debug( '@@ contact ' + c.OB_Service_Point__r.OB_ServicePointAdminResponsible__c );
            //     contactIds.add( c.OB_Service_Point__r.OB_ServicePointAdminResponsible__c );
            // }
            // if ( c.OB_Service_Point__r.OB_ServicePointResponsible__c != null )
            // {
            //     system.debug( '@@ contact ' + c.OB_Service_Point__r.OB_ServicePointResponsible__c );
            //     contactIds.add( c.OB_Service_Point__r.OB_ServicePointResponsible__c );
            // }
            // if ( c.OB_Service_Point__r.OB_TechnicalReferent__c != null )
            // {
            //     system.debug( '@@ contact ' + c.OB_Service_Point__r.OB_TechnicalReferent__c );
            //     contactIds.add( c.OB_Service_Point__r.OB_TechnicalReferent__c );
            // }
            // if ( !contactIds.isEmpty( ) )
            // {
            //START -  elena.preteni 18/06/2019 change signature  c.OB_Service_Point__r.Id 
            contacts = OB_Serialize_Order.serializecontacts( merchantId, proposerABIId, c.OB_Service_Point__r.Id );
            //END - elena.preteni 18/06/2019 change signature  c.OB_Service_Point__r.Id 
            // }

            terminals = so.serializeTerminals( c.Id );
            acquiring = new acquiringDTO( c.Id );
            pagoBancomatBancario = so.serializeBancomat( c.Id );
            VAS = so.serializeVas( c.Id );
        }
    }

    public static Account getMerchant( Id merchantId, Id proposerABIId )
    {

        return
        [
                Select Id,Name,OB_Legal_Form__c,OB_Legal_Form_Code__c,NE__VAT__c,NE__Fiscal_code__c,NE__E_mail__c,
                        OB_Year_constitution_company__c, OB_CCIAA__c, OB_CCIAA_Province__c, OB_CCIAA_Province_Code__c,
                        OB_SAE_Code__c, OB_ATECO__c, OB_VAT_Not_Present__c,OB_Administrative_Office_State_Code__c, OB_Legal_Address_Street__c,
                        OB_Legal_Address_Street_Number__c,OB_Legal_Address_Detail__c,OB_Legal_Address_ZIP__c, OB_Legal_Address_City__c,
                        OB_Legal_Address_Country__c,OB_Legal_Address_Hamlet__c, OB_Administrative_Office_Street__c,OB_Administrative_Office_Street_number__c,
                        OB_Administrative_Office_Address_Details__c,OB_Administrative_Office_ZIP__c,OB_Administrative_Office_City__c,
                        OB_Administrative_Office_Country__c,OB_Administrative_Office_Hamlet__c,OB_Legal_Address_Country_Code__c,OB_Administrative_Office_Country_Code__c,
                        OB_No_Profit_Class__c, OB_No_Profit_Recipient_Other__c, OB_No_Profit_Recipient_Class__c,OB_DescriptionVATNotPresent__c,
                        OB_Employees_Number__c,OB_Annual_Revenue__c,OB_Legal_Address_State_Code__c,OB_SionID__c,
                (
                        select id,Name,Email, OB_PEC__C, Phone, MobilePhone,Fax,RecordType.DeveloperName
                        from contacts
                        where OB_bank__c = :proposerABIId
                        and RecordType.DeveloperName = :SEDE_LEGALE_RT
                )
                from Account
                where id = :merchantId
                LIMIT 1
        ];
    }

    public NE__Order_Header__c getOrderHeader( Id headerId )
    {

        return
        [
                SELECT Id,CreatedDate,OB_Main_Process__c,name,OB_ProposerABI__c,OB_ProposerABI__r.OB_ABI__c,OB_Report_Type__c,NE__Type__c,NE__Order_date__c
                        ,OB_Report_Type_Format__c,NE__AccountId__c,NE__AccountId__r.OB_Bank_owner__r.OB_ABI__c,
                        OB_Business_Model_Acquiring__c,OB_Business_Model_POS__c, OB_NDG__c,OB_Sub_Process__c, //elena.preteni added OB_Sub_Process__c 26/06/2019
                ( select id,OB_AgreedChanges__c from NE__Configurations__r )//elena.preteni added OB_AgreedChanges__c 26/06/2019
                FROM NE__Order_Header__c
                where id = :headerId
                LIMIT 1
        ];
    }


    public static List<Contact> getContact( Id merchantId, Id proposerABIId )
    {
        return
        [
                select id,FirstName,LastName,OB_Sex__c,OB_Fiscal_code__c,OB_Birth_Date__c,OB_Birth_State__c,OB_Country_Birth__c,OB_Country_Birth_Code__c
                        ,OB_Citizenship__c,OB_Birth_State_Code__c,OB_Company_Link_Type__c,OB_PEP__c,OB_Address_Street__c
                        ,OB_Address_Street_Number__c,OB_Address_PostalCode__c,OB_Address_City__c,OB_Address_Hamlet__c
                        ,OB_Address_State__c,OB_Address_State_Code__c,OB_Address_Country__c,OB_Address_Country_Code__c,Email, OB_Birth_City__c, Phone, MobilePhone,Fax
                        ,OB_Document_Type__c,OB_Document_Number__c,OB_Document_Release_Date__c,OB_Document_Expiration_Date__c,OB_Document_Release_Authority__c
                        ,OB_Document_Release_City__c,OB_Document_Release_State__c,OB_Document_Release_State_Code__c,OB_Document_Release_Country__c,OB_Document_Release_Country_Code__c,RecordType.DeveloperName
                from contact
                where AccountId = :merchantId and OB_Bank__c = :proposerABIId and RecordType.DeveloperName != :SEDE_LEGALE_RT
                // michele.lubrano@accenture.com 29-05-2019 -- filtering inactive contacts
                and RecordType.DeveloperName != :REFERENTE_PV_RT and RecordType.DeveloperName != :REFERENTE_TEC_RT and RecordType.DeveloperName != :REFERENTE_AMM_PV_RT and OB_Contact_State__c =: OB_Serialize_Order.ACTIVE
        ];
    }

    public static List<Contact> getServicePointContacts( Id merchantId, Id proposerABIId, Set<Id> contactIds )
    {
        return
        [
                select id,FirstName,LastName,OB_Sex__c,OB_Fiscal_code__c,OB_Birth_Date__c,OB_Birth_State__c,OB_Country_Birth__c,OB_Country_Birth_Code__c
                        ,OB_Citizenship__c,OB_Birth_State_Code__c,OB_Company_Link_Type__c,OB_PEP__c,OB_Address_Street__c
                        ,OB_Address_Street_Number__c,OB_Address_PostalCode__c,OB_Address_City__c,OB_Address_Hamlet__c
                        ,OB_Address_State__c,OB_Address_State_Code__c,OB_Address_Country__c,OB_Address_Country_Code__c,Email, OB_Birth_City__c, Phone, MobilePhone,Fax
                        ,OB_Document_Type__c,OB_Document_Number__c,OB_Document_Release_Date__c,OB_Document_Expiration_Date__c,OB_Document_Release_Authority__c
                        ,OB_Document_Release_City__c,OB_Document_Release_State__c,OB_Document_Release_State_Code__c,OB_Document_Release_Country__c,OB_Document_Release_Country_Code__c,RecordType.DeveloperName
                from contact
                where AccountId = :merchantId and OB_Bank__c = :proposerABIId
                //and   (RecordType.DeveloperName = :REFERENTE_AMM_PV_RT or RecordType.DeveloperName = :REFERENTE_PV_RT or RecordType.DeveloperName = :REFERENTE_TEC_RT)
                and Id in :contactIds
        ];
    }

    public static List<NE__Order__c> getConfigurations( Id headerId )
    {
        return
        [
                SELECT Id,OB_Service_Point__r.Name,OB_MCC__c,OB_Service_Point__r.OB_Service_Point_Name__c,OB_Service_Point__r.OB_Service_Point_City__c
                        ,OB_Service_Point__r.OB_Privacy_C3__c,OB_Service_Point__r.OB_Privacy_C4__c,OB_Service_Point__r.OB_Privacy_C5__c
                        ,OB_Service_Point__r.NE__Street__c,OB_Service_Point__r.OB_Street_Number__c,OB_Service_Point__r.OB_Address_Detail__c
                        ,OB_Service_Point__r.NE__Zip_Code__c,OB_Service_Point__r.NE__City__c,OB_Service_Point__r.OB_Province_Code__c,OB_Service_Point__r.NE__Country_Code__c
                        ,OB_Service_Point__r.OB_Address_Hamlet__c,OB_Service_Point__r.OB_Phone_Number__c,OB_Service_Point__r.OB_Mobile_Phone_Number__c
                        ,OB_Service_Point__r.OB_Fax_Number__c,OB_Service_Point__r.OB_Email__c, OB_Service_Point__r.OB_PEC__c
                        // ,OB_Service_Point__r.OB_ServicePointAdminResponsible__c,OB_Service_Point__r.OB_ServicePointResponsible__c, OB_Service_Point__r.OB_TechnicalReferent__c elena.preteni 25/06/2019 no more neede
                        ,OB_Service_Point__r.OB_Opening_Monday_Morning__c,OB_Service_Point__r.OB_Opening_Monday_Afternoon__c
                        ,OB_Service_Point__r.OB_Opening_Tuesday_Morning__c, OB_Service_Point__r.OB_Opening_Tuesday_Afternoon__c,OB_Service_Point__r.OB_Opening_Wednesday_Morning__c
                        ,OB_Service_Point__r.OB_Opening_Wednesday_Afternoon__c,OB_Service_Point__r.OB_Opening_Thursday_Morning__c,OB_Service_Point__r.OB_Opening_Thursday_Afternoon__c
                        ,OB_Service_Point__r.OB_Opening_Friday_Morning__c,OB_Service_Point__r.OB_Opening_Friday_Afternoon__c,OB_Service_Point__r.OB_Opening_Saturday_Morning__c
                        ,OB_Service_Point__r.OB_Opening_Saturday_Afternoon__c,OB_Service_Point__r.OB_Opening_Sunday_Morning__c,OB_Service_Point__r.OB_Opening_Sunday_Afternoon__c,OB_Service_Point__r.OB_Workshift__c
                        ,OB_Service_Point__r.OB_Break_Start_Time__c, OB_Service_Point__r.OB_Break_End_Time__c, OB_Service_Point__r.OB_Opening_Time__c
                        ,OB_Service_Point__r.OB_Ending_Time__c, OB_Service_Point__r.OB_Start_Seasonal__c, OB_Service_Point__r.OB_End_Seasonal__c
                        ,OB_ReceiptCity__c,OB_ReceiptHeader__c,OB_ShopSign__c,NE__Order_Header__r.OB_Main_Process__c
                        ,OB_PBSettlementMethod__c, OB_FormulaInternationalSettlementMethod__c, NE__Order_Header__r.OB_PreliminaryVerificationCode__c
                        ,NE__BillingProfId__c,OB_BankAccount_Acquiring__c,OB_CTI_Code__c,OB_Numero_Assitenza_POS__c,
                ( select Id,name,NE__ProdId__r.Name,NE__ProdId__r.OB_Codice_sfdc__c from NE__Order_Items__r where NE__Bundle_Element__c = null and NE__Root_Order_Item__c = null ),
				 //michele.lubrano@accenture.com 10/05/2019 START
                OB_Petitioner__c,OB_Note__c,OB_RequestDate__c,OB_Unistallation_Procedure__c
                //michele.lubrano@accenture.com 10/05/2019 END
																
																						   
															  
                FROM NE__Order__c
                where NE__Order_Header__c = :headerId
        ];
    }

    public static NE__Billing_Profile__c getBillingProfile( Id bpId )
    {
        return
        [
                SELECT Id, OB_IBAN__c, OB_CountryCode__c, OB_EuroControlCode__c
                        ,OB_CINCode__c, OB_ABICode__c, OB_CABCode__c, OB_Bank_Account_Number__c
                        ,OB_HeaderInternational__c
                from NE__Billing_Profile__c
                where Id = :bpId
                LIMIT 1
        ];
    }
     /**
    * @author Elena Preteni <elena.preteni@accenture.com>
    * @date 18/06/2019
    * @description The method execute query on Cntacts to retrives referents for a service point
    * @history 18/06/2019 Created
    **/
    public static Set<Id> gerReferents (Id merchantId, Id proposerABIId, Id servicePoinId )
    {
        Set<Id> referentsId = new  Set<Id>();
        List<Contact> contacts = [ SELECT  id FROM contact WHERE AccountId = :merchantId AND OB_Bank__c = :proposerABIId AND OB_Service_Point__c = :servicePoinId AND 
                                                                (RecordType.DeveloperName = :REFERENTE_AMM_PV_RT or RecordType.DeveloperName = :REFERENTE_PV_RT or RecordType.DeveloperName = :REFERENTE_TEC_RT)];
        for(Contact cons : contacts){
            referentsId.add(cons.Id);
        }
      
        return referentsId;
    }
    /*******************************************************************************
    Purpose:  Method to check if legal form code is empty on a merchant(Account) and it fills it with code from list of values which matches the legal form
    Parameters: Account merchant
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       12/07/2019      Created         NEXI-121
    ********************************************************************************/
    @TestVisible
    public static void checkForEmptyLegalFormCode( Account merchant )
    {
        System.debug( LoggingLevel.INFO, 'OB_Serialize_Order.checkForEmptyLegalFormCode: merchant(Account) value: ' + merchant );
        if ( merchant == null )
        {
            return;
        }
        if ( String.isBlank( merchant.OB_Legal_Form_Code__c ) && String.isNotBlank( merchant.OB_Legal_Form__c ) )
        {

            List<NE__Lov__c> lovs = [ SELECT Name, NE__Value1__c FROM NE__Lov__c where NE__Type__c = :OB_UtilityConstants.TYPE_LEGALFORM and name = :merchant.OB_Legal_Form__c LIMIT 1 ];
            merchant.OB_Legal_Form_Code__c = ( lovs.size( ) == 1 ) ? lovs.get( 0 ).NE__Value1__c : null;
            try
            {
                update merchant;
            } catch ( Exception ex )
            {
                System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            }
        }
        return;
    }
}