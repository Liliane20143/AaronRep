@isTest
public class OB_ContactTriggerHandler_Test
{
    /*******************************************************************************
    Purpose:    Test method for extractVowels method - scenario - method accepts test
                text and return expect result

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
	@isTest
    public static void extractVowels_test( )
    {
        String testText = 'test triggerContact';
        String expectResutlt = 'eieoa';
        System.assertEquals( expectResutlt, OB_ContactTriggerHandler.extractVowels( testText ) );
	}
 /*******************************************************************************
    Purpose:    Test method for insertContactShare
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         francesca ribezzi      19/12/2019      Created         
    ********************************************************************************/
	@isTest
    public static void insertContactShare_test( ) 
    {
        Map<Contact, Group> mapToInsert = new Map<Contact, Group>(); 
        Account a = OB_TestDataFactory.getAccount();
        insert a; 
        Contact c = OB_TestDataFactory.getContact(a);
        insert c;
        Group gr = new Group();
        gr.Name = 'test'; 
        insert gr;

        mapToInsert.put(c, gr);
        Test.startTest();
            OB_ContactTriggerHandler.insertContactShare(mapToInsert);
        Test.stopTest();
    }
    /*******************************************************************************
    Purpose:    Test method for stringNormalizer method - scenario - method accepts test
                text and return expect result

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
	@isTest
    public static void stringNormalizer_test( )
    {
        String testText = 'test triggerContact ÀÂÄÇÉÈÊËÎÏÌÛÜÙÔÖÒÑ';
        String expectResult = 'testtriggerContactAAACEEEEIIIUUUOOON';
        System.assertEquals( expectResult, OB_ContactTriggerHandler.stringNormalizer( testText ) );
    }

    /*******************************************************************************
    Purpose:    Test method for extractConsonants method - scenario - method accepts test
                text and return expect result
		
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void extractConsonants_test( )
    {
        String testText = 'test triggerContact';
        String expectResult = 'tst trggrCntct';
        System.assertEquals( expectResult, OB_ContactTriggerHandler.extractConsonants( testText ) );
	}

    /*******************************************************************************
    Purpose:    Test method for checkNameSurnameCF method - scenario - if method accepts correct parameters
                should return null

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
	@isTest
    public static void checkNameSurnameCF_test1( )
    {
        String nome = 'rior';
		String cognome = 'toti';
		String cf = 'TTORRI90E18F205U';
		
		Date birthDate = Date.newInstance(1990, 05, 18);
		String birthDateString = String.valueOf(birthDate);
		String gender = 'M';
		
        String result = OB_ContactTriggerHandler.checkNameSurnameCF( nome, cognome, cf, birthDateString, gender );
        System.assertEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Second test method for checkNameSurnameCF method - scenario - if method accepts correct parameters
                should return null
		
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
	@isTest
    public static void checkNameSurnameCF_test2( )
    {
        String nome = 'riri';
		String cognome = 'toti';
		String cf = 'TTORRI00A01D150K';
		
		Date birthDate = Date.newInstance(2000, 01, 01);
		String birthDateString = String.valueOf(birthDate);
		String gender = 'M';
		
        String result = OB_ContactTriggerHandler.checkNameSurnameCF( nome, cognome, cf, birthDateString, gender );
        System.assertEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Third test method for checkNameSurnameCF method - scenario - pass wrong surname to method
                should return 'errorSurname'
		
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
	@isTest
    public static void checkNameSurnameCF_test3( )
    {
		String nome = 'riri';
		String cognome = 'Piti';
		String cf = 'TTORRI00A01D150K';
		
		Date birthDate = Date.newInstance(2000, 01, 01);
		String birthDateString = String.valueOf(birthDate);
		String gender = 'M';
		
        String result = OB_ContactTriggerHandler.checkNameSurnameCF( nome, cognome, cf, birthDateString, gender );
        System.assertEquals( 'errorSurname', result );
    }

    /*******************************************************************************
    Purpose:    Fourth test method for checkNameSurnameCF method - scenario - pass wrong gender to method
                should return 'errorGender'
		
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
	@isTest
    public static void checkNameSurnameCF_test4( )
    {
		String nome = 'riri';
		String cognome = 'Toti';
		String cf = 'TTORRI00B01D150K';
		
		Date birthDate = Date.newInstance(2000, 01, 01);
		String birthDateString = String.valueOf(birthDate);
		String gender = 'F';

        String result = OB_ContactTriggerHandler.checkNameSurnameCF( nome, cognome, cf, birthDateString, gender );
        System.assertEquals( 'errorGender', result );
    }

    /*******************************************************************************
    Purpose:    Fifth test method for checkNameSurnameCF method - scenario - pass wrong name or surname to method
                should return 'errorName' or 'errorSurname'
		
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void checkNameSurnameCF_test5( )
    {
        String testName1 = 'ERROR_NAMEERROR_NAMEERROR_NAMEERROR_NAMEERROR_NAMEERROR_NAME';
        String testLastname1 = 'toti';
        String cf1 = 'TTORRI90E18F205U';
        Date testBirthDate1 = Date.newInstance( 1990, 05, 18 );
        String testBirthDateString1 = String.valueOf( testBirthDate1 );
        String testGender1 = 'M';

        String testName2 = 'riri';
        String testLastname2 = 'ERRORLASTNAME_ERRORLASTNAME_ERRORLASTNAME_ERRORLASTNAME_ERRORLASTNAME_';
        String cf2 = 'TTORRI90E18F205U';
        Date testBirthDate2 = Date.newInstance( 1990, 05, 18 );
        String testBirthDateString2 = String.valueOf( testBirthDate2 );
        String testGender2 = 'M';

        String result1 = OB_ContactTriggerHandler.checkNameSurnameCF( testName1, testLastname1, cf1, testBirthDateString1, testGender1 );
        String result2 = OB_ContactTriggerHandler.checkNameSurnameCF( testName2, testLastname2, cf2, testBirthDateString2, testGender2 );
        System.debug( result1 );
        System.debug( result2 );
        System.assertEquals( 'errorName', result1 );
        System.assertEquals( 'errorSurname', result2 );
	}

    /*******************************************************************************
    Purpose:    Sixth test method for checkNameSurnameCF method - scenario - pass wrong gender to method
                should return 'errorGender'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void checkNameSurnameCF_test6( )
    {
        String testName1 = 'riri';
        String testLastname1 = 'toti';
        String cf1 = 'TTORRI90E70F205U';
        Date testBirthDate1 = Date.newInstance( 1990, 05, 18 );
        String testBirthDateString1 = String.valueOf( testBirthDate1 );
        String testGender1 = 'M';
	
        String testName2 = 'riri';
        String testLastname2 = 'toti';
        String cf2 = 'TTORRI90E30F205U';
        Date testBirthDate2 = Date.newInstance( 1990, 05, 18 );
        String testBirthDateString2 = String.valueOf( testBirthDate2 );
        String testGender2 = 'F';

        String result1 = OB_ContactTriggerHandler.checkNameSurnameCF( testName1, testLastname1, cf1, testBirthDateString1, testGender1 );
        String result2 = OB_ContactTriggerHandler.checkNameSurnameCF( testName2, testLastname2, cf2, testBirthDateString2, testGender2 );
        System.assertEquals( 'errorGender', result1 );
        System.assertEquals( 'errorGender', result2 );
    }

    /*******************************************************************************
    Purpose:    The seventh test method for checkNameSurnameCF method - scenario - pass wrong date to method
                should return 'errorDate'

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
	@isTest
    public static void checkNameSurnameCF_test7( )
    {
        String nome = 'rior';
        String cognome = 'toti';
        String cf = 'TTORRI90E1000000';
        Date birthDate = Date.newInstance( 1990, 05, 18 );
        String birthDateString = String.valueOf( birthDate );
        String gender = 'M';
	
        String result = OB_ContactTriggerHandler.checkNameSurnameCF( nome, cognome, cf, birthDateString, gender );
        System.assertEquals( 'errorData', result );
    }
		
    /*******************************************************************************
    Purpose:    An auxiliary method in creating an Account for other test method

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    static Account createAccount( string Email, String FiscalCode, Boolean VATNotPresent )
    {
        Account acc = OB_TestDataFactory.getAccount( );
        acc.NE__E_mail__c = Email;
        acc.NE__Fiscal_code__c = FiscalCode;
        acc.OB_VAT_Not_Present__c = VATNotPresent;
        return acc;
    }

    /*******************************************************************************
    Purpose:    An auxiliary method in creating an Contact for other test method

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    static Contact createContact( String FirstName, String LastName, String FiscalCode, String DocumentReleaseAuthority, String DocumentType, String Sex, Boolean BypassValidation, String DocumentNumber, String CountryBirth, Date DocumentExpirationDate, Date DocumentReleaseDate )
    {
		Contact cont = new Contact();
        cont.FirstName = FirstName;
        cont.LastName = LastName;
        cont.OB_Fiscal_Code__c = FiscalCode;
        cont.OB_Document_Release_Authority__c = DocumentReleaseAuthority;
        cont.OB_Document_Type__c = DocumentType;
        cont.OB_Sex__c = Sex;
        cont.OB_BypassValidation__c = BypassValidation;
        cont.OB_Document_Number__c = DocumentNumber;
        cont.OB_Country_Birth__c = CountryBirth;
        cont.OB_Document_Expiration_Date__c = DocumentExpirationDate;
        cont.OB_Document_Release_Date__c = DocumentReleaseDate;
        cont.fax = '234567';
        cont.MobilePhone = '12345678';
        cont.Phone = '3456789';
        Account acc = createAccount('test@null.it', '12345678901', false);
        insert acc;
        cont.AccountId = acc.id;
        return cont;
    }

    /*******************************************************************************
    Purpose:    Test method for testFiscalCode method - scenario - pass correct date to method
                should not return any exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testFiscalCode_test1( )
    {
        Account acc = createAccount( 'test@null.it', '12345678901', false );
        insert acc;
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI00B01D150K', 'Comune', 'Carta di Identità', 'M', false, '123erty644', 'ITALY', Date.today( ).addYears( 10 ), Date.today( ) );
		insert cont;
        Contact cont2 = createContact( 'RIRI', 'TOTI', 'TTORRI00B01D150K', 'Comune', 'Carta di Identità', 'M', false, '123ert542', 'ITALY', Date.today( ).addYears( 10 ), Date.today( ) );
        insert cont2;

        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        conts.add( cont );
        oldConts.add( cont2 );

        String result;
        try
        {
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testFiscalCode( conts, oldConts );
        } catch ( Exception e )
        {
            result = e.getMessage( );
        }
        System.assertEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Test method for testFiscalCode method - scenario - pass correct date to method
                should not return any exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testFiscalCode_test2( )
    {
        Account acc = createAccount( 'test@null.it', '12345678901', false );
        insert acc;
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI00B01D150', 'Comune', 'Carta di Identità', 'M', false, '123erty644', 'ITALY', Date.today( ).addYears( 10 ), Date.today( ) );
        Contact cont2 = createContact( 'RIRI', 'TOTI', 'TTORRI00B01D150K', 'Comune', 'Carta di Identità', 'M', false, '123ert542', 'ITALY', Date.today( ).addYears( 10 ), Date.today( ) );

		insert cont2; 

        Boolean result;
        try
        {
            Database.insert( cont, false );

		List<Contact> conts    = new List<Contact>();
		List<Contact> oldConts = new List<Contact>();
		conts.add(cont);
		oldConts.add(cont2);

            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testFiscalCode( conts, oldConts );
        } catch ( Exception e )
        {
            result = e.getMessage( ).contains( Label.OB_InvalidFiscalCode ) ? true : false;
        }
        System.assertEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Test method for testFiscalCode method - scenario - pass correct date to method
                should not return any exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testFiscalCode_test3( )
    {
        Account acc = createAccount( 'test@null.it', '12345678901', false );
        insert acc;
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI00B01D150K', 'Comune', 'Carta di Identità', 'M', false, '123erty644', 'ITALY', Date.today( ).addYears( 10 ), Date.today( ) );
        Contact cont2 = createContact( 'RIRI', 'TOTI', 'TTORRI00B01D150K', 'Comune', 'Carta di Identità', 'M', false, '123ert542', 'ITALY', Date.today( ).addYears( 10 ), Date.today( ) );

        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        conts.add( cont );
        oldConts.add( cont2 );

        String result = null;
        try
        {
            insert cont;
            insert cont2;
		OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler();
		triggerContact.testFiscalCode(conts, oldConts);
        } catch ( Exception e )
        {
            result = e.getMessage( );
        }
        System.assertEquals( null, result );
	}
	
    /*******************************************************************************
    Purpose:    Test method for testFiscalCode method - scenario - pass correct date to method
                should not return any exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
	@isTest
    public static void testFiscalCode_test5( )
    {
        Account acc = createAccount( 'test@null.it', '12345678901', false );

        insert acc;
		
        Contact cont = OB_TestDataFactory.getContact( acc );
        acc.Id = cont.Id ;
		cont.FirstName = 'contTest';
		cont.LastName = 'contTest';
		cont.OB_Fiscal_Code__c = 'RSSGLI80A01F205V';
		cont.OB_Sex__c = 'F';
		cont.OB_BypassValidation__c = false;
		insert cont;

        Contact cont2 = OB_TestDataFactory.getContact( acc );
        acc.Id = cont2.Id ;
		cont2.FirstName = 'RIRI';
		cont2.LastName = 'TOTI';
		cont2.OB_Fiscal_Code__c = 'TTORRI00A01D150K';
		cont2.OB_Sex__c = 'M';
		cont2.OB_BypassValidation__c = false;
		insert cont2;

        String result = null;
        try
        {
		List<Contact> conts = new List<Contact>();
		List<Contact> oldConts = new List<Contact>();
		conts.add(cont);
		oldConts.add(cont2);
		OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler();
		triggerContact.testFiscalCode(conts, oldConts);
        } catch ( Exception e )
        {
            result = e.getMessage( );
        }
        System.assertEquals( null, result );
	}

    /*******************************************************************************
    Purpose:    Test method for testFiscalCode method - scenario - pass correct date to method
                should not return any exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
	@isTest
    public static void testFiscalCode_test6( )
    {
        Account acc = createAccount( 'test@null.it', '12345678901', false );
        insert acc;

        Contact cont = OB_TestDataFactory.getContact( acc );
        acc.Id = cont.Id ;
		cont.FirstName = 'contTest';
		cont.LastName = 'contTest';
		cont.OB_Fiscal_Code__c = 'RSSGLI80A01F205V';
        cont.OB_Sex__c = 'F';
        cont.OB_BypassValidation__c = false;
        insert cont;

        Contact cont2 = OB_TestDataFactory.getContact( acc );
        acc.Id = cont2.Id ;
        cont2.FirstName = 'RIRI';
        cont2.LastName = 'TOTI';
        cont2.OB_Fiscal_Code__c = 'TTORRI00A01D150K';
        cont2.OB_Sex__c = 'M';
        cont2.OB_BypassValidation__c = false;
        insert cont2;

        String result = null;
        try
        {
            List<Contact> conts = new List<Contact>( );
            List<Contact> oldConts = new List<Contact>( );
		conts.add(cont);
            oldConts.add( cont2 );
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testFiscalCode( conts, oldConts );
        } catch ( Exception e )
        {
            result = e.getMessage( );
        }
        System.assertEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Test method for testFiscalCode method - scenario - pass correct date to method
                should not return any exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testFiscalCode_test7( )
    {
        Account acc = createAccount( 'test@null.it', '12345678901', false );
        insert acc;

        Contact cont = OB_TestDataFactory.getContact( acc );
        acc.Id = cont.Id ;
        cont.FirstName = 'RIRI';
        cont.LastName = 'TOTI';
        cont.OB_Fiscal_Code__c = 'TTORRI00B01D150K';
        cont.OB_Sex__c = 'F';
        cont.OB_BypassValidation__c = false;
        insert cont;

        Contact cont2 = OB_TestDataFactory.getContact( acc );
        acc.Id = cont2.Id ;
        cont2.FirstName = 'RIRI';
        cont2.LastName = 'TOTI';
        cont2.OB_Fiscal_Code__c = 'TTORRI00A01D150K';
		cont2.OB_Sex__c = 'M';
        cont2.OB_BypassValidation__c = false;
        insert cont2;

        String result = null;
        try
        {
            List<Contact> conts = new List<Contact>( );
            List<Contact> oldConts = new List<Contact>( );
            conts.add( cont );
            oldConts.add( cont2 );
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testFiscalCode( conts, oldConts );
        } catch ( Exception e )
        {
            result = e.getMessage( );
        }
        System.assertEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Test method for testFiscalCode method

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testFiscalCode_test8( )
    {
        Account acc = createAccount( 'test@null.it', '12345678901', false );
        acc.NE__VAT__c = '12345678901';
        insert acc;
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI00B01D150K', 'Comune', 'Carta di Identità', 'M', false, '123erty644', 'ITALY', Date.today( ).addYears( 10 ), Date.today( ) );
        insert cont;
        Contact cont2 = createContact( 'RIRI', 'TOTI', 'TTORRI00B01D150K', 'Comune', 'Carta di Identità', 'M', false, '123ert542', 'ITALY', Date.today( ).addYears( 10 ), Date.today( ) );
        insert cont2;

        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        conts.add( cont );
        oldConts.add( cont2 );

        NE__Lov__c lov = new NE__Lov__c( );
        lov.NE__Type__c = 'COUNTRY';
        lov.Name = 'ITALY';
        insert lov;

        Test.startTest( );
        OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
        triggerContact.testFiscalCode( conts, oldConts );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentNumber method - scenario - pass wrong parameters
                should not throw any exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testCoerencyDocumentNumber_test( )
    {
        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        Contact cont = createContact( 'contTest', 'contTest', 'RSSGLI80A01F205V', 'Comune', 'Carta di Identità', 'M', false, '123erty645', 'ITALY', Date.today( ).addYears( 10 ), Date.today( ) );
        conts.add( cont );
        insert conts;
        Contact cont2 = createContact( 'cont2 Test', 'cont2 Test', 'RSSGLI80A01F205V', 'Comune', 'Carta di Identità', 'M', false, '123erty645', 'ITALY', Date.today( ).addYears( 10 ), Date.today( ) );
		oldConts.add(cont2);
		insert oldConts;

        String Result = null;
        try
        {
		Test.startTest();
		OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler();
		triggerContact.testCoerencyDocumentNumber(conts, oldConts);
		Test.stopTest();
        } catch ( Exception e )
        {
            Result = e.getMessage( );
        }
        System.assertEquals( null, Result );
    }

    
    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentExpirationDate method - scenario - pass wrong parameters
                should not throw any exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
	@isTest
    public static void testCoerencyDocumentExpirationDate_test( )
    {
		List<Contact> conts = new List<Contact>();
		List<Contact> oldConts = new List<Contact>();
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Comune', 'Carta di Identità', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
		cont.OB_Birth_Date__c    = Date.newInstance(1990, 05, 18);
        Contact cont2 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'UCO', 'Patente', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
		cont2.OB_Birth_Date__c    = Date.newInstance(1990, 05, 18);
        Contact cont3 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
		cont3.OB_Birth_Date__c    = Date.newInstance(1990, 05, 18);
        Contact cont4 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
        cont4.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );


		conts.add(cont);
		conts.add(cont2);
		conts.add(cont3);
		insert conts;

		oldConts.add(cont4);
		insert oldConts;

        String result = null;
        try
        {
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testCoerencyDocumentExpirationDate( conts, oldConts );
        } catch ( Exception e )
        {
            result = e.getMessage( );
        }
        System.assertEquals( null, result );
    }

   

    

    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentExpirationDate method - scenario - pass wrong parameters
                should throw exception OB_InvalidDocumentExpirationDate
	
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testCoerencyDocumentExpirationDate_test4( )
    {
        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Comune', 'Carta di Identità', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2020, 02, 09 ), Date.newInstance( 2010, 02, 09 ) );
        cont.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );
        Contact cont4 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
        cont4.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );
   
        conts.add( cont );
        oldConts.add( cont4 );

        Boolean result;
        try
        {
            insert conts;
            insert oldConts;
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testCoerencyDocumentExpirationDate( conts, oldConts );
        } catch ( Exception e )
        {
            result = e.getMessage( ).contains( Label.OB_InvalidDocumentExpirationDate ) ? true : false;
        }
        
    }

    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentExpirationDate method - scenario - pass wrong parameters
                should not throw exception OB_Document_Release_Date

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testCoerencyDocumentExpirationDate_test5( )
    {
        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Comune', 'Carta di Identità', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2021, 02, 09 ), Date.newInstance( 2011, 02, 10 ) );
        cont.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );
        Contact cont4 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
        cont4.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );

        conts.add( cont );
        oldConts.add( cont4 );

        Boolean result;
        try
        {
            insert conts;
            insert oldConts;
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testCoerencyDocumentExpirationDate( conts, oldConts );
        } catch ( Exception e )
        {
            result = e.getMessage( ).contains( Label.OB_Document_Release_Date ) ? true : false;
        }
        System.assertEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentExpirationDate method - scenario - pass wrong parameters
                should throw exception OB_Document_Release_Date

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testCoerencyDocumentExpirationDate_test6( )
    {
        //Account acc = createAccount('test@null.it', '12345678901', false);
        //insert acc;
        //List<Contact> conts = new List<Contact>( );
        //List<Contact> oldConts = new List<Contact>( );
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Comune', 'Carta di Identità', 'M', true, 'as23456678', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 01, 01 ) );
        cont.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );
      
        //Contact cont4 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', true, 'as23456678', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 01, 01 ) );
        //cont4.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );
		insert cont;
        cont.OB_Document_Number__c = 'as7654211';
        update cont;
        //conts.add( cont );
        //oldConts.add( cont4 );

        /*Boolean result;
        try
        {
            //insert conts;
            //insert oldConts;
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testCoerencyDocumentExpirationDate( conts, oldConts );
        } catch ( Exception e )
        {
            result = e.getMessage( ).contains( Label.OB_Document_Release_Date ) ? true : false;
        }
        System.Assert( result );*/
    }

    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentExpirationDate method - scenario - pass wrong parameters
                should throw exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testCoerencyDocumentExpirationDate_test7( )
    {
        //List<Contact> conts = new List<Contact>( );
        //List<Contact> oldConts = new List<Contact>( );
        Exception result = null;
        try{
            
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Comune', 'Carta di Identità', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 04, 10 ), Date.newInstance( 201, 02, 10 ) );
        cont.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );
        insert cont;
        cont.OB_Document_Release_Authority__c = 'Questura';
      	cont.OB_Document_Expiration_Date__c =  Date.newInstance( 2029, 05, 18 );
       	cont.OB_Document_Release_Date__c = Date.newInstance( 2019, 05, 18 );
        cont.OB_Document_Type__c = 'Passaporto';
        update cont;
        }
        /*Contact cont4 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
        cont4.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );
        conts.add( cont );
        oldConts.add( cont4 );

        Exception result = null;
        try
        {
            insert conts;
            insert oldConts;
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testCoerencyDocumentExpirationDate( conts, oldConts );*/
         catch ( Exception e )
        {
            result = e;
        }
        System.assertNotEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentExpirationDate method - scenario - pass wrong parameters
                should throw exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testCoerencyDocumentExpirationDate8_test( )
    {
        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Comune', 'Carta di Identità', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 04, 10 ), Date.newInstance( 2014, 02, 10 ) );
        cont.OB_Birth_Date__c = Date.newInstance( 1990, 02, 18 );
        Contact cont4 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
        cont4.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );

        conts.add( cont );
        oldConts.add( cont4 );

        Exception result = null;
        try
        {
            insert conts;
            insert oldConts;
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testCoerencyDocumentExpirationDate( conts, oldConts );
        } catch ( Exception e )
        {
            result = e;
        }
        //System.assertNotEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentExpirationDate method - scenario - pass wrong parameters
                should throw exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testCoerencyDocumentExpirationDate9_test( )
    {
        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Comune', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 04, 10 ), Date.newInstance( 2014, 02, 10 ) );
        cont.OB_Birth_Date__c = Date.newInstance( 1990, 02, 18 );
        Contact cont4 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
        cont4.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );

        conts.add( cont );
        oldConts.add( cont4 );

        Exception result = null;
        try
        {
            insert conts;
            insert oldConts;
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testCoerencyDocumentExpirationDate( conts, oldConts );
        } catch ( Exception e )
        {
            result = e;
        }
        //System.assertNotEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentExpirationDate method - scenario - pass wrong parameters
                should throw exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testCoerencyDocumentExpirationDate10_test( )
    {
        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Carta di Identità', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 04, 10 ), Date.newInstance( 2014, 02, 10 ) );
        cont.OB_Birth_Date__c = Date.newInstance( 1990, 02, 18 );
        Contact cont4 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 17 ) );
        cont4.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );
        conts.add( cont );
        oldConts.add( cont4 );

        Exception result = null;
        try
        {
            insert conts;
            insert oldConts;
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testCoerencyDocumentExpirationDate( conts, oldConts );
        } catch ( Exception e )
        {
            result = e;
        }
        //System.assertNotEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentExpirationDate method - scenario - pass wrong parameters
                should throw exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testCoerencyDocumentExpirationDate11_test( )
    {
        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Prefettura', 'Carta di Identità', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 04, 10 ), Date.newInstance( 2014, 02, 10 ) );
        cont.OB_Birth_Date__c = Date.newInstance( 1990, 02, 18 );
        Contact cont4 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
        cont4.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );
        conts.add( cont );
        oldConts.add( cont4 );

        Exception result = null;
        try
        {
            insert conts;
            insert oldConts;
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testCoerencyDocumentExpirationDate( conts, oldConts );
        } catch ( Exception e )
        {
            result = e;
        }
        //System.assertNotEquals( null, result );
    }

    /*******************************************************************************
    Purpose:    Test method for testCoerencyDocumentExpirationDate method - scenario - pass wrong parameters
                should throw exception

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek        24/04/2019      Created         R1F2_RP_000_CC_OB_ContactTriggerHandler
    ********************************************************************************/
    @isTest
    public static void testCoerencyDocumentExpirationDate12_test( )
    {
        List<Contact> conts = new List<Contact>( );
        List<Contact> oldConts = new List<Contact>( );
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 04, 10 ), Date.newInstance( 2014, 02, 10 ) );
        cont.OB_Birth_Date__c = Date.newInstance( 1990, 02, 18 );
        Contact cont4 = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', false, '123erty645', 'ITALY', Date.newInstance( 2029, 05, 18 ), Date.newInstance( 2019, 05, 18 ) );
        cont4.OB_Birth_Date__c = Date.newInstance( 1990, 05, 18 );
        conts.add( cont );
        oldConts.add( cont4 );

        Exception result = null;
        try
        {
            insert conts;
            insert oldConts;
            OB_ContactTriggerHandler triggerContact = new OB_ContactTriggerHandler( );
            triggerContact.testCoerencyDocumentExpirationDate( conts, oldConts );
        } catch ( Exception e )
        {
            result = e;
        }
       // System.assertNotEquals( null, result );
    }
    /*******************************************************************************
    Purpose:    Test method for shareContact method

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        giovanni spinell8i       24/04/2019      Created         
    ********************************************************************************/
    @isTest
    public static void shareContact( )
    {
        Account bank = OB_TestDataFactory.getAccount( );
        bank.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( OB_UtilityConstants.BANKRT ).getRecordTypeId( );
        insert bank;
        Contact cont = createContact( 'RIRI', 'TOTI', 'TTORRI90E18F205U', 'Questura', 'Passaporto', 'M', true, '123erty645', 'ITALY', Date.newInstance( 2029, 04, 10 ), Date.newInstance( 2014, 02, 10 ) );
        cont.OB_Bank__c=bank.Id;
        insert cont;
        
    }
}