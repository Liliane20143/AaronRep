/*
ANDREA MORITTU: HANDLER OF BILLING PROFILE TRIGGER
23/10/2018
*/global without sharing class OB_BillingProfileTriggerHandler
{

    String space = ' ';
    String quote = '\'';

    //	START 	micol.ferrari 23/11/2018
    //public String userId = Userinfo.getuserid();
    //public list<User> listOfUsers = [SELECT id, contactId , contact.accountId, Profile.UserLicense.Name, OB_CAB__C, OB_ABI__c
    //						FROM User
    //						WHERE Id =: userId
    //						LIMIT 1];
    //	END 	micol.ferrari 23/11/2018

    /* ------------------------------------------------------------------------------------------------------------------------------ 		*/
    /*USER COULD INSERT THESE SPECIAL CHAR : (	)	”	?	!	&	% 	$	£  	=	^ 	°	\ 	/	AlphabeticChars and Numeric Chars    	*/
    /* -----------------------------------------------------------------------------------------------------------------------------	 	*/
    //  micol.ferrari 28/11/2019 - PROD-207 - START
    public String acceptedLetterChar = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ';
    //  micol.ferrari 28/11/2019 - PROD-207 - STOP
    public String acceptedNumber = '0123456789';
    public String acceptedSpecialChars = '.()”?!&%$£=^°//\\ ';
    // ANDREA: First Part of algorthm, available in : https://en.wikipedia.org/wiki/International_Bank_Account_Number#Example
    //Step #1 : rearranging the IBAN string by moving the first four digits to the end
    //The algorithm is available here:
    public static String rearrange( String iban )
    {
        //ITALIAN  RIGHT IBAN EXAMPLE =  'IT60X0542811101000000123456';
        //ITALIAN  WRONG IBAN EXAMPLE =  'IT60X0542811101000000123452';
        iban = iban.trim( ).toUpperCase( );
        iban = iban.replaceAll( '(\\s+)', '' );
        String start = iban.substring( 0, 4 );
        String ending = iban.substring( 4 );
        String rearranged = ending + start;

        System.debug( '####rearranged : ' + rearranged );
        return rearranged;
    }

    //Step #2 : converting the letters to their corresponding numbers
    //The algorithm is available here:
    //https://en.wikipedia.org/wiki/International_Bank_Account_Number#Example
    public static String convertToInteger( String iban )
    {
        iban = iban.replaceAll( 'A', '10' );
        iban = iban.replaceAll( 'B', '11' );
        iban = iban.replaceAll( 'C', '12' );
        iban = iban.replaceAll( 'D', '13' );
        iban = iban.replaceAll( 'E', '14' );
        iban = iban.replaceAll( 'F', '15' );
        iban = iban.replaceAll( 'G', '16' );
        iban = iban.replaceAll( 'H', '17' );
        iban = iban.replaceAll( 'I', '18' );
        iban = iban.replaceAll( 'J', '19' );
        iban = iban.replaceAll( 'K', '20' );
        iban = iban.replaceAll( 'L', '21' );
        iban = iban.replaceAll( 'M', '22' );
        iban = iban.replaceAll( 'N', '23' );
        iban = iban.replaceAll( 'O', '24' );
        iban = iban.replaceAll( 'P', '25' );
        iban = iban.replaceAll( 'Q', '26' );
        iban = iban.replaceAll( 'R', '27' );
        iban = iban.replaceAll( 'S', '28' );
        iban = iban.replaceAll( 'T', '29' );
        iban = iban.replaceAll( 'U', '30' );
        iban = iban.replaceAll( 'V', '31' );
        iban = iban.replaceAll( 'W', '32' );
        iban = iban.replaceAll( 'X', '33' );
        iban = iban.replaceAll( 'Y', '34' );
        iban = iban.replaceAll( 'Z', '35' );

        return iban;
    }

    //Step #3 : Performs modulos by doing a sequence of modulos 97 on the formatted IBAN string
    //The algorithm is available here:
    //https://en.wikipedia.org/wiki/International_Bank_Account_Number#Example
    public static Long performModulos( String iban )
    {

        //Doing a mod 97 on the first 9-digits chunk
        String part1 = iban.substring( 0, 9 );
        System.debug( '####part1 : ' + part1 );
        Long result1 = Math.mod( Long.valueOf( part1 ), Long.valueOf( '97' ) );

        Integer currentPosition = 9;
        Boolean digitsRemaining = true;
        Long result = result1;
        String partN;

        //Doing a mod 97 on the next 7-digits chunk
        //Or the last chunk if there is less than 7 digits remaining
        while ( digitsRemaining )
        {

            if ( iban.length( ) < ( currentPosition + 7 ) )
            {
                digitsRemaining = false;
            }

            if ( digitsRemaining )
            {
                partN = String.valueOf( result ) + iban.substring( currentPosition, currentPosition + 7 );
                System.debug( '####part ' + currentPosition + ' to ' + currentPosition + 7 );
                result = Math.mod( Long.valueOf( partN ), Long.valueOf( '97' ) );
            }
            else
            {
                partN = String.valueOf( result ) + iban.substring( currentPosition );
                System.debug( '####part ' + currentPosition + ' to end' );
                result = Math.mod( Long.valueOf( partN ), Long.valueOf( '97' ) );
            }

            currentPosition += 7;
        }

        return result;
    }

    public static boolean validateIban( String iban )
    {
        //iban  = 'GB82 WEST 1234 5698 7654 32';
        //iban  = 'DE89 3704 0044 0532 0130 00';
        //iban  = 'FR14 2004 1010 0505 0001 3M02 606';
        //iban  = 'FR7610807004090232158413487';
        //iban  = 'FR76 1670 7000 1901 1215 8931 852';
        //iban =  'IT60 X054 2811 1010 0000 0123 456';
        //iban = 'IT60X0542811101000000123456';
        //Step #1 : rearranging the IBAN string by moving the first four digits to the end
        iban = rearrange( iban );
        //Step #2 : converting the letters to their corresponding numbers
        iban = convertToInteger( iban );
        //Step #3 : Performs modulos by doing a sequence of modulos 97 on the formatted IBAN string
        Long result;
        result = performModulos( iban );
        //If the result is 1, then the IBAN is valid
        System.debug( 'result' + result );
        return result == 1;
    }

    // METHOD TO INTAKE BOOLEAN PARAMETER TO TEST IF AN IBAN IS VALID OR NOT
    public void checkValidityOnIban( List<NE__Billing_Profile__c> billProfs, List<NE__Billing_Profile__c> oldBillProfs )
    {

        //	START 	micol.ferrari 23/11/2018
        Boolean userSkipValidation = false;
        if ( !billProfs.isEmpty( ) )
        {
            userSkipValidation = billProfs.get( 0 ).OB_UserSkipValidation__c;
        }
        //	END 	micol.ferrari 23/11/2018
        if ( !userSkipValidation )
        {
            System.debug( '@@@@ I AM IN MY IBAN METHOD!!!!!' );
            //if(currentUser.OB_CAB__c != 'SKIP'){
            Map<Id, NE__Billing_Profile__c> mapOfOldBill = new Map<Id, NE__Billing_Profile__c>( );
            if ( null != oldBillProfs && !oldBillProfs.isEmpty( ) )
            {
                for ( NE__Billing_Profile__c oldBillprof : oldBillProfs )
                {
                    mapOfOldBill.put( oldBillprof.Id, oldBillprof );
                    System.debug( 'mapOfOldBill is ' + mapOfOldBill );
                }
            }
            for ( NE__Billing_Profile__c billProf : billProfs )
            {
                System.debug( 'billProf.OB_BypassValidation__c is: ' + billProf.OB_BypassValidation__c );
                if ( billProf.OB_BypassValidation__c == false )
                {
                    try
                    {
                        Boolean enableValidation = !mapOfOldBill.containsKey( billProf.Id ) || ( mapOfOldBill.containsKey( billProf.Id ) && mapOfOldBill.get( billProf.Id ).OB_BypassValidation__c == billProf.OB_BypassValidation__c );
                        Boolean enableUpdate = !mapOfOldBill.containsKey( billProf.Id ) || ( mapOfOldBill.containsKey( billProf.Id ) && mapOfOldBill.get( billProf.Id ).NE__Iban__c != billProf.NE__Iban__c );

                        String iban = billProf.NE__Iban__c;
                        String abi = billProf.OB_ABICode__c;
                        String cab = billProf.OB_CABCode__c;
                        String cin = billProf.OB_CINCode__c;
                        String bankAccNumber = billProf.OB_Bank_Account_Number__c ;
                        String euroControlCode = billProf.OB_EuroControlCode__c;
                        String countryCode = billProf.OB_CountryCode__c;

                        system.debug( 'enableValidation is: ' + enableValidation );
                        system.debug( 'enableUpdate is: ' + enableUpdate );
                        if ( enableValidation && enableUpdate )
                        {
                            if ( !( String.isBlank( abi ) ) && !( String.isBlank( cab ) ) && !( String.isBlank( cin ) ) && !( String.isBlank( bankAccNumber ) ) && !String.isBlank( euroControlCode ) )
                            {
                                system.debug( 'abi is: ' + abi );
                                system.debug( 'cab is: ' + cab );
                                system.debug( 'cin is: ' + cin );
                                system.debug( 'bankAccNumber is:' + bankAccNumber );
                                system.debug( 'euroControlCode is: ' + euroControlCode );

                                Boolean validAbi;
                                Boolean validCab;
                                Boolean validCin;
                                Boolean validBankAccNumber;
                                Boolean validEuroControlCode;
                                // acceptedLetterChar acceptedNumber acceptedSpecialChars

                                if ( abi.containsOnly( acceptedNumber ) && abi.length( ) == 5 )
                                {
                                    validAbi = true;
                                }
                                else if ( !abi.containsOnly( acceptedNumber ) || abi.length( ) != 5 )
                                {
                                    billProf.OB_ABICode__c.addError( Label.OB_InvalidABILabel );
                                }

                                if ( cab.length( ) == 5 && cab.isNumeric( ) )
                                {
                                    validCab = true;
                                }
                                else if ( cab.length( ) != 5 || !cab.isNumeric( ) )
                                {
                                    billProf.OB_CABCode__c.addError( Label.OB_InvalidCABLabel );
                                }
                                cin = cin.toLowerCase( );
                                if ( cin.length( ) == 1 && cin.containsOnly( acceptedLetterChar ) )
                                {
                                    validCin = true;
                                }
                                else
                                {
                                    billProf.OB_CINCode__c.addError( Label.OB_InvalidCINLabel );
                                }
                                bankAccNumber = bankAccNumber.toLowerCase( );
                                //NEXI-366 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/10/2019 Start
                                if ( bankAccNumber.length( ) == 12 )
                                {
                                    validBankAccNumber = true;
                                }
                                else
                                {
                                    billProf.OB_Bank_Account_Number__c.addError( Label.OB_InvalidBankAccNumberLabel );
                                    validBankAccNumber = false;
                                }
                                //NEXI-366 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/10/2019 Stop

                                if ( euroControlCode.length( ) == 2 && euroControlCode.isNumeric( ) )
                                {
                                    validEuroControlCode = true;
                                }
                                else if ( euroControlCode.length( ) != 2 || !euroControlCode.isNumeric( ) )
                                {
                                    billProf.OB_EuroControlCode__c.addError( Label.OB_InvalidEuroControlCodeLabel );
                                }
                                System.debug( 'valid abi is: ' + validAbi );
                                System.debug( 'valid cab is: ' + validCab );
                                System.debug( 'valid cin is: ' + validCin );
                                System.debug( 'bank acc numb is: ' + validBankAccNumber );
                                System.debug( 'euro contr is: ' + validEuroControlCode );

                                /*----------------	VALIDATION OF IBAN: IF IT DOES NOT MATCH				------------------------------------
                                ----------------	WITH CONCATENATION of CountryCode, EuroControlCode, --------------------------------
                                ----------------	Cin, Abi, Cab & BankAccNumber, LAUNCH AN ERROR ------------------------------------*/
                                if ( validAbi && validCab && validCin && validBankAccNumber && validEuroControlCode )
                                {
                                    if ( !String.isBlank( iban ) )
                                    {
                                        String finalIbanMatcher = countryCode + euroControlCode + cin + abi + cab + bankAccNumber;
                                        finalIbanMatcher = finalIbanMatcher.ToLowerCase( );
                                        iban = iban.toLowerCase( );

                                        System.debug( 'finalIbanMatcher is: ' + finalIbanMatcher );
                                        System.debug( 'iban is: ' + iban );
                                        if ( finalIbanMatcher != iban )
                                        {
                                            billProf.NE__Iban__c.addError( Label.OB_IbanDoesNotMatchLabel );
                                        }
                                        else
                                        {
                                            Boolean resultIBANValidation = OB_BillingProfileTriggerHandler.validateIban( iban );
                                            if ( resultIBANValidation )
                                            {
                                                System.debug( 'resultIBANValidation is: ' + resultIBANValidation );
                                                System.debug( 'DONE' );
                                            }
                                            else
                                            {
                                                billProf.NE__Iban__c.addError( Label.OB_InvalidIban );
                                                System.debug( 'resultIBANValidation is: ' + resultIBANValidation );
                                            }
                                        }
                                        System.debug( 'finalIbanMatcher is: ' + finalIbanMatcher );
                                    }
                                }
                            }
                        }

                    } catch ( DmlException exc )
                    {
                        System.debug( '[EXCE] OB_BillingProfileTriggerHandler.testHeaderInternational - The following exception has occurred: ' + exc.getMessage( ) );
                    }
                }
            }
            //}
        }
    }


    public void testHeaderInternational( List<NE__Billing_Profile__c> billProfs, List<NE__Billing_Profile__c> oldBillProfs )
    {

        //	START 	micol.ferrari 23/11/2018
        Boolean userSkipValidation = false;
        if ( !billProfs.isEmpty( ) )
        {
            userSkipValidation = billProfs.get( 0 ).OB_UserSkipValidation__c;
        }
        //	END 	micol.ferrari 23/11/2018

        if ( !userSkipValidation )
        {
            System.debug( '@@@@ I AM IN MY HEaEDR INTERNATIONAL METHOD!!!!!' );
            //if(currentUser.OB_CAB__c != 'SKIP'){
            Map<Id, NE__Billing_Profile__c> mapOfOldBill = new Map<Id, NE__Billing_Profile__c>( );
            if ( null != oldBillProfs && !oldBillProfs.isEmpty( ) )
            {
                for ( NE__Billing_Profile__c oldBillprof : oldBillProfs )
                {
                    mapOfOldBill.put( oldBillprof.Id, oldBillprof );
                    System.debug( 'mapOfOldBill is ' + mapOfOldBill );
                }
            }
            for ( NE__Billing_Profile__c billProf : billProfs )
            {
                String headerInternational = billProf.OB_HeaderInternational__c;
                if ( userSkipValidation == false && billProf.OB_BypassValidation__c == false )
                {
                    Boolean enableValidation = !mapOfOldBill.containsKey( billProf.Id ) || ( mapOfOldBill.containsKey( billProf.Id ) && mapOfOldBill.get( billProf.Id ).OB_BypassValidation__c == billProf.OB_BypassValidation__c );
                    Boolean enableUpdate = !mapOfOldBill.containsKey( billProf.Id ) || ( mapOfOldBill.containsKey( billProf.Id ) && mapOfOldBill.get( billProf.Id ).Name != billProf.Name );
                    if ( enableValidation && enableUpdate )
                    {
                        try
                        {
                            if ( !String.isBlank( headerInternational ) )
                            {
                                headerInternational = headerInternational.toLowerCase( );
                                String acceptedFinalSpecialChar = 'abcdefghijklmnopqrstuvxyz0123456789.()”?!&%$£=^°//\\ ';
                                if ( !headerInternational.containsOnly( acceptedFinalSpecialChar ) )
                                {
                                    billProf.OB_HeaderInternational__c.addError( Label.OB_PresenceOfAnInvalidCharacter );
                                }
                            }
                            // acceptedLetterChar acceptedNumber acceptedSpecialChars
                        } catch ( DmlException exc )
                        {
                            System.debug( '[EXCE] OB_BillingProfileTriggerHandler.testHeaderInternational - The following exception has occurred: ' + exc.getMessage( ) );
                        }
                    }
                }
            }
            //}
        }
    }

}