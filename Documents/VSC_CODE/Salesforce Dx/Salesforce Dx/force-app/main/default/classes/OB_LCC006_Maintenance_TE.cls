/*******************************************************************************
Purpose:  Class that is controller for OB_LCP006_Maintenance_Titolari_Effettivi
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Adrian Dlugolecki       14/06/2019      Created         NEXI-60
********************************************************************************/
public with sharing class OB_LCC006_Maintenance_TE
{
    public static final List<String> MANDATORY_FIELDS_FOR_TE = new List<String>
    {
            'FirstName',
            'LastName',
            'OB_Sex__c',
            'OB_Fiscal_Code__c',
            'OB_Address_State__c',
            'OB_Address_City__c',
            'OB_Address_Street__c',
            'OB_Address_Street_Number__c',
            'OB_Document_Release_State__c',
            'OB_Document_Release_City__c',
            'OB_Birth_State__c',
            'OB_Birth_City__c',
            'OB_Document_Type__c',
            'OB_Birth_Date__c',
            'OB_Document_Number__c',
            'OB_Document_Release_Authority__c',
            'OB_Document_Release_Date__c',
            'OB_Document_Expiration_Date__c'
    };

    /*******************************************************************************
    Purpose:  Class that is output wrapper for init of component
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       14/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       21/06/2019      Modified        NEXI-60 removed companyLinkTypes
    ********************************************************************************/
    public class InitWrapper
    {
        @AuraEnabled
        public Map<String, String> genders;
        @AuraEnabled
        public Map<String, String> contactFieldsLabel;
    }

    /*******************************************************************************
    Purpose:  Init method for OB_LCP006_Maintenance_Titolari_Effettivi
    Parameters: -
    Returns: InitWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       14/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       21/06/2019      Modified        NEXI-60 removed companyLinkTypes
    ********************************************************************************/
    @AuraEnabled
    public static InitWrapper initComponent( )
    {
        InitWrapper result = new InitWrapper( );
        result.genders = getGenders( );
        result.contactFieldsLabel = retrieveContactSchemaInformation( );
        return result;
    }

    /*******************************************************************************
    Purpose:  Method retrieve picklist values with labels from org
    Parameters: Schema.DescribeFieldResult inFieldDescription
    Returns: Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       14/06/2019      Created         NEXI-60
    ********************************************************************************/
    private static Map<String, String> getPicklistValues( Schema.DescribeFieldResult inFieldDescription )
    {
        System.debug( LoggingLevel.INFO, 'OB_LCC006_Maintenance_TE.getPicklistValues started ' + inFieldDescription );
        Map<String, String> pickListValuesList = new Map<String, String>( );
        List<Schema.PicklistEntry> pPicklistEntry = inFieldDescription.getPicklistValues( );
        for ( Schema.PicklistEntry pickListVal : pPicklistEntry )
        {
            pickListValuesList.put( pickListVal.getValue( ), pickListVal.getLabel( ) );
        }
        System.debug( LoggingLevel.INFO, 'OB_LCC006_Maintenance_TE.getPicklistValues end ' + pickListValuesList );
        return pickListValuesList;
    }

    /*******************************************************************************
    Purpose:  Method retrieve picklist values with labels from org for OB_Sex__c
    Parameters: -
    Returns: Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       14/06/2019      Created         NEXI-60
    ********************************************************************************/
    private static Map<String, String> getGenders( )
    {
        return getPicklistValues( Contact.OB_Sex__c.getDescribe( ) );
    }

    /*******************************************************************************
    Purpose:  Method retrieve labels for all fields of contact
    Parameters: -
    Returns: Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       14/06/2019      Created         NEXI-60
    ********************************************************************************/
    private static Map<String, String> retrieveContactSchemaInformation( )
    {
        Map<String, String> apiToLabels = new Map<String, String>( );
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe( ).get( 'Contact' ).getDescribe( ).fields.getMap( );
        for ( String fieldName : fieldMap.keySet( ) )
        {
            apiToLabels.put( fieldName, fieldMap.get( fieldName ).getDescribe( ).getLabel( ) );
        }
        return apiToLabels;
    }

    /*******************************************************************************
    Purpose:  Method check if mandatory fields are not blank
    Parameters: Contact inContact
    Returns: List<String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       14/06/2019      Created         NEXI-60
    ********************************************************************************/
    private static List<String> mandatoryFieldsCheck( Contact inContact )
    {
        List<String> errorFieldsApis = new List< String>( );
        for ( String fieldApi : MANDATORY_FIELDS_FOR_TE )
        {
            if ( inContact.get( fieldApi ) == null || inContact.get( fieldApi ) == '' )
            {
                errorFieldsApis.add( fieldApi );
            }
        }
        return errorFieldsApis;
    }

    /*******************************************************************************
    Purpose:  Method validate contact. Method taken from original component executore
    Parameters: Contact inContact
    Returns: String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       14/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       22/06/2019      Modified        NEXI-60 removed repeated condition
    ********************************************************************************/
    private static String checkValidationCont( Contact inContact )
    {
        List< String> mandatoryValidationCheck = new List< String>( );
        Pattern docNumPattern = Pattern.compile( '^[a-zA-Z0-9]+$' );
        Matcher docNum = docNumPattern.matcher( inContact.OB_Document_Number__c );
        Date checkBirthDate = Date.newInstance( 1900, 1, 1 );
        if ( inContact.OB_Country_Birth__c != 'ITALIA' )
        {
            List<NE__Lov__c> lovCadastralCode = [ SELECT Id, NE__Value2__c FROM NE__Lov__c WHERE NE__Type__c = 'COUNTRY' AND Name = :inContact.OB_Country_Birth__c LIMIT 1 ];
            if ( lovCadastralCode != null && lovCadastralCode.size( ) > 0 )
            {
                inContact.OB_Cadastral_Code__c = lovCadastralCode[ 0 ].NE__Value2__c;
            }
        }
        
        /* ANDREA MORITTU START 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT - REMOVED ADRIAN'S CODE AND PUT IT UNDER PASSAPORTO AND PATENTE  */
        if ( inContact.OB_Document_Release_Date__c > system.today( ) || inContact.OB_Document_Release_Date__c < inContact.OB_Birth_Date__c )
        {
            mandatoryValidationCheck.add( Label.OB_Invalid_Release_Date );
        }
        if ( inContact.OB_Document_Type__c == OB_UtilityConstants.CARTA_DI_IDENTITA )
        {
            Date checkDate = Date.newInstance( 2012, 2, 10 );
            if ( ( inContact.OB_Document_Release_Date__c < checkDate || inContact.OB_Document_Release_Date__c == checkDate )
                    && inContact.OB_Document_Expiration_Date__c != inContact.OB_Document_Release_Date__c.addYears( 10 ).addDays( -1 )

                    || ( inContact.OB_Document_Expiration_Date__c < system.today( ) ) )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidDocumentExpirationDate );
            }
            else if ( inContact.OB_Document_Release_Date__c > checkDate )
            {
                if ( ( ( inContact.OB_Birth_Date__c.month( ) < inContact.OB_Document_Release_Date__c.month( ) ) || ( inContact.OB_Birth_Date__c.month( ) == inContact.OB_Document_Release_Date__c.month( ) && inContact.OB_Birth_Date__c.day( ) < inContact.OB_Document_Release_Date__c.day( ) ) ) && inContact.OB_Document_Expiration_Date__c != Date.newInstance( inContact.OB_Document_Release_Date__c.addYears( 11 ).year( ), inContact.OB_Birth_Date__c.month( ), inContact.OB_Birth_Date__c.day( ) ) )
                {
                    mandatoryValidationCheck.add( Label.OB_InvalidDocumentExpirationDate );
                }
                else if ( ( ( inContact.OB_Birth_Date__c.month( ) > inContact.OB_Document_Release_Date__c.month( ) ) || ( inContact.OB_Birth_Date__c.month( ) == inContact.OB_Document_Release_Date__c.month( ) && inContact.OB_Birth_Date__c.day( ) >= inContact.OB_Document_Release_Date__c.day( ) ) ) && inContact.OB_Document_Expiration_Date__c != Date.newInstance( inContact.OB_Document_Release_Date__c.addYears( 10 ).year( ), inContact.OB_Birth_Date__c.month( ), inContact.OB_Birth_Date__c.day( ) ) )
                {
                    mandatoryValidationCheck.add( Label.OB_InvalidDocumentExpirationDate );
                }
            }

            if ( inContact.OB_Document_Release_Authority__c != OB_UtilityConstants.COMUNE )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidDocumentReleaseAuthority );
            }

             /* ANDREA MORITTU START 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
            if ( inContact.OB_Document_Release_Country_Code__c == 'ITA' && (inContact.OB_Document_Number__c.isAlphaNumeric() == false ) || (inContact.OB_Document_Number__c.length() < 8 || inContact.OB_Document_Number__c.length() > 9 ) )
            {
                
                mandatoryValidationCheck.add( Label.OB_InvalidDocumentNumber );
            }
            /* ANDREA MORITTU END 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
        }
        else if ( inContact.OB_Document_Type__c == OB_UtilityConstants.PASSAPORTO )
        {
            /* ANDREA MORITTU START 04-Dec-2019 - PRODOB_552 - ADDED REMOVED CODE  */
            if ( !docNum.matches( ) || ( inContact.OB_Document_Number__c.length( ) != 10 && inContact.OB_Document_Number__c.length( ) != 9 ) )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidDocumentNumber );
            }
            /* ANDREA MORITTU END 04-Dec-2019 - PRODOB_552 - ADDED REMOVED CODE  */

            if ( inContact.OB_Document_Expiration_Date__c.year( ) != inContact.OB_Document_Release_Date__c.addYears( 10 ).year( ) || ( inContact.OB_Document_Expiration_Date__c != inContact.OB_Document_Release_Date__c.addYears( 10 ).addDays( -1 ) && inContact.OB_Document_Expiration_Date__c != inContact.OB_Document_Release_Date__c.addYears( 10 ) ) || inContact.OB_Document_Expiration_Date__c < system.today( ) )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidDocumentExpirationDate );
            }

            if ( inContact.OB_Document_Release_Authority__c != OB_UtilityConstants.QUESTURA )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidDocumentReleaseAuthority );
            }

            /*ANDREA MORITTU - REMOVED REDUNTANT CODE - FIX */
        }
        else if ( inContact.OB_Document_Type__c == OB_UtilityConstants.PATENTE )
        {
            if ( !docNum.matches( ) || ( inContact.OB_Document_Number__c.length( ) != 10 && inContact.OB_Document_Number__c.length( ) != 9 ) )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidDocumentNumber );
            }
            if ( inContact.OB_Document_Release_Authority__c != OB_UtilityConstants.UCO && inContact.OB_Document_Release_Authority__c != OB_UtilityConstants.MOTORIZZAZIONE && inContact.OB_Document_Release_Authority__c != OB_UtilityConstants.PREFETTURA )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidDocumentReleaseAuthority );
            }
        }
        if ( inContact.OB_Birth_Date__c > system.today( ).addYears( -16 ) || inContact.OB_Birth_Date__c < checkBirthDate )
        {
            mandatoryValidationCheck.add( Label.OB_InvalidBirthDate );
        }

        if ( !String.isEmpty( inContact.OB_Fiscal_Code__c ) && inContact.OB_Fiscal_Code__c.length( ) == 16 )
        {
            String errorCFType = OB_FlowControlUtility.checkNameSurnameCF( inContact.FirstName, inContact.LastName, inContact.OB_Fiscal_Code__c, String.valueOf( inContact.OB_Birth_Date__c ), inContact.OB_Sex__c, inContact.OB_Cadastral_Code__c, inContact.OB_SkipCadastralCodeCheck__c );
            if ( errorCFType == 'errorName' )
            {
                mandatoryValidationCheck.add( Label.OB_InconsistentFiscalCode );
            }
            else if ( errorCFType == 'errorData' )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidFiscalCodeBirthDate );
            }
            else if ( errorCFType == 'errorSurname' )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidFiscalCodeSurname );
            }
            else if ( errorCFType == 'errorGender' )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidFiscalCodeGender );
            }
            else if ( errorCFType == 'errorCadastralCode' )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidFiscalCodeCadastralCode );
            }
            else if ( errorCFType == 'errorLastChar' )
            {
                mandatoryValidationCheck.add( Label.OB_InvalidFiscalCode );
            }
        }
        else
        {
            mandatoryValidationCheck.add( Label.OB_InvalidFiscalCode );
        }
        return String.join( mandatoryValidationCheck, ' , ' );
    }

    /*******************************************************************************
    Purpose:  Class that is output wrapper for save method
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       14/06/2019      Created         NEXI-60
    ********************************************************************************/
    public class SaveOutputWrapper
    {
        @AuraEnabled
        public Boolean isError;
        @AuraEnabled
        public String errorMessage;
        @AuraEnabled
        public String hiddenErrorMessage;

        public SaveOutputWrapper( )
        {
            isError = false;
            errorMessage = '';
            hiddenErrorMessage = '';

        }

        public SaveOutputWrapper( String inError, String inHiddenErrorMessage )
        {
            isError = true;
            errorMessage = inError;
            hiddenErrorMessage = inHiddenErrorMessage;
        }
    }

    /*******************************************************************************
    Purpose:  Method validate if change on contact is good
    Parameters: Contact inOldContact, Contact inNewContact
    Returns: SaveOutputWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       14/06/2019      Created         NEXI-60
    ********************************************************************************/
    @AuraEnabled
    public static SaveOutputWrapper saveRequest( Contact inOldContact, Contact inNewContact )
    {
        try
        {
            User currentUser =
            [
                    SELECT Id,
                            Profile.Userlicense.Name,
                            OB_CAB__c,
                            contact.account.OB_ABI__c,
                            OB_ABI__c
                    FROM User
                    WHERE Id = :userinfo.getuserid( )
            ];
            List<String> mandatoryFormalCheck = mandatoryFieldsCheck( inNewContact );
            Map<String, String> contactApiToLabel = retrieveContactSchemaInformation( );
            if ( mandatoryFormalCheck.size( ) >= 1 )
            {
                List<String> errorFieldLabels = new List<String>( );
                for ( String errorField : mandatoryFormalCheck )
                {
                    String label = contactApiToLabel.get( errorField.toLowerCase( ) );
                    if ( label != null )
                    {
                        errorFieldLabels.add( label );
                    }
                    else
                    {
                        errorFieldLabels.add( errorField );
                    }
                }
                return new SaveOutputWrapper( Label.MandatoryField + '  [' + String.join( errorFieldLabels, ' , ' ) + ']', ' Required Fields Check failed' );
            }

            String mandatoryValidationCheckErrors = checkValidationCont( inNewContact );
            if ( !String.isBlank( mandatoryValidationCheckErrors ) )
            {
                return new SaveOutputWrapper( mandatoryValidationCheckErrors, ' Mandatory Validation Checks failed' );
            }

            if ( !OB_Util006_MaintenanceAnagrafica.checkContactIsAfterModification( inOldContact, inNewContact ) )
            {
                return new SaveOutputWrapper( Label.OB_MAINTENANCE_ERROR_NODATACHANGE, Label.OB_MAINTENANCE_ERROR_NODATACHANGE );
            }
        } catch ( Exception ex )
        {
            String hiddenMessage = '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( );
            System.debug( LoggingLevel.ERROR, hiddenMessage );
            return new SaveOutputWrapper( Label.OB_ServerLogicFailed, hiddenMessage );
        }
        return new SaveOutputWrapper( );
    }
}