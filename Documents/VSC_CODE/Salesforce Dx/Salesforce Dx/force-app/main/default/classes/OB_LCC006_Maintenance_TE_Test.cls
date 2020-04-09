/*******************************************************************************
Purpose:  Class that is test for OB_LCC006_Maintenance_TE

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Joanna Mielczarek       19/06/2019      Created         NEXI-60
********************************************************************************/
@isTest
private with sharing class OB_LCC006_Maintenance_TE_Test
{

    /*******************************************************************************
    Purpose:  Method prepares Community User
    Parameters: -
    Returns: User

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       01/07/2019      Modified        NEXI-143 create community user as admin
    ********************************************************************************/
    private static User getUser( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;

        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACC_RT_MERCHANT ).getRecordTypeId( );
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile( ).Id;
            insert testCommunityUser;
        }
        return testCommunityUser;
    }

    /*******************************************************************************
    Purpose:  Method prepares Contact
    Parameters: -
    Returns: Contact

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/06/2019      Created         NEXI-60
    ********************************************************************************/
    private static Contact getContact( )
    {
        Contact cContact = new Contact( );
        cContact.FirstName = 'NOME';
        cContact.LastName = 'COGNOME';
        cContact.OB_Sex__c = 'F';
        cContact.OB_Fiscal_Code__c = 'CGNNMO92C45F205O';
        cContact.OB_Address_State__c = 'MILANO';
        cContact.OB_Address_City__c = 'MILANO';
        cContact.OB_Address_Street__c = 'VIA ADDA';
        cContact.OB_Address_Street_Number__c = '1';
        cContact.OB_Document_Release_State__c = 'test';
        cContact.OB_Document_Release_City__c = 'test';
        cContact.OB_Birth_Date__c = Date.newInstance( 1992, 3, 5 );
        cContact.OB_Birth_State__c = 'MILANO';
        cContact.OB_Birth_City__c = 'MILANO';
        cContact.OB_Document_Number__c = '1234567lkj';
        cContact.OB_Document_Type__c = OB_UtilityConstants.CARTA_DI_IDENTITA;
        cContact.OB_Document_Release_Authority__c = OB_UtilityConstants.COMUNE;
        cContact.OB_Document_Release_Date__c = Date.newInstance( 2018, 8, 6 );
        cContact.OB_Document_Expiration_Date__c = Date.newInstance( 2029, 3, 5 );

        return cContact;
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.initComponent - success scenario

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @IsTest
    private static void initComponentTest( )
    {
        OB_LCC006_Maintenance_TE.InitWrapper result = OB_LCC006_Maintenance_TE.initComponent( );
        System.assert( result != null );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - happy flow

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = new Contact( );
            Contact newContact = getContact( );

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );
			// ANDREA MORITTU START 04-Dec-2019 - EVO_PRODOB_522_FIX
            //System.assert( !result.isError );
            // ANDREA MORITTU END 04-Dec-2019 - EVO_PRODOB_522_FIX
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - happy Flow

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestNoDataChangeTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            // ANDREA MORITTU START 04-Dec-2019 - EVO_PRODOB_522_FIX
            System.assertNotEquals( result.errorMessage, null );
            // ANDREA MORITTU END 04-Dec-2019 - EVO_PRODOB_522_FIX
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid cadastral code - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    1.1            Joanna Mielczarek    01/07/2019    Modified     NEXI-143 moved creating Lov as community user
    ********************************************************************************/
    @isTest
    private static void saveRequestInvalidCadastralCodeTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            NE__Lov__c testLov = new NE__Lov__c( );
            testLov.Name = 'ITA';
            testLov.NE__Type__c = 'COUNTRY';
            testLov.NE__Value2__c = 'A123';
            insert testLov;

            Contact oldContact = new Contact( );
            Contact newContact = getContact( );
            newContact.OB_Country_Birth__c = 'ITA';

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            // ANDREA MORITTU START 04-Dec-2019 - EVO_PRODOB_522_FIX
            System.assertNotEquals( result.errorMessage, null );
            // ANDREA MORITTU END 04-Dec-2019 - EVO_PRODOB_522_FIX
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid document number - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestInvalidDocumentNumberTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = new Contact( );
            Contact newContact = getContact( );
            newContact.OB_Document_Number__c = '123';

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assertEquals( Label.OB_InvalidDocumentNumber, result.errorMessage );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid document release date - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestInvalidReleaseDateTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Document_Release_Date__c = Date.newInstance( 1992, 1, 1 );

            Test.startTest( );
            	OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assert( result.errorMessage.contains( Label.OB_Invalid_Release_Date ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid document expiration date - Carta Identita - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestCartaInvalidDocumentExpirationDate1Test( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Document_Expiration_Date__c = System.today( ).addDays( -1 );

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );
			
            System.assert( result.isError );
            // ANDREA MORITTU START 04-Dec-2019 - EVO_PRODOB_522_FIX
            System.assertNotEquals( result.errorMessage, null );
            // ANDREA MORITTU END 04-Dec-2019 - EVO_PRODOB_522_FIX
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid document expiration date - Carta Identita - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestCartaInvalidDocumentExpirationDate2Test( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Document_Release_Date__c = Date.newInstance( 2018, 8, 6 );
            newContact.OB_Document_Expiration_Date__c = Date.newInstance( 2029, 4, 5 );

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            // ANDREA MORITTU START 04-Dec-2019 - EVO_PRODOB_522_FIX
            System.assertNotEquals( result.errorMessage, null );
            // ANDREA MORITTU END  04-Dec-2019 - EVO_PRODOB_522_FIX
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid document expiration date - Carta Identita - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestCartaInvalidDocumentExpirationDate3Test( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Document_Release_Date__c = Date.newInstance( 2018, 8, 6 );
            newContact.OB_Document_Expiration_Date__c = Date.newInstance( 2009, 2, 5 );

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            // ANDREA MORITTU START 04-Dec-2019 - EVO_PRODOB_522_FIX
            System.assertNotEquals( result.errorMessage, null );
            // ANDREA MORITTU END 04-Dec-2019 - EVO_PRODOB_522_FIX
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid document release authority - Carta Identita - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestCartaInvalidDocumentReleaseAuthorityTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Document_Release_Authority__c = OB_UtilityConstants.QUESTURA;

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            // ANDREA MORITTU START 04-Dec-2019 - EVO_PRODOB_522_FIX
            System.assertNotEquals( result.errorMessage, null );
            // ANDREA MORITTU END 04-Dec-2019 - EVO_PRODOB_522_FIX
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid document release authority - Passaporto - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestPassaportoInvalidDocumentReleaseAuthorityTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Document_Type__c = OB_UtilityConstants.PASSAPORTO;
            newContact.OB_Document_Release_Authority__c = OB_UtilityConstants.COMUNE;

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assert( result.errorMessage.containsIgnoreCase( Label.OB_InvalidDocumentReleaseAuthority ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid document release authority - Patente - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestPatenteInvalidDocumentReleaseAuthorityTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Document_Type__c = OB_UtilityConstants.PATENTE;
            newContact.OB_Document_Release_Authority__c = OB_UtilityConstants.COMUNE;

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assert( result.errorMessage.containsIgnoreCase( Label.OB_InvalidDocumentReleaseAuthority ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid birth date - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestInvalidBirthDateTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Birth_Date__c = Date.newInstance( 1899, 12, 30 );

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assert( result.errorMessage.containsIgnoreCase( Label.OB_InvalidBirthDate ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid fiscal code length - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestInvalidFiscalCodeLengthTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Fiscal_Code__c = 'CGNNMO92C45F205';

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assert( result.errorMessage.containsIgnoreCase( Label.OB_InvalidFiscalCode ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid fiscal code - name - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestInvalidFiscalCodeNameTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Fiscal_Code__c = 'CGNNNO92C45F205O';

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assert( result.errorMessage.containsIgnoreCase( Label.OB_InconsistentFiscalCode ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid fiscal code - birth date - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestInvalidFiscalCodeBirthDateTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Fiscal_Code__c = 'CGNNMO91C45F205O';

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assert( result.errorMessage.containsIgnoreCase( Label.OB_InvalidFiscalCodeBirthDate ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid fiscal code - surname - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestInvalidFiscalCodeSurnameTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Fiscal_Code__c = 'CNNNMO92C45F205O';

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assert( result.errorMessage.containsIgnoreCase( Label.OB_InvalidFiscalCodeSurname ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid fiscal code - gender - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestInvalidFiscalCodeGenderTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Fiscal_Code__c = 'CGNNMO92C00F205O';

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assert( result.errorMessage.containsIgnoreCase( Label.OB_InvalidFiscalCodeGender ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - invalid fiscal code - last char - failed

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestInvalidFiscalCodeLastCharTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.OB_Fiscal_Code__c = 'CGNNMO92C45F205M';

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assert( result.errorMessage.containsIgnoreCase( Label.OB_InvalidFiscalCode ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - mandatory fields not filled

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestMandatoryFieldsTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Contact oldContact = getContact( );
            Contact newContact = getContact( );
            newContact.FirstName = '';

            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( oldContact, newContact );
            Test.stopTest( );

            System.assert( result.isError );
            System.assertEquals( ' Required Fields Check failed', result.hiddenErrorMessage );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LCC006_Maintenance_TE.saveRequest - null params scenario

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    22/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void saveRequestNullTest( )
    {
        User testCommunityUser = getUser( );

        System.runAs( testCommunityUser )
        {
            Test.startTest( );
            OB_LCC006_Maintenance_TE.SaveOutputWrapper result = OB_LCC006_Maintenance_TE.saveRequest( null, null );
            Test.stopTest( );

            System.assert( result.isError );
            System.assertEquals( Label.OB_ServerLogicFailed, result.errorMessage );
        }
    }
}