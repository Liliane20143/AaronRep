/*****************************************************************
Name:  OB_MandatoryFormalCheck

============================================================
Purpose:    check input control                                                                                                                   
============================================================
History                                                            
-------                                                            
VERSION  AUTHOR              DATE             DETAIL          Description
1.0      Giovanni spinelli   05/09/2018       Created          CSR: 
*****************************************************************/


global without sharing class OB_MandatoryFormalCheck
{

    /*******************************************************************************
    Purpose:  Method checks the correctness of data due to given step

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0		    Giovanni Spinelli		 05/09/2018		 Created		  -
    2.0         Joanna Mielczarek        24/04/2019      Updated         removed unnecessary comments and formatted code
    ********************************************************************************/
    global static Map<String, String> inputCheck( Map<String, Object> data, String step )
    {

        Map<String, String> errorMap = new Map<String, String>( );
        Boolean isError = false; //BOOLEAN TO SET THE ERROR MESSAGE
        System.debug( '1) into inputCheck method' );
        Map<String, Map<String, String>> objectDataMapInput = new Map<String, Map<String, String>>( );
        Map<String, Object> bankProfileMap = new Map<String, Object>( );//giovanni spinelli
        Map<String, Object> merchantMap = ( Map<String, Object> ) data.get( 'merchant' ); // NEXI-278 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 just moved to top
        if ( step == 'identifyCompany' )
        {
            //GET THE NODE PV AND AFTER VALUATE THE COUNTRY VALUE--GIOVANNI SPINELLI--26/09/2018
            Map<String, Object> servicePointMap = ( Map<String, Object> ) data.get( 'pv' );
            bankProfileMap = ( Map<String, Object> ) data.get( 'bankProfile' );//giovanni spinelli
            Boolean checkBoxNDGBool = bankProfileMap.get( 'OB_NDG__c' ) == null ? false : Boolean.valueOf( bankProfileMap.get( 'OB_NDG__c' ) );//NEXI-276 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/08/2019

            Object countryValue = servicePointMap.get( 'NE__Country__c' );
            objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAP;
            //VALUATE IF THE COUNTRY ISN'T ITALY, DELETE 'SERVICEPOINT' FROM COSTANT MAP--GIOVANNI SPINELLI--26/09/2018
            Map<String, String> servicePointEEValue = objectDataMapInput.get( 'pvee' );
            if ( servicePointEEValue != null )
            {
                if ( countryValue != 'ITALIA' )
                {
                    objectDataMapInput.put( 'pv', servicePointEEValue );
                }

                objectDataMapInput.remove( 'pvee' );
            }

            if ( !checkBoxNDGBool )
            {
                Map<String, String> orderHeaderMap = objectDataMapInput.get( 'OrderHeader' );
                system.debug( 'headerMap' + JSON.serialize( orderHeaderMap ) );
                orderHeaderMap.remove( 'OB_NDG__c' );
                objectDataMapInput.put( 'OrderHeader', orderHeaderMap );
            }

            system.debug( 'Check OB_VAT_Not_Present__c ' + merchantMap.get( 'OB_VAT_Not_Present__c' ) );
            //ANDREA MORITTU END 23-Jul-19 WN-178 - Fix length of fiscal code
            String merchantVAT = String.valueOf( merchantMap.get( 'OB_VAT_Not_Present__c' ) );
            //ANDREA MORITTU END 23-Jul-19 WN-178 - Fix length of fiscal code
            Boolean vatNotPresent = false;

            if ( merchantMap.get( 'OB_VAT_Not_Present__c' ) != null )
            {
                vatNotPresent = Boolean.valueOf( merchantMap.get( 'OB_VAT_Not_Present__c' ) );
            }

            Map<String, String> tmpMap = objectDataMapInput.get( 'merchant' );
            //ANDREA MORITTU END 23-Jul-19 WN-178 - Fix length of fiscal code
            if ( !String.isBlank( merchantVAT ) )
            {
                if ( merchantVAT.length( ) == 11 && merchantVAT.isNumeric( ) )
                {
                    tmpMap.remove( 'NE__VAT__c' );
                }
                else
                {
                    tmpMap.put( 'NE__VAT__c', 'ERROR' );
                }
            }
            //ANDREA MORITTU END 23-Jul-19 WN-178 - Fix length of fiscal code
            if ( vatNotPresent )
            {
                tmpMap.remove( 'NE__VAT__c' );
            }
            else
            {
                tmpMap.remove( 'OB_DescriptionVATNotPresent__c' );
            }
            objectDataMapInput.put( 'merchant', tmpMap );

        }
        else if ( step == 'companyData' )
        {
            Map<String, Object> legaleRappMap = ( Map<String, Object> ) data.get( 'legale_rappresentante' );
            Map<String, Object> merchantObjectMap = ( Map<String, Object> ) data.get( 'merchant' );

            objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA;
            Map<String, String> esecutoreEEValue = objectDataMapInput.get( 'legale_rappresentanteee' );
            Map<String, String> esecutoreValue = objectDataMapInput.get( 'legale_rappresentante' );
            Map<String, String> merchantValue = objectDataMapInput.get( 'merchant' );
            if ( esecutoreEEValue != null )
            {
                Object countryValueBirth = legaleRappMap.get( 'OB_Country_Birth__c' );
                Object countryValueDoc = legaleRappMap.get( 'OB_Document_Release_Country__c' );
                Object countryValueFull = legaleRappMap.get( 'OB_Address_Country__c' );
                if ( countryValueBirth != 'ITALIA' )
                {
                    esecutoreValue.remove( 'OB_Birth_State__c' );
                    esecutoreValue.put( 'OB_Birth_City__c', esecutoreEEValue.get( 'OB_Birth_City__c' ) );
                }
                if ( countryValueDoc != 'ITALIA' )
                {
                    esecutoreValue.remove( 'OB_Document_Release_State__c' );
                    esecutoreValue.put( 'OB_Document_Release_City__c', esecutoreEEValue.get( 'OB_Document_Release_City__c' ) );
                }
                if ( countryValueFull != 'ITALIA' )
                {
                    esecutoreValue.remove( 'OB_Address_State__c' );
                    esecutoreValue.put( 'OB_Address_City__c', esecutoreEEValue.get( 'OB_Address_City__c' ) );
                    esecutoreValue.put( 'OB_Address_Street__c', esecutoreEEValue.get( 'OB_Address_Street__c' ) );
                    esecutoreValue.put( 'OB_Address_Street_Number__c', esecutoreEEValue.get( 'OB_Address_Street_Number__c' ) );
                }
                if ( merchantObjectMap.get( 'OB_FATECO__c' ) == 'S' )
                {
                    merchantValue.put( 'OB_ATECO__c', 'ATECO' );
                }

                //ANDREA START 15/02/2019 --> check fiscal code contact
                Object legaleRappObjectFiscalCode = legaleRappMap.get( 'OB_Fiscal_Code__c' );
                Object legaleRappObjectName = legaleRappMap.get( 'FirstName' );
                Object legaleRappObjectSurname = legaleRappMap.get( 'LastName' );
                Object legaleRappObjectDateBirth = legaleRappMap.get( 'OB_Birth_Date__c' );
                Object legaleRappObjectgender = legaleRappMap.get( 'OB_Sex__c' );
                Object legaleRappObjectcadastralCode = legaleRappMap.get( 'OB_Cadastral_Code__c' );
                Object legaleRappObjectskipCheckCadCode = legaleRappMap.get( 'OB_SkipCadastralCodeCheck__c' );

                String fiscalCodelegaleRappObject = String.valueOf( legaleRappObjectFiscalCode );
                String firstNamelegalRapp = String.valueOf( legaleRappObjectName );
                String lastNameContactlegalRapp = String.valueOf( legaleRappObjectSurname );
                String birthDateContactlegalRapp = String.valueOf( legaleRappObjectDateBirth );
                String genderContactlegalRapp = String.valueOf( legaleRappObjectgender );
                String cadastralCodeContactlegalRapp = String.valueOf( legaleRappObjectcadastralCode );
                String skipCheckCadCodeContactlegalRapp = String.valueOf( legaleRappObjectskipCheckCadCode );

                objectDataMapInput.put( 'legale_rappresentante', esecutoreValue );
                objectDataMapInput.remove( 'legale_rappresentanteee' );
                system.debug( 'objectDataMapInput finale' + objectDataMapInput );
            }

            Boolean isLegalEqualAdm = ( Boolean ) data.get( 'isLegalEqualAdm' );
            if ( isLegalEqualAdm )
            {
                merchantValue.remove( 'OB_Administrative_Office_State__c' );
                merchantValue.remove( 'OB_Administrative_Office_City__c' );
                merchantValue.remove( 'OB_Administrative_Office_Street__c' );
                merchantValue.remove( 'OB_Administrative_Office_Street_number__c' );
                objectDataMapInput.put( 'merchant', merchantValue );
            }
        }
        else if ( step == 'operationalData' )
        {
            Map<String, String> orderHeader = new Map<String, String>( );
            Map<String, String> configuration = new Map<String, String>( );
            objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPOPERATIONALDATA;
            //START gianluigi.virga 17/07/2019 - BACKLOG-110 - Added 'showReportType' condition in the if statement
            if ( data.get( 'reportTypeRO' ) == false && data.get( 'showReportType' ) == true )
            {
                //END gianluigi.virga 17/07/2019 - BACKLOG-110
                orderHeader.put( 'OB_Report_Type__c', 'reportType' );
            }
            if ( data.get( 'prelimVerifCodeRO' ) == false )
            {
                orderHeader.put( 'OB_PreliminaryVerificationCode__c', 'prelimVerifCode' );
            }
            objectDataMapInput.put( 'OrderHeader', orderHeader );
            if ( data.get( 'viewSettMeth' ) == true )
            {
                configuration.put( 'OB_PBSettlementMethod__c', 'setOBPBSettlementMethod' );
            }
            else if ( data.get( 'showPicklistPostpagato' ) == true )
            {
                configuration.put( 'OB_PBSettlementMethod__c', 'postPagatoPick' );
            }
            objectDataMapInput.put( 'Configuration', configuration );
        }
        else if ( step == 'actualOwnerOne' )
        {
            objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPTITOLARE1;
            Map<String, Object> actualOwner1Map = ( Map<String, Object> ) data.get( 'contact1' );

            Map<String, String> actualOwner1EEValue = objectDataMapInput.get( 'contact1EE' );
            Map<String, String> actualOwner1Value = objectDataMapInput.get( 'contact1' );
            if ( actualOwner1Value != null )
            {
                Object countryValueBirth = actualOwner1Map.get( 'OB_Country_Birth__c' );
                Object countryValueDoc = actualOwner1Map.get( 'OB_Document_Release_Country__c' );
                Object countryValueFull = actualOwner1Map.get( 'OB_Address_Country__c' );
                if ( countryValueBirth != 'ITALIA' )
                {
                    actualOwner1Value.remove( 'OB_Birth_State__c' );
                    actualOwner1Value.put( 'OB_Birth_City__c', actualOwner1EEValue.get( 'OB_Birth_City__c' ) );
                }
                if ( countryValueDoc != 'ITALIA' )
                {
                    actualOwner1Value.remove( 'OB_Document_Release_State__c' );
                    actualOwner1Value.put( 'OB_Document_Release_City__c', actualOwner1EEValue.get( 'OB_Document_Release_City__c' ) );
                }
                if ( countryValueFull != 'ITALIA' )
                {
                    actualOwner1Value.remove( 'OB_Address_State__c' );
                    actualOwner1Value.put( 'OB_Address_City__c', actualOwner1EEValue.get( 'OB_Address_City__c' ) );
                    actualOwner1Value.put( 'OB_Address_Street__c', actualOwner1EEValue.get( 'OB_Address_Street__c' ) );
                    actualOwner1Value.put( 'OB_Address_Street_Number__c', actualOwner1EEValue.get( 'OB_Address_Street_Number__c' ) );
                }
                objectDataMapInput.put( 'contact1', actualOwner1Value );
                objectDataMapInput.remove( 'contact1ee' );
            }
        }
        else if ( step == 'actualOwnerTwo' )
        {
            objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPTITOLARE2;
            Map<String, Object> actualOwner2Map = ( Map<String, Object> ) data.get( 'contact2' );

            Map<String, String> actualOwner2EEValue = objectDataMapInput.get( 'contact2EE' );
            Map<String, String> actualOwner2Value = objectDataMapInput.get( 'contact2' );
            // System.debug( 'GET SPEE FROM COSTANT MAP: ' + actualOwner2EEValue );
            if ( actualOwner2Value != null )
            {
                Object countryValueBirth = actualOwner2Map.get( 'OB_Country_Birth__c' );
                Object countryValueDoc = actualOwner2Map.get( 'OB_Document_Release_Country__c' );
                Object countryValueFull = actualOwner2Map.get( 'OB_Address_Country__c' );
                if ( countryValueBirth != 'ITALIA' )
                {
                    actualOwner2Value.remove( 'OB_Birth_State__c' );
                    actualOwner2Value.put( 'OB_Birth_City__c', actualOwner2EEValue.get( 'OB_Birth_City__c' ) );
                }
                if ( countryValueDoc != 'ITALIA' )
                {
                    actualOwner2Value.remove( 'OB_Document_Release_State__c' );
                    actualOwner2Value.put( 'OB_Document_Release_City__c', actualOwner2EEValue.get( 'OB_Document_Release_City__c' ) );
                }
                if ( countryValueFull != 'ITALIA' )
                {
                    actualOwner2Value.remove( 'OB_Address_State__c' );
                    actualOwner2Value.put( 'OB_Address_City__c', actualOwner2EEValue.get( 'OB_Address_City__c' ) );
                    actualOwner2Value.put( 'OB_Address_Street__c', actualOwner2EEValue.get( 'OB_Address_Street__c' ) );
                    actualOwner2Value.put( 'OB_Address_Street_Number__c', actualOwner2EEValue.get( 'OB_Address_Street_Number__c' ) );
                }
                objectDataMapInput.put( 'contact2', actualOwner2Value );
                objectDataMapInput.remove( 'contact2ee' );
                system.debug( 'objectDataMapInput finale' + objectDataMapInput );
            }
        }
        else if ( step == 'actualOwnerThree' )
        {
            objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPTITOLARE3;
            Map<String, Object> actualOwner3Map = ( Map<String, Object> ) data.get( 'contact3' );
            Map<String, String> actualOwner3EEValue = objectDataMapInput.get( 'contact3EE' );
            Map<String, String> actualOwner3Value = objectDataMapInput.get( 'contact3' );
            if ( actualOwner3Value != null )
            {
                Object countryValueBirth = actualOwner3Map.get( 'OB_Country_Birth__c' );
                Object countryValueDoc = actualOwner3Map.get( 'OB_Document_Release_Country__c' );
                Object countryValueFull = actualOwner3Map.get( 'OB_Address_Country__c' );
                if ( countryValueBirth != 'ITALIA' )
                {
                    actualOwner3Value.remove( 'OB_Birth_State__c' );
                    actualOwner3Value.put( 'OB_Birth_City__c', actualOwner3EEValue.get( 'OB_Birth_City__c' ) );
                }
                if ( countryValueDoc != 'ITALIA' )
                {
                    actualOwner3Value.remove( 'OB_Document_Release_State__c' );
                    actualOwner3Value.put( 'OB_Document_Release_City__c', actualOwner3EEValue.get( 'OB_Document_Release_City__c' ) );
                }
                if ( countryValueFull != 'ITALIA' )
                {
                    actualOwner3Value.remove( 'OB_Address_State__c' );
                    actualOwner3Value.put( 'OB_Address_City__c', actualOwner3EEValue.get( 'OB_Address_City__c' ) );
                    actualOwner3Value.put( 'OB_Address_Street__c', actualOwner3EEValue.get( 'OB_Address_Street__c' ) );
                    actualOwner3Value.put( 'OB_Address_Street_Number__c', actualOwner3EEValue.get( 'OB_Address_Street_Number__c' ) );
                }
                objectDataMapInput.put( 'contact3', actualOwner3Value );
                objectDataMapInput.remove( 'contact3ee' );
                system.debug( 'objectDataMapInput finale' + objectDataMapInput );
            }
        }
        else if ( step == 'actualOwnerFour' )
        {
            objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPTITOLARE4;
            Map<String, Object> actualOwner4Map = ( Map<String, Object> ) data.get( 'contact4' );

            Map<String, String> actualOwner4EEValue = objectDataMapInput.get( 'contact4EE' );
            Map<String, String> actualOwner4Value = objectDataMapInput.get( 'contact4' );
            if ( actualOwner4Value != null )
            {
                Object countryValueBirth = actualOwner4Map.get( 'OB_Country_Birth__c' );
                Object countryValueDoc = actualOwner4Map.get( 'OB_Document_Release_Country__c' );
                Object countryValueFull = actualOwner4Map.get( 'OB_Address_Country__c' );
                if ( countryValueBirth != 'ITALIA' )
                {
                    actualOwner4Value.remove( 'OB_Birth_State__c' );
                    actualOwner4Value.put( 'OB_Birth_City__c', actualOwner4EEValue.get( 'OB_Birth_City__c' ) );
                }
                if ( countryValueDoc != 'ITALIA' )
                {
                    actualOwner4Value.remove( 'OB_Document_Release_State__c' );
                    actualOwner4Value.put( 'OB_Document_Release_City__c', actualOwner4EEValue.get( 'OB_Document_Release_City__c' ) );
                }
                if ( countryValueFull != 'ITALIA' )
                {
                    actualOwner4Value.remove( 'OB_Address_State__c' );
                    actualOwner4Value.put( 'OB_Address_City__c', actualOwner4EEValue.get( 'OB_Address_City__c' ) );
                    actualOwner4Value.put( 'OB_Address_Street__c', actualOwner4EEValue.get( 'OB_Address_Street__c' ) );
                    actualOwner4Value.put( 'OB_Address_Street_Number__c', actualOwner4EEValue.get( 'OB_Address_Street_Number__c' ) );
                }
                objectDataMapInput.put( 'contact4', actualOwner4Value );
                objectDataMapInput.remove( 'contact4ee' );
                system.debug( 'objectDataMapInput finale' + objectDataMapInput );
            }
        }
        else if ( step == 'actualOwnerFive' )
        {
            objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPTITOLARE5;
            Map<String, Object> actualOwner5Map = ( Map<String, Object> ) data.get( 'contact5' );

            Map<String, String> actualOwner5EEValue = objectDataMapInput.get( 'contact5EE' );
            Map<String, String> actualOwner5Value = objectDataMapInput.get( 'contact5' );
            System.debug( 'GET SPEE FROM COSTANT MAP: ' + actualOwner5Map );
            if ( actualOwner5Value != null )
            {
                Object countryValueBirth = actualOwner5Map.get( 'OB_Country_Birth__c' );
                Object countryValueDoc = actualOwner5Map.get( 'OB_Document_Release_Country__c' );
                Object countryValueFull = actualOwner5Map.get( 'OB_Address_Country__c' );
                if ( countryValueBirth != 'ITALIA' )
                {
                    actualOwner5Value.remove( 'OB_Birth_State__c' );
                    actualOwner5Value.put( 'OB_Birth_City__c', actualOwner5EEValue.get( 'OB_Birth_City__c' ) );
                }
                if ( countryValueDoc != 'ITALIA' )
                {
                    actualOwner5Value.remove( 'OB_Document_Release_State__c' );
                    actualOwner5Value.put( 'OB_Document_Release_City__c', actualOwner5EEValue.get( 'OB_Document_Release_City__c' ) );
                }
                if ( countryValueFull != 'ITALIA' )
                {
                    actualOwner5Value.remove( 'OB_Address_State__c' );
                    actualOwner5Value.put( 'OB_Address_City__c', actualOwner5EEValue.get( 'OB_Address_City__c' ) );
                    actualOwner5Value.put( 'OB_Address_Street__c', actualOwner5EEValue.get( 'OB_Address_Street__c' ) );
                    actualOwner5Value.put( 'OB_Address_Street_Number__c', actualOwner5EEValue.get( 'OB_Address_Street_Number__c' ) );
                }
                objectDataMapInput.put( 'contact5', actualOwner5Value );
                objectDataMapInput.remove( 'contact5ee' );
                system.debug( 'objectDataMapInput finale' + objectDataMapInput );
            }
        }
        else if ( step == 'actualOwnerSix' )
        {
            objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPTITOLARE6;
            Map<String, Object> actualOwner6Map = ( Map<String, Object> ) data.get( 'contact6' );
            Map<String, String> actualOwner6EEValue = objectDataMapInput.get( 'contact6EE' );
            Map<String, String> actualOwner6Value = objectDataMapInput.get( 'contact6' );
            System.debug( 'GET SPEE FROM COSTANT MAP: ' + actualOwner6EEValue );
            if ( actualOwner6Value != null )
            {
                Object countryValueBirth = actualOwner6Map.get( 'OB_Country_Birth__c' );
                Object countryValueDoc = actualOwner6Map.get( 'OB_Document_Release_Country__c' );
                Object countryValueFull = actualOwner6Map.get( 'OB_Address_Country__c' );
                if ( countryValueBirth != 'ITALIA' )
                {
                    actualOwner6Value.remove( 'OB_Birth_State__c' );
                    actualOwner6Value.put( 'OB_Birth_City__c', actualOwner6EEValue.get( 'OB_Birth_City__c' ) );
                }
                if ( countryValueDoc != 'ITALIA' )
                {
                    actualOwner6Value.remove( 'OB_Document_Release_State__c' );
                    actualOwner6Value.put( 'OB_Document_Release_City__c', actualOwner6EEValue.get( 'OB_Document_Release_City__c' ) );
                }
                if ( countryValueFull != 'ITALIA' )
                {
                    actualOwner6Value.remove( 'OB_Address_State__c' );
                    actualOwner6Value.put( 'OB_Address_City__c', actualOwner6EEValue.get( 'OB_Address_City__c' ) );
                    actualOwner6Value.put( 'OB_Address_Street__c', actualOwner6EEValue.get( 'OB_Address_Street__c' ) );
                    actualOwner6Value.put( 'OB_Address_Street_Number__c', actualOwner6EEValue.get( 'OB_Address_Street_Number__c' ) );
                }
                objectDataMapInput.put( 'contact6', actualOwner6Value );
                objectDataMapInput.remove( 'contact6ee' );
                system.debug( 'objectDataMapInput finale' + objectDataMapInput );
            }
        }
        else if ( step == 'servicePoint' )
        {
            //	START 	micol.ferrari 13/10/2018 - CONSTANTS MAP DEPENDS FROM WHICH FIELDS NEED TO BE MANDATORY INSIDE THE STEP
            Map<String, Object> pvMap = ( Map<String, Object> ) data.get( 'pv' );

            if ( ( ( pvMap.get( 'OB_Break_Start_Time__c' ) != null && pvMap.get( 'OB_Break_End_Time__c' ) == null )
                    ||
                    ( pvMap.get( 'OB_Break_Start_Time__c' ) == null && pvMap.get( 'OB_Break_End_Time__c' ) != null ) )
                    &&
                    ( ( pvMap.get( 'OB_Opening_Time__c' ) != null && pvMap.get( 'OB_Ending_Time__c' ) == null )
                            ||
                            ( pvMap.get( 'OB_Opening_Time__c' ) == null && pvMap.get( 'OB_Ending_Time__c' ) != null ) )
                    )
            {
                objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINT;
            }
            else if ( ( pvMap.get( 'OB_Break_Start_Time__c' ) != null && pvMap.get( 'OB_Break_End_Time__c' ) == null )
                    ||
                    ( pvMap.get( 'OB_Break_Start_Time__c' ) == null && pvMap.get( 'OB_Break_End_Time__c' ) != null )
                    &&
                    ( pvMap.get( 'OB_Opening_Time__c' ) == null && pvMap.get( 'OB_Ending_Time__c' ) == null )
                    )
            {
                objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTBREAKTIME;
            }
            else if ( ( pvMap.get( 'OB_Opening_Time__c' ) != null && pvMap.get( 'OB_Ending_Time__c' ) == null )
                    ||
                    ( pvMap.get( 'OB_Opening_Time__c' ) == null && pvMap.get( 'OB_Ending_Time__c' ) != null )
                    &&
                    ( pvMap.get( 'OB_Break_Start_Time__c' ) == null && pvMap.get( 'OB_Break_End_Time__c' ) == null )
                    )
            {
                objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTOPENING;
            }

            else if ( ( pvMap.get( 'OB_Break_Start_Time__c' ) == null && pvMap.get( 'OB_Break_End_Time__c' ) == null )
                    &&
                    ( pvMap.get( 'OB_Opening_Time__c' ) != null && pvMap.get( 'OB_Ending_Time__c' ) != null )
                    )
            {
                objectDataMapInput = OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTOPENING;
            }

            System.debug( 'SERVICEPOINT objectDataMapInput: ' + objectDataMapInput );

            //	END 	micol.ferrari 13/10/2018 - CONSTANTS MAP DEPENDS FROM WHICH FIELDS NEED TO BE MANDATORY INSIDE THE STEP
        }

        //START gianluigi.virga 15/07/2019 - BACKLOG-153
        Boolean mandatoryCheckInDate = false;
        if ( bankProfileMap.get( 'OB_Show_check_in_date__c' ) != null )
        {
            mandatoryCheckInDate = Boolean.valueOf( bankProfileMap.get( 'OB_Show_check_in_date__c' ) );
        }
        System.debug( 'OB_Show_check_in_date__c: ' + mandatoryCheckInDate );
        //END gianluigi.virga

        Boolean vatNotPresent = merchantMap.get( 'OB_VAT_Not_Present__c' ) != null ? Boolean.valueOf( merchantMap.get( 'OB_VAT_Not_Present__c' ) ) : false; // NEXI-278 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019

        //ITERATION IN COSTANT MAP KEY-->GET KEY
        for ( String key : objectDataMapInput.keySet( ) )
        {
            Map<String, String> temporaryMap = objectDataMapInput.get( key );
            //ITERATION IN COSTANT MAP VALUE WITH PREVIOUS KEY-->GET VALUES
            for ( String value : temporaryMap.keySet( ) )
            {
                System.debug( 'value temporaryMap.keySet( ) is:' + value );
                try
                {
                    //GET THE VALUE FROM OBJECTDATAMAP PASSING COSTANT KEY
                    Map<String, Object> mapFromObj = ( Map<String, Object> ) data.get( key );
                    //VALUATE IF THE VALUE IS NULL OR OTHER CONTROLS
                    if ( mapFromObj.get( value ) == null || mapFromObj.get( value ) == '' )
                    {
                        //ACTIVATE THE MESSAGE ERROR
                        isError = true;
                        //if I don't check the vat not present, it deletes the field description vat not present
                        if ( step == 'identifyCompany' )
                        {
                            System.debug( 'the value in temporaryMap is---> ' + temporaryMap.get( key ) );
                            // NEXI-278 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 START check for vat presence
                            if ( vatNotPresent )
                            {
                                temporaryMap.remove( 'NE__VAT__c' );
                            }
                            else
                            {
                                temporaryMap.remove( 'OB_DescriptionVATNotPresent__c' );
                            }
                            // NEXI-278 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 STOP
                            //START gianluigi.virga 15/07/2019 - BACKLOG-153
                            if ( mandatoryCheckInDate != true )
                            {
                                temporaryMap.remove( 'OB_Check_in_date__c' );
                                System.debug( 'the value in temporaryMap (CheckInDate) is---> ' + temporaryMap.get( key ) );
                            }
                            //END gianluigi.virga
                        }

                        String mandatoryField = Label.MandatoryField;
                        // START - 2019/05/14 - elena.preteni
                        if ( temporaryMap.get( value ) != null )
                        {
                            errorMap.put( temporaryMap.get( value ), mandatoryField );
                        }
                        // END - 2019/05/14 - elena.preteni
                        System.debug( 'errorMap---> ' + errorMap );
                    }

                } catch ( Exception e )
                {
                    System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
                }
            }
        }
        return errorMap;
    }
}